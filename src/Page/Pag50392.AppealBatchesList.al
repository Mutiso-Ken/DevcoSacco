#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50392 "Appeal Batches - List"
{
    ApplicationArea = Basic;
    CardPageID = "Appeal batches Card";
    PageType = List;
    SourceTable = "Loan Disburesment-Batching";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000006)
            {
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                }
                field("Description/Remarks"; Rec."Description/Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Mode Of Disbursement"; Rec."Mode Of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

