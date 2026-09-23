report 52004 MembersExitReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MembershipExit.rdlc';


    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Withdrawal Date";
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Shares_Retained; "Shares Retained") { }
            column(Withdrawal_Date; "Withdrawal Date") { }
        }
    }



    var
        myInt: Integer;
}