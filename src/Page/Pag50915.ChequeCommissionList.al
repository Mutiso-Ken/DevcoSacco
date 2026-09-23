#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50915 "Cheque Commission List"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Cheque Commissions";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount(Local)"; Rec."Minimum Amount(Local)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Min Amount(Local)';
                }
                field("Maximum Amount(Local)"; Rec."Maximum Amount(Local)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Max Amount(Local)';
                }
                field("Charge(Local)"; Rec."Charge(Local)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Charge(Local)';
                }
                field("Use Percentage(Local)"; Rec."Use Percentage(Local)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Use Percentage(Local)';
                }
                field("% Amount(Local)"; Rec."% Amount(Local)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Percentage Amount';
                    ToolTip = 'perc';
                }
                label("|")
                {
                    ApplicationArea = Basic;
                    Caption = '|';
                    //  NotBlank = false;
                }
                field("Minimum Amount(Upcountry)"; Rec."Minimum Amount(Upcountry)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Min Amount(Upcountry)';
                }
                field("Maximum Amount(Upcountry)"; Rec."Maximum Amount(Upcountry)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Max Amount(Upcountry)';
                }
                field("Charge(Upcountry)"; Rec."Charge(Upcountry)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Charge(Upcountry)';
                }
                field("Use Percentage(Upcountry)"; Rec."Use Percentage(Upcountry)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Use Percentage(Upcountry)';
                }
                field("% Amount(Upcountry)"; Rec."% Amount(Upcountry)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Percentage Amount';
                }
                label("||")
                {
                    ApplicationArea = Basic;
                    Caption = '||';
                    // NotBlank = false;
                }
                field("Minimum Amount(Inhouse)"; Rec."Minimum Amount(Inhouse)")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Amount(Inhouse)"; Rec."Maximum Amount(Inhouse)")
                {
                    ApplicationArea = Basic;
                }
                field("Charge(Inhousel)"; Rec."Charge(Inhousel)")
                {
                    ApplicationArea = Basic;
                }
                field("Use Percentage(Inhouse)"; Rec."Use Percentage(Inhouse)")
                {
                    ApplicationArea = Basic;
                }
                field("% Amount (Inhouse)"; Rec."% Amount (Inhouse)")
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

