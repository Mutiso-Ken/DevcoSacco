#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
codeunit 50021 "SurePESABulkSMS"
{

    trigger OnRun()
    begin
        Message(PollPendingSMS());
        //ChargeSMS();
    end;

    var
        SMSMessages: Record "SMS Messages";
        SMSCharges: Record "SMS Messages";
        SMSCharge: Decimal;
        ExDuty: Decimal;
        Vendor: Record Vendor;
        GenJournalLine: Record "Gen. Journal Line";
        GenBatches: Record "Gen. Journal Batch";
        LineNo: Integer;



    procedure PollPendingSMS() MessageDetails: Text
    begin

        SMSMessages.Reset;
        SMSMessages.SetRange(SMSMessages."Sent To Server", SMSMessages."sent to server"::No);
        SMSMessages.SetFilter(SMSMessages.Source, '%1', 'DEFAULTER');
        SMSMessages.SetRange("Telephone No", '0706833285'); // 
        SMSMessages.SetFilter(SMSMessages."Date Entered", '=%', TODAY);
        if SMSMessages.Find('-') then begin

            if (SMSMessages."Telephone No" = '')
              or (SMSMessages."Telephone No" = '+')
              or (SMSMessages."SMS Message" = '')
              then begin

                SMSMessages."Sent To Server" := SMSMessages."sent to server"::Failed;
                SMSMessages."Entry No." := 'FAILED';
                SMSMessages.Modify;

            end else begin
                MessageDetails := '';

                MessageDetails += SMSMessages."Telephone No" + ':::' + SMSMessages."SMS Message" + ':::' + Format(SMSMessages."Entry No");
            end;
        end;
    end;


    procedure ConfirmSent(TelephoneNo: Text[20]; Status: Integer)
    begin

        SMSMessages.Reset;
        SMSMessages.SetRange(SMSMessages."Sent To Server", SMSMessages."sent to server"::No);
        SMSMessages.SetRange(SMSMessages."Entry No", Status);
        if SMSMessages.FindFirst then begin
            SMSMessages."Sent To Server" := SMSMessages."sent to server"::Yes;
            SMSMessages."Entry No." := 'SUCCESS';
            SMSMessages."System Date" := Today;
            SMSMessages."System Time" := Time;
            SMSMessages.Modify;
        end
    end;
}

