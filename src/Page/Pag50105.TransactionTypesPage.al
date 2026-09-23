Page 50105 "Transaction Types Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Types Table";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Posting Group Code"; Rec."Posting Group Code")
                {
                    ApplicationArea = All;

                }
                field("Transaction Type"; Rec."Transaction Type")
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}