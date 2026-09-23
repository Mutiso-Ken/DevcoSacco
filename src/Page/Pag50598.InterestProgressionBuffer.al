#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50598 "Interest Progression Buffer"
{
    Editable = false;
    PageType = List;
    SourceTable = "Interest Progression";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Gross Interest"; Rec."Gross Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Witholding Tax"; Rec."Witholding Tax")
                {
                    ApplicationArea = Basic;
                }
                field("Net Interest"; Rec."Net Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Qualifying Savings"; Rec."Qualifying Savings")
                {
                    ApplicationArea = Basic;
                }
                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
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

