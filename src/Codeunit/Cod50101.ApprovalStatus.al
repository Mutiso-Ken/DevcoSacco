codeunit 50102 "Approval Entry Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnApprovalEntryModify(var Rec: Record "Approval Entry")
    begin
        if Rec.Status = Rec.Status::Approved then begin
            if Rec."Table ID" = Database::"Membership Applications" then
                UpdateDocumentApproval(Rec);

            if Rec."Table ID" = Database::"Loans Register" then
                UpdateDocumentApprovalLoan(Rec);
        end;
    end;

    procedure UpdateDocumentApproval(ApprovalEntry: Record "Approval Entry")
    var
        TargetDocument: Record "Membership Applications";
    begin
        if not AllApprovalsCompleted(ApprovalEntry) then
            exit;

        if TargetDocument.Get(ApprovalEntry."Record ID to Approve") then begin
            TargetDocument.Status := TargetDocument.Status::Approved;
            TargetDocument.Modify(true);
        end;
    end;

    procedure UpdateDocumentApprovalLoan(ApprovalEntry: Record "Approval Entry")
    var
        TargetDocument: Record "Loans Register";
    begin
        if not AllApprovalsCompleted(ApprovalEntry) then
            exit;

        if TargetDocument.Get(ApprovalEntry."Record ID to Approve") then begin
            TargetDocument."Loan Status" := TargetDocument."Loan Status"::Approved;
            TargetDocument."Approval Status" := TargetDocument."Approval Status"::Approved;
            TargetDocument.Modify(true);
        end;
    end;

    procedure AllApprovalsCompleted(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        ApprovalEntry2: Record "Approval Entry";
    begin
        ApprovalEntry2.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");

        if ApprovalEntry2.FindFirst() then
            repeat
                if ApprovalEntry2.Status <> ApprovalEntry2.Status::Approved then
                    exit(false);
            until ApprovalEntry2.Next() = 0;

        exit(true);
    end;
}