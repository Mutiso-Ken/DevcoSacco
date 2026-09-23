#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50451 "Investor Receipt Card"
{
    PageType = Card;
    SourceTable = "Receipt Header";
    SourceTableView = where("Receipt Category" = const(Investor),
                            Posted = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Investor No."; Rec."Investor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Name"; Rec."Investor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Code"; Rec."Interest Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Balance"; Rec."Bank Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Amount Received"; Rec."Amount Received")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Amount Received(LCY)"; Rec."Amount Received(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount(LCY)"; Rec."Total Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Net Amount"; Rec."Investor Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Net Amount(LCY)"; Rec."Investor Net Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control22; "Investor Receipt Lines")
            {
                SubPageLink = "Document No" = field("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Post Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Post Receipt';
                Image = PostPrint;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    Rec.CalcFields("Investor Net Amount", "Investor Net Amount(LCY)", "Total Amount");
                    if Rec."Total Amount" <> Rec."Amount Received" then
                        Error('The amount received entered must be equal to the total amount in lines');
                    ok := Confirm('Post Receipt No:' + Format(Rec."No.") + '. The Investor account will be credited with KES:' + Format(Rec."Investor Net Amount(LCY)") + ' Continue?');
                    if ok then begin
                        DocNo := Rec."No.";
                        if FundsUser.Get(UserId) then begin
                            FundsUser.TestField(FundsUser."Receipt Journal Template");
                            FundsUser.TestField(FundsUser."Receipt Journal Batch");
                            JTemplate := FundsUser."Receipt Journal Template";
                            JBatch := FundsUser."Receipt Journal Batch";
                            PostedEntry := FundsManager.PostInvestorReceipt(Rec, JTemplate, JBatch);

                            /*IF PostedEntry THEN BEGIN
                              ReceiptHeader.RESET;
                              ReceiptHeader.SETRANGE(ReceiptHeader."No.",DocNo);
                              IF ReceiptHeader.FINDFIRST THEN BEGIN
                                REPORT.RUNMODAL(REPORT::"Investor Receipt",TRUE,FALSE,ReceiptHeader);
                              END;
                            END;*/
                        end else begin
                            Error('User Account Not Setup');
                        end;
                    end;

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    ReceiptHeader.Reset;
                    ReceiptHeader.SetRange(ReceiptHeader."No.", DocNo);
                    if ReceiptHeader.FindFirst then begin
                        Error('DEV');
                        // Report.RunModal(Report::"Investor Receipt",true,false,ReceiptHeader);
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Receipt Category" := Rec."receipt category"::Investor;
    end;

    var
        FundsManager: Codeunit "Funds Management";
        JTemplate: Code[20];
        JBatch: Code[20];
        FundsUser: Record "Funds User Setup";
        ok: Boolean;
        ReceiptHeader: Record "Receipt Header";
        PostedEntry: Boolean;
        DocNo: Code[20];
}

