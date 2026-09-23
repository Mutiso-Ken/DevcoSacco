#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50902 "Transaction Schedule"
{
    PageType = ListPart;
    SourceTable = "Transaction Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Bosa Account No"; Rec."Bosa Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("EFT Amount"; Rec."EFT Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Deductions"; Rec."Loan Deductions")
                {
                    ApplicationArea = Basic;
                }
                field("Amount-""EFT Amount"""; Rec.Amount - Rec."EFT Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Fee';
                }
            }
        }
    }

    actions
    {
    }
}

