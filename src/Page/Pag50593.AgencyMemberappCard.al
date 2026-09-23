#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50593 "Agency Member app Card"
{
    PageType = Card;
    SourceTable = "Agency Members App";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    trigger OnValidate()
                    var
                        AgencyMembers: record "Agency Members App";
                    begin
                        //.....................Check If User Is Existing
                        AgencyMembers.Reset();
                        AgencyMembers.SetRange(AgencyMembers."Account No", Rec."Account No");
                        if AgencyMembers.Find('-') then begin
                            Error('The member is already registered !');
                        end;
                        //............................
                        Rec."Created By" := UserId;
                        Rec."Time Applied" := time;
                        Rec."Date Applied" := Today;
                    end;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("Date Applied"; Rec."Date Applied")
                {

                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Applied"; Rec."Time Applied")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field(SentToServer; Rec.SentToServer)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Refresh)
            {

                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Refresh;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
            action(sendapp)
            {

                Caption = 'Send Application';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }
}

