#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50523 "Opportunity card."
{
    PageType = Card;
    SourceTable = "Lead Management";

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
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = Basic;
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Dates)
            {
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Next To-do Date"; Rec."Next To-do Date")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Attempted"; Rec."Last Date Attempted")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Last Interaction"; Rec."Date of Last Interaction")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Opportunity details")
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Lost Reasons"; Rec."Lost Reasons")
                {
                    ApplicationArea = Basic;
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = Basic;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("External ID"; Rec."External ID")
                {
                    ApplicationArea = Basic;
                }
                field("Duration (Min.)"; Rec."Duration (Min.)")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Opportunities"; Rec."No. of Opportunities")
                {
                    ApplicationArea = Basic;
                }
                field(status; Rec.status)
                {
                    ApplicationArea = Basic;
                }
                field("Lead Type"; Rec."Lead Type")
                {
                    ApplicationArea = Basic;
                }
                field("member no"; Rec."member no")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000028; "Loans Sub-Page List")
            {
                Caption = 'Loans Details';
                SubPageLink = "Client Code" = field("member no");
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
                RunPageLink = "Staff/Payroll No" = field("member no");
            }
            action("Send To")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestField("Caller Reffered To");
                    Rec."Date Sent" := WorkDate;
                    Rec."Time Sent" := Time;
                    Rec."Sent By" := UserId;
                    Rec.Modify;
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
            action("Create Opportunity")
            {
                ApplicationArea = Basic;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec."Lead Type" = Rec."lead type"::"As Employer" then begin
                        employer.Init;
                        employer.Code := Rec."Company No.";
                        employer.Description := Rec."Company Name";
                        employer."Join Date" := Today;
                        employer.Insert(true);
                        Message('opportunity successfully generated');
                    end;
                    if Rec."Lead Type" = Rec."lead type"::"As Non Member" then begin
                        membApp.Init;
                        membApp."No." := Rec."No.";
                        //membApp."First member name":="First Name";
                        membApp.Name := Rec.Name;
                        membApp.Address := Rec.Address;
                        membApp."ID No." := Rec."ID No";
                        membApp."Customer Posting Group" := 'MEMBER';
                        membApp."Customer Type" := membApp."customer type"::Member;
                        membApp.City := Rec.City;
                        membApp."Recruited By" := UserId;
                        membApp."Registration Date" := Today;
                        membApp.Insert(true);
                        Message('opportunity successfully generated');

                    end;
                    // LOAN FORM
                    /*  IF "Lead Type"="Lead Type"::"As member" THEN BEGIN
                        IF M*/
                    //get the CASE INFORMATION

                end;
            }
        }
    }

    var
        PvApp: Record "Loans Register";
        CustCare: Record "General Equiries";
        CQuery: Record "General Equiries";
        employer: Record "Sacco Employers";
        membApp: Record "Membership Applications";
        LeadM: Record "Lead Management";
        entry: Integer;
        vend: Record Vendor;
        CASEM: Record "Cases Management";
}

