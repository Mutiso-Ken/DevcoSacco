#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 53876 "loan Performance Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loan Performance Status.rdlc';

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = where(Source = filter(BOSA), "Loan Status" = filter(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = filter(<> 'CEEP OLD'));
            RequestFilterFields = "Client Code", "Date filter";
            column(PrincipalPaid; PrincipalPaid)
            {
            }
            column(InterestPaid; InterestPaid)
            {
            }
            column(Loan_Last_Pay_Date; "Loan Last Pay Date")
            {
            }
            column(MonthlyPrinciple; MonthlyPrinciple)
            {
            }
            column(InterestArrears; InterestArrears)
            {
            }
            column(PrincipleArrears; PrincipleArrears)
            {
            }
            column(PrincipalBalance; PrincipalBalance)
            {
            }
            column(InterestBalance; InterestBalance)
            {
            }
            column(Loan__No_; "Loan  No.")
            {
            }
            column(Loan_Interest_Repayment; "Loan Interest Repayment")
            {
            }
            column(MonthlyInterest; MonthlyInterest)
            {
            }
            column(Client_Code; "Client Code")
            {
            }
            column(Source; Source)
            {
            }
            column(Amount_in_Arrears; "Amount in Arrears")
            {
            }
            column(LoanOfficer_Loan; "Loan Officer")
            {
            }
            column(GroupName_Loan; "Group Name")
            {
            }
            column(ClientCode_Loan; "Client Code")
            {
            }
            column(ClientName_Loan; "Client Name")
            {
            }
            column(ApprovedAmount_Loan; "Approved Amount")
            {
            }
            column(Installments_Loan; Installments)
            {
            }
            column(LoanProductType_Loan; "Loan Product Type")
            {
            }
            column(LoanDisbursementDate_Loan; "Loan Disbursement Date")
            {
            }
            column(Repayment_Loan; Repayment)
            {
            }
            column(OutstandingBalance_Loan; "Outstanding Balance")
            {
            }
            column(LoanRepayment_Loan; "Loan Repayment")
            {
            }
            column(LastPayDate_Loan; "Loan Last Pay Date")
            {
            }
            column(TotalPaid; TotalPaid)
            {
            }
            column(TotalLoan; TotalLnBal)
            {
            }
            column(IntArrears; IntArrears)
            {
            }
            column(CompanyName; Company.Name)
            {
            }
            column(CompanyAddress; Company.Address)
            {
            }
            column(CompanyPic; Company.Picture)
            {
            }
            column(ExpectInt_loans; ExpctInt)
            {
            }
            column(Loan_in_Arrears; LoanArrears)
            {
            }
            column(LoanNo_Loan; "Loans Register"."Loan  No.")
            {
            }
            column(Total_loan_bal; Totalloanbal)
            {
            }
            // column(IntPaidFinsacco_Loan; "Loans Register"."Int Paid Finsacco")
            // {
            // }
            column(Total_Int_Paid; TotalIntPaid)
            {
            }
            column(IntBal; IntBal)
            {
            }
            column(Totalloanbal; Totalloanbal)
            {
            }
            column(IntPaid; IntPaid)
            {
            }
            column(Total_Loan_Paid; TotalPay)
            {
            }
            column(Print_Date; AsAt)
            {
            }
            column(Interest; Loans.Interest)
            {
            }
            column(LastPayment; LastPaid)
            {
            }
            // New columns for monthly tracking
            column(MonthYear; MonthYear)
            {
            }
            column(ScheduledPrincipal; ScheduledPrincipal)
            {
            }
            column(ScheduledInterest; ScheduledInterest)
            {
            }
            column(ActualPrincipalPaid; ActualPrincipalPaid)
            {
            }
            column(ActualInterestPaid; ActualInterestPaid)
            {
            }
            column(BalanceNotPaid; BalanceNotPaid)
            {
            }
            column(CumulativeBalance; CumulativeBalance)
            {
            }
            column(MonthStartDate; MonthStartDate)
            {
            }
            column(MonthEndDate; MonthEndDate)
            {
            }
            column(TotalScheduled; TotalScheduled)
            {
            }
            column(TotalActualPaid; TotalActualPaid)
            {
            }

            trigger OnAfterGetRecord()
            var
                CurrentMonth: Date;
            begin
                // Initialize monthly tracking
                ClearMonthlyTracking();

                Loans.SetFilter(Loans."Date filter", DateFilter);
                Loans.SetAutocalcFields(Loans."Oustanding Interest", Loans."Interest Paid", Loans."Principal Paid", Loans."Loan Last Pay Date", Loans."Current Shares", Loans."Outstanding Balance", loans."Scheduled Principle Payments", loans."Scheduled Interest Payments", loans."Schedule Loan Amount Issued");
                if Loans.Get("Loans Register"."Loan  No.") then begin
                    // Existing calculations
                    MonthlyPrinciple := 0;
                    MonthlyInterest := 0;
                    MonthlyPrinciple := FnGetMonthPrinciple(Loans."Loan  No.");
                    MonthlyInterest := FnGetMonthInterest(Loans."Loan  No.");

                    Interestpaid := 0;
                    Interestpaid := (Loans."Interest Paid") * -1;
                    PrincipalPaid := 0;
                    PrincipalPaid := (loans."Principal Paid") * -1;

                    InterestBalance := 0;
                    PrincipalBalance := 0;
                    InterestBalance := loans."Loan Interest Repayment" - (Loans."Interest Paid") * -1;
                    PrincipalBalance := loans."Schedule Loan Amount Issued" - (loans."Principal Paid") * -1;

                    PrincipleArrears := 0;
                    PrincipleArrears := FnGetPreviousMonthsPrincipalArrears(Loans."Loan  No.", PrincipalPaid);
                    if PrincipleArrears < 0 then
                        PrincipleArrears := 0;
                    InterestArrears := 0;
                    InterestArrears := FnGetPreviousMonthsInterestArrears(Loans."Loan  No.", Interestpaid);
                    if InterestArrears < 0 then
                        InterestArrears := 0;

                    // Generate monthly tracking data
                    GenerateMonthlyTracking(Loans."Loan  No.");
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Loans Register".SetFilter("Loans Register"."Group Account", GroupFilter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(IncludeMonthlyDetail; IncludeMonthlyDetail)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Monthly Breakdown';
                        ToolTip = 'Include detailed monthly repayment tracking';
                    }
                    field(MonthsToShow; MonthsToShow)
                    {
                        ApplicationArea = All;
                        Caption = 'Number of Months to Show';
                        ToolTip = 'Number of recent months to display in the report';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        MonthYearLbl = 'Month';
        ScheduledPrincipalLbl = 'Scheduled Principal';
        ScheduledInterestLbl = 'Scheduled Interest';
        ActualPrincipalPaidLbl = 'Principal Paid';
        ActualInterestPaidLbl = 'Interest Paid';
        BalanceNotPaidLbl = 'Balance Not Paid';
        CumulativeBalanceLbl = 'Cumulative Balance';
        TotalScheduledLbl = 'Total Scheduled';
        TotalActualPaidLbl = 'Total Paid';
    }

    trigger OnInitReport()
    begin
        IncludeMonthlyDetail := true;
        MonthsToShow := 12;
    end;

    trigger OnPreReport()
    begin
        Company.Get;
        Company.CalcFields(Company.Picture);
        InitializeVariables();
    end;

    local procedure FnGetSchedulePrinciplePayments(LoanNo: Code[30]): Decimal
    var
        LoansReg: record "Loans Register";
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        LoansReg.SetAutoCalcFields(LoansReg."Scheduled Principle Payments");
        if LoansReg.Find('-') then begin
            exit(LoansReg."Scheduled Principle Payments");
        end;
    end;

    local procedure FnGetScheduleInterestPayments(LoanNo: Code[30]): Decimal
    var
        LoansReg: record "Loans Register";
    begin
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        LoansReg.SetAutoCalcFields(LoansReg."Scheduled Interest Payments");
        if LoansReg.Find('-') then begin
            exit(LoansReg."Scheduled Interest Payments");
        end;
    end;

    local procedure FnGetMonthPrinciple(LoanNo: Code[30]): Decimal
    var
        LoanSchedule: record "Loan Repayment Schedule";
        RepaymentDateRange: date;
    begin
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        LoanSchedule.Reset();
        LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
        LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', CalcDate('-CM', RepaymentDateRange), CalcDate('CM', RepaymentDateRange));
        if LoanSchedule.Find('-') then begin
            exit(LoanSchedule."Principal Repayment");
        end;
    end;

    local procedure FnGetMonthInterest(LoanNo: Code[30]): Decimal
    var
        LoanSchedule: record "Loan Repayment Schedule";
        RepaymentDateRange: date;
    begin
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        LoanSchedule.Reset();
        LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
        LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', CalcDate('-CM', RepaymentDateRange), CalcDate('CM', RepaymentDateRange));
        if LoanSchedule.Find('-') then begin
            exit(LoanSchedule."Monthly Interest");
        end;
    end;

    local procedure FnGetPreviousMonthsPrincipalArrears(LoanNo: Code[30]; PrincipalPaid: Decimal): Decimal
    var
        LoansRegister: record "Loans Register";
        RepaymentDateRange: date;
        NewFilter: date;
    begin
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        NewFilter := CalcDate('-1M', (CalcDate('CM', RepaymentDateRange)));
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + format(NewFilter));
        LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Principle Payments", LoansRegister."Principal Paid");
        IF LoansRegister.Find('-') THEN begin
            exit(LoansRegister."Scheduled Principle Payments" - (PrincipalPaid));
        end;
        exit(0);
    end;

    local procedure FnGetPreviousMonthsInterestArrears(LoanNo: Code[30]; Interestpaid: Decimal): Decimal
    var
        LoansRegister: record "Loans Register";
        RepaymentDateRange: date;
        NewFilter: date;
    begin
        RepaymentDateRange := 0D;
        Evaluate(RepaymentDateRange, CopyStr(DateFilter, 3, 100));
        NewFilter := CalcDate('-1M', (CalcDate('CM', RepaymentDateRange)));
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        LoansRegister.SetFilter(LoansRegister."Date filter", '..' + format(NewFilter));
        LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Interest Payments", LoansRegister."Interest Paid");
        IF LoansRegister.Find('-') THEN begin
            exit(LoansRegister."Scheduled Interest Payments" - (Interestpaid));
        end;
        exit(0);
    end;

    // New procedures for monthly tracking
    local procedure GenerateMonthlyTracking(LoanNo: Code[30])
    var
        Loan: Record "Loans Register";
        MonthDate: Date;
        CurrentDate: Date;
        MonthCounter: Integer;
    begin
        if not IncludeMonthlyDetail then
            exit;

        if Loan.Get(LoanNo) then begin
            MonthDate := Loan."Loan Disbursement Date";
            CurrentDate := Today;
            MonthCounter := 0;
            CumulativeBalance := 0;

            while (MonthDate <= CurrentDate) and (MonthCounter < MonthsToShow) do begin
                CalculateMonthlyBalances(LoanNo, MonthDate);

                // Prepare for next month
                MonthDate := CalcDate('<1M>', MonthDate);
                MonthCounter += 1;

                // For demonstration, we'll store the last month's data
                // In a real scenario, you might want to use a temporary table for multiple months
            end;
        end;
    end;

    local procedure CalculateMonthlyBalances(LoanNo: Code[30]; MonthDate: Date)
    var
        LoanSchedule: Record "Loan Repayment Schedule";
        LoansRegister: Record "Loans Register";
    begin
        ClearMonthlyVariables();

        // Get scheduled amounts for the month
        LoanSchedule.Reset();
        LoanSchedule.SetRange("Loan No.", LoanNo);
        LoanSchedule.SetRange("Repayment Date", CalcDate('-CM', MonthDate), CalcDate('CM', MonthDate));
        if LoanSchedule.FindFirst() then begin
            ScheduledPrincipal := LoanSchedule."Principal Repayment";
            ScheduledInterest := LoanSchedule."Monthly Interest";
        end;

        // Get actual payments for the month
        LoansRegister.Reset();
        LoansRegister.SetRange("Loan  No.", LoanNo);
        LoansRegister.SetFilter("Date filter", '%1..%2', CalcDate('-CM', MonthDate), CalcDate('CM', MonthDate));
        LoansRegister.SetAutoCalcFields("Principal Paid", "Interest Paid");
        if LoansRegister.FindFirst() then begin
            ActualPrincipalPaid := LoansRegister."Principal Paid" * -1;
            ActualInterestPaid := LoansRegister."Interest Paid" * -1;
        end;

        // Calculate balances
        TotalScheduled := ScheduledPrincipal + ScheduledInterest;
        TotalActualPaid := ActualPrincipalPaid + ActualInterestPaid;
        BalanceNotPaid := TotalScheduled - TotalActualPaid;

        if BalanceNotPaid < 0 then
            BalanceNotPaid := 0;

        // Update cumulative balance
        CumulativeBalance := CumulativeBalance + BalanceNotPaid;

        // Set display values
        MonthYear := Format(MonthDate, 0, '<Month Text> <Year4>');
        MonthStartDate := CalcDate('-CM', MonthDate);
        MonthEndDate := CalcDate('CM', MonthDate);
    end;

    local procedure ClearMonthlyTracking()
    begin
        Clear(ScheduledPrincipal);
        Clear(ScheduledInterest);
        Clear(ActualPrincipalPaid);
        Clear(ActualInterestPaid);
        Clear(BalanceNotPaid);
        Clear(CumulativeBalance);
        Clear(MonthYear);
        Clear(MonthStartDate);
        Clear(MonthEndDate);
        Clear(TotalScheduled);
        Clear(TotalActualPaid);
    end;

    local procedure ClearMonthlyVariables()
    begin
        ScheduledPrincipal := 0;
        ScheduledInterest := 0;
        ActualPrincipalPaid := 0;
        ActualInterestPaid := 0;
        BalanceNotPaid := 0;
        TotalScheduled := 0;
        TotalActualPaid := 0;
    end;

    local procedure InitializeVariables()
    begin
        Company.Get;
        Company.CalcFields(Company.Picture);
        PrincipalPaid := 0;
        InterestPaid := 0;
        LoanArrears := 0;
        IntArrears := 0;
        TotalPaid := 0;
        ExpctInt := 0;
        MonthsInArrears := 0;
        Expectedpayment := 0;
        InstallementExpected := 0;
        No_ofmonths := 0;
        nofmonths := 0;
        TotalIntPaid := 0;
        IntBal := 0;
        MonthlyPrinciple := 0;
        MonthlyInterest := 0;
        Totalloanbal := 0;
        IntPaid := 0;
        PaidInt := 0;
        InterestAmt := 0;
        Intbalcon := 0;
        IssueDate := 20170101D;
        TotalPay := 0;
        Months := 0;
        Days := 0;
        InterestBalance := 0;
        PrincipalBalance := 0;
        PrinArrears := 0;
        PrincipleArrears := 0;
        InterestArrears := 0;
        PrinPay := 0;
        LoanMonths := 0;
        ExpectedRepayment := 0;
        PaidMonths := 0;
        MonthlyPrinciple := 0;
        MonthlyInterest := 0;
        CumulativeBalance := 0;

        GroupFilter := "Loans Register".GetFilter("Loans Register"."Group Account");
        DateFilter := "Loans Register".GetFilter("Loans Register"."Date filter");
    end;

    var
        Loans: Record "Loans Register";
        MonthlyPrinciple: Decimal;
        MonthlyInterest: Decimal;
        Company: Record "Company Information";
        LoanArrears: Decimal;
        IntArrears: Decimal;
        TotalPaid: Decimal;
        TotalLnBal: Decimal;
        ExpctInt: Decimal;
        Expectedpayment: Decimal;
        LoanInArrears: Decimal;
        MonthsInArrears: Integer;
        InstallementExpected: Decimal;
        No_ofmonths: Decimal;
        PrincipleArrears: Decimal;
        InterestBalance: Decimal;
        PrincipalBalance: Decimal;
        InterestArrears: Decimal;
        LoansRec: Record "Loans Register";
        nofmonths: Decimal;
        AsAt: Date;
        GroupFilter: Code[50];
        Totalloanbal: Decimal;
        TotalIntPaid: Decimal;
        IntBal: Decimal;
        IntPaid: Decimal;
        DateFilter: Text;
        PaidInt: Decimal;
        InterestAmt: Decimal;
        IssueDate: Date;
        Intbalcon: Decimal;
        InterestPaid: Decimal;
        PrincipalPaid: Decimal;
        TotalPay: Decimal;
        Months: Decimal;
        Days: Decimal;
        PrinArrears: Decimal;
        PrinPay: Decimal;
        LoanMonths: Decimal;
        ExpectedRepayment: Decimal;
        PaidMonths: Decimal;
        LastPaid: Decimal;
        // New variables for monthly tracking
        ScheduledPrincipal: Decimal;
        ScheduledInterest: Decimal;
        ActualPrincipalPaid: Decimal;
        ActualInterestPaid: Decimal;
        BalanceNotPaid: Decimal;
        CumulativeBalance: Decimal;
        MonthYear: Text;
        MonthStartDate: Date;
        MonthEndDate: Date;
        TotalScheduled: Decimal;
        TotalActualPaid: Decimal;
        IncludeMonthlyDetail: Boolean;
        MonthsToShow: Integer;
}
#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Report 53876 "loan Performance Status"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/Loan Performance Status.rdlc';

