report 51031 "Creditors Report"
{
    ApplicationArea = All;
    Caption = 'Creditors Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/CreditorsReport.rdlc';
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields="Date Filter";
            DataItemTableView = order(descending) where("Vendor Posting Group" = const('TCREDTORS'));
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

