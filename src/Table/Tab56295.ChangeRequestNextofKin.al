Table 56295 "Change Request-Next of Kin"
{

    fields
    {
        field(1; "Account No"; Code[30])
        {
            TableRelation = Customer."No.";
        }
        field(2; "Full Names"; Text[200])
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                "Full Names" := UpperCase("Full Names");
            end;
        }
        field(3; Relationship; Text[200])
        {
            NotBlank = true;
            TableRelation = "Relationship Types";
        }
        field(4; Beneficiary; Boolean)
        {
        }
        field(5; "Date of Birth"; Date)
        {

            trigger OnValidate()
            begin

            end;
        }
        field(6; "Identification No."; Text[80])
        {
        }
        field(7; "Phone No"; Code[50])
        {
        }
        field(9; Email; Text[30])
        {
        }
        field(12; "%Allocation"; Decimal)
        {

            trigger OnValidate()
            begin
            end;
        }
        field(13; "Total %Allocation"; Decimal)
        {
            CalcFormula = sum("Change Request-Next of Kin"."%Allocation" where("Account No" = field("Account No")));
            FieldClass = FlowField;
            Editable = false;
            trigger OnValidate()
            begin
            end;
        }
        field(14; "Change Request no"; Code[30])
        {
            TableRelation = "Change Request"."No";
        }
    }

    keys
    {
        key(Key1;"Change Request no", "Account No", "Full Names" )
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var

}
