#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50249 "Loan Offset Detail List"
{
    PageType = List;
    SourceTable = "Loan Offset Details";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = Basic;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Principle Top Up"; Rec."Principle Top Up")
                {
                    ApplicationArea = Basic;
                    Editable = OffsetEditable;
                }
                field("Interest Top Up"; Rec."Interest Top Up")
                {
                    ApplicationArea = Basic;
                }
                field(Commision; Rec.Commision)
                {
                    ApplicationArea = Basic;
                    Caption = 'Commission on Offset';
                }
                field("Total Top Up"; Rec."Total Top Up")
                {
                    ApplicationArea = Basic;
                    Editable = OffsetEditable;
                }

            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    var
        LoansRegister: Record "Loans Register";
    begin

    end;

    var
        OffsetEditable: Boolean;
}

