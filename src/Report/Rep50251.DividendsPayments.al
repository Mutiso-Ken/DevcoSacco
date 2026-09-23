Report 50251 "Dividends Payments"
{
    Caption = 'Dividends Payments';
    ProcessingOnly = true;
    ApplicationArea = all;
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            trigger OnPreDataItem();
            begin



                BATCH_TEMPLATE := 'PAYMENTS';
                BATCH_NAME := 'DIVIDEND';
                DOCUMENT_NO := 'DIV_' + FORMAT(PostingDate);
                ObjGensetup.GET();
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", BATCH_TEMPLATE);
                GenJournalLine.SETRANGE("Journal Batch Name", BATCH_NAME);
                GenJournalLine.DELETEALL;
            end;

            trigger OnAfterGetRecord()
            var
                LoanBalance: Decimal;
            begin
                RunBal := 0;
                LoanBalance := 0;
                Cust.Reset();
                Cust.SetRange(Cust."No.", "No.");
                cust.SetFilter(cust."Retaine Dividends", '%1', false);
                if cust.FindSet() then begin
                    Cust.CalcFields(Cust."Dividend Amount");
                    if cust."Dividend Amount" > 0 then begin
                        repeat
                            ObjGensetup.GET();
                            RunBal := cust."Dividend Amount";

                            LoanRegister.Reset();
                            LoanRegister.SetRange(LoanRegister."Client Code", cust."No.");
                            LoanRegister.SetFilter(LoanRegister."Loan Product Type", 'DIVIDEND ADVANCE');
                            if LoanRegister.FindSet() then begin
                                repeat
                                    LoanRegister.CalcFields(LoanRegister."Outstanding Balance");
                                    if LoanRegister."Outstanding Balance" > 0 then begin
                                        LoanBalance := LoanRegister."Outstanding Balance";
                                        if RunBal > LoanBalance then begin
                                            LineNo := LineNo + 10000;
                                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."Transaction Type"::Repayment, GenJournalLine."Account Type"::Customer,
                                            LoanRegister."Client Code", PostingDate, LoanBalance * -1, 'BOSA', LoanRegister."Loan  No.", 'Loan Payement By Dividends', LoanRegister."Loan  No.");

                                            LineNo := LineNo + 10000;
                                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."Transaction Type"::Dividend, GenJournalLine."Account Type"::Customer,
                                            LoanRegister."Client Code", PostingDate, LoanBalance, 'BOSA', LoanRegister."Loan  No.", 'Loan Payement By Dividends', LoanRegister."Loan  No.");
                                        end;


                                        // LineNo := LineNo + 10000;
                                        // SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."Transaction Type"::Dividend,
                                        // GenJournalLine."Account Type"::Customer, "No.", PostingDate, LoanBalance, 'BOSA', '',
                                        // 'Dividends Payments- ' + FORMAT(PostingDate), '', GenJournalLine."Account Type"::"Bank Account", ObjGensetup."Dividends Paying Bank Account");
                                    end;
                                until LoanRegister.next = 0;
                            end;

                        until Cust.Next = 0;

                    end;


                end;
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                if GenJournalLine.Find('-') then
                    Page.Run(page::"General Journal", GenJournalLine);
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        cust: Record Customer;
        ObjGensetup: Record "Sacco General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_NAME: Code[50];
        BATCH_TEMPLATE: Code[50];

        RunBal: Decimal;
        LoanRegister: Record "Loans Register";
        DOCUMENT_NO: Code[50];
        LineNo: Integer;
        PostingDate: Date;
        DivTotal: Decimal;
}
