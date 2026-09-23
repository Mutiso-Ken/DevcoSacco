#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50530 "Cheque Book Application List"
{
    ApplicationArea = Basic;
    CardPageID = "Cheque Application";
    Editable = false;
    PageType = List;
    SourceTable = "Cheque Book Application";
    SourceTableView = where("Cheque Book charges Posted" = filter(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Cheque Account No."; Rec."Cheque Account No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Staff No."; Rec."Staff No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Register Generated"; Rec."Cheque Register Generated")
                {

                }
                field("Cheque Book Type"; Rec."Cheque Book Type")
                {

                }
                field("Requested By"; Rec."Requested By")
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

