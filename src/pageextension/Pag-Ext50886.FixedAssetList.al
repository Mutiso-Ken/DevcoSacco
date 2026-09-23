pageextension 50886 "Fixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Acquisition Amount"; "Acquisition Amount")
            {
                ApplicationArea = all;

            }
            field("Depreciation Amount"; "Depreciation Amount")
            {
                ApplicationArea = all;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}