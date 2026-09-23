#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50306 "Teller & Treasury Trans List"
{
    ApplicationArea = Basic;
    CardPageID = "Teller & Treasury Trans Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Treasury Transactions";
    UsageCategory = Tasks;
    SourceTableView = where(Issued = const(No), "Transaction Type" = filter('Issue To Teller' | 'Issue From Bank'));

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
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("From Account"; Rec."From Account")
                {
                    ApplicationArea = Basic;
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Received By"; Rec."Received By")
                {


                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
    end;
}

