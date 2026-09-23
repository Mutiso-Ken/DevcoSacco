pageextension 50884 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Blanket Order Nos.")
        {
            field("BOSA Transfer Nos"; Rec."BOSA Transfer Nos")
            {
                ApplicationArea = all;
            }
            field("Collateral Register No"; Rec."Collateral Register No")
            {
                ApplicationArea = all;
            }
            field("Custodian No."; Rec."Custodian No.")
            {
                ApplicationArea = all;
            }
            field("Safe Custody Package Nos"; Rec."Safe Custody Package Nos")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}