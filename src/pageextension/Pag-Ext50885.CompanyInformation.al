pageextension 50885 "Company Information" extends "Company Information"
{
    layout
    {
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        addafter(Address)
        {
            field("Company P.I.N"; Rec."Company P.I.N")
            {
                ApplicationArea = all;
                Caption = 'Company Information';
            }
        }
    }
}

