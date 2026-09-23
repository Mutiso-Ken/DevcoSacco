tableextension 50042 "Bank Account Statement" extends "Bank Account Statement"
{
    fields
    {

        field(50051; "Cash Book Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; Reconciled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}