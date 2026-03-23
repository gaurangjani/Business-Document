namespace DefaultPublisher;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

page 50305 "Document Generation Dialog"
{
    PageType = PromptDialog;
    Extensible = false;
    IsPreview = true;
    Caption = 'Generate with Copilot';

    layout
    {
        area(Prompt)
        {
            field(AdditionalInstructions; AdditionalInstructions)
            {
                ApplicationArea = All;
                MultiLine = true;
                ShowCaption = false;
                InstructionalText = 'Add optional instructions for this document generation.';
            }
        }

        area(Content)
        {
            field(GeneratedText; GeneratedText)
            {
                ApplicationArea = All;
                MultiLine = true;
                ShowCaption = false;
                Editable = false;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';

                trigger OnAction()
                begin
                    GenerateDocument();
                end;
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';

                trigger OnAction()
                begin
                    GenerateDocument();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Apply';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (CloseAction = CloseAction::OK) and (GeneratedText <> '') then
            ApplyGeneratedText();

        exit(true);
    end;

    procedure SetSalesContext(SalesHeader: Record "Sales Header"; TemplateType: Enum "Document Template Type")
    begin
        SourceKind := SourceKind::Sales;
        SalesHeaderContext := SalesHeader;
        TemplateTypeContext := TemplateType;
    end;

    procedure SetPurchaseContext(PurchaseHeader: Record "Purchase Header"; TemplateType: Enum "Document Template Type")
    begin
        SourceKind := SourceKind::Purchase;
        PurchaseHeaderContext := PurchaseHeader;
        TemplateTypeContext := TemplateType;
    end;

    local procedure GenerateDocument()
    begin
        case SourceKind of
            SourceKind::Sales:
                GeneratedText := DocumentGenerator.GenerateForSalesHeader(SalesHeaderContext, TemplateTypeContext, AdditionalInstructions);
            SourceKind::Purchase:
                GeneratedText := DocumentGenerator.GenerateForPurchaseHeader(PurchaseHeaderContext, TemplateTypeContext, AdditionalInstructions);
        end;
    end;

    local procedure ApplyGeneratedText()
    begin
        case SourceKind of
            SourceKind::Sales:
                DocumentGenerator.ApplyToSalesHeader(SalesHeaderContext, GeneratedText, TemplateTypeContext);
            SourceKind::Purchase:
                DocumentGenerator.ApplyToPurchaseHeader(PurchaseHeaderContext, GeneratedText, TemplateTypeContext);
        end;
    end;

    var
        DocumentGenerator: Codeunit "Document Generator";
        SalesHeaderContext: Record "Sales Header";
        PurchaseHeaderContext: Record "Purchase Header";
        SourceKind: Enum "Doc. Dialog Source Kind";
        TemplateTypeContext: Enum "Document Template Type";
        AdditionalInstructions: Text;
        GeneratedText: Text;
}
