page 50090 "Email Messages List"
{
    PageType = List;
    SourceTable = "Email Messages";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; "Entry No") { }
                field("Recipient Name"; "Recipient Name") { }
                field("Email"; Email) { }
                field("Email Subject"; "Email Subject") { }
                 field("Email Body"; "Email Body") { }
                field("Account No"; "Account No") { }
                field("Loan No"; "Loan No") { }
                field("Notice Type"; "Notice Type") { }
                field("Sent To Server"; "Sent To Server") { }
                field("Date Entered"; "Date Entered") { }
                field("Date Sent"; "Date Sent") { }
                field("Error Message"; "Error Message") { }
            }
        }
    }
}

