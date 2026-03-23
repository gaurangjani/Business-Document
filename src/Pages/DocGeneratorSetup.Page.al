namespace DefaultPublisher;

page 50302 "Doc. Generator Setup"
{
    PageType = Card;
    SourceTable = "Doc. Generator Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Document Generator Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Default Tone"; Rec."Default Tone")
                {
                    ApplicationArea = All;
                }
                field("Default Max Length"; Rec."Default Max Length")
                {
                    ApplicationArea = All;
                }
                field("Allow Line Suggestions"; Rec."Allow Line Suggestions")
                {
                    ApplicationArea = All;
                }
            }
            group(Prompting)
            {
                Caption = 'Prompting';

                field("Global Instructions"; Rec."Global Instructions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    InstructionalText = 'These instructions are added to every prompt sent to Copilot.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Templates)
            {
                Caption = 'Templates';
                ApplicationArea = All;
                Image = Setup;

                trigger OnAction()
                var
                    DocTemplateList: Page "Doc. Template List";
                begin
                    DocTemplateList.Run();
                end;
            }
            action(CopilotConfiguration)
            {
                Caption = 'Azure OpenAI Configuration';
                ApplicationArea = All;
                Image = Setup;

                trigger OnAction()
                var
                    CopilotConfig: Page "Copilot Config";
                begin
                    CopilotConfig.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        DocumentGenerator: Codeunit "Document Generator";
    begin
        EnsureSetup();
        DocumentGenerator.EnsureTemplateDefaults();
    end;

    local procedure EnsureSetup()
    begin
        if Rec.Get('SETUP') then
            exit;

        Rec.Init();
        Rec."Primary Key" := 'SETUP';
        Rec.Insert(true);
    end;
}
