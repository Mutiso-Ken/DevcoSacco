Page 50320 "Loan Application CardAdvances"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'FOSA Loans Posting Card';
    Editable = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Source = const(FOSA),
                            Posted = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;

                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'FOSA Account No';
                    Editable = MNoEditable;
                    Style = StrongAccent;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("ID NO"; Rec."ID NO")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Editable = LProdTypeEditable;
                    Style = StrongAccent;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Editable = AppliedAmountEditable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);

                    end;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = false;
                    Style = Unfavorable;


                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = Basic;
                    Editable = Interrest;
                }

                field("Main Sector"; Rec."Main Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Sub-Sector"; Rec."Sub-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Specific Sector"; Rec."Specific Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    Editable = MNoEditable;
                }
                field("Repayment Method"; Rec."Repayment Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = LoanStatusEditable;

                    trigger OnValidate()
                    begin
                        UpdateControl();

                    end;
                }

                field("Top Up Amount"; Rec."Top Up Amount")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Total TopUp Commission"; Rec."Total TopUp Commission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    Style = StrongAccent;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No';
                    Editable = false;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                Caption = 'FOSA Loan Guarantor Details';
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = false;
            }
            part("Loan Collateral Security"; "Loan Collateral Security")
            {
                Caption = 'Loan Collateral Security Details';
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = false;
            }
            part("Loan Appraisal Salary Details"; "Loan Appraisal Salary Details")
            {
                Caption = 'Loan Appraisal Salary Details';
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = false;
            }
        }
        area(factboxes)
        {
            part("FOSA Statistics FactBox"; "FOSA Statistics FactBox")
            {
                SubPageLink = "No." = field("Account No");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan)
            {
                Caption = 'Loan';
                Image = AnalysisView;

                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin

                        if (Rec."Repayment Start Date" = 0D) then
                            Error('Please enter Disbursement Date to continue');
                        SFactory.FnGenerateRepaymentSchedule(Rec."Loan  No.");

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(50477, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action9)
                {
                }
            }
            group(POSTING)
            {
                action(POST)
                {

                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = PrintChecklistReport;
                    trigger OnAction()
                    begin
                        If FnCanPostLoans(UserId) = false then begin
                            //   if (UserId <> 'MMHSACCO\SMUTUMA') and (UserId <> 'MMHSACCO\JKANANU') and (UserId <> 'MMHSACCO\BENKOBIA') then begin
                            Error('Denied! You are not allowed to Post Loans')
                        end;
                        if Rec."Loan Product Type" = 'OVERDRAFT' THEN begin
                            Error('Use Overdraft Loans Menu to disburse');
                        end;
                        if Rec."Loan Product Type" = 'OKOA' THEN begin
                            Error('Use OKOA Biashara Loans Menu to disburse');
                        end;
                        if Rec."Mode of Disbursement" <> Rec."Mode of Disbursement"::Cheque then begin
                            Error('Prohibited ! Mode of disbursement cannot be ' + Format(Rec."Mode of Disbursement"));
                        end;
                        if Rec.Posted = true then begin
                            Error('Prohibited ! The loan is already Posted');
                        end;
                        if Rec."Loan Status" <> Rec."Loan Status"::Approved then begin
                            Error('Prohibited ! The loan is Status MUST be Approved');
                        end;
                        if Confirm('Are you sure you want to POST Loan Approved amount of Ksh. ' + Format(Rec."Approved Amount") + ' to member -' + Format(Rec."Client Name") + ' ?', false) = false then begin
                            exit;
                        end else begin
                            TemplateName := 'PAYMENTS';
                            BatchName := 'LOANS';
                            FnPostFOSALoans();//Insert Lines
                            // if UserId = 'MMHSACCO\CMUTHAURA' then begin
                            //     exit;
                            // end;
                            GenJournalLine.RESET;
                            GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
                            GenJournalLine.SETRANGE("Journal Batch Name", BatchName);
                            if GenJournalLine.Find('-') then begin
                                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
                                FnSendNotifications();//Send Notifications
                                Rec."Loan Status" := Rec."Loan Status"::Issued;
                                Rec.Posted := true;
                                Rec."Posted By" := UserId;
                                Rec."Posting Date" := Today;
                                Rec."Issued Date" := Rec."Loan Disbursement Date";
                                Rec."Approval Status" := Rec."Approval Status"::Approved;
                                // "Loans Category-SASRA" := "Loans Category-SASRA"::Perfoming;
                                Rec.Modify();
                                //...................Recover Overdraft Loan On Loan
                                SFactory.FnRecoverOnLoanOverdrafts(Rec."Client Code");
                                //.................................................
                                Message('Loan has successfully been posted and member notified');
                                CurrPage.close();
                            end;
                        end;
                    end;
                }

            }
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                // PromotedIsBig = true;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }

            action("OffsetLoan")
            {
                ApplicationArea = Basic;
                Caption = 'Offseted Loan';
                Enabled = true;
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Loan Offset Detail List";
                RunPageLink = "Loan No." = FIELD("Loan  No."), "Client Code" = FIELD("Client Code");
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        LoanAppPermisions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Source := Rec.Source::FOSA;
        Rec."Mode of Disbursement" := Rec."mode of disbursement"::Cheque;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        if Rec."Loan Status" = Rec."loan status"::Approved then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Posted, false);
        if
        Rec."Mode of Disbursement" <> Rec."Mode of Disbursement"::Cheque then begin
            Rec."Mode of Disbursement" := Rec."Mode of Disbursement"::Cheque;
            rec.Modify();
        end;
    end;

    var
        iEntryNo: Integer;
        VEND1: Record Vendor;
        LoanGuar: Record "Loans Guarantee Details";
        SMSMessage: Record "SMS Messages";
        SMSMessages: Record "SMS Messages";
        i: Integer;
        LoanType: Record "Loan Products Setup";
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
        Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[15];
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
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        LoanTopUp: Record "Loan Offset Details";
        Vend: Record Vendor;
        BOSAInt: Decimal;
        TopUpComm: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        TotalTopupComm: Decimal;
        Notification: Codeunit Mail;
        CustE: Record Customer;
        DocN: Text[50];
        DocM: Text[100];
        DNar: Text[250];
        DocF: Text[50];
        MailBody: Text[250];
        ccEmail: Text[250];
        LoanG: Record "Loans Register";
        SpecialComm: Decimal;
        FOSAName: Text[150];
        IDNo: Code[50];
        MovementTracker: Record "File Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Loan Offset Details";
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        SalDetails: Record "Loan Appraisal Salary Details";
        LGuarantors: Record "Loans Guarantee Details";
        Text001: label 'Status Must Be Open';
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        CurrpageEditable: Boolean;
        LoanStatusEditable: Boolean;
        MNoEditable: Boolean;
        ApplcDateEditable: Boolean;
        LProdTypeEditable: Boolean;
        InstallmentEditable: Boolean;
        AppliedAmountEditable: Boolean;
        ApprovedAmountEditable: Boolean;
        RepayMethodEditable: Boolean;
        RepaymentEditable: Boolean;
        BatchNoEditable: Boolean;
        RepayFrequencyEditable: Boolean;
        ModeofDisburesmentEdit: Boolean;
        DisbursementDateEditable: Boolean;
        Interrest: Boolean;
        InterestSal: Decimal;
        TemplateName: Code[100];
        BatchName: Code[100];
        NetIncome: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        compinfo: Record "Company Information";
        Text002: label 'The Loan has already been approved';
        ApprovalEntries: Record "Approval Entry";
        ApprovalEntry: Record "Approval Entry";
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan;
        SFactory: Codeunit "SURESTEP Factory";
        CancelApprovalEnabled: Boolean;
        SendApprovalEnabled: Boolean;


    procedure UpdateControl()
    begin
        if Rec."Loan Status" = Rec."loan status"::Application then begin
            CancelApprovalEnabled := false;
            SendApprovalEnabled := true;
            MNoEditable := true;
            ApplcDateEditable := true;
            LoanStatusEditable := false;
            LProdTypeEditable := true;
            InstallmentEditable := true;
            NetIncome := true;
            Interrest := false;
            AppliedAmountEditable := true;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
        end;

        if Rec."Loan Status" = Rec."loan status"::Appraisal then begin
            CancelApprovalEnabled := true;
            SendApprovalEnabled := false;
            MNoEditable := false;
            ApplcDateEditable := true;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            Interrest := false;
            NetIncome := true;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
        end;

        if Rec."Loan Status" = Rec."loan status"::Rejected then begin
            CancelApprovalEnabled := false;
            SendApprovalEnabled := true;
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            NetIncome := false;
            Interrest := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := false;
            DisbursementDateEditable := false;
        end;

        if Rec."Loan Status" = Rec."loan status"::Approved then begin
            SendApprovalEnabled := false;
            CancelApprovalEnabled := false;
            MNoEditable := false;
            LoanStatusEditable := false;
            ApplcDateEditable := false;
            Interrest := false;
            LProdTypeEditable := false;
            NetIncome := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := true;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
        end;
    end;


    procedure LoanAppPermisions()
    begin
    end;

    local procedure FnSendNotifications()
    var
        msg: Text[250];
        PhoneNo: Text[250];
    begin
        LoansR.Reset();
        LoansR.SetRange(LoansR."Loan  No.", Rec."Loan  No.");
        if LoansR.Find('-') then begin
            msg := '';
            msg := 'Dear Member, Your ' + Format(LoansR."Loan Product Type") + ' loan application of KSHs.' + Format(Rec."Requested Amount") + ' has been processed and deposited to your FOSA Account.Jamii Yetu Sacco.';
            PhoneNo := FnGetPhoneNo(Rec."Client Code");
            SendSMSMessage(Rec."Client Code", msg, PhoneNo);
        end;
    end;

    local procedure SendSMSMessage(BOSANo: Code[20]; msg: Text[250]; PhoneNo: Text[250])
    begin
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        //--------------------------------------------------
        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := BOSANo;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MOBILETRAN';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := msg;
        SMSMessages."Telephone No" := PhoneNo;
        SMSMessages.Insert;
    end;

    local procedure FnGetPhoneNo(ClientCode: Code[50]): Text[250]
    var
        Member: Record Customer;
        Vendor: Record Vendor;
    begin
        Member.Reset();
        Member.SetRange(Member."FOSA Account", ClientCode);
        if Member.Find('-') = true then begin
            if (Member."Mobile Phone No." <> '') or (Member."Mobile Phone No." <> '0') then begin
                exit(Member."Mobile Phone No.");
            end;
            if (Member."Mobile Phone No" <> '') or (Member."Mobile Phone No" <> '0') then begin
                exit(Member."Mobile Phone No");
            end;
            if (Member."Phone No." <> '') or (Member."Phone No." <> '0') then begin
                exit(Member."Phone No.");
            end;
            Vendor.Reset();
            Vendor.SetRange(Vendor."No.", ClientCode);
            if Vendor.Find('-') then begin
                if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                    exit(Vendor."Mobile Phone No.");
                end;
                if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                    exit(Vendor."Mobile Phone No");
                end;
                if (Vendor."MPESA Mobile No" <> '') or (Vendor."MPESA Mobile No" <> '0') then begin
                    exit(Vendor."MPESA Mobile No");
                end;
            end;

        end else
            if Member.find('-') = false then begin
                Vendor.Reset();
                Vendor.SetRange(Vendor."BOSA Account No", ClientCode);
                if Vendor.Find('-') then begin
                    if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                        exit(Vendor."Mobile Phone No.");
                    end;
                    if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                        exit(Vendor."Mobile Phone No");
                    end;
                    if (Vendor."MPESA Mobile No" <> '') or (Vendor."MPESA Mobile No" <> '0') then begin
                        exit(Vendor."MPESA Mobile No");
                    end;
                end;
            end;
    end;

    local procedure FnPostFOSALoans()
    var
        EndMonth: Date;
        RemainingDays: Integer;
        TMonthDays: Integer;
        Sfactorycode: Codeunit "SURESTEP Factory";
    begin
        //--------------------Generate Schedule
        Sfactorycode.FnGenerateRepaymentSchedule(Rec."Loan  No.");
        //....................PRORATED DAYS
        EndMonth := CALCDATE('-1D', CALCDATE('1M', DMY2DATE(1, DATE2DMY(Today, 2), DATE2DMY(Today, 3))));
        RemainingDays := (EndMonth - Today) + 1;
        TMonthDays := DATE2DMY(EndMonth, 1);
        //....................Ensure that If Batch doesnt exist then create
        IF NOT GenBatch.GET(TemplateName, BatchName) THEN BEGIN
            GenBatch.INIT;
            GenBatch."Journal Template Name" := TemplateName;
            GenBatch.Name := BatchName;
            GenBatch.INSERT;
        END;
        //....................Reset General Journal Lines
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", BatchName);
        GenJournalLine.DELETEALL;
        //....................Loan Posting Lines
        GenSetUp.GET;
        DActivity := '';
        DBranch := '';
        IF Vend.GET(Rec."Client Code") THEN BEGIN
            DActivity := Vend."Global Dimension 1 Code";
            DBranch := Vend."Global Dimension 2 Code";
        END;
        //**************Loan Principal Posting**********************************
        LineNo := LineNo + 10000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := Rec."Client Code";
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Document No." := Rec."Loan  No.";
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Loan Principle Amount' + Format(Rec."Loan  No.");
        GenJournalLine.Amount := Rec."Approved Amount";
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Loan;
        GenJournalLine."Loan No" := Rec."Loan  No.";
        GenJournalLine."Group Code" := Rec."Group Code";
        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //****************************Credit FOSA Account The Loan Amount
        LineNo := LineNo + 10000;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document No." := Rec."Loan  No.";
        GenJournalLine."Posting Date" := Today;
        GenJournalLine."External Document No." := Rec."Loan  No.";
        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
        GenJournalLine."Account No." := Rec."Account No";
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        GenJournalLine.Description := Rec."Loan Product Type" + ' Loan-' + Format(Rec."Loan  No.");
        GenJournalLine.Amount := (Rec."Approved Amount") * -1;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //-------------Recover Interst of all FOSA loans (Check with Credit Department)
        IF LoanType.Get(Rec."Loan Product Type") then begin
            if LoanType."Charge Interest Upfront" = true then begin
                LineNo := LineNo + 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := TemplateName;
                GenJournalLine."Journal Batch Name" := BatchName;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No." := Rec."Account No";
                GenJournalLine."Document No." := Rec."Loan  No.";
                GenJournalLine."External Document No." := Rec."Loan  No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := 'Upfront Interest Recovered-' + Format(Rec."Loan  No.");
                GenJournalLine.Amount := (Rec."Approved Amount" * (Rec.Interest / 100));
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                if LoanType.Get(Rec."Loan Product Type") then begin
                    GenJournalLine."Bal. Account No." := LoanType."Loan Interest Account";
                end;
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                GenJournalLine."Shortcut Dimension 2 Code" := Sfactorycode.FnGetMemberBranch(Rec."BOSA No");
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
            END;
        end;
        //--------------------------------RECOVER OVERDRAFT()-------------------------------------------------------
        //Code Here
        //***************************Loan Product Charges code
        PCharges.Reset();
        PCharges.SETRANGE(PCharges."Product Code", Rec."Loan Product Type");
        IF PCharges.FIND('-') THEN BEGIN
            REPEAT
                PCharges.TESTFIELD(PCharges."G/L Account");
                LineNo := LineNo + 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := TemplateName;
                GenJournalLine."Journal Batch Name" := BatchName;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No." := PCharges."G/L Account";
                GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                GenJournalLine."Document No." := Rec."Loan  No.";
                GenJournalLine."External Document No." := Rec."Loan  No.";
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := PCharges.Description + '-' + Format(Rec."Loan  No.");
                IF PCharges."Use Perc" = TRUE THEN BEGIN
                    GenJournalLine.Amount := (Rec."Approved Amount" * (PCharges.Percentage / 100)) * -1
                END ELSE
                    IF PCharges."Use Perc" = false then begin
                        GenJournalLine.Amount := PCharges.Amount * -1;
                    end;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                GenJournalLine."Bal. Account No." := Rec."Account No";
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
            UNTIL PCharges.NEXT = 0;
        END;
        //...................Cater for Loan Offset Now !
        Rec.CalcFields("Top Up Amount");
        if Rec."Top Up Amount" > 0 then begin
            LoanTopUp.RESET;
            LoanTopUp.SETRANGE(LoanTopUp."Loan No.", Rec."Loan  No.");
            IF LoanTopUp.FIND('-') THEN BEGIN
                REPEAT//Maybe there are multiple topup loans
                    //Principle
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := Rec."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine."External Document No." := Rec."Loan  No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    GenJournalLine."Account No." := Rec."Client Code";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine.Description := 'Loan OffSet By - ' + Rec."Loan  No.";
                    GenJournalLine.Amount := LoanTopUp."Principle Top Up" * -1;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //****************************Debit Vendor To pay loan principle*******************************
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := Rec."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine."External Document No." := Rec."Loan  No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := Rec."Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine.Description := 'Loan offset Principal to loan-' + LoanTopUp."Loan Top Up" + '-' + LoanTopUp."Loan Type";
                    GenJournalLine.Amount := LoanTopUp."Principle Top Up";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //..................Recover Interest On Top Up
                    IF LoanType.GET(Rec."Loan Product Type") THEN BEGIN
                        LineNo := LineNo + 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := TemplateName;
                        GenJournalLine."Journal Batch Name" := BatchName;
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                        GenJournalLine."Account No." := Rec."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine."Document No." := Rec."Loan  No.";
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Interest Due Paid on top up';
                        GenJournalLine.Amount := -LoanTopUp."Interest Top Up";
                        GenJournalLine."External Document No." := Rec."Loan  No.";
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                        IF GenJournalLine.Amount <> 0 THEN
                            GenJournalLine.INSERT;
                    END;
                    //Recover Loan Interest From FOSA Account
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := Rec."Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := Rec."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Loan offset Interest to loan-' + LoanTopUp."Loan Top Up" + '-' + LoanTopUp."Loan Type";
                    GenJournalLine.Amount := LoanTopUp."Interest Top Up";
                    GenJournalLine."External Document No." := Rec."Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //Recover Commission on topup
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine."Account No." := '5411';
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := Rec."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Commission on ' + format(LoanTopUp."Loan No.") + ' Loan Offset';
                    GenJournalLine.Amount := -LoanTopUp.Commision;
                    GenJournalLine."External Document No." := Rec."Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //Recover Loan Interest From FOSA Account
                    LineNo := LineNo + 10000;
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Account No." := Rec."Account No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Document No." := Rec."Loan  No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Commission Charged on ' + format(LoanTopUp."Loan No.") + ' Loan Offset';
                    GenJournalLine.Amount := LoanTopUp.Commision;
                    GenJournalLine."External Document No." := Rec."Loan  No.";
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Loan No" := LoanTopUp."Loan Top Up";
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                UNTIL LoanTopUp.NEXT = 0;
            END;
        end;

        //end of code
    end;

    local procedure FnCanPostLoans(UserId: Text): Boolean
    var
        UserSetUp: Record "User Setup";
    begin
        if UserSetUp.get(UserId) then begin
            if UserSetUp."Can POST Loans" = true then begin
                exit(true);
            end;
        end;
        exit(false);
    end;

}

