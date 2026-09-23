#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50197 "Due Diligence Measures"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Due Diligence Measures";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Risk Rating Level"; Rec."Risk Rating Level")
                {
                    ApplicationArea = Basic;
                }
                field("Risk Rating Scale"; Rec."Risk Rating Scale")
                {
                    ApplicationArea = Basic;
                }
                field("Due Diligence Type"; Rec."Due Diligence Type")
                {
                    ApplicationArea = Basic;
                }
                field("Due Diligence No"; Rec."Due Diligence No")
                {
                    ApplicationArea = Basic;
                }
                field("Due Diligence Measure"; Rec."Due Diligence Measure")
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

