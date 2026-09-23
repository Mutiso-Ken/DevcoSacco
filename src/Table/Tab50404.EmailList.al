
table 50404 "Email Messages"
{
    fields
    {
        field(1; "Entry No"; Integer) { }
        field(2; Source; Code[100]) { }
        field(3; "Email"; Text[100]) { }
        field(4; "Recipient Name"; Text[100]) { }
        field(5; "Date Entered"; Date) { }
        field(6; "Time Entered"; Time) { }
        field(7; "Entered By"; Code[100]) { }
        field(8; "Email Body"; Text[2048]) { }
        field(9; "Email Subject"; Text[250]) { }
        field(10; "Sent To Server"; Option)
        {
            OptionMembers = No,Yes,Failed;
        }
        field(11; "Date Sent"; Date) { }
        field(12; "Time Sent"; Time) { }
        field(13; "Error Message"; Text[250]) { }
        field(14; "Account No"; Code[30]) { }
        field(15; "Loan No"; Code[30]) { }
        field(16; "Notice Type"; Option)
        {
            OptionMembers = "1ST","2ND","3RD";
        }
    }

    keys
    {
        key(PK; "Entry No") { Clustered = true; }
    }
}