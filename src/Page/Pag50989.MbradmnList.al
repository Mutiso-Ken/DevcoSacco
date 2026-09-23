

#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50989 MbradmnList

{
    ApplicationArea = Basic;
    Caption = 'Member List';
    CardPageID = MbradmnList;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = sorting("No.")
                      order(ascending)
                      where("Customer Type" = filter(Member | MicroFinance),
                            "Customer Posting Group" = filter('MEMBER|MICRO'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }

                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }
                field("<Mobile Phone>"; Rec."Mobile Phone No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile Phone';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Branch Code';
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }


                field("FOSA Account"; Rec."FOSA Account")
                {
                    ApplicationArea = Basic;
                }


                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {

                }
                field("Payroll/Staff No"; Rec."Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                }

                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
        }

    }

    actions
    {
        area(creation)
        {
            group(ActionGroup1102755024)
            {
                action("Account Page")
                {
                    // ApplicationArea = Basic;
                    // Image = Planning;
                    // Caption = 'FOSA Account Page';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // RunObject = Page "Account Card";
                    // RunPageLink = "No." = field("FOSA Account");
                }
            }
            group(ActionGroup1102755007)
            {
                action(Statement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Statement';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = "process";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50223, true, false, Cust);
                    end;
                }
                action(GStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Guaranteed';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = "process";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50226, true, false, Cust);
                    end;
                }
                action("Shares Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50302, true, false, Cust);
                    end;
                }
                action("Loans Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50608, true, false, Cust);
                    end;
                }
                action("Shares Certificate")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50303, true, false, Cust);
                    end;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;

    var
        Cust: Record Customer;
        GeneralSetup: Record "Sacco General Set-Up";
        Gnljnline: Record "Gen. Journal Line";
        TotalRecovered: Decimal;
        TotalAvailable: Integer;
        Loans: Record "Loans Register";
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        TotalDefaulterR: Decimal;
        Value2: Decimal;
        AvailableShares: Decimal;
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        RoundingDiff: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        LoansR: Record "Loans Register";
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
}

