namespace DefaultPublisher;

page 50303 "Doc. Template List"
{
    PageType = List;
    SourceTable = "Doc. Template";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Document Templates';
    CardPageId = "Doc. Template Card";

    layout
    {
        area(Content)
        {
            repeater(Templates)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Template Name"; Rec."Template Name")
                {
                    ApplicationArea = All;
                }
                field(Tone; Rec.Tone)
                {
                    ApplicationArea = All;
                }
                field("Max Length"; Rec."Max Length")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        DocumentGenerator: Codeunit "Document Generator";
    begin
        DocumentGenerator.EnsureTemplateDefaults();
    end;
}
