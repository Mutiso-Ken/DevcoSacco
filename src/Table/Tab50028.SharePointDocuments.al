table 50028 "SharePoint Documents"
{
    Caption = 'SharePoint Documents';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(2; "Document No"; Code[50])
        {
            Caption = 'Document No';
        }
        field(3; "File Name"; Text[1000])
        {
            Caption = 'File Name';
        }
        field(4; Location; Text[2048])
        {
            Caption = 'Location';
        }
        field(5; "File type"; Text[100])
        {
            Caption = 'File type';
        }
    }
    keys
    {
        key(PK; "Entry No", "Document No", "File Name")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Sharepoint2: Record "SharePoint Documents";
    begin
        Sharepoint2.Reset();
        if Sharepoint2.FindLast() then
            "Entry No" := Sharepoint2."Entry No" + 10
        else
            "Entry No" := 1;
    end;
}
