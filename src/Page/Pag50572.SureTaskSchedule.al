#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50572 "Sure Task Schedule"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Sure Task Schedule";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Task; Rec.Task)
                {
                    ApplicationArea = Basic;
                }
                field("Next Task Date"; Rec."Next Task Date")
                {
                    ApplicationArea = Basic;
                }
                field(frequency; Rec.frequency)
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

