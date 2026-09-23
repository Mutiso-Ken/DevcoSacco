#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50374 "BOSA Transfer List"
{
    ApplicationArea = Basic;
    CardPageID = Transfers;
    PageType = List;
    Editable = false;
    DeleteAllowed = true;
    SourceTable = "BOSA Transfers";
    SourceTableView = where(Posted = const(false), Approved = const(false));
    UsageCategory = Tasks;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }

                field("Schedule Total"; Rec."Schedule Total")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;

                }


                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Posted; Rec.Posted)
                {

                }
                field("Captured By"; Rec."Captured By")
                {
                    Style = StrongAccent;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Captured By", UserId);

    end;
}

