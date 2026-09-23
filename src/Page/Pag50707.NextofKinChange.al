#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50707 "Next of Kin-Change"
{
    PageType = CardPart;
    SourceTable = "Change Request-Next of Kin";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No";"Account No")
                {
                    ApplicationArea = Basic;
                }
                
                field("Change Request no";"Change Request no")
                {
                    ApplicationArea = Basic;
                }
                field(Name;"Full Names")
                {
                    ApplicationArea = Basic;
                }
                field(Relationship;Relationship)
                {
                    ApplicationArea = Basic;
                }
                field(Beneficiary;Beneficiary)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth";"Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Telephone;"Phone No")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Identity No";"Identification No.")
                {
                    ApplicationArea = Basic;
                }
                field("%Allocation";"%Allocation")
                {
                    ApplicationArea = Basic;
                }
                field("Total Allocation";"Total %Allocation")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }


    trigger OnDeleteRecord(): Boolean
    begin

    end;

}
