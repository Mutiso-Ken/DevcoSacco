#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50214 "Nextof Kin-Change"
{
    PageType = ListPart;
    SourceTable = "Next of Kin/Account Sign";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                }
                field(Fax; Rec.Fax)
                {
                    ApplicationArea = Basic;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("%Allocation"; Rec."%Allocation")
                {
                    ApplicationArea = Basic;
                }
                field("Total Allocation"; Rec."Total Allocation")
                {
                    ApplicationArea = Basic;
                }
                field("Maximun Allocation %"; Rec."Maximun Allocation %")
                {
                    ApplicationArea = Basic;
                }
                field(Age; Rec.Age)
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
            action(Populate)
            {
                ApplicationArea = Basic;
                Caption = 'Populate';
                Image = GetLines;

                trigger OnAction()
                begin
                    Message('12345');
                end;
            }
        }
    }

    var
        ProductNxK: Record "FOSA Account NOK Details";
    //MembNxK: Record "Members Next of Kin";
    //cloudRequest: Record "Pension Processing Headerr";
}

