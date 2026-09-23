#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50150 "Posted Imprest List"
{
    Caption = 'Staff Travel  List';
    // CardPageID = "Posted Imprest Request";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Imprest Header";
    SourceTableView = where(Posted = filter(true));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Status"; Rec."Surrender Status")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print/Preview")
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImprestHeader.Reset;
                    ImprestHeader.SetRange(ImprestHeader."No.", Rec."No.");
                    Report.Run(50130, true, false, ImprestHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GLEntry.Reset;
        GLEntry.SetRange("Document No.", Rec."No.");
        if not GLEntry.FindFirst then begin
            Rec.Posted := false;
            Rec.Modify;
        end;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE(Cashier,USERID );
    end;

    var
        ImprestHeader: Record "Imprest Header";
        GLEntry: Record "G/L Entry";
}

