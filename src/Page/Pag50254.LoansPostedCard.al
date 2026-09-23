#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50254 "Loans Posted Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Source = filter(BOSA),
                            Posted = const(true));

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
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member';
                    Editable = MNoEditable;
                    Style = StrongAccent;

                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Editable = AccountNoEditable;
                    Style = StrongAccent;
                    Visible = false;
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
                    Visible = false;
                }
                field("Member Deposits"; Rec."Member Deposits")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No';
                    Editable = false;
                    Visible = false;

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
                    Style = Unfavorable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }

                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    //Editable = ApplcDateEditable;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        //TestField(Posted, false);
                    end;
                }

                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                    Editable = InstallmentEditable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Approved Repayment"; Rec."Approved Repayment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = ApprovedAmountEditable;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Repayment Method"; Rec."Repayment Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = Basic;
                    Editable = RepaymentEditable;
                }

                field("Loan Principle Repayment"; Rec."Loan Principle Repayment")
                {
                    Editable = false;
                    ApplicationArea = all;
                }

                field("Loan Interest Repayment"; Rec."Loan Interest Repayment")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Oustanding Interest"; Rec."Oustanding Interest")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = Unfavorable;

                }
                field("Principal In Arrears"; Rec."Principal In Arrears")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = Unfavorable;
                }
                field("Interest In Arrears"; Rec."Interest In Arrears")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Style = Unfavorable;
                }

                field("Appeal Amount"; Rec."Appeal Amount")
                {
                    Editable = false;
                    ApplicationArea = all;
                    visible = false;
                }
                field("Appeal Date"; Rec."Appeal Date")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Loan Purpose"; Rec."Loan Purpose")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = true;

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
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic;
                    Editable = BatchNoEditable;
                    Visible = false;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Top Up Amount"; Rec."Top Up Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bridged Amount';
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    Editable = RepayFrequencyEditable;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {

                    Editable = false;
                    ApplicationArea = all;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;


                    trigger OnValidate()
                    begin
                        if StrLen(Rec."Cheque No.") > 6 then
                            Error('Document No. cannot contain More than 6 Characters.');
                    end;
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
                field("External EFT"; Rec."External EFT")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }


                field("Total TopUp Commission"; Rec."Total TopUp Commission")
                {
                    ApplicationArea = Basic;

                    Editable = false;
                }
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ApplicationArea = all;
                    Editable = true;
                }

                field("Rejection  Remark"; Rec."Rejection  Remark")
                {
                    ApplicationArea = Basic;
                    Editable = RejectionRemarkEditable;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000002; "Loan Appraisal Salary Details")
            {
                Caption = 'Salary Details';
                SubPageLink = "Loan No" = field("Loan  No."),
                              "Client Code" = field("Client Code");
                ApplicationArea = Basic;
                Editable = false;
            }
            part(Control1000000004; "Loans Guarantee Details")
            {
                Caption = 'Guarantors  Detail';
                SubPageLink = "Loan No" = field("Loan  No.");
                ApplicationArea = Basic;
                Editable = false;
            }
            part(Control1000000005; "Loan Collateral Security")
            {
                Caption = 'Other Securities';
                SubPageLink = "Loan No" = field("Loan  No.");
                ApplicationArea = Basic;
                Editable = false;
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

                action("Loan Application Form")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Application Form';
                    Enabled = true;
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(50022, true, false, LoanApp);
                        end;
                    end;
                }
                action("Reschedule Loan")
                {
                    ApplicationArea = Basic;
                    Image = RefreshVATExemption;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        myInt: Integer;
                    begin
                        if not Rescheduled then begin
                            if Confirm('Are you sure you want to reshedule this Loan?', false) = true then begin
                                Rec."Reschedule by" := UserId;
                                Rec.Rescheduled := true;
                                Rec.Modify();
                            end
                        end else begin
                            Message('This Loan is already Rescheduled.');
                        end;

                    end;
                }
                action("Re Appraise Loan")
                {
                    RunObject = report "Loan Appraisal";
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        Loaapp: Record "Loans Register";
                    begin
                        Loaapp.Reset();
                        Loaapp.SetRange(Loaapp."Loan  No.", rec."Loan  No.");
                        if Loaapp.FindSet() then begin
                            repeat
                                Report.Run(Report::"Loan Appraisal", false, false, Loaapp);
                            until Loaapp.Next() = 0;
                        end;
                    end;
                }
                action("Member Page")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Page';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Card";
                    RunPageLink = "No." = field("BOSA No");
                }
                action("Member Statement")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    Caption = 'Detailed Member Statement';
                    PromotedCategory = "process";
                    Image = report;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."Client Code");
                        Report.Run(50223, true, false, Cust);
                    end;
                }
                action("Loan Statement")
                {
                    ApplicationArea = Basic;
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = process;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."Client Code");
                        Cust.SetFilter(Cust."Loan Product Filter", Rec."Loan Product Type");
                        Cust.SetFilter(Cust."Loan No. Filter", Rec."Loan  No.");
                        Report.Run(50227, true, false);
                    end;
                }
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = "process";
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        if Rec.Posted then
                            SFactory.FnGenerateRepaymentSchedule(Rec."Loan  No.");

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(50477, true, false, LoanApp);
                        end;
                    end;
                }


                separator(Action1102755012)
                {
                }
                action("Loans Appeal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans to Appeal';
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Appeal List";
                    RunPageLink = "Loan Number" = field("Loan  No.");

                }

                 action("Send Loan Defaulter")
                {
                    ApplicationArea = Basic;
                    Image = SendEmailPDF;
               Promoted = true;
               PromotedIsBig = true;
               PromotedOnly = true;
               PromotedCategory = Process;

                      trigger OnAction()
                begin
                    FnSendD2Email;
                end;

                }

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
        Rec.Source := Rec.Source::BOSA;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        /*IF "Loan Status"="Loan Status"::Approved THEN
        CurrPage.EDITABLE:=FALSE; */

    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Posted, true);
        /*IF "Loan Status"="Loan Status"::Approved THEN
        CurrPage.EDITABLE:=FALSE;*/

    end;

    var
        Text001: label 'Status Must Be Open';
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
        //Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
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
        MovementTracker: Record "Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Loan Special Clearance";
        SMSMessage: Record Customer;
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        Disbursement: Record "Loan Disburesment-Batching";
        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loans Register";
        SalDetails: Record "Loan Appraisal Salary Details";
        LGuarantors: Record "Loans Guarantee Details";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Imprest,ImprestSurrender,Interbank;
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
        AccountNoEditable: Boolean;
        LNBalance: Decimal;
        ApprovalEntries: Record "Approval Entry";
        RejectionRemarkEditable: Boolean;
        ApprovalEntry: Record "Approval Entry";
        Overdue: Option Yes," ";
        SFactory: Codeunit "SURESTEP Factory";


    procedure UpdateControl()
    begin

        if Rec."Loan Status" = Rec."loan status"::Application then begin
            MNoEditable := true;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := true;
            InstallmentEditable := true;
            AppliedAmountEditable := true;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
        end;

        if Rec."Loan Status" = Rec."loan status"::Appraisal then begin
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
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
            MNoEditable := false;
            AccountNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := false;
            DisbursementDateEditable := false;
            RejectionRemarkEditable := false
        end;

        if Rec."Approval Status" = Rec."approval status"::Approved then begin
            MNoEditable := false;
            AccountNoEditable := false;
            LoanStatusEditable := false;
            ApplcDateEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := true;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
            RejectionRemarkEditable := false;
        end;
    end;


    procedure LoanAppPermisions()
    begin
    end;

 procedure FnSendD2Email()
    var
        MemberReg: Record Customer;
        FileName: Text[200];
        FileName2: Text[200];
        FileType: Text[100];
        SendEmailTo: Text[100];
        EmailBody: Text[1000];
        EmailSubject: Text[100];
        membersreg: Record Customer;
        Outstr: OutStream;
        Instr: InStream;
        Outstr2: OutStream;
        Instr2: InStream;
        TempBlob: Codeunit "Temp Blob";
        Receipt: Record "Loans Register";
        MailToSend: Codeunit "Email Message";
        GenerateDoc: InStream; //Generate PDF/Document to be sent 
        EncodeStream: Codeunit "Base64 Convert"; //To encode the stream of data form GenerateDoc
        FnEmail: Codeunit Email;
        DialogBox: Dialog;
        reportrun: Report "Loan Defaulter 2nd Notice";
        reportparameters: text;
        ReportTable: Record "Payroll Employee.";
        CompanyInfo: Record "Company Information";
        PeriodDate: Record "Payroll Calender.";

    begin
        if Confirm('Are you sure you want to Send Demand Letter to ' + Format(Receipt."Client Name") + '?', false) = false then begin
            Message('Aborted');
            exit
        end else begin


            DialogBox.Open('Sending Defaulter to  ' + Format(Receipt."Client Name"));
            //------------------->Get Key Details of Send Email
            SendEmailTo := '';
            SendEmailTo := FnGetClientCodeEmail(Rec."Client Code");
            EmailSubject := '';
            EmailSubject := '2nd Default Notice';

            EmailBody := 'Dear <b>' + Format(Rec."Client Name") + '</b>,</br></br>' +
            'We hope this email finds you well. Please find attached your Default.' +
                Companyinfo.Name + '</br> ' + Companyinfo.Address + '</br> ' + Companyinfo.City + '</br>' +
           Companyinfo."Post Code" + '</br>' + Companyinfo."Country/Region Code" + '</br>' +
            Companyinfo."Phone No." + '</br> ' + Companyinfo."E-Mail";
            //------------------->Generate The Report Attachments To Send
            //---------Attachment 1
            reportparameters := reportrun.RunRequestPage();
            //reportparameters :=  format("No.") + Format( "Payroll Period");
            FileName := '-2ndD-mand-Notice.pdf';
            TempBlob.CreateOutStream(Outstr);
            Report.SaveAs(Report::"Loan Defaulter 2nd Notice", reportparameters, ReportFormat::Pdf, Outstr);
            TempBlob.CreateInStream(Instr);
            //------------------->Create Emails Start
            MailToSend.Create(SendEmailTo, EmailSubject, EmailBody, true);
            MailToSend.AddAttachment(FileName, FileType, Instr);
            //.........................................
            FnEmail.Send(MailToSend);
            DialogBox.Close();
            Message('Email Send to %1 Succesfully', Rec."Client Name");
        end;
    end;


 local procedure FnGetClientCodeEmail(ClientCode: Code[50]): Text[100]
    var
        LoanlEmp: Record "Loans Register";
        Cust: Record "Customer";
    begin
        LoanlEmp.Reset();
       LoanlEmp.SetRange(LoanlEmp."Client Code", ClientCode);
        if LoanlEmp.Find('-') then begin
            exit(Cust."E-mail");
        end;
    end;
}

