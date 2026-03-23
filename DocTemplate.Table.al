namespace DefaultPublisher;

table 50317 "Doc. Template"
{
    Caption = 'Document Template';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Document Template Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(10; "Template Name"; Text[100])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
        }
        field(20; "Prompt Text"; Text[2048])
        {
            Caption = 'Prompt Text';
            DataClassification = CustomerContent;
        }
        field(30; "Tone"; Option)
        {
            Caption = 'Tone';
            OptionMembers = Professional,Friendly,Formal,Concise;
            OptionCaption = 'Professional,Friendly,Formal,Concise';
            DataClassification = CustomerContent;
        }
        field(40; "Max Length"; Integer)
        {
            Caption = 'Max Length';
            DataClassification = CustomerContent;
            MinValue = 100;
            InitValue = 800;
        }
        field(50; "Active"; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Document Type")
        {
            Clustered = true;
        }
    }
}
