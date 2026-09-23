#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50359 "Change MPESA PIN No"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Change MPESA PIN No";
    SourceTableView = where(Status = const(Open));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Application No"; Rec."MPESA Application No")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer ID No"; Rec."Customer ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Mobile No"; Rec."MPESA Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("MPESA Corporate No"; Rec."MPESA Corporate No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Date Sent"; Rec."Date Sent")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Sent"; Rec."Time Sent")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sent By"; Rec."Sent By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Change Mpesa pin No")
            {
                Caption = 'Change Mpesa pin No';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin


                        if Confirm('Are you sure you would like to send a New PIN No to the customer?') = true then begin
                            Rec.TestField("MPESA Application No");
                            Rec.TestField(Comments);

                            MPESAApp.Reset;
                            MPESAApp.SetRange(MPESAApp.No, Rec."MPESA Application No");
                            if MPESAApp.Find('-') then begin

                                MPESAApp."Sent To Server" := MPESAApp."sent to server"::No;
                                MPESAApp.Modify;

                            end
                            else begin
                                Error('MPESA Application No not found');
                                exit;
                            end;

                            Rec.Status := Rec.Status::Pending;
                            Rec."Date Sent" := Today;
                            Rec."Time Sent" := Time;
                            Rec."Sent By" := UserId;
                            Rec.Modify;

                            Message('New PIN No sent to Customer ' + Rec."Customer Name" + '. The Customer will receive a confirmation SMS shortly.');

                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you would like to reject the PIN change request?') = true then begin
                            Rec.TestField("MPESA Application No");
                            Rec.TestField("Rejection Reason");

                            Rec.Status := Rec.Status::Approved;
                            Rec."Date Rejected" := Today;
                            Rec."Time Rejected" := Time;
                            Rec."Rejected By" := UserId;
                            Rec.Modify;

                            Message('PIN change request has been rejected.');

                        end;
                    end;
                }
            }
        }
    }

    var
        MPESAApp: Record "MPESA Applications";
}

