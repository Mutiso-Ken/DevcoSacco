#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50895 "MC Group Holders"
{
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Customer;
    SourceTableView = where("Customer Posting Group" = const('MICRO'),
                            "Group Account" = filter(true));

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
                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                // field("Group Account No";"Group Account No")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Group Account"; Rec."Group Account")
                {
                    ApplicationArea = Basic;
                }
                field("Micro Group Code"; Rec."Micro Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Certificate No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Debtors Type"; Rec."Debtors Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Officer Name"; Rec."Loan Officer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Personal Details")
            {
            }
            group(Communication)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1000000004)
            {
                action("Group Members")
                {
                    ApplicationArea = Basic;
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "MC Individual Sub-List";
                    // RunPageLink = "Group Account No"=field("No.");
                }
                action("Account Signatories ")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories';
                    Image = Group;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Member Account Signatory list";
                    RunPageLink = "Account No" = field("No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
        StatusPermissions.RESET;
        StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
        StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::Edit);
        IF StatusPermissions.FIND('-') = FALSE THEN
        ERROR('You do not have permissions to edit account information.');
        */

    end;

    var
        StatusPermissions: Record "Status Change Permision";
}

