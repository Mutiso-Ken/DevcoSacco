Page 50247 "Loans Guarantee Details"
{
    PageType = ListPart;
    SourceTable = "Loans Guarantee Details";
    SourceTableView = where(Substituted = const(false));




    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Loan No"; Rec."Loan No")
                {
                    Editable = false;

                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    trigger OnValidate()
                    var
                        cust: Record Customer;
                    begin
                        if cust.get(rec."Member No") then begin
                            cust.CalcFields(cust."Current Shares", "Loans Guaranteed");
                            Rec.Name := cust.Name;
                            rec.Shares := cust."Current Shares";
                            Rec."Total Loans Guaranteed" := cust."Loans Guaranteed";
                            Rec."Free Shares" := ((rec.Shares * 4) - Rec."Total Loans Guaranteed");
                            rec."ID No." := cust."ID No.";
                            rec.Date := Today;
                            //rec."Loan Balance" := FnGetPersonGuarantingLoanBal(rec."Member No");
                            rec."Outstanding Balance" := FnGetPersonGuarantingLoanBal(rec."Member No");
                            rec."Self Guarantee" := FnIsSelfGuarantee(rec."Loan No", rec."Member No");
                        end;
                    end;
                }

                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Ambiguous;
                }
                field(Shares; Rec.Shares)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    caption = 'Current Deposits';
                    Editable = false;
                }
                field("Free Shares"; Rec."Free Shares")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Amont Guaranteed"; Rec."Amont Guaranteed")
                {
                    Caption = 'Amount To Guarantee';
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        //rec.CalcFields("Outstanding Balance");
                        if Rec."Free Shares" < Rec."Amont Guaranteed" then begin
                            Error('The Guarantor has no enough Deposits to Guarantee')
                        end
                        else begin
                            rec."Total Amount Guaranteed" := FnRunGetCummulativeAmountGuaranteed(Rec."Loan No");
                        end;

                    end;
                }
                field("Total Amount Guaranteed"; Rec."Total Amount Guaranteed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                }
                field("Self Guarantee"; Rec."Self Guarantee")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Cust: Record Customer;
        EmployeeCode: Code[20];
        RunningBalance: Decimal;
        CStatus: Option Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member","New (Pending Confirmation)","Defaulter Recovery";
        LoanApps: Record "Loans Register";
        StatusPermissions: Record "Status Change Permision";

    local procedure FnGetPersonGuarantingLoanBal(MemberNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        LoanBalTotal: Decimal;
    begin
        LoanBalTotal := 0;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", MemberNo);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance");
        if LoansRegister.Find('-') then begin
            repeat
                LoanBalTotal += LoansRegister."Outstanding Balance";
            until LoansRegister.Next = 0;
        end;
        exit(LoanBalTotal);
    end;

    local procedure FnIsSelfGuarantee(LoanNo: Code[20]; MemberNo: Code[20]): Boolean
    var
        LoansRegister: Record "Loans Register";
    begin
        LoansRegister.Reset;
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        if LoansRegister.Find('-') then begin
            if LoansRegister."Client Code" = MemberNo then begin
                exit(true);
            end;
        end
        else begin
            exit(false);
        end;
    end;

    local procedure FnRunGetCummulativeAmountGuaranteed(VarLoanNo: Code[30]): Decimal
    var
        LoansGuaranteeDetails: Record "Loans Guarantee Details";
    begin
        RunningBalance := 0;

        LoansGuaranteeDetails.Reset;
        LoansGuaranteeDetails.SetRange(LoansGuaranteeDetails."Loan No", VarLoanNo);
        if LoansGuaranteeDetails.FindSet then begin
            repeat
                RunningBalance := RunningBalance + LoansGuaranteeDetails."Amont Guaranteed";
            until LoansGuaranteeDetails.Next = 0;
        end;
    end;
}

