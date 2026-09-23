#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50906 "MF Business Loans targets"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Officer Loans Targets";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Target Type"; Rec."Target Type")
                {
                    ApplicationArea = Basic;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic;
                }
                field("Previous Year actual"; Rec."Previous Year actual")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(January; Rec.January)
                {
                    ApplicationArea = Basic;
                }
                field(February; Rec.February)
                {
                    ApplicationArea = Basic;
                }
                field(March; Rec.March)
                {
                    ApplicationArea = Basic;
                }
                field(April; Rec.April)
                {
                    ApplicationArea = Basic;
                }
                field(May; Rec.May)
                {
                    ApplicationArea = Basic;
                }
                field(June; Rec.June)
                {
                    ApplicationArea = Basic;
                }
                field(July; Rec.July)
                {
                    ApplicationArea = Basic;
                }
                field(August; Rec.August)
                {
                    ApplicationArea = Basic;
                }
                field(September; Rec.September)
                {
                    ApplicationArea = Basic;
                }
                field(October; Rec.October)
                {
                    ApplicationArea = Basic;
                }
                field(November; Rec.November)
                {
                    ApplicationArea = Basic;
                }
                field(December; Rec.December)
                {
                    ApplicationArea = Basic;
                }
                field(Totals; Rec.Totals)
                {
                    ApplicationArea = Basic;
                }
                field("Targets No. of Loans"; Rec."Targets No. of Loans")
                {
                    ApplicationArea = Basic;
                }
                field("Actuals No. of Loans"; Rec."Actuals No. of Loans")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                }
                field("Date Modified"; Rec."Date Modified")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1000000024)
            {
                action("Import Business Loans targets")
                {
                    ApplicationArea = Basic;
                    Image = XMLFile;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = XMLport "Import BOSA Members";

                    trigger OnAction()
                    begin
                        ///fdfdfdfsfdfdd
                    end;
                }
            }
        }
    }
}

