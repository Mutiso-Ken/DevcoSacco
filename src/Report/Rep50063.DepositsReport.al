report 50063 DepositsReport
{
    ApplicationArea = All;
    Caption = 'Deposits Report';
    RDLCLayout = './Layout/DepositsReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") order(descending);
            RequestFilterFields = "No.", "Date Filter", Status;
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyPic; CompanyInfo.Picture) { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(No; "No.") { }
            column(Name; Name) { }
            column(ID_No_; "ID No.") { }
            column(EntryNo; EntryNo) { }
            column(Deposits; Deposits) { }
            column(Phone_No_; "Phone No.") { }

            trigger OnPreDataItem()
            begin
                Deposits := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                Cust.SetFilter(Cust."Date Filter", Datefilter);
                if cust.get(Customer."No.") then begin
                    Cust.SetAutoCalcFields(Cust."Current Shares");
                    Deposits := Cust."Current Shares";
                end;
                EntryNo := EntryNo + 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        Datefilter := Customer.GetFilter("Date Filter");
    end;

    var
        CompanyInfo: Record "Company Information";
        EntryNo: Integer;
        Deposits: Decimal;
        Datefilter: Text[100];
        Cust: Record Customer;
}
