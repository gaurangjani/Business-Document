namespace DefaultPublisher;

table 50318 "Doc. Generation Audit"
{
    Caption = 'Document Generation Audit';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Created At"; DateTime)
        {
            Caption = 'Created At';
            DataClassification = SystemMetadata;
        }
        field(20; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(30; "Document Type"; Enum "Document Template Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(40; "Source Table No."; Integer)
        {
            Caption = 'Source Table No.';
            DataClassification = SystemMetadata;
        }
        field(50; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(60; "Generated Text"; Text[2048])
        {
            Caption = 'Generated Text';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Document; "Document Type", "Document No.")
        {
        }
    }
}
