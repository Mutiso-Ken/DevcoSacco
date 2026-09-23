report 51032 "Debtors Report"
{
    ApplicationArea = All;
    Caption = 'Debtors Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/DebtorsReport.rdlc';
    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields="Date Filter";
            DataItemTableView = order(descending) where("customer Type" = const(Checkoff));
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Balance; "Net Change")
            {
            }
            column(CName; CompanyInfo.Name)
            {
            }
            column(CAddress; CompanyInfo.Address)
            {
            }
            column(CPic; CompanyInfo.Picture)
            {
            }
            column(TaxRegNo; CompanyInfo."Company P.I.N")
            {
            }
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

