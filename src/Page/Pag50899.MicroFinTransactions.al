#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50899 "Micro_Fin_Transactions"
{
    Caption = 'C.E.E.P Receipts';
    DeleteAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = Micro_Fin_Transactions;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Group Account No.';
                    Style = StrongAccent;

                }
                field("Group Name"; Rec."Group Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Teller No.';


                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Teller Account Name';
                }
                field("Payment Description"; Rec."Payment Description")
                {
                    ApplicationArea = Basic;

                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Group Meeting Day"; Rec."Group Meeting Day")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Total Repayment"; Rec."Total Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Total Savings"; Rec."Total Savings")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Unfavorable;
                }

                field("Total Principle"; Rec."Total Principle")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Total Interest"; Rec."Total Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Total Excess"; Rec."Total Excess")
                {
                    ApplicationArea = Basic;
                }
                field("Total Penalty"; Rec."Total Penalty")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("CEEP Officer"; Rec."CEEP Officer")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1102755013; Micro_Fin_Schedule)
            {
                Caption = 'Receipts Allocation Schedule';
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup1102755015)
            {
                action("Refresh Page")
                {
                    ApplicationArea = Basic;
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //---------------------------------
                        CurrPage.Update();
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you have selected loan number for clients with loans?') = true then begin
                            if Confirm(Text006) = true then begin
                                if Rec.Amount = 0 then
                                    Error('Amount must not be 0');
                                Rec.TestField("Account No");
                                Rec.TestField("Payment Description");
                                Rec.TestField(Amount);
                                if Rec.Posted then
                                    Error('Transaction already posted');

                                if Rec."Account Type" = Rec."account type"::"G/L Account" then
                                    Error('Account type must be Bank Account');
                                if Rec.Posted then
                                    Error('The transaction %1 is already posted', Rec."No.");
                                if Rec.Amount = 0 then
                                    Error(Text002, Rec."No.", Rec.Amount);

                                Rec.CalcFields("Total Amount");
                                if Rec."Total Amount" <> Rec.Amount then begin
                                    Error(Text005);
                                end;
                                Temp.Get(UserId);

                                Jtemplate := Temp."Receipt Journal Template";
                                JBatch := Temp."Receipt Journal Batch";
                                if Jtemplate = '' then begin
                                    Error(Text003)
                                end;
                                if JBatch = '' then begin
                                    Error(Text004)
                                end;

                                GenJournalLine.Reset;
                                GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                                GenJournalLine.SetRange("Journal Batch Name", JBatch);
                                GenJournalLine.DeleteAll;
                                //end of deletion
                                LineNo := 10000;

                                Rec.TestField("Account No");
                                //.........................................THE CODE
                                LineNo := LineNo + 10000;    //JBatch
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := Jtemplate;
                                GenJournalLine."Journal Batch Name" := JBatch;
                                GenJournalLine."Document No." := Rec."No.";
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Group Code" := Rec."Group Code";
                                GenJournalLine."Account Type" := Rec."Account Type";
                                GenJournalLine."Account No." := Rec."Account No";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Rec."Transaction Date";
                                GenJournalLine.Description := Rec."Payment Description";
                                GenJournalLine.Amount := Rec.Amount;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Loan No" := Transact."Loans No.";
                                GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                Transact.Reset;
                                Transact.SetRange(Transact."No.", Rec."No.");
                                Transact.SetFilter(Transact.Amount, '>%1', 0);
                                if Transact.Find('-') then begin
                                    repeat
                                        if Transact."Principle Amount" > 0 then begin
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := Jtemplate;
                                            GenJournalLine."Journal Batch Name" := JBatch;
                                            GenJournalLine."Document No." := Rec."No.";
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Repayment;
                                            GenJournalLine."Group Code" := Transact."Group Code";
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := Transact."Account Number";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Posting Date" := Rec."Transaction Date";
                                            GenJournalLine.Description := 'Loan Repayment';
                                            GenJournalLine.Amount := -Transact."Principle Amount";
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Loan No" := Transact."Loans No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                            GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;

                                        if Transact.Savings > 0 then begin
                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := Jtemplate;
                                            GenJournalLine."Journal Batch Name" := JBatch;
                                            GenJournalLine."Document No." := Rec."No.";
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Group Code" := Transact."Group Code";
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := Transact."Account Number";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Posting Date" := Rec."Transaction Date";
                                            GenJournalLine.Description := 'Deposit Contribution';
                                            GenJournalLine.Amount := -Transact.Savings;
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Deposit Contribution";
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                            GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;

                                        if Transact."Interest Amount" > 0 then begin
                                            GenJournalLine.Init;
                                            LineNo := LineNo + 10000;
                                            GenJournalLine."Journal Template Name" := Jtemplate;
                                            GenJournalLine."Journal Batch Name" := JBatch;
                                            GenJournalLine."Document No." := Rec."No.";
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Group Code" := Transact."Group Code";
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Interest Paid";
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := Transact."Account Number";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Posting Date" := Rec."Transaction Date";
                                            GenJournalLine.Description := 'Interest Paid';
                                            GenJournalLine.Amount := -Transact."Interest Amount";
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Loan No" := Transact."Loans No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                            GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                            Commit;
                                        end;
                                        //******************excess
                                        if Transact."Excess Amount" > 0 then begin

                                            LineNo := LineNo + 10000;
                                            GenJournalLine.Init;
                                            GenJournalLine."Journal Template Name" := Jtemplate;
                                            GenJournalLine."Journal Batch Name" := JBatch;

                                            GenJournalLine."Document No." := Rec."No.";
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Unallocated Funds";
                                            GenJournalLine."Group Code" := Transact."Group Code";
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := Transact."Account Number";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Posting Date" := Rec."Transaction Date";
                                            GenJournalLine.Description := 'Excess from-' + Transact."Account Number" + ' To unallocated funds';
                                            GenJournalLine.Amount := -Transact."Excess Amount";
                                            GenJournalLine.Validate(GenJournalLine.Amount);

                                            GenJournalLine."Shortcut Dimension 1 Code" := Rec."Activity Code";
                                            GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;
                                        //********excess

                                        if Transact."Penalty Amount" > 0 then begin
                                            GenJournalLine.Init;
                                            LineNo := LineNo + 10000;
                                            GenJournalLine."Journal Template Name" := Jtemplate;
                                            GenJournalLine."Journal Batch Name" := JBatch;
                                            GenJournalLine."Document No." := Rec."No.";
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Group Code" := Rec."Group Code";
                                            GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                            GenJournalLine."Account No." := Transact."Account Number";
                                            GenJournalLine.Validate(GenJournalLine."Account No.");
                                            GenJournalLine."Posting Date" := Rec."Transaction Date";
                                            // GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Penalty Paid";
                                            GenJournalLine.Description := 'CEEP Fees';
                                            GenJournalLine.Amount := -Transact."Penalty Amount";
                                            GenJournalLine.Validate(GenJournalLine.Amount);
                                            GenJournalLine."Loan No" := Transact."Loans No.";
                                            GenJournalLine."Shortcut Dimension 1 Code" := 'MICRO';
                                            GenJournalLine."Shortcut Dimension 2 Code" := Rec."Branch Code";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert;
                                        end;

                                    until Transact.Next = 0;
                                end;
                                //post
                                GenJournalLine.Reset;
                                GenJournalLine.SetRange(GenJournalLine."Journal Template Name", Jtemplate);
                                GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", JBatch);
                                Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);

                                Rec.Posted := true;
                                Rec."Posted By" := UserId;
                                Rec.Modify;
                            end else
                                Error('Operation aborted !');
                        end else
                            Error('Please select loan number for clients with loans');
                        CurrPage.Close;
                    end;
                }
                action("Micro Schedule")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.TestField(Posted, true);
                        MicrSchedule.Reset;
                        MicrSchedule.SetRange(MicrSchedule."No.", Rec."No.");
                        if MicrSchedule.Find('-') then begin
                            Report.Run(50850, true, false, MicrSchedule);
                        end;
                    end;
                }
            }
            group(Approvals)
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        Transact: Record Micro_Fin_Schedule;
        LineNo: Integer;
        DefaultBatch: Record "Gen. Journal Batch";
        BranchCode: Code[20];
        Bank: Record "Bank Account";
        Group: Code[30];
        MTrans: Record Micro_Fin_Transactions;
        Bcode: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans;
        DistributedAmt: Decimal;
        MicrSchedule: Record Micro_Fin_Schedule;
        CustMember: Record Customer;
        GensetUp: Record "Sacco General Set-Up";
        ChangeStatus: Boolean;
        DepDifference: Decimal;
        TotDiff: Decimal;
        Text001: label 'Account type Must be Bank Acount. The current Value is -%1 in transaction No. -%2.';
        Text002: label 'There is nothing to Post in transaction No. -%1. The current amount value is -%2.';
        Temp: Record "Funds User Setup";
        Jtemplate: Code[50];
        JBatch: Code[50];
        Text003: label 'Ensure The Receipt Journal Template is set up in cash Office set up';
        Text004: label 'Ensure The Receipt Journal Batch is set up in cash Office set up';
        Text005: label 'Please note that the Total Amount and the Amount Received Must be the same';
        Text006: label 'ARE YOU SURE YOU WANT TO POST THE RECEIPTS';
        Text007: label 'Business Loan  Repayment Journal';
        Text008: label 'The transaction No. -%1 is already posted';
        Text009: label 'This Till is No. %1 not assigned to this Specific User. Please contact your system administrator';
        ReceiptAllocations: Record "Receipt Allocation";
        Cust: Record Customer;
        LoanApp: Record "Loans Register";
        LOustanding: Decimal;
        SFactory: Codeunit "SURESTEP Factory";
}

