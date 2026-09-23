Page 52314 "Payroll Earnings List."
{
    // version Payroll ManagementV1.0(Surestep Systems)
    ApplicationArea = Basic, Suite;
    Caption = 'Payroll Earnings List';
    UsageCategory = Lists;
    CardPageID = "Payroll Earnings Card.";
    PageType = List;
    SourceTable = "Payroll Transaction Code.";
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
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = All;
                }
                field("Is Formulae"; Rec."Is Formulae")
                {
                    ApplicationArea = All;
                }
                field(Formulae; Rec.Formulae)
                {
                    ApplicationArea = All;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Income;
    end;
}

