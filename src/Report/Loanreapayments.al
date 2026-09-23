report 52009 RepaymentConcentrationReport
{
    UsageCategory = Tasks;
    RDLCLayout = './Layouts/RepaymentConcentrationReport1.rdlc';
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

                //Openingbalances
                LoanReg.SetFilter("Date Filter", '..%1', OpeningBalDate);
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    OpeningBal := LoanReg."Outstanding Balance";
                end;

                //Jan
                JanDatefilter := CalcDate('1M', OpeningBalDate);
                LoanReg.SetFilter("Date Filter", '%1..%2', OpeningBalDate, JanDatefilter);
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    Jan := Abs(LoanReg.Repayment);
                end;
                //Feb
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('1M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('1M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    Feb := Abs(LoanReg.Repayment);
                end;

                //March
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('2M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('2M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    mar := Abs(LoanReg.Repayment);
                end;
                //April
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('3M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('3M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    apr := Abs(LoanReg.Repayment);

                end;
                //May
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('4M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('4M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    may := Abs(LoanReg.Repayment);

                end;
                //June
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('5M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('5M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    jun := Abs(LoanReg.Repayment);

                end;
                //July
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('6M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('6M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                if LoanReg.FindSet() then begin
                    repeat
                        jul := Abs(LoanReg.Repayment);
                    until LoanReg.Next() = 0;
                end;
                //Aug
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('7M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('7M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    aug := Abs(LoanReg.Repayment);

                end;
                //Sept
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('8M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('8M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    sep := Abs(LoanReg.Repayment);

                end;
                //Oct
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('9M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('9M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    oct := Abs(LoanReg.Repayment);
                end;
                //Nov
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('10M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('10M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    Nov := Abs(LoanReg.Repayment);

                end;
                //Dec
                LoanReg.SetFilter("Date Filter", '%1..%2', CalcDate('1D', CalcDate('11M', OpeningBalDate)), CalcDate('CM', CalcDate('1D', CalcDate('11M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    Dec := Abs(LoanReg.Repayment);
                end;

                LoanReg.SetFilter("Date Filter", '..%1', CalcDate('CM', CalcDate('1D', CalcDate('11M', OpeningBalDate))));
                LoanReg.SetAutoCalcFields(LoanReg."Outstanding Balance");
                LoanReg.SetRange(LoanReg."Loan  No.", "Loan  No.");
                if LoanReg.FindSet() then begin
                    Totals := Abs(jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec);
                end;

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


}

