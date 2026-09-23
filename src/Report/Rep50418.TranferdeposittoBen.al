report 50418 "Tranfer deposit to Ben"
{
    ApplicationArea = All;
    Caption = 'Tranfer deposit to Ben';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                PostingDate: Date;
                GenSetup: Record "Sacco General Set-Up";
            begin
                GenSetup.Get();
                PostingDate := GenSetup."GO Live Date";
                Cust.Reset();
                Cust.SetRange(Cust."No.", "No.");
                cust.SetAutoCalcFields(Cust."Benevolent Fund", cust."Current Shares");
                Cust.SetFilter(Cust."Current Shares", '>%1', 3500);
                Cust.SetFilter(Cust."Benevolent Fund", '<%1', 3500);
                Cust.SetFilter(Cust.Status, '<>%1', cust.Status::"Awaiting Exit");
                if cust.FindSet() then begin

                    LineNo := LineNo + 10000;
                    SFactory.FnCreateGnlJournalLine(TemplateName, BatchName, 'Benevolent', LineNo, GenJournalLine."Transaction Type"::"Benevolent Fund",
                    GenJournalLine."Account Type"::Customer, Cust."No.", PostingDate, 3500 * -1, 'BOSA', Cust."No.", 'Benevolent Tranfer from Deposits ', '');

                end
            end;
        }
    }
    var
        Cust: Record Customer;
        SFactory: Codeunit "SURESTEP Factory";
        LineNo: Integer;
        TemplateName: Code[50];
        BatchName: Code[50];
        GenJournalLine: Record "Gen. Journal Line";
}
