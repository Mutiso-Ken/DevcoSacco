#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50570 "Cheque Receipt Line-Family"
{
    CardPageID = "Cheque Truncation Card";
    PageType = List;
    SourceTable = "Cheque Issue Lines-Family";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Header No"; Rec."Header No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Cheque Serial No"; Rec."Cheque Serial No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    //editable = false;
                    trigger OnValidate()
                    var
                        cust: record Vendor;
                    begin
                        if cust.get(Rec."Account No.") then begin
                            cust.CalcFields(cust."FOSA Balance");
                            Rec."Account Name" := cust.Name;
                            Rec."Account Balance" := cust."FOSA Balance";
                        end;
                    end;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    editable = false;
                }
                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                    style = Unfavorable;
                    editable = false;
                }
                field("Un pay Code"; Rec."Un pay Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Interpretation; Rec.Interpretation)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Verification Status"; Rec."Verification Status")
                {
                    ApplicationArea = Basic;
                }

                field(FrontImage; Rec.FrontImage)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field(FrontGrayImage; Rec.FrontGrayImage)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field(BackImages; Rec.BackImages)
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Family Account No."; Rec."Family Account No.")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Un Pay Charge Amount"; Rec."Un Pay Charge Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Date _Refference No."; Rec."Date _Refference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Date-1"; Rec."Date-1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Date-2"; Rec."Date-2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Family Routing No."; Rec."Family Routing No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Fillers; Rec.Fillers)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transaction Refference"; Rec."Transaction Refference")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unpay Date"; Rec."Unpay Date")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
                field("Member Branch"; Rec."Member Branch")
                {
                    ApplicationArea = Basic;
                    editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

