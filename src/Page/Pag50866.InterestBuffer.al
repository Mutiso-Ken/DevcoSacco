#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50866 "Interest Buffer"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Interest Buffer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Interest Date"; Rec."Interest Date")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Account Matured"; Rec."Account Matured")
                {
                    ApplicationArea = Basic;
                }
                field("Late Interest"; Rec."Late Interest")
                {
                    ApplicationArea = Basic;
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = Basic;
                }
                field("Mark For Deletion"; Rec."Mark For Deletion")
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