//     dataset
//     {
//         dataitem("Loans Register"; "Loans Register")
//         {
//             DataItemTableView = where(Source = filter(BOSA), "Loan Status" = filter(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = filter(<> 'CEEP OLD'));
//             RequestFilterFields = "Client Code", "Date filter";
//             column(PrincipalPaid; PrincipalPaid)
//             {
//             }
//             column(InterestPaid; InterestPaid)
//             {
//             }
//             column(Loan_Last_Pay_Date; "Loan Last Pay Date")
//             {
//             }
//             column(MonthlyPrinciple; MonthlyPrinciple)
//             {
//             }
//             column(InterestArrears; InterestArrears)
//             {
//             }
//             column(PrincipleArrears; PrincipleArrears)
//             {
//             }
//             column(PrincipalBalance; PrincipalBalance)
//             {
//             }
//             column(InterestBalance; InterestBalance)
//             {
//             }
//             column(Loan__No_; "Loan  No.")
//             {
//             }
//             column(Loan_Interest_Repayment; "Loan Interest Repayment")
//             {
//             }
//             column(MonthlyInterest; MonthlyInterest)
//             {
//             }
//             column(Client_Code; "Client Code")
//             {
//             }
//             column(Source; Source)
//             {
//             }
//             column(Amount_in_Arrears; "Amount in Arrears")
//             {
//             }
//             column(LoanOfficer_Loan; "Loan Officer")
//             {
//             }
//             column(GroupName_Loan; "Group Name")
//             {
//             }
//             column(ClientCode_Loan; "Client Code")
//             {
//             }
//             column(ClientName_Loan; "Client Name")
//             {
//             }
//             column(ApprovedAmount_Loan; "Approved Amount")
//             {
//             }
//             column(Installments_Loan; Installments)
//             {
//             }
//             column(LoanProductType_Loan; "Loan Product Type")
//             {
//             }
//             column(LoanDisbursementDate_Loan; "Loan Disbursement Date")
//             {
//             }
//             column(Repayment_Loan; Repayment)
//             {
//             }
//             column(OutstandingBalance_Loan; "Outstanding Balance")
//             {
//             }
//             column(LoanRepayment_Loan; "Loan Repayment")
//             {
//             }
//             column(LastPayDate_Loan; "Loan Last Pay Date")
//             {
//             }
//             column(TotalPaid; TotalPaid)
//             {
//             }
//             column(TotalLoan; TotalLnBal)
//             {
//             }
//             column(IntArrears; IntArrears)
//             {
//             }
//             column(CompanyName; Company.Name)
//             {
//             }
//             column(CompanyAddress; Company.Address)
//             {
//             }
//             column(CompanyPic; Company.Picture)
//             {
//             }
//             column(ExpectInt_loans; ExpctInt)
//             {
//             }
//             column(Loan_in_Arrears; LoanArrears)
//             {
//             }
//             column(LoanNo_Loan; "Loans Register"."Loan  No.")
//             {
//             }
//             column(Total_loan_bal; Totalloanbal)
//             {
//             }
//             column(IntPaidFinsacco_Loan; "Loans Register"."Int Paid Finsacco")
//             {
//             }
//             column(Total_Int_Paid; TotalIntPaid)
//             {
//             }
//             column(IntBal; IntBal)
//             {
//             }
//             column(Totalloanbal; Totalloanbal)
//             {
//             }
//             column(IntPaid; IntPaid)
//             {
//             }
//             column(Total_Loan_Paid; TotalPay)
//             {
//             }
//             column(Print_Date; AsAt)
//             {
//             }
//             column(Interest; Loans.Interest)
//             {
//             }
//             column(LastPayment; LastPaid)
//             {
//             }
//             // New columns for monthly tracking
//             column(MonthYear; MonthYear)
//             {
//             }
//             column(ScheduledPrincipal; ScheduledPrincipal)
//             {
//             }
//             column(ScheduledInterest; ScheduledInterest)
//             {
//             }
//             column(ActualPrincipalPaid; ActualPrincipalPaid)
//             {
//             }
//             column(ActualInterestPaid; ActualInterestPaid)
//             {
//             }
//             column(BalanceNotPaid; BalanceNotPaid)
//             {
//             }
//             column(CumulativeBalance; CumulativeBalance)
//             {
//             }
//             column(MonthStartDate; MonthStartDate)
//             {
//             }
//             column(MonthEndDate; MonthEndDate)
//             {
//             }
//             column(TotalScheduled; TotalScheduled)
//             {
//             }
//             column(TotalActualPaid; TotalActualPaid)
//             {
//             }
//             column(Report_End_Date; ReportEndDate)
//             {
//             }
//             column(Report_Start_Date; ReportStartDate)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 // Initialize monthly tracking
//                 ClearMonthlyTracking();

