#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50589 "Cheque Truncation Card"
{
    PageType = Card;
    SourceTable = "Cheque Issue Lines-Family";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Chq Receipt No"; Rec."Chq Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Serial No"; Rec."Cheque Serial No")
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Refference"; Rec."Transaction Refference")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                }
                field(FrontImage; Rec.FrontImage)
                {
                    ApplicationArea = Basic;
                }
                field(FrontGrayImage; Rec.FrontGrayImage)
                {
                    ApplicationArea = Basic;
                }
                field(BackImages; Rec.BackImages)
                {
                    ApplicationArea = Basic;
                }
                field("Verification Status"; Rec."Verification Status")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000015; "Cheque Trans Verification")
            {
                SubPageLink = "Chq Receipt No" = field("Account No.");
            }
        }
    }

    actions
    {
    }
}

