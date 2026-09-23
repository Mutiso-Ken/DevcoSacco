codeunit 50160 "Portal Integration"
{

    trigger OnRun()
    begin

    end;

    var
        Title: Label 'title';
        Message: Label 'message';
        Status: Label 'status';
        Data: Label 'data';
        LoansRegister: Record "Loans Register";
        GenJournalLine: Record "Gen. Journal Line";
        LoanCharges: Record "Loan Product Charges";

    // ################################################################################################
    // MAIN FUNCTIONS
    // ################################################################################################
    procedure ProcessRequest(Request: Text) Response: Text;
    var
        RequestJson: JsonObject;
        OutputJson: JsonObject;
        RequestDataJson: JsonObject;
        RequestAction: Text;
        SessionId: Text;
        SessionValid: Boolean;
    begin
        if not RequestJson.ReadFrom(Request) then
            Error('Invalid Json Input');

        SessionId := SelectJsonToken(RequestJson, '$.session_id').AsValue.AsText;
        RequestAction := SelectJsonToken(RequestJson, '$.action').AsValue.AsText;

        RequestDataJson := SelectJsonToken(RequestJson, '$.payload').AsObject();

        ValidateRequestHash(RequestJson);

        SessionValid := true;

        if not (RequestAction in ['login']) then begin
            SessionValid := ValidateUserSession(RequestJson);
        end;

        if SessionValid then begin
            case RequestAction of
                'get-member-details':
                    begin
                        OutputJson := GetMemberDetails(RequestDataJson);
                    end;
                'GET_ACCOUNTS':

                    begin
                        OutputJson := GetAccountsPortal(RequestDataJson);//Done
                    end;

                'GET_LOAN_CALCULATOR_PARAMETERS':
                    begin
                        OutputJson := GetLoanCalculatorParameters(RequestDataJson);//iKO SAWA
                    end;
                'GET_LOAN_REPAYMENT_SCHEDULE_REPORT':
                    begin
                        OutputJson := GetLoanRepaymentScheduleReportPortal(RequestDataJson);//Done
                    end;
                'GET_LOAN_STATEMENT':
                    begin
                        OutputJson := GetLoanStatementPortal(RequestDataJson); //Done to test
                    end;
                'GET_LOAN_GUARANTORS':
                    begin
                        OutputJson := GetLoanGuarantorsPortal(RequestDataJson);//iko sawa
                    end;
                'GET_LOANS_GUARANTEED':
                    begin
                        OutputJson := GetLoansGuaranteedPortal(RequestDataJson);//iko sawa
                    end;
                'GET_LOAN_TYPES':
                    begin
                        OutputJson := GetLoanTypesPortal(RequestDataJson);//iko swa
                    end;
                'GET_LOAN_STATEMENT_REPORT':
                    begin
                        OutputJson := GetLoanStatementReportPortal(RequestDataJson); //checked ending Testing
                    end;
                // 'GET_ACCOUNT_DETAILS':
                //     begin
                //         OutputJson := GetAccountDetailsPortal(RequestDataJson);
                //     end;
                'GET_LOANS':
                    begin
                        OutputJson := GetLoansPortal(RequestDataJson);//iko sawa
                    end;
                'MEMBER_REGISTRATION':
                    begin
                        OutputJson := GetMemberRegistration(RequestDataJson);//iko sawa
                    end;
                'SEND_SMS':
                    begin
                        OutputJson := SendPortalSMSMessages(RequestDataJson);
                    end;
                // 'charge-mapp-service':
                //     begin
                //         OutputJson := ChargeMappService(RequestDataJson);
                //     end;
                // 'get-atm-cards':
                //     begin
                //         OutputJson := GetATMCards(RequestDataJson);
                //     end;
                // 'action_atm_card':
                //     begin
                //         OutputJson := ActionATMCards(RequestDataJson);
                //     end;

                'GET_NEXT_OF_KIN':
                    begin
                        OutputJson := GetNextOfKin(RequestDataJson);//iko sawa
                    end;
                // 'balance-enquiry':
                //     begin
                //         OutputJson := BalanceEnquiry(RequestDataJson);
                //     end;
                // 'statement-enquiry':
                //     begin
                //         OutputJson := StatementEnquiry(RequestDataJson);
                //     end;
                'GET_ACCOUNT_STATEMENT':
                    begin
                        OutputJson := GetAccountStatementPortal(RequestDataJson);
                    end;
                // 'GET_RECENT_ACCOUNT_TRANSACTIONS':
                //     begin
                //         OutputJson := GetRecentAccountTransactionsPortal(RequestDataJson);
                //     end;
                'GET_LOAN_DETAILS':
                    begin
                        OutputJson := GetLoanDetailsPortal(RequestDataJson); //checked
                    end;
                'GET_ACCOUNT_STATEMENT_REPORT':
                    begin
                        OutputJson := GetAccountStatementReportPortal(RequestDataJson); // Checked
                    end;

                'GET_DIVIDEND_PAYSLIP_REPORT':
                    begin
                        OutputJson := GetDividendPayslipReportPortal(RequestDataJson);
                    end;

                'GET_DIVIDENDS_PAYSLIP_PERIODS':
                    begin
                        OutputJson := GetDividendPayslipPeriods(RequestDataJson);
                    end;


            end;
        end
        else begin
            SetResponseStatus(OutputJson, 'error', '401 Unauthorized', 'Your request could not be processed');
        end;

        Response := WrapResponse(RequestJson, OutputJson);
    end;


    // ################################################################################################
    // REQUEST PROCESSING PROCEDURES (MATUMBO)
    // ################################################################################################
    local procedure GetMemberDetails(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        Customer: Record Customer;
        Found: Boolean;
    begin

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Found := false;
        if IdentifierType = 'MSISDN' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
            if Customer.FindFirst() then begin

                SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
                DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
                DataJson.Add('identifier_type', 'CUSTOMER_NO');
                DataJson.Add('identifier', Customer."No.");
                DataJson.Add('primary_identity_type', UpperCase(Format(Customer."ID No.")));
                DataJson.Add('primary_identity_no', Customer."ID No.");
                DataJson.Add('title', Format(Customer.Title));
                DataJson.Add('full_name', Customer.Name);
                DataJson.Add('gender', UpperCase(Format(Customer.Gender)));
                DataJson.Add('date_of_birth', Customer."Date Of Birth");
                DataJson.Add('primary_email_address', Customer."E-Mail (Personal)");
                DataJson.Add('primary_mobile_number', Customer."Mobile Phone No");
                DataJson.Add('status', UpperCase(Format(Customer.Status)));
                DataJson.Add('registration_date', Customer."Registration Date");
                DataJson.Add('tax_authority', 'KRA');
                DataJson.Add('tax_authority_pin_number', Customer.Pin);
                DataJson.Add('branch_code', '100');
                DataJson.Add('branch', 'NAIROBI');
                DataJson.Add('main_savings_account_no', Customer."No.");
                Found := true;
            end;
        end;


        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
            if Customer.FindFirst() then begin

                SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
                DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
                DataJson.Add('identifier_type', 'CUSTOMER_NO');
                DataJson.Add('identifier', Customer."No.");
                DataJson.Add('primary_identity_type', UpperCase(Format(Customer."ID No.")));
                DataJson.Add('primary_identity_no', Customer."ID No.");
                DataJson.Add('title', Format(Customer.Title));
                DataJson.Add('full_name', Customer.Name);
                DataJson.Add('gender', UpperCase(Format(Customer.Gender)));
                DataJson.Add('date_of_birth', Customer."Date Of Birth");
                DataJson.Add('primary_email_address', Customer."E-Mail (Personal)");
                DataJson.Add('primary_mobile_number', Customer."Mobile Phone No");
                DataJson.Add('status', UpperCase(Format(Customer.Status)));
                DataJson.Add('registration_date', Customer."Registration Date");
                DataJson.Add('tax_authority', 'KRA');
                DataJson.Add('tax_authority_pin_number', Customer.Pin);
                DataJson.Add('branch_code', '100');
                DataJson.Add('branch', 'NAIROBI');
                DataJson.Add('main_savings_account_no', Customer."No.");
                Found := true;
            end;
        end;


        if IdentifierType = 'MEMBER_NUMBER' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
            if Customer.FindFirst() then begin

                SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
                DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
                DataJson.Add('identifier_type', 'CUSTOMER_NO');
                DataJson.Add('identifier', Customer."No.");
                DataJson.Add('primary_identity_type', UpperCase(Format(Customer."ID No.")));
                DataJson.Add('primary_identity_no', Customer."ID No.");
                DataJson.Add('title', Format(Customer.Title));
                DataJson.Add('full_name', Customer.Name);
                DataJson.Add('gender', UpperCase(Format(Customer.Gender)));
                DataJson.Add('date_of_birth', Customer."Date Of Birth");
                DataJson.Add('primary_email_address', Customer."E-Mail (Personal)");
                DataJson.Add('primary_mobile_number', Customer."Mobile Phone No");
                DataJson.Add('status', UpperCase(Format(Customer.Status)));
                DataJson.Add('registration_date', Customer."Registration Date");
                DataJson.Add('tax_authority', 'KRA');
                DataJson.Add('tax_authority_pin_number', Customer.Pin);
                DataJson.Add('branch_code', '100');
                DataJson.Add('branch', 'NAIROBI');
                DataJson.Add('main_savings_account_no', Customer."No.");
                Found := true;
            end;
        end;

        if IdentifierType = 'CUSTOMER_NO' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
            if Customer.FindFirst() then begin

                SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
                DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
                DataJson.Add('identifier_type', 'CUSTOMER_NO');
                DataJson.Add('identifier', Customer."No.");
                DataJson.Add('primary_identity_type', UpperCase(Format(Customer."ID No.")));
                DataJson.Add('primary_identity_no', Customer."ID No.");
                DataJson.Add('title', Format(Customer.Title));
                DataJson.Add('full_name', Customer.Name);
                DataJson.Add('gender', UpperCase(Format(Customer.Gender)));
                DataJson.Add('date_of_birth', Customer."Date Of Birth");
                DataJson.Add('primary_email_address', Customer."E-Mail (Personal)");
                DataJson.Add('primary_mobile_number', Customer."Mobile Phone No");
                DataJson.Add('status', UpperCase(Format(Customer.Status)));
                DataJson.Add('registration_date', Customer."Registration Date");
                DataJson.Add('tax_authority', 'KRA');
                DataJson.Add('tax_authority_pin_number', Customer.Pin);
                DataJson.Add('branch_code', '100');
                DataJson.Add('branch', 'NAIROBI');
                DataJson.Add('main_savings_account_no', Customer."No.");
                Found := true;
            end;
        end;

        if IdentifierType = 'ACCOUNT_NUMBER' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
            if Customer.FindFirst() then begin

                SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
                DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
                DataJson.Add('identifier_type', 'CUSTOMER_NO');
                DataJson.Add('identifier', Customer."No.");
                DataJson.Add('primary_identity_type', UpperCase(Format(Customer."ID No.")));
                DataJson.Add('primary_identity_no', Customer."ID No.");
                DataJson.Add('title', Format(Customer.Title));
                DataJson.Add('full_name', Customer.Name);
                DataJson.Add('gender', UpperCase(Format(Customer.Gender)));
                DataJson.Add('date_of_birth', Customer."Date Of Birth");
                DataJson.Add('primary_email_address', Customer."E-Mail (Personal)");
                DataJson.Add('primary_mobile_number', Customer."Mobile Phone No");
                DataJson.Add('status', UpperCase(Format(Customer.Status)));
                DataJson.Add('registration_date', Customer."Registration Date");
                DataJson.Add('tax_authority', 'KRA');
                DataJson.Add('tax_authority_pin_number', Customer.Pin);
                DataJson.Add('branch_code', '100');
                DataJson.Add('branch', 'NAIROBI');
                DataJson.Add('main_savings_account_no', Customer."No.");
                Found := true;
            end;
        end;

        if Found = false then begin
            SetResponseStatus(ResponseJson, 'error', 'Error', 'An error occurred');
        end;


        ResponseJson.Add(Data, DataJson);
    end;

    Local procedure SendPortalSMSMessages(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        Phone_Number: Text[100];
        Message: Text[1000];
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        IdentifierType: Text;
        Identifier: Text;
        DataJson: JsonObject;

    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Phone_Number := SelectJsonToken(RequestJson, '$.phone_number').AsValue.AsText;
        Message := SelectJsonToken(RequestJson, '$.Message').AsValue.AsText;

        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN begin

            SMSMessages.Reset;
            if SMSMessages.Find('+') then begin
                iEntryNo := SMSMessages."Entry No";
                iEntryNo := iEntryNo + 1;
            end else begin
                iEntryNo := 1;
            end;

            SMSMessages.Init;
            SMSMessages."Entry No" := iEntryNo;
            SMSMessages."Account No" := '';
            SMSMessages."Date Entered" := Today;
            SMSMessages."Time Entered" := Time;
            SMSMessages.Source := 'PORTAL';
            SMSMessages."Entered By" := UserId;
            SMSMessages."System Created Entry" := true;
            SMSMessages."Document No" := ' ';
            SMSMessages."Telephone No" := Phone_Number;
            SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
            SMSMessages."SMS Message" := Message;
            SMSMessages.Insert;
            SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
            ResponseJson.Add(Data, DataJson);
        end;
    end;

    local procedure GetMemberRegistration(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        MembershipApplication: Record "Membership Applications";
        MemberNextofKin: Record "Member App Next Of kin";
        DataJson: JsonObject;
        FullNames: text[100];
        Phone_Number: Text[100];
        Email_address: Text[100];
        Gender: Option Male,Female;
        Date_of_birth: Date;
        Id_number: Text[100];
        Passport_number: Text[199];
        Home_address: Text[100];
        Citizen: Text[100];
        //Next of Kin
        kin_Fullname: Text[100];
        kin_Relationship: Text[100];
        Kin_Identifiertype: Text[100];
        Kin_identifier: Text[100];
        kin_PhoneNumber: Text[100];
        Kin_EmailAddress: Text[100];
        kin_Percentage: Decimal;
        kin_Beneficiary: Boolean;
        //Recruiter
        Recruiter_Identifier_Type: Text[100];
        Recruiter_identifier: Text[100];
        T_and_c_accepted: Boolean;
        JArray: JsonArray;
        NOKObject: JsonObject;
    begin

        FullNames := SelectJsonToken(RequestJson, '$.full_name').AsValue.AsText;
        Phone_Number := SelectJsonToken(RequestJson, '$.phone_number').AsValue.AsText;
        Email_address := SelectJsonToken(RequestJson, '$.email_name').AsValue.AsText;
        Gender := SelectJsonToken(RequestJson, '$.gender').AsValue.AsOption();
        Date_of_birth := SelectJsonToken(RequestJson, '$.date_of_birth').AsValue.AsDate();
        Id_number := SelectJsonToken(RequestJson, '$.Id_number').AsValue.AsText();
        Passport_number := SelectJsonToken(RequestJson, '$.Passport_number').AsValue.AsText();
        Home_address := SelectJsonToken(RequestJson, '$.Home_address').AsValue.AsText();
        Citizen := SelectJsonToken(RequestJson, '$.Citizen').AsValue.AsText();

        NOKObject := SelectArray(RequestJson, 'next_of_kin');
        kin_Fullname := SelectJsonToken(NOKObject, '$.full_name').AsValue.AsText();
        kin_Relationship := SelectJsonToken(NOKObject, '$.relationship').AsValue.AsText();
        Kin_Identifiertype := SelectJsonToken(NOKObject, '$.identifier_type').AsValue.AsText();
        Kin_identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText();
        kin_PhoneNumber := SelectJsonToken(RequestJson, '$.phone_number').AsValue.AsText();
        Kin_EmailAddress := SelectJsonToken(RequestJson, '$.email_name').AsValue.AsText();
        kin_Percentage := SelectJsonToken(RequestJson, '$.Percentage').AsValue.AsDecimal();
        kin_Beneficiary := SelectJsonToken(RequestJson, '$.beneficiary').AsValue.AsBoolean();




        If FullNames <> ' ' then begin

            MembershipApplication.Name := FullNames;
            MembershipApplication."Phone No." := Phone_Number;
            MembershipApplication."E-Mail (Personal)" := Email_address;
            MembershipApplication.Gender := Gender;
            MembershipApplication."Date of Birth" := Date_of_birth;
            MembershipApplication."ID No." := Id_number;
            MembershipApplication."Passport No." := Passport_number;
            MembershipApplication."Home Address" := Home_address;
            MembershipApplication."Country/Region Code" := Citizen;
            MembershipApplication.Insert();
            //Next of kin
            MemberNextofKin.Name := kin_Fullname;
            MemberNextofKin.Relationship := kin_Relationship;
            MemberNextofKin."ID No." := Kin_identifier;
            MemberNextofKin.Telephone := kin_PhoneNumber;
            MemberNextofKin.Email := Kin_EmailAddress;
            MemberNextofKin."%Allocation" := kin_Percentage;
            MemberNextofKin.Beneficiary := kin_Beneficiary;
            MemberNextofKin.Next();

            SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
        end





        else begin
            SetResponseStatus(ResponseJson, 'error', 'Error', 'An error occurred');
        end;
        ResponseJson.Add(Data, DataJson);


    end;

    local procedure GetDividendPayslipPeriods(RequestJson: JsonObject) ResponseJson: JsonObject
    var

        Member: Record Customer;
        IdentifierType: Text;
        Iterator: Integer;
        Identifier: Text;
        beginDate: Date;
        EndDate: Date;
        Period: Text;
        DateFormula: Text;
        DividendPeriodArray: JsonArray;
        DividendPeriodObject: JsonObject;
        Found: Boolean;
    begin
        DateFormula := '<CY>';
        Iterator := 0;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Member.Reset();
        Member.SetRange(Member."ID No.", UpperCase(Format(Identifier)));
        Member.SetFilter(Member."Dividend Processed Date", '<>', 0D);
        if Member.FindFirst() then begin
            SetResponseStatus(ResponseJson, 'success', 'Success', 'Sacco dividend payslip periods list has been fetched Succesufully');
            repeat
                beginDate := Member."Dividend Processed Date";
                EndDate := CalcDate(DateFormula, Member."Dividend Processed Date");
                Period := Format(beginDate) + ' ' + 'to' + ' ' + Format(EndDate);

                DividendPeriodObject.Add('Period', Period);
                Clear(DividendPeriodObject);
                Iterator := Iterator + 1;
                Found := true;
            until Member.Next() = 0;
            if Found = false then begin
                SetResponseStatus(ResponseJson, 'error', 'Error', 'An error occurred');
            end;

            ResponseJson.Add(Data, DividendPeriodArray);
        end;
    end;
    // ------------------------------------------------------------------------------------------------
    local procedure GetAccountsPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        AccountType: Text;
        IdentifierType: Text;
        Identifier: Text;
        AccountsArray: JsonArray;
        AccountObject: JsonObject;
        AccountNumber: Code[200];
        Iterator: Integer;
        AccountTypes: Record "Account Types-Saving Products";
        Found: boolean;
        FireLable: Label '+';
        Memb: record Customer;
        // MBuffer: Record "Mpesa Withdawal Buffer";

        AvailableBalance: Decimal;
        PendingAmount: Decimal;
    begin
        Iterator := 0;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Found := false;
        AccountNumber := '';

        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN BEGIN
            Memb.Reset();
            Memb.SetRange(Memb."ID No.", UpperCase(Format(Identifier)));
            if Memb.FindFirst() then begin

                memb.init;
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s accounts list has been fetched successfully');
                repeat

                    Memb.CalcFields(Memb."Current Shares", "Housing Deposits", "Alpha Savings", "Junior Savings One", "Likizo Contribution", "Share Capital");
                    AccountObject.Add('Account_Number', Memb."No.");
                    AccountObject.Add('Account_Name', Memb."Global Dimension 1 Code" + ' ' + 'Savings Account');
                    AccountObject.Add('Account_Type', Memb."Global Dimension 1 Code" + ' ' + 'Account');
                    AccountObject.Add('Account_Status', Memb.Status);
                    AccountObject.Add('Currency', 'KES');
                    AccountObject.Add('Deposits', Memb."Current Shares");
                    AccountObject.Add('Alpha_Savings', Memb."Alpha Savings");
                    AccountObject.Add('Juniour_Savings', Memb."Junior Savings One");
                    AccountObject.Add('Housing_Contribution', Memb."Housing Deposits");
                    AccountObject.Add('Holiday_Savings', Memb."Likizo Contribution");
                    AccountObject.Add('ShareCapital', Memb."Share Capital");
                    AccountObject.Add('actions', 'Deposits');
                    AccountsArray.Add(AccountObject);
                    Clear(AccountObject);
                    Iterator := Iterator + 1;
                    Found := true;

                until Memb.Next() = 0;
                DataJson.Add('accounts', AccountsArray);
            end;


        end;



        if Found = false then begin
            SetResponseStatus(ResponseJson, 'error', 'Error', 'An error occurred');
        end;

        ResponseJson.Add(Data, AccountsArray);
    end;




    local procedure GetAccountStatementPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DocumentNumber: Code[40];
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        page_size: integer;
        page_number: Integer;
        TotalFoundRecords: Integer;
        FirstRow: Integer;
        LastRow: Integer;
        Count: Integer;
        PageJson: JsonObject;
        RunningBalances: decimal;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        NetCharges: Decimal;
        AvailableBalance: decimal;
        PendingAmount: decimal;
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        AccountNumber := SelectJsonToken(RequestJson, '$.account_number').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;
        page_number := SelectJsonToken(RequestJson, '$.page').AsValue.AsInteger();
        page_size := SelectJsonToken(RequestJson, '$.page_count').AsValue.AsInteger();


        if IdentifierType = 'NATIONAL_ID_NUMBER' then begin

            Members.Reset();
            Members.SetRange(Members."ID No.", AccountNumber);
            if Members.FindFirst() then begin
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Account Statement has been fetched successfully');

                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("Customer No.", Members."No.");
                CustLedgerEntry.SetRange(Reversed, false);
                CustLedgerEntry.SetFilter(CustLedgerEntry."Posting Date", '%1..%2', StartDate, EndDate);
                if CustLedgerEntry.Findset then begin
                    CustLedgerEntry.CalcFields("Debit Amount", "Credit Amount");
                    TotalDebits := CustLedgerEntry."Debit Amount";
                    TotalCredits := CustLedgerEntry."Credit Amount";
                    Count := 0;
                    FirstRow := ((page_number - 1) * page_size) + 1;
                    LastRow := page_number * page_size;
                    TotalFoundRecords := CustLedgerEntry.Count;
                    repeat begin

                        Count := Count + 1;
                        if (Count >= FirstRow) and (Count <= LastRow) then begin
                            EntryType := '';
                            if CustLedgerEntry."Debit Amount" <> 0 then
                                EntryType := 'Debit'
                            else
                                EntryType := 'Credit';

                            CustLedgerEntry.CalcFields(CustLedgerEntry.Description, CustLedgerEntry."Amount Posted");
                            TransactionObject.Add('entry_number', CustLedgerEntry."Entry No.");
                            TransactionObject.Add('transaction_reference', CustLedgerEntry."Document No.");
                            TransactionObject.Add('posting_date', CustLedgerEntry."Posting Date");
                            TransactionObject.Add('description', CustLedgerEntry.Description);
                            TransactionObject.Add('amount', CustLedgerEntry."Amount Posted");
                            TransactionObject.Add('running_balance', RunBal);
                            TransactionObject.Add('entry_type', EntryType);
                            TransactionsArray.Add(TransactionObject);
                            Clear(TransactionObject);
                        end;
                        RunBal := RunBal + (CustLedgerEntry."Amount Posted");
                    end until CustLedgerEntry.Next() = 0;
                    PageJson.Add('records', TransactionsArray);
                    PageJson.Add('page', page_number);
                    PageJson.Add('page_count', page_size);
                    PageJson.Add('total_records', TotalFoundRecords);
                    PageJson.Add('credits', TotalCredits);
                    PageJson.Add('debits', TotalDebits);
                end;
            end else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
        end;

        ResponseJson.Add(Data, PageJson);


    end;


    local procedure GetLoanStatementPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        SavAccount: Record Vendor;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        DetLedger: record "Detailed Cust. Ledg. Entry";
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CredLedger: Record "Cust. Ledger Entry";
        CredLedgers: Record "Cust. Ledger Entry";
        DocumentNumber: Code[40];
        AccountTypeX: Record "Account Types-Saving Products";
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        // MemberStatement: Report 50004;
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        loanNumber: Text;
        page_size: integer;
        page_number: Integer;
        TotalFoundRecords: Integer;
        FirstRow: Integer;
        LastRow: Integer;
        Count: Integer;
        PageJson: JsonObject;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        loanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;
        page_number := SelectJsonToken(RequestJson, '$.page').AsValue.AsInteger();
        page_size := SelectJsonToken(RequestJson, '$.page_count').AsValue.AsInteger();



        if IdentifierType = 'NATIONAL_ID_NUMBER' then begin
            Members.Reset();
            Members.SetRange(Members."ID No.", Identifier);
            if Members.FindFirst() then
                LoansRegister.Reset();
            LoansRegister.SetRange(LoansRegister."Loan  No.", loanNumber);
            if LoansRegister.FindFirst() then begin
                LoansRegister.CalcFields(LoansRegister."Outstanding Balance");
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Loan Statement has been fetched successfully');
                RunBal := LoansRegister."Outstanding Balance";
                CredLedgers.Reset();
                CredLedgers.SetCurrentKey("Posting Date");
                CredLedgers.SetAscending("Posting Date", false);
                CredLedgers.SetRange(CredLedgers."Loan No", LoansRegister."Loan  No.");
                CredLedgers.SetFilter(CredLedgers."Transaction Type", '%1|%2', CredLedgers."Transaction Type"::Loan, CredLedgers."Transaction Type"::Repayment, CredLedgers."Transaction Type"::"Interest Due", CredLedgers."Transaction Type"::"Interest Paid");
                CredLedgers.SetFilter(CredLedgers."Posting Date", '%1..%2', StartDate, EndDate);

                if CredLedgers.FindSet() then begin
                    // CredLedgers.CalcSums("Debit Amount", "Credit Amount");
                    TotalDebits := CredLedgers."Debit Amount";
                    TotalCredits := CredLedgers."Credit Amount";

                end;


                DetLedger.Reset();
                DetLedger.SetFilter(DetLedger."Posting Date", '..%1', CalcDate('-1D', StartDate));
                DetLedger.SetFilter(DetLedger."Transaction Type", '%1|%2', DetLedger."Transaction Type"::Loan, DetLedger."Transaction Type"::Repayment, DetLedger."Transaction Type"::"Interest Due", DetLedger."Transaction Type"::"Interest Paid");
                //DetLedger.SetRange(DetLedger.Reversed, false);
                DetLedger.SetRange(DetLedger."Loan No", loanNumber);
                DetLedger.SetFilter(DetLedger."Entry Type", '<>%1', DetLedger."Entry Type"::Application);
                if DetLedger.FindSet() then begin
                    DetLedger.CalcSums(DetLedger.Amount);
                    OpenBal := DetLedger.Amount;
                end;
                RunBal := OpenBal;

                CredLedger.Reset();
                CredLedger.SetCurrentKey("Posting Date");
                CredLedger.SetAscending("Posting Date", false);
                CredLedger.SetRange(CredLedger.Reversed, false);
                CredLedger.SetRange(CredLedger."Loan No", LoansRegister."Loan  No.");
                CredLedger.SetFilter(CredLedger."Transaction Type", '%1|%2|%3|%4', CredLedger."Transaction Type"::Loan, CredLedger."Transaction Type"::Repayment, CredLedger."Transaction Type"::"Interest Due", CredLedger."Transaction Type"::"Interest Paid");
                CredLedger.SetFilter(CredLedger."Posting Date", '%1..%2', StartDate, EndDate);
                // CredLedger.SetFilter(CredLedger."Entry Type", '<>%1', CredLedger."Entry Type"::Application);
                if CredLedger.FindSet() then begin
                    Count := 0;
                    FirstRow := ((page_number - 1) * page_size) + 1;
                    LastRow := page_number * page_size;
                    TotalFoundRecords := CredLedger.Count;

                    repeat begin
                        Count := Count + 1;
                        if (Count >= FirstRow) and (Count <= LastRow) then begin
                            EntryType := '';
                            if CredLedger.Amount > 0 then
                                EntryType := 'Debit'
                            else
                                EntryType := 'Credit';
                            RunBal := RunBal + CredLedger.Amount;
                            TransactionObject.Add('entry_number', CredLedger."Entry No.");
                            TransactionObject.Add('transaction_reference', CredLedger."Document No.");
                            TransactionObject.Add('posting_date', CredLedger."Posting Date");
                            TransactionObject.Add('description', CredLedger.Description);
                            TransactionObject.Add('amount', CredLedger.Amount);
                            TransactionObject.Add('running_balance', RunBal);
                            TransactionObject.Add('entry_type', EntryType);
                            TransactionObject.Add('transaction_type', Format(CredLedger."Transaction Type"));
                            TransactionsArray.Add(TransactionObject);
                            Clear(TransactionObject);
                        end;
                    end until (Count = LastRow) or (CredLedger.Next() = 0);

                end;
                PageJson.Add('records', TransactionsArray);
                PageJson.Add('page', page_number);
                PageJson.Add('page_count', page_size);
                PageJson.Add('total_records', TotalFoundRecords);
                PageJson.Add('credits', TotalCredits);
                PageJson.Add('debits', TotalDebits);
                PageJson.Add('Balance_Brought_Forward', OpenBal);



            end else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
        end;
        ResponseJson.Add(Data, PageJson);
    end;

    local procedure GetLoanStatementReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        SavAccount: Record Vendor;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        SavLedger: record "Detailed Vendor Ledg. Entry";
        DetLedger: record "Detailed Vendor Ledg. Entry";
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        DocumentNumber: Code[40];
        AccountTypeX: Record "Account Types-Saving Products";
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        // MemberStatement: Report 50004;
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        Customer: Record Customer;
        loanNumber: Text;
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        loanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;
        if IdentifierType = 'MEMBER_NUMBER' THEN begin
            Customer.Reset();
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
            Customer.SetFilter(Customer."Date filter", '%1..%2', StartDate, EndDate);
            Customer.SetRange(Customer."Loan No. Filter", loanNumber);
            if Customer.FindFirst() then begin
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Loan Statement has been fetched successfully');
                varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);

                RecRef.GetTable(Customer);
                Report.SaveAs(Report::"Member Loans Statement", '', REPORTFORMAT::Pdf, OStream, RecRef);
                varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
                vConvertedContent := varBase64Conversion.ToBase64(IStream);
                DataJson.Add('pdf', vConvertedContent);
            end
            else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
        end;
        // end;
        ResponseJson.Add(Data, DataJson);
    end;


    local procedure GetLoanRepaymentScheduleReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        SavAccount: Record Vendor;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        SavLedger: record "Detailed Vendor Ledg. Entry";
        DetLedger: record "Detailed Vendor Ledg. Entry";
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        DocumentNumber: Code[40];
        AccountTypeX: Record "Account Types-Saving Products";
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        MemberStatement: Report "Member Account Statement";
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        loanNumber: Text;
        Schedule: Record "Loan Repayment Schedule";
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        loanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;

        if IdentifierType = 'NATIONAL_ID_NUMBER' then begin
            Members.Reset();
            Members.SetRange(Members."ID No.", Identifier);
            if Members.FindFirst() then begin
                LoansRegister.Reset();
                LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");
                LoansRegister.SetRange(LoansRegister."Loan  No.", loanNumber);
                if LoansRegister.FindFirst() then begin

                    SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Loan Repayment Schedule report has been exported successfully');
                    varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);

                    RecRef.GetTable(LoansRegister);
                    Report.SaveAs(Report::"Loans Repayment Schedule New", '', REPORTFORMAT::Pdf, OStream, RecRef);
                    varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
                    vConvertedContent := varBase64Conversion.ToBase64(IStream);
                    DataJson.Add('pdf', vConvertedContent);
                end else
                    SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
            end;
        end;
        ResponseJson.Add(Data, DataJson);
    end;

    local procedure GetAccountStatementReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        DocumentNumber: Code[40];
        AccountTypeX: Record "Account Types-Saving Products";
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        MemberStatement: Report "Member Detailed Statement";
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        page_size: integer;
        page_number: Integer;
        TotalFoundRecords: Integer;
        FirstRow: Integer;
        LastRow: Integer;
        Count: Integer;
        PageJson: JsonObject;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        FosaState: report "Member Detailed Statement";
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        AccountNumber := SelectJsonToken(RequestJson, '$.account_number').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;


        if IdentifierType = 'NATIONAL_ID_NUMBER' then begin
            Members.Reset();
            Members.SetRange(Members."ID No.", AccountNumber);
            Members.SetFilter(Members."Date Filter", '%1..%2', StartDate, EndDate);
            if Members.FindFirst() then begin
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Account Statement has been fetched successfully');
                varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);
                RecRef.GetTable(Members);



                Report.SaveAs(Report::"Member Detailed Statement", '', REPORTFORMAT::Pdf, OStream, RecRef);
                varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
                vConvertedContent := varBase64Conversion.ToBase64(IStream);
                DataJson.Add('pdf', vConvertedContent);


            end else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
        end;
        ResponseJson.Add(Data, DataJson);
    end;


    local procedure GetDividendPayslipReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountType: Text;
        AccountNumber: Text;
        NumberOfTransactions: Integer;
        StartDate: Date;
        EndDate: Date;
        SavAccount: Record Customer;
        StatementType: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        DividendProgression: record "Dividends Progression";
        OpenBal: Decimal;
        Found: Boolean;
        Loans: Record "Loans Register";
        CredLedger: Record "Detailed Cust. Ledg. Entry";
        DocumentNumber: Code[40];
        AccountTypeX: Record "Account Types-Saving Products";
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        // MemberStatement: Report 50004;
        StatementOutstream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        StatementInstream: InStream;
        RunBal: Decimal;
        SaccoGen: Record "Sacco General Set-Up";
        LoansRegister: Record "Loans Register";
        EntryType: Text[50];
        page_size: integer;
        page_number: Integer;
        TotalFoundRecords: Integer;
        FirstRow: Integer;
        LastRow: Integer;
        Count: Integer;
        PageJson: JsonObject;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        // FosaState: report FOSAStatementOne;
        Period: Code[40];
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Period := SelectJsonToken(RequestJson, '$.period').AsValue.AsText;



        if IdentifierType = 'NATIONAL_ID_NUMBER' then begin

            SavAccount.Reset();
            SavAccount.SetRange(SavAccount."ID No.", Identifier);
            if SavAccount.FindFirst() then begin
                // DividendProgression.SetRange(DividendProgression."Member No",SavAccount."No.");

                // SavAccount."Dividend Year" := Period;
                // SavAccount.Modify();
                SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Dividend Payment report has been exported successfully');
                varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);
                RecRef.GetTable(SavAccount);



                Report.SaveAs(Report::"Dividends Progressionslip", '', REPORTFORMAT::Pdf, OStream, RecRef);
                varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
                vConvertedContent := varBase64Conversion.ToBase64(IStream);
                DataJson.Add('pdf', vConvertedContent);


            end else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Account does not exist');
        end;

        ResponseJson.Add(Data, DataJson);
        //RandText := Mob.GetBalanceEnquiry(Identifier, DocumentNumber);




    end;

    // // ------------------------------------------------------------------------------------------------
    // local procedure GetLoanTypes(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypesArray: JsonArray;
    //     LoanTypesArray2: JsonArray;
    //     LoanTypeObject: JsonObject;
    //     LoanTypeObject2: JsonObject;
    //     Iterator: Integer;
    //     ProdFactory: Record "Loan Products Setup";
    //     ProdFactory2: Record "Loan Products Setup";
    //     Found: Boolean;
    //     SalDetails: record "Salary Details";
    //     Loans: Record "Loans Register";
    //     Members: Record Vendor;
    //     NetSalary: Decimal;
    //     Maxloan: Decimal;
    //     PayrollMonthlyTransactions: Record "prPeriod Transactions.";
    //     LoanDescription: Text[100];
    //     Cust: Record Customer;
    //     loanR: Record "Loans Register";
    //     PesaTele: Decimal;
    //     Msg: Text[250];
    // begin
    //     Found := false;
    //     Iterator := 0;

    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

    //     if IdentifierType = 'MSISDN' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."Mobile Phone No", Identifier);
    //         Members.SetFilter(Members."Account Type", '103');
    //         if Members.FindFirst() then begin
    //             Members.CalcFields(Members.Balance);

    //             ProdFactory.SetRange(ProdFactory."Is Mobile Loan?", true);
    //             ProdFactory.SetRange(ProdFactory."Mobile Application Source", true);
    //             if ProdFactory.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat
    //                     LoanDescription := '';
    //                     Maxloan := 0;
    //                     //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //                     Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, ProdFactory."Product Description", ProdFactory."Max. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_id', ProdFactory.Code);
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     LoanTypeObject.Add('loan_type_min_amount', ProdFactory."Min. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_description', LoanDescription);
    //                     LoanTypeObject.Add('loan_type_status', FnCheckMemberStatus(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_age', FnCheckMemberAge(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_shares', FnCheckMemberShares(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_default_status', FnCheckLoanDefault(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_max_amount', Maxloan);
    //                     LoanTypeObject.Add('loan_type_interest_rate', ProdFactory."Interest rate");
    //                     LoanTypeObject.Add('loan_type_min_instalments', 1);
    //                     LoanTypeObject.Add('loan_type_max_instalments', ProdFactory."Default Installements");
    //                     LoanTypeObject.Add('Installation_type', 'INPUT/NONE');
    //                     if ProdFactory."Min No. Of Guarantors" > 0 then begin
    //                         LoanTypeObject2.Add('required_guarantors', true);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);

    //                     end else begin
    //                         LoanTypeObject2.Add('required_guarantors', false);
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                     end;
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject2);
    //                     Clear(LoanTypeObject);
    //                 // end;
    //                 until ProdFactory.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //                 Found := true;
    //             end;
    //         end else
    //             DataJson.Add('loan_types', LoanTypesArray);
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');


    //     end;
    //     if IdentifierType = 'MEMBER_NUMBER' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."BOSA Account No", Identifier);
    //         Members.SetFilter(Members."Account Type", '103');
    //         if Members.Findlast() then begin
    //             Members.CalcFields(Members.Balance);

    //             ProdFactory.SetRange(ProdFactory."Is Mobile Loan?", true);
    //             ProdFactory.SetRange(ProdFactory."Mobile Application Source", true);

    //             if ProdFactory.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat
    //                     Maxloan := 0;
    //                     //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //                     if (ProdFactory.Code = 'A03') or (ProdFactory.Code = 'A16') then begin
    //                         Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, Msg, ProdFactory."Max. Loan Amount");
    //                     end;
    //                     if ProdFactory.Code = 'A01' then begin
    //                         Maxloan := GetSalaryLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'M_OD' then begin
    //                         Maxloan := GetOverdraftLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'A10' then begin
    //                         Maxloan := GetReloadedLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;


    //                     // Loans.Reset();
    //                     // Loans.SetRange(Loans."Client Code", Members."BOSA Account No");
    //                     // //Loans.SetAutoCalcFields(Loans."Outstanding Balance");
    //                     // Loans.SetRange(Loans."Loan Product Type", ProdFactory.Code);
    //                     // //Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
    //                     // if not Loans.FindFirst() then begin
    //                     LoanTypeObject.Add('loan_type_id', ProdFactory.Code);
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     LoanTypeObject.Add('loan_type_min_amount', ProdFactory."Min. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_status', FnCheckMemberStatus(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_age', FnCheckMemberAge(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_shares', FnCheckMemberShares(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_default_status', FnCheckLoanDefault(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_max_amount', Maxloan);
    //                     LoanTypeObject.Add('loan_type_description', FnCheckLoanIfExisting(Members."BOSA Account No", ProdFactory.Code));
    //                     LoanTypeObject.Add('loan_type_interest_rate', ProdFactory."Interest rate");
    //                     LoanTypeObject.Add('loan_type_min_instalments', 1);
    //                     LoanTypeObject.Add('loan_type_max_instalments', ProdFactory."Default Installements");
    //                     LoanTypeObject.Add('Installation_type', 'INPUT/NONE');
    //                     if ProdFactory."Min No. Of Guarantors" > 0 then begin
    //                         LoanTypeObject2.Add('required_guarantors', true);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);

    //                     end else begin
    //                         LoanTypeObject2.Add('required_guarantors', false);
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                     end;
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject2);
    //                     Clear(LoanTypeObject);
    //                 //end;
    //                 until ProdFactory.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //                 Found := true;
    //             end;
    //         end else
    //             SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');
    //     END;

    //     if Found = false then begin
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'No product exists');
    //     end;

    //     ResponseJson.Add(Data, DataJson);
    // end;


    local procedure GetLoanTypesPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        LoanTypesArray: JsonArray;
        LoanTypesArray2: JsonArray;
        LoanTypeObject: JsonObject;
        LoanTypeObject2: JsonObject;
        Iterator: Integer;
        ProdFactory: Record "Loan Products Setup";
        ProdFactory2: Record "Loan Products Setup";
        Found: Boolean;
        SalDetails: record "Loan Appraisal Salary Details";
        Loans: Record "Loans Register";
        Members: Record Customer;
        NetSalary: Decimal;
        Maxloan: Decimal;
        PayrollMonthlyTransactions: Record "prPeriod Transactions.";
        LoanDescription: Text[100];
        Cust: Record Customer;
        loanR: Record "Loans Register";
        PesaTele: Decimal;
        Msg: Text[250];
        Insider: Record "Sacco Insiders";
        NormalMember: Boolean;
        Director: Boolean;
        Staff: Boolean;
    begin
        Found := false;
        Iterator := 0;

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Staff := false;
        Director := false;
        NormalMember := false;
        if IdentifierType = 'MSISDN' THEN BEGIN
            Members.Reset();
            Members.SetRange(Members."Mobile Phone No", Identifier);
            if Members.FindFirst() then begin
                Members.CalcFields(Members.Balance);
                Insider.Reset();
                Insider.SetRange(Insider.MemberNo, Members."No.");
                if Insider.FindFirst() then begin
                    if Insider."Position in society" = Insider."Position in society"::Staff then begin
                        Staff := true;
                    end;
                    if Insider."Position in society" = Insider."Position in society"::Board then begin
                        Director := true;
                    end;
                end else begin
                    NormalMember := true;
                end;

                if NormalMember = true then begin
                    ProdFactory.Reset();
                    // ProdFactory.SetFilter(ProdFactory."Member Category", '%1', ProdFactory."Member Category"::"All Members");
                    // ProdFactory.SetRange(ProdFactory.InActive,false);
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'SACCO loan types list has been fetched successfully');
                        repeat
                            LoanDescription := '';
                            Maxloan := 0;

                            LoanTypeObject.Add('loan_code', ProdFactory.Code);
                            LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                            LoanTypeObject.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
                            LoanTypeObject.Add('source', Format(ProdFactory.Source));
                            LoanTypeObject.Add('maximum_amount', ProdFactory."Max. Loan Amount");
                            LoanTypeObject.Add('minimum_amount', ProdFactory."Min. Loan Amount");
                            LoanTypesArray.Add(LoanTypeObject);
                            Clear(LoanTypeObject);
                        until ProdFactory.Next() = 0;
                        Found := true;
                    end;
                end;

                if Director = true then begin
                    ProdFactory.Reset();
                    // ProdFactory.SetFilter(ProdFactory."Member Category", '%1|%2', ProdFactory."Member Category"::"All Members", ProdFactory."Member Category"::Board);
                    //  ProdFactory.SetRange(ProdFactory.InActive,false);
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'SACCO loan types list has been fetched successfully');
                        repeat
                            LoanDescription := '';
                            Maxloan := 0;

                            LoanTypeObject.Add('loan_code', ProdFactory.Code);
                            LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                            LoanTypeObject.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
                            LoanTypeObject.Add('source', Format(ProdFactory.Source));
                            LoanTypeObject.Add('maximum_amount', ProdFactory."Max. Loan Amount");
                            LoanTypeObject.Add('minimum_amount', ProdFactory."Min. Loan Amount");
                            LoanTypesArray.Add(LoanTypeObject);
                            Clear(LoanTypeObject);
                        until ProdFactory.Next() = 0;
                        Found := true;
                    end;
                end;

                if Staff = true then begin
                    ProdFactory.Reset();
                    // ProdFactory.SetFilter(ProdFactory."Member Category", '%1|%2', ProdFactory."Member Category"::"All Members", ProdFactory."Member Category"::Staff);
                    //  ProdFactory.SetRange(ProdFactory.InActive,false);
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'SACCO loan types list has been fetched successfully');
                        repeat
                            LoanDescription := '';
                            Maxloan := 0;

                            LoanTypeObject.Add('loan_code', ProdFactory.Code);
                            LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                            LoanTypeObject.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
                            LoanTypeObject.Add('source', Format(ProdFactory.Source));
                            LoanTypeObject.Add('maximum_amount', ProdFactory."Max. Loan Amount");
                            LoanTypeObject.Add('minimum_amount', ProdFactory."Min. Loan Amount");
                            LoanTypesArray.Add(LoanTypeObject);
                            Clear(LoanTypeObject);
                        until ProdFactory.Next() = 0;
                        Found := true;
                    end;
                end;


            end;


        end;


        ResponseJson.Add(Data, LoanTypesArray);
    end;

    // local procedure GetSpecificLoanTypesDetails(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypesArray: JsonArray;
    //     LoanTypesArray2: JsonArray;
    //     LoanTypeObject: JsonObject;
    //     LoanTypeObject2: JsonObject;
    //     Iterator: Integer;
    //     ProdFactory: Record "Loan Products Setup";
    //     ProdFactory2: Record "Loan Products Setup";
    //     Found: Boolean;
    //     SalDetails: record "Salary Details";
    //     Loans: Record "Loans Register";
    //     Members: Record Vendor;
    //     NetSalary: Decimal;
    //     Maxloan: Decimal;
    //     PayrollMonthlyTransactions: Record "prPeriod Transactions.";
    //     LoanDescription: Text[100];
    //     Cust: Record Customer;
    //     loanR: Record "Loans Register";
    //     PesaTele: Decimal;
    //     Msg: Text[250];
    //     LoanType: Text;
    // begin
    //     Found := false;
    //     Iterator := 0;

    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
    //     LoanType := SelectJsonToken(RequestJson, '$.loan_type').AsValue.AsText;


    //     if IdentifierType = 'MEMBER_NUMBER' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."BOSA Account No", Identifier);
    //         Members.SetFilter(Members."Account Type", '103');
    //         if Members.Findlast() then begin
    //             Members.CalcFields(Members.Balance);

    //             ProdFactory.SetRange(ProdFactory."Is Mobile Loan?", true);
    //             ProdFactory.SetRange(ProdFactory."Mobile Application Source", true);
    //             ProdFactory.SetRange(ProdFactory.Code, LoanType);

    //             if ProdFactory.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat
    //                     Maxloan := 0;
    //                     //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //                     if (ProdFactory.Code = 'A03') or (ProdFactory.Code = 'A16') then begin
    //                         Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, Msg, ProdFactory."Max. Loan Amount");
    //                     end;
    //                     if ProdFactory.Code = 'A01' then begin
    //                         Maxloan := GetSalaryLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'M_OD' then begin
    //                         Maxloan := GetOverdraftLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'A10' then begin
    //                         Maxloan := GetReloadedLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;


    //                     // Loans.Reset();
    //                     // Loans.SetRange(Loans."Client Code", Members."BOSA Account No");
    //                     // //Loans.SetAutoCalcFields(Loans."Outstanding Balance");
    //                     // Loans.SetRange(Loans."Loan Product Type", ProdFactory.Code);
    //                     // //Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
    //                     // if not Loans.FindFirst() then begin
    //                     LoanTypeObject.Add('loan_type_id', ProdFactory.Code);
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     LoanTypeObject.Add('loan_type_min_amount', ProdFactory."Min. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_status', FnCheckMemberStatus(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_age', FnCheckMemberAge(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_shares', FnCheckMemberShares(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_default_status', FnCheckLoanDefault(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_max_amount', Maxloan);
    //                     LoanTypeObject.Add('loan_type_description', FnCheckLoanIfExisting(Members."BOSA Account No", ProdFactory.Code));
    //                     LoanTypeObject.Add('loan_type_interest_rate', ProdFactory."Interest rate");
    //                     LoanTypeObject.Add('loan_type_min_instalments', 1);
    //                     LoanTypeObject.Add('loan_type_max_instalments', ProdFactory."Default Installements");
    //                     LoanTypeObject.Add('Installation_type', 'INPUT/NONE');
    //                     if ProdFactory."Min No. Of Guarantors" > 0 then begin
    //                         LoanTypeObject2.Add('required_guarantors', true);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);

    //                     end else begin
    //                         LoanTypeObject2.Add('required_guarantors', false);
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                     end;
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject2);
    //                     Clear(LoanTypeObject);
    //                 //end;
    //                 until ProdFactory.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //                 Found := true;
    //             end;
    //         end else
    //             SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');
    //     END;

    //     if Found = false then begin
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'No product exists');
    //     end;

    //     ResponseJson.Add(Data, DataJson);
    // end;


    // local procedure GetLoanLimit(MemberNo: Code[40]; LoanType: Code[60]) Salary: Decimal
    // var
    //     DataJson: JsonObject;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypesArray: JsonArray;
    //     LoanTypesArray2: JsonArray;
    //     LoanTypeObject: JsonObject;
    //     LoanTypeObject2: JsonObject;
    //     Iterator: Integer;
    //     ProdFactory: Record "Loan Products Setup";
    //     ProdFactory2: Record "Loan Products Setup";
    //     Found: Boolean;
    //     SalDetails: record "Salary Details";
    //     Loans: Record "Loans Register";
    //     Members: Record Vendor;
    //     NetSalary: Decimal;
    //     Maxloan: Decimal;
    //     PayrollMonthlyTransactions: Record "prPeriod Transactions.";
    //     LoanDescription: Text[100];
    //     Cust: Record Customer;
    //     loanR: Record "Loans Register";
    //     PesaTele: Decimal;
    //     Msg: Text[250];

    // begin


    //     Members.Reset();
    //     Members.SetRange(Members."BOSA Account No", MemberNo);
    //     Members.SetFilter(Members."Account Type", '103');
    //     if Members.Findlast() then begin
    //         Members.CalcFields(Members.Balance);
    //         ProdFactory.Reset();
    //         ProdFactory.SetRange(ProdFactory.Code, LoanType);
    //         if ProdFactory.FindFirst() then begin

    //             Maxloan := 0;
    //             //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //             if (ProdFactory.Code = 'A03') or (ProdFactory.Code = 'A16') then begin
    //                 Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, Msg, ProdFactory."Max. Loan Amount");
    //             end;
    //             if ProdFactory.Code = 'A01' then begin
    //                 Maxloan := GetSalaryLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //             end;
    //             if ProdFactory.Code = 'M_OD' then begin
    //                 Maxloan := GetOverdraftLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //             end;
    //             if ProdFactory.Code = 'A10' then begin
    //                 Maxloan := GetReloadedLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //             end;
    //             Salary := Maxloan;

    //         end;
    //     end;
    // END;

    // local procedure GetLoanTypesUSSD(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypesArray: JsonArray;
    //     LoanTypesArray2: JsonArray;
    //     LoanTypeObject: JsonObject;
    //     LoanTypeObject2: JsonObject;
    //     Iterator: Integer;
    //     ProdFactory: Record "Loan Products Setup";
    //     ProdFactory2: Record "Loan Products Setup";
    //     Found: Boolean;
    //     SalDetails: record "Salary Details";
    //     Loans: Record "Loans Register";
    //     Members: Record Vendor;
    //     NetSalary: Decimal;
    //     Maxloan: Decimal;
    //     PayrollMonthlyTransactions: Record "prPeriod Transactions.";
    //     LoanDescription: Text[100];
    //     Cust: Record Customer;
    //     loanR: Record "Loans Register";
    //     PesaTele: Decimal;
    //     Msg: Text[250];
    // begin
    //     Found := false;
    //     Iterator := 0;

    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

    //     if IdentifierType = 'MSISDN' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."Mobile Phone No", Identifier);
    //         Members.SetFilter(Members."Account Type", '103');
    //         if Members.FindFirst() then begin
    //             Members.CalcFields(Members.Balance);

    //             ProdFactory.SetRange(ProdFactory."Is Mobile Loan?", true);
    //             ProdFactory.SetRange(ProdFactory."Mobile Application Source", true);
    //             if ProdFactory.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat
    //                     LoanDescription := '';
    //                     Maxloan := 0;
    //                     //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //                     Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, ProdFactory."Product Description", ProdFactory."Max. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_id', ProdFactory.Code);
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     // LoanTypeObject.Add('loan_type_min_amount', ProdFactory."Min. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_description', LoanDescription);
    //                     LoanTypeObject.Add('loan_type_status', FnCheckMemberStatus(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_age', FnCheckMemberAge(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_shares', FnCheckMemberShares(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_default_status', FnCheckLoanDefault(Members."BOSA Account No"));
    //                     // LoanTypeObject.Add('loan_type_max_amount', Maxloan);
    //                     LoanTypeObject.Add('loan_type_interest_rate', ProdFactory."Interest rate");
    //                     LoanTypeObject.Add('loan_type_min_instalments', 1);
    //                     LoanTypeObject.Add('loan_type_max_instalments', ProdFactory."Default Installements");
    //                     LoanTypeObject.Add('Installation_type', 'INPUT/NONE');
    //                     if ProdFactory."Min No. Of Guarantors" > 0 then begin
    //                         LoanTypeObject2.Add('required_guarantors', true);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);

    //                     end else begin
    //                         LoanTypeObject2.Add('required_guarantors', false);
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                     end;
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject2);
    //                     Clear(LoanTypeObject);
    //                 // end;
    //                 until ProdFactory.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //                 Found := true;
    //             end;
    //         end else
    //             DataJson.Add('loan_types', LoanTypesArray);
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');


    //     end;
    //     if IdentifierType = 'MEMBER_NUMBER' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."BOSA Account No", Identifier);
    //         Members.SetFilter(Members."Account Type", '103');
    //         if Members.Findlast() then begin
    //             Members.CalcFields(Members.Balance);

    //             ProdFactory.SetRange(ProdFactory."Is Mobile Loan?", true);
    //             ProdFactory.SetRange(ProdFactory."Mobile Application Source", true);

    //             if ProdFactory.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat
    //                     Maxloan := 0;
    //                     //Maxloan := GetGrossSalary(Members."No.", ProdFactory.Code);
    //                     if (ProdFactory.Code = 'A03') or (ProdFactory.Code = 'A16') then begin
    //                         //Maxloan := FnGetMobileAdvanceEligibility(Members."No.", ProdFactory.Code, Msg, ProdFactory."Max. Loan Amount");
    //                     end;
    //                     if ProdFactory.Code = 'A01' then begin
    //                         // Maxloan := GetSalaryLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'M_OD' then begin
    //                         // Maxloan := GetOverdraftLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;
    //                     if ProdFactory.Code = 'A10' then begin
    //                         // Maxloan := GetReloadedLoanQualifiedAmount(Members."No.", ProdFactory.Code, ProdFactory."Max. Loan Amount", Msg)
    //                     end;


    //                     // Loans.Reset();
    //                     // Loans.SetRange(Loans."Client Code", Members."BOSA Account No");
    //                     // //Loans.SetAutoCalcFields(Loans."Outstanding Balance");
    //                     // Loans.SetRange(Loans."Loan Product Type", ProdFactory.Code);
    //                     // //Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
    //                     // if not Loans.FindFirst() then begin
    //                     LoanTypeObject.Add('loan_type_id', ProdFactory.Code);
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     //LoanTypeObject.Add('loan_type_min_amount', ProdFactory."Min. Loan Amount");
    //                     LoanTypeObject.Add('loan_type_status', FnCheckMemberStatus(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_age', FnCheckMemberAge(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_shares', FnCheckMemberShares(Members."BOSA Account No"));
    //                     LoanTypeObject.Add('loan_type_default_status', FnCheckLoanDefault(Members."BOSA Account No"));
    //                     //LoanTypeObject.Add('loan_type_max_amount', Maxloan);
    //                     LoanTypeObject.Add('loan_type_description', FnCheckLoanIfExisting(Members."BOSA Account No", ProdFactory.Code));
    //                     LoanTypeObject.Add('loan_type_interest_rate', ProdFactory."Interest rate");
    //                     LoanTypeObject.Add('loan_type_min_instalments', 1);
    //                     LoanTypeObject.Add('loan_type_max_instalments', ProdFactory."Default Installements");
    //                     LoanTypeObject.Add('Installation_type', 'INPUT/NONE');
    //                     if ProdFactory."Min No. Of Guarantors" > 0 then begin
    //                         LoanTypeObject2.Add('required_guarantors', true);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);

    //                     end else begin
    //                         LoanTypeObject2.Add('required_guarantors', false);
    //                         LoanTypeObject.Add('guarantors', LoanTypeObject2);
    //                         LoanTypeObject2.Add('minimum_guarantors', ProdFactory."Min No. Of Guarantors");
    //                         LoanTypeObject2.Add('maximum_guarantors', ProdFactory."Max No. Of Guarantor");
    //                     end;
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject2);
    //                     Clear(LoanTypeObject);
    //                 //end;
    //                 until ProdFactory.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //                 Found := true;
    //             end;
    //         end else
    //             SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');
    //     END;

    //     if Found = false then begin
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'No product exists');
    //     end;

    //     ResponseJson.Add(Data, DataJson);
    // end;


    local procedure GetLoanCalculatorParameters(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        LoanTypesArray: JsonArray;
        LoanTypesArray2: JsonArray;
        LoanTypeObject: JsonObject;
        LoanTypeObject2: JsonObject;
        Iterator: Integer;
        ProdFactory: Record "Loan Products Setup";
        ProdFactory2: Record "Loan Products Setup";
        Found: Boolean;
        SalDetails: record "Loan Appraisal Salary Details";
        Loans: Record "Loans Register";
        Members: Record Customer;
        NetSalary: Decimal;
        Maxloan: Decimal;
        PayrollMonthlyTransactions: Record "prPeriod Transactions.";
        LoanDescription: Text[100];
        Cust: Record Customer;
        loanR: Record "Loans Register";
        PesaTele: Decimal;
        Msg: Text[250];
        loan_Code: text;
        Insider: Record "Sacco Insiders";
        NormalMember: Boolean;
        Director: Boolean;
        Staff: Boolean;

    Begin
        Found := false;
        Iterator := 0;

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        loan_Code := SelectJsonToken(RequestJson, '$.loan_code').AsValue.AsText;
        Staff := false;
        Director := false;
        NormalMember := false;
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN BEGIN
            Members.Reset();
            Members.SetRange(Members."ID No.", Identifier);
            if Members.FindFirst() then begin
                Insider.Reset();
                Insider.SetRange(Insider.MemberNo, Members."No.");
                if Insider.FindFirst() then begin
                    if Insider."Position in society" = Insider."Position in society"::Staff then begin
                        Staff := true;
                    end;
                    if Insider."Position in society" = Insider."Position in society"::Board then begin
                        Director := true;
                    end;
                end else begin
                    NormalMember := true;
                end;

                if NormalMember = true then begin

                    ProdFactory.Reset();
                    ProdFactory.SetRange(ProdFactory.Code, loan_Code);
                    //ProdFactory.SetFilter(ProdFactory."Member Category", '%1', ProdFactory."Member Category"::"All Members");
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'Loan calculator parameters have been fetched successfully');

                        LoanDescription := '';
                        Maxloan := 0;
                        LoanTypeObject.Add('loan_code', ProdFactory.Code);
                        LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                        LoanTypeObject.Add('repayment_frequency', Format(ProdFactory."Repayment Frequency"));
                        LoanTypeObject.Add('maximum_loan_amount', ProdFactory."Max. Loan Amount");
                        LoanTypeObject.Add('manimum_loan_amount', ProdFactory."Min. Loan Amount");
                        LoanTypeObject.Add('interest_rate', ProdFactory."Interest rate");
                        LoanTypeObject.Add('maximum_installments', ProdFactory."Default Installements");
                        LoanTypeObject.Add('minimum_number_of_guarantors', ProdFactory."Min No. Of Guarantors");
                        LoanTypeObject.Add('maximum_number_of_guarantors', ProdFactory."Max No. Of Guarantors");
                        LoanTypeObject.Add('recovery_mode', Format(ProdFactory."Recovery Mode"));
                        LoanTypeObject.Add('source', Format(ProdFactory.Source));
                        LoanTypeObject.Add('interest_calculation_method', ProdFactory."Repayment Method");
                        Found := true;
                    end;
                end;

                if Director = true then begin

                    ProdFactory.Reset();
                    ProdFactory.SetRange(ProdFactory.Code, loan_Code);
                    //ProdFactory.SetFilter(ProdFactory."Member Category", '%1|%2', ProdFactory."Member Category"::"All Members", ProdFactory."Member Category"::Board);
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'Loan calculator parameters have been fetched successfully');

                        LoanDescription := '';
                        Maxloan := 0;
                        LoanTypeObject.Add('loan_code', ProdFactory.Code);
                        LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                        LoanTypeObject.Add('repayment_frequency', Format(ProdFactory."Repayment Frequency"));
                        LoanTypeObject.Add('maximum_loan_amount', ProdFactory."Max. Loan Amount");
                        LoanTypeObject.Add('interest_rate', ProdFactory."Interest rate");
                        LoanTypeObject.Add('maximum_installments', ProdFactory."Default Installements");
                        LoanTypeObject.Add('minimum_number_of_guarantors', ProdFactory."Min No. Of Guarantors");
                        LoanTypeObject.Add('maximum_number_of_guarantors', ProdFactory."Max No. Of Guarantors");
                        LoanTypeObject.Add('recovery_mode', Format(ProdFactory."Recovery Mode"));
                        LoanTypeObject.Add('source', Format(ProdFactory.Source));
                        LoanTypeObject.Add('interest_calculation_method', ProdFactory."Repayment Method");
                        Found := true;
                    end;
                end;



                if Staff = true then begin

                    ProdFactory.Reset();
                    ProdFactory.SetRange(ProdFactory.Code, loan_Code);
                    // ProdFactory.SetFilter(ProdFactory."Member Category", '%1|%2', ProdFactory."Member Category"::"All Members", ProdFactory."Member Category"::Staff);
                    if ProdFactory.FindFirst() then begin
                        SetResponseStatus(ResponseJson, 'success', 'Success', 'Loan calculator parameters have been fetched successfully');

                        LoanDescription := '';
                        Maxloan := 0;
                        LoanTypeObject.Add('loan_code', ProdFactory.Code);
                        LoanTypeObject.Add('product_name', Format(ProdFactory."Product Description"));
                        LoanTypeObject.Add('repayment_frequency', Format(ProdFactory."Repayment Frequency"));
                        LoanTypeObject.Add('maximum_loan_amount', ProdFactory."Max. Loan Amount");
                        LoanTypeObject.Add('interest_rate', ProdFactory."Interest rate");
                        LoanTypeObject.Add('maximum_installments', ProdFactory."Default Installements");
                        LoanTypeObject.Add('minimum_number_of_guarantors', ProdFactory."Min No. Of Guarantors");
                        LoanTypeObject.Add('maximum_number_of_guarantors', ProdFactory."Max No. Of Guarantors");
                        LoanTypeObject.Add('recovery_mode', Format(ProdFactory."Recovery Mode"));
                        LoanTypeObject.Add('source', Format(ProdFactory.Source));
                        LoanTypeObject.Add('interest_calculation_method', ProdFactory."Repayment Method");
                        Found := true;
                    end;
                end;

            end else
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');


        end;

        if Found = false then begin
            SetResponseStatus(ResponseJson, 'error', 'Error', 'No product exists');
        end;

        ResponseJson.Add(Data, LoanTypeObject);
    end;

    // local procedure CheckLoanStatus(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     DataArray: JsonArray;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypesArray: JsonArray;
    //     LoanTypesArray2: JsonArray;
    //     LoanTypeObject: JsonObject;
    //     LoanTypeObject2: JsonObject;
    //     Iterator: Integer;
    //     ProdFactory: Record "Loan Products Setup";
    //     ProdFactory2: Record "Loan Products Setup";
    //     Found: Boolean;
    //     SalDetails: record "Salary Details";
    //     Loans: Record "Loans Register";
    //     Members: Record Vendor;
    //     NetSalary: Decimal;
    //     Maxloan: Decimal;
    //     PayrollMonthlyTransactions: Record "prPeriod Transactions.";

    // begin
    //     Found := false;
    //     Iterator := 0;

    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

    //     if IdentifierType = 'MSISDN' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."Mobile Phone No", Identifier);
    //         // Members.SetFilter(Members."Account Type", '103');
    //         if Members.FindFirst() then begin
    //             Members.CalcFields(Members.Balance);
    //             Loans.Reset();
    //             Loans.SetRange(Loans."Client Code", Members."BOSA Account No");
    //             Loans.SetRange(Loans."Approval Status", Loans."Approval Status"::Pending);
    //             if Loans.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat

    //                     ProdFactory.Get(Loans."Loan Product Type");
    //                     LoanTypeObject.Add('loan_type_id', Loans."Loan Product Type");
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     LoanTypeObject.Add('loan_status', Format(Loans."Loan Status"));
    //                     LoanTypeObject.Add('loan_amount', Loans."Requested Amount");
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject);

    //                     Found := true;
    //                 until Loans.Next() = 0;

    //             end;
    //             DataJson.Add('loan_types', LoanTypesArray);
    //         end else
    //             SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');
    //         // ResponseJson.Add('loan_types', DataJson);

    //     end;
    //     if IdentifierType = 'MEMBER_NUMBER' THEN BEGIN
    //         Members.Reset();
    //         Members.SetRange(Members."BOSA Account No", Identifier);
    //         //Members.SetFilter(Members."Account Type", '103');
    //         if Members.FindFirst() then begin
    //             Members.CalcFields(Members.Balance);
    //             Loans.Reset();
    //             Loans.SetRange(Loans."Client Code", Members."BOSA Account No");
    //             Loans.SetRange(Loans."Approval Status", Loans."Approval Status"::Pending);
    //             if Loans.FindFirst() then begin
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //                 repeat

    //                     ProdFactory.Get(Loans."Loan Product Type");
    //                     LoanTypeObject.Add('loan_type_id', Loans."Loan Product Type");
    //                     LoanTypeObject.Add('loan_type_name', Format(ProdFactory."Product Description"));
    //                     LoanTypeObject.Add('loan_status', Format(Loans."Loan Status"));
    //                     LoanTypeObject.Add('loan_amount', Loans."Requested Amount");
    //                     LoanTypesArray.Add(LoanTypeObject);
    //                     Clear(LoanTypeObject);

    //                     Found := true;
    //                 until Loans.Next() = 0;
    //                 DataJson.Add('loan_types', LoanTypesArray);
    //             end;
    //         end;// else
    //             // SetResponseStatus(ResponseJson, 'error', 'Error', 'Member number does not exists.');

    //     END;

    //     if Found = false then begin
    //         //SetResponseStatus(ResponseJson, 'error', 'Error', 'No product exists');
    //         ResponseJson.Add('loan_types', LoanTypesArray);

    //     end;
    //     if Found = true then begin
    //         ResponseJson.Add(Data, DataJson);
    //     end;
    // end;


    // // ------------------------------------------------------------------------------------------------
    // local procedure CheckLoanLimit(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     OriginatorID: Text;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoanTypeID: Text;
    //     LoansRegister: Record "Loans Register";
    //     LoanType: Record "Loan Products Setup";
    //     Customer: Record Customer;
    // begin
    //     OriginatorID := SelectJsonToken(RequestJson, '$.originator_id').AsValue.AsText;
    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
    //     LoanTypeID := SelectJsonToken(RequestJson, '$.loan_type_id').AsValue.AsText;

    //     if IdentifierType = 'MEMBER_NUMBER' then begin
    //         SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //         Customer.Reset();
    //         Customer.SetRange("No.", Identifier);
    //         if Customer.Find('-') then begin
    //             Customer.CalcFields("Current Shares");
    //             if LoanType.Get(LoanTypeID) then begin

    //                 DataJson.Add('loan_type_id', LoanType.Code);
    //                 DataJson.Add('loan_name', LoanType."Product Description");
    //                 DataJson.Add('eligible_amount', GetLoanLimit(Customer."No.", LoanTypeID));//GetGrossSalary(Customer."FOSA Account No.", LoanTypeID));
    //                 DataJson.Add('loan_type_status', FnCheckMemberStatus(Customer."No."));
    //                 DataJson.Add('loan_type_age', FnCheckMemberAge(Customer."No."));
    //                 DataJson.Add('loan_type_shares', FnCheckMemberShares(Customer."No."));
    //                 DataJson.Add('loan_type_default_status', FnCheckLoanDefault(Customer."No."));
    //             end;

    //         end;
    //     end;
    //     if IdentifierType = 'MSISDN' then begin
    //         Customer.Reset();
    //         Customer.SetRange(Customer."Mobile Phone No", Identifier);
    //         if Customer.Find('-') then begin
    //             Customer.CalcFields("Current Shares");
    //             if LoanType.Get(LoanTypeID) then begin
    //                 DataJson.Add('loan_type_id', LoanType.Code);
    //                 DataJson.Add('loan_name', LoanType."Product Description");
    //                 DataJson.Add('eligible_amount', GetLoanLimit(Customer."No.", LoanTypeID));
    //                 DataJson.Add('loan_type_status', FnCheckMemberStatus(Customer."No."));
    //                 DataJson.Add('loan_type_age', FnCheckMemberAge(Customer."No."));
    //                 DataJson.Add('loan_type_shares', FnCheckMemberShares(Customer."No."));
    //                 DataJson.Add('loan_type_default_status', FnCheckLoanDefault(Customer."No."));
    //             end;


    //         end;

    //     end;
    //     ResponseJson.Add(Data, DataJson);
    // end;

    // // ------------------------------------------------------------------------------------------------


    // local procedure DiscardLoanApplication(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     OriginatorID: Text;
    //     IdentifierType: Text;
    //     Installments: Integer;
    //     Identifier: Text;
    //     LoanID: Code[40];
    //     Amount: Decimal;
    //     SourceReference: Text;
    //     RequestApplication: Text;
    //     TransactionDateTime: Text;
    //     LoansRegister: Record "Loans Register";
    //     LoanProductSetup: Record "Loan Products Setup";
    //     LoanRec: Record "Loans Register";
    //     Members: Record Customer;
    //     NoSeries: Codeunit NoSeriesManagement;
    //     Found: Boolean;
    //     ProductFound: Boolean;
    //     GenJournalLine: Record "Gen. Journal Line";
    //     Guarantors: record "Loans Guarantee Details";
    // begin
    //     // OriginatorID := SelectJsonToken(RequestJson, '$.originator_id').AsValue.AsText;
    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
    //     LoanID := SelectJsonToken(RequestJson, '$.loan_id').AsValue.AsText;




    //     Found := false;
    //     if IdentifierType = 'MEMBER_NUMBER' then begin
    //         Members.Reset();
    //         Members.SetRange(Members."No.", Identifier);
    //         if Members.FindFirst() then begin

    //             LoanRec.Reset();
    //             LoanRec.SetRange(LoanRec."Client Code", Members."No.");
    //             LoanRec.SetRange(LoanRec."Loan  No.", UpperCase(LoanID));
    //             if LoanRec.FindFirst() then begin
    //                 // Error('here%1',LoanID);
    //                 SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');

    //                 LoanRec."Archive Loan" := true;
    //                 LoanRec.Modify();
    //                 Found := true;
    //             end;
    //         end;
    //     end;
    //     if Found = false then begin
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'Loan not  found.');
    //     end;

    //     //if Found = true then begin
    //     //  ResponseJson.Add(Data, DataJson);
    //     //   end;

    // end;


    // // ------------------------------------------------------------------------------------------------    
    // local procedure GetOutstandingLoans(RequestJson: JsonObject) ResponseJson: JsonObject
    // var
    //     DataJson: JsonObject;
    //     IdentifierType: Text;
    //     Identifier: Text;
    //     LoansArray: JsonArray;
    //     LoanObject: JsonObject;
    //     Iterator: Integer;
    //     Loans: Record "Loans Register";
    //     Members: Record Customer;
    //     ProdFactory: Record "Loan Products Setup";


    // begin
    //     Iterator := 0;

    //     IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
    //     Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
    //     if Members.get(Identifier) then begin
    //         SetResponseStatus(ResponseJson, 'success', 'Success', 'Request processed successfully');
    //         Loans.Reset();
    //         Loans.SetRange(Loans."Client Code", Members."No.");
    //         Loans.SetAutoCalcFields(Loans."Outstanding Balance");
    //         Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
    //         if Loans.FindSet() then begin

    //             repeat
    //                 Loans.CalcFields(Loans."Outstanding Balance", Loans."Outstanding Interest");
    //                 LoanObject.Add('loan_serial_number', Loans."Loan  No.");
    //                 LoanObject.Add('loan_type_id', Loans."Loan Product Type");
    //                 if Loans."Loan Product Type Name" = '' then begin
    //                     ProdFactory.Reset();
    //                     ProdFactory.SetRange(ProdFactory.Code, Loans."Loan Product Type");
    //                     if ProdFactory.FindFirst() then begin
    //                         LoanObject.Add('loan_type_name', ProdFactory."Product Description");
    //                     end
    //                 end else begin
    //                     LoanObject.Add('loan_type_name', Loans."Loan Product Type Name");
    //                 end;
    //                 LoanObject.Add('loan_amount', Loans."Approved Amount");
    //                 LoanObject.Add('loan_balance', Loans."Outstanding Balance" + Loans."Outstanding Interest");
    //                 LoanObject.Add('installment_amount', Loans.Repayment);
    //                 LoanObject.Add('loan_defaulted_amount', Loans."Amount in Arrears");
    //                 LoanObject.Add('loan_issued_date', Loans."Loan Disbursement Date");
    //                 LoanObject.Add('loan_end_date', Loans."Expected Date of Completion");
    //                 LoanObject.Add('loan_performance', Format(Loans."Loans Category-SASRA"));
    //                 LoanObject.Add('loan_performance_description', StrSubstNo('Loan is %1', UpperCase(Format(Loans."Loans Category-SASRA"))));

    //                 LoansArray.Add(LoanObject);
    //                 Clear(LoanObject);
    //                 Iterator := Iterator + 1;
    //             until Loans.Next() = 0;
    //         end;

    //         DataJson.Add('loans', LoansArray);

    //     end else
    //         SetResponseStatus(ResponseJson, 'error', 'Error', 'Member does not exist');

    //     ResponseJson.Add(Data, DataJson);
    // end;

    local procedure GetLoansPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        LoansArray: JsonArray;
        LoanObject: JsonObject;
        Iterator: Integer;
        Loans: Record "Loans Register";
        Members: Record Customer;
        ProdFactory: Record "Loan Products Setup";
        LoanNumber: Text;
        Schedule: Record "Loan Repayment Schedule";
        NextDate: Date;

    begin

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Members.Reset();
        Members.SetRange(Members."ID No.", Identifier);
        if Members.FindFirst() then begin
            SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s loans list has been fetched successfully');
            Loans.Reset();
            Loans.SetRange(Loans."Client Code", Members."No.");
            Loans.SetAutoCalcFields(Loans."Outstanding Balance");
            Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
            if Loans.FindSet() then begin
                repeat
                    Schedule.Reset();
                    Schedule.SetRange(Schedule."Loan No.", Loans."Loan  No.");
                    Schedule.SetFilter(Schedule."Repayment Date", '>%1', Today);
                    if Schedule.FindFirst() then begin
                        NextDate := Schedule."Repayment Date";
                    end;

                    ProdFactory.Get(Loans."Loan Product Type");
                    Loans.CalcFields(Loans."Outstanding Balance", Loans."Oustanding Interest");
                    LoanObject.Add('loan_number', Loans."Loan  No.");
                    LoanObject.Add('loan_type', ProdFactory."Product Description");
                    LoanObject.Add('loan_source', ProdFactory.Source);
                    LoanObject.Add('application_date', Loans."Application Date");
                    LoanObject.Add('posting_date', Loans."Posting Date");
                    LoanObject.Add('outstanding_balance', Loans."Outstanding Balance" + Loans."Oustanding Interest");
                    LoanObject.Add('loan_principal', Loans."Approved Amount");
                    LoanObject.Add('outstanding_interest', Loans."Oustanding Interest");
                    LoanObject.Add('installments', Loans.Installments);
                    LoanObject.Add('loan_status', Format(Loans."Loan Status"));
                    LoanObject.Add('repayment_amount', Loans.Repayment);
                    LoanObject.Add('loan_category', Format(Loans."Loans Category-SASRA"));
                    LoanObject.Add('currency', 'KES');
                    LoanObject.Add('next_repayment_date', NextDate);
                    LoanObject.Add('loan_disbursement_date', Loans."Loan Disbursement Date");
                    LoanObject.Add('expected_date_of_completion', Loans."Expected Date of Completion");
                    LoansArray.Add(LoanObject);
                    Clear(LoanObject);
                until Loans.Next() = 0;
            end;

            //DataJson.Add('loans', LoansArray);

        end else
            SetResponseStatus(ResponseJson, 'error', 'Error', 'Member does not exist');

        ResponseJson.Add(Data, LoansArray);
    end;

    local procedure GetLoanDetailsPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        LoansArray: JsonArray;
        LoanObject: JsonObject;
        Iterator: Integer;
        Loans: Record "Loans Register";
        Members: Record Customer;
        ProdFactory: Record "Loan Products Setup";
        LoanNumber: Text;
        Schedule: Record "Loan Repayment Schedule";
        NextDate: Date;

    begin

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        LoanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;
        Members.Reset();
        Members.SetRange(Members."ID No.", Identifier);
        if Members.FindFirst() then begin
            SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s loan details have been fetched successfully');
            Loans.Reset();
            Loans.SetRange(Loans."Client Code", Members."No.");
            Loans.SetRange(Loans."Loan  No.", LoanNumber);
            Loans.SetAutoCalcFields(Loans."Outstanding Balance");
            Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
            if Loans.FindSet() then begin
                Schedule.Reset();
                Schedule.SetRange(Schedule."Loan No.", Loans."Loan  No.");
                Schedule.SetFilter(Schedule."Repayment Date", '>%1', Today);
                if Schedule.FindFirst() then begin
                    NextDate := Schedule."Repayment Date";
                end;

                ProdFactory.Get(Loans."Loan Product Type");
                Loans.CalcFields(Loans."Outstanding Balance", Loans."Oustanding Interest");
                LoanObject.Add('loan_number', Loans."Loan  No.");
                LoanObject.Add('loan_type', ProdFactory."Product Description");
                LoanObject.Add('loan_source', ProdFactory.Source);
                LoanObject.Add('application_date', Loans."Application Date");
                LoanObject.Add('posting_date', Loans."Posting Date");
                LoanObject.Add('outstanding_balance', Loans."Outstanding Balance" + Loans."Oustanding Interest");
                LoanObject.Add('loan_principal', Loans."Approved Amount");
                LoanObject.Add('outstanding_interest', Loans."Oustanding Interest");
                LoanObject.Add('installments', Loans.Installments);
                LoanObject.Add('loan_status', Format(Loans."Loan Status"));
                LoanObject.Add('repayment_amount', Loans.Repayment);
                LoanObject.Add('loan_category', Format(Loans."Loans Category-SASRA"));
                LoanObject.Add('currency', 'KES');
                LoanObject.Add('next_repayment_date', NextDate);
                LoanObject.Add('expected_date_of_completion', Loans."Expected Date of Completion");
                LoansArray.Add(LoanObject);
                // Clear(LoanObject);
            end;

            // DataJson.Add('loans', LoansArray);

        end else
            SetResponseStatus(ResponseJson, 'error', 'Error', 'Member does not exist');

        ResponseJson.Add(Data, LoanObject);
    end;

    local procedure GetNextOfKin(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        NextKinJson: JsonObject;
        LoansArray: JsonArray;
        LoanObject: JsonObject;
        Iterator: Integer;
        Loans: Record "Loans Register";
        Members: Record Customer;
        ProdFactory: Record "Loan Products Setup";
        NetKin: Record "Members Next Kin Details";
        NextKin: JsonArray;


    begin
        Iterator := 0;

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Members.Reset();
        Members.SetRange(Members."ID No.", Identifier);
        if Members.FindFirst() then begin
            SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s Next of Kin list has been fetched successfully');
            NetKin.Reset();
            NetKin.SetRange(NetKin."Account No", Members."No.");
            if NetKin.FindSet() then begin

                repeat
                    NextKinJson.Add('name', NetKin.Name);
                    NextKinJson.Add('relationship', NetKin.Relationship);
                    NextKinJson.Add('allocation', NetKin."%Allocation");
                    NextKinJson.Add('status', 'status');
                    NextKinJson.Add('address', NetKin.Address);
                    NextKinJson.Add('phone_number', NetKin.Telephone);
                    NextKinJson.Add('id_number', NetKin."ID No.");
                    NextKinJson.Add('email_address', NetKin.Email);
                    NextKin.Add(NextKinJson);
                    Clear(NextKinJson);
                    Iterator := Iterator + 1;
                until NetKin.Next() = 0;

            end;

        end else
            SetResponseStatus(ResponseJson, 'error', 'Error', 'Member does not exist');

        ResponseJson.Add(Data, NextKin);
    end;

    // // ################################################################################################
    local procedure WrapResponse(RequestJson: JsonObject; ResponseJson: JsonObject) Wrapped: Text;
    var
        ResponseInnerJson: JsonObject;
        WrappedJson: JsonObject;
        PayloadJson: JsonObject;

        RequestAction: Text;
        RequestId: Text;
        ResponseStatus: Text;
        ResponsePayload: Text;
        ResponseHash: Text;
        RequestSessionId: Text;
        RequesteUser: Text;
    begin
        RequestId := SelectJsonToken(RequestJson, '$.id').AsValue.AsText;
        RequestAction := SelectJsonToken(RequestJson, '$.action').AsValue.AsText;

        RequestSessionId := SelectJsonToken(RequestJson, '$.session_id').AsValue.AsText;
        RequesteUser := SelectJsonToken(RequestJson, '$.user').AsValue.AsText;

        ResponseStatus := SelectJsonToken(ResponseJson, '$.' + Status).AsValue.AsText;

        ResponseJson.Remove(Status);

        PayloadJson.WriteTo(ResponsePayload);
        ResponseHash := Sha256Hash(ResponsePayload);

        ResponseInnerJson.Add('id', RequestId);
        ResponseInnerJson.Add('action', RequestAction);
        ResponseInnerJson.Add('status', ResponseStatus);
        ResponseInnerJson.Add('hash', ResponseHash);
        ResponseInnerJson.Add('session_id', RequestSessionId);
        ResponseInnerJson.Add('user', RequesteUser);
        ResponseInnerJson.Add('timestamp', CurrentDateTime);
        ResponseInnerJson.Add('payload', ResponseJson);

        WrappedJson.Add('response', ResponseInnerJson);
        WrappedJson.WriteTo(Wrapped);
    end;

    // // SUPPORTING PROCEDURES
    // // ------------------------------------------------------------------------------------------------

    local procedure SetResponseStatus(var ResponseJson: JsonObject; TheStatus: Text; TheTitle: Text; TheMessage: Text)
    begin
        ResponseJson.Add(Status, TheStatus);
        // ResponseJson.Add('Title', TheTitle);
        ResponseJson.Add(Message, TheMessage);
    end;

    local procedure ValidateUserSession(RequestJson: JsonObject) Response: Boolean
    var
        UserName: Text;
        SessionId: Text;
        Employee: Record Employee;
    begin
        UserName := SelectJsonToken(RequestJson, '$.user').AsValue.AsText;
        SessionId := SelectJsonToken(RequestJson, '$.session_id').AsValue.AsText;
        Response := true;
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    local procedure SelectArray(JsonObject: JsonObject; Path: text): JsonObject
    var
        JsonToken: JsonToken;
        JsArray: JsonArray;
    begin
        JsonObject.Get(Path, JsonToken);
        JsArray := (JsonToken.AsArray());
        Clear(JsonToken);
        JsArray.Get(1, JsonToken);
        exit(JsonToken.AsObject());
    end;

    local procedure ValidateRequestHash(RequestJson: JsonObject)
    var
        PayLoadJson: JsonObject;
        PayLoad: Text;
        HashFromPayload: Text;
        HashedPayload: Text;
    begin
        exit;
        HashFromPayload := SelectJsonToken(RequestJson, '$.request.hash').AsValue.AsText;
        PayLoadJson := SelectJsonToken(RequestJson, '$.request.payload').AsObject;
        PayLoadJson.WriteTo(PayLoad);
        HashedPayload := Sha256Hash(PayLoad);

        if HashedPayload <> HashFromPayload then
            Error('Payload hash mismatch');
    end;

    local procedure Sha256Hash(ClearText: Text): Text
    var
        CryptographyManagement: codeunit "Cryptography Management";
        HashAlgorithmType: option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        exit(Text.LowerCase(CryptographyManagement.GenerateHash(ClearText, HashAlgorithmType::SHA256)));
    end;



    local procedure GetLoansGuaranteedPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        Guarantors: JsonObject;
        GuarantorsArray: JsonArray;
        IdentifierType: Text;
        Identifier: Text;
        Customer: Record Customer;
        Loans: Record "Loans Register";
        Found: Boolean;
        LoanId: Integer;
        LoanG: Record "Loans Guarantee Details";
        TransactionInitiatorIdentifierType: Text;
        TransactionInitiatorIdentifier: Text;
        TransactionInitiatorAccount: Text;
        TransactionInitiatorName: Text;
        TransactionInitiatorAmount: Decimal;
        TransactionSourceIdentifierType: Text;
        TransactionSourceIdentifier: Text;
        TransactionSourceAccount: Text;
        TransactionSourceName: Text;
        TransactionSourceAmount: Decimal;
        loansG: record "Loans Guarantee Details";
        Members: Record Customer;
        Lproduct: Record "Loan Products Setup";
        SaccoGen: Record "Sacco General Set-Up";
        GuaranteedAmount: Decimal;
        Vendor: Record Vendor;
        Deposits: Decimal;
        FreeShares: Decimal;
    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        GuaranteedAmount := 0;
        Found := false;
        LoanId := 1;
        SaccoGen.Get();
        if IdentifierType = 'MSISDN' then begin
            Customer.Reset();
            Customer.SetRange(Customer."Mobile Phone No", Identifier);
            IF Customer.FindFirst() then BEGIN
                loansG.Reset();
                LoanG.SetRange(LoanG."Member No", Customer."No.");
                //LoanG.SetFilter(LoanG."Acceptance Status", '%1', loansG."Acceptance Status"::Accepted);
                LoanG.SetAutoCalcFields(LoanG."Loans Outstanding");
                LoanG.SetFilter(LoanG."Loans Outstanding", '>%1', 0);
                if LoanG.FindSet() then begin
                    LoanG.CalcSums(LoanG."Amont Guaranteed");
                    GuaranteedAmount := LoanG."Amont Guaranteed";
                end;

                Deposits := 0;
                FreeShares := 0;
                Vendor.Reset();
                Vendor.SetRange(Vendor."BOSA Account No", Customer."No.");
                Vendor.SetRange(Vendor."Account Type", '102');
                Vendor.SetAutoCalcFields(Vendor.Balance);
                IF Vendor.findfirst then begin
                    Deposits := Vendor.Balance * SaccoGen."Guarantors Multiplier";
                end;

                FreeShares := Deposits - GuaranteedAmount;
                // Error('GuaranteedAmount%1Deposits%2Setup%3Balance%4', GuaranteedAmount, Deposits,SaccoGen."Guarantors Multiplier",Vendor.Balance);
                loansG.Reset();
                LoanG.SetRange(LoanG."Member No", Customer."No.");
                //LoanG.SetFilter(LoanG."Acceptance Status", '%1', loansG."Acceptance Status"::Accepted);
                LoanG.SetAutoCalcFields(LoanG."Loans Outstanding");
                LoanG.SetFilter(LoanG."Loans Outstanding", '>%1', 0);
                if LoanG.FindFirst() then begin
                    repeat
                        Loans.Reset();
                        Loans.SetRange(Loans."Loan  No.", LoanG."Loan No");
                        Loans.SetAutoCalcFields(loans."Outstanding Balance");
                        Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);

                        if Loans.FindFirst() then begin
                            Members.Get(Loans."Client Code");
                            Guarantors.Add('member_number', Loans."Client Code");
                            Guarantors.Add('name', Loans."Client Name");
                            Guarantors.Add('phone_number', Members."Mobile Phone No");
                            Guarantors.Add('loan_number', LoanG."Loan No");
                            Lproduct.Get(Loans."Loan Product Type");
                            Guarantors.Add('loan_type', Lproduct."Product Description");
                            Guarantors.Add('amount_guaranteed', LoanG."Amont Guaranteed");
                            Guarantors.Add('loan_category', UpperCase(Format(Loans."Loans Category-SASRA")));
                            Guarantors.Add('loan_balance', Loans."Outstanding Balance");
                            Guarantors.Add('free_shares', FreeShares);
                            Guarantors.Add('application_date', Loans."Application Date");
                            Guarantors.Add('expected_completion_date', Loans."Expected Date of Completion");
                            GuarantorsArray.Add(Guarantors);
                            Clear(Guarantors);
                        end;
                    until LoanG.Next() = 0;
                    //  DataJson.Add('loan_guarantors', GuarantorsArray);
                    SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s loans guaranteed list has been fetched successfully');
                end else begin
                    SetResponseStatus(ResponseJson, 'error', 'Error', 'You have not guaranteed any loans');
                end;
            END ELSE
                SetResponseStatus(ResponseJson, 'error', 'Error', 'Member not found');
        end else begin
            SetResponseStatus(ResponseJson, 'error', 'Error', 'Wrong Identifier Type');
        end;

        ResponseJson.Add(Data, GuarantorsArray);
    end;



    local procedure GetLoanGuarantorsPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        LoanJson: JsonObject;
        LoanObject: JsonObject;
        Guarantors: JsonObject;
        GuarantorsArray: JsonArray;
        GuarantorObject: JsonObject;
        LoanArray: JsonArray;
        Soft: JsonArray;
        IdentifierType: Text;
        Identifier: Text;
        Customer: Record Customer;
        Loans: Record "Loans Register";
        LoanX: Record "Loans Register";
        LoansRec: Record "Loans Register";
        Found: Boolean;
        LoanId: Integer;
        LoanG: Record "Loans Guarantee Details";
        LoansWithGuarantors: Record "Loans Guarantee Details";
        TransactionInitiatorIdentifierType: Text;
        TransactionInitiatorIdentifier: Text;
        TransactionInitiatorAccount: Text;
        TransactionInitiatorName: Text;
        TransactionInitiatorAmount: Decimal;
        TransactionSourceIdentifierType: Text;
        TransactionSourceIdentifier: Text;
        TransactionSourceAccount: Text;
        TransactionSourceName: Text;
        TransactionSourceAmount: Decimal;
        loansG: record "Loans Guarantee Details";
        Members: Record Customer;
        LoanTypes: Record "Loan Products Setup";
        DataArray: JsonArray;
        GuarantorArray: JsonArray;
        LoanNumber: Text[200];


    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        //LoanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;
        Found := false;
        LoanId := 1;

        if IdentifierType = 'MSISDN' then begin
            Customer.Reset();
            Customer.SetRange(Customer."Mobile Phone No", Identifier);
            if Customer.Find('-') then begin
                loanX.Reset();
                LoanX.SetRange(LoanX."Client Code", Customer."No.");
                if LoanX.FindFirst() then begin
                    SetResponseStatus(ResponseJson, 'success', 'Success', 'Member’s loans guarantors list has been fetched successfully');
                    LoanX.CalcFields(LoanX."Outstanding Balance");
                    repeat
                        loanG.Reset();
                        LoanG.SetRange(LoanG."Loan No", LoanX."Loan  No.");
                        if LoanG.FindFirst() then begin
                            repeat
                                Members.Reset();
                                Members.SetRange(Members."No.", LoanG."Member No");
                                if Members.FindFirst() then begin
                                    Guarantors.Add('member_number', Members."No.");
                                    Guarantors.Add('guarantor_name', Members.Name);
                                    Guarantors.Add('phone_number', Members."Mobile Phone No");
                                    Guarantors.Add('amount_guaranteed', LoanG."Amont Guaranteed");
                                    Guarantors.Add('status', UpperCase(Format(LoanG."Acceptance Status")));
                                    Guarantors.Add('loan_balance', LoanX."Outstanding Balance");
                                    LoanArray.Add(Guarantors);
                                    Clear(Guarantors);
                                end;
                            until LoanG.Next() = 0;

                        end;
                    //DataJson.Add('guarantors', LoanArray);
                    //Clear(LoanArray);
                    //DataArray.Add(DataJson);
                    //Clear(DataJson);
                    until LoanX.Next() = 0;

                end else
                    SetResponseStatus(ResponseJson, 'error', 'Error', 'No Loan found');
            end;

        end;

        ResponseJson.Add(Data, LoanArray);
    end;

    local procedure UpdatePortalTracker(membernumber: code[20]; type: Text[100]; description: Text[500]): Text
    var
        Tracker: Record "Portal Tracker";
    begin
        Tracker.Init();
        if type = 'BALANCE' then
            Tracker."Interaction Type" := Tracker."Interaction Type"::"Balance Check";
        if type = 'LOGIN' then
            Tracker."Interaction Type" := Tracker."Interaction Type"::Login;
        if type = 'STATEMENt' then
            Tracker."Interaction Type" := Tracker."Interaction Type"::"Statement Retrieval";
        Tracker.Description := description;
        tracker.MemberNumber := membernumber;
        Tracker.Insert(true);
    end;

    procedure RetriveReport(args: text): Text
    var
        ljson: JsonObject;
        larray: JsonArray;
        tracker: Record "Portal Tracker";
    begin
        Clear(ljson);
        Clear(larray);
        tracker.Reset();

        if (args <> '') then//Member Number Filter
            tracker.SetRange(MemberNumber, args);
        if ((args <> '') and (args <> '')) then//Dates Filter
            tracker.SetFilter(Date, (args + '..' + args));
        if (args <> '') then begin//Interaction Type
            if args = '' then//Checking Balance
                tracker.SetRange("Interaction Type", tracker."Interaction Type"::"Balance Check");
            if args = '' then//Statement Retrieval
                tracker.SetRange("Interaction Type", tracker."Interaction Type"::"Statement Retrieval");
        end;

        if tracker.FindSet() then begin
            repeat
                Clear(ljson);
                ljson.add('', tracker.MemberNumber);
                ljson.add('', tracker.MemberName);
                ljson.add('', tracker.Description);
                ljson.add('', tracker.Date);
                ljson.add('', tracker.Time);
                larray.Add(ljson);
            until tracker.Next() = 0;
        end;
        exit(Format(larray));
    end;



    var

        LineNo: Integer;
        BATCH_TEMPLATE: Code[60];
        BATCH_NAME: Code[80];

        DOCUMENT_NO: Code[40];


}
