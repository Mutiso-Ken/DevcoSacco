pageextension 50880 "GeneralLedgerSetUpExt" extends "General Ledger Setup"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            group(MOBILESETUPS)
            {
                field("Mobile Transfer Charge"; Rec."Mobile Transfer Charge")
                {
                    ApplicationArea = Basic;
                }
                field("CloudPESA Comm Acc"; Rec."CloudPESA Comm Acc")
                {
                    ApplicationArea = Basic;
                }
                field("CloudPESA Charge"; Rec."CloudPESA Charge")
                {
                    ApplicationArea = Basic;
                }
                field("Agency Application Nos"; Rec."Agency Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Agency Charges Acc"; Rec."Agency Charges Acc")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Recon Acc"; Rec."MPESA Recon Acc")
                {
                    ApplicationArea = Basic;
                }
                field("M-banking Charges Acc"; Rec."M-banking Charges Acc")
                {
                    ApplicationArea = Basic;
                }
                field(PaybillAcc; Rec.PaybillAcc)
                {
                    ApplicationArea = Basic;
                }
                field(AirTimeSettlAcc; Rec.AirTimeSettlAcc)
                {
                    ApplicationArea = Basic;
                }
                field("Mobile Charge"; Rec."Mobile Charge")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
