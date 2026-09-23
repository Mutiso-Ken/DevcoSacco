reportextension 50000 "FA Register" extends "Fixed Asset - List"
{
     dataset
    {
        add("Fixed Asset")
        {
            column(Location_Code; "Location Code" ) 
            { }
            column(Responsible_Employee; "Responsible Employee")
            { }
        }
    }

}
