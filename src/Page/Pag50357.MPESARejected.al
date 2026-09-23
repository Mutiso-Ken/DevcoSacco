#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50357 "MPESA Rejected"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "Change MPESA Transactions";
    SourceTableView = where(Status = const(Rejected));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Initiated By"; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Receipt No"; Rec."MPESA Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("New Account No"; Rec."New Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Reasons for rejection"; Rec."Reasons for rejection")
                {
                    ApplicationArea = Basic;
                }
                field("Date Approved"; Rec."Date Approved")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Rejected';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rejected by';
                }
                field("Time Approved"; Rec."Time Approved")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time Rejected';
                }
            }
        }
    }

    actions
    {
    }
}

