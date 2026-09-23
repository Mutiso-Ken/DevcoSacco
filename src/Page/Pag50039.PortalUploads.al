page 50039 "Portal Uploads"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SharePoint Documents";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { ApplicationArea = all; Editable = false; }
                field(Description; Rec."File Name") { ApplicationArea = all; ShowMandatory = true; Editable = false; }
                field(LocalUrl; Rec.Location) { ApplicationArea = all; Editable = false; ExtendedDatatype = URL; }
                
            }
        }
        area(Factboxes)
        {

        }
    }
    }