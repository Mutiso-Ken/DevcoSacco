#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50524 "Cases Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Cases Management";
    SourceTableView = where(Status = filter(Open));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case Number"; Rec."Case Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Complaint"; Rec."Date of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Type of cases"; Rec."Type of cases")
                {
                    ApplicationArea = Basic;
                }
                field("Recommended Action"; Rec."Recommended Action")
                {
                    ApplicationArea = Basic;
                }
                field("Case Description"; Rec."Case Description")
                {
                    ApplicationArea = Basic;
                }
                field("Resource#1"; Rec."Resource#1")
                {
                    ApplicationArea = Basic;
                }
                field("Action Taken"; Rec."Action Taken")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Case Information")
            {
                field("Date To Settle Case"; Rec."Date To Settle Case")
                {
                    ApplicationArea = Basic;
                }
                field("Document Link"; Rec."Document Link")
                {
                    ApplicationArea = Basic;
                }
                field("solution Remarks"; Rec."solution Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                }
                field(Recomendations; Rec.Recomendations)
                {
                    ApplicationArea = Basic;
                }
                field("Support Documents"; Rec."Support Documents")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Resource Assigned"; Rec."Resource Assigned")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Fosa Account"; Rec."Fosa Account")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("loan no"; Rec."loan no")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000031; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Member No");
            }
            part(Control1000000033; "Loans Sub-Page List")
            {
                Caption = 'Loans Details';
                SubPageLink = "Client Code" = field("Member No");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Assign To  Reasorce")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestField("Resource#1");
                    Rec.TestField("Action Taken");
                    Rec.TestField("Date To Settle Case");
                    Rec.TestField("solution Remarks");
                    Rec."Date Sent" := WorkDate;
                    Rec."Time Sent" := Time;
                    Rec."Sent By" := UserId;
                    AssignedReas.Init;
                    AssignedReas."Case Number" := 'ASS' + Rec."Case Number";
                    AssignedReas."Receive date" := Today;
                    AssignedReas."Action Taken" := Rec."Action Taken";
                    AssignedReas."Receive User" := Rec."Resource#1";
                    AssignedReas."Body Handling The Complaint" := Rec."Body Handling The Complaint";
                    AssignedReas."Date To Settle Case" := Rec."Date To Settle Case";
                    AssignedReas."solution Remarks" := Rec."solution Remarks";
                    AssignedReas."Responsibility Center" := Rec."Responsibility Center";
                    AssignedReas."Resource Assigned" := Rec."Resource#1";
                    AssignedReas."Member No" := Rec."Member No";
                    AssignedReas."Account Name" := Rec."Account Name";
                    AssignedReas."Type of cases" := Rec."Type of cases";
                    AssignedReas."loan no" := Rec."loan no";
                    AssignedReas."Fosa Account" := Rec."Fosa Account";
                    AssignedReas."Date of Complaint" := Rec."Date of Complaint";
                    AssignedReas."Sent By" := UserId;
                    if AssignedReas."Resource Assigned" <> '' then
                        Message(AssignedReas."Case Number");
                    AssignedReas.Insert(true);
                    if Rec.Insert = true then;

                    Rec.Status := Rec.Status::Assigned;
                    Rec.Modify;
                    sms();
                    Message('Case has been Assigned to %1', AssignedReas."Resource Assigned");

                    //to be continued tomorrow......
                end;
            }
            action(Receive)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec."Receive User" := UserId;
                    Rec."Receive date" := WorkDate;
                    Rec."Receive Time" := Time;
                    Rec.Modify;
                end;
            }
            action(Resolved)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                begin

                    if Rec.Status = Rec.Status::Resolved then begin
                        Error('Customer query has already been %1', Rec.Status);
                    end;



                    //TO ENABLE RESOLUTION OF CUSTOMER QUERIES LOGGED INTO THE SYSTEM
                    CustCare.SetRange(CustCare.No, Rec."Case Number");
                    if CustCare.Find('-') then begin
                        CustCare.Status := CustCare.Status::Resolved;
                        CustCare."Resolved User" := UserId;
                        CustCare."Resolved Date" := WorkDate;
                        CustCare."Resolved Time" := Time;
                        CustCare.Modify;
                    end;

                    CurrPage.Editable := false;
                end;
            }
        }
    }

    var
        CustCare: Record "General Equiries";
        AssignedReas: Record "Cases Management";
        lineno: Integer;
        SMSMessages: Record "SMS Messages";
        Cust: Record Customer;

    local procedure sms()
    var
        iEntryNo: Integer;
        SMSMessages: Record "SMS Messages";
    begin

        //SMS MESSAGE
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;

        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := Rec."Member No";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'Cases';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
        SMSMessages."SMS Message" := 'Your case/complain has been received and assigned to.' + Rec."Resource#1" +
                                  ' kindly contact the resource for follow ups';
        Cust.Reset;
        if Cust.Get(Rec."Member No") then
            SMSMessages."Telephone No" := Cust."Phone No.";
        SMSMessages.Insert;
    end;

    local procedure smsResolved()
    var
        iEntryNo: Integer;
        SMSMessages: Record "SMS Messages";
    begin

        //SMS MESSAGE
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;

        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := Rec."Member No";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'Cases';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        //SMSMessages."Sent To Server":=SMSMessages."Sent To Server::No;
        SMSMessages."SMS Message" := 'Your case/complain has been resolved by.' + Rec."Resolved User" +
                                  ' Thank you for your being our priority customer';
        Cust.Reset;
        if Cust.Get(Rec."Member No") then
            SMSMessages."Telephone No" := Cust."Phone No.";
        SMSMessages.Insert;
    end;
}