//                 // Set date filter properly for the loan
//                 Loans.SetFilter(Loans."Date filter", GetDateFilter());
//                 Loans.SetAutocalcFields(Loans."Oustanding Interest", Loans."Interest Paid", Loans."Principal Paid", Loans."Loan Last Pay Date", Loans."Current Shares", Loans."Outstanding Balance", loans."Scheduled Principle Payments", loans."Scheduled Interest Payments", loans."Schedule Loan Amount Issued");

//                 if Loans.Get("Loans Register"."Loan  No.") then begin
//                     // Existing calculations
//                     MonthlyPrinciple := 0;
//                     MonthlyInterest := 0;
//                     MonthlyPrinciple := FnGetMonthPrinciple(Loans."Loan  No.");
//                     MonthlyInterest := FnGetMonthInterest(Loans."Loan  No.");

//                     Interestpaid := 0;
//                     Interestpaid := (Loans."Interest Paid") * -1;
//                     PrincipalPaid := 0;
//                     PrincipalPaid := (loans."Principal Paid") * -1;

//                     InterestBalance := 0;
//                     PrincipalBalance := 0;
//                     InterestBalance := loans."Loan Interest Repayment" - (Loans."Interest Paid") * -1;
//                     PrincipalBalance := loans."Schedule Loan Amount Issued" - (loans."Principal Paid") * -1;

