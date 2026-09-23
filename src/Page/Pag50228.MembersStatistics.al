#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50228 "Members Statistics"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Shares Retained"; Rec."Shares Retained")
                {
                    ApplicationArea = Basic;
                    Caption = 'Share Capital';
                }
                field("Current Shares"; Rec."Current Shares")
                {
                    ApplicationArea = Basic;
                    Caption = 'Non-withdrawable Deposits';
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Interest';
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Un-allocated Funds"; Rec."Un-allocated Funds")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Fee Paid"; Rec."Registration Fee Paid")
                {
                    ApplicationArea = Basic;
                }

                field("Alpha Savings"; Rec."Alpha Savings")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Likizo Contribution"; Rec."Likizo Contribution")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Holiday Savings';

                }

                field("Junior Savings One"; Rec."Junior Savings One")
                {
                    ApplicationArea = Basic;
                    Editable = false;


                }
                field("Junior Savings Two"; Rec."Junior Savings Two")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Junior Savings Three"; Rec."Junior Savings Three")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Monthly ShareCap Cont."; Rec."Monthly ShareCap Cont.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Share Capital';
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Deposit Contribution';
                }
                field("Holiday Monthly Contribution"; Rec."Holiday Monthly Contribution")
                {
                    ApplicationArea = Basic;
                    Editable = true;


                }
                field("Housing Contribution"; Rec."Investment Monthly Cont")
                {
                    ApplicationArea = Basic;
                    Caption = 'Housing contribution';
                    Editable = true;
                }
                field("Junior Monthly Contribution"; Rec."Junior Monthly Contribution")
                {
                    ApplicationArea = basic;
                }
                field("Alpha Monthly Contribution"; Rec."Alpha Monthly Contribution")
                {
                    ApplicationArea = all;
                }
            }
            part(Control1102755002; "Loans Sub-Page List")
            {
                Editable = false;
                SubPageLink = "Client Code" = field("No.");

            }
        }
    }

    actions
    {
    }
}

