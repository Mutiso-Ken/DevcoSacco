
report 50359 "Deposit Balances Report"
{
    UsageCategory = Tasks;
    RDLCLayout = './Layouts/DepositBalancesReport.rdlc';
    DefaultLayout = RDLC;
    Caption = 'Deposit Balances Report';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Employer Code", "Customer Type", "Current Shares";
            DataItemTableView = where("Current Shares" = filter(> 0));

            column(No_; "No.") { }
            column(Name; Name) { }
            column(Payroll_Staff_No; "Payroll/Staff No") { }
            column(Phone_No_; "Phone No.") { }
            column(Employer_Code; "Employer Code") { }
            column(Employer_Name; "Employer Name") { }
            column(Customer_Type; "Customer Type") { }
            column(ID_No_; "ID No.") { }
            column(CurrentShares; CurrentShares) { }
            column(Loans_Guaranteed; LoansGuaranteed) { }
            column(Committed_Shares; CommittedShares) { }
            column(Total_Loan_Balance; TotalLoanBalance) { }
            column(Free_Shares; FreeShares) { }
            column(Net_Free_Shares; NetFreeShares) { }
            column(Free_Shares_Ratio; FreeSharesRatio) { }
            column(Guarantee_Limit; GuaranteeLimit) { }
            column(Available_Guarantee_Capacity; AvailableGuaranteeCapacity) { }
            column(As_At_Date; Format(AsAt)) { }
            column(Report_Date; Format(Today, 0, 4)) { }
            column(Company_Name; CompanyName) { }

            // Column for loan numbers
            column(Loan_Numbers; LoanNumbers) { }

            trigger OnAfterGetRecord()
            begin
                CalculateCustomerDepositDetails();

                // Apply minimum balance filter
                if (CurrentShares < MinimumBalance) and (MinimumBalance > 0) then
                    CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Report Options';
                    field(AsAt; AsAt)
                    {
                        ApplicationArea = All;
                        Caption = 'As At Date';
                        ToolTip = 'Specify the date for which to calculate balances';
                    }
                    field(GuaranteeMultiplier; GuaranteeMultiplier)
                    {
                        ApplicationArea = All;
                        Caption = 'Guarantee Multiplier';
                        ToolTip = 'Multiplier for calculating guarantee limit (e.g., 3x or 4x deposits)';
                        MinValue = 0;
                        MaxValue = 10;
                        DecimalPlaces = 0 : 0;
                    }
                    field(MinimumBalance; MinimumBalance)
                    {
                        ApplicationArea = All;
                        Caption = 'Minimum Deposit Balance to Include';
                        ToolTip = 'Show only customers with deposit balance above this amount';
                        DecimalPlaces = 0 : 0;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if AsAt = 0D then
                AsAt := Today;

            // Default guarantee multiplier (4x as per your code)
            if GuaranteeMultiplier = 0 then
                GuaranteeMultiplier := 4;
        end;
    }

    trigger OnPreReport()
    begin
        if AsAt = 0D then
            AsAt := Today;

        if GuaranteeMultiplier = 0 then
            GuaranteeMultiplier := 4;
    end;

    local procedure CalculateCustomerDepositDetails()
    var
        TempCust: Record Customer;
        LoansRegister: Record "Loans Register";
        LoanGuaranteeDetails: Record "Loans Guarantee Details";
        LoanRec: Record "Loans Register";
    begin
        // Calculate Current Shares (Deposit Balance) as at date
        TempCust.SetRange("No.", Customer."No.");
        TempCust.SetFilter("Date Filter", '..%1', AsAt);
        TempCust.SetAutoCalcFields(TempCust."Current Shares", TempCust."Loans Guaranteed");

        if TempCust.FindFirst() then begin
            CurrentShares := TempCust."Current Shares";
            LoansGuaranteed := TempCust."Loans Guaranteed";
        end else begin
            CurrentShares := 0;
            LoansGuaranteed := 0;
        end;

        // Calculate Total Loan Balance and get loan numbers
        TotalLoanBalance := 0;
        LoanNumbers := ''; // Initialize loan numbers string
        CommittedShares := 0; // Initialize committed shares

        LoansRegister.Reset();
        LoansRegister.SetRange("Client Code", Customer."No.");
        LoansRegister.SetAutoCalcFields("Outstanding Balance");
        LoansRegister.SetFilter("Outstanding Balance", '>%1', 0);

        if LoansRegister.FindSet() then begin
            repeat
                // Check if loan was active as at the date
                if (LoansRegister."Issued Date" <= AsAt) then begin
                    TotalLoanBalance += LoansRegister."Outstanding Balance";

                    // Always add loan number to the list (removed ShowLoanDetails condition)
                    if LoanNumbers <> '' then
                        LoanNumbers += ', ';
                    LoanNumbers += LoansRegister."Loan  No.";
                end;
            until LoansRegister.Next() = 0;
        end;

        // Calculate Committed Shares using the same logic from Loan Guarantors report
        LoanGuaranteeDetails.Reset();
        LoanGuaranteeDetails.SetRange("Member No", Customer."No.");
        LoanGuaranteeDetails.SetRange(Substituted, false);

        if LoanGuaranteeDetails.FindSet() then begin
            repeat
                // Get the loan to check if it's active and get outstanding balance
                if LoanRec.Get(LoanGuaranteeDetails."Loan No") then begin
                    LoanRec.CalcFields(LoanRec."Outstanding Balance");

                    // Check if loan was active as at the date
                    if (LoanRec."Issued Date" <= AsAt) and (LoanRec."Outstanding Balance" > 0) then begin
                        // Use the calculation based on requested amount (same as Loan Guarantors report)
                        if LoanRec."Requested Amount" > 0 then
                            CommittedShares += LoanRec."Outstanding Balance" *
                                             (LoanGuaranteeDetails."Amont Guaranteed" / LoanRec."Requested Amount");
                    end;
                end;
            until LoanGuaranteeDetails.Next() = 0;
        end;

        // Calculate Free Shares using the original formula
        // Free Shares = (Current Shares * Multiplier) - Loans Guaranteed
        if CurrentShares > 0 then begin
            // Calculate Guarantee Limit (Maximum amount that can be guaranteed)
            GuaranteeLimit := CurrentShares * GuaranteeMultiplier;

            // Calculate Gross Free Shares (before considering own loans and commitments)
            FreeShares := (CurrentShares * GuaranteeMultiplier) - LoansGuaranteed;

            // Ensure Free Shares doesn't go negative
            if FreeShares < 0 then
                FreeShares := 0;

            // Calculate Net Free Shares (after considering own loans and commitments)
            // Using CommittedShares from the loan guarantee calculation
            NetFreeShares := FreeShares - TotalLoanBalance - CommittedShares;
            if NetFreeShares < 0 then
                NetFreeShares := 0;

            // Calculate Available Guarantee Capacity
            // This is what's left after all commitments (own loans + guaranteed loans)
            AvailableGuaranteeCapacity := NetFreeShares;
            if AvailableGuaranteeCapacity < 0 then
                AvailableGuaranteeCapacity := 0;

            // Calculate Free Shares Ratio (percentage of guarantee limit still available)
            if GuaranteeLimit > 0 then
                FreeSharesRatio := (NetFreeShares / GuaranteeLimit) * 100
            else
                FreeSharesRatio := 0;
        end else begin
            GuaranteeLimit := 0;
            FreeShares := 0;
            NetFreeShares := 0;
            AvailableGuaranteeCapacity := 0;
            FreeSharesRatio := 0;
        end;
    end;

    var
        // Report variables
        AsAt: Date;
        GuaranteeMultiplier: Decimal;
        MinimumBalance: Decimal;

        // Customer level variables
        CurrentShares: Decimal;
        LoansGuaranteed: Decimal;
        CommittedShares: Decimal;
        TotalLoanBalance: Decimal;
        FreeShares: Decimal;
        NetFreeShares: Decimal;
        FreeSharesRatio: Decimal;
        GuaranteeLimit: Decimal;
        AvailableGuaranteeCapacity: Decimal;
        LoanNumbers: Text;
}