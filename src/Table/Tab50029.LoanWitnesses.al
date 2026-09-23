table 50029 "Loan Witness Table"
{
    Caption = 'LoanWitnesses';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Entry; Integer)
        {
            Caption = 'Entry';
            AutoIncrement = true;
        }
        field(2; "Loan Number"; Code[50])
        {
            Caption = 'Loan Number';
        }
        field(3; "Member Number"; Code[50])
        {
            Caption = 'Member Number';
        }
        field(4; "Witness Number"; Code[50])
        {
            Caption = 'Witness Number';

            trigger OnValidate()
            begin
                if customerTable.Get(Rec."Witness Number") then begin
                    Rec."Witness Name" := customerTable.Name;
                    Rec.Modify();
                end;
            end;
        }
        field(7; Status; Option)
        {
            OptionMembers = Requested,Approved,Rejected;
            OptionCaption = 'Requested,Approved,Rejected';
        }
        field(8; "Requested Date"; Date)
        {
            Caption = 'Requested Date';
        }
        field(9; "Approval/Rejection Date"; Date)
        {
            Caption = 'Approval/Rejection Date';
        }
        field(10; OTP; Code[10])
        {
            Caption = 'OTP';
        }
        field(11; "Is OTP Verified"; Boolean)
        {
            Caption = 'Is OTP Verified';
        }
        field(12; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
        }
        field(13; "Witness Name"; Text[100])
        {
            Caption = 'Witness Name';
        }
        field(14; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(15; Comments; Text[2048])
        {
            Caption = 'Comments';
        }
        field(16; "OTP send Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Entry)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if loanRegister.Get("Loan Number") then begin
            "Loan Amount" := loanRegister."Requested Amount";
            "Member Number" := loanRegister."Client Code";
            "Member Name" := loanRegister."Client Name";
        end;
        if customerTable.Get("Witness Number") then begin
            "Witness Name" := customerTable.Name;
        end;
    end;

    trigger OnModify()
    begin
        if loanRegister.Get("Loan Number") then begin
            "Loan Amount" := loanRegister."Requested Amount";
            "Member Number" := loanRegister."Client Code";
            "Member Name" := loanRegister."Client Name";
        end;
        if customerTable.Get("Witness Number") then begin
            "Witness Name" := customerTable.Name;
        end;
    end;

    var
        loanRegister: record "Loans Register";
        customerTable: Record Customer;
}