//                     PrincipleArrears := 0;
//                     PrincipleArrears := FnGetPreviousMonthsPrincipalArrears(Loans."Loan  No.", PrincipalPaid);
//                     if PrincipleArrears < 0 then
//                         PrincipleArrears := 0;
//                     InterestArrears := 0;
//                     InterestArrears := FnGetPreviousMonthsInterestArrears(Loans."Loan  No.", Interestpaid);
//                     if InterestArrears < 0 then
//                         InterestArrears := 0;

//                     // Generate monthly tracking data
//                     GenerateMonthlyTracking(Loans."Loan  No.");
//                 end;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 "Loans Register".SetFilter("Loans Register"."Group Account", GroupFilter);

//                 // Initialize report dates
//                 InitializeReportDates();
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     field(AsAtDate; AsAtDate)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'As At Date';
//                         ToolTip = 'Specify the end date for the report';
//                     }
//                     field(IncludeMonthlyDetail; IncludeMonthlyDetail)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Include Monthly Breakdown';
//                         ToolTip = 'Include detailed monthly repayment tracking';
//                     }
//                     field(MonthsToShow; MonthsToShow)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Number of Months to Show';
//                         ToolTip = 'Number of recent months to display in the report';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//         MonthYearLbl = 'Month';
//         ScheduledPrincipalLbl = 'Scheduled Principal';
//         ScheduledInterestLbl = 'Scheduled Interest';
//         ActualPrincipalPaidLbl = 'Principal Paid';
//         ActualInterestPaidLbl = 'Interest Paid';
//         BalanceNotPaidLbl = 'Balance Not Paid';
//         CumulativeBalanceLbl = 'Cumulative Balance';
//         TotalScheduledLbl = 'Total Scheduled';
//         TotalActualPaidLbl = 'Total Paid';
//         Report_End_DateLbl = 'As At Date';
//         Report_Start_DateLbl = 'From Date';
//     }

//     trigger OnInitReport()
//     begin
//         IncludeMonthlyDetail := true;
//         MonthsToShow := 12;
//         AsAtDate := Today; // Default to today
//     end;

//     trigger OnPreReport()
//     begin
//         Company.Get;
//         Company.CalcFields(Company.Picture);
//         InitializeVariables();
//     end;

//     local procedure FnGetSchedulePrinciplePayments(LoanNo: Code[30]): Decimal
//     var
//         LoansReg: record "Loans Register";
//     begin
//         LoansReg.Reset();
//         LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
//         LoansReg.SetAutoCalcFields(LoansReg."Scheduled Principle Payments");
//         if LoansReg.Find('-') then begin
//             exit(LoansReg."Scheduled Principle Payments");
//         end;
//     end;

//     local procedure FnGetScheduleInterestPayments(LoanNo: Code[30]): Decimal
//     var
//         LoansReg: record "Loans Register";
//     begin
//         LoansReg.Reset();
//         LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
//         LoansReg.SetAutoCalcFields(LoansReg."Scheduled Interest Payments");
//         if LoansReg.Find('-') then begin
//             exit(LoansReg."Scheduled Interest Payments");
//         end;
//     end;

//     // Fixed date filter functions
//     local procedure FnGetMonthPrinciple(LoanNo: Code[30]): Decimal
//     var
//         LoanSchedule: record "Loan Repayment Schedule";
//     begin
//         LoanSchedule.Reset();
//         LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
//         LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', ReportStartDate, ReportEndDate);
//         if LoanSchedule.FindSet() then begin
//             LoanSchedule.CalcSums("Principal Repayment");
//             exit(LoanSchedule."Principal Repayment");
//         end;
//         exit(0);
//     end;

//     local procedure FnGetMonthInterest(LoanNo: Code[30]): Decimal
//     var
//         LoanSchedule: record "Loan Repayment Schedule";
//     begin
//         LoanSchedule.Reset();
//         LoanSchedule.SetRange(LoanSchedule."Loan No.", LoanNo);
//         LoanSchedule.SetFilter(LoanSchedule."Repayment Date", '%1..%2', ReportStartDate, ReportEndDate);
//         if LoanSchedule.FindSet() then begin
//             LoanSchedule.CalcSums("Monthly Interest");
//             exit(LoanSchedule."Monthly Interest");
//         end;
//         exit(0);
//     end;

//     local procedure FnGetPreviousMonthsPrincipalArrears(LoanNo: Code[30]; PrincipalPaid: Decimal): Decimal
//     var
//         LoansRegister: record "Loans Register";
//         PreviousMonthEnd: Date;
//     begin
//         PreviousMonthEnd := CalcDate('<-1M-CM>', ReportEndDate);

//         LoansRegister.Reset();
//         LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
//         LoansRegister.SetFilter(LoansRegister."Date filter", '..' + Format(PreviousMonthEnd));
//         LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Principle Payments", LoansRegister."Principal Paid");
//         if LoansRegister.FindFirst() then begin
//             exit(LoansRegister."Scheduled Principle Payments" - (PrincipalPaid));
//         end;
//         exit(0);
//     end;

