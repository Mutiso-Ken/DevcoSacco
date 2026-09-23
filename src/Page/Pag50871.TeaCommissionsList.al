#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50871 "Tea Commissions List"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Tea Commissions";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Lower Bound"; Rec."Lower Bound")
                {
                    ApplicationArea = Basic;
                }
                field("Upper Bound"; Rec."Upper Bound")
                {
                    ApplicationArea = Basic;
                }
                field(Charge; Rec.Charge)
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

