namespace DefaultPublisher;

using Microsoft.Sales.Document;

pageextension 50312 "Sales Order Copilot Ext" extends "Sales Order"
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
                    DocumentGenerationDialog.SetSalesContext(Rec, Enum::"Document Template Type"::"Sales Order");
                    DocumentGenerationDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
