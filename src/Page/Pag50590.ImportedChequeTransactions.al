#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50590 "Imported Cheque Transactions"
{
    CardPageID = "Cheque Transactions Card";
    Editable = false;
    PageType = List;
    SourceTable = "Cheque Truncation Buffer";
    SourceTableView = where("Imported to Receipt Lines" = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ChequeDataId; Rec.ChequeDataId)
                {
                    ApplicationArea = Basic;
                }
                field(SerialId; Rec.SerialId)
                {
                    ApplicationArea = Basic;
                }
                field(AMOUNT; Rec.AMOUNT)
                {
                    ApplicationArea = Basic;
                }
                field(CURRENCYCODE; Rec.CURRENCYCODE)
                {
                    ApplicationArea = Basic;
                }
                field(DESTBANK; Rec.DESTBANK)
                {
                    ApplicationArea = Basic;
                }
                field(DESTBRANCH; Rec.DESTBRANCH)
                {
                    ApplicationArea = Basic;
                }
                field(DESTACC; Rec.DESTACC)
                {
                    ApplicationArea = Basic;
                }
                field(PBANK; Rec.PBANK)
                {
                    ApplicationArea = Basic;
                }
                field(PBRANCH; Rec.PBRANCH)
                {
                    ApplicationArea = Basic;
                }
                field(MemberNo; Rec.MemberNo)
                {
                    ApplicationArea = Basic;
                }
                field(SNO; Rec.SNO)
                {
                    ApplicationArea = Basic;
                }
                field(FrontBWImage; Rec.FrontBWImage)
                {
                    ApplicationArea = Basic;
                }
                field(FrontGrayScaleImage; Rec.FrontGrayScaleImage)
                {
                    ApplicationArea = Basic;
                }
                field(RearImage; Rec.RearImage)
                {
                    ApplicationArea = Basic;
                }
                field(IsFCY; Rec.IsFCY)
                {
                    ApplicationArea = Basic;
                }
                field("Imported to Receipt Lines"; Rec."Imported to Receipt Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imported ?';
                }
            }
        }
    }

    actions
    {
    }
}

