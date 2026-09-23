report 50211 "Send Defaulter Notifications"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

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
            //                 SmsBody: Text[500];
            //                 ClientCode: Code[30];
            //                 Arrears: Decimal;

            //                 GuarRec: Record "Loans Guarantee Details";
            //                 GuarSMS: Text[500];
            //                 GuarCode: Code[30];
            //             begin
            //                 Arrears := "Amount in Arrears";

            //                 if Arrears > 0 then begin

            //                     ClientCode := "Client Code";
            //                     //This is to inform you that your EMERGENCYloan is in arrears for  months,Your outstanding balance is Kshs.0.You are now required to clear the said arrears within the next fourteen (14) days without fail.
            //                     SmsBody :=
            //                       'Dear ' + "Client Name" + ', your ' + "Loan Product Type Name" +
            // ' with DEVCO SACCO LIMITED is in default and currently in arrears of ' + Format(Arrears) + ', overdue by '
            // + Format("No of Months in Arrears") + ' month(s). ' + 'Kindly make payment immediately to avoid further recovery action.';
            //                     Saccogensetup.FnSendSMS(
            //                         'DEFAULTER',
            //                         SmsBody,
            //                         ClientCode,
            //                         GetPhoneNumber(ClientCode)
            //                     );

            //                     GuarRec.Reset();
            //                     GuarRec.SetRange("Loan No", "Loan  No.");
            //                     GuarRec.SetRange(Substituted, false);

            //                     if GuarRec.Find('-') then begin
            //                         repeat
            //                             GuarCode := GuarRec."Member No";
            //                             GuarSMS :=
            // 'Dear ' + GuarRec.Name + ', you guaranteed a ' +
            // "Loan Product Type Name" + ' for ' + "Client Name" + ' with DEVCO SACCO LIMITED. The loan is in default with arrears of ' +
            // Format(Arrears) + ', overdue by' + Format("No of Months in Arrears") + 'months. Kindly advise the borrower to regularize the account or be prepared to honor your guarantee obligations.'
            //                        ;

            //                             Saccogensetup.FnSendSMS(
            //                                 'DEFAULTER-GUARANTOR',
            //                                 GuarSMS,
            //                                 GuarCode,
            //                                 GetPhoneNumber(GuarCode)
            //                             );

            //                         until GuarRec.Next() = 0;
            //                     end;

            //                 end;
            //             end;
            trigger OnAfterGetRecord()
            var
                SmsBody: Text[500];
                ClientCode: Code[30];
                Arrears: Decimal;

                GuarRec: Record "Loans Guarantee Details";
                GuarSMS: Text[500];
                GuarCode: Code[30];
                "Amount to Be Recovered": Decimal;
                
            begin
                Arrears := "Amount in Arrears";
                // "Amount to Be Recovered" := (GuarRec."Amont Guaranteed" / GuarRec."Total Amount Guaranteed" * Arrears);

                if Arrears > 0 then begin
                    // Arrears := "Amount in Arrears";
                    // "Amount to Be Recovered" := (GuarRec."Amont Guaranteed" / GuarRec."Total Amount Guaranteed" * Arrears);


                    ClientCode := "Client Code";

                    if "No of Days in Arrears" > 90 then begin



                        SmsBody :=
                        'Notification of Loan Arrears Recovery: Dear ' + "Client Name" + ', your ' + "Loan Product Type Name" +
                        ' loan with Devco is in default of  ' + Format(Arrears) +
                        ' Pay within 7 days to avoid recovery from guarantors, or recovery action will be taken.';

                        Saccogensetup.FnSendSMS(
                            'DEFAULTER-3RD',
                            SmsBody,
                            ClientCode,
                            GetPhoneNumber(ClientCode)
                        );

                        GuarRec.Reset();
                        GuarRec.SetRange("Loan No", "Loan  No.");
                        GuarRec.SetRange(Substituted, false);

                        if GuarRec.FindSet() then begin
                            repeat
                                GuarCode := GuarRec."Member No";

                                GuarSMS :=
                                'Notification of Loan Arrears Recovery: Dear ' + GuarRec.Name + ', The ' + "Loan Product Type Name" +
                                ' loan you guaranteed for ' + "Client Name" + ' at Devco is in default of  ' + Format(Arrears) +
                                ' Pay within 7 days or recovery will proceesd. Please note recovery commences end of the Month';
                                Saccogensetup.FnSendSMS(
                                    'DEFAULTER-GUAR-3RD',
                                    GuarSMS,
                                    GuarCode,
                                    GetPhoneNumber(GuarCode)
                                );

                            until GuarRec.Next() = 0;
                        end;

                    end else if "No of Days in Arrears" > 60 then begin

                        SmsBody :=
                        '2ND NOTICE: Dear ' + "Client Name" + ', your ' + "Loan Product Type Name" +
                        ' loan with Devco Sacco is in arrears of ' + Format(Arrears) +
                        ' Kindly pay to avoid recovery from guarantors';



                        Saccogensetup.FnSendSMS(
                            'DEFAULTER-2ND',
                            SmsBody,
                            ClientCode,
                            GetPhoneNumber(ClientCode)
                        );

                        GuarRec.Reset();
                        GuarRec.SetRange("Loan No", "Loan  No.");
                        GuarRec.SetRange(Substituted, false);

                        if GuarRec.FindSet() then begin
                            repeat
                                GuarCode := GuarRec."Member No";

                                GuarSMS :=
                                '2ND NOTICE: Dear ' + GuarRec.Name + ', the loan you guaranteed for' + "Client Name" +
                                 ' at Devco Sacco is in arrears of ' + Format(Arrears) + '.To avoid enforcement, kindly advice ' + "Client Name" +
                                 ' to pay to avoid recovery from you';

                                Saccogensetup.FnSendSMS(
                                    'DEFAULTER-GUAR-2ND',
                                    GuarSMS,
                                    GuarCode,
                                    GetPhoneNumber(GuarCode)
                                );

                            until GuarRec.Next() = 0;
                        end;

                    end else if "No of Days in Arrears" > 30 then begin

                        SmsBody :=
                        '1ST NOTICE: Dear ' + "Client Name" + ', your ' + "Loan Product Type Name" +
                        ' loan with Devco Sacco is in arrears of ' + Format(Arrears) + ' Kindly make payment to regularize your account. Thank you.';

                        Saccogensetup.FnSendSMS(
                            'DEFAULTER-1ST',
                            SmsBody,
                            ClientCode,
                            GetPhoneNumber(ClientCode)
                        );

                        GuarRec.Reset();
                        GuarRec.SetRange("Loan No", "Loan  No.");
                        GuarRec.SetRange(Substituted, false);

                        if GuarRec.FindSet() then begin
                            repeat
                                GuarCode := GuarRec."Member No";

                                GuarSMS :=
                                '1ST NOTICE: Dear ' + GuarRec.Name + ', you guaranteed a ' +
                                "Loan Product Type Name" + ' loan for ' + "Client Name" +
                                ' at Devco Sacco. The loan is in arrears of ' + Format(Arrears) +
                                ' . Kindly advise ' + "Client Name" + ' to pay';

                                Saccogensetup.FnSendSMS(
                                    'DEFAULTER-GUAR-1ST',
                                    GuarSMS,
                                    GuarCode,
                                    GetPhoneNumber(GuarCode)
                                );

                            until GuarRec.Next() = 0;
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
}


