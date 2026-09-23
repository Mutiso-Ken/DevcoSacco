#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50356 "MPESA Applications Approved"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "MPESA Applications";
    SourceTableView = where(Status = const(Approved));
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
                field("Document Serial No"; Rec."Document Serial No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Customer ID No"; Rec."Customer ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Mobile No"; Rec."MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ApplicationArea = Basic;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Sent To Server"; Rec."Sent To Server")
                {
                    ApplicationArea = Basic;
                }
                field("Date Approved"; Rec."Date Approved")
                {
                    ApplicationArea = Basic;
                }
                field("Time Approved"; Rec."Time Approved")
                {
                    ApplicationArea = Basic;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Rejected"; Rec."Date Rejected")
                {
                    ApplicationArea = Basic;
                }
                field("Time Rejected"; Rec."Time Rejected")
                {
                    ApplicationArea = Basic;
                }
                field("Rejected By"; Rec."Rejected By")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Limit Amount"; Rec."Withdrawal Limit Amount")
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

