#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50291 "PGuarantor Sub Card"

{
    PageType = Card;
    Caption = 'Proccesed Guarantor substituion';
    SourceTable = "Guarantorship Substitution H";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Loanee Member No"; "Loanee Member No")
                {
                    ApplicationArea = Basic;
                    Editable = LoaneeNoEditable;
                }
                field("Loanee Name"; "Loanee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Guaranteed"; "Loan Guaranteed")
                {
                    ApplicationArea = Basic;
                    Editable = LoanGuaranteedEditable;
                }
                field("Substituting Member"; "Substituting Member")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member to be substuted';
                    Editable = SubMemberEditable;
                }
                field("Substituting Member Name"; "Substituting Member Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field("Commited Amount"; "Commited Amount")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Substituted; Substituted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Substituted"; "Date Substituted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Substituted By"; "Substituted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000014; "Guarantor Sub Subform")
            {
                SubPageLink = "Document No" = field("Document No"),
                              "Member No" = field("Substituting Member"),
                              "Loan No." = field("Loan Guaranteed");
                Editable = false;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        FNAddRecordRestriction();
        Controls();
    end;

    trigger OnAfterGetRecord()
    begin
        FNAddRecordRestriction();
        Controls();
    end;

    trigger OnOpenPage()
    begin
        "Application Date" := Today;
        Controls();

        Permision.RESET;
        Permision.SETRANGE(Permision."User ID", USERID);
        Permision.SETRANGE(Permision."Function", Permision."Function"::"Replace Guarantors");
        IF Permision.FIND('-') = FALSE THEN
            ERROR('You do not have permissions to  open this Card.');
    end;

    var
        LGuarantor: Record "Loans Guarantee Details";
        Permision: Record "Status Change Permision";
        GSubLine: Record "Guarantorship Substitution L";
        LoaneeNoEditable: Boolean;
        LoanGuaranteedEditable: Boolean;
        SubMemberEditable: Boolean;
        TotalReplaced: Decimal;
        Commited: Decimal;
        SendApproval: Boolean;
        AllowPosting: Boolean;
        CancelApproval: Boolean;
        NewLGuar: Record "Loans Guarantee Details";

    local procedure FNAddRecordRestriction()
    begin
        if Status = Status::Open then begin
            LoaneeNoEditable := true;
            LoanGuaranteedEditable := true;
            SubMemberEditable := true

        end else
            if Status = Status::Pending then begin
                LoaneeNoEditable := false;
                LoanGuaranteedEditable := false;
                SubMemberEditable := false
            end else
                if Status = Status::Approved then begin
                    LoaneeNoEditable := false;
                    LoanGuaranteedEditable := false;
                    SubMemberEditable := false;
                end;
    end;

    local procedure CalculateAmountGuaranteed(AmountReplaced: Decimal; TotalAmount: Decimal; AmountGuaranteed: Decimal) AmtGuar: Decimal
    begin
        AmtGuar := ((AmountReplaced / TotalAmount) * AmountGuaranteed);

        exit(AmtGuar);
    end;

    local procedure Controls()
    begin
        if Status = Status::Open THEN begin
            AllowPosting := false;
            CancelApproval := false;
            SendApproval := true;
        end ELSE
            if Status = Status::Pending THEN begin
                AllowPosting := false;
                CancelApproval := true;
                SendApproval := false;
            end ELSE
                if Status = Status::Approved THEN begin
                    AllowPosting := true;
                    CancelApproval := false;
                    SendApproval := false;
                end
                ELSE
                    if Status = Status::Closed THEN begin
                        AllowPosting := false;
                        CancelApproval := false;
                        SendApproval := false;
                    end;
    end;
}
