#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50281 "Loan Product Charges"
{
    PageType = List;
    SourceTable = "Loan Product Charges";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Amount2; Rec.Amount2)
                {
                    Caption = 'Loan Drsbursement Fee Above 1M';
                    ApplicationArea = Basic;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                }

                field("Above 1M"; Rec."Above 1M")
                {
                    ApplicationArea = basic;
                }
                field("Use Perc"; Rec."Use Perc")
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

