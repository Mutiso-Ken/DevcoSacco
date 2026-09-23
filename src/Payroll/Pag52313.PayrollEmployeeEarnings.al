Page 52313 "Payroll Employee Earnings."
{
    // version Payroll ManagementV1.0(Surestep Systems)
    ApplicationArea = Basic, Suite;
    Caption = 'Payroll Employee Earnings.';
    UsageCategory = Lists;
    DeleteAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Payroll Employee Transactions.";
    SourceTableView = WHERE("Transaction Type" = CONST(Income));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                    TableRelation = "Payroll Transaction Code."."Transaction Code" where("Transaction Type" = CONST(Income));
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount(LCY)"; Rec."Amount(LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field("Balance(LCY)"; Rec."Balance(LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Period Month"; Rec."Period Month")
                {
                    ApplicationArea = All;
                }
                field("Period Year"; Rec."Period Year")
                {
                    ApplicationArea = All;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        PayrollCalender.Reset;
        PayrollCalender.SetRange(Closed, false);
        if PayrollCalender.FindFirst then
            Rec.SetRange("Payroll Period", PayrollCalender."Date Opened");
    end;

    var
        PayrollCalender: Record "Payroll Calender.";
}

