namespace DefaultPublisher;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

codeunit 50310 "Document Generator"
{
    procedure EnsureTemplateDefaults()
    begin
        EnsureSetupExists();
        EnsureTemplate(Enum::"Document Template Type"::"Sales Quote");
        EnsureTemplate(Enum::"Document Template Type"::"Sales Order");
        EnsureTemplate(Enum::"Document Template Type"::"Sales Invoice");
        EnsureTemplate(Enum::"Document Template Type"::"Purchase Order");
        EnsureTemplate(Enum::"Document Template Type"::"Purchase Invoice");
    end;

    procedure GenerateForSalesHeader(SalesHeader: Record "Sales Header"; TemplateType: Enum "Document Template Type"; AdditionalInstructions: Text): Text
    var
        PromptTxt: Text;
        ContextTxt: Text;
    begin
        ContextTxt := BuildSalesContext(SalesHeader);
        PromptTxt := BuildPrompt(TemplateType, ContextTxt, AdditionalInstructions);
        exit(Copilot.Generate(PromptTxt));
    end;

    procedure GenerateForPurchaseHeader(PurchaseHeader: Record "Purchase Header"; TemplateType: Enum "Document Template Type"; AdditionalInstructions: Text): Text
    var
        PromptTxt: Text;
        ContextTxt: Text;
    begin
        ContextTxt := BuildPurchaseContext(PurchaseHeader);
        PromptTxt := BuildPrompt(TemplateType, ContextTxt, AdditionalInstructions);
        exit(Copilot.Generate(PromptTxt));
    end;

    procedure ApplyToSalesHeader(var SalesHeader: Record "Sales Header"; GeneratedText: Text; TemplateType: Enum "Document Template Type")
    begin
        if GeneratedText = '' then
            exit;

        SalesHeader.Validate("Posting Description", CopyStr(GeneratedText, 1, MaxStrLen(SalesHeader."Posting Description")));
        SalesHeader.Modify(true);

        LogAudit(TemplateType, Database::"Sales Header", SalesHeader."No.", GeneratedText);
    end;

    procedure ApplyToPurchaseHeader(var PurchaseHeader: Record "Purchase Header"; GeneratedText: Text; TemplateType: Enum "Document Template Type")
    begin
        if GeneratedText = '' then
            exit;

        PurchaseHeader.Validate("Posting Description", CopyStr(GeneratedText, 1, MaxStrLen(PurchaseHeader."Posting Description")));
        PurchaseHeader.Modify(true);

        LogAudit(TemplateType, Database::"Purchase Header", PurchaseHeader."No.", GeneratedText);
    end;

    local procedure BuildPrompt(TemplateType: Enum "Document Template Type"; ContextTxt: Text; AdditionalInstructions: Text): Text
    var
        DocGeneratorSetup: Record "Doc. Generator Setup";
        Template: Record "Doc. Template";
        TemplatePrompt: Text;
        GlobalInstructions: Text;
        MaxLength: Integer;
        ToneTxt: Text;
        FinalPrompt: Text;
        PromptFormatLbl: Label '%1\\Context:\\%2\\Tone: %3\\MaxLength: %4\\Additional instructions: %5\\Respond with final business-ready text only.';
    begin
        EnsureSetupExists();

        if DocGeneratorSetup.Get('SETUP') then begin
            GlobalInstructions := DocGeneratorSetup."Global Instructions";
            ToneTxt := Format(DocGeneratorSetup."Default Tone");
            MaxLength := DocGeneratorSetup."Default Max Length";
        end;

        if Template.Get(TemplateType) and Template.Active then begin
            if Template."Prompt Text" <> '' then
                TemplatePrompt := Template."Prompt Text";

            if Format(Template.Tone) <> '' then
                ToneTxt := Format(Template.Tone);

            if Template."Max Length" > 0 then
                MaxLength := Template."Max Length";
        end;

        if TemplatePrompt = '' then
            TemplatePrompt := GetDefaultTemplatePrompt(TemplateType);

        if ToneTxt = '' then
            ToneTxt := 'Professional';

        if MaxLength = 0 then
            MaxLength := 800;

        FinalPrompt := StrSubstNo(PromptFormatLbl, GlobalInstructions + '\\' + TemplatePrompt, ContextTxt, ToneTxt, MaxLength, AdditionalInstructions);
        exit(FinalPrompt);
    end;

    local procedure BuildSalesContext(SalesHeader: Record "Sales Header"): Text
    var
        ContextLbl: Label 'Document No: %1\\Document Type: %2\\Customer No: %3\\Customer Name: %4\\Currency: %5\\Requested Delivery Date: %6\\Current Posting Description: %7';
    begin
        exit(StrSubstNo(
            ContextLbl,
            SalesHeader."No.",
            Format(SalesHeader."Document Type"),
            SalesHeader."Sell-to Customer No.",
            SalesHeader."Sell-to Customer Name",
            SalesHeader."Currency Code",
            Format(SalesHeader."Requested Delivery Date"),
            SalesHeader."Posting Description"));
    end;

    local procedure BuildPurchaseContext(PurchaseHeader: Record "Purchase Header"): Text
    var
        ContextLbl: Label 'Document No: %1\\Document Type: %2\\Vendor No: %3\\Vendor Name: %4\\Currency: %5\\Requested Receipt Date: %6\\Current Posting Description: %7';
    begin
        exit(StrSubstNo(
            ContextLbl,
            PurchaseHeader."No.",
            Format(PurchaseHeader."Document Type"),
            PurchaseHeader."Buy-from Vendor No.",
            PurchaseHeader."Buy-from Vendor Name",
            PurchaseHeader."Currency Code",
            Format(PurchaseHeader."Requested Receipt Date"),
            PurchaseHeader."Posting Description"));
    end;

    local procedure EnsureSetupExists()
    var
        DocGeneratorSetup: Record "Doc. Generator Setup";
    begin
        if DocGeneratorSetup.Get('SETUP') then
            exit;

        DocGeneratorSetup.Init();
        DocGeneratorSetup."Primary Key" := 'SETUP';
        DocGeneratorSetup.Insert(true);
    end;

    local procedure EnsureTemplate(TemplateType: Enum "Document Template Type")
    var
        Template: Record "Doc. Template";
    begin
        if Template.Get(TemplateType) then
            exit;

        Template.Init();
        Template."Document Type" := TemplateType;
        Template."Template Name" := Format(TemplateType);
        Template."Prompt Text" := GetDefaultTemplatePrompt(TemplateType);
        Template.Tone := Template.Tone::Professional;
        Template."Max Length" := 800;
        Template.Active := true;
        Template.Insert(true);
    end;

    local procedure GetDefaultTemplatePrompt(TemplateType: Enum "Document Template Type"): Text
    begin
        case TemplateType of
            TemplateType::"Sales Quote":
                exit('Generate a concise and professional sales quote summary with clear scope and assumptions.');
            TemplateType::"Sales Order":
                exit('Generate a clear sales order summary including delivery expectations and customer-facing language.');
            TemplateType::"Sales Invoice":
                exit('Generate a professional invoice description with concise billing context.');
            TemplateType::"Purchase Order":
                exit('Generate a clear purchase order description for internal and vendor communication.');
            TemplateType::"Purchase Invoice":
                exit('Generate a concise purchase invoice summary suitable for accounting review.');
        end;

        exit('Generate professional business document text.');
    end;

    local procedure LogAudit(TemplateType: Enum "Document Template Type"; SourceTableNo: Integer; DocumentNo: Code[20]; GeneratedText: Text)
    var
        Audit: Record "Doc. Generation Audit";
    begin
        Audit.Init();
        Audit."Created At" := CurrentDateTime();
        Audit."Created By" := CopyStr(UserId(), 1, MaxStrLen(Audit."Created By"));
        Audit."Document Type" := TemplateType;
        Audit."Source Table No." := SourceTableNo;
        Audit."Document No." := DocumentNo;
        Audit."Generated Text" := CopyStr(GeneratedText, 1, MaxStrLen(Audit."Generated Text"));
        Audit.Insert(true);
    end;

    var
        Copilot: Codeunit "Copilot";
}
