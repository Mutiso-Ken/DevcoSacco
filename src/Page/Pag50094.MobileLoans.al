#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50094 "Mobile Loans"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "Mobile Loans";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Batch No"; Rec."Batch No")
                {
                    ApplicationArea = Basic;

                }
                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
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
                field("Sent To Server"; Rec."Sent To Server")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Date Sent To Server"; Rec."Date Sent To Server")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Time Sent To Server"; Rec."Time Sent To Server")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }

                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Telephone No"; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                }
                field("Corporate No"; Rec."Corporate No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Delivery Center"; Rec."Delivery Center")
                {
                    ApplicationArea = Basic;
                }

                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("MPESA Doc No."; Rec."MPESA Doc No.")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = Basic;
                }
                field("Ist Notification"; Rec."Ist Notification")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Notification"; Rec."2nd Notification")
                {
                    ApplicationArea = Basic;
                }
                field("3rd Notification"; Rec."3rd Notification")
                {
                    ApplicationArea = Basic;
                }
                field("Penalty Date"; Rec."Penalty Date")
                {
                    ApplicationArea = Basic;
                }

                field(Recovery; Rec.Recovery)
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

