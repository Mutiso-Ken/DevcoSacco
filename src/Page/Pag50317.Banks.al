#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50317 "Banks"
{
    // Editable = false;
    PageType = Card;
    SourceTable = Banks;


    layout
    {
        area(content)
        {
            repeater(Control5)
            {
                // field("Code";Code)
                // {
                //     ApplicationArea = Basic;
                // }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                }
                // field(Branch;Branch)
                // {
                //     ApplicationArea = Basic;
                // }

            }
        }
    }

    actions
    {
    }
}

