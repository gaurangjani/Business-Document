namespace DefaultPublisher;

enum 50301 "Document Template Type"
{
    Extensible = false;

    value(0; "Sales Quote")
    {
        Caption = 'Sales Quote';
    }
    value(1; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(2; "Sales Invoice")
    {
        Caption = 'Sales Invoice';
    }
    value(3; "Purchase Order")
    {
        Caption = 'Purchase Order';
    }
    value(4; "Purchase Invoice")
    {
        Caption = 'Purchase Invoice';
    }
}
