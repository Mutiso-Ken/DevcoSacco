#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50328 "Transaction Type Card"
{
    PageType = Card;
    SourceTable = "Transaction Types";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Has Schedule"; Rec."Has Schedule")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Category"; Rec."Transaction Category")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Span"; Rec."Transaction Span")
                {
                    ApplicationArea = Basic;
                }
                field("Default Mode"; Rec."Default Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000; "Front Office Charges")
            {
                SubPageLink = "Transaction Type" = field(Code);
            }
        }
    }

    actions
    {
    }
}

