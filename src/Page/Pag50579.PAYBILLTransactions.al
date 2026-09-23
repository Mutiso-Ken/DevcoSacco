#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50579 "PAYBILL Transactions"
{
    ApplicationArea = Basic;
    CardPageID = "posted paybills card";
    PageType = List;
    SourceTable = "CloudPESA MPESA Trans";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Sender Name';

                    ApplicationArea = Basic;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    visible = false;
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }

                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Paybill Acc Balance"; Rec."Paybill Acc Balance")
                {
                    ApplicationArea = Basic;
                }

                field("Key Word"; Rec."Key Word")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field("Needs Manual Posting"; Rec."Needs Manual Posting")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
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
    trigger OnOpenPage()
    begin

        Rec.SetCurrentKey("Transaction Date");
        Rec.Ascending(false);

        // if "Account No" <> '' then begin
        //     "Destination Acc" := Accounts.Name;

        // end;
    end;



    var
        Accounts: Record Customer;

}

