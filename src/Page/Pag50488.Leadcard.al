#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50488 "Lead card"
{
    PageType = Card;
    SourceTable = "General Equiries.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Enquiring As"; Rec."Calling As")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enquiring As';
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if Rec."Calling As" = Rec."calling as"::"As Member" then begin
                            Asmember := true;
                            AsEmployer := true;
                            Ascase := true;
                            IfMember := true;
                            CurrPage.Update();
                        end;
                        if Rec."Calling As" = Rec."calling as"::"As Non Member" then begin
                            AsNonmember := true;
                            IfMember := false;
                            Asother := true;
                            CurrPage.Update();
                        end;
                        if Rec."Calling As" = Rec."calling as"::"As Staff" then begin
                            AsEmployer := true;
                            Asother := true;
                            Ascase := true;
                            IfMember := false;
                            CurrPage.Update();
                        end;

                    end;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Caption = 'Case Classification';
                }
                field("Enquiring For"; Rec."Calling For")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Contact Mode"; Rec."Contact Mode")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Case Subject"; Rec."Case Subject")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Lead Status"; Rec."Lead Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Case Status';
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Captured On"; Rec."Captured On")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

            }
            group("Lead Details")
            {
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    //Enabled = IfMember;
                    trigger OnValidate()
                    var
                        cust: Record customer;
                        LoansReg: Record "Loans Register";
                    begin
                        cust.Reset();
                        cust.SetRange(cust."No.", Rec."Member No");
                        if cust.Find('-') then begin
                            Rec."Member Name" := cust.Name;
                            Rec."ID No" := cust."ID No.";
                            Rec."ID No." := cust."ID No.";
                            Rec."Phone No" := cust."Mobile Phone No";
                            Rec.Email := cust."E-Mail (Personal)";
                            Rec."Date Of Birth" := cust."Date of Birth";
                            Rec.Gender := cust.Gender;
                        end;
                    end;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Full Name';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Of Birth';
                    ShowMandatory = true;
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = false;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable = false;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID No';
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Escalate Case;"; Rec."Escalate Case")
                {
                    ApplicationArea = Basic;
                    Caption = 'Escalate Case';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec."Escalate Case" = true then begin
                            IsEscalated := true;
                        end else
                            if Rec."Escalate Case" = false then begin
                                IsEscalated := false;
                            end;
                        if Rec."Escalate Case" <> true then begin
                            Escalated := true;//Allow editing
                        end;
                        if (Rec."Escalate Case" = true) and (Rec.Status = Rec.Status::Escalted) then begin
                            Escalated := true;//Allow editing
                        end;
                    end;
                }
            }
            group("Case Description;")
            {
                Caption = 'Case Description';
                Visible = IsEscalated;
                field("Case Details"; Rec."Case Details")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin


                    end;
                }
                field("Caller Reffered To"; Rec."Caller Reffered To")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }

            }
            group("Case Resolution Details")
            {
                field("Resolution Details"; Rec."Resolution Details")
                {
                    ShowMandatory = true;
                    Enabled = Escalated;
                }
                field("Resolved by"; Rec."Resolved by")
                {
                    Enabled = false;
                    Style = Favorable;
                }
                field("Resolved Time"; Rec."Resolved Time")
                {
                    Enabled = false;
                    Style = Favorable;
                }
                field("Resolved Date"; Rec."Resolved Date")
                {
                    Enabled = false;
                    Style = Favorable;
                }
            }
        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Member No");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Email Escalated")
            {
                ApplicationArea = Basic;
                Promoted = true;
                Image = Email;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Attach Email To Delegate';
                PromotedCategory = process;
                RunObject = page "Email Editor";
                Enabled = IsEscalated;
                trigger OnAction()
                begin

                end;
            }
            action("Create")
            {
                ApplicationArea = Basic;
                Caption = 'Escalate Case';
                Image = FixedAssetLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = IsEscalated;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure to Forward case to %1 ?', false, Rec."Caller Reffered To") = false then begin
                        Message('Action Aborted !');
                        exit;
                    end else begin
                        Rec.TestField("Case Details");
                        if Rec.Class = Rec.Class::" " then begin
                            Error('Case Must be classified as either low,medium or high risk');
                        end;
                        Rec.Status := Rec.Status::Escalted;//Escalated
                        Rec."Lead Status" := Rec."Lead Status"::Open;
                        Rec."Time Sent" := time;
                        Rec."Sent By" := UserId;
                        Rec."Escalted By" := UserId;
                        Rec."Escaltion Date" := today;
                        Rec."Escaltion time" := time;
                        Rec.Modify(true);
                        //....................................................
                        //Send sms of case resolution
                        FnSendEscaltionSMS();
                        Message('Case %1 has successfully been forwarded and staff notified.', Format(Rec.No));
                        CurrPage.Close();
                    end;
                end;
            }
            action("Close Case;")
            {
                ApplicationArea = Basic;
                Promoted = true;
                Image = Email;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Close Case';
                PromotedCategory = process;
                Enabled = Not IsEscalated;
                trigger OnAction()
                begin
                    Rec.TestField("Resolution Details");
                    if (UserId = Rec."Captured By") or (UserId = Rec."Delegated To") then begin
                    end else begin
                        Error('Only the staff who opened the case or case delegated to can close this ticket');
                    end;
                    //--------------------------------------------------------------------
                    if Confirm('Are you sure to Mark this ticket as resolved?', false) = false then begin
                        Message('Action Cancelled !');
                        exit;
                    end else begin
                        Rec.TestField("Resolution Details");
                        if Rec.Class = Rec.Class::" " then begin
                            Error('Case Must be classified as either low,medium or high risk');
                        end;
                        Rec.Status := Rec.Status::Resolved;
                        Rec."Lead Status" := Rec."Lead Status"::Closed;
                        Rec."Resolved by" := UserId;
                        Rec."Resolved Date" := today;
                        Rec."Resolved Time" := time;
                        Rec."Date Resolved" := today;
                        Rec."Time Resolved" := time;
                        Rec.Modify(true);
                        //....................................................
                        //Send sms of case resolution
                        FnSendSMS();
                    end;

                end;
            }
            action("Open Member Page")
            {
                ApplicationArea = Basic;
                Promoted = true;
                Image = Card;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Open Member Page';
                PromotedCategory = process;
                RunObject = page "Member Account Card";
                Enabled = IsEnabled;
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Resolved then begin
            CurrPage.Editable := false;
            IsEnabled := false;
        end else
            if Rec.Status <> Rec.Status::Resolved then begin
                IsEnabled := true;
            end;
        if Rec."Calling As" = Rec."calling as"::"As Member" then begin
            Asmember := true;
            AsEmployer := true;
            Ascase := true;
            IfMember := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Non Member" then begin
            AsNonmember := true;
            IfMember := false;
            Asother := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Staff" then begin
            AsEmployer := true;
            Asother := true;
            Ascase := true;
            IfMember := false;
        end;
        if Rec."Escalate Case" = true then begin
            IsEscalated := true;
        end else
            if Rec."Escalate Case" = false then begin
                IsEscalated := false;
            end;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Calling As" = Rec."calling as"::"As Non Member" then begin
            AsNonmember := true;
            Asother := true;
        end;
        if Rec."Escalate Case" <> true then begin
            Escalated := true;//Allow editing
        end;
        if (Rec."Escalate Case" = true) and (Rec.Status = Rec.Status::Escalted) then begin
            Escalated := true;//Allow editing
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin

    end;

    procedure FnSendSMS()
    var
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
    begin
        SMSMessages.RESET;
        IF SMSMessages.FIND('+') THEN BEGIN
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        END
        ELSE BEGIN
            iEntryNo := 1;
        END;

        SMSMessages.RESET;
        SMSMessages.INIT;
        SMSMessages."Entry No" := iEntryNo;
        IF Rec."Member No" <> '' THEN begin
            SMSMessages."Account No" := Rec."Member No";
        end else
            IF Rec."Member No" = '' THEN begin
                SMSMessages."Account No" := 'NON-MEMBER';
            end;
        SMSMessages."Date Entered" := TODAY;
        SMSMessages."Time Entered" := TIME;
        SMSMessages.Source := 'CRM';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
        SMSMessages."SMS Message" := 'Good news! Your query has been resolved. If you have any more concerns or require further assistance, please feel free to contact us.Thank you for being a valued member. Jamii Yetu Sacco.';
        SMSMessages."Telephone No" := Rec."Phone No";
        SMSMessages.INSERT;
    end;

    local procedure FnSendEscaltionSMS()
    var
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
    begin
        SMSMessages.RESET;
        IF SMSMessages.FIND('+') THEN BEGIN
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        END
        ELSE BEGIN
            iEntryNo := 1;
        END;

        SMSMessages.RESET;
        SMSMessages.INIT;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := Rec."Caller Reffered To";
        SMSMessages."Date Entered" := TODAY;
        SMSMessages."Time Entered" := TIME;
        SMSMessages.Source := 'CRM';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
        SMSMessages."SMS Message" := 'Dear staff, Ticket No. ' + Format(Rec.No) + ' subject-' + Format(Rec."Calling For") + ' has been raised and requires your immediate attention. Jamii Yetu Sacco.';
        SMSMessages."Telephone No" := FnGetPhoneNo(Rec."Caller Reffered To");
        SMSMessages.INSERT;
    end;

    local procedure FnGetPhoneNo(CallerRefferedTo: Code[50]): Code[30]
    var
        usersetup: Record "User Setup";
    begin
        usersetup.Reset();
        usersetup.SetRange(usersetup."User ID", CallerRefferedTo);
        if usersetup.Find('-') then begin
            usersetup.TestField(usersetup."Phone No.");
            exit(usersetup."Phone No.");
        end;
    end;

    var
        Cust: Record Customer;
        IfMember: Boolean;
        CustCare: Record "General Equiries.";
        CQuery: Record "General Equiries.";
        employer: Record "Sacco Employers";
        LeadM: Record "Lead Management";
        entry: Integer;
        IsEscalated: Boolean;
        vend: Record Vendor;
        AsEmployer: Boolean;
        Asmember: Boolean;
        AsNonmember: Boolean;
        Asother: Boolean;
        Ascase: Boolean;
        ok: Boolean;
        Escalated: Boolean;
        LeadSetup: Record "Crm General Setup.";
        LeadNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CaseNO: Code[20];
        CaseSetup: Record "Crm General Setup.";
        sure: Boolean;
        IsEnabled: Boolean;
        EmploymentInfoEditable: Boolean;
        EmployedEditable: Boolean;
        ContractingEditable: Boolean;
        NatureofBussEditable: Boolean;
        IndustryEditable: Boolean;
        BusinessNameEditable: Boolean;
        PhysicalBussLocationEditable: Boolean;
        YearOfCommenceEditable: Boolean;
        FromDisplayName: Text[100];
        ToRecipient: Text[100];
        EmailBody: Text;

        CcRecipient: Text[1000];
        PositionHeldEditable: Boolean;
        EmploymentDateEditable: Boolean;
        EmployerAddressEditable: Boolean;
        EmployerCodeEditable: Boolean;
        DepartmentEditable: Boolean;
        EmailSubject: text[1000];
        TermsofEmploymentEditable: Boolean;
        OccupationEditable: Boolean;
        OthersEditable: Boolean;
        MonthlyIncomeEditable: Boolean;
}

