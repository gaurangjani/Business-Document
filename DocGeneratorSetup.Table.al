namespace DefaultPublisher;

table 50302 "Doc. Generator Setup"
{
    Caption = 'Document Generator Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Default Tone"; Option)
        {
            Caption = 'Default Tone';
            OptionMembers = Professional,Friendly,Formal,Concise;
            OptionCaption = 'Professional,Friendly,Formal,Concise';
            DataClassification = CustomerContent;
        }
        field(20; "Default Max Length"; Integer)
        {
            Caption = 'Default Max Length';
            DataClassification = CustomerContent;
            MinValue = 100;
            InitValue = 800;
        }
        field(30; "Global Instructions"; Text[2048])
        {
            Caption = 'Global Instructions';
            DataClassification = CustomerContent;
        }
        field(40; "Allow Line Suggestions"; Boolean)
        {
            Caption = 'Allow Line Suggestions';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
