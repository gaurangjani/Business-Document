namespace DefaultPublisher;

page 50304 "Doc. Template Card"
{
    PageType = Card;
    SourceTable = "Doc. Template";
    ApplicationArea = All;
    Caption = 'Document Template';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Template Name"; Rec."Template Name")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
            }
            group(Output)
            {
                Caption = 'Output';

                field(Tone; Rec.Tone)
                {
                    ApplicationArea = All;
                }
                field("Max Length"; Rec."Max Length")
                {
                    ApplicationArea = All;
                }
            }
            group(Prompting)
            {
                Caption = 'Prompting';

                field("Prompt Text"; Rec."Prompt Text")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    InstructionalText = 'Use placeholders like {DocumentNo}, {CustomerName}, {VendorName}, and {LinesHint}.';
                }
            }
        }
    }
}
