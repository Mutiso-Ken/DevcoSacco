codeunit 50163 "Portal Entry"
{
    trigger OnRun()
    begin

    end;

    var
        Customer: Record Customer;
        Tracker: Record "Portal Tracker";
        LoanProductsTable: Record "Loan Products Setup";
    // WitnessesTable: Record LoanWitnesses;

    procedure MemberDetails(idnumber: code[1000]): Text
    var
        dataobj: JsonObject;
        dataarr: JsonArray;
    begin
        Customer.Reset();
        Customer.SetRange("ID No.", idnumber);
        if Customer.FindFirst() then begin
            Clear(dataobj);
            dataobj.add('idnumber', idnumber);
            dataobj.add('fullname', Customer.Name);
            dataobj.add('membernumber', Customer."No.");
            dataobj.add('email', Customer."E-Mail");
            dataobj.add('phonenumber', Customer."Phone No.");
        end;
        exit(Format(dataobj));
    end;

    procedure RetrieveInformation(args: Text): Text
    var
        requestjson: JsonObject;
        requesttype: Text;
        jsontoken: JsonToken;
    begin
        if not requestjson.ReadFrom(args) then
            Error('Invalid JSON input');

        requestjson.Get('request_type', jsontoken);
        requesttype := jsontoken.AsValue().AsText();

        // if requesttype = 'loan_page_details' then
        if (requesttype = 'loan_page_details') then begin
            if requestjson.Get('employee_id', jsontoken) and not JsonToken.AsValue().IsNull then
                exit(LoanAppPageDetails(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'loan_product_details') then begin
            if RequestJson.Get('loan_product_code', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetLoanProductDetails(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'loans_details') then begin
            if requestjson.Get('employee_id', jsontoken) and not JsonToken.AsValue().IsNull then
                exit(GetLoanApplicationLoans(JsonToken.AsValue().AsCode()));
            // if RequestJson.Get('loan_product_code', JsonToken) and not JsonToken.AsValue().IsNull then
            //     SelectJsonToken() exit(GetLoanApplicationLoans(JsonToken.AsValue().AsCode()))
        end;
        if (RequestType = 'get_sub_sectors') then begin
            if RequestJson.Get('loan_product_code', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetSubSectors(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'get_specific_sectors') then begin
            if RequestJson.Get('loan_product_code', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetSpecificSectors(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'loan_repayment_schedule') then begin
            if RequestJson.Get('loan_information', JsonToken) and JsonToken.IsObject() then
                exit(CalculateLoanSchedule(JsonToken.AsObject()));
        end;
        if (RequestType = 'loan_applications_details') then begin
            if RequestJson.Get('employee_id', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetLoanApplications(JsonToken.AsValue().AsText()));
        end;
        if (RequestType = 'loan_application_specific_details') then begin
            if RequestJson.Get('loan_number', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetLoanApplicationDetails(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'search_members') then begin
            if RequestJson.Get('member_number', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetSearchMembers(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'guarantor_request_details') then begin
            if RequestJson.Get('guarantorship_request', JsonToken) and JsonToken.IsObject() then
                exit(GetGuarantorshipRequestDetails(JsonToken.AsObject()));
        end;
        if (RequestType = 'guarantorship_requests') then begin
            if RequestJson.Get('employee_id', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetGuarantorshipRequests(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'witness_request_details') then begin
            if RequestJson.Get('witness_request', JsonToken) and JsonToken.IsObject() then
                exit(GetWitnessRequestDetails(JsonToken.AsObject()));
        end;
        if (RequestType = 'witness_requests') then begin
            if RequestJson.Get('employee_id', JsonToken) and not JsonToken.AsValue().IsNull then
                exit(GetWitnessRequests(JsonToken.AsValue().AsCode()));
        end;
        if (RequestType = 'get_board_metrics_dashboard') then begin
            if RequestJson.Get('dashboard_metrics', JsonToken) and JsonToken.IsObject() then
                exit(GetPortalDashboardData(JsonToken.AsObject()));
        end;
        // if(requesttype)
    end;

    local procedure GetGuarantorshipRequests(memberNumber: Code[50]): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        array: JsonArray;
        GuarantorshipTable: Record "Guarantorship Tracking";

    begin
        Clear(outputjson);
        Clear(array);
        GuarantorshipTable.Reset();
        GuarantorshipTable.SetRange("Guarantor Number", memberNumber);
        if GuarantorshipTable.FindSet() then
            repeat
                Clear(object);
                object.Add('loan_number', GuarantorshipTable."Loan Number");
                object.Add('applicant_name', GuarantorshipTable."Member Name");
                object.Add('applicant_number', GuarantorshipTable."Member Number");
                object.Add('status', Format(GuarantorshipTable.Status));
                object.Add('request_date', GuarantorshipTable."Requested Date");
                object.Add('loan_amount', GuarantorshipTable."Loan Amount");
                object.Add('requested_amount', GuarantorshipTable."Requested Amount");
                object.Add('approved_amount', GuarantorshipTable."Approved Amount");
                array.Add(object);
            until GuarantorshipTable.Next() = 0;
        outputjson.Add('guarantorship_requests', array);
        exit(Format(AddResponseHead(outputjson, true)));
    end;

    local procedure GetWitnessRequests(memberNumber: Code[50]): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        array: JsonArray;
        WitnessTable: Record "Loan Witness Table";
    begin
        Clear(outputjson);
        Clear(array);
        WitnessTable.Reset();
        WitnessTable.SetRange("Witness Number", memberNumber);
        if WitnessTable.FindSet() then
            repeat
                Clear(object);
                object.Add('loan_number', WitnessTable."Loan Number");
                object.Add('applicant_name', WitnessTable."Member Name");
                object.Add('applicant_number', WitnessTable."Member Number");
                object.Add('status', Format(WitnessTable.Status));
                object.Add('request_date', WitnessTable."Requested Date");
                object.Add('loan_amount', WitnessTable."Loan Amount");
                array.Add(object);
            until WitnessTable.Next() = 0;
        outputjson.Add('witness_requests', array);
        exit(Format(AddResponseHead(outputjson, true)));
    end;


    local procedure GetGuarantorshipRequestDetails(requestJson: JsonObject): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        JsonToken: JsonToken;

        LoansTable: Record "Loans Register";
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        Clear(outputjson);
        GuarantorshipTable.Reset();
        requestJson.Get('loan_number', JsonToken);
        GuarantorshipTable.SetRange("Loan Number", JsonToken.AsValue().AsCode());
        requestJson.Get('guarantor_number', JsonToken);
        GuarantorshipTable.SetRange("Guarantor Number", JsonToken.AsValue().AsCode());
        if GuarantorshipTable.Find('-') then begin
            Clear(object);
            object.Add('loan_number', GuarantorshipTable."Loan Number");
            object.Add('applicant_name', GuarantorshipTable."Member Name");
            object.Add('applicant_number', GuarantorshipTable."Member Number");
            object.Add('guarantor_name', GuarantorshipTable."Guarantor Name");
            object.Add('guarantor_number', GuarantorshipTable."Guarantor Number");
            object.Add('status', Format(GuarantorshipTable.Status));
            object.Add('request_date', GuarantorshipTable."Requested Date");
            object.Add('loan_amount', GuarantorshipTable."Loan Amount");
            object.Add('requested_amount', GuarantorshipTable."Requested Amount");
            object.Add('approved_amount', GuarantorshipTable."Approved Amount");
            object.Add('approval_decline_date', GuarantorshipTable."Approval/Rejection Date");
        end;
        outputjson.Add('guarantorship_request', object);

        Clear(object);
        if LoansTable.Get(GuarantorshipTable."Loan Number") then begin
            object.Add('loan_number', LoansTable."Loan  No.");
            object.Add('product_name', LoansTable."Loan Product Type Name");
            object.Add('sasra_category', Format(LoansTable."Loans Category-SASRA"));
            object.Add('loan_status', Format(LoansTable."Loan Status"));
            object.Add('approved_amount', LoansTable."Approved Amount");
            object.Add('outstanding_balance', LoansTable."Outstanding Balance");
            object.Add('application_date', LoansTable."Application Date");
            object.Add('loan_repayments', LoansTable."Schedule Repayments");
            object.Add('expected_maturity_date', LoansTable."Expected Date of Completion");
            object.Add('interest_rate', LoansTable.Interest);
            object.Add('requested_amount', LoansTable."Requested Amount");
            object.Add('installments', LoansTable.Installments);
            object.Add('member_number', LoansTable."Client Name");
            object.Add('member_deposits', LoansTable."Member Deposits");
        end;
        outputjson.Add('loan_details', object);

        exit(Format(AddResponseHead(outputjson, true)));
    end;

    local procedure GetWitnessRequestDetails(requestJson: JsonObject): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        JsonToken: JsonToken;

        LoansTable: Record "Loans Register";
        WitnessTable: Record "Loan Witness Table";
    begin
        Clear(outputjson);
        WitnessTable.Reset();
        requestJson.Get('loan_number', JsonToken);
        WitnessTable.SetRange("Loan Number", JsonToken.AsValue().AsCode());
        requestJson.Get('guarantor_number', JsonToken);
        WitnessTable.SetRange("Witness Number", JsonToken.AsValue().AsCode());
        if WitnessTable.Find('-') then begin
            Clear(object);
            object.Add('loan_number', WitnessTable."Loan Number");
            object.Add('applicant_name', WitnessTable."Member Name");
            object.Add('applicant_number', WitnessTable."Member Number");
            object.Add('guarantor_name', WitnessTable."Witness Name");
            object.Add('guarantor_number', WitnessTable."Witness Number");
            object.Add('status', Format(WitnessTable.Status));
            object.Add('request_date', WitnessTable."Requested Date");
            object.Add('loan_amount', WitnessTable."Loan Amount");
            object.Add('approval_decline_date', WitnessTable."Approval/Rejection Date");
        end;
        outputjson.Add('witness_request', object);

        Clear(object);
        if LoansTable.Get(WitnessTable."Loan Number") then begin
            object.Add('loan_number', LoansTable."Loan  No.");
            object.Add('product_name', LoansTable."Loan Product Type Name");
            object.Add('sasra_category', Format(LoansTable."Loans Category-SASRA"));
            object.Add('loan_status', Format(LoansTable."Loan Status"));
            object.Add('approved_amount', LoansTable."Approved Amount");
            object.Add('outstanding_balance', LoansTable."Outstanding Balance");
            object.Add('application_date', LoansTable."Application Date");
            object.Add('loan_repayments', LoansTable."Schedule Repayments");
            object.Add('expected_maturity_date', LoansTable."Expected Date of Completion");
            object.Add('interest_rate', LoansTable.Interest);
            object.Add('requested_amount', LoansTable."Requested Amount");
            object.Add('installments', LoansTable.Installments);
            object.Add('member_number', LoansTable."Client Name");
            object.Add('member_deposits', LoansTable."Member Deposits");
        end;
        outputjson.Add('loan_details', object);

        exit(Format(AddResponseHead(outputjson, true)));
    end;

    local procedure GetSearchMembers(memberNumber: Code[50]): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        array: JsonArray;

    begin
        Clear(outputjson);
        Clear(array);

        Customer.Reset();

        Customer.SetRange("ID No.", memberNumber);
        if Customer.FindSet() then
            repeat
                Clear(object);
                object.Add('MemberNumber', Customer."No.");
                object.Add('FullName', Customer.Name);
                object.Add('Email', Customer."E-Mail");
                object.Add('Phone', Customer."Mobile Phone No");
                array.Add(object);
            until Customer.Next() = 0;

        outputjson.Add('Members', array);
        exit(Format(AddResponseHead(outputjson, true)));
    end;

    // local procedure GetMemberFullName(): Text
    // begin
    //     if Customer.name = '' then
    //         exit(CustomerTable."Name")
    //     else if Customer."Middle Name" = '' then
    //         exit(CustomerTable."First Name" + ' ' + CustomerTable."Last Name")
    //     else
    //         exit(CustomerTable."First Name" + ' ' + CustomerTable."Middle Name" + ' ' + CustomerTable."Last Name");
    // end;

    local procedure GetLoanApplicationDetails(loannumber: Code[20]): Text
    var
        OutputJson: JsonObject;
        object: JsonObject;
        subarray: JsonArray;
        subobject: JsonObject;
        LoansTable: Record "Loans Register";
        GuarantorshipTable: Record "Guarantorship Tracking";
        WitnessTable: Record "Loan Witness Table";
    begin
        Clear(OutputJson);
        if (loannumber <> '') then begin
            LoansTable.Reset();
            LoansTable.SetRange("Loan  No.", loannumber);
            if LoansTable.Find('-') then begin
                Clear(object);
                LoansTable.CalcFields("Outstanding Balance", "Schedule Repayments");
                object.Add('loan_number', LoansTable."Loan  No.");
                object.Add('product_name', LoansTable."Loan Product Type Name");
                object.Add('sasra_category', Format(LoansTable."Loans Category-SASRA"));
                object.Add('loan_status', Format(LoansTable."Loan Status"));
                object.Add('approved_amount', LoansTable."Approved Amount");
                object.Add('outstanding_balance', LoansTable."Outstanding Balance");
                object.Add('application_date', LoansTable."Application Date");
                object.Add('loan_repayments', LoansTable."Schedule Repayments");
                object.Add('expected_maturity_date', LoansTable."Expected Date of Completion");
                object.Add('interest_rate', LoansTable.Interest);
                object.Add('requested_amount', LoansTable."Requested Amount");
                object.Add('installments', LoansTable.Installments);
                object.Add('member_number', LoansTable."Client Code");
                object.Add('member_deposits', LoansTable."Member Deposits");

                GuarantorshipTable.Reset();
                GuarantorshipTable.SetRange("Loan Number", loannumber);
                if GuarantorshipTable.FindSet() then
                    repeat
                        Clear(subobject);
                        subobject.Add('guarantor_name', GuarantorshipTable."Guarantor Name");
                        subobject.Add('guarantor_number', GuarantorshipTable."Guarantor Number");
                        subobject.Add('applicant_number', GuarantorshipTable."Member Number");
                        subobject.Add('status', Format(GuarantorshipTable.Status));
                        subobject.Add('request_date', GuarantorshipTable."Requested Date");
                        subobject.Add('loan_amount', GuarantorshipTable."Loan Amount");
                        subobject.Add('requested_amount', GuarantorshipTable."Requested Amount");
                        subobject.Add('approved_amount', GuarantorshipTable."Approved Amount");
                        subarray.Add(subobject);
                    until GuarantorshipTable.Next() = 0;
                object.Add('guarantors', subarray);

                Clear(subobject);
                WitnessTable.Reset();
                WitnessTable.SetRange("Loan Number", loannumber);
                if WitnessTable.FindFirst() then begin
                    subobject.Add('guarantor_name', WitnessTable."Witness Name");
                    subobject.Add('guarantor_number', WitnessTable."Witness Number");
                    subobject.Add('applicant_number', WitnessTable."Member Number");
                    subobject.Add('status', Format(WitnessTable.Status));
                    subobject.Add('request_date', WitnessTable."Requested Date");
                    subobject.Add('loan_amount', WitnessTable."Loan Amount");
                    object.Add('witness', subobject);
                end;
                OutputJson.Add('loan_details', object);

                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;



    local procedure GetLoanApplications(employeeid: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;
        object: JsonObject;
        array: JsonArray;
        LoansTable: Record "Loans Register";
    begin
        if (employeeid <> '') then begin
            Customer.Reset();
            Customer.SetRange("No.", employeeid);
            if Customer.Find('-') then begin
                Clear(OutputJson);
                Clear(array);
                LoansTable.Reset();
                LoansTable.SetRange("Client Code", Customer."No.");
                LoansTable.SetRange(Posted, false);
                if LoansTable.FindSet() then
                    repeat
                        LoansTable.CalcFields("Outstanding Balance");
                        Clear(object);
                        object.Add('loan_number', LoansTable."Loan  No.");
                        object.Add('product_name', LoansTable."Loan Product Type Name");
                        object.Add('sasra_category', Format(LoansTable."Loans Category-SASRA"));
                        object.Add('loan_status', Format(LoansTable."Loan Status"));
                        object.Add('requested_amount', LoansTable."Requested Amount");
                        object.Add('approved_amount', LoansTable."Approved Amount");
                        object.Add('application_date', LoansTable."Application Date");
                        array.Add(object);
                    until LoansTable.Next() = 0;
                OutputJson.Add('member_loans', array);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetLoanApplicationLoans(employeeid: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;
        object: JsonObject;
        array: JsonArray;
        LoansTable: Record "Loans Register";
    begin
        if (employeeid <> '') then begin
            Customer.Reset();
            Customer.SetRange("No.", employeeid);
            if Customer.Find('-') then begin
                Clear(OutputJson);
                Clear(array);
                LoansTable.Reset();
                LoansTable.SetRange("Client Code", Customer."No.");
                LoansTable.SetAutoCalcFields(LoansTable."Outstanding Balance");
                LoansTable.SetFilter(LoansTable."Outstanding Balance", '>%1', 0);
                if LoansTable.FindSet() then
                    repeat
                        Clear(object);
                        object.Add('loan_number', LoansTable."Loan  No.");
                        object.Add('product_name', LoansTable."Loan Product Type Name");
                        object.Add('sasra_category', Format(LoansTable."Loans Category-SASRA"));
                        object.Add('loan_status', Format(LoansTable."Loan Status"));
                        object.Add('requested_amount', LoansTable."Requested Amount");
                        object.Add('approved_amount', LoansTable."Approved Amount");
                        object.Add('application_date', LoansTable."Application Date");
                        object.Add('outstanding_balance', LoansTable."Outstanding Balance");
                        array.Add(object);
                    until LoansTable.Next() = 0;
                OutputJson.Add('member_loans', array);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;


    local procedure CalculateLoanSchedule(LoanInformation: JsonObject): Text
    var
        MonthlyInterestRate: Decimal;
        InstallmentAmount: Decimal;
        TotalInterest: Decimal;
        TotalRepayment: Decimal;
        Balance: Decimal;
        Interest: Decimal;
        Principal: Decimal;
        ScheduleArray: JsonArray;
        ScheduleObject: JsonObject;
        object: JsonObject;
        i: Integer;
        outputjson: JsonObject;

        InterestRate: Decimal;
        jsontoken: JsonToken;
        LoanAmount: Decimal;
        RepaymentPeriod: Integer;
        LoanCode: Code[20];
    begin
        Clear(outputjson);

        if LoanInformation.Get('loan_code', jsontoken) and not jsontoken.AsValue().IsNull then
            LoanCode := jsontoken.AsValue().AsCode();
        if LoanInformation.Get('loan_amount', jsontoken) and not jsontoken.AsValue().IsNull then
            LoanAmount := jsontoken.AsValue().AsDecimal();
        if LoanInformation.Get('repayment_period', jsontoken) and not jsontoken.AsValue().IsNull then
            RepaymentPeriod := jsontoken.AsValue().AsInteger();

        if LoanProductsTable.Get(LoanCode) then begin
            InterestRate := LoanProductsTable."Interest rate";

            MonthlyInterestRate := InterestRate / 100 / 12;

            if MonthlyInterestRate > 0 then
                InstallmentAmount := LoanAmount * (MonthlyInterestRate * Power(1 + MonthlyInterestRate, RepaymentPeriod)) /
                                    (Power(1 + MonthlyInterestRate, RepaymentPeriod) - 1)
            else
                InstallmentAmount := LoanAmount / RepaymentPeriod;

            Balance := LoanAmount;
            TotalInterest := 0;

            for i := 1 to RepaymentPeriod do begin
                Clear(ScheduleObject);
                Interest := Balance * MonthlyInterestRate;
                Principal := InstallmentAmount - Interest;
                Balance := Balance - Principal;

                if i = RepaymentPeriod then begin
                    Principal := Principal + Balance;
                    Balance := 0;
                end;

                TotalInterest += Interest;

                ScheduleObject.Add('month', i);
                ScheduleObject.Add('installment', Round(InstallmentAmount, 0.01));
                ScheduleObject.Add('principal', Round(Principal, 0.01));
                ScheduleObject.Add('interest', Round(Interest, 0.01));
                ScheduleObject.Add('balance', Round(Balance, 0.01));

                ScheduleArray.Add(ScheduleObject);
            end;

            TotalRepayment := LoanAmount + TotalInterest;

            object.Add('total_repayment', TotalRepayment);
            object.Add('total_interest', TotalInterest);
            object.Add('amortization_schedule', ScheduleArray);
            outputjson.Add('loan_app_details', object);
            exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;



    local procedure GetSubSectors(mianSectorCode: Code[20]): Text
    var
        outputjson: JsonObject;
        SubSector: Record "Sub-Sector";
        jobject: JsonObject;
        jarray: JsonArray;
    begin
        Clear(jarray);
        SubSector.Reset();
        SubSector.SetRange(No, mianSectorCode);
        if SubSector.Find('-') then
            repeat
                Clear(jobject);
                jobject.Add('code', SubSector.Code);
                jobject.Add('description', SubSector.Description);
                jarray.Add(jobject);
            until SubSector.Next() = 0;
        outputjson.Add('subSectors', jarray);
        exit(Format(AddResponseHead(outputjson, true)));
    end;

    local procedure GetSpecificSectors(subSectorCode: Code[20]): Text
    var
        outputjson: JsonObject;
        SpecificSector: Record "Specific-Sector";
        jobject: JsonObject;
        jarray: JsonArray;
    begin
        Clear(jarray);
        SpecificSector.Reset();
        SpecificSector.SetRange(No, subSectorCode);
        if SpecificSector.Find('-') then
            repeat
                Clear(jobject);
                jobject.Add('code', SpecificSector.Code);
                jobject.Add('description', SpecificSector.Description);
                jarray.Add(jobject);
            until SpecificSector.Next() = 0;
        outputjson.Add('specificSectors', jarray);
        exit(Format(AddResponseHead(outputjson, true)));
    end;

    local procedure GetLoanProductDetails(LoanProductCode: Code[20]): Text
    var
        outputjson: JsonObject;
        object: JsonObject;
        MainSector: Record "Main Sector";
        jobject: JsonObject;
        jarray: JsonArray;
    begin
        if not LoanProductsTable.Get(LoanProductCode) then
            exit(Format(AddResponseHead(outputjson, false)));
        Clear(outputjson);

        object.Add('loan_product_code', LoanProductsTable.Code);
        object.Add('loan_product_name', LoanProductsTable."Product Description");
        object.Add('minimum_amount', LoanProductsTable."Min. Loan Amount");
        object.Add('maximum_amount', LoanProductsTable."Max. Loan Amount");
        object.Add('interest_rate', LoanProductsTable."Interest rate");
        object.Add('maximum_tenor_months', LoanProductsTable."No of Installment");
        outputjson.Add('loan_product_details', object);
        Clear(jarray);
        MainSector.Reset();
        if MainSector.Find('-') then
            repeat
                Clear(jobject);
                jobject.Add('code', MainSector.Code);
                jobject.Add('description', MainSector.Description);
                jarray.Add(jobject);
            until MainSector.Next() = 0;
        outputjson.Add('mainSectors', jarray);
        exit(Format(AddResponseHead(outputjson, true)));
    end;


    local procedure LoanAppPageDetails(memberNumber: Code[50]): Text
    var
        OutputJson: JsonObject;
        Object: JsonObject;
        subobject: JsonObject;
        subarray: JsonArray;
        Array: JsonArray;
        MainSector: Record "Main Sector";
        SubSector: Record "Sub-Sector";
        SaccoInsiders: Record "Sacco Insiders";
    begin
        Clear(OutputJson);
        Clear(Array);
        LoanProductsTable.Reset();
        LoanProductsTable.SetRange("Available on Portal", true);
        if LoanProductsTable.Find('-') then
            repeat
                Clear(Object);
                Object.Add('loan_product_code', LoanProductsTable.Code);
                Object.Add('loan_product_name', LoanProductsTable."Product Description");
                Object.Add('minimum_amount', LoanProductsTable."Min. Loan Amount");
                Object.Add('maximum_amount', LoanProductsTable."Max. Loan Amount");
                Object.Add('interest_rate', LoanProductsTable."Interest rate");
                Object.Add('maximum_tenor_months', LoanProductsTable."No of Installment");
                Array.Add(Object);
            until LoanProductsTable.Next() = 0;
        OutputJson.Add('loan_products', Array);

        Clear(Array);
        MainSector.Reset();
        if MainSector.Find() then
            repeat
                Clear(Object);
                // TableRelation = "Sub-Sector".Code where(No = FIELD("Main Sector"));
                Object.Add('main_sector', MainSector.Code);
                Object.Add('main_sector_description', MainSector.Description);
                Clear(subarray);
                SubSector.Reset();
                SubSector.SetRange(No, MainSector.Code);
                if SubSector.FindSet() then
                    repeat
                        Clear(subobject);
                        subobject.Add('sub_sector', SubSector.Code);
                        subobject.Add('sub_sector_description', SubSector.Description);
                        subarray.Add(subobject);
                    until SubSector.Next() = 0;
                Object.Add('sub_sectors', subarray);
                Array.Add(Object);
            until MainSector.Next() = 0;
        OutputJson.Add('main_sectors', Array);

        Clear(Object);
        Customer.reset();
        Customer.SetRange("No.", memberNumber);
        if Customer.Find('-') then begin
            Customer.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
            Object.Add('member_deposits', Customer."Current Shares");
            Object.Add('share_capital', Customer."Shares Retained");
            Object.Add('loan_outstanding_balance', Customer."Outstanding Balance");
            Object.Add('max_loan_qualification', ((Customer."Current Shares" * 3) - Customer."Outstanding Balance"));
            SaccoInsiders.Reset();
            if SaccoInsiders.Get(Customer."No.") then begin
                Object.Add('board_position', UpperCase(Format(SaccoInsiders."Position in society")));
                Object.Add('is_board_member', true);
            end;
        end;
        OutputJson.Add('employee_biodata', Object);
        exit(Format(AddResponseHead(OutputJson, true)));
    end;


    procedure SubmitInformation(args: Text): Text
    var
        requestjson: JsonObject;
        requesttype: Text;
        jsontoken: JsonToken;
        element: JsonObject;
    begin
        if not requestjson.ReadFrom(args) then
            Error('Invalid JSON input');

        requestjson.Get('request_type', jsontoken);
        requesttype := jsontoken.AsValue().AsText();

        if requesttype = 'next_of_kin_change' then begin
            requestjson.Get('next_of_kin_change', jsontoken);
            exit(UpdateNextofKin(jsontoken.AsObject()));
        end;
        if requesttype = 'ephone_change' then begin
            requestjson.Get('ephone_change', jsontoken);
            exit(UpdateEPhone(jsontoken.AsObject()));
        end;

        if (RequestType = 'loan_submission') then begin
            RequestJson.Get('loan_information', JsonToken);
            exit(SubmitLoanApplication(JsonToken.AsObject()));
        end;
        if (RequestType = 'add_guarantor') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(SubmitGuarantorshipRequest(JsonToken.AsObject()));
        end;
        if (RequestType = 'add_witness') then begin
            RequestJson.Get('witness_request', JsonToken);
            exit(SubmitWitnessRequest(JsonToken.AsObject()));
        end;

        if (RequestType = 'remove_guarantor') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(RemoveGuarantorshipRequest(JsonToken.AsObject()));
        end;
        if (RequestType = 'accept_guarantorship') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(SendAcceptGuarantorshipOTP(JsonToken.AsObject()));
        end;
        if (RequestType = 'accept_witness') then begin
            RequestJson.Get('witness_request', JsonToken);
            exit(SendAcceptWitnessOTP(JsonToken.AsObject()));
        end;
        if (RequestType = 'reject_guarantorship') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(RejectGuarantorship(JsonToken.AsObject()));
        end;
        if (RequestType = 'reject_witness') then begin
            RequestJson.Get('witness_request', JsonToken);
            exit(RejectWitness(JsonToken.AsObject()));
        end;
        if (RequestType = 'confirm_accept_guarantorship') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(ConfirmAcceptGuarantorshipOTP(JsonToken.AsObject()));
        end;
        if (RequestType = 'confirm_accept_witness') then begin
            RequestJson.Get('witness_request', JsonToken);
            exit(ConfirmAcceptWitnessOTP(JsonToken.AsObject()));
        end;
        if (RequestType = 'update_accept_guarantorship') then begin
            RequestJson.Get('guarantorship_request', JsonToken);
            exit(UpdateAcceptGuarantorship(JsonToken.AsObject()));
        end;
        if (RequestType = 'update_accept_witness') then begin
            RequestJson.Get('witness_request', JsonToken);
            exit(UpdateAcceptWitness(JsonToken.AsObject()));
        end;
        if (RequestType = 'update_documents') then begin
            // RequestJson.Get('loan', JsonToken);
            exit(UpdateUploadedDocuments(requestjson));
        end;
        if (RequestType = 'member_application') then begin
            RequestJson.Get('membership_application', JsonToken);
            exit(Format(SubmitMembershipApplication(JsonToken.AsObject())));
        end;
    end;

    [TryFunction]
    local procedure TryValidateApplicationIdNo(var MembApp: Record "Membership Applications"; NewIdNo: Text)
    begin
        MembApp.Validate("ID No.", NewIdNo);
    end;

    local procedure SubmitMembershipApplication(RequestJson: JsonObject) OutputJson: JsonObject
    var
        MembApp: Record "Membership Applications";
        Kin: Record "Member App Next Of kin";
        Referrer: Record Customer;
        KinJson: JsonObject;
        JsonToken: JsonToken;
        IdNumber: Text;
        ReferrerMemberNo: Text;
        GenderText: Text;
        TermsText: Text;
    begin
        Clear(OutputJson);

        if RequestJson.Get('referrer_member_number', JsonToken) and not JsonToken.AsValue().IsNull then
            ReferrerMemberNo := JsonToken.AsValue().AsText();

        if ReferrerMemberNo = '' then begin
            OutputJson.Add('response_message', 'A verified referrer is required to submit an application.');
            exit(AddResponseHead(OutputJson, false));
        end;

        Referrer.Reset();
        Referrer.SetRange(Referrer."No.", UpperCase(ReferrerMemberNo));
        if not Referrer.FindFirst() then begin
            OutputJson.Add('response_message', 'The referrer could not be verified.');
            exit(AddResponseHead(OutputJson, false));
        end;

        if RequestJson.Get('id_number', JsonToken) and not JsonToken.AsValue().IsNull then
            IdNumber := JsonToken.AsValue().AsText();

        MembApp.Init();
        if not TryValidateApplicationIdNo(MembApp, IdNumber) then begin
            OutputJson.Add('response_message', 'An applicant with this ID number already exists.');
            exit(AddResponseHead(OutputJson, false));
        end;

        if RequestJson.Get('full_name', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp.Validate(Name, JsonToken.AsValue().AsText());
        if RequestJson.Get('official_designation', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Official Designation" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Official Designation"));

        if RequestJson.Get('gender', JsonToken) and not JsonToken.AsValue().IsNull then begin
            GenderText := LowerCase(JsonToken.AsValue().AsText());
            if GenderText = 'male' then
                MembApp.Gender := MembApp.Gender::Male;
            if GenderText = 'female' then
                MembApp.Gender := MembApp.Gender::Female;
        end;

        if RequestJson.Get('employer_name', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Employer Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Employer Name"));

        if RequestJson.Get('date_employed', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Date Employed" := System.DT2Date(JsonToken.AsValue().AsDateTime());

        if RequestJson.Get('terms_of_service', JsonToken) and not JsonToken.AsValue().IsNull then begin
            TermsText := LowerCase(JsonToken.AsValue().AsText());
            if TermsText = 'permanent' then
                MembApp."Terms of Employment" := MembApp."Terms of Employment"::Permanent;
            if TermsText = 'contract' then
                MembApp."Terms of Employment" := MembApp."Terms of Employment"::Contract;
            if (TermsText = 'casual') or (TermsText = 'temporary') then
                MembApp."Terms of Employment" := MembApp."Terms of Employment"::Casual;
        end;

        if RequestJson.Get('department', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Station/Department" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Station/Department"));

        if RequestJson.Get('payroll_number', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Payroll/Staff No" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Payroll/Staff No"));

        if RequestJson.Get('home_address', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp.Validate("Home Address", JsonToken.AsValue().AsText());

        if RequestJson.Get('phone_number', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Mobile Phone No" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Mobile Phone No"));

        if RequestJson.Get('email_address', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."E-Mail (Personal)" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."E-Mail (Personal)"));

        if RequestJson.Get('alternate_email_address', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."E-Mail (Personal2)" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."E-Mail (Personal2)"));

        if RequestJson.Get('kra_pin_number', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."KRA Pin" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."KRA Pin"));

        if RequestJson.Get('starting_share_contribution', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Monthly Contribution" := JsonToken.AsValue().AsDecimal();

        if RequestJson.Get('bank_name', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Bank Name" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Bank Name"));
        if RequestJson.Get('bank_branch', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Bank Branch" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Bank Branch"));
        if RequestJson.Get('bank_account_number', JsonToken) and not JsonToken.AsValue().IsNull then
            MembApp."Bank Account No" := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MembApp."Bank Account No"));

        MembApp."Referee Member No" := CopyStr(UpperCase(ReferrerMemberNo), 1, MaxStrLen(MembApp."Referee Member No"));
        MembApp.Validate("Recruited By", UpperCase(ReferrerMemberNo));

        MembApp.Insert(true);

        if RequestJson.Get('next_of_kin', JsonToken) and JsonToken.IsObject() then begin
            KinJson := JsonToken.AsObject();
            Kin.Init();
            Kin."Account No" := MembApp."No.";
            if KinJson.Get('full_name', JsonToken) and not JsonToken.AsValue().IsNull then
                Kin.Name := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Kin.Name));
            if KinJson.Get('relationship', JsonToken) and not JsonToken.AsValue().IsNull then
                Kin.Relationship := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Kin.Relationship));
            if KinJson.Get('address', JsonToken) and not JsonToken.AsValue().IsNull then
                Kin.Address := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Kin.Address));
            if KinJson.Get('phone_number', JsonToken) and not JsonToken.AsValue().IsNull then
                Kin.Telephone := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Kin.Telephone));
            if KinJson.Get('id_number', JsonToken) and not JsonToken.AsValue().IsNull then
                Kin."ID No." := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(Kin."ID No."));
            Kin.Type := Kin.Type::"Next of Kin";
            Kin."%Allocation" := 100;
            if Kin.Name <> '' then
                Kin.Insert();
        end;

        OutputJson.Add('response_message', MembApp."No.");
        exit(AddResponseHead(OutputJson, true));
    end;


    local procedure UpdateUploadedDocuments(RequestJson: JsonObject): Text
    var
        Sharepoint: Record "SharePoint Documents";
        jsontoken: JsonToken;
        ElementNumber: Code[50];
        array: JsonArray;
        object: JsonObject;
    begin
        requestJson.Get('document_number', jsontoken);
        ElementNumber := jsontoken.AsValue().AsCode();
        requestJson.Get('documents', jsontoken);
        array := jsontoken.AsArray();
        if array.Count() > 0 then begin
            foreach jsontoken in array do begin
                if jsontoken.IsObject() then begin
                    Clear(object);
                    object := jsontoken.AsObject();
                    Sharepoint.Reset();
                    Sharepoint.SetRange("Document No", ElementNumber);
                    object.Get('file_name', jsontoken);
                    Sharepoint.SetRange("File Name", jsontoken.AsValue().AsText());
                    if not Sharepoint.FindFirst() then begin
                        Sharepoint.Init();
                        Sharepoint."Document No" := ElementNumber;
                        Sharepoint."File Name" := jsontoken.AsValue().AsText();
                        object.Get('file_location', jsontoken);
                        Sharepoint.Location := jsontoken.AsValue().AsText();
                        object.Get('file_extension', jsontoken);
                        Sharepoint."File type" := jsontoken.AsValue().AsText();
                        Sharepoint.Insert(true);
                    end;
                end;
            end;
        end;
    end;

    //                 file_name = payslipfinalFileName,
    // file_extension = payslipfileExtension,
    // file_location = payslipBcSavePath,

    local procedure RejectGuarantorship(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        Clear(outputjson);
        GuarantorshipTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        if GuarantorshipTable.Find('-') then begin
            if requestJson.Get('comments', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable.Comments := jsontoken.AsValue().AsText();
            GuarantorshipTable."Is OTP Verified" := false;
            GuarantorshipTable.Status := GuarantorshipTable.Status::Rejected;
            GuarantorshipTable."Approval/Rejection Date" := Today;
            SMSMessage := 'Dear ' + GuarantorshipTable."Member Name" + ', We regret to inform you that your Guarantorship request for loan number ' + GuarantorshipTable."Loan Number" + ' has been rejected. Thank you. Devco Sacco Ltd.';
            SendCustomSMS(GuarantorshipTable."Member Number", SMSMessage);
            if GuarantorshipTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure RejectWitness(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        WitnessTable: record "Loan Witness Table";
    begin
        Clear(outputjson);
        WitnessTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        WitnessTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        WitnessTable.SetRange("Witness Number", jsontoken.AsValue().AsCode());
        if WitnessTable.Find('-') then begin
            if requestJson.Get('comments', jsontoken) and not jsontoken.AsValue().IsNull then
                WitnessTable.Comments := jsontoken.AsValue().AsText();
            WitnessTable."Is OTP Verified" := false;
            WitnessTable.Status := WitnessTable.Status::Rejected;
            WitnessTable."Approval/Rejection Date" := Today;
            SMSMessage := 'Dear ' + WitnessTable."Member Name" + ', We regret to inform you that your Witness request for loan number ' + WitnessTable."Loan Number" + ' has been rejected. Thank you. Devco Sacco Ltd.';
            SendCustomSMS(WitnessTable."Member Number", SMSMessage);
            if WitnessTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure UpdateAcceptGuarantorship(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        GuarantorshipTable: Record "Guarantorship Tracking";
        GuarantorsTable: Record "Loans Guarantee Details";
    begin
        Clear(outputjson);
        GuarantorshipTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        GuarantorshipTable.SetRange("Is OTP Verified", true);
        if GuarantorshipTable.Find('-') then begin
            if requestJson.Get('approved_amount', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Approved Amount" := jsontoken.AsValue().AsDecimal();
            if requestJson.Get('comments', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable.Comments := jsontoken.AsValue().AsText();
            GuarantorshipTable.Status := GuarantorshipTable.Status::Approved;
            GuarantorshipTable."Approval/Rejection Date" := Today;

            GuarantorsTable.Reset();
            GuarantorsTable.SetRange("Loan No", GuarantorshipTable."Loan Number");
            GuarantorsTable.SetRange("Member No", GuarantorshipTable."Guarantor Number");
            if GuarantorsTable.FindSet() then
                repeat
                    GuarantorsTable.Delete();
                until GuarantorsTable.Next() = 0;

            GuarantorsTable.Init();
            GuarantorsTable."Loan No" := GuarantorshipTable."Loan Number";
            GuarantorsTable."Member No" := GuarantorshipTable."Guarantor Number";
            if Customer.get(GuarantorsTable."Member No") then begin
                Customer.CalcFields(Customer."Current Shares", "Loans Guaranteed");
                GuarantorsTable.Name := Customer.Name;
                GuarantorsTable.Shares := Customer."Current Shares";
                GuarantorsTable."Total Loans Guaranteed" := Customer."Loans Guaranteed";
                GuarantorsTable."Free Shares" := ((GuarantorsTable.Shares * 4) - GuarantorsTable."Total Loans Guaranteed");
                GuarantorsTable."ID No." := Customer."ID No.";
                GuarantorsTable.Date := Today;
                //rec."Loan Balance" := FnGetPersonGuarantingLoanBal(rec."Member No");
                GuarantorsTable."Outstanding Balance" := FnGetPersonGuarantingLoanBal(GuarantorsTable."Member No");
                GuarantorsTable."Self Guarantee" := FnIsSelfGuarantee(GuarantorsTable."Loan No", GuarantorsTable."Member No");
            end;
            GuarantorsTable.Validate("Member No");
            GuarantorsTable."Amont Guaranteed" := GuarantorshipTable."Approved Amount";
            if not GuarantorsTable.Insert() then
                exit(Format(AddResponseHead(outputjson, false)));

            if GuarantorshipTable.Modify(true) then begin

                SendApprovalSMS(GuarantorshipTable."Member Number", '', 'GACOK');
                SMSMessage := 'Dear ' + GuarantorshipTable."Member Name" + ', Your Guarantorship request for loan number ' + GuarantorshipTable."Loan Number" + ' has been approved. Thank you. Devco Sacco Ltd.';
                SendCustomSMS(GuarantorshipTable."Member Number", SMSMessage);
                UpdateLoanGuarantorshipApprovals(GuarantorshipTable."Loan Number");
                exit(Format(AddResponseHead(outputjson, true)));
            end;
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure UpdateAcceptWitness(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        WitnessTable: Record "Loan Witness Table";
    // GuarantorsTable: Record "Loans Guarantee Details";
    begin
        Clear(outputjson);
        WitnessTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        WitnessTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        WitnessTable.SetRange("Witness Number", jsontoken.AsValue().AsCode());
        WitnessTable.SetRange("Is OTP Verified", true);
        if WitnessTable.Find('-') then begin
            // if requestJson.Get('approved_amount', jsontoken) and not jsontoken.AsValue().IsNull then
            //     GuarantorshipTable."Approved Amount" := jsontoken.AsValue().AsDecimal();
            if requestJson.Get('comments', jsontoken) and not jsontoken.AsValue().IsNull then
                WitnessTable.Comments := jsontoken.AsValue().AsText();
            WitnessTable.Status := WitnessTable.Status::Approved;
            WitnessTable."Approval/Rejection Date" := Today;
            if WitnessTable.Modify(true) then begin
                // SendApprovalSMS(WitnessTable."Member Number", '', 'GACOK');
                SMSMessage := 'Dear ' + WitnessTable."Member Name" + ', Your witness request for loan number ' + WitnessTable."Loan Number" + ' has been approved. Thank you. Devco Sacco Ltd.';
                SendCustomSMS(WitnessTable."Member Number", SMSMessage);
                UpdateLoanGuarantorshipApprovals(WitnessTable."Loan Number");
                exit(Format(AddResponseHead(outputjson, true)));
            end;
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure FnGetPersonGuarantingLoanBal(MemberNo: Code[20]): Decimal
    var
        LoansRegister: Record "Loans Register";
        LoanBalTotal: Decimal;
    begin
        LoanBalTotal := 0;
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Client Code", MemberNo);
        LoansRegister.SetAutoCalcFields(LoansRegister."Outstanding Balance");
        if LoansRegister.Find('-') then begin
            repeat
                LoanBalTotal += LoansRegister."Outstanding Balance";
            until LoansRegister.Next = 0;
        end;
        exit(LoanBalTotal);
    end;

    local procedure FnIsSelfGuarantee(LoanNo: Code[20]; MemberNo: Code[20]): Boolean
    var
        LoansRegister: Record "Loans Register";
    begin
        LoansRegister.Reset;
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        if LoansRegister.Find('-') then begin
            if LoansRegister."Client Code" = MemberNo then begin
                exit(true);
            end;
        end
        else begin
            exit(false);
        end;
    end;


    local procedure UpdateLoanGuarantorshipApprovals(requestNumber: Code[50]): Text
    var
        loanAmount: Decimal;
        totalguarantorshipAmount: Decimal;
        LoansTable: Record "Loans Register";
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        if LoansTable.Get(requestNumber) then begin
            loanAmount := LoansTable."Loan Amount";
            GuarantorshipTable.Reset();
            GuarantorshipTable.SetRange("Loan Number", LoansTable."Loan  No.");
            GuarantorshipTable.SetRange(Status, GuarantorshipTable.Status::Approved);
            if GuarantorshipTable.FindSet() then
                repeat
                    totalguarantorshipAmount += GuarantorshipTable."Approved Amount";
                until GuarantorshipTable.Next() = 0;

            if totalguarantorshipAmount >= loanAmount then
                LoansTable.PortalGuaranteedBoolean := true;
            LoansTable.Modify();
        end;
    end;

    local procedure SendApprovalSMS(memberNumber: Code[50]; OTPCode: Code[10]; Type: Code[10]): Text
    var
        SMSMessage: Text;
    begin

        case Type of
            'NOK':
                SMSMessage := 'Dear Member, Your OTP for Next of Kin approval is: ' + OTPCode + '. Keep it safe and do not share it with anyone. Thank you. Devco Sacco Ltd.';
            'BEN':
                SMSMessage := 'Dear Member, Your OTP for Beneficiary approval is: ' + OTPCode + '. Keep it safe and do not share it with anyone. Thank you. Devco Sacco Ltd.';
            'NOKOK':
                SMSMessage := 'Dear Member, Your Next of Kin has been successfully approved. Thank you. Devco Sacco Ltd.';
            'BENOK':
                SMSMessage := 'Dear Member, Your Beneficiary has been successfully approved. Thank you. Devco Sacco Ltd.';
            'GACOK':
                SMSMessage := 'Dear Member, Your Guarantorship request has been successfully approved. Thank you. Devco Sacco Ltd.';
        end;
        // Customer.Reset();
        // Customer.SetRange("No.", memberNumber);
        // if Customer.Find('-') then
        //     SmsManagement.SendSmsResponse(CustomerTable."Mobile Phone No", SMSMessage);
        SendCustomSMS(memberNumber, SMSMessage);
        // SmsManagement.SendSmsResponse('254715881357', SMSMessage);
        exit('');
    end;

    local procedure ConfirmAcceptGuarantorshipOTP(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        GuarantorshipTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('otp_code', jsontoken);
        GuarantorshipTable.SetRange(OTP, jsontoken.AsValue().AsCode());
        if GuarantorshipTable.Find('-') then begin
            GuarantorshipTable.OTP := '';
            GuarantorshipTable."Is OTP Verified" := true;
            if GuarantorshipTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure ConfirmAcceptWitnessOTP(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        WitnessTable: Record "Loan Witness Table";
    begin
        WitnessTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        WitnessTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        WitnessTable.SetRange("Witness Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('otp_code', jsontoken);
        WitnessTable.SetRange(OTP, jsontoken.AsValue().AsCode());
        if WitnessTable.Find('-') then begin
            WitnessTable.OTP := '';
            WitnessTable."Is OTP Verified" := true;
            if WitnessTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SendAcceptGuarantorshipOTP(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        OTPCode: Code[10];
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        Clear(outputjson);
        OTPCode := GenerateDigitsCode(6);
        // SendApprovalSMS(MemberNumber, CodeTxt, 'NOK');
        GuarantorshipTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        if GuarantorshipTable.Find('-') then begin
            GuarantorshipTable.OTP := OTPCode;
            GuarantorshipTable."Is OTP Verified" := false;
            GuarantorshipTable."OTP send Date" := CreateDateTime(Today, Time);
            SMSMessage := 'Dear ' + GuarantorshipTable."Guarantor Name" + ', Your OTP for Guarantorship approval is: ' + OTPCode + '. Keep it safe and do not share it with anyone. Thank you. Devco Sacco Ltd.';
            SendCustomSMS(GuarantorshipTable."Guarantor Number", SMSMessage);
            outputjson.Add('response_message', OTPCode);
            if GuarantorshipTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SendAcceptWitnessOTP(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        OTPCode: Code[10];
        outputjson: JsonObject;
        SMSMessage: Text[2048];
        WitnessTable: record "Loan Witness Table";
    begin
        Clear(outputjson);
        OTPCode := GenerateDigitsCode(6);
        // SendApprovalSMS(MemberNumber, CodeTxt, 'NOK');
        WitnessTable.Reset();
        RequestJson.Get('loan_number', jsontoken);
        WitnessTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        RequestJson.Get('guarantor_number', jsontoken);
        WitnessTable.SetRange("Witness Number", jsontoken.AsValue().AsCode());
        if WitnessTable.Find('-') then begin
            WitnessTable.OTP := OTPCode;
            WitnessTable."Is OTP Verified" := false;
            WitnessTable."OTP send Date" := CreateDateTime(Today, Time);
            SMSMessage := 'Dear ' + WitnessTable."Witness Name" + ', Your OTP for Witness approval is: ' + OTPCode + '. Keep it safe and do not share it with anyone. Thank you. Devco Sacco Ltd.';
            SendCustomSMS(WitnessTable."Witness Number", SMSMessage);
            outputjson.Add('response_message', OTPCode);
            if WitnessTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SendCustomSMS(memberNumber: Code[50]; SMSMessage: Text[2048]): Text
    var
        SMSMessages: Record "SMS Messages";
        Lineno: Integer;
    begin
        Customer.Reset();
        Customer.SetRange("No.", memberNumber);
        if Customer.Find('-') then begin
            SMSMessages.Reset;
            if SMSMessages.FindLast() then
                Lineno := SMSMessages."Entry No" + 1;
            SMSMessages.Init();
            SMSMessages."Entry No" := Lineno;
            SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
            SMSMessages."SMS Message" := SMSMessage;
            SMSMessages."Telephone No" := Customer."Mobile Phone No.";
            SMSMessages."Date Entered" := Today;
            SMSMessages.Source := 'PORTAL';
            SMSMessages."Entered By" := UserId;
            SMSMessages."Time Entered" := time;
            SMSMessages."Account No" := Customer."No.";
            SMSMessages."Batch No" := Customer."No.";
            SMSMessages.Insert(true);
        end;

        exit('okay');
    end;

    local procedure GenerateDigitsCode(Digits: Integer): Text
    var
        RandomNumber: Integer;
        Code: Text;
        Characters: Text[36];
        i: Integer;
        MaxAttempts: Integer;
    begin
        Characters := 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
        Code := '';
        MaxAttempts := 0;

        while (StrLen(Code) < Digits) and (MaxAttempts < 100) do begin
            RandomNumber := Random(StrLen(Characters));
            if RandomNumber = 0 then
                RandomNumber := 1;

            Code += CopyStr(Characters, RandomNumber, 1);
            MaxAttempts += 1;
        end;

        while StrLen(Code) < Digits do
            Code += Format(Random(10));

        exit(Code);
    end;

    local procedure RemoveGuarantorshipRequest(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        Clear(outputjson);
        GuarantorshipTable.Reset();
        requestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        requestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        // GuarantorshipTable.SetRange(Status, GuarantorshipTable.Status::Requested);
        if GuarantorshipTable.Find('-') then begin
            if GuarantorshipTable.Delete() then
                exit(Format(AddResponseHead(outputjson, true)));
        end;

        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SubmitGuarantorshipRequest(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        GuarantorshipTable: Record "Guarantorship Tracking";
    begin
        Clear(outputjson);
        GuarantorshipTable.Reset();
        requestJson.Get('loan_number', jsontoken);
        GuarantorshipTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        requestJson.Get('guarantor_number', jsontoken);
        GuarantorshipTable.SetRange("Guarantor Number", jsontoken.AsValue().AsCode());
        if GuarantorshipTable.Find('-') then begin
            if GuarantorshipTable.Status <> GuarantorshipTable.Status::Requested then
                exit(Format(AddResponseHead(outputjson, false)));
            if requestJson.Get('requested_amount', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Requested Amount" := jsontoken.AsValue().AsDecimal();
            if GuarantorshipTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end else begin
            if requestJson.Get('member_number', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Member Number" := jsontoken.AsValue().AsCode();
            if requestJson.Get('loan_number', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Loan Number" := jsontoken.AsValue().AsCode();
            if requestJson.Get('guarantor_number', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Guarantor Number" := jsontoken.AsValue().AsCode();
            if requestJson.Get('requested_amount', jsontoken) and not jsontoken.AsValue().IsNull then
                GuarantorshipTable."Requested Amount" := jsontoken.AsValue().AsDecimal();
            GuarantorshipTable.Status := GuarantorshipTable.Status::Requested;
            GuarantorshipTable."Requested Date" := Today;
            GuarantorshipTable."Is OTP Verified" := false;
            if GuarantorshipTable.Insert(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;

        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SubmitWitnessRequest(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        outputjson: JsonObject;
        WitnessTable: Record "Loan Witness Table";
    begin
        Clear(outputjson);
        WitnessTable.Reset();
        requestJson.Get('loan_number', jsontoken);
        WitnessTable.SetRange("Loan Number", jsontoken.AsValue().AsCode());
        requestJson.Get('guarantor_number', jsontoken);
        WitnessTable.SetRange("Witness Number", jsontoken.AsValue().AsCode());
        if WitnessTable.Find('-') then begin
            if WitnessTable.Status <> WitnessTable.Status::Requested then
                exit(Format(AddResponseHead(outputjson, false)));
            if WitnessTable.Modify(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end else begin
            if requestJson.Get('member_number', jsontoken) and not jsontoken.AsValue().IsNull then
                WitnessTable."Member Number" := jsontoken.AsValue().AsCode();
            if requestJson.Get('loan_number', jsontoken) and not jsontoken.AsValue().IsNull then
                WitnessTable."Loan Number" := jsontoken.AsValue().AsCode();
            if requestJson.Get('guarantor_number', jsontoken) and not jsontoken.AsValue().IsNull then
                WitnessTable."Witness Number" := jsontoken.AsValue().AsCode();
            WitnessTable.Status := WitnessTable.Status::Requested;
            WitnessTable."Requested Date" := Today;
            WitnessTable."Is OTP Verified" := false;
            if WitnessTable.Insert(true) then
                exit(Format(AddResponseHead(outputjson, true)));
        end;

        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure SubmitLoanApplication(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        NextApplicationNumber: code[50];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sacco No. Series";
        outputjson: JsonObject;
        LoansTable: Record "Loans Register";
        DisbursementModeText: Text;
        RemarksText: Text;
    begin
        requestJson.Get('member_number', jsontoken);
        if Customer.Get(jsontoken.AsValue().AsCode()) then begin
            LoansTable.Reset();
            if requestJson.Get('loan_code', jsontoken) and not jsontoken.AsValue().IsNull then
                LoansTable.SetRange("Loan Product Type", jsontoken.AsValue().AsCode());
            LoansTable.SetRange(Posted, true);
            LoansTable.SetRange("Client Code", Customer."No.");
            if LoansTable.FindFirst() then begin
                outputjson.Add('response_message', 'You have an Existing Loan with the same product Type. Please Change the Product Type');
                exit(Format(AddResponseHead(outputjson, false)));
            end;

            SalesSetup.GET;
            SalesSetup.TESTFIELD("BOSA Loans Nos");
            NextApplicationNumber := NoSeriesManagement.GetNextNo(SalesSetup."BOSA Loans Nos", 0D, TRUE);

            LoansTable.Reset();
            LoansTable.Init();
            LoansTable.Source := LoansTable.Source::BOSA;
            LoansTable."Loan  No." := NextApplicationNumber;
            LoansTable."Application Date" := Today;
            LoansTable.Advice := true;
            LoansTable."Client Code" := Customer."No.";
            if requestJson.Get('loan_code', jsontoken) and not jsontoken.AsValue().IsNull then
                LoansTable."Loan Product Type" := jsontoken.AsValue().AsCode();

            LoansTable."Captured By" := UserId;

            if LoansTable.Insert() then begin
                LoansTable.Validate("Client Code");
                LoansTable.Validate("Loan Product Type");
                if requestJson.Get('repayment_period', jsontoken) and not jsontoken.AsValue().IsNull then
                    LoansTable.Installments := jsontoken.AsValue().AsInteger();
                if requestJson.Get('loan_amount', jsontoken) and not jsontoken.AsValue().IsNull then
                    LoansTable."Requested Amount" := jsontoken.AsValue().AsDecimal();
                if requestJson.Get('main_sector', jsontoken) and not jsontoken.AsValue().IsNull then
                    LoansTable."Main Sector" := jsontoken.AsValue().AsCode();
                if requestJson.Get('sub_sector', jsontoken) and not jsontoken.AsValue().IsNull then
                    LoansTable."Sub-Sector" := jsontoken.AsValue().Ascode();
                if requestJson.Get('specific_sector', jsontoken) and not jsontoken.AsValue().IsNull then
                    LoansTable."Specific Sector" := jsontoken.AsValue().AsCode();

                if requestJson.Get('disbursement_mode', jsontoken) and not jsontoken.AsValue().IsNull then begin
                    DisbursementModeText := jsontoken.AsValue().AsText();
                    if DisbursementModeText = 'BANK' then begin
                        LoansTable."Mode of Disbursement" := LoansTable."Mode of Disbursement"::BANK;
                        if requestJson.Get('bank_name', jsontoken) and not jsontoken.AsValue().IsNull then
                            LoansTable."Bank Name" := CopyStr(jsontoken.AsValue().AsText(), 1, MaxStrLen(LoansTable."Bank Name"));
                        if requestJson.Get('bank_branch', jsontoken) and not jsontoken.AsValue().IsNull then
                            LoansTable."Bank Branch" := CopyStr(jsontoken.AsValue().AsText(), 1, MaxStrLen(LoansTable."Bank Branch"));
                        if requestJson.Get('bank_account_number', jsontoken) and not jsontoken.AsValue().IsNull then
                            LoansTable."Bank Account No" := jsontoken.AsValue().AsInteger();
                        if requestJson.Get('bank_account_name', jsontoken) and not jsontoken.AsValue().IsNull then
                            LoansTable."Bank Account Name" := CopyStr(jsontoken.AsValue().AsText(), 1, MaxStrLen(LoansTable."Bank Account Name"));
                    end else
                        if DisbursementModeText = 'MPESA' then begin
                            LoansTable."Mode of Disbursement" := LoansTable."Mode of Disbursement"::MPESA;
                            if requestJson.Get('mpesa_phone_number', jsontoken) and not jsontoken.AsValue().IsNull then
                                LoansTable."Mpesa Number" := CopyStr(jsontoken.AsValue().AsText(), 1, MaxStrLen(LoansTable."Mpesa Number"));
                        end;
                end;

                if requestJson.Get('is_top_up', jsontoken) and not jsontoken.AsValue().IsNull and jsontoken.AsValue().AsBoolean() then
                    if requestJson.Get('top_up_loan_number', jsontoken) and not jsontoken.AsValue().IsNull then begin
                        LoansTable."Is Loan Top Up" := true;
                        LoansTable."Topup Loan No" := jsontoken.AsValue().AsText();
                    end;

                if RemarksText <> '' then
                    LoansTable.Remarks := CopyStr(RemarksText, 1, MaxStrLen(LoansTable.Remarks));

                LoansTable.Validate("Requested Amount");
                LoansTable.Modify();
                outputJson.Add('response_message', NextApplicationNumber);
                exit(Format(AddResponseHead(outputJson, true)));
            end;

        end;
        exit(Format(AddResponseHead(outputJson, false)));
    end;



    local procedure UpdateNextofKin(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        elementlines: JsonArray;
        elementline: JsonObject;
        ChangeRequest: Record "Change Request";
        SalesSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextNo: Code[50];
        NewKIN: Record "Change Request-Next of Kin";
        outputjson: JsonObject;
    begin

        Customer.Reset();
        requestJson.Get('membernumber', jsontoken);
        Customer.SetRange(Customer."No.", jsontoken.AsValue().AsCode());
        if Customer.FindFirst() then begin
            ChangeRequest.Reset();
            ChangeRequest.SetRange("Account No", Customer."No.");
            ChangeRequest.SetFilter(Status, '%1|%2', ChangeRequest.Status::Open, ChangeRequest.Status::Pending);
            ChangeRequest.SetRange(Type, ChangeRequest.Type::"Next Of Kin Change");
            if not ChangeRequest.Find('-') then begin
                SalesSetup.Get;
                SalesSetup.TestField(SalesSetup."Change Request No");
                NextNo := NoSeriesMgt.GetNextNo(SalesSetup."Change Request No", 0D, TRUE);
                ChangeRequest.Init();
                ChangeRequest.No := NextNo;
                ChangeRequest."No. Series" := '';
                ChangeRequest.Type := ChangeRequest.Type::"Next Of Kin Change";
                ChangeRequest."Account No" := Customer."No.";
                ChangeRequest.Validate("Account No");
                ChangeRequest."Capture Date" := Today;
                ChangeRequest."Captured by" := UserId;
                requestJson.Get('change_reason', jsontoken);
                ChangeRequest."Reason for change" := jsontoken.AsValue().AsText();
                if ChangeRequest.Insert() then begin
                    outputjson.Add('response_message', NextNo);
                    NewKIN.Reset;
                    NewKIN.SetRange(NewKIN."Change Request no", NextNo);
                    if NewKIN.FindFirst then
                        NewKIN.DeleteAll;

                    requestJson.Get('nextofkins', jsontoken);
                    elementlines := jsontoken.AsArray();
                    if elementlines.Count() > 0 then begin
                        foreach jsontoken in elementlines do begin
                            if jsontoken.IsObject() then begin
                                Clear(elementline);
                                elementline := jsontoken.AsObject();
                                NewKIN.Init;
                                NewKIN."Account No" := Customer."No.";
                                if elementline.Get('kin_name', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN."Full Names" := jsontoken.AsValue().AsText();
                                if elementline.Get('relationship', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN.Relationship := jsontoken.AsValue().AsText();
                                if elementline.Get('id_number', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN."Identification No." := jsontoken.AsValue().AsText();
                                if elementline.Get('allocation', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN."%Allocation" := jsontoken.AsValue().AsDecimal();
                                if elementline.Get('phone_number', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN."Phone No" := jsontoken.AsValue().AsText();
                                if elementline.Get('email_address', jsontoken) and not jsontoken.AsValue().IsNull then
                                    NewKIN.Email := jsontoken.AsValue().AsText();
                                NewKIN."Change Request no" := NextNo;
                                NewKIN.Insert;
                            end;
                        end;
                    end;
                    exit(Format(AddResponseHead(outputjson, true)));
                end;
            end;
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure UpdateEPhone(requestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        elementlines: JsonArray;
        elementline: JsonObject;
        ChangeRequest: Record "Change Request";
        SalesSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextNo: Code[50];
        outputjson: JsonObject;
    begin

        Customer.Reset();
        requestJson.Get('membernumber', jsontoken);
        Customer.SetRange(Customer."No.", jsontoken.AsValue().AsCode());
        if Customer.FindFirst() then begin
            ChangeRequest.Reset();
            ChangeRequest.SetRange("Account No", Customer."No.");
            ChangeRequest.SetFilter(Status, '%1|%2', ChangeRequest.Status::Open, ChangeRequest.Status::Pending);
            ChangeRequest.SetRange(Type, ChangeRequest.Type::"BOSA Change");
            if not ChangeRequest.Find('-') then begin
                SalesSetup.Get;
                SalesSetup.TestField(SalesSetup."Change Request No");
                NextNo := NoSeriesMgt.GetNextNo(SalesSetup."Change Request No", 0D, TRUE);
                ChangeRequest.Init();
                ChangeRequest.No := NextNo;
                ChangeRequest."No. Series" := '';
                ChangeRequest.Type := ChangeRequest.Type::"BOSA Change";
                ChangeRequest."Account No" := Customer."No.";
                ChangeRequest.Validate("Account No");
                ChangeRequest."Capture Date" := Today;
                ChangeRequest."Captured by" := UserId;
                requestJson.Get('change_reason', jsontoken);
                ChangeRequest."Reason for change" := jsontoken.AsValue().AsText();
                requestJson.Get('email', jsontoken);
                ChangeRequest."Email(New Value)" := LowerCase(jsontoken.AsValue().AsText());
                requestJson.Get('phone_number', jsontoken);
                ChangeRequest."Mobile No(New Value)" := LowerCase(jsontoken.AsValue().AsText());
                if ChangeRequest.Insert() then begin
                    outputjson.Add('response_message', NextNo);
                    exit(Format(AddResponseHead(outputjson, true)));
                end;
            end;
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure AddResponseHead(outputjson: JsonObject; status: Boolean): JsonObject
    begin
        if status then begin
            outputjson.Add('response_code', 200);
            outputjson.Add('ResponseStatus', 'Request is successfull');
        end else begin
            outputjson.Add('response_code', 404);
            outputjson.Add('ResponseStatus', 'Request failed');
        end;
        exit(outputjson);
    end;

    procedure RecordActivity(membernumber: Code[20]; type: code[10]; description: Text[500])
    begin
        Tracker.Init();
        Tracker.Date := Today();
        Tracker.Time := Time();
        if (type = 'BALCHK') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Balance Check";
        if (type = 'LOGIN') then
            tracker."Interaction Type" := Tracker."Interaction Type"::Login;
        if (type = 'SIGNUP') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Sign Up";
        if (type = 'LOGOUT') then
            tracker."Interaction Type" := Tracker."Interaction Type"::Logout;
        if (type = 'STMT') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Statement Retrieval";
        if (type = 'DWNLD') then
            tracker."Interaction Type" := Tracker."Interaction Type"::Download;
        if (type = 'PCHCK') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Profile Check";
        if (type = 'LNCHK') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Loan Check";
        if (type = 'LTCHCK') then
            tracker."Interaction Type" := Tracker."Interaction Type"::"Loan Types Check";

        Tracker.Description := description;
        Tracker.MemberNumber := membernumber;
        if (Customer.get(membernumber)) then begin
            Tracker.MemberName := Customer.Name;
            Tracker.Gender := Customer.Gender;
        end;
        Tracker.Insert();
    end;

    local procedure GetPortalDashboardData(ReqJson: JsonObject): Text
    var
        RootObj: JsonObject;
        KPIObj: JsonObject;
        StartDate: Date;
        EndDate: Date;
        InteractionTypeFilter: Text;
        GenderFilter: Text;
        jsontoken: JsonToken;

        BreakdownArr: JsonArray;
        TrendArr: JsonArray;
        TopMembersArr: JsonArray;
        LoginDistArr: JsonArray;
        GenderArr: JsonArray;

        QBkdown: Query "Portal Activity Breakdown";
        QTrend: Query "Portal Daily Trend";
        QTop: Query "Portal Top Members";
        QKPI: Query "Portal KPI Summary";
        QLogin: Query "Portal Login Distribution";
        QGender: Query "Portal Gender Distribution";

        ItemObj: JsonObject;

        TotalActivities: Integer;
        TotalLogins: Integer;
        TotalSignUps: Integer;
        TotalBalanceChecks: Integer;
        UniqueMembers: Integer;
        Statements: Integer;
        Loans: Integer;
        Profiles: Integer;
        TotalMale: Integer;
        TotalFemale: Integer;

        Hourly: array[24] of Integer;

        HourVal: Integer;
        DurationVal: Duration;
    begin
        Tracker.Reset();
        if Tracker.Find('-') then begin
            repeat
                Customer.Reset();
                if Customer.Get(Tracker.MemberNumber) then
                    Tracker.Gender := Customer.Gender;
                Tracker.Modify();
            until Tracker.Next() = 0;
        end;

        if ReqJson.Get('startDate', jsontoken) and not jsontoken.AsValue().IsNull then
            StartDate := System.DT2Date(jsontoken.AsValue().AsDateTime());
        if ReqJson.Get('endDate', jsontoken) and not jsontoken.AsValue().IsNull then
            EndDate := System.DT2Date(jsontoken.AsValue().AsDateTime());
        if ReqJson.Get('interactionType', jsontoken) and not jsontoken.AsValue().IsNull then
            InteractionTypeFilter := jsontoken.AsValue().AsText();
        if ReqJson.Get('gender', jsontoken) and not jsontoken.AsValue().IsNull then
            GenderFilter := jsontoken.AsValue().AsText();

        QKPI.SetRange(Date_Filter, StartDate, EndDate);
        if GenderFilter <> '' then
            QKPI.SetFilter(Gender_Filter, GenderFilter);

        if QKPI.Open() then begin
            while QKPI.Read() do begin
                TotalActivities += QKPI.ActivityCount;
                case QKPI.InteractionType of
                    QKPI.InteractionType::Login:
                        TotalLogins += QKPI.ActivityCount;
                    QKPI.InteractionType::"Balance Check":
                        TotalBalanceChecks += QKPI.ActivityCount;
                    QKPI.InteractionType::"Statement Retrieval":
                        Statements += QKPI.ActivityCount;
                    QKPI.InteractionType::"Loan Check",
                    QKPI.InteractionType::"Loan Types Check":
                        Loans += QKPI.ActivityCount;
                    QKPI.InteractionType::"Profile Check":
                        Profiles += QKPI.ActivityCount;
                    QKPI.InteractionType::"Sign Up":
                        TotalSignUps += QKPI.ActivityCount;
                end;
                case QKPI.Gender of
                    QKPI.Gender::Male:
                        TotalMale += QKPI.ActivityCount;
                    QKPI.Gender::Female:
                        TotalFemale += QKPI.ActivityCount;
                end;
            end;
            QKPI.Close();
        end;

        UniqueMembers := CalculateUniqueMembers(StartDate, EndDate, InteractionTypeFilter);

        KPIObj.Add('TotalActivities', TotalActivities);
        KPIObj.Add('TotalLogins', TotalLogins);
        KPIObj.Add('TotalSignUps', TotalSignUps);
        KPIObj.Add('TotalBalanceChecks', TotalBalanceChecks);
        KPIObj.Add('UniqueMembers', UniqueMembers);
        KPIObj.Add('StatementsRetrieved', Statements);
        KPIObj.Add('LoanChecks', Loans);
        KPIObj.Add('ProfileChecks', Profiles);
        KPIObj.Add('TotalMale', TotalMale);
        KPIObj.Add('TotalFemale', TotalFemale);

        QBkdown.SetRange(Date_Filter, StartDate, EndDate);
        if InteractionTypeFilter <> '' then
            QBkdown.SetFilter(Interaction_Type_Filter, InteractionTypeFilter);
        if GenderFilter <> '' then
            QBkdown.SetFilter(Gender_Filter, GenderFilter);

        if QBkdown.Open() then begin
            while QBkdown.Read() do begin
                Clear(ItemObj);
                ItemObj.Add('InteractionType', Format(QBkdown.InteractionType));
                ItemObj.Add('Count', QBkdown.ActivityCount);
                BreakdownArr.Add(ItemObj);
            end;
            QBkdown.Close();
        end;

        QTrend.SetRange(Date_Filter, StartDate, EndDate);
        if InteractionTypeFilter <> '' then
            QTrend.SetFilter(Interaction_Type_Filter, InteractionTypeFilter);
        if GenderFilter <> '' then
            QTrend.SetFilter(Gender_Filter, GenderFilter);

        if QTrend.Open() then begin
            while QTrend.Read() do begin
                Clear(ItemObj);
                ItemObj.Add('Date', Format(QTrend.ActivityDate, 0, 9));
                ItemObj.Add('Count', QTrend.ActivityCount);
                TrendArr.Add(ItemObj);
            end;
            QTrend.Close();
        end;

        QTop.SetRange(Date_Filter, StartDate, EndDate);
        if InteractionTypeFilter <> '' then
            QTop.SetFilter(Interaction_Type_Filter, InteractionTypeFilter);
        if GenderFilter <> '' then
            QTop.SetFilter(Gender_Filter, GenderFilter);

        if QTop.Open() then begin
            while QTop.Read() do begin
                Clear(ItemObj);
                ItemObj.Add('MemberNumber', QTop.MemberNumber);
                ItemObj.Add('MemberName', QTop.MemberName);
                ItemObj.Add('Count', QTop.ActivityCount);
                TopMembersArr.Add(ItemObj);
            end;
            QTop.Close();
        end;

        Clear(Hourly);

        QLogin.SetRange(Date_Filter, StartDate, EndDate);
        QLogin.SetRange(Interaction_Type_Filter, QLogin.Interaction_Type_Filter::Login);
        if GenderFilter <> '' then
            QLogin.SetFilter(Gender_Filter, GenderFilter);

        if QLogin.Open() then begin
            while QLogin.Read() do begin
                DurationVal := QLogin.ActivityTime - 000000T;
                HourVal := DurationVal div 3600000;
                if (HourVal >= 0) and (HourVal <= 23) then
                    Hourly[HourVal + 1] += QLogin.ActivityCount;
            end;
            QLogin.Close();
        end;

        for HourVal := 0 to 23 do begin
            Clear(ItemObj);
            ItemObj.Add('Hour', HourVal);
            ItemObj.Add('Count', Hourly[HourVal + 1]);
            LoginDistArr.Add(ItemObj);
        end;
        RootObj.Add('LoginDistribution', LoginDistArr);

        Clear(Hourly);
        Clear(ItemObj);
        Clear(LoginDistArr);
        Clear(QLogin);

        QLogin.SetRange(Date_Filter, StartDate, EndDate);
        QLogin.SetRange(Interaction_Type_Filter, QLogin.Interaction_Type_Filter::"Sign Up");
        if GenderFilter <> '' then
            QLogin.SetFilter(Gender_Filter, GenderFilter);

        if QLogin.Open() then begin
            while QLogin.Read() do begin
                DurationVal := QLogin.ActivityTime - 000000T;
                HourVal := DurationVal div 3600000;
                if (HourVal >= 0) and (HourVal <= 23) then
                    Hourly[HourVal + 1] += QLogin.ActivityCount;
            end;
            QLogin.Close();
        end;

        for HourVal := 0 to 23 do begin
            Clear(ItemObj);
            ItemObj.Add('Hour', HourVal);
            ItemObj.Add('Count', Hourly[HourVal + 1]);
            LoginDistArr.Add(ItemObj);
        end;
        RootObj.Add('SignUpDistribution', LoginDistArr);

        QGender.SetRange(Date_Filter, StartDate, EndDate);
        if InteractionTypeFilter <> '' then
            QGender.SetFilter(Interaction_Type_Filter, InteractionTypeFilter);

        if QGender.Open() then begin
            while QGender.Read() do begin
                Clear(ItemObj);
                ItemObj.Add('Gender', Format(QGender.Gender));
                ItemObj.Add('Count', QGender.ActivityCount);
                GenderArr.Add(ItemObj);
            end;
            QGender.Close();
        end;
        RootObj.Add('GenderDistribution', GenderArr);

        RootObj.Add('KPIs', KPIObj);
        RootObj.Add('ActivityBreakdown', BreakdownArr);
        RootObj.Add('DailyTrend', TrendArr);
        RootObj.Add('TopMembers', TopMembersArr);

        exit(Format(RootObj));
    end;

    local procedure CalculateUniqueMembers(StartDate: Date; EndDate: Date; InteractionTypeFilter: Text): Integer
    var
        Tracker: Record "Portal Tracker";
        DistinctMembers: Dictionary of [Code[20], Boolean];
    begin
        Tracker.SetRange("Date", StartDate, EndDate);
        if InteractionTypeFilter <> '' then
            Tracker.SetFilter("Interaction Type", InteractionTypeFilter);

        if Tracker.FindSet(false, false) then
            repeat
                if not DistinctMembers.ContainsKey(Tracker.MemberNumber) then
                    DistinctMembers.Add(Tracker.MemberNumber, true);
            until Tracker.Next() = 0;

        exit(DistinctMembers.Count());
    end;

    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    local procedure SetResponseStatus(var ResponseJson: JsonObject; ResponseCode: Text; ResponseStatus: Text; ResponseMessage: Text)
    begin
        ResponseJson.Add('ResponseCode', ResponseCode);
        ResponseJson.Add('ResponseStatus', ResponseStatus);
        ResponseJson.Add('Message', ResponseMessage);
    end;

    procedure ProcessRequest(RequestText: Text): Text
    var
        Requesttype: Text;
        RequestJson: JsonObject;
        JsonToken: JsonToken;
    begin
        if not JsonToken.ReadFrom(RequestText) then begin
            Error('Invalid Json Input1 %1', RequestText);
        end;

        if not JsonToken.IsObject then begin
            Error('Invalid Json Input2 %1', RequestText);
        end;

        RequestJson := JsonToken.AsObject();

        Requesttype := SelectJsonToken(RequestJson, '$.Requesttype').AsValue.AsText;

        case LowerCase(Requesttype) of
            //Retrieving Member details
            'member_details':
                exit(Format(GetMemberDetails(RequestJson)));
            //Retrieving member's accounts
            'member_accounts':
                exit(Format(GetAccountsPortal(RequestJson)));
            //Member outstanding loans
            'member_loans':
                exit(Format(GetLoansPortal(RequestJson)));
            //get loans guaranteed
            'loans_guaranteed':
                exit(Format(GetLoansGuaranteedPortal(RequestJson)));
            //Get loan guarantors
            'loan_guarantors':
                exit(Format(GetLoanGuarantorsPortal(RequestJson)));
            //Get next of kin
            'next_of_kins':
                exit(Format(GetNextOfKin(RequestJson)));
            //Statements
            //Dividends Statement
            'dividends_stmt':
                exit(Format(GetDividendPayslipReportPortal(RequestJson)));
            //Member Statement
            'member_stmt':
                exit(Format(GetAccountStatementReportPortal(RequestJson)));
            //Loan Statement
            'loan_stsmt':
                exit(Format(GetLoanStatementReportPortal(RequestJson)));
            //Loan Types
            'loan_types':
                exit(Format(GetLoanTypes(RequestJson)));
            //Member activity / login history
            'member_activity':
                exit(Format(GetMemberActivity(RequestJson)));
        end;
    end;

    local procedure GetMemberActivity(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        ActivityArr: JsonArray;
        ItemObj: JsonObject;
        Identifier: Text;
        ActivityTracker: Record "Portal Tracker";
        LastLoginTracker: Record "Portal Tracker";
        EntryCount: Integer;
        MaxEntries: Integer;
    begin
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        MaxEntries := 50;

        ActivityTracker.Reset();
        ActivityTracker.SetRange(MemberNumber, UpperCase(Identifier));
        if ActivityTracker.Find('+') then
            repeat
                Clear(ItemObj);
                ItemObj.Add('date', ActivityTracker.Date);
                ItemObj.Add('time', Format(ActivityTracker.Time, 0, '<Hours24>:<Minutes,2>:<Seconds,2>'));
                ItemObj.Add('interaction_type', Format(ActivityTracker."Interaction Type"));
                ItemObj.Add('description', ActivityTracker.Description);
                ActivityArr.Add(ItemObj);
                EntryCount += 1;
            until (ActivityTracker.Next(-1) = 0) or (EntryCount >= MaxEntries);

        LastLoginTracker.Reset();
        LastLoginTracker.SetRange(MemberNumber, UpperCase(Identifier));
        LastLoginTracker.SetRange("Interaction Type", LastLoginTracker."Interaction Type"::Login);
        if LastLoginTracker.Find('+') then
            DataJson.Add('lastlogin', CreateDateTime(LastLoginTracker.Date, LastLoginTracker.Time));

        DataJson.Add('activity', ActivityArr);

        SetResponseStatus(ResponseJson, '200', 'Success', 'Member activity retrieved successfully');
        ResponseJson.Add('memberactivity', DataJson);
    end;


    local procedure GetMemberDetails(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        Found: Boolean;
        ChangeRequest: Record "Change Request";
        SaccoInsiders: Record "Sacco Insiders";
        NetKin: Record "Members Next Kin Details";
    // New
    begin

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Customer.Reset();

        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));

        if Customer.FindFirst() then begin

            DataJson.Add('customer_type', UpperCase(Format(Customer."Account Category")));
            DataJson.Add('identifier_type', 'CUSTOMER_NO');
            DataJson.Add('membernumber', Customer."No.");
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
            if SaccoInsiders.Get(Customer."No.") then
                DataJson.Add('insiderStatus', UpperCase(Format(SaccoInsiders."Position in society")));
            ChangeRequest.Reset();
            ChangeRequest.SetRange("Account No", Customer."No.");
            ChangeRequest.SetFilter(Status, '%1|%2', ChangeRequest.Status::Open, ChangeRequest.Status::Pending);
            if ChangeRequest.Find('-') then
                DataJson.Add('change_requested', true)
            else
                DataJson.Add('change_requested', false);

            NetKin.Reset();
            NetKin.SetRange(NetKin."Account No", Customer."No.");
            if not NetKin.FindFirst() then
                DataJson.Add('needskinupdate', true)
            else
                DataJson.Add('needskinupdate', false);

            Found := true;
        end;

        if (Found = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Member Details retrieved successfully');
            ResponseJson.Add('memberdetails', DataJson);
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Details could not be retrieved');
        end;
    end;

    local procedure GetAccountsPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        AccountsArray: JsonArray;
        AccountObject: JsonObject;
        AccountTypes: Record "Account Types-Saving Products";
        Found: boolean;

    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Found := false;

        Customer.Reset();

        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));

        if Customer.FindFirst() then begin
            Clear(AccountObject);
            Customer.init;
            repeat
                Customer.CalcFields(Customer."Current Shares", "Housing Deposits", "Alpha Savings", "Junior Savings One", "Likizo Contribution", "Share Capital", "Dividend Amount");
                AccountObject.Add('Account_Number', Customer."No.");
                AccountObject.Add('Account_Name', Customer."Global Dimension 1 Code" + ' ' + 'Savings Account');
                AccountObject.Add('Account_Type', Customer."Global Dimension 1 Code" + ' ' + 'Account');
                AccountObject.Add('Account_Status', Customer.Status);
                AccountObject.Add('Currency', 'KES');
                AccountObject.Add('Deposits', Customer."Current Shares");
                AccountObject.Add('Alpha_Savings', Customer."Alpha Savings");
                AccountObject.Add('Juniour_Savings', Customer."Junior Savings One");
                AccountObject.Add('Housing_Contribution', Customer."Housing Deposits");
                AccountObject.Add('Holiday_Savings', Customer."Likizo Contribution");
                AccountObject.Add('ShareCapital', Customer."Share Capital");
                AccountObject.Add('DividendAmount', Customer."Dividend Amount");
                //AccountsArray.Add(AccountObject);
                Found := true;
            until Customer.Next() = 0;
        end;

        if (Found = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Member Accounts retrieved successfully');
            ResponseJson.Add('memberaccounts', AccountObject);
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Accounts could not be retrieved');
        end;

    end;

    local procedure GetLoansPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        LoansArray: JsonArray;
        LoanObject: JsonObject;
        Iterator: Integer;
        Loans: Record "Loans Register";
        ProdFactory: Record "Loan Products Setup";
        LoanNumber: Text;
        Schedule: Record "Loan Repayment Schedule";
        NextDate: Date;

        Found: Boolean;
        Found1: Boolean;

    begin
        Found := false;
        Found1 := false;

        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if Customer.FindFirst() then begin
            Found := true;
            Loans.Reset();
            Loans.SetRange(Loans."Client Code", Customer."No.");
            Loans.SetAutoCalcFields(Loans."Outstanding Balance");
            Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);
            if Loans.FindSet() then begin
                found1 := true;
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
        end;
        if (Found = true and found1 = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Member Loans retrieved successfully');
            ResponseJson.Add('memberloans', LoansArray);
        end else if (Found = true and Found1 = false) then begin
            SetResponseStatus(ResponseJson, '201', 'Success', 'Member Account found but no loans found');
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    local procedure GetLoanTypes(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        product: JsonObject;
        products: JsonArray;
        Lproduct: Record "Loan Products Setup";

    begin
        Lproduct.Reset();
        if Lproduct.Find('-') then begin
            repeat
                if Lproduct."Max. Loan Amount" > 0 then begin
                    Clear(product);
                    product.Add('Description', Lproduct."Product Description");
                    product.Add('MaxAmount', Lproduct."Max. Loan Amount");
                    product.Add('Installments', Lproduct."No of Installment");
                    product.Add('Interest', Lproduct."Interest rate");
                    products.Add(product);
                end;
            until Lproduct.Next() = 0;
        end;
        SetResponseStatus(ResponseJson, '200', 'Success', 'Loans Types retrieved successfully');
        ResponseJson.Add('loantypes', products);
    end;

    local procedure GetLoansGuaranteedPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        Guarantors: JsonObject;
        GuarantorsArray: JsonArray;
        IdentifierType: Text;
        Identifier: Text;
        Loans: Record "Loans Register";
        Found: Boolean;
        Found1: Boolean;
        loanG: record "Loans Guarantee Details";
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
        Found1 := false;
        SaccoGen.Get();

        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        IF Customer.FindFirst() then BEGIN
            Found := true;
            loanG.Reset();
            LoanG.SetRange(LoanG."Member No", Customer."No.");
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
            loanG.Reset();
            LoanG.SetRange(LoanG."Member No", Customer."No.");
            LoanG.SetAutoCalcFields(LoanG."Loans Outstanding");
            LoanG.SetFilter(LoanG."Loans Outstanding", '>%1', 0);
            if LoanG.FindFirst() then begin
                repeat
                    Loans.Reset();
                    Loans.SetRange(Loans."Loan  No.", LoanG."Loan No");
                    Loans.SetAutoCalcFields(loans."Outstanding Balance");
                    Loans.SetFilter(Loans."Outstanding Balance", '>%1', 0);

                    if Loans.FindFirst() then begin
                        Found1 := true;
                        Customer.Get(Loans."Client Code");
                        Guarantors.Add('member_number', Loans."Client Code");
                        Guarantors.Add('name', Loans."Client Name");
                        Guarantors.Add('phone_number', Customer."Mobile Phone No");
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
            end;
        end;
        if (Found = true and found1 = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Loans Guaranteed retrieved successfully');
            ResponseJson.Add('loansguaranteed', GuarantorsArray);
        end else if (Found = true and Found1 = false) then begin
            SetResponseStatus(ResponseJson, '201', 'Success', 'Member Account found but no loans guaranteed');
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    local procedure GetLoanGuarantorsPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        GuarantorsArray: JsonArray;
        GuarantorObject: JsonObject;
        Found: Boolean;
        Found1: Boolean;
        IdentifierType: Text;
        Identifier: Text;
        LoanX: Record "Loans Register";
        loanG: record "Loans Guarantee Details";

    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Found := false;
        Found1 := false;


        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if Customer.Find('-') then begin
            loanX.Reset();
            LoanX.SetRange(LoanX."Client Code", Customer."No.");
            LoanX.SetFilter("Outstanding Balance", '>%1', 0);
            if LoanX.FindFirst() then begin
                LoanX.CalcFields(LoanX."Outstanding Balance");
                repeat
                    loanG.Reset();
                    LoanG.SetRange(LoanG."Loan No", LoanX."Loan  No.");
                    if LoanG.FindFirst() then begin
                        repeat
                            Customer.Reset();
                            Customer.SetRange(Customer."No.", LoanG."Member No");
                            if Customer.FindFirst() then begin
                                GuarantorObject.Add('member_number', Customer."No.");
                                GuarantorObject.Add('guarantor_name', Customer.Name);
                                GuarantorObject.Add('phone_number', Customer."Mobile Phone No");
                                GuarantorObject.Add('amount_guaranteed', LoanG."Amont Guaranteed");
                                GuarantorObject.Add('status', UpperCase(Format(LoanG."Acceptance Status")));
                                GuarantorObject.Add('loan_balance', LoanX."Outstanding Balance");
                                GuarantorsArray.Add(GuarantorObject);
                                Clear(GuarantorObject);
                            end;
                        until LoanG.Next() = 0;
                    end;
                until LoanX.Next() = 0;
            end;
        end;

        if (Found = true and found1 = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Loan Guarantors retrieved successfully');
            ResponseJson.Add('loanguarantors', GuarantorsArray);
        end else if (Found = true and Found1 = false) then begin
            SetResponseStatus(ResponseJson, '201', 'Success', 'Member Account found but no loan guarantors');
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;

    end;

    local procedure GetNextOfKin(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        NextKinJson: JsonObject;
        NetKin: Record "Members Next Kin Details";
        NextKin: JsonArray;
        Found: Boolean;
        Found1: Boolean;

    begin
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        Found := false;
        Found1 := false;


        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if Customer.Find('-') then begin
            found := true;
            NetKin.Reset();
            NetKin.SetRange(NetKin."Account No", Customer."No.");
            if NetKin.FindSet() then begin
                Found1 := true;
                repeat
                    NextKinJson.Add('kin_name', NetKin.Name);
                    NextKinJson.Add('relationship', NetKin.Relationship);
                    NextKinJson.Add('allocation', NetKin."%Allocation");
                    NextKinJson.Add('status', 'status');
                    NextKinJson.Add('address', NetKin.Address);
                    NextKinJson.Add('phone_number', NetKin.Telephone);
                    NextKinJson.Add('id_number', NetKin."ID No.");
                    NextKinJson.Add('email_address', NetKin.Email);
                    NextKin.Add(NextKinJson);
                    Clear(NextKinJson);
                until NetKin.Next() = 0;
            end;

        end;

        if (Found = true and found1 = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Next of Kin Members successfully');
            ResponseJson.Add('nextofkins', NextKin);
        end else if (Found = true and Found1 = false) then begin
            SetResponseStatus(ResponseJson, '201', 'Success', 'Member Account found but no next of kin');
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    local procedure GetDividendPayslipReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        Members: Record Customer;
        TransactionsArray: JsonArray;
        TransactionObject: JsonObject;
        Iterator: Integer;
        Found: Boolean;
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        Period: Code[40];
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;

        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if Customer.FindFirst() then begin
            Found := true;
            varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);
            RecRef.GetTable(Customer);
            Report.SaveAs(Report::"Dividends Progressionslip", '', REPORTFORMAT::Pdf, OStream, RecRef);
            varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
            vConvertedContent := varBase64Conversion.ToBase64(IStream);
            DataJson.Add('pdf', vConvertedContent);
        end;

        if (Found = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Dividends Statement Retrieved successfully');
            ResponseJson.Add('dividendsstatament', DataJson);
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    local procedure GetLoanStatementReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        StartDate: Date;
        EndDate: Date;
        Iterator: Integer;
        Found: Boolean;
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
        loanNumber: Text;
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        loanNumber := SelectJsonToken(RequestJson, '$.loan_number').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;

        Customer.Reset();
        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));

        Customer.SetFilter(Customer."Date filter", '%1..%2', StartDate, EndDate);
        Customer.SetRange(Customer."Loan No. Filter", loanNumber);

        if Customer.FindFirst() then begin
            found := true;
            varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);

            RecRef.GetTable(Customer);
            Report.SaveAs(Report::"Member Loans Statement", '', REPORTFORMAT::Pdf, OStream, RecRef);
            varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
            vConvertedContent := varBase64Conversion.ToBase64(IStream);
            DataJson.Add('pdf', vConvertedContent);
        end;
        if (Found = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Loan Statement Retrieved successfully');
            ResponseJson.Add('loanstatement', DataJson);
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    local procedure GetAccountStatementReportPortal(RequestJson: JsonObject) ResponseJson: JsonObject
    var
        DataJson: JsonObject;
        IdentifierType: Text;
        Identifier: Text;
        StartDate: Date;
        EndDate: Date;
        Iterator: Integer;
        OpenBal: Decimal;
        Found: Boolean;
        varTempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        varBase64Conversion: Codeunit "Base64 Convert";
        vConvertedContent: Text;
        RecRef: RecordRef;
    begin
        Iterator := 0;
        Found := false;
        IdentifierType := SelectJsonToken(RequestJson, '$.identifier_type').AsValue.AsText;
        Identifier := SelectJsonToken(RequestJson, '$.identifier').AsValue.AsText;
        StartDate := SelectJsonToken(RequestJson, '$.start_date').AsValue.AsDate;
        EndDate := SelectJsonToken(RequestJson, '$.end_date').AsValue.AsDate;

        Customer.Reset();

        if IdentifierType = 'MSISDN' THEN
            Customer.SetRange(Customer."Mobile Phone No", UpperCase(Identifier));
        if IdentifierType = 'NATIONAL_ID_NUMBER' THEN
            Customer.SetRange(Customer."ID No.", UpperCase(Identifier));
        if IdentifierType = 'MEMBER_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'CUSTOMER_NO' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));
        if IdentifierType = 'ACCOUNT_NUMBER' THEN
            Customer.SetRange(Customer."No.", UpperCase(Identifier));

        Customer.SetFilter(Customer."Date Filter", '%1..%2', StartDate, EndDate);
        if Customer.FindFirst() then begin
            varTempBlob.CreateOutStream(OStream, TextEncoding::UTF8);
            RecRef.GetTable(Customer);
            Found := true;

            Report.SaveAs(Report::"Member Detailed Statement", '', REPORTFORMAT::Pdf, OStream, RecRef);
            varTempBlob.CreateInStream(IStream, TextEncoding::UTF8);
            vConvertedContent := varBase64Conversion.ToBase64(IStream);
            DataJson.Add('pdf', vConvertedContent);
        end;

        if (Found = true) then begin
            SetResponseStatus(ResponseJson, '200', 'Success', 'Member Statement Retrieved successfully');
            ResponseJson.Add('memberstatement', DataJson);
        end else begin
            SetResponseStatus(ResponseJson, '404', 'Failed', 'Member Account could not be retrieved');
        end;
    end;

    procedure ImportImageFromBase64(memberNumber: Code[50]; Base64Text: Text; FileName: Text; MimeType: Text; ImageType: Text; CRCode: Code[50]): Boolean
    var
        CustomerTable: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        MediaId: Guid;
        i: Integer;
        ChangeRequest: Record "Change Request";
    begin

        if CustomerTable.Get(memberNumber) then begin
            ChangeRequest.Reset();
            // ChangeRequest.SetRange("Account No", Customer."No.");
            ChangeRequest.SetRange(No, CRCode);
            if ChangeRequest.FindFirst() then begin
                if (ImageType = 'profile_picture') then begin
                    for i := ChangeRequest."Picture(New Value)".Count downto 1 do begin
                        MediaId := ChangeRequest."Picture(New Value)".Item(i);
                        ChangeRequest."Picture(New Value)".Remove(MediaId);
                    end;

                    TempBlob.CreateOutStream(OutStr);
                    Base64Convert.FromBase64(Base64Text, OutStr);

                    TempBlob.CreateInStream(InStr);
                    ChangeRequest."Picture(New Value)".ImportStream(InStr, FileName, MimeType);
                    // ChangeRequest."Piccture File Name" := FileName;
                    // ChangeRequest."Piccture Mime Type" := MimeType;
                end;

                if (ImageType = 'signature') then begin
                    for i := ChangeRequest."signinature(New Value)".Count downto 1 do begin
                        MediaId := ChangeRequest."signinature(New Value)".Item(i);
                        ChangeRequest."signinature(New Value)".Remove(MediaId);
                    end;

                    TempBlob.CreateOutStream(OutStr);
                    Base64Convert.FromBase64(Base64Text, OutStr);

                    TempBlob.CreateInStream(InStr);
                    ChangeRequest."signinature(New Value)".ImportStream(InStr, FileName, MimeType);
                    // ChangeRequest."Signature File Name" := FileName;
                    // ChangeRequest."Signature Mime Type" := MimeType;
                end;

                exit(ChangeRequest.Modify(true));
            end;
        end;
        exit(false);
    end;

    procedure ExportImageToBase64(memberNumber: Code[50]; var Base64Text: Text; var FileName: Text; var MimeType: Text; ImageType: Text): Boolean
    var
        CustomerTable: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        TenantMedia: Record "Tenant Media";
        MediaId: Guid;
    begin
        Base64Text := '';
        FileName := '';
        MimeType := '';

        if not CustomerTable.Get(memberNumber) then
            exit(false);

        if (ImageType = 'profile_picture') then begin
            if CustomerTable.Piccture.Count = 0 then
                exit(false);

            MediaId := CustomerTable.Piccture.Item(CustomerTable.Piccture.Count);
        end;
        if (ImageType = 'signature') then begin
            if CustomerTable.Siggnature.Count = 0 then
                exit(false);

            MediaId := CustomerTable.Siggnature.Item(CustomerTable.Siggnature.Count);
        end;
        if not TenantMedia.Get(MediaId) then
            exit(false);

        TenantMedia.CalcFields(Content);
        if not TenantMedia.Content.HasValue then
            exit(false);

        TenantMedia.Content.CreateInStream(InStr);
        Base64Text := Base64Convert.ToBase64(InStr);
        FileName := TenantMedia."File Name";
        MimeType := TenantMedia."Mime Type";

        exit(true);
    end;


    var
        myInt: Integer;
}