#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50898 "Micro_Fin_Schedule"
{
    CardPageID = Micro_Fin_Transactions;
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = Micro_Fin_Schedule;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Number"; Rec."Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Loans No."; Rec."Loans No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan No.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Received From Member';
                    Style = Strong;
                }
                field(Savings; Rec.Savings)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    Caption = 'Savings Amount';
                }
                field("Principle Amount"; Rec."Principle Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Principal Amount';
                    Style = Unfavorable;
                }

                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Interest Amount';
                    Style = Unfavorable;
                }
                field("Expected Principle Amount"; Rec."Expected Principle Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Principle';
                }
                field("Expected Interest"; Rec."Expected Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Interest';
                }
                field("Excess Amount"; Rec."Excess Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

}

