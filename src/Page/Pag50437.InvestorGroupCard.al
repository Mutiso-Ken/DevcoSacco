#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50437 "Investor Group Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Investor Group Members";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID/Passport No"; Rec."ID/Passport No")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field("Postal Code"; Rec."Postal Code")
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
                field(County; Rec.County)
                {
                    ApplicationArea = Basic;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    ApplicationArea = Basic;
                }
                field("Home Phone No."; Rec."Home Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                }
                field("Pin Number"; Rec."Pin Number")
                {
                    ApplicationArea = Basic;
                }
                field(Photo; Rec.Photo)
                {
                    ApplicationArea = Basic;
                }
                field(Sgnature; Rec.Sgnature)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

