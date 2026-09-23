#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50521 "Crm log card"
{
    PageType = Card;
    SourceTable = "General Equiries";
    SourceTableView = where(Send = const(false));

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
                field("Calling As"; Rec."Calling As")
                {
                    ApplicationArea = Basic;
                }
                field("Calling For"; Rec."Calling For")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Mode"; Rec."Contact Mode")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Lead Details")
            {
                Visible = AsNonmember;
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = Basic;
                }
                field(SurName; Rec.SurName)
                {
                    ApplicationArea = Basic;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field("Id Number"; Rec."Passport No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Member Information")
            {
                Visible = Asmember;
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Share Capital"; Rec."Share Capital")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Deposits"; Rec."Current Deposits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = Basic;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Case Information")
            {
                Visible = Ascase;
                field("Type of cases"; Rec."Type of cases")
                {
                    ApplicationArea = Basic;
                }
                field("Case Description"; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Query Code"; Rec."Query Code")
                {
                    ApplicationArea = Basic;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Caller Reffered To"; Rec."Caller Reffered To")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Employer Information")
            {
                Visible = AsEmployer;
                field("company No"; Rec."company No")
                {
                    ApplicationArea = Basic;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                }
                field("Company Address"; Rec."Company Address")
                {
                    ApplicationArea = Basic;
                }
                field("Company postal code"; Rec."Company postal code")
                {
                    ApplicationArea = Basic;
                }
                field("Company Telephone"; Rec."Company Telephone")
                {
                    ApplicationArea = Basic;
                }
                field("Company Email"; Rec."Company Email")
                {
                    ApplicationArea = Basic;
                }
                field("Company website"; Rec."Company website")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Detailed Member Page")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Checkoff Processing Lines-D";
                RunPageLink = "Staff/Payroll No" = field("Member No");
            }
            action(Forward)
            {
                ApplicationArea = Basic;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //Get lead
                    if (Rec."Calling As" = Rec."calling as"::"As Non Member") or (Rec."Calling As" = Rec."calling as"::"As Others") then begin
                        LeadM.Init;
                        LeadM."No." := Rec.No;
                        LeadM."First Name" := Rec."First Name";
                        LeadM."Middle Name" := Rec.SurName;
                        LeadM.Surname := Rec."Last Name";
                        LeadM."member no" := Rec."Member No";
                        LeadM.Name := Rec."Member Name";
                        LeadM.Address := Rec.Address;
                        LeadM.City := Rec.city;
                        LeadM."Phone No." := Rec."Phone No";
                        LeadM."Company No." := Rec."company No";
                        LeadM."Company Name" := Rec."Company Name";
                        LeadM.Name := Rec."First Name" + '' + Rec.SurName + '' + '' + Rec."Last Name";
                        LeadM.Type := Rec."Calling As";
                        LeadM."ID No" := Rec."ID No";
                        LeadM."Receive date" := Today;
                        LeadM."Receive Time" := Time;
                        LeadM."Received From" := UserId;
                        LeadM."Sent By" := UserId;
                        LeadM."Caller Reffered To" := Rec."Caller Reffered To";
                        LeadM.Description := Rec.Description;
                        LeadM.Insert(true);
                        Rec.Send := true;
                        Message('opportunity successfully generated');

                    end;
                    //categories lead

                    //get the CASE INFORMATION
                    if Rec."Calling As" = Rec."calling as"::"As Member" then begin
                        if (Rec."Calling For" = Rec."calling for"::Complaint) or (Rec."Calling For" = Rec."calling for"::Payment) or (Rec."Calling For" = Rec."calling for"::Receipt) or (Rec."Calling For" = Rec."calling for"::"Loan Form") then begin
                            Rec.TestField("Type of cases");
                            if Rec."Type of cases" = Rec."type of cases"::Loan then begin
                                Rec.TestField("Loan No");
                            end;
                            CASEM.Init;
                            CASEM."Case Number" := Rec.No;
                            CASEM."Member No" := Rec."Member No";
                            CASEM."Fosa Account" := Rec."Fosa account";
                            CASEM."Account Name" := Rec."Member Name";
                            CASEM."loan no" := Rec."Loan No";
                            CASEM."Date of Complaint" := Today;
                            CASEM."Type of cases" := Rec."Type of cases";
                            CASEM."Time Sent" := Time;
                            CASEM."Date Sent" := Today;
                            CASEM."Receive date" := Today;
                            CASEM."Caller Reffered To" := Rec."Caller Reffered To";
                            CASEM."Case Description" := Rec.Description;
                            if CASEM."Case Number" <> '' then
                                Message('Member Case created ');
                            Rec.Send := true;
                            CASEM.Insert(true);
                        end else
                            CASEM.Init;
                        CASEM."Case Number" := Rec.No;
                        CASEM."Member No" := Rec."Member No";
                        CASEM."Fosa Account" := Rec."Fosa account";
                        CASEM."Account Name" := Rec."Member Name";
                        CASEM."loan no" := Rec."Loan No";
                        CASEM."Date of Complaint" := Today;
                        CASEM."Type of cases" := Rec."Type of cases";
                        CASEM."Time Sent" := Time;
                        CASEM."Date Sent" := Today;
                        CASEM."Receive date" := Today;
                        CASEM."Caller Reffered To" := Rec."Caller Reffered To";
                        CASEM."Case Description" := Rec.Description;
                        if CASEM."Case Number" <> '' then
                            Message('Member Case created ');
                        Rec.Send := true;

                        CASEM.Insert(true);
                    end;

                    //company cases
                    if Rec."Calling As" = Rec."calling as"::"As Employer" then begin
                        if (Rec."Calling For" = Rec."calling for"::Complaint) or (Rec."Calling For" = Rec."calling for"::Payment) or (Rec."Calling For" = Rec."calling for"::Receipt) then begin
                            Rec.TestField("Type of cases");
                            Rec.TestField("Query Code");
                            if Rec."Type of cases" <> Rec."type of cases"::"Payment/Receipt/Advice" then
                                Error('Case must be Payment/Receipt/Advice');
                            CASEM.Init;
                            CASEM."Case Number" := Rec.No;
                            CASEM."company No" := Rec."Query Code";
                            CASEM."Company Name" := Rec."Company Name";
                            CASEM."Company Address" := Rec."Company Address";
                            CASEM."Company Email" := Rec."Company Email";
                            CASEM."Date of Complaint" := Today;
                            CASEM."Company postal code" := Rec."Company postal code";
                            CASEM."Company Telephone" := Rec."Company Telephone";
                            CASEM."Type of cases" := Rec."Type of cases";
                            CASEM."Time Sent" := Time;
                            CASEM."Date Sent" := Today;
                            CASEM."Receive date" := Today;
                            CASEM."Caller Reffered To" := Rec."Caller Reffered To";
                            CASEM."Case Description" := Rec.Description;
                            if CASEM."Case Number" <> '' then
                                Rec.Send := true;
                            Message('Employer Case created ');
                        end;
                        CASEM.Insert(true);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AsEmployer := false;
        Asmember := false;
        AsNonmember := false;
        Asother := false;
        Ascase := false;
        if Rec."Calling As" = Rec."calling as"::"As Member" then begin
            Asmember := true;
            AsEmployer := true;
            Ascase := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Non Member" then begin
            AsNonmember := true;
            Asother := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Employer" then begin
            AsEmployer := true;
            Asother := true;
            Ascase := true;
        end;
    end;

    trigger OnOpenPage()
    begin
        AsEmployer := false;
        Asmember := false;
        AsNonmember := false;
        Asother := false;
        Ascase := false;
        if Rec."Calling As" = Rec."calling as"::"As Member" then begin
            Asmember := true;
            AsEmployer := true;
            Ascase := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Non Member" then begin
            AsNonmember := true;
            Asother := true;
        end;
        if Rec."Calling As" = Rec."calling as"::"As Employer" then begin
            AsEmployer := true;
            Ascase := true;
        end;
    end;

    var
        Cust: Record Customer;
        PvApp: Record "Loans Register";
        CustCare: Record "General Equiries";
        CQuery: Record "General Equiries";
        employer: Record "Sacco Employers";
        membApp: Record "Membership Applications";
        LeadM: Record "Lead Management";
        entry: Integer;
        vend: Record Vendor;
        CASEM: Record "Cases Management";
        AsEmployer: Boolean;
        Asmember: Boolean;
        AsNonmember: Boolean;
        Asother: Boolean;
        Ascase: Boolean;
}

