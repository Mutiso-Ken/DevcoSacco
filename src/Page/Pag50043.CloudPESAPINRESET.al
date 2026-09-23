#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50043 "CloudPESA PIN RESET"
{
    ApplicationArea = Basic;
    CardPageID = "CloudPESA PIN Reset Card";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "SurePESA Applications";
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
                    Visible = false;
                }
                field(SentToServer; Rec.SentToServer)
                {
                    ApplicationArea = Basic;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Reset By"; Rec."Reset By")
                {
                    ApplicationArea = Basic;
                }
                field("Last PIN Reset"; Rec."Last PIN Reset")
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

