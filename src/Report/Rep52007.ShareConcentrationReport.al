report 52007 ShareConcentrationReport
{
    UsageCategory = Tasks;
    RDLCLayout = './Layouts/ShareConcentrationReport.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Employer Code", "Share Capital";
            DataItemTableView = where("Share Capital" = filter(> 0));
            column(No_; "No.") { }
            column(Name; Name) { }
            column(OpeningBal; OpeningBal) { }
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
                Cust: Record Customer;
                Julyfilter:Text;

            begin
                OpeningBalDate := CalcDate('<-CY>', Asat);
                OpeningBalDate:=CalcDate('<-1D>', CalcDate('<-CY>', Asat));
            
                //Openingbalances
                Cust.SetFilter("Date Filter", '..%1', OpeningBalDate);
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    OpeningBal := Cust. "Share Capital";
                end;

                //Jan
                JanDatefilter := CalcDate('1M', OpeningBalDate);
                Cust.SetFilter("Date Filter", '%1..%2', OpeningBalDate, JanDatefilter);
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    Jan := Cust. "Share Capital";
                end;
                //Feb
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate( '1D',CalcDate('1M', OpeningBalDate)), CalcDate('CM',CalcDate( '1D',CalcDate('1M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    Feb := Cust. "Share Capital";
                end;

                //March
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('2M', OpeningBalDate)), CalcDate('CM',CalcDate('1D',CalcDate('2M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    mar := Cust. "Share Capital";

                end;
                //April
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('3M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('3M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    apr := Cust. "Share Capital";

                end;
                //May
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('4M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('4M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    may := Cust. "Share Capital";

                end;
                //June
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('5M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('5M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    jun := Cust. "Share Capital";

                end;
                //July
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('6M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('6M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                if Cust.FindSet() then begin
                    repeat
                        jul := Cust. "Share Capital";
                    until Cust.Next() = 0;
                end;
                //Aug
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('7M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('7M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    aug := Cust. "Share Capital";

                end;
             //Sept
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('8M', OpeningBalDate)), CalcDate('CM',CalcDate('1D',CalcDate('8M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                    sep := Cust. "Share Capital";

                end;
                //Oct
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('9M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('9M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                     oct := Cust. "Share Capital";
                end;
              //Nov
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('10M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('10M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                   Nov := Cust. "Share Capital";

                end;
                   //Dec
                Cust.SetFilter("Date Filter", '%1..%2', CalcDate('1D',CalcDate('11M', OpeningBalDate)), CalcDate('CM', CalcDate('1D',CalcDate('11M', OpeningBalDate))));
                Cust.SetAutoCalcFields(Cust. "Share Capital");
                Cust.SetRange(Cust."No.", "No.");
                if Cust.FindSet() then begin
                       Dec := Cust. "Share Capital";
                end;
                Totals := 0;
                Totals := OpeningBal + jan + Feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec;

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
                group(GroupName)
                {
                    field(Asat; Asat)
                    {

                    }
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