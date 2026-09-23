pageextension 50028 AuditTrail extends "Change Log Entries"
{

    Caption = 'Devco Sacco Audit';
    layout
    {
        modify("Date and Time")
        {
            trigger OnAfterValidate()
            var
                DateTimee: DateTime;
                LoogDate: Date;
            begin
                rec.Find('-');
                repeat
                    DateTimee := Rec."Date and Time";
                    Loogdate := DT2DATE(DateTimee);
                    Rec.Logdate := LoogDate;
                    Rec.Modify();
                until rec.Next = 0;
            end;
        }
        // Add changes to page layout here

        modify("Primary Key Field 1 Value")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Primary Key Field 2 Value")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Primary Key Field 3 Value")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Old Value Local")
        {
            Visible = false;
            Enabled = false;
        }
        modify("New Value Local")
        {
            Visible = false;
            Enabled = false;

        }
        addafter("Date and Time")
        {
            field("Computer Name"; Rec."Computer Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Logdate; Rec.Logdate)
            {
                ApplicationArea = all;
            }
            field("Full Name"; Rec."Full Name")
            {
                ApplicationArea = all;
            }
            field("Client Name"; Rec."Client Name")
            {
                ApplicationArea = all;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {
            Visible = false;
            Enabled = false;

        }
        addafter(Setup)
        {
            action(KLBAuditReport)
            {
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report AuditReport;
                Caption = 'Viwanda System Audit Report';
                ApplicationArea = all;
            }
        }

    }
    trigger OnOpenPage()

    var
        DateTimee: DateTime;
        LoogDate: Date;
        Msg: Label 'The client type that is running in current session is "%1" ';

    begin
        begin
            rec.Find('-');
            repeat
                DateTimee := Rec."Date and Time";
                Loogdate := DT2DATE(DateTimee);
                Rec.Logdate := LoogDate;
                Rec.Modify();
            until rec.Next = 0;
        end;
        begin
            Message(Msg, CurrentClientType);
        end;

    end;

    var
        myInt: Integer;

    procedure GetUserClientName(): Text[100]
    var
        ChangeLogEntry: Record "Change Log Entry";
    begin
        if ChangeLogEntry.Get(Rec."User ID") then
            exit(ChangeLogEntry."Client Name")
        else
            exit('');
    end;

}