//     local procedure FnGetPreviousMonthsInterestArrears(LoanNo: Code[30]; Interestpaid: Decimal): Decimal
//     var
//         LoansRegister: record "Loans Register";
//         PreviousMonthEnd: Date;
//     begin
//         PreviousMonthEnd := CalcDate('<-1M-CM>', ReportEndDate);

//         LoansRegister.Reset();
//         LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
//         LoansRegister.SetFilter(LoansRegister."Date filter", '..' + Format(PreviousMonthEnd));
//         LoansRegister.SetAutoCalcFields(LoansRegister."Scheduled Interest Payments", LoansRegister."Interest Paid");
//         if LoansRegister.FindFirst() then begin
//             exit(LoansRegister."Scheduled Interest Payments" - (Interestpaid));
//         end;
//         exit(0);
//     end;

//     // New procedures for proper date handling
//     local procedure InitializeReportDates()
//     begin
//         if AsAtDate = 0D then
//             AsAtDate := Today;

//         ReportEndDate := CalcDate('CM', AsAtDate); // End of month
//         ReportStartDate := CalcDate('<-CM>', AsAtDate); // Start of month
//         AsAt := ReportEndDate; // For display purposes
//     end;

//     local procedure GetDateFilter(): Text
//     begin
//         exit(StrSubstNo('%1..%2', ReportStartDate, ReportEndDate));
//     end;

//     // Updated monthly tracking with proper date handling
//     local procedure GenerateMonthlyTracking(LoanNo: Code[30])
//     var
//         Loan: Record "Loans Register";
//         MonthDate: Date;
//         CurrentDate: Date;
//         MonthCounter: Integer;
//     begin
//         if not IncludeMonthlyDetail then
//             exit;

//         if Loan.Get(LoanNo) then begin
//             // Start from loan disbursement date or report start date
//             MonthDate := Loan."Loan Disbursement Date";
//             if MonthDate < ReportStartDate then
//                 MonthDate := ReportStartDate;

//             CurrentDate := ReportEndDate;
//             MonthCounter := 0;
//             CumulativeBalance := 0;

//             while (MonthDate <= CurrentDate) and (MonthCounter < MonthsToShow) do begin
//                 CalculateMonthlyBalances(LoanNo, MonthDate);

//                 // Prepare for next month - move to next month's start
//                 MonthDate := CalcDate('<1M>', CalcDate('CM', MonthDate) + 1);
//                 MonthCounter += 1;
//             end;
//         end;
//     end;

//     local procedure CalculateMonthlyBalances(LoanNo: Code[30]; MonthDate: Date)
//     var
//         LoanSchedule: Record "Loan Repayment Schedule";
//         LoansRegister: Record "Loans Register";
//         MonthStart: Date;
//         MonthEnd: Date;
//     begin
//         ClearMonthlyVariables();

//         // Calculate month boundaries
//         MonthStart := CalcDate('<-CM>', MonthDate);
//         MonthEnd := CalcDate('<CM>', MonthDate);

//         // Get scheduled amounts for the month
//         LoanSchedule.Reset();
//         LoanSchedule.SetRange("Loan No.", LoanNo);
//         LoanSchedule.SetRange("Repayment Date", MonthStart, MonthEnd);
//         if LoanSchedule.FindSet() then begin
//             LoanSchedule.CalcSums("Principal Repayment", "Monthly Interest");
//             ScheduledPrincipal := LoanSchedule."Principal Repayment";
//             ScheduledInterest := LoanSchedule."Monthly Interest";
//         end;

//         // Get actual payments for the month
//         LoansRegister.Reset();
//         LoansRegister.SetRange("Loan  No.", LoanNo);
//         LoansRegister.SetFilter("Date filter", '%1..%2', MonthStart, MonthEnd);
//         LoansRegister.SetAutoCalcFields("Principal Paid", "Interest Paid");
//         if LoansRegister.FindFirst() then begin
//             ActualPrincipalPaid := LoansRegister."Principal Paid" * -1;
//             ActualInterestPaid := LoansRegister."Interest Paid" * -1;
//         end;

//         // Calculate balances
//         TotalScheduled := ScheduledPrincipal + ScheduledInterest;
//         TotalActualPaid := ActualPrincipalPaid + ActualInterestPaid;
//         BalanceNotPaid := TotalScheduled - TotalActualPaid;

//         if BalanceNotPaid < 0 then
//             BalanceNotPaid := 0;

//         // Update cumulative balance
//         CumulativeBalance := CumulativeBalance + BalanceNotPaid;

