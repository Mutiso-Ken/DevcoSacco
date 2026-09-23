#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50578 "SurePESA Applications"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
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


                field(SentToServer; Rec.SentToServer)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pin Reset"; Rec."Pin Reset")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Reset By"; Rec."Reset By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Last PIN Reset"; Rec."Last PIN Reset")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Created By"; Rec."Created By")
                {

                }
                field("Time Applied"; Rec."Time Applied")
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

