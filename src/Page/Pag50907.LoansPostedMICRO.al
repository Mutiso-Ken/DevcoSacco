#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50907 "Loans Posted-MICRO"
{
    ApplicationArea = Basic;
    CardPageID = "Loan Posted Card - MICRO";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    PageType = List;
    //PageType = ListPart;
    SourceTable = "Loans Register";
    SourceTableView = where(Posted = const(true),
                            Source = const(MICRO));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                }
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA No"; Rec."BOSA No")
                {
                    ApplicationArea = Basic;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Oustanding Interest"; Rec."Oustanding Interest")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = Basic;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Schedule Installments"; Rec."Schedule Installments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Schedule Loan Amount Issued"; Rec."Schedule Loan Amount Issued")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Scheduled Principle Payments"; Rec."Scheduled Principle Payments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Scheduled Interest Payments"; Rec."Scheduled Interest Payments")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Principal Paid"; Rec."Principal Paid")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;

                }
                field("Interest Paid"; Rec."Interest Paid")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Last Pay Date"; Rec."Last Pay Date")
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

