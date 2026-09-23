codeunit 50024 "Notifications Handler"
{
    procedure fnSendemail(recipientName: Text;
       subject: Text;
       body: text;
       recipientEmail: Text;
       hasAttachment: Boolean;
       attachmentBase64: Text;
       attachmentName: Text;
       attachmentType: Text
   ) res: Text
    var
        Companyinforec: Record "Company Information";
        CuEmail: Codeunit Email;
        CuEmailMessage: Codeunit "Email Message";
        EmailReceipientType: Enum "Email Recipient Type";
        Response: JsonObject;
        InputTkn: JsonToken;
        EmailAccount: Record "Email Account";
    templobCu: Codeunit "Temp Blob";
        Detail: Text;

        Receipient: Text;
    begin
        Companyinforec.GET;
        if RecipientEmail <> '' then begin
            CuEmailMessage.Create('', Subject, '');
            CuEmailMessage.SetBodyHTMLFormatted(true);
            CuEmailMessage.SetRecipients(EmailReceipientType::"To", RecipientEmail);
            if hasAttachment then begin
                CuEmailMessage.AddAttachment(AttachmentName + '.' + attachmentType, AttachmentType, AttachmentBase64);
            end;
            CuEmailMessage.AppendToBody('<html> <body> <font face="Maiandra GD,Garamond,Tahoma", size = "3">');
            CuEmailMessage.AppendToBody('<br><br>');
            CuEmailMessage.AppendToBody(Body);
            CuEmailMessage.AppendToBody('<br><br>');
            CuEmailMessage.AppendToBody('<HR>');
            CuEmailMessage.AppendToBody('Kind Regards');
            CuEmailMessage.AppendToBody('<br>');
            //CuEmailMessage.AppendToBody('<img src="https://telpostapension.org/img/logo-full.jpg" alt="Logo" />');
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody(Companyinforec.Name);
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody(Companyinforec.Address);
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody('Tel: ' + Companyinforec."Phone No.");
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody(Companyinforec."E-Mail");
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody(Companyinforec."Home Page");
            CuEmailMessage.AppendToBody('<br>');
            CuEmailMessage.AppendToBody('<br>');
            if CuEmail.Send(CuEmailMessage) then begin
                Response.Add('sent', true);
                Response.Add('status', '200');
                Response.Add('message', 'Email Sent Successfully');
            end else begin
                Response.Add('sent', false);
                Response.Add('status', '400');
                Response.Add('message', 'Email Not Sent');
                Response.Add('error', GetLastErrorText());
            end;
        end else begin
            Response.Add('sent', false);
            Response.Add('status', '400');
            Response.Add('message', 'Invalid Email Address');
            response.Add('error', 'Invalid Email Address. Please check email format and try again');
        end;
        Response.WriteTo(res);

        exit(res);
    end;


procedure FnQueueEmail(
    EmailSource: Text;
    Subject: Text;
    Body: Text;
    AccountNo: Code[30];
    LoanNo: Code[30];
    NoticeType: Option "1ST","2ND","3RD";
    RecipientName: Text;
    EmailAddress: Text)
var
    EmailMsg: Record "Email Messages";
    iEntryNo: Integer;
begin
    if EmailMsg.FindLast() then
        iEntryNo := EmailMsg."Entry No" + 1
    else
        iEntryNo := 1;

    EmailMsg.Init();
    EmailMsg."Entry No" := iEntryNo;
    EmailMsg.Source := EmailSource;
    EmailMsg."Account No" := AccountNo;
    EmailMsg."Loan No" := LoanNo;
    EmailMsg."Notice Type" := NoticeType;
    EmailMsg."Recipient Name" := RecipientName;
    EmailMsg."Email" := EmailAddress;
    EmailMsg."Email Subject" := Subject;
    EmailMsg."Email Body" := Body;
    EmailMsg."Date Entered" := Today;
    EmailMsg."Time Entered" := Time;
    EmailMsg."Entered By" := UserId;
    EmailMsg."Sent To Server" := EmailMsg."Sent To Server"::No;

    if (EmailAddress <> '') and (Body <> '') then
        EmailMsg.Insert();
end;

    var

        Usersetup: Record "User Setup";
        RecipientsName: Text;
        RecipientEmail: Text;
        subject: Text;
        body: Text;


}