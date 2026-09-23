#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50581 "SurePESA Appplications List"
{
    ApplicationArea = Basic;
    CardPageID = "SurePESA Applications Card";
    Editable = false;
    PageType = List;
    SourceTable = "SurePESA Applications";
    SourceTableView = sorting("No.") order(descending);
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
                field("Date Applied"; Rec."Date Applied")
                {
                    ApplicationArea = Basic;
                }

                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;

                }
                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = Basic;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;

                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = Basic;
                }

                field("Time Applied"; Rec."Time Applied")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }


}

