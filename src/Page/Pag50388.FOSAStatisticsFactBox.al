#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50388 "FOSA Statistics FactBox"
{
    Caption = 'FOSA Statistics FactBox';
    Editable = false;
    PageType = CardPart;
    SaveValues = true;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group("Member Picture")
            {
                field(Image; Rec.Image)
                {
                    ApplicationArea = Basic;
                    Caption = 'Picture';
                }
            }

            group("Account Statistics FactBox")
            {
                Caption = 'Account Statistics FactBox';


                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Book Balance';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("""Account Balance""-(""Uncleared Cheques""+""ATM Transactions""+""EFT Transactions""+MinBalance+1100)"; Rec."Account Balance" - (Rec."Uncleared Cheques" + Rec."ATM Transactions" + Rec."EFT Transactions" + MinBalance + 1100))
                {
                    ApplicationArea = Basic;
                    Caption = 'Withdrawable Balance';
                    Editable = false;
                    Style = Unfavorable;

                }
                field("Uncleared Cheques"; Rec."Uncleared Cheques")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Total Outstanding Overdraft"; Rec."Total Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Total Outstanding Okoa"; Rec."Total Outstanding Okoa")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Outstanding FOSA Loan"; Rec."Outstanding FOSA Loan")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                    Visible = false;
                    Caption = 'Outstanding FOSA Loans';
                }
                field("Outstanding FOSA Interest"; Rec."Outstanding FOSA Interest")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }

            group("Member Signature")
            {
                field(Signature; Rec.Signature)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signature';
                }
            }
        }



    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        LoansRegisterTable: Record "Loans Register";
    begin
        Rec.CalcFields("Outstanding Overdraft", Balance);
        AdjustmentAmount := 0;
        if ((Rec.Balance < 1090) and (Rec.Balance > 0)) then begin
            AdjustmentAmount := 1090 - Rec.Balance;
        end;
        if Rec.Balance < 0 then begin
            AdjustmentAmount := 1090 + Abs(Rec.Balance);
        end;

    end;

    trigger OnOpenPage()
    begin

    end;

    var
        LatestCustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry: array[4] of Record "Cust. Ledger Entry";
        AgingTitle: array[4] of Text[30];
        AgingPeriod: DateFormula;
        I: Integer;
        PeriodStart: Date;
        PeriodEnd: Date;
        Text002: label 'Not Yet Due';
        Text003: label 'Over %1 Days';
        Text004: label '%1-%2 Days';
        MinBalance: Decimal;
        AvaialableOD: Decimal;
        AdjustmentAmount: Decimal;


    procedure CalculateAgingForPeriod(PeriodBeginDate: Date; PeriodEndDate: Date; Index: Integer)
    var
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        NumDaysToBegin: Integer;
        NumDaysToEnd: Integer;
    begin
    end;


    procedure CalculateAging()
    begin

    end;


    procedure GetLatestPayment()
    begin

    end;


    procedure ChangeCustomer()
    begin

    end;


    procedure DrillDown(Index: Integer)
    begin
        if Index = 0 then
            Page.RunModal(Page::"Customer Ledger Entries", LatestCustLedgerEntry)
        else
            Page.RunModal(Page::"Customer Ledger Entries", CustLedgerEntry[Index]);
    end;

    var
        OutstandingOverdraft: Decimal;
}

