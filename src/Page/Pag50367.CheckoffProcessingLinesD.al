#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50367 "Checkoff Processing Lines-D"
{
    PageType = ListPart;
    SourceTable = "Checkoff Lines-Distributed";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt Header No"; Rec."Receipt Header No")
                {
                    ApplicationArea = Basic;
                }
                field("Staff/Payroll No"; Rec."Staff/Payroll No")
                {
                    ApplicationArea = Basic;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Amount"; Rec."Expected Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Not Found"; Rec."Staff Not Found")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Multiple Receipts"; Rec."Multiple Receipts")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                }
                field("Account type"; Rec."Account type")
                {
                    ApplicationArea = Basic;
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = Basic;
                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = Basic;
                }
                field("Loans Not found"; Rec."Loans Not found")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("No Repayment"; Rec."No Repayment")
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

