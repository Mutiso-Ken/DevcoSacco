#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50977 ReceiveTellerCash
{
    DeleteAllowed = false;
    PageType = Card;
    InsertAllowed = false;
    editable = false;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Treasury Transactions";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = StrongAccent;

                }
                field("From Account"; Rec."From Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'From';
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'To';
                    Style = StrongAccent;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;

                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/Document No.';
                }
                field(Issued; Rec.Issued)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Issued"; Rec."Time Issued")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Issued By"; Rec."Issued By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Received; Rec.Received)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = Basic;
                }
                field("Time Received"; Rec."Time Received")
                {
                    ApplicationArea = Basic;
                }
                field("Received By"; Rec."Received By")
                {
                    ApplicationArea = Basic;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field("Captured By"; "Captured By")
                // {
                // }
            }
            part(Control1000000024; "Treasury Denominations")
            {
                SubPageLink = No = field(No);
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Issue/Return")
            {
                Visible = false;
                ApplicationArea = Basic;
                Caption = 'Issue/Return';
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Amount);
                    Rec.TestField("From Account");
                    Rec.TestField("To Account");
                    Coinage.Reset;
                    Coinage.SetRange(Coinage.No, Rec.No);
                    if Coinage.Find('-') then begin
                        Rec.CalcFields("Total Cash on Treasury Coinage");
                        if Rec.Amount <> Rec."Total Cash on Treasury Coinage" then
                            Error('Amount must be equal before performing this operation');
                    end;
                    if (Rec."Transaction Type" = Rec."transaction type"::"Issue To Teller") or
                    (Rec."Transaction Type" = Rec."transaction type"::"Return To Treasury") or
                    (Rec."Transaction Type" = Rec."transaction type"::"Inter Teller Transfers") or
                    (Rec."Transaction Type" = Rec."transaction type"::"Branch Treasury Transactions")
                     then begin
                        if Rec.Issued = Rec.Issued::Yes then
                            Error('The money has already been issued.');

                        TellerTill.Reset;
                        TellerTill.SetRange(TellerTill."No.", Rec."From Account");
                        if TellerTill.Find('-') then begin
                            if UpperCase(UserId) <> TellerTill.CashierID then
                                Error('You do not have permission to transact on this teller till/Account.');
                        end;


                        Banks.Reset;
                        Banks.SetRange(Banks."No.", Rec."From Account");
                        if Banks.Find('-') then begin
                            Banks.CalcFields(Banks."Balance (LCY)");
                            BankBal := Banks."Balance (LCY)";
                            if Rec.Amount > BankBal then begin
                                Error('You cannot issue more than the account balance.')
                            end;
                        end;

                        if Confirm('Are you sure you want to make this issue?', false) = true then begin
                            Rec.Issued := Rec.Issued::Yes;
                            Rec."Date Issued" := Today;
                            Rec."Time Issued" := Time;
                            Rec."Issued By" := UpperCase(UserId);
                            Rec.Modify;
                            SENDMAIL;
                        end;

                        if (Rec."Transaction Type" = Rec."transaction type"::"Issue To Teller") or (Rec."Transaction Type" = Rec."transaction type"::"Issue From Bank")
                        or (Rec."Transaction Type" = Rec."transaction type"::"Issue To Teller") or (Rec."Transaction Type" = Rec."transaction type"::"Inter Teller Transfers") then
                            Message('Money successfully issued.')
                        else
                            Message('Money successfully Returned.')
                    end else begin
                        if Rec."Transaction Type" = Rec."transaction type"::"Return To Bank" then begin
                            Rec.TestField(Amount);
                            Rec.TestField("From Account");
                            Rec.TestField("To Account");


                            Banks.Reset;
                            Banks.SetRange(Banks."No.", Rec."From Account");
                            if Banks.Find('-') then begin
                                Banks.CalcFields("Balance (LCY)");
                                if Rec.Amount > Banks."Balance (LCY)" then
                                    Error('You cannot receive more than balance in ' + Rec."From Account")
                            end;

                            if Confirm('Are you sure you want to make this return?', false) = false then
                                exit;

                            //Delete any items present
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FTRANS');
                            GenJournalLine.DeleteAll;

                            if DefaultBatch.Get('GENERAL', 'FTRANS') = false then begin
                                DefaultBatch.Init;
                                DefaultBatch."Journal Template Name" := 'GENERAL';
                                DefaultBatch.Name := 'FTRANS';
                                DefaultBatch.Insert;
                            end;


                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'GENERAL';
                            GenJournalLine."Journal Batch Name" := 'FTRANS';
                            GenJournalLine."Document No." := Rec.No;
                            GenJournalLine."External Document No." := Rec."Cheque No.";
                            GenJournalLine."Line No." := 10000;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Account No." := Rec."From Account";
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine.Description := Rec.Description;
                            GenJournalLine."Currency Code" := Rec."Currency Code";
                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            GenJournalLine.Amount := -Rec.Amount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                            GenJournalLine."Bal. Account No." := Rec."To Account";
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;

                            GenJournalLine.Reset;
                            GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'GENERAL');
                            GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FTRANS');
                            if GenJournalLine.Find('-') then
                                Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);

                            Rec.Posted := true;
                            Rec."Date Posted" := Today;
                            Rec."Time Posted" := Time;
                            Rec."Posted By" := UpperCase(UserId);

                            Rec.Received := Rec.Received::Yes;
                            Rec."Date Received" := Today;
                            Rec."Time Received" := Time;
                            Rec."Received By" := UpperCase(UserId);
                            Rec.Modify;

                            //END;


                        end else
                            Message('Only applicable for teller, treasury & Bank Issues/Returns.');

                    end;
                end;
            }
            action(Receive)
            {
                ApplicationArea = Basic;
                Caption = 'Receive Cash';
                Image = ReceiveLoaner;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestField(Amount);
                    Rec.TestField("From Account");
                    Rec.TestField("To Account");
                    Rec.Approved := true;
                    GenSetup.Get;

                    if Rec."Transaction Type" = Rec."transaction type"::"Issue From Bank" then
                        Rec.TestField("Cheque No.");

                    CurrentTellerAmount := 0;
                    if Rec.Posted = true then
                        Error('The transaction has already been received and posted.');

                    if Rec."Transaction Type" = Rec."transaction type"::"Inter Teller Transfers" then begin
                        if Rec.Approved = false then
                            Error('Inter Teller Transfers must be approved.');
                    end;


                    if (Rec."Transaction Type" = Rec."transaction type"::"Issue To Teller") or
                    (Rec."Transaction Type" = Rec."transaction type"::"Branch Treasury Transactions") or
                    (Rec."Transaction Type" = Rec."transaction type"::"Inter Teller Transfers") then begin
                        if Rec.Issued = Rec.Issued::No then
                            Error('The issue has not yet been made and therefore you cannot continue with this transaction.');

                        TellerTill.Reset;
                        TellerTill.SetRange(TellerTill."No.", Rec."To Account");
                        if TellerTill.Find('-') then begin
                            if UpperCase(UserId) <> TellerTill.CashierID then
                                Error('You do not have permission to transact on this teller till/Account.');

                            TellerTill.CalcFields(TellerTill.Balance);
                            CurrentTellerAmount := TellerTill.Balance;
                            if CurrentTellerAmount + Rec.Amount > TellerTill."Maximum Teller Withholding" then
                                Error('The transaction will result in the teller having a balance more than the maximum allowable therefor terminated.');

                        end;
                    end;



                    if Confirm('Are you sure you want to make this receipt?', false) = false then
                        exit;

                    //Delete any items present
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FTRANS');
                    GenJournalLine.DeleteAll;

                    if DefaultBatch.Get('GENERAL', 'FTRANS') = false then begin
                        DefaultBatch.Init;
                        DefaultBatch."Journal Template Name" := 'GENERAL';
                        DefaultBatch.Name := 'FTRANS';
                        DefaultBatch.Insert;
                    end;

                    lines := lines + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'FTRANS';
                    GenJournalLine."Document No." := Rec.No;
                    GenJournalLine."Line No." := lines;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := Rec."From Account";
                    GenJournalLine."External Document No." := Rec."Cheque No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine.Description := Rec.Description;
                    GenJournalLine."Currency Code" := Rec."Currency Code";
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount := -Rec.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                    GenJournalLine."Bal. Account No." := Rec."To Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Post
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'FTRANS');
                    if GenJournalLine.Find('-') then begin

                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                    end;

                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'FTRANS');
                    GenJournalLine.DeleteAll;
                    Rec.Posted := true;
                    Rec."Date Posted" := Today;
                    Rec."Time Posted" := Time;
                    Rec."Posted By" := UpperCase(UserId);

                    Rec.Received := Rec.Received::Yes;
                    Rec."Date Received" := Today;
                    Rec."Time Received" := Time;
                    Rec."Received By" := UpperCase(UserId);
                    Rec.Modify;

                    //END;
                end;
            }
            action("EOD Report")
            {
                ApplicationArea = Basic;
                Caption = 'EOD Report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    Trans.Reset;
                    Trans.SetRange(Trans.No, Rec.No);
                    if Trans.Find('-') then
                        Report.Run(50430, true, true, Trans)
                end;
            }
            // action(SENDMAIL)
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'SENDMAIL';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Visible = false;

            //     trigger OnAction()
            //     begin


            //         SENDMAIL;
            //     end;
            // }
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
            action(Approve)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("From Account");
                    Rec.TestField("To Account");
                    Rec.TestField(Amount);

                    StatusPermissions.Reset;
                    StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
                    StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Inter Teller Approval");
                    if StatusPermissions.Find('-') = false then
                        Error('You do not have permissions to approve inter teller transactions.');

                    Rec.Approved := true;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*IF UsersID.GET(USERID) THEN BEGIN
        IF UsersID.Branch <> '' THEN
        SETRANGE("Transacting Branch",UsersID.Branch);
        END;
        */


        if Rec.Posted = true then
            CurrPage.Editable := false

    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        //GLPosting: Codeunit "Gen. Jnl.-Post Line";
        window: Dialog;
        CurrentTellerAmount: Decimal;
        TellerTill: Record "Bank Account";
        Banks: Record "Bank Account";
        BankBal: Decimal;
        TotalBal: Decimal;
        DenominationsRec: Record Denominations;
        TillNo: Code[20];
        Trans: Record "Treasury Transactions";
        UsersID: Record User;
        StatusPermissions: Record "Status Change Permision";
        "Gen-Setup": Record "Sacco General Set-Up";
        SendToAddress: Text[30];
        BankAccount: Record "Bank Account";
        MailContent: Text[150];
        SenderName: Code[20];
        TreauryTrans: Record "Treasury Transactions";
        Coinage: Record "Treasury Coinage";
        GenSetup: Record "Sacco General Set-Up";
        lines: Integer;
        MaxWithholding: Decimal;
        FrmAcc: Boolean;
    //  SMTPMAIL: Record "SMTP Mail Setup";


    procedure SENDMAIL()
    begin
        //sent mail on authorisation
        /*
        BankAccount.RESET;
        BankAccount.SETRANGE(BankAccount."No.","From Account");
        IF BankAccount.FIND('-') THEN BEGIN
        SenderName:=BankAccount.Name;
        END;
        
        BankAccount.RESET;
        BankAccount.SETRANGE(BankAccount."No.","To Account");
        IF BankAccount.FIND('-') THEN BEGIN
         MailContent:='You have received Kshs.'+' '+FORMAT(Amount)+' '+'from'+ ' '+SenderName+
         ' '+ 'the transaction type is' + ', '+ FORMAT("Transaction Type")+ ', ' +'TR.No' +' '+No+
         ' '+ 'Date'+ ' '+FORMAT("Transaction Date")+'.';
        
        REPEAT
        "Gen-Setup".GET();
        SMTPMAIL.NewMessage("Gen-Setup"."Sender Address",'TELLER & TEASURY TRANSACTIONS'+''+'');
        SMTPMAIL.SetWorkMode();
        SMTPMAIL.ClearAttachments();
        SMTPMAIL.ClearAllRecipients();
        SMTPMAIL.SetDebugMode();
        SMTPMAIL.SetFromAdress("Gen-Setup"."Sender Address");
        SMTPMAIL.SetHost("Gen-Setup"."Outgoing Mail Server");
        SMTPMAIL.SetUserID("Gen-Setup"."Sender User ID");
        SMTPMAIL.AddLine(MailContent);
        SendToAddress:=BankAccount."E-Mail";
        SMTPMAIL.SetToAdress(SendToAddress);
        SMTPMAIL.Send;
        UNTIL BankAccount.NEXT=0;
        END;
        */

    end;
}

