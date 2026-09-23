#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50592 "Cheque Book Application List F"
{
    ApplicationArea = Basic;
    CardPageID = postedchequebookcard;
    Editable = false;
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Cheque Book Application";
    SourceTableView = where("Cheque Book charges Posted" = const(true),
                            "Cheque Register Generated" = const(true));
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
                    style = StrongAccent;
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
                    visible = false;
                }
                field("Cheque Register Generated"; Rec."Cheque Register Generated")
                {

                }
                field("Cheque Book charges Posted"; Rec."Cheque Book charges Posted")
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

