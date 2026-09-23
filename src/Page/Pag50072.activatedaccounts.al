#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50072 activatedaccounts
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption';
    SourceTable = "Account Activation";



    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Type"; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = AType;
                    Caption = 'Account Source';
                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Activation Date"; Rec."Activation Date")
                {
                    ApplicationArea = Basic;
                    Editable = ClosingDateEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = Rmarks;
                }
                field("Captured By"; Rec."Captured By")
                {
                    Style = StrongAccent;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := Documenttype::"Account Reactivation";
                        ApprovalEntries.SetRecordFilters(Database::"Account Activation", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    visible = false;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                    //ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Rec.Status <> Rec.Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //IF ApprovalMgt.SendAccActivateApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel A&pproval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    visible = false;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Rec.Status <> Rec.Status::Open then
                            Error(text001);

                        //End allocate batch number
                        //IF ApprovalMgt.CancelAccActivateApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action(Activate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Activate';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    visible = false;

                    trigger OnAction()
                    begin

                        if Rec.Status <> Rec.Status::Approved then
                            Error('The request must be approved');

                        Rec.TestField("Activation Date");

                        if Rec.Type = Rec.Type::Member then begin

                            if cust.Get(Rec."Client No.") then begin
                                if cust.Status = cust.Status::Active then
                                    Error('This Member Account has already been Activated');


                                if Confirm('Are you sure you want to reactivate this member account?') = false then
                                    exit;



                                cust.Status := cust.Status::Active;
                                cust.Blocked := cust.Blocked::" ";
                                cust.Modify;


                            end;
                        end;

                        if Rec.Type = Rec.Type::Account then begin
                            if Vend.Get(Rec."Client No.") then begin
                                if Vend.Status = Vend.Status::Active then
                                    Error('This Account has already been Activated');


                                if Confirm('Are you sure you want to reactivate this account?') = false then
                                    exit;


                                Vend.Status := Vend.Status::Active;
                                Vend.Blocked := Vend.Blocked::" ";
                                Vend.Modify;

                            end;
                        end;


                        Rec.Activated := true;
                        Rec.Modify;

                        BATCH_TEMPLATE := 'GENERAL';
                        BATCH_NAME := 'ACTIVATE';
                        DOCUMENT_NO := Rec."No.";
                        GenSetup.Get();
                        LineNo := 0;
                        //----------------------------------1.DEBIT TO VENDOR WITH PROCESSING FEE----------------------------------------------
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                        Rec."Client No.", Today, 200, 'FOSA', '', 'Activation fees', '', GenJournalLine."bal. account type"::"G/L Account", '5534');

                        //-------------------------------2.CHARGE EXCISE DUTY----------------------------------------------
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLineBalanced(BATCH_TEMPLATE, BATCH_NAME, DOCUMENT_NO, LineNo, GenJournalLine."transaction type"::"0", GenJournalLine."account type"::Vendor,
                        Rec."Client No.", Today, 20, 'FOSA', '', 'Excise Duty', '', GenJournalLine."bal. account type"::"G/L Account", GenSetup."Excise Duty Account");


                        //Post New
                        Gnljnline.Reset;
                        Gnljnline.SetRange("Journal Template Name", BATCH_TEMPLATE);
                        Gnljnline.SetRange("Journal Batch Name", BATCH_NAME);
                        if Gnljnline.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", Gnljnline);
                            Gnljnline.DeleteAll;
                        end;

                        Message('Account re-activated successfully');
                        //EXIT;




                    end;
                }
                action("Account/Member Page")
                {
                    visible = false;
                    ApplicationArea = Basic;
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Card";
                    RunPageLink = "No." = field("Client No.");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
    end;

    trigger OnOpenPage()
    begin
        //Gnljnline.DELETEALL;
    end;

    var
        Closure: Integer;
        Text001: label 'Not Approved';
        cust: Record Customer;
        UBFRefund: Decimal;
        Generalsetup: Record "Sacco General Set-Up";
        Totalavailable: Decimal;
        UnpaidDividends: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        value2: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Totalrecovered: Decimal;
        Advice: Boolean;
        TotalDefaulterR: Decimal;
        AvailableShares: Decimal;
        Loans: Record "Loans Register";
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        Vendno: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation";
        MNoEditable: Boolean;
        ClosingDateEditable: Boolean;
        ClosureTypeEditable: Boolean;
        AType: Boolean;
        Rmarks: Boolean;
        GenSetup: Record "Sacco General Set-Up";
        SFactory: Codeunit "SURESTEP Factory";
        BATCH_TEMPLATE: Code[100];
        BATCH_NAME: Code[100];
        DOCUMENT_NO: Code[100];
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";


    procedure UpdateControl()
    begin
        if Rec.Status = Rec.Status::Open then begin
            MNoEditable := true;
            ClosingDateEditable := false;
            ClosureTypeEditable := true;
            AType := true;
            Rmarks := true;
        end;

        if Rec.Status = Rec.Status::Pending then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            AType := false;
            Rmarks := true;
        end;

        if Rec.Status = Rec.Status::Rejected then begin
            MNoEditable := false;
            ClosingDateEditable := false;
            ClosureTypeEditable := false;
            AType := false;
            Rmarks := false;
        end;

        if Rec.Status = Rec.Status::Approved then begin
            MNoEditable := false;
            ClosingDateEditable := true;
            AType := false;
            ClosureTypeEditable := false;
            Rmarks := false;
        end;


    end;
}


