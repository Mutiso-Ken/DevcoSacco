#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50369 "Data Sheet Main"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Data Sheet Main";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PF/Staff No"; Rec."PF/Staff No")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field("ID NO."; Rec."ID NO.")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Deduction"; Rec."Type of Deduction")
                {
                    ApplicationArea = Basic;
                }
                field("Amount ON"; Rec."Amount ON")
                {
                    ApplicationArea = Basic;
                }
                field("Amount OFF"; Rec."Amount OFF")
                {
                    ApplicationArea = Basic;
                }
                field("New Balance"; Rec."New Balance")
                {
                    ApplicationArea = Basic;
                }
                field("REF."; Rec."REF.")
                {
                    ApplicationArea = Basic;
                }
                field("Remark/LoanNO"; Rec."Remark/LoanNO")
                {
                    ApplicationArea = Basic;
                }
                field("Sort Code"; Rec."Sort Code")
                {
                    ApplicationArea = Basic;
                }
                field(Employer; Rec.Employer)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Uploaded Interest"; Rec."Uploaded Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field("Principal Amount"; Rec."Principal Amount")
                {
                    ApplicationArea = Basic;
                }
                field(UploadInt; Rec.UploadInt)
                {
                    ApplicationArea = Basic;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field("Shares OFF"; Rec."Shares OFF")
                {
                    ApplicationArea = Basic;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    ApplicationArea = Basic;
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                }
                field("aMOUNT ON 1"; Rec."aMOUNT ON 1")
                {
                    ApplicationArea = Basic;
                }
                field("Vote Code"; Rec."Vote Code")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode; Rec.EDCode)
                {
                    ApplicationArea = Basic;
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = Basic;
                }
                field(TranType; Rec.TranType)
                {
                    ApplicationArea = Basic;
                }
                field(TranName; Rec.TranName)
                {
                    ApplicationArea = Basic;
                }
                field("Action"; Rec.Action)
                {
                    ApplicationArea = Basic;
                }
                field("Interest Fee"; Rec."Interest Fee")
                {
                    ApplicationArea = Basic;
                }
                field(Recoveries; Rec.Recoveries)
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Off"; Rec."Interest Off")
                {
                    ApplicationArea = Basic;
                }
                field("Repayment Method"; Rec."Repayment Method")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate DataSHEET")
            {
                ApplicationArea = Basic;
                Caption = 'Generate Data SHEET';
                Image = process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    DataSheet.Reset;
                    if DataSheet.Find('-') then begin
                        DataSheet.DeleteAll;
                    end;

                    IssuedDatetel := 20161019D;
                    loansAppz.Reset;
                    loansAppz.SetRange(loansAppz."Loan Status", loansAppz."loan status"::Issued);
                    loansAppz.SetRange(loansAppz."Recovery Mode", loansAppz."recovery mode"::Checkoff);
                    loansAppz.SetFilter(loansAppz."Issued Date", '>%1', IssuedDatetel);
                    loansAppz.SetFilter(loansAppz."Approved Amount", '>%1', 0);
                    if loansAppz.Find('-') then begin
                        repeat

                            loansAppz.CalcFields(loansAppz."Outstanding Balance");
                            DataSheet.Init;


                            Cust.Reset;
                            Cust.SetRange(Cust."No.", loansAppz."Client Code");
                            if Cust.Find('-') then begin
                                DataSheet."PF/Staff No" := Cust."Payroll/Staff No";
                                DataSheet.Name := loansAppz."Client Name";
                            end;

                            LoanTypes.Reset;
                            LoanTypes.SetRange(LoanTypes.Code, loansAppz."Loan Product Type");
                            if LoanTypes.Find('-') then begin
                                DataSheet."Type of Deduction" := LoanTypes."Product Description";
                            end;
                            DataSheet."Remark/LoanNO" := loansAppz."Loan  No.";

                            DataSheet."ID NO." := Cust."ID No.";
                            DataSheet."Amount ON" := (loansAppz."Approved Amount" / loansAppz.Installments);
                            //DataSheet."Amount OFF":=xRec.Repayment;


                            DataSheet."REF." := '2026';
                            DataSheet."New Balance" := loansAppz."Outstanding Balance";
                            DataSheet.Date := loansAppz."Issued Date";
                            DataSheet.Date := Today;
                            DataSheet.Employer := loansAppz."Employer Code";
                            DataSheet.Installments := Format(loansAppz.Installments);
                            //DataSheet.Employer:=EmployerName;
                            DataSheet."Transaction Type" := DataSheet."transaction type"::"FRESH FEED";
                            //DataSheet."Sort Code":=PTEN;
                            DataSheet.Insert(true);

                        until loansAppz.Next = 0;
                    end;
                    Message('Data Sheet Generated Successfully');
                    //END;
                end;
            }
            action("Validate Data Sheet")
            {
                ApplicationArea = Basic;
                Caption = 'Validate Data Sheet';
                Image = "process ";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Modify Datasheet";
            }
            action("Round Up Datasheet")
            {
                ApplicationArea = Basic;
                Caption = 'Round Up Datasheet';
                Image = process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Round Up Datasheet";
            }
            action("DATASHEET REPORT")
            {
                ApplicationArea = Basic;
                Caption = 'DATASHEET REPORT';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Data Sheet Main-Telkom";

                trigger OnAction()
                begin


                end;
            }
        }
    }

    var
        LoanType: Record "Loan Products Setup";
        i: Integer;
        PeriodDueDate: Date;
        ScheduleRep: Record "Loan Repayment Schedule";
        RunningDate: Date;
        G: Integer;
        IssuedDate: Date;
        GracePeiodEndDate: Date;
        InstalmentEnddate: Date;
        GracePerodDays: Integer;
        InstalmentDays: Integer;
        NoOfGracePeriod: Integer;
        NewSchedule: Record "Loan Repayment Schedule";
        RSchedule: Record "Loan Repayment Schedule";
        GP: Text[30];
        ScheduleCode: Code[20];
        PreviewShedule: Record "Loan Repayment Schedule";
        PeriodInterval: Code[10];
        CustomerRecord: Record Customer;
        Gnljnline: Record "Gen. Journal Line";
        // Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[10];
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        TestAmt: Decimal;
        CustRec: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        GenSetUp: Record "Sales & Receivables Setup";
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        LoansR: Record "Loans Register";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Decimal;
        RepayInterval: DateFormula;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[40];
        GrPrinciple: Integer;
        GrInterest: Integer;
        QPrinciple: Decimal;
        QCounter: Integer;
        InPeriod: DateFormula;
        InitialInstal: Integer;
        InitialGraceInt: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        FOSAComm: Decimal;
        BOSAComm: Decimal;
        //GLPosting: Codeunit "Gen. Jnl.-Post Line";
        LoanTopUp: Record "Loan Offset Details";
        Vend: Record Vendor;
        BOSAInt: Decimal;
        TopUpComm: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        UsersID: Record User;
        TotalTopupComm: Decimal;
        Notification: Codeunit Mail;
        CustE: Record Customer;
        DocN: Text[50];
        DocM: Text[100];
        DNar: Text[250];
        DocF: Text[50];
        MailBody: Text[250];
        ccEmail: Text[250];
        LoanG: Record "Loans Guarantee Details";
        SpecialComm: Decimal;
        FOSAName: Text[150];
        IDNo: Code[50];
        ApprovalUsers: Record "Approvals Users Set Up";
        MovementTracker: Record "Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Special Loan Clearances";
        SMSMessage: Record Customer;
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        Disbursement: Record "Loan Disburesment-Batching";
        Vendor: Record Vendor;
        LoanTypes: Record "Loan Products Setup";
        DataSheet: Record "Data Sheet Main";
        IssuedDatetel: Date;
        loansAppz: Record "Loans Register";
}

