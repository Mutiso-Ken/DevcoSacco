report 52010 "Loan repayment Concentration"
{
    UsageCategory = Tasks;
    RDLCLayout = './Layouts/RepaymentConcentrationReport.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = sorting("Staff No") order(ascending) where(Posted = const(true), "Outstanding Balance" = filter(> 0));
            column(No_; "Client Code") { }
            column(Loan__No_; "Loan  No.") { }
            column(Issued_Date; "Issued Date") { }
            column(Name; "Client Name") { }
            column(OpeningBal; OpeningBal) { }
            column(Approved_Amount; "Approved Amount") { }
            column(Repayment; Repayment) { }
            column(Loan_Repayment; "Loan Repayment") { }
            column(jan; jan) { }
            column(feb; feb) { }
            column(mar; mar) { }
            column(apr; apr) { }
            column(may; may) { }
            column(jun; jun) { }
            column(jul; jul) { }
            column(aug; aug) { }
            column(sep; sep) { }
            column(oct; oct) { }
            column(nov; nov) { }
            column(dec; dec) { }
            column(Totals; Totals) { }
            column(TransactionPeriod; TransactionPeriod) { }
            trigger OnAfterGetRecord()
            var

                OpeningBalDate: Date;
                JanDatefilter: Date;
                FebDate: Date;
                LoanReg: Record "Loans Register";
                Julyfilter: Text;


            begin
                OpeningBalDate := CalcDate('<-CY>', Asat);
                OpeningBalDate := CalcDate('<-1D>', CalcDate('<-CY>', Asat));
                TransactionPeriod := Date2DMY(AsAt, 3);
                //Openingbalances
                LoanReg.SetFilter("Date Filter", '..%1', OpeningBalDate);
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    OpeningBal := LoanReg."Outstanding Balance";
                end;

                //Jan
                jan := 0;
                JanDatefilter := CalcDate('1M', OpeningBalDate);
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('CM', JanDatefilter), JanDatefilter);
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    Jan := (MemberLedger."Credit Amount (LCY)");
                end;
                //Feb
                feb := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('1M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('1M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    Feb := (MemberLedger."Credit Amount (LCY)");
                end;


                //March
                mar := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('2M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('2M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    mar := (MemberLedger."Credit Amount (LCY)");
                end;

                //April
                apr := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('3M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('3M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    apr := (MemberLedger."Credit Amount (LCY)");
                end;
                //May
                may := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('4M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('4M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    may := (MemberLedger."Credit Amount (LCY)");
                end;

                //June
                jun := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('5M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('5M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    jun := (MemberLedger."Credit Amount (LCY)");
                end;

                //July
                jul := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('6M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('6M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    jul := (MemberLedger."Credit Amount (LCY)");
                end;



                //Aug
                aug := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('7M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('7M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    aug := (MemberLedger."Credit Amount (LCY)");
                end;
                //Sept
                sep := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('8M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('8M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    sep := (MemberLedger."Credit Amount (LCY)");
                end;
                //Oct
                oct := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('9M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('9M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    oct := (MemberLedger."Credit Amount (LCY)");
                end;
                //Nov
                nov := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('10M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('10M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    nov := (MemberLedger."Credit Amount (LCY)");
                end;
                //Dec
                dec := 0;
                MemberLedger.SetFilter("Posting Date", '%1..%2', CalcDate('1D', CalcDate('11M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('11M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    dec := (MemberLedger."Credit Amount (LCY)");
                end;

                MemberLedger.SetFilter("Posting Date", '..%1', CalcDate('CM', CalcDate('1D', CalcDate('11M', OpeningBalDate))));
                MemberLedger.SetAutoCalcFields(MemberLedger."Credit Amount (LCY)", MemberLedger."Credit Amount");
                MemberLedger.SetRange(MemberLedger."Loan No", LoanReg."Loan  No.");
                MemberLedger.SetFilter(MemberLedger."Transaction Type", '%1', MemberLedger."Transaction Type"::Repayment);
                if MemberLedger.FindSet() then begin
                    Totals := Abs(jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec);

                end;


                // LoanReg.SetFilter("Date Filter", '..%1', CalcDate('CM', CalcDate('1D', CalcDate('11M', OpeningBalDate))));
                // LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                // LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                // if LoanReg.FindSet() then begin
                //     Totals := Abs(jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec);
                // end;

            end;

            trigger OnPreDataItem()
            begin
                // Explicitly set filter at runtime for clarity
                "Loans Register".SetFilter("Outstanding Balance", '>0');
                "Loans Register".SetRange(Posted, true);
            end;
        }

    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {

                field(Asat; Asat)
                {

                }
            }
        }

    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        if Asat = 0D then begin
            Asat := Today;
        end;
    end;


    var
        OpeningBal: Decimal;
        Asat: Date;
        jan: Decimal;
        feb: Decimal;
        mar: Decimal;
        apr: Decimal;
        may: Decimal;
        jun: Decimal;
        jul: Decimal;
        aug: Decimal;
        sep: Decimal;
        oct: Decimal;
        nov: Decimal;
        dec: Decimal;
        Totals: Decimal;
        TransactionPeriod: Integer;
        MemberLedger: Record "Cust. Ledger Entry";


}

