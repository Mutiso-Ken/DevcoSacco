Page 50118 "Member FeedBack Card"
{
    PageType = Card;
    LinksAllowed = true;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member FeedBack";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Type of Feed Back"; Rec."Type of Feed Back")
                {
                    ApplicationArea = all;
                }
                field("Customer FeedBack"; Rec."Customer FeedBack")
                {
                    ApplicationArea = all;
                    Editable = true;
                    MultiLine = true;
                    RowSpan = 10;

                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}