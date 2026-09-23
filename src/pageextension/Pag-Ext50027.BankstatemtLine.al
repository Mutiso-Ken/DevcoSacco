pageextension 50027 BankstatemtLine extends "Bank Account Statement List"
{
    layout
    {

        // Add changes to page layout here
    }

    actions
    {
        addafter(Print)
        {
            action("Print Posted Bank Statement")
            {
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    bankLine: Record "Bank Account Statement";
                begin
                    bankLine.Reset();
                    bankLine.SetRange(bankLine."Statement No.", Rec."Statement No.");
                    bankLine.SetRange(bankLine."Bank Account No.", Rec."Bank Account No.");
                    if bankLine.FindSet() then begin
                        Report.Run(Report::"Bank Income Statement List", true, false, bankLine);
                    end;
                end;

            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}