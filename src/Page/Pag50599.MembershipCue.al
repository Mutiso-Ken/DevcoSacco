#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50599 "Membership Cue"
{
    PageType = CardPart;
    SourceTable = "Membership Cue";

    layout
    {
        area(content)
        {
            cuegroup(Members)
            {
                field("Active Members"; Rec."Active Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Junior Members"; Rec."Junior Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Non-Active Members"; Rec."Non-Active Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                    Style = Attention;
                    StyleExpr = true;
                }
                field("Dormant Members"; Rec."Dormant Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Withdrawn Members"; Rec."Withdrawn Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Deceased Members"; Rec."Deceased Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
            }
            cuegroup("Members Per Branch")
            {
                field("Maua Members"; Rec."Maua Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Mutuati Members"; Rec."Mutuati Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Muriri Members"; Rec."Muriri Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("KK Members"; Rec."KK Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Mikinduri Members"; Rec."Mikinduri Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
            }
            cuegroup("BOSA Loans")
            {
                Caption = 'BOSA Loans';
                field(Development; Rec.Development)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Executive; Rec.Executive)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Mfadhili; Rec.Mfadhili)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Devt Savings"; Rec."Devt Savings")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Mkombozi; Rec.Mkombozi)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Pepea; Rec.Pepea)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(College; Rec.College)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("School Fees"; Rec."School Fees")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Digital; Rec.Digital)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Housing; Rec.Housing)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Asset; Rec.Asset)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
            }
            cuegroup("FOSA Loans")
            {
                field("Normal Adv Loan"; Rec."Normal Adv Loan")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Xmas Adv"; Rec."Xmas Adv")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(Crop; Rec.Crop)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(MILK; Rec.MILK)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
            }
            cuegroup(CEEP)
            {
                field("Ceep Groups"; Rec."Ceep Groups")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Ceep Members"; Rec."Ceep Members")
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field("Ceep New"; Rec."Ceep New")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ceep Loan New';
                    Image = "None";
                }
            }
            cuegroup("Staff Loans")
            {
                field(StaffCar; Rec.StaffCar)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
                field(StaffHousing; Rec.StaffHousing)
                {
                    ApplicationArea = Basic;
                    Image = "None";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get(UserId) then begin
            Rec.Init;
            Rec."User ID" := UserId;
            Rec.Insert;
        end;
    end;
}

