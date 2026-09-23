

Report 53877 "UFAA Dormancy Status"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/UFAA Member Dormancy.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPic; CompanyInfo.Picture)
            {
            }
            column(ReportDate; Today)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(No_; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(ID_No_; "ID No.")
            {
            }
            column(Address; Address)
            {
            }
            column(Current_Shares; "Current Shares")
            {
            }
            column(Shares_Retained; "Shares Retained")
            {
            }
            column(Last_Payment_Date; "Last Payment Date")
            {
            }
            column(LastPaymentDateFormatted; Format("Last Payment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(NextOfKinName; NextOfKinName)
            {
            }
            column(NextOfKinRelationship; NextOfKinRelationship)
            {
            }
            column(Status; Status)
            {
            }
            column(DaysSinceLastPayment; DaysSinceLastPayment)
            {
            }
            column(PERIOD; PERIOD)
            {
            }
            column(DormancyThresholdDate; Format(DormancyThresholdDate, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(IsEligibleForUFAA; IsEligibleForUFAA)
            {
            }
            column(UFAA_Period; UFAA_Period)
            {
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

            end;

            trigger OnAfterGetRecord()
            var
                NextKin: Record "Members Next Kin Details";
                GenSetup: Record "Sacco General Set-Up";
            begin
                // Get Next of Kin details
                Clear(NextOfKinName);
                Clear(NextOfKinRelationship);

                NextKin.Reset();
                NextKin.SetRange("Account No", "No.");
                NextKin.SetRange(Type, NextKin.Type::"Next of Kin");

                if NextKin.FindFirst() then begin
                    NextOfKinName := NextKin.Name;
                    NextOfKinRelationship := NextKin.Relationship;
                end;

                // Get General Setup
                GenSetup.GET();
                UFAA_Period := GenSetup."UFAA Max Non Contribution P";

                // Calculate last payment date
                CalcFields(Customer."Last Payment Date", Customer."Current Shares", Customer."Shares Retained");
                if (Customer."Current Shares" <= 0) or (Customer."Shares Retained" <= 0)
                then begin
                    CurrReport.Skip();
                end;



                if "Last Payment Date" <> 0D then begin
                    // Calculate dormancy threshold date
                    DormancyThresholdDate := CalcDate(UFAA_Period, Customer."Last Payment Date");

                    // Calculate time since last payment
                    DaysSinceLastPayment := Today - Customer."Last Payment Date";
                    PERIOD := Round(DaysSinceLastPayment / 30, 1, '<');


                    // Check if eligible for UFAA List (has exceeded the period)
                    IsEligibleForUFAA := Today > DormancyThresholdDate;

                    // Only include in report if eligible for UFAA
                    if not IsEligibleForUFAA then
                        CurrReport.Skip(); // Skip members who are still within the period
                end else begin
                    // No payment history - treat as eligible for UFAA
                    IsEligibleForUFAA := true;
                    DaysSinceLastPayment := 0;
                    PERIOD := 0;
                    DormancyThresholdDate := 0D;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        NextOfKinName: Text[50];
        NextOfKinRelationship: Text[30];
        CompanyInfo: Record "Company Information";
        DaysSinceLastPayment: Integer;
        PERIOD: Decimal;
        DormancyThresholdDate: Date;
        IsEligibleForUFAA: Boolean;
        UFAA_Period: Text;
}