namespace DefaultPublisher;

using Microsoft.Purchases.Document;

pageextension 50313 "Purchase Order Copilot Ext" extends "Purchase Order"
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
                    DocumentGenerationDialog.SetPurchaseContext(Rec, Enum::"Document Template Type"::"Purchase Order");
                    DocumentGenerationDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
