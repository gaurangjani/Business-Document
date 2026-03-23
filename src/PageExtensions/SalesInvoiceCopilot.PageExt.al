namespace DefaultPublisher;

using Microsoft.Sales.Document;

pageextension 50314 "Sales Invoice Copilot Ext" extends "Sales Invoice"
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
                    DocumentGenerationDialog.SetSalesContext(Rec, Enum::"Document Template Type"::"Sales Invoice");
                    DocumentGenerationDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
