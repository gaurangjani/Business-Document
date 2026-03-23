namespace DefaultPublisher;

using Microsoft.Purchases.Document;

pageextension 50315 "Purchase Invoice Copilot Ext" extends "Purchase Invoice"
{
    actions
    {
        addLast(Prompting)
        {
            action(GenerateWithCopilot)
            {
                Caption = 'Generate with Copilot';
                Image = Sparkle;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocumentGenerationDialog: Page "Document Generation Dialog";
                begin
                    DocumentGenerationDialog.SetPurchaseContext(Rec, Enum::"Document Template Type"::"Purchase Invoice");
                    DocumentGenerationDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
