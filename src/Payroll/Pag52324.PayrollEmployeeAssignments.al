page 52324 "Payroll Employee Assignments."
{
    // version Payroll ManagementV1.0(Surestep Systems)

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Employee.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Pays PAYE"; Rec."Pays PAYE")
                {
                    ApplicationArea = All;
                }
                field("Pays NSSF"; Rec."Pays NSSF")
                {
                    ApplicationArea = All;
                }
                field("Pays NHIF"; Rec."Pays NHIF")
                {
                    ApplicationArea = All;
                }
                field(Secondary; Rec.Secondary)
                {
                    ApplicationArea = All;
                }
            }
            group(Numbers)
            {
                field("National ID No"; Rec."National ID No")
                {
                    ApplicationArea = All;
                }
                field("PIN No"; Rec."PIN No")
                {
                    ApplicationArea = All;
                }
                field("NHIF No"; Rec."NHIF No")
                {
                    ApplicationArea = All;
                }
                field("NSSF No"; Rec."NSSF No")
                {
                    ApplicationArea = All;
                }
            }
            group("PAYE Relief and Benefit")
            {
                field(GetsPayeRelief; Rec.GetsPayeRelief)
                {
                    ApplicationArea = All;
                }
                field(GetsPayeBenefit; Rec.GetsPayeBenefit)
                {
                    ApplicationArea = All;
                }
                field(PayeBenefitPercent; Rec.PayeBenefitPercent)
                {
                    ApplicationArea = All;
                }
            }
            group("Employee Company")
            {
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    OptionCaption = '';
                }
            }
        }
    }

    actions
    {
    }
}

