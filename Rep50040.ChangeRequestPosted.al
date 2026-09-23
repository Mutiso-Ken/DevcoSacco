report 50040 "Change Request Posted"
{
    ApplicationArea = All;
    Caption = 'Change Request Posted ';
    UsageCategory = Lists;

    RDLCLayout = './Layouts/Changerequest.rdl';
    dataset
    {
        dataitem(ChangeRequest; "Change Request")
        {
            column(No; No)
            {
            }
            column(AccountNo; "Account No")
            {
            }
            column(Name; Name)
            {
            }
            column(Reasonforchange; "Reason for change")
            {
            }
            column(CaptureDate; "Capture Date")
            {
            }
            column(Captured_by; "Captured by") { }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
