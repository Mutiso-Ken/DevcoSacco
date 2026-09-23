report 50022 LoanApplicationForm
{
    RDLCLayout = './Layouts/PortalLoanApplicationForm.rdlc';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            column(Loan__No_; LoansRegister."Loan  No.") { }
            column(Loan_Product_Type_Name; "Loan Product Type Name") { }
            column(Installments; Installments) { }
            column(Requested_Amount; "Requested Amount") { }
            column(Repayment_Start_Date; "Repayment Start Date") { }
            column(Main_Sector; "Main Sector") { }
            column(Sub_Sector; "Sub-Sector") { }
            column(Specific_Sector; "Specific Sector") { }
            column(CompanyInfoName; CompanyInfor.Name) { }
            column(CompanyInfoAdd; CompanyInfor.Address) { }
            column(CompanyInfoPhoneNo; CompanyInfor."Phone No.") { }
            column(CompanyInfoPicture; CompanyInfor.Picture) { }
            column(isMember; isMember) { }
            column(SignatureBase64; SignatureBase64) { }
            column(mimeType; mimeType) { }
            column(MainSectorDesc; MainSectorDesc) { }
            column(Sub_SectorDesc; Sub_SectorDesc) { }
            column(currentDate; currentDate) { }
            column(Application_Date; "Application Date") { }
            column(showBankDetails; showBankDetails) { }
            column(showMpesaDetails; showMpesaDetails) { }
            column(Bank_Account_No; "Bank Account No") { }
            column(Bank_Account_Name; "Bank Account Name") { }
            column(Bank_Name; "Bank Name") { }
            column(Bank_Branch; "Bank Branch") { }
            column(Mpesa_Number; "Mpesa Number") { }
            column(Is_Loan_Top_Up; "Is Loan Top Up") { }
            column(Topup_Loan_No; "Topup Loan No") { }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Client Code");
                DataItemLinkReference = LoansRegister;
                DataItemTableView = sorting("No.");
                column(Client_Name; Customer.Name) { }
                column(Client_No; Customer."No.") { }
                column(KRA_Pin; Customer.Pin) { }
                column(ID_No_; Customer."ID No.") { }
                column(Phone_No_; Customer."Phone No.") { }
                column(Mobile_Phone_No; Customer."Mobile Phone No") { }
                column(E_Mail__Personal_; Customer."E-Mail (Personal)") { }
                column(Employer_Name; Customer."Employer Name") { }
                column(EmployerName; EmployerName) { }
                dataitem("Sacco Insiders"; "Sacco Insiders")
                {
                    DataItemLink = "MemberNo" = field("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = sorting("MemberNo");
                    column(MemberNo; "Sacco Insiders".MemberNo) { }
                    column(Position_in_society; "Sacco Insiders"."Position in society") { }
                    trigger OnAfterGetRecord()
                    begin
                    end;
                }
                trigger OnAfterGetRecord();
                var
                    TenantMedia: Record "Tenant Media";
                    MediaId: Guid;
                    InStr: InStream;
                begin
                    Clear(SignatureBase64);
                    Clear(mimeType);
                    if Customer.Siggnature.Count > 0 then begin
                        MediaId := Customer.Siggnature.Item(1);
                        if TenantMedia.Get(MediaId) then begin
                            TenantMedia.CalcFields(Content);
                            if TenantMedia.Content.HasValue then begin
                                TenantMedia.Content.CreateInStream(InStr);
                                SignatureBase64 := Base64Convert.ToBase64(InStr);
                                mimeType := TenantMedia."Mime Type";
                            end;
                        end;
                    end;

                    SaccoEmployers.Reset();
                    SaccoEmployers.SetRange(Code, Customer."Employer Code");
                    if SaccoEmployers.Find('-') then
                        EmployerName := SaccoEmployers.Description;
                end;
            }
            dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                DataItemLink = "Loan No" = field("Loan  No.");
                DataItemLinkReference = LoansRegister;
                DataItemTableView = sorting("Loan No");
                column(Guarantor_Member_No; "Loans Guarantee Details"."Member No") { }
                column(Guarantor_ID_No_; "Loans Guarantee Details"."ID No.") { }
                column(Guarantor_Name; "Loans Guarantee Details".Name) { }
                column(Guarantor_Amount_Guaranteed; "Loans Guarantee Details"."Amont Guaranteed") { }
            }
            trigger OnAfterGetRecord()
            begin
                memberNumber := LoansRegister."Client Code";
                MainSector.Reset();
                MainSector.SetRange(MainSector.Code, "Main Sector");
                if MainSector.FindSet() then begin
                    MainSectorDesc := MainSector.Description;
                end;
                Sub_Sector.Reset();
                Sub_Sector.SetRange(Sub_Sector.Code, "Main Sector");
                if Sub_Sector.FindSet() then begin
                    Sub_SectorDesc := Sub_Sector.Description;
                end;
                SPecific_Sector.Reset();
                SPecific_Sector.SetRange(SPecific_Sector.Code, "Main Sector");
                if SPecific_Sector.FindSet() then begin
                    SPecific_SectorDesc := SPecific_Sector.Description;
                end;

                if LoansRegister."Mode of Disbursement" = LoansRegister."Mode of Disbursement"::BANK then
                    showBankDetails := true;
                if LoansRegister."Mode of Disbursement" = LoansRegister."Mode of Disbursement"::MPESA then
                    showMpesaDetails := true;
            end;
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfor.Get;
        CompanyInfor.CalcFields(Picture);
        isMember := true;
        currentDate := Today;
    end;

    var
        CompanyInfor: Record "Company Information";
        SaccoEmployers: Record "Sacco Employers";
        isMember: Boolean;
        isBoard: Boolean;
        Base64Convert: Codeunit "Base64 Convert";
        SignatureBase64: Text;
        mimeType: Text;
        loanNumber: Code[50];
        memberNumber: Code[50];
        MainSector: Record "Main Sector";
        Sub_Sector: Record "Sub-Sector";
        SPecific_Sector: Record "Specific-Sector";
        MainSectorDesc: Text;
        Sub_SectorDesc: Text;
        SPecific_SectorDesc: Text;
        currentDate: Date;
        EmployerName: Text;
        showMpesaDetails: Boolean;
        showBankDetails: Boolean;
}