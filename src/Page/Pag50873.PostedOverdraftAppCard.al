#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50873 "Posted Over draft App Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Over Draft Register";
    SourceTableView = where(Posted = const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("Over Draft No"; Rec."Over Draft No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Over Draft Payoff"; Rec."Over Draft Payoff")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Application date"; Rec."Application date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Captured by"; Rec."Captured by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Member No"; Rec."Current Account No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Overdraft"; Rec."Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                }
                field("Amount applied"; Rec."Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
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
        area(creation)
        {
            action("Send Approval")
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = SendApprovalRequest;
                Promoted = true;

                trigger OnAction()
                begin
                    if Rec.Posted = true then begin
                        Error(Rec."Over Draft No" + 'Already posted');
                    end else
                        Rec.TestField("Account No");
                    //TESTFIELD("Approved Date") ;
                    Rec.TestField("Current Account No");

                    Rec.Status := Rec.Status::Approved;
                    Message('Approved succesfully');
                    Rec.Modify;
                    if Rec.Status = Rec.Status::Approved then
                        Rec."Approved Date" := Today;
                end;
            }
            action("Reject Request")
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = Reject;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Message('application rejected');
                    Rec.Modify;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = Post;
                Promoted = true;

                trigger OnAction()
                begin
                    if Rec.Posted = true then begin
                        Error(Rec."Over Draft No" + 'Already posted');
                    end else
                        Rec.TestField("Account No");
                    Rec.TestField("Approved Date");
                    Rec.TestField("Current Account No");
                    overdraftno := '';
                    Rec.TestField("Amount applied");
                    //get Current account
                    if vend."Account Type" = 'CURRENT' then
                        vend.Reset;
                    vend.SetRange(vend."No.", Rec."Account No");
                    //vend.SETRANGE()
                    if vend.Find('-') then begin
                        Rec."Approved Amount" := Rec."Amount applied";
                        vend."Overdraft amount" := Rec."Approved Amount";
                        vend.Modify;
                    end;

                    LneNo := LneNo + 10000;

                    OverdraftAut.Init;
                    OverdraftAut."Entry NO" := LneNo;
                    OverdraftAut."Over Draft No" := Rec."Over Draft No";
                    OverdraftAut."Account No" := Rec."Account No";
                    OverdraftAut."Account Name" := Rec."Account Name";
                    //IF "Outstanding Overdraft">0 THEN OverdraftAut."Approved Amount":="Outstanding Overdraft" ELSE
                    OverdraftAut."Approved Amount" := Rec."Approved Amount";
                    OverdraftAut."Approved Date" := Rec."Approved Date";
                    OverdraftAut."Current Account No" := Rec."Current Account No";
                    OverdraftAut."Captured by" := Rec."Captured by";
                    OverdraftAut."ID Number" := Rec."ID Number";
                    OverdraftAut."Over Draft Payoff" := Rec."Over Draft Payoff";
                    OverdraftAut.Status := Rec.Status::Approved;
                    OverdraftAut."Overdraft Status" := Rec."overdraft status"::Active;
                    OverdraftAut."Document Type" := Rec."Document Type";
                    if Rec."Approved Amount" <> 0 then
                        OverdraftAut.Insert(true);
                    //END;

                    //end authorisation

                    Message('Over draft successfully updated');
                    Rec."Posted By" := UserId;
                    Rec.Posted := true;
                    Rec."Time Posted" := Time;
                    Rec."Overdraft Status" := Rec."overdraft status"::Active;
                    vend.Modify;
                    Rec.Modify;
                    //Postoverdraft;
                    //END;
                    //END;
                    //Postoverdraft

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Cust.Reset;
                    Cust.SetRange(Cust."Account No", Rec."Account No");
                    Report.Run(50301, true, false, Cust);
                end;
            }
        }
    }

    var
        Gnljnline: Record "Gen. Journal Line";
        LineN: Integer;
        vend: Record Vendor;
        overdraftno: Code[30];
        Cust: Record "Over Draft Register";
        LineNo: Integer;
        UserSetup: Record "User Setup";
        GenSetup: Record "Sacco General Set-Up";
        DValue: Record "Dimension Value";
        OverdraftBank: Code[10];
        GenJournalLine: Record "Gen. Journal Line";
        OverdraftAut: Record "Over Draft Authorisationx";
        LneNo: Integer;
        OVED: Record "Over Draft Register";

    local procedure Postoverdraft()
    begin

        //Post New
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", 'OVERDRAFT');
        if GenJournalLine.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco21", GenJournalLine);
        end;

        //Post New
        Rec.Posted := true;
        Rec."Overdraft Status" := Rec."overdraft status"::Active;
        Rec."Supervisor Checked" := true;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Modify;

        Message('Overdraft  posted successfully.');
        Cust.Reset;
        Cust.SetRange(Cust."Account No", Rec."Account No");
        if Cust.Find('-') then
            Report.Run(50281, false, true, Cust);


        //END;
    end;
}

