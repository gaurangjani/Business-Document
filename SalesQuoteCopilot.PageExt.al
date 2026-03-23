namespace DefaultPublisher;

using Microsoft.Sales.Document;

pageextension 50316 "Sales Quote Copilot Ext" extends "Sales Quote"
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
                    DocumentGenerationDialog.SetSalesContext(Rec, Enum::"Document Template Type"::"Sales Quote");
                    DocumentGenerationDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
