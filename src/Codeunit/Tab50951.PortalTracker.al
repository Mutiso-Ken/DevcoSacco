table 50951 "Portal Tracker"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; Description; text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(3; MemberNumber; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; MemberName; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Time; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Interaction Type"; Option)
        {
            OptionCaption = ' ,Login,Balance Check,Statement Retrieval,Logout,Download,Profile Check,Loan Check,Loan Types Check,Sign Up';
            OptionMembers = " ","Login","Balance Check","Statement Retrieval","Logout","Download","Profile Check","Loan Check","Loan Types Check","Sign Up";
        }
        field(8; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;

            trigger OnValidate()
            begin


            end;
        }
    }

    keys
    {
        key(Key1; LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {

    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}