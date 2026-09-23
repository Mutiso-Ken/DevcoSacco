#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50497 "Lead list Closed"
{
    CardPageID = "lead card closed";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "General Equiries.";
    SourceTableView = where(Status = const(Resolved));

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

                field("Full Name"; Rec."Member Name")
                {
                    ApplicationArea = Basic;
                }

                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Calling For"; Rec."Calling For")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Lead Status"; Rec."Lead Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Attention;
                }
            }
        }
    }

    actions
    {
    }
}

