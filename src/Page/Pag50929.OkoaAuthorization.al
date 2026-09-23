#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50929 "Okoa Authorization"
{
    PageType = Card;
    SourceTable = "Okoa Authorisationx";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Over Draft No"; Rec."Over Draft No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa No.';
                }
                field("Over Draft Payoff"; Rec."Over Draft Payoff")
                {
                    ApplicationArea = Basic;
                    Caption = ' OKoa Payoff';
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
                }
                field("Captured by"; Rec."Captured by")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Current Account No"; Rec."Current Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Overdraft"; Rec."Outstanding Overdraft")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Okoa';
                }
                field("Amount applied"; Rec."Amount applied")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter"; Rec."Date Filter")
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
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Overdraft Status"; Rec."Overdraft Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Okoa Status';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Authorisation Requirement"; Rec."Authorisation Requirement")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor Checked"; Rec."Supervisor Checked")
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Entry NO"; Rec."Entry NO")
                {
                    ApplicationArea = Basic;
                }
                field("Authoriser Id"; Rec."Authoriser Id")
                {
                    ApplicationArea = Basic;
                }
                field(Recovered; Rec.Recovered)
                {
                    ApplicationArea = Basic;
                }
                field("Recovered Amount"; Rec."Recovered Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

