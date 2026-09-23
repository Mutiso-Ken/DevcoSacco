Page 50084 "Tea Processing Lines"
{
    ApplicationArea = All;
    Caption = 'Tea Processing Lines';
    PageType = List;
    SourceTable = "Periodics Processing Lines";
    UsageCategory = Lists;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                }
                field("Grower No"; Rec."Grower No")
                {
                }
                field("Account No"; Rec."Account No")
                {
                }
                field("Member No"; Rec."Member No")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("No. Of Counts"; Rec."No. Of Counts")
                {
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                }
            }
        }
    }
}
