#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50348 "Mpesa Transactions List"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "MPESA Transactions";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(TelephoneNo; Rec.TelephoneNo)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Key Word"; Rec."Key Word")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = Basic;
                }
                field(Messages; Rec.Messages)
                {
                    ApplicationArea = Basic;
                }
                field("Needs Change"; Rec."Needs Change")
                {
                    ApplicationArea = Basic;
                }
                field("Change Transaction No"; Rec."Change Transaction No")
                {
                    ApplicationArea = Basic;
                }
                field("Old Account No"; Rec."Old Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Changed; Rec.Changed)
                {
                    ApplicationArea = Basic;
                }
                field("Date Changed"; Rec."Date Changed")
                {
                    ApplicationArea = Basic;
                }
                field("Time Changed"; Rec."Time Changed")
                {
                    ApplicationArea = Basic;
                }
                field("Changed By"; Rec."Changed By")
                {
                    ApplicationArea = Basic;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                }
                field("Original Account No"; Rec."Original Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

