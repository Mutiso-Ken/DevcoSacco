#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50196 "Member Acc. Sign. Card Change"
{
    PageType = Card;
    SourceTable = "Member Acc. Signatories Change";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member No.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Group No.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = Basic;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                }
                field("Must Sign"; Rec."Must Sign")
                {
                    ApplicationArea = Basic;
                }
                field("Must be Present"; Rec."Must be Present")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Limit"; Rec."Withdrawal Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile Banking Limit"; Rec."Mobile Banking Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Signed Up For Mobile Banking"; Rec."Signed Up For Mobile Banking")
                {
                    ApplicationArea = Basic;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            // part(Control2; "AC_Signatory Picture-Uploaded")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Picture';
            //     SubPageLink = "Account No" = field("Account No");
            // }
            // part(Control1; "AC_Signatory Sign-Uploaded")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Signature';
            //     SubPageLink = "Account No" = field("Account No");
            // }
        }
    }

    actions
    {
    }
}

