#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50584 "Agent Transactions"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Agent transaction";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;



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
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;



                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Location"; Rec."Transaction Location")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction By"; Rec."Transaction By")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Agent Code"; Rec."Agent Code")
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
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
                field(Messages; Rec.Messages)
                {
                    ApplicationArea = Basic;
                }
                field("Needs Change"; Rec."Needs Change")
                {
                    ApplicationArea = Basic;
                }
                field("Old Account No"; Rec."Old Account No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Changed; Rec.Changed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Date Changed"; Rec."Date Changed")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Time Changed"; Rec."Time Changed")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Changed By"; Rec."Changed By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Original Account No"; Rec."Original Account No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 1 Filter"; Rec."Global Dimension 1 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 2 Filter"; Rec."Global Dimension 2 Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account No 2"; Rec."Account No 2")
                {
                    ApplicationArea = Basic;
                }
                field(CCODE; Rec.CCODE)
                {
                    ApplicationArea = Basic;
                }

                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Id No"; Rec."Id No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(DeviceID; Rec.DeviceID)
                {
                    ApplicationArea = Basic;
                }

            }

        }
    }

    actions
    {

    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Transaction Date");
        Rec.Ascending(false);
    end;

}

