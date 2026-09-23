#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50861 "Property Receipt Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Receipt Header";
    SourceTableView = where("Receipt Category" = const(Property),
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
                field("Document Type"; Rec."Document Type")
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
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Balance"; Rec."Bank Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic;
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = Basic;
                }
                field("Property Code"; Rec."Property Code")
                {
                    ApplicationArea = Basic;
                }
                field("Property Name"; Rec."Property Name")
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
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Received"; Rec."Amount Received")
                {
                    ApplicationArea = Basic;
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control23; "Property Receipt Line")
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
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.CalcFields("Total Amount", "Total Amount(LCY)");

                    ok := Confirm('Post Receipt No:' + Format(Rec."No.") + '. The Customer account will be credited with KES:' + Format(Rec."Total Amount(LCY)") + ' Continue?');
                    if ok then begin
                        DocNo := Rec."No.";
                        if FundsUser.Get(UserId) then begin
                            FundsUser.TestField(FundsUser."Receipt Journal Template");
                            FundsUser.TestField(FundsUser."Receipt Journal Batch");
                            JTemplate := FundsUser."Receipt Journal Template";
                            JBatch := FundsUser."Receipt Journal Batch";
                            PostedEntry := FundsManager.PostPropertyReceipt(Rec, JTemplate, JBatch, Rec."Property Code", Rec."No.", '', Rec."Received From", Rec."Total Amount(LCY)");
                            if PostedEntry then begin
                                ReceiptHeader.Reset;
                                ReceiptHeader.SetRange(ReceiptHeader."No.", DocNo);
                                if ReceiptHeader.FindFirst then begin
                                    Error('DEV');
                                    //Report.RunModal(Report::"Investor Receipt",true,false,ReceiptHeader);
                                end;
                            end;
                        end else begin
                            Error('User Account Not Setup');
                        end;
                    end;
                end;
            }
            action("Send For Approval")
            {
                ApplicationArea = Basic;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify;
                    Message('Receipt No:' + Format(Rec."No.") + ' Was Automatically Approved');
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ReceiptHeader.Reset;
                    ReceiptHeader.SetRange(ReceiptHeader."No.", Rec."No.");
                    if ReceiptHeader.FindFirst then begin
                        Error('DEV');
                        // Report.RunModal(Report::"Property Receipt",true,false,ReceiptHeader);
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Receipt Category" := Rec."receipt category"::Property;
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

