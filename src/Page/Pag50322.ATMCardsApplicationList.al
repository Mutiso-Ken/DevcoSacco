#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50322 "ATM Cards Application List"
{
    ApplicationArea = Basic;
    CardPageID = "ATM Applications Card";
    DeleteAllowed = true;
    Editable = false;
    PageType = List;
    SourceTable = "ATM Card Applications";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                Editable = false;
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Address 1"; Rec."Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Address 3"; Rec."Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Address 4"; Rec."Address 4")
                {
                    ApplicationArea = Basic;
                }
                field("Address 5"; Rec."Address 5")
                {
                    ApplicationArea = Basic;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = Basic;
                }
                field("Relation Indicator"; Rec."Relation Indicator")
                {
                    ApplicationArea = Basic;
                }
                field("Card Type"; Rec."Card Type")
                {
                    ApplicationArea = Basic;
                }
                field("Request Type"; Rec."Request Type")
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

