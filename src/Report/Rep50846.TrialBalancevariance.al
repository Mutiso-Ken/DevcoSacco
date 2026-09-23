#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50847 "Trial Balance variance"
{
    DefaultLayout = RDLC;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/Trial BalanceVariance.rdlc';
    Caption = 'Trial Balance - 2 Years Comparison';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            RequestFilterFields = "No.", "Account Type", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710) { }
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText)) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(PeriodText; PeriodText) { }
            column(company_Picture; company.Picture) { }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter) { }
            column(GLFilter; GLFilter) { }
            column(G_L_Account_No_; "No.") { }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(Year1_Net_ChangeCaption; Year1_Net_ChangeCaptionLbl) { }
            column(Year2_Net_ChangeCaption; Year2_Net_ChangeCaptionLbl) { }
            column(VarianceCaption; VarianceCaptionLbl) { }
            column(Variance_PercentCaption; Variance_PercentCaptionLbl) { }
            column(G_L_Account___No__Caption; FieldCaption("No.")) { }
            column(Account_NameCaption; Account_NameCaptionLbl) { }
            column(PageGroupNo; PageGroupNo) { }
            column(Year1NetChange; Year1NetChange) { }
            column(Year2NetChange; Year2NetChange) { }
            column(VarianceAmount; VarianceAmount) { }
            column(VariancePercent; VariancePercent) { }
            column(Year1DateFilter; Year1DateFilter) { }
            column(Year2DateFilter; Year2DateFilter) { }

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_5444; 5444) { }
                column(G_L_Account___No__; "G/L Account"."No.") { }
                column(Account_Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name) { }
                column(Year1_Debit; Year1Debit) { }
                column(Year1_Credit; Year1Credit) { }
                column(Year2_Debit; Year2Debit) { }
                column(Year2_Credit; Year2Credit) { }
                column(Variance_Amount; VarianceAmount) { }
                column(Variance_Percent; VariancePercent) { }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2)) { }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines") { }

                dataitem(BlankLineRepeater; "Integer")
                {
                    column(ReportForNavId_7; 7) { }
                    column(BlankLineNo; BlankLineNo) { }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break;
                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                    CalculateYearlyAmounts();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;
                ChangeGroupNo := "New Page";

                // Skip accounts with zero amounts in both years if needed
                if (Year1NetChange = 0) and (Year2NetChange = 0) and HideZeroLines then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;
                company.Get();
                company.CalcFields(company.Picture);

                // Set date filters
                if Year1StartDate = 0D then Year1StartDate := CalcDate('<-CY>', Today);
                if Year1EndDate = 0D then Year1EndDate := CalcDate('<CY>', Today);
                if Year2StartDate = 0D then Year2StartDate := CalcDate('<-1Y>', Year1StartDate);
                if Year2EndDate = 0D then Year2EndDate := CalcDate('<-1Y>', Year1EndDate);

                Year1DateFilter := Format(Year1StartDate) + '..' + Format(Year1EndDate);
                Year2DateFilter := Format(Year2StartDate) + '..' + Format(Year2EndDate);
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
                    Caption = 'Date Filters';
                    field(Year1StartDate; Year1StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Year 1 Start Date';
                    }
                    field(Year1EndDate; Year1EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Year 1 End Date';
                    }
                    field(Year2StartDate; Year2StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Year 2 Start Date';
                    }
                    field(Year2EndDate; Year2EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Year 2 End Date';
                    }
                    field(HideZeroLines; HideZeroLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Hide Zero Balance Lines';
                    }
                }
            }
        }
    }

    labels
    {
        Year1_Caption = 'Year 1';
        Year2_Caption = 'Year 2';
        Variance_Caption = 'Variance';
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := 'Year 1: ' + Year1DateFilter + ' | Year 2: ' + Year2DateFilter;
    end;

    var
        company: Record "Company Information";
        Text000: label 'Period: %1';
        GLFilter: Text;
        PeriodText: Text[100];
        Year1DateFilter: Text;
        Year2DateFilter: Text;
        Year1StartDate: Date;
        Year1EndDate: Date;
        Year2StartDate: Date;
        Year2EndDate: Date;
        Year1NetChange: Decimal;
        Year2NetChange: Decimal;
        Year1Debit: Decimal;
        Year1Credit: Decimal;
        Year2Debit: Decimal;
        Year2Credit: Decimal;
        VarianceAmount: Decimal;
        VariancePercent: Decimal;
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        HideZeroLines: Boolean;

        // Labels
        Trial_BalanceCaptionLbl: label 'Trial Balance - 2 Years Comparison';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Year1_Net_ChangeCaptionLbl: label 'Year 1 Amount';
        Year2_Net_ChangeCaptionLbl: label 'Year 2 Amount';
        VarianceCaptionLbl: label 'Variance Amount';
        Variance_PercentCaptionLbl: label 'Variance %';
        Account_NameCaptionLbl: label 'Account Name';

    local procedure CalculateYearlyAmounts()
    var
        GLEntry: Record "G/L Entry";
    begin
        // Initialize variables
        Year1NetChange := 0;
        Year2NetChange := 0;
        Year1Debit := 0;
        Year1Credit := 0;
        Year2Debit := 0;
        Year2Credit := 0;
        VarianceAmount := 0;
        VariancePercent := 0;

        // Calculate Year 1 amounts
        "G/L Account".SetRange("Date Filter", Year1StartDate, Year1EndDate);
        "G/L Account".CalcFields("Net Change");
        Year1NetChange := "G/L Account"."Net Change";

        if Year1NetChange > 0 then
            Year1Debit := Year1NetChange
        else
            Year1Credit := Abs(Year1NetChange);

        // Calculate Year 2 amounts
        "G/L Account".SetRange("Date Filter", Year2StartDate, Year2EndDate);
        "G/L Account".CalcFields("Net Change");
        Year2NetChange := "G/L Account"."Net Change";

        if Year2NetChange > 0 then
            Year2Debit := Year2NetChange
        else
            Year2Credit := Abs(Year2NetChange);

        // Calculate variance
        VarianceAmount := Year2NetChange - Year1NetChange;

        // Calculate variance percentage (avoid division by zero)
        if Year1NetChange <> 0 then
            VariancePercent := (VarianceAmount / Abs(Year1NetChange)) * 100
        else if Year2NetChange <> 0 then
            VariancePercent := 100
        else
            VariancePercent := 0;

        // Reset date filter
        "G/L Account".SetRange("Date Filter");
    end;
}