#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50829 "Cheques RegisterX"
{
    ApplicationArea = Basic;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cheques Register";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Application Date"; Rec."Application Date")
                {

                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;

                }
                field("Cancelled/Stopped By"; Rec."Cancelled/Stopped By")
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