//         // Set display values
//         MonthYear := Format(MonthDate, 0, '<Month Text> <Year4>');
//         MonthStartDate := MonthStart;
//         MonthEndDate := MonthEnd;
//     end;

//     local procedure ClearMonthlyTracking()
//     begin
//         Clear(ScheduledPrincipal);
//         Clear(ScheduledInterest);
//         Clear(ActualPrincipalPaid);
//         Clear(ActualInterestPaid);
//         Clear(BalanceNotPaid);
//         Clear(CumulativeBalance);
//         Clear(MonthYear);
//         Clear(MonthStartDate);
//         Clear(MonthEndDate);
//         Clear(TotalScheduled);
//         Clear(TotalActualPaid);
//     end;

//     local procedure ClearMonthlyVariables()
//     begin
//         ScheduledPrincipal := 0;
//         ScheduledInterest := 0;
//         ActualPrincipalPaid := 0;
//         ActualInterestPaid := 0;
//         BalanceNotPaid := 0;
//         TotalScheduled := 0;
//         TotalActualPaid := 0;
//     end;

//     local procedure InitializeVariables()
//     begin
//         Company.Get;
//         Company.CalcFields(Company.Picture);
//         PrincipalPaid := 0;
//         InterestPaid := 0;
//         LoanArrears := 0;
//         IntArrears := 0;
//         TotalPaid := 0;
//         ExpctInt := 0;
//         MonthsInArrears := 0;
//         Expectedpayment := 0;
//         InstallementExpected := 0;
//         No_ofmonths := 0;
//         nofmonths := 0;
//         TotalIntPaid := 0;
//         IntBal := 0;
//         MonthlyPrinciple := 0;
//         MonthlyInterest := 0;
//         Totalloanbal := 0;
//         IntPaid := 0;
//         PaidInt := 0;
//         InterestAmt := 0;
//         Intbalcon := 0;
//         IssueDate := 20170101D;
//         TotalPay := 0;
//         Months := 0;
//         Days := 0;
//         InterestBalance := 0;
//         PrincipalBalance := 0;
//         PrinArrears := 0;
//         PrincipleArrears := 0;
//         InterestArrears := 0;
//         PrinPay := 0;
//         LoanMonths := 0;
//         ExpectedRepayment := 0;
//         PaidMonths := 0;
//         MonthlyPrinciple := 0;
//         MonthlyInterest := 0;
//         CumulativeBalance := 0;

//         GroupFilter := "Loans Register".GetFilter("Loans Register"."Group Account");
//         DateFilter := "Loans Register".GetFilter("Loans Register"."Date filter");
//     end;

//     var
//         Loans: Record "Loans Register";
//         MonthlyPrinciple: Decimal;
//         MonthlyInterest: Decimal;
//         Company: Record "Company Information";
//         LoanArrears: Decimal;
//         IntArrears: Decimal;
//         TotalPaid: Decimal;
//         TotalLnBal: Decimal;
//         ExpctInt: Decimal;
//         Expectedpayment: Decimal;
//         LoanInArrears: Decimal;
//         MonthsInArrears: Integer;
//         InstallementExpected: Decimal;
//         No_ofmonths: Decimal;
//         PrincipleArrears: Decimal;
//         InterestBalance: Decimal;
//         PrincipalBalance: Decimal;
//         InterestArrears: Decimal;
//         LoansRec: Record "Loans Register";
//         nofmonths: Decimal;
//         AsAt: Date;
//         GroupFilter: Code[50];
//         Totalloanbal: Decimal;
//         TotalIntPaid: Decimal;
//         IntBal: Decimal;
//         IntPaid: Decimal;
//         DateFilter: Text;
//         PaidInt: Decimal;
//         InterestAmt: Decimal;
//         IssueDate: Date;
//         Intbalcon: Decimal;
//         InterestPaid: Decimal;
//         PrincipalPaid: Decimal;
//         TotalPay: Decimal;
//         Months: Decimal;
//         Days: Decimal;
//         PrinArrears: Decimal;
//         PrinPay: Decimal;
//         LoanMonths: Decimal;
//         ExpectedRepayment: Decimal;
//         PaidMonths: Decimal;
//         LastPaid: Decimal;
//         // New variables for monthly tracking
//         ScheduledPrincipal: Decimal;
//         ScheduledInterest: Decimal;
//         ActualPrincipalPaid: Decimal;
//         ActualInterestPaid: Decimal;
//         BalanceNotPaid: Decimal;
//         CumulativeBalance: Decimal;
//         MonthYear: Text;
//         MonthStartDate: Date;
//         MonthEndDate: Date;
//         TotalScheduled: Decimal;
//         TotalActualPaid: Decimal;
//         IncludeMonthlyDetail: Boolean;
//         MonthsToShow: Integer;
//         // New date variables
//         AsAtDate: Date;
//         ReportEndDate: Date;
//         ReportStartDate: Date;
// }