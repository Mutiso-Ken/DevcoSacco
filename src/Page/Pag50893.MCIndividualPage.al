#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50893 "MC Individual Page"
{
    Caption = 'Member Card';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = Customer;
    SourceTableView = where("Customer Posting Group" = const('MICRO'),
                            "Global Dimension 1 Code" = const('MICRO'),
                            "Group Account" = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Memebership No.';
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Old Memebership No.';
                    visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Member Name';
                    Style = StrongAccent;
                }
                field("BOSA Account No."; Rec."BOSA Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    visible = false;
                }

                field("Payroll/Staff No"; Rec."Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("FOSA Account"; Rec."FOSA Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        FosaName := '';

                        if Rec."FOSA Account" <> '' then begin
                            if Vend.Get(Rec."FOSA Account") then begin
                                FosaName := Vend.Name;
                            end;
                        end;
                    end;
                }
                field(FosaName; FosaName)
                {
                    ApplicationArea = Basic;
                    Caption = 'FOSA Account Name';
                    Editable = false;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    // trigger OnValidate()
                    // begin
                    //     lblIDVisible := true;
                    //     lblDOBVisible := true;
                    //     lblRegNoVisible := false;
                    //     lblRegDateVisible := false;
                    //     lblGenderVisible := true;
                    //     txtGenderVisible := true;
                    //     lblMaritalVisible := true;
                    //     txtMaritalVisible := true;
                    //     if "Account Category" <> "account category"::SINGLE then begin
                    //         lblIDVisible := false;
                    //         lblDOBVisible := false;
                    //         lblRegNoVisible := true;
                    //         lblRegDateVisible := true;
                    //         lblGenderVisible := false;
                    //         txtGenderVisible := false;
                    //         lblMaritalVisible := false;
                    //         txtMaritalVisible := false;

                    //     end;
                    // end;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID Number';
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No.';
                    Editable = false;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer';
                    Editable = false;
                }
                field("Job Title"; Rec."Job title")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Title';
                    Editable = false;
                }
                field(PIN; Rec.Pin)
                {
                    ApplicationArea = Basic;
                    Caption = 'PIN';
                    Editable = false;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(txtMarital; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marital Status';
                    Visible = txtMaritalVisible;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date of Birth';
                    Editable = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        StatusPermissions.Reset;
                        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
                        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::"Overide Defaulters");
                        if StatusPermissions.Find('-') = false then
                            Error('You do not have permissions to change the account status.');
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Currect File Location"; Rec."Currect File Location")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("File Movement Remarks"; Rec."File Movement Remarks")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group("Group Details")
            {
                Caption = 'Group Details';
                // field("Group Account No"; "Group Account No")
                // {
                //     ApplicationArea = Basic;
                //     Style = StrongAccent;
                // }
                field("Group Account"; Rec."Group Account")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Group Account Name"; Rec."Group Account Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Loan Officer Name"; Rec."Loan Officer Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }

            }
            group("Other Details")
            {
                Caption = 'Other Details';
                Editable = true;
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Person Phone"; Rec."Contact Person Phone")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Village/Residence"; Rec."Village/Residence")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Address';
                    Visible = false;
                }
                field("Withdrawal Application Date"; Rec."Withdrawal Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Date"; Rec."Withdrawal Date")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Fee"; Rec."Withdrawal Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Status - Withdrawal App."; Rec."Status - Withdrawal App.")
                {
                    ApplicationArea = Basic;

                }
                field("Mode of Dividend Payment"; Rec."Mode of Dividend Payment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("CEEP Statistics FactBox"; "CEEP Statistics FactBox")
            {
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1102755023)
            {
                action("<Page Customer Ledger Entries>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Ledger Entries";
                    RunPageLink = "Customer No." = field("No.");
                    RunPageView = sorting("Customer No.");
                }
                action("Members Statistics")
                {
                    ApplicationArea = Basic;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Members Statistics";
                    RunPageLink = "No." = field("No.");
                }
                separator(Action1102755021)
                {
                }
                action("Detailed Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Statement';
                    Image = "Report";
                    PromotedCategory = Process;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50223, true, false, Cust);
                    end;
                }
                separator(Action1102755011)
                {
                }

                separator(Action1000000005)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FosaName := '';

        // if "FOSA Account" <> '' then begin
        //     if Vend.Get("FOSA Account") then begin
        //         FosaName := Vend.Name;
        //     end;
        // end;

        // lblIDVisible := true;
        // lblDOBVisible := true;
        // lblRegNoVisible := false;
        // lblRegDateVisible := false;
        // lblGenderVisible := true;
        // txtGenderVisible := true;
        // lblMaritalVisible := true;
        // txtMaritalVisible := true;

        // if "Account Category" <> "account category"::SINGLE then begin
        //     lblIDVisible := false;
        //     lblDOBVisible := false;
        //     lblRegNoVisible := true;
        //     lblRegDateVisible := true;
        //     lblGenderVisible := false;
        //     txtGenderVisible := false;
        //     lblMaritalVisible := false;
        //     txtMaritalVisible := false;

        // end;
        OnAfterGetCurrRec;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := Rec.Find(Which);
        CurrPage.Editable := RecordFound or (Rec.GetFilter("No.") = '');
        exit(RecordFound);
    end;

    trigger OnInit()
    begin
        txtMaritalVisible := true;
        lblMaritalVisible := true;
        txtGenderVisible := true;
        lblGenderVisible := true;
        lblRegDateVisible := true;
        lblRegNoVisible := true;
        lblDOBVisible := true;
        lblIDVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        OnAfterGetCurrRec;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        ActivateFields;


    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        Text001: label 'Do you want to allow payment tolerance for entries that are currently open?';
        CustomizedCalendar: Record "Customized Calendar Change";
        Text002: label 'Do you want to remove payment tolerance from entries that are currently open?';
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        PictureExists: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        StatusPermissions: Record "Status Change Permision";
        Charges: Record Charges;
        Vend: Record Vendor;
        Cust: Record Customer;
        LineNo: Integer;
        UsersID: Record User;
        GeneralSetup: Record "Sacco General Set-Up";
        Loans: Record "Loans Register";
        AvailableShares: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        TotalRecovered: Decimal;
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
        LoansR: Record "Loans Register";
        DActivity: Code[20];
        DBranch: Code[20];
        Accounts: Record Vendor;
        FosaName: Text[50];
        [InDataSet]
        lblIDVisible: Boolean;
        [InDataSet]
        lblDOBVisible: Boolean;
        [InDataSet]
        lblRegNoVisible: Boolean;
        [InDataSet]
        lblRegDateVisible: Boolean;
        [InDataSet]
        lblGenderVisible: Boolean;
        [InDataSet]
        txtGenderVisible: Boolean;
        [InDataSet]
        lblMaritalVisible: Boolean;
        [InDataSet]
        txtMaritalVisible: Boolean;
        AccNo: Code[20];
        Vendor: Record Vendor;
        TotalAvailable: Decimal;
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        TotalDefaulterR: Decimal;
        value2: Decimal;
        Value1: Decimal;
        RoundingDiff: Decimal;
        OldValueOfficer: Code[10];


    procedure ActivateFields()
    begin
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

