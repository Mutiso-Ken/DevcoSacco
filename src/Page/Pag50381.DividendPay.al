report 50381 "Dividend Payment"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                BATCH_TEMPLATE := 'PAYMENTS';
                BATCH_NAME := 'DIV_PAY';
                DOCUMENT_NO := 'DIVPAY_' + FORMAT(PostingDate);

                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", BATCH_TEMPLATE);
                GenJournalLine.SETRANGE("Journal Batch Name", BATCH_NAME);
                GenJournalLine.DELETEALL;
            end;

            trigger OnAfterGetRecord()
            var
                AmountToPay: Decimal;
            begin
                IF Customer."Net Dividend Payable" <= 0 THEN
                    EXIT;

                AmountToPay := Customer."Net Dividend Payable";
                LineNo := LineNo + 10000;

                SFactory.FnCreateGnlJournalLineBalanced(
                    BATCH_TEMPLATE,
                    BATCH_NAME,
                    DOCUMENT_NO,
                    LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::Customer,
                    Customer."No.",
                    PostingDate,
                    AmountToPay,
                    'BOSA',
                    '',
                    'Dividend Payment - ' + FORMAT(PostingDate),
                    '',
                    GenJournalLine."Account Type"::"Bank Account",
                    BankAccountNo
                );

                Customer."Net Dividend Payable" := 0;
                Customer.MODIFY;
            end;

            trigger OnPostDataItem()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", BATCH_TEMPLATE);
                GenJournalLine.SETRANGE("Journal Batch Name", BATCH_NAME);
                IF GenJournalLine.FIND('-') THEN
                    PAGE.RUN(PAGE::"General Journal", GenJournalLine);

                CustLedgEntry.RESET;
                CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                CustLedgEntry.SETFILTER("Remaining Amount", '<>0');
                IF CustLedgEntry.FIND('-') THEN
                    CODEUNIT.RUN(CODEUNIT::"CustEntry-Apply Posted Entries", CustLedgEntry);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                }

                field(BankAccountNo; BankAccountNo)
                {
                    ApplicationArea = All;
                    TableRelation = "Bank Account";
                }
            }
        }
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_TEMPLATE: Code[50];
        BATCH_NAME: Code[50];
        DOCUMENT_NO: Code[50];
        LineNo: Integer;
        PostingDate: Date;
        BankAccountNo: Code[20];
}