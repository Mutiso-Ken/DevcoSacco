report 50416 "Loan Deposits & Shares Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    RDLCLayout = './Layouts/Loans_Deposits.rdlc';

    dataset
    {
        dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
        {
            DataItemTableView = sorting("Member No") where("Outstanding Balance" = filter(> 0), "Member No" = filter(<> ''));
            column(Loan_No; "Loan No")
            {

            }
            column(Member_No; "Member No") { }
            column(Amont_Guaranteed; "Amont Guaranteed") { }

            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Member No");
                column(No_; "No.")
                {

                }
                column(Name; Name) { }
                column(Employer_Code; "Employer Code") { }

                column(Mobile_Phone_No; "Mobile Phone No") { }
                column(Current_Shares; "Current Shares") { }
                dataitem("Sacco Employers"; "Sacco Employers")
                {
                    DataItemLink = Code = field("Employer Code");
                    column(Employer_Name; Description){}
                }

                }
            }
        }


    }
  