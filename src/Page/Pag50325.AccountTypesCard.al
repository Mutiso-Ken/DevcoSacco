#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50325 "Account Types Card"
{
    Editable = true;
    PageType = Card;
    SourceTable = "Account Types-Saving Products";

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
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Account No Prefix"; Rec."Account No Prefix")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account No. Format';
                    Editable = true;
                }
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Branc';
                    Editable = true;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'Noseries';
                    Editable = true;
                }
                field("Ending Series"; Rec."Ending Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'EndSeries';
                    Editable = true;
                }
                field("SMS Description"; Rec."SMS Description")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                    Editable = true;
                }
                field("Dormancy Period (M)"; Rec."Dormancy Period (M)")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Interval"; Rec."Withdrawal Interval")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Penalty"; Rec."Withdrawal Penalty")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Interval Account"; Rec."Withdrawal Interval Account")
                {
                    ApplicationArea = Basic;
                }
                field("Requires Opening Deposit"; Rec."Requires Opening Deposit")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Loan Applications"; Rec."Allow Loan Applications")
                {
                    ApplicationArea = Basic;
                }
                field("Use Savings Account Number"; Rec."Use Savings Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Deposit"; Rec."Fixed Deposit")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Balance"; Rec."Minimum Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Standing Orders Suspense"; Rec."Standing Orders Suspense")
                {
                    ApplicationArea = Basic;
                }
                field("Bankers Cheque Account"; Rec."Bankers Cheque Account")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Withdrawal Amount"; Rec."Maximum Withdrawal Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Allowable Deposit"; Rec."Maximum Allowable Deposit")
                {
                    ApplicationArea = Basic;
                }
                field("Check Off Recovery"; Rec."Check Off Recovery")
                {
                    ApplicationArea = Basic;
                }
                field("Recovery Priority"; Rec."Recovery Priority")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Multiple Accounts"; Rec."Allow Multiple Accounts")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Interest Computation")
            {
                Caption = 'Interest Computation';
                field("Earns Interest"; Rec."Earns Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Calc Min Balance"; Rec."Interest Calc Min Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest Min. Balance';
                }
                field("Minimum Interest Period (M)"; Rec."Minimum Interest Period (M)")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Expense Account"; Rec."Interest Expense Account")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Payable Account"; Rec."Interest Payable Account")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Forfeited Account"; Rec."Interest Forfeited Account")
                {
                    ApplicationArea = Basic;
                }
                field("Tax On Interest"; Rec."Tax On Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Tax Account"; Rec."Interest Tax Account")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Charges)
            {
                Caption = 'Charges';
                field("Account Openning Fee"; Rec."Account Openning Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Opening Fee';
                }
                field("Account Openning Fee Account"; Rec."Account Openning Fee Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Opening Fee Account';
                }
                field("Re-activation Fee"; Rec."Re-activation Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Re-activation Fee Account"; Rec."Re-activation Fee Account")
                {
                    ApplicationArea = Basic;
                }
                field("Requires Closure Notice"; Rec."Requires Closure Notice")
                {
                    ApplicationArea = Basic;
                }
                field("Closure Notice Period"; Rec."Closure Notice Period")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Charge"; Rec."Closing Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Prior Notice Charge"; Rec."Closing Prior Notice Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Min Bal. Calc Frequency"; Rec."Min Bal. Calc Frequency")
                {
                    ApplicationArea = Basic;
                }
                field("Fee Below Minimum Balance"; Rec."Fee Below Minimum Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Fee bellow Min. Bal. Account"; Rec."Fee bellow Min. Bal. Account")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Charge"; Rec."Overdraft Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Authorised Ovedraft Charge"; Rec."Authorised Ovedraft Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Service Charge"; Rec."Service Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Maintenence Fee"; Rec."Maintenence Fee")
                {
                    ApplicationArea = Basic;
                }
                field("External EFT Charges"; Rec."External EFT Charges")
                {
                    ApplicationArea = Basic;
                }
                field("Internal EFT Charges"; Rec."Internal EFT Charges")
                {
                    ApplicationArea = Basic;
                }
                field("EFT Charges Account"; Rec."EFT Charges Account")
                {
                    ApplicationArea = Basic;
                }
                field("RTGS Charges"; Rec."RTGS Charges")
                {
                    ApplicationArea = Basic;
                }
                field("RTGS Charges Account"; Rec."RTGS Charges Account")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Charge"; Rec."Statement Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Savings Duration"; Rec."Savings Duration")
                {
                    ApplicationArea = Basic;
                }
                field("Savings Withdrawal penalty"; Rec."Savings Withdrawal penalty")
                {
                    ApplicationArea = Basic;
                }
                field("Savings Penalty Account"; Rec."Savings Penalty Account")
                {
                    ApplicationArea = Basic;
                }
                field("FOSA Shares"; Rec."FOSA Shares")
                {
                    ApplicationArea = Basic;
                }
                field("Pass Book"; Rec."Pass Book")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Fee"; Rec."Registration Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Over Draft"; Rec."Allow Over Draft")
                {
                    ApplicationArea = Basic;
                }
                field("Over Draft Interest %"; Rec."Over Draft Interest %")
                {
                    ApplicationArea = Basic;
                }
                field("Over Draft Interest Account"; Rec."Over Draft Interest Account")
                {
                    ApplicationArea = Basic;
                }
                field("Over Draft Issue Charge %"; Rec."Over Draft Issue Charge %")
                {
                    ApplicationArea = Basic;
                }
                field("Over Draft Issue Charge A/C"; Rec."Over Draft Issue Charge A/C")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Multiple Over Draft"; Rec."Allow Multiple Over Draft")
                {
                    ApplicationArea = Basic;
                }
                field("ATM Placing Charge"; Rec."ATM Placing Charge")
                {
                    ApplicationArea = Basic;
                }
                field("ATM Replacement Charge"; Rec."ATM Replacement Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Commission on Placing"; Rec."Commission on Placing")
                {
                    ApplicationArea = Basic;
                }
                field("Commission on Replacement"; Rec."Commission on Replacement")
                {
                    ApplicationArea = Basic;
                }
                field("Comission on ATM Cards A/C"; Rec."Comission on ATM Cards A/C")
                {
                    ApplicationArea = Basic;
                }
                field("ATM Post to Stock"; Rec."ATM Post to Stock")
                {
                    ApplicationArea = Basic;
                }
                field("ATM Bank/GL Account"; Rec."ATM Bank/GL Account")
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

