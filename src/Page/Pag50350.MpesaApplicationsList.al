#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50350 "Mpesa Applications List"
{
    ApplicationArea = Basic;
    CardPageID = "Mpesa Applications";
    DeleteAllowed = false;
    Editable = true;
    PageType = List;
    SourceTable = "MPESA Applications";
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
                }
                field("Customer ID No"; Rec."Customer ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Mobile No"; Rec."MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
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

