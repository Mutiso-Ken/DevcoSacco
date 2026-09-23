
#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50485 "Treasury Denominations"
{
    Editable = true;
    PageType = ListPart;
    SourceTable = "Treasury Coinage";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = Basic;
                    Enabled = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        /*Overdue := Overdue::" ";
        IF FormatField(Rec) THEN
          Overdue := Overdue::Yes;*/

    end;


    procedure GetVariables(var LoanNo: Code[20]; var LoanProductType: Code[20])
    begin
        /*LoanNo:="Loan  No.";
        LoanProductType:="Loan Product Type"; */

    end;
}

