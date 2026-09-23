report 50212 "Send Defaulter Emails"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Send Defaulter Emails.rdlc';



    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            RequestFilterFields = "Loan  No.";

            column(Loan__No_; "Loan  No.")
            {
            }

            //             trigger OnAfterGetRecord()
            //             var
            //                 emailBody: Text[500];
            //                 ClientCode: Code[30];
            //                 Arrears: Decimal;

            //                 GuarRec: Record "Loans Guarantee Details";
            //                 Guaremail: Text[500];
            //                 GuarCode: Code[30];
            //             begin
            //                 Arrears := "Amount in Arrears";

            //                 if Arrears > 0 then begin

            //                     ClientCode := "Client Code";
            //                     //This is to inform you that your EMERGENCYloan is in arrears for  months,Your outstanding balance is Kshs.0.You are now required to clear the said arrears within the next fourteen (14) days without fail.
            //                     emailBody :=
            //                       'Dear ' + "Client Name" + ', your ' + "Loan Product Type Name" +
            // ' with DEVCO SACCO LIMITED is in default and currently in arrears of ' + Format(Arrears) + ', overdue by '
            // + Format("No of Months in Arrears") + ' month(s). ' + 'Kindly make payment immediately to avoid further recovery action.';
            //                     Saccogensetup.FnSendemail(
            //                         'DEFAULTER',
            //                         emailBody,
            //                         ClientCode,
            //                         GetPhoneNumber(ClientCode)
            //                     );

            //                     GuarRec.Reset();
            //                     GuarRec.SetRange("Loan No", "Loan  No.");
            //                     GuarRec.SetRange(Substituted, false);

            //                     if GuarRec.Find('-') then begin
            //                         repeat
            //                             GuarCode := GuarRec."Member No";
            //                             Guaremail :=
            // 'Dear ' + GuarRec.Name + ', you guaranteed a ' +
            // "Loan Product Type Name" + ' for ' + "Client Name" + ' with DEVCO SACCO LIMITED. The loan is in default with arrears of ' +
            // Format(Arrears) + ', overdue by' + Format("No of Months in Arrears") + 'months. Kindly advise the borrower to regularize the account or be prepared to honor your guarantee obligations.'
            //                        ;

            //                             Saccogensetup.FnSendemail(
            //                                 'DEFAULTER-GUARANTOR',
            //                                 Guaremail,
            //                                 GuarCode,
            //                                 GetPhoneNumber(GuarCode)
            //                             );

            //                         until GuarRec.Next() = 0;
            //                     end;

            //                 end;
            //             end;
            trigger OnAfterGetRecord()
            var
                EmailBody: Text;
                Subject: Text;
                ClientCode: Code[30];
                Arrears: Decimal;
                GuarRec: Record "Loans Guarantee Details";
                GuarCode: Code[30];
                TodayTxt: Text;
                Note: Codeunit "Notifications Handler";
                "Amount to Be Recovered": Decimal;
            begin
                Arrears := "Amount in Arrears";
                // "Amount to Be Recovered" := (GuarRec."Amont Guaranteed" / GuarRec."Total Amount Guaranteed" * Arrears);

                if Arrears > 0 then begin
                    // Arrears := "Amount in Arrears";
                    // "Amount to Be Recovered" := (GuarRec."Amont Guaranteed" / GuarRec."Total Amount Guaranteed" * Arrears);


                    ClientCode := "Client Code";

                    // ================= 3RD NOTICE =================
                    if "No of Days in Arrears" > 90 then begin


                        Subject := 'Final Demand Notice';

                        EmailBody :=
                        TodayTxt +
                        'Dear ' + "Client Name" + ', ' +
                        'RE: Final Demand Notice ' +

                        'We are writing to inform you about the loan arrears amounting to Kshs.' + Format(Arrears) +
                        ' currently owed by you. ' +

                        'In accordance with the SACCO bylaws, we are required to recover the defaulted amount from the guarantors. ' +

                        'Kindly clear within 7 days to avoid recovery. ' +

                        'Yours faithfully, ' +
                        'Hillary Koskey ' +
                        'Manager-Sacco Ltd ' +
                        'CC-CREDIT COMMITTEE';
                        //SendNotificationMessages(ClientCode, today, EmailBody);
                        //"Loans Register"."Final Notice" := true;
                        //"Loans Register".Modify();
                        Note.fnqueueEmail('DEFAULTER-3RD', Subject, EmailBody, ClientCode, "Loan  No.", 2, "Client Name", 'mmitey@surestep.co.ke');//GetEmail(ClientCode)
                        GuarRec.SetRange("Loan No", "Loan  No.");
                        if GuarRec.FindSet() then
                            repeat
                                GuarCode := GuarRec."Member No";

                                EmailBody :=
                                TodayTxt +
                                'Dear' + GuarRec.Name +
                                'RE: Final Demand Notice ' +

                                'We are writing to inform you about the loan arrears amounting to Kshs.' + Format(Arrears) +
                                ' currently owed by ' + "Client Name" + '. ' +

                                'In accordance with the SACCO bylaws, we are required to recover the defaulted amount from the guarantors. ' +

                                'We will commence the recovery of Kshs.' + Format("Amount to Be Recovered") + ' starting at the end of the month. ' +
                                'until the outstanding amount is paid in full.In the event ' + "Client Name" + ' repays this amount, we will refund you the deducted amount. ' +

                                'Yours faithfully, ' +
                                'Hillary Koskey ' +
                                'Manager-Sacco Ltd ' +
                                'CC-CREDIT COMMITTEE';
                                //GetEmail(GuarCode)
                                Note.fnqueueEmail('GUAR-3RD', Subject, EmailBody, GuarCode, "Loan  No.", 2, GuarRec.Name, 'mmitey@surestep.co.ke');

                            until GuarRec.Next() = 0;

                    end
                    //end
                    //demandnotice@devcosacco.co.ke
                    // ================= 2ND NOTICE =================
                    else if ("No of Days in Arrears" > 60) and ("No of Days in Arrears" < 90) then begin
                        if ("1st Notice" = true) and ("2nd Notice" = false) and ("Final Notice" = false) then begin
                            Subject := '2nd Demand Notice';

                            EmailBody :=
                            TodayTxt +
                             'Dear' + "Client Name" +
                                    'RE: 2nd Demand Notice ' +

                            'We are writing to inform you of the defaulted ' + "Loan Product Type Name" + ' loan for two monthsamounting to Kes. ' + Format(Arrears) + '. ' +

                            'Kindly note that we are bound by our credit policy to notify guarantors on the second month of default, on the third month guarantors to start repaying defaulted amount. ' +
                            'We are therefore requesting you to update your account by end of month to avoid notifying the guarantors at the beginning of next month and subsequent recoveries in  ' +
                            'at the end of the month as directed by Credit and by laws policy. ' +

                            'Yours faithfully, ' +
                            'Hillary Koskey ' +
                            'Manager- Devco Sacco Ltd ' +
                            'CC-Credit Committee';
                           // SendNotificationMessages(ClientCode, today, EmailBody);
                            //"Loans Register"."2nd Notice" := true;
                            //"Loans Register".Modify();
                            Note.fnqueueEmail('DEFAULTER-2ND', Subject, EmailBody, ClientCode, "Loan  No.", 1, "Client Name", 'demandnotice@devcosacco.co.ke');

                            GuarRec.SetRange("Loan No", "Loan  No.");
                            if GuarRec.FindSet() then
                                repeat
                                    GuarCode := GuarRec."Member No";

                                    EmailBody :=
                                    TodayTxt +
                                 'Dear' + GuarRec.Name +
                                    'RE: 2nd Demand Notice ' +

                                    'We are writing to inform you about the loan arrears amounting to Kshs.' + Format(Arrears) +
                                    ' currently owed by ' + "Client Name" + '. ' +

                                    'In accordance with the SACCO bylaws, we are required to recover the defaulted amount from the guarantors. ' +

                                    'Kindly advice ' + "Client Name" + ' to arrange for the payment of their arrears to avoid recoveries from you as a guarantor. ' +

                                    'Yours faithfully, ' +
                                    'Hillary Koskey ' +
                                    'Manager-Sacco Ltd ' +
                                    'CC-CREDIT COMMITTEE';

                                    Note.fnqueueEmail('GUAR-3RD', Subject, EmailBody, GuarCode, "Loan  No.", 2, GuarRec.Name, 'demandnotice@devcosacco.co.ke');
                                // GetEmail(GuarCode));
                                until GuarRec.Next() = 0;
                        end
                    end

                    // ================= 1ST NOTICE =================
                    else if ("No of Days in Arrears" > 30) and ("No of Days in Arrears" < 60) then begin
                        if ("1st Notice" = false) and ("2nd Notice" = false) and ("Final Notice" = false) then begin
                            Subject := '1st Demand Notice';

                            EmailBody :=
                            TodayTxt +
                           'Dear' + "Client Name" +
                           'RE: 1st Demand Notice ' +

                            'We are writing to inform you of the defaulted ' + "Loan Product Type Name" + ' loan for a month(s) amounting to Kes. ' + Format(Arrears) + '. ' +

                            'Kindly note that we are bound by our credit policy to notify guarantors on the second month of default, on the third month guarantors to start repaying defaulted amount. ' +
                            'We are therefore requesting you to update your account by end of month to avoid notifying the guarantors at the beginning of next month and subsequent recoveries in  ' +
                            'at the end of next month as directed by Credit and by laws policy. ' +


                            'Yours faithfully, ' +
                            'Hillary Koskey ' +
                            'Manager- Devco Sacco Ltd ' +
                            'CC-Credit Committee';

                            Note.fnqueueEmail('DEFAULTER-1ST', Subject, EmailBody, ClientCode, "Loan  No.", 0, "Client Name", 'demandnotice@devcosacco.co.ke');
                           // SendNotificationMessages(ClientCode, today, EmailBody);
                           // "Loans Register"."2nd Notice" := true;
                            //"Loans Register".Modify();
                        end;

                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //  SetFilter("No of Days in Arrears", '>30');
                SetFilter("Amount in Arrears", '>0');
            end;

        }
    }

    var
        CustRecord: Record Customer;
        Saccogensetup: Codeunit "SURESTEP Factory";

    local procedure GetPhoneNumber(ClientCode: Code[20]): Text
    begin
        CustRecord.Reset();
        CustRecord.SetRange("No.", ClientCode);
        if CustRecord.Find('-') then
            exit(CustRecord."Phone No.");
    end;

    local procedure GetEmail(ClientCode: Code[20]): Text
    begin
        CustRecord.Reset();
        CustRecord.SetRange("No.", ClientCode);
        if CustRecord.Find('-') then
            exit(CustRecord."E-Mail");
    end;

    local procedure SendNotificationMessages(MemberNo: Code[40]; Date: date; EmailBody: Text)
    var
        msg: Text[250];
        PhoneNo: Text[250];
        Cust: Record Customer;
    begin
        Cust.Reset();
        Cust.SetRange(Cust."No.", MemberNo);
        If Cust.FindFirst() then begin
            if Cust."Phone No." <> ' ' then
                msg := '';
            msg := EmailBody;
            //msg := 'Dear ' + Cust.Name + ',' + ' We received an amount of ' + Format(RunningBal) + ' on ' + Format(Date) + ', and it has been successfully allocated.';
            SendSMSMessage(Cust."No.", msg, '0735074910');


        end;
    end;

    local procedure SendSMSMessage(BOSANo: Code[20]; msg: Text[250]; PhoneNo: Text[250])
    Var
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
    begin
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else
            iEntryNo := 1;
        //--------------------------------------------------
        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := BOSANo;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'BOSANOTIFICATION';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := msg;
        SMSMessages."Telephone No" := PhoneNo;
        SMSMessages.Insert;
    end;



    local procedure FnSendemail(PeriodFilter: Date)
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

        MailToSend: Codeunit "Email Message";
        GenerateDoc: InStream;//Generate PDF/Document to be sent 
        EncodeStream: Codeunit "Base64 Convert";//To encode the stream of data form GenerateDoc
        FnEmail: Codeunit Email;
        DialogBox: Dialog;
    begin
        //------------------->Get Key Details of Send Email
        SendEmailTo := '';
        SendEmailTo := 'mm@surestep.co.ke';//"E-Mail (Personal)"
        EmailSubject := '';
        EmailSubject := 'GENERATED AND POSTED BOSA INTEREST EARNED';

        EmailBody := '';
        EmailBody := 'Dear ' + Format('team') + '  We hope this email finds you well.Please find the attached excel document for the the generated and posted FOSA Interests for the period ending ' + Format(PeriodFilter);
        //------------------->Generate The Report Attachments To Send
        //---------Attachment 1
        FileName := Format(PeriodFilter) + '-BOSAInterestPosted.XLSX';
        TempBlob.CreateOutStream(Outstr);
        Report.SaveAs(Report::"FOSA Interest Generated", '', ReportFormat::Excel, Outstr);
        TempBlob.CreateInStream(Instr);
        //------------------->Create Emails Start
        MailToSend.Create(SendEmailTo, EmailSubject, EmailBody);
        MailToSend.AddAttachment(FileName, FileType, Instr);
        FnEmail.Send(MailToSend, Enum::"Email Scenario"::Default);
        Message('The Process has completed successfully. Please Check your email for more details');

    end;
}

