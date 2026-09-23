
#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50106 "Sasra Loan Classification Cue"
{

    PageType = CardPart;
    SourceTable = SasraLoanClassificationCues;
    UsageCategory = Lists;
    ApplicationArea = Basic;

    layout
    {
        area(content)
        {
            cuegroup(Group1)
            {
                Caption = 'BOSA LOANS ';
                field("Watchful Loans"; Rec."Watchful Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    // DrillDownPageId = "Loan List";
                }

                field("Substandard Loans"; Rec."Substandard Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    // DrillDownPageId = "Loans Posted List";
                }

                field("Doubtful Loans"; Rec."Doubtful Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    // DrillDownPageId = "Loan List";
                }

            }

            cuegroup(Group2)
            {
                Caption = 'FOSA LOANS ';
                field("Watchful FOSA Loans"; Rec."Watchful FOSA Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Substandard FOSA Loans"; Rec."Substandard FOSA Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Doubtful FOSA Loans"; Rec."Doubtful FOSA Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }

            }


            cuegroup(Group3)
            {
                Caption = 'MICRO LOANS ';
                field("Watchful MICRO loans"; Rec."Watchful MICRO Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Substandard MICRO Loans"; Rec."Substandard MICRO Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Doubtful MICRO Loans"; Rec."Doubtful MICRO Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                }

            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    var
    begin
        if not Rec.Get(Rec."Primary Key") then begin
            Rec.Init;
            Rec."Primary Key" := Rec."Primary Key";
            Rec.Insert;
        end;

    end;

}

