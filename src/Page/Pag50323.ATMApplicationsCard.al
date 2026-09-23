#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50323 "ATM Applications Card"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = Card;
    SourceTable = "ATM Card Applications";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Address 1"; Rec."Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = Basic;
                }
                field("Card Type"; Rec."Card Type")
                {
                    ApplicationArea = Basic;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Card No"; Rec."Card No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin


                        if StrLen(Rec."Card No") <> 16 then
                            Error('ATM No. cannot contain More or less than 16 Characters.');
                    end;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ApplicationArea = Basic;
                }
                field(Limit; Rec.Limit)
                {
                    ApplicationArea = Basic;
                }
                field("Terms Read and Understood"; Rec."Terms Read and Understood")
                {
                    ApplicationArea = Basic;
                }
                field("Card Issued"; Rec."Card Issued")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Form No"; Rec."Form No")
                {
                    ApplicationArea = Basic;
                }
                field("Sent To External File"; Rec."Sent To External File")
                {
                    ApplicationArea = Basic;
                }
                field("Card Status"; Rec."Card Status")
                {
                    ApplicationArea = Basic;
                }
                field("Date Activated"; Rec."Date Activated")
                {
                    ApplicationArea = Basic;
                }
                field("Date Frozen"; Rec."Date Frozen")
                {
                    ApplicationArea = Basic;
                }
                field("Replacement For Card No"; Rec."Replacement For Card No")
                {
                    ApplicationArea = Basic;
                }
                field("Has Other Accounts"; Rec."Has Other Accounts")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Collected; Rec.Collected)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Approved"; Rec."Application Approved")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Collected"; Rec."Date Collected")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Card Issued By"; Rec."Card Issued By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("ATM Expiry Date"; Rec."ATM Expiry Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Card Issued to Customer"; Rec."Card Issued to Customer")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Issued to"; Rec."Issued to")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pesa Point ATM Card")
            {
                Caption = 'Pesa Point ATM Card';
                action("Approve Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve Application';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to approve this application?', true) = true then begin
                            if Rec."Application Approved" = true then
                                Error('This application is already approved');
                            //TESTFIELD("No.");
                            Rec.TestField("Account Name");
                            //TESTFIELD("Customer ID");
                            //TESTFIELD("Request Type C");
                            //TESTFIELD("Phone No.");
                            //TESTFIELD("Card Type");

                            Rec."Approval Date" := Today;
                            Rec."Application Approved" := true;
                            Rec.Modify;
                        end else
                            Error('Operation cancelled');
                    end;
                }
                action("Received from bank")
                {
                    ApplicationArea = Basic;
                    Caption = 'Received from bank';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        if Rec.Collected = true then
                            Error('The ATM Card has already been collected');

                        if Confirm('Are you sure you have received this ATM card from Bank?', true) = true then begin

                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
                            GenJournalLine.SetRange("Journal Batch Name", 'Ftrans');
                            GenJournalLine.DeleteAll;



                            //generalSetup.GET();

                            generalSetup.Get;

                            LineNo := LineNo + 10000;


                            //Vendor Entry
                            //IF AccountTypes.FIND('-') THEN  BEGIN
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'PURCHASES';
                            GenJournalLine."Journal Batch Name" := 'Ftrans';
                            GenJournalLine."Document No." := 'ATM charge';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                            GenJournalLine."Account No." := Rec."Account No";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := Today;
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Description := 'ATM charge-Replacement'
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Description := 'ATM charge-New'
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Description := 'ATM charge-Renewal';

                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Amount := generalSetup."ATM Card Fee-Replacement"
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Amount := generalSetup."ATM Card Fee-New Coop"
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Amount := generalSetup."ATM Card Fee-Renewal";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"Bank Account";
                            //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee Co-op Bank";
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';
                            //END;
                            /*
                            GenJournalLine.VALIDATE(GenJournalLine.Amount);
                            GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code":='FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code":='Nairobi';
                            */

                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;






                            //Bank Account Entry

                            LineNo := LineNo + 10000;

                            //IF AccountTypes.FIND('-') THEN  BEGIN
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'PURCHASES';
                            GenJournalLine."Journal Batch Name" := 'Ftrans';
                            GenJournalLine."Document No." := 'ATM charge';
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                            GenJournalLine."Account No." := generalSetup."ATM Card Fee Co-op Bank";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := Today;
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Description := 'ATM charge-Replacement'
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Description := 'ATM charge-New'
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Description := 'ATM charge-Renewal';
                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Amount := -generalSetup."ATM Card Co-op Bank Amount"
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Amount := -generalSetup."ATM Card Co-op Bank Amount"
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Amount := -generalSetup."ATM Card Co-op Bank Amount";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                            //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee-Account";
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';


                            //END;


                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';


                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;




                            //Commission Entry

                            LineNo := LineNo + 10000;

                            //IF AccountTypes.FIND('-') THEN  BEGIN
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'PURCHASES';
                            GenJournalLine."Journal Batch Name" := 'Ftrans';
                            GenJournalLine."Document No." := 'ATM charge';
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := generalSetup."ATM Card Fee-Account";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := Today;
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Description := 'ATM charge-Commission'
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Description := 'ATM charge-Commission'
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Description := 'ATM charge-Commission';
                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            if Rec."Request Type" = Rec."request type"::Replacement then
                                GenJournalLine.Amount := -generalSetup."ATM Card Fee-New Sacco"
                            else
                                if Rec."Request Type" = Rec."request type"::New then
                                    GenJournalLine.Amount := -generalSetup."ATM Card Fee-New Sacco"
                                else
                                    if Rec."Request Type" = Rec."request type"::"Re-Pin" then
                                        GenJournalLine.Amount := -generalSetup."ATM Card Fee-New Sacco";
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                            //GenJournalLine."Bal. Account No.":=generalSetup."ATM Card Fee-Account";
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';


                            //END;


                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';


                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;


                            //Excise Duty

                            LineNo := LineNo + 10000;

                            //IF AccountTypes.FIND('-') THEN  BEGIN
                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := 'PURCHASES';
                            GenJournalLine."Journal Batch Name" := 'Ftrans';
                            GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                            GenJournalLine."Account No." := generalSetup."Excise Duty Account";
                            GenJournalLine."Document No." := 'ATM charge';
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := Today;
                            GenJournalLine.Amount := -(generalSetup."ATM Card Fee-New Sacco" * generalSetup."Excise Duty(%)") / 100;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                            //GenJournalLine."Bal. Account No.":=generalSetup."Excise Duty Account";
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';
                            //END;


                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                            GenJournalLine."Shortcut Dimension 2 Code" := 'Nairobi';


                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;



                            //Post New
                            GenJournalLine.Reset;
                            GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
                            GenJournalLine.SetRange("Journal Batch Name", 'Ftrans');
                            if GenJournalLine.Find('-') then begin

                                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);

                                //window.OPEN('Posting:,#1######################');
                            end;
                            //Post New
                            Rec.Collected := true;
                            Rec."Date Collected" := Today;
                            Rec."Card Issued By" := UserId;
                            Rec.Modify;

                        end;



                        Vend.Get(Rec."Account No");
                        Vend."ATM No." := Rec."Card No";
                        Vend."Atm card ready" := true;
                        Vend.Modify;

                        generalSetup.Get();
                        Rec."ATM Expiry Date" := CalcDate(generalSetup."ATM Expiry Duration", Today);


                        /*GenJournalLine.RESET;
                        GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                        GenJournalLine.SETRANGE("Journal Batch Name",'Ftrans');
                        GenJournalLine.DELETEALL;*/

                    end;
                }
                action("Disable ATM Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disable ATM Card';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Vend.Get(Rec."Account No");
                        if Confirm('Are you sure you want to disable this account from ATM transactions  ?', true) = true then
                            Vend."ATM No." := '';
                        Vend."Disabled By" := UserId;
                        Vend."Last Date Modified" := Today;
                        //Vend.Blocked:=Vend.Blocked::Payment;
                        //Vend."Account Frozen":=TRUE;
                        Vend.Modify;
                    end;
                }
                action("Enable ATM Card")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Vend.Get(Rec."Account No");
                        if Confirm('Are you sure you want to Enable ATM no. for this account  ?', true) = true then
                            Vend."ATM No." := Rec."Card No";
                        //Vend.Blocked:=Vend.Blocked::Payment;
                        //Vend."Account Frozen":=TRUE;
                        Vend.Modify;
                    end;
                }
                action("Confirm Card Collection")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Rec."Card Issued to Customer" = Rec."card issued to customer"::"Card Issued to" then begin
                            Rec.TestField("Issued to");
                        end;

                        if Confirm('Are you sure you want to issue this Card?', true) = true then
                            Rec.Collected := true;
                        Rec.Modify;

                        Vend.Get(Rec."Account No");
                        Vend."ATM No." := Rec."Card No";
                    end;
                }
            }
        }
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        AccountHolders: Record Vendor;
        window: Dialog;
        // PostingCode: Codeunit "Gen. Jnl.-Post Line";
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        CustomizedCalEntry: Record "Office/Group";
        PictureExists: Boolean;
        AccountTypes: Record "Account Types-Saving Products";
        //G//LPosting: Codeunit "Gen. Jnl.-Post Line";
        StatusPermissions: Record "Status Change Permision";
        Charges: Record Charges;
        ForfeitInterest: Boolean;
        InterestBuffer: Record "Interest Buffer";
        FDType: Record "Fixed Deposit Type";
        Vend: Record Vendor;
        Cust: Record Customer;
        UsersID: Record User;
        Bal: Decimal;
        AtmTrans: Decimal;
        UnCheques: Decimal;
        AvBal: Decimal;
        Minbal: Decimal;
        generalSetup: Record "Sacco General Set-Up";
}

