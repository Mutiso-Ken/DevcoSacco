report 58000 AssetsReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/AssetReport.rdlc';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            column(No_; "No.")
            {

            }
            column(ComputerAcccurrent; ComputerAcccurrent) { }
            column(FurnitureFittingscurrent; FurnitureFittingscurrent) { }
            column(OfficeEquipmentCurrent; OfficeEquipmentCurrent) { }
            column(IntangibleCurrent; IntangibleCurrent) { }

            column(StartDeprComputerAcccurrent; StartDeprComputerAcccurrent) { }
            column(StartDeprFurnitureFittingscurrent; StartDeprFurnitureFittingscurrent) { }
            column(StartDeprOfficeEquipmentCurrent; StartDeprOfficeEquipmentCurrent) { }
            column(startDeprIntangibleCurrent; startDeprIntangibleCurrent) { }

            column(DeprComputerAcccurrent; DeprComputerAcccurrent) { }
            column(DeprFurnitureFittingscurrent; DeprFurnitureFittingscurrent) { }
            column(DeprOfficeEquipmentCurrent; DeprOfficeEquipmentCurrent) { }
            column(DeprIntangibleCurrent; DeprIntangibleCurrent) { }
            column(StartFurnitureFittingscurrent; StartFurnitureFittingscurrent) { }
            column(StartIntangibleCurrent; StartIntangibleCurrent) { }
            column(StartOfficeEquipmentCurrent; StartOfficeEquipmentCurrent) { }
            column(StartComputerAcccurrent; StartComputerAcccurrent) { }
            column(CurrentDate; CurrentDate)
            {

            }
            column(StartofcurrentDate; StartofcurrentDate) { }
            column(EndoflastYear; EndoflastYear) { }
            column(StartofLastYear; StartofLastYear) { }
            column(CurrentYear; CurrentYear) { }
            column(LastYear; LastYear) { }



            column(AdditionsComputerAcccurrent; AdditionsComputerAcccurrent) { }
            column(AdditionsFurnitureFittingscurrent; AdditionsFurnitureFittingscurrent) { }
            column(AdditionsOfficeEquipmentCurrent; AdditionsOfficeEquipmentCurrent) { }
            column(AdditionsIntangibleCurrent; AdditionsIntangibleCurrent) { }



            column(ChargeComputerAcccurrent; ChargeComputerAcccurrent) { }
            column(chargeIntangibleCurrent; chargeIntangibleCurrent) { }
            column(chargeOfficeEquipmentCurrent; chargeOfficeEquipmentCurrent) { }
            column(ChargeFurnitureFittingscurrent; ChargeFurnitureFittingscurrent) { }



            column(ChargeComputerAcccurrentlast; ChargeComputerAcccurrentlast) { }
            column(chargeIntangibleCurrentLast; chargeIntangibleCurrentLast) { }
            column(chargeOfficeEquipmentCurrentLast; chargeOfficeEquipmentCurrentLast) { }
            column(ChargeFurnitureFittingscurrentLast; ChargeFurnitureFittingscurrentLast) { }

            column(EndComputerAccLast; EndComputerAccLast) { }

            column(EndFurnitureFittingsLast; EndFurnitureFittingsLast) { }
            column(EndOfficeEquipmentlast; EndOfficeEquipmentlast) { }
            column(EndIntangibleLast; EndIntangibleLast) { }

            column(StartComputerAccLast; StartComputerAccLast) { }
            column(StartFurnitureFittingsLast; StartFurnitureFittingsLast) { }
            column(StartOfficeEquipmentlast; StartOfficeEquipmentlast) { }
            column(StartIntangibleLast; StartIntangibleLast) { }

            column(AdditionsComputerAcLast; AdditionsComputerAcLast) { }
            column(AdditionsFurnitureFittingsLast; AdditionsFurnitureFittingsLast) { }
            column(AdditionsOfficeEquipmentLast; AdditionsOfficeEquipmentLast) { }
            column(AdditionsIntangibleLast; AdditionsIntangibleLast) { }

            column(DeprComputerAccLast; DeprComputerAccLast) { }
            column(DeprFurnitureFittingsLast; DeprFurnitureFittingsLast) { }
            column(DeprOfficeEquipmentLast; DeprOfficeEquipmentLast) { }
            column(DeprIntangiblelast; DeprIntangiblelast) { }

            column(StartDeprComputerAccLast; StartDeprComputerAccLast) { }
            column(StartDeprFurnitureFittingsLast; StartDeprFurnitureFittingsLast) { }
            column(StartDeprOfficeEquipmentLast; StartDeprOfficeEquipmentLast) { }

            column(startDeprIntangibleLast; startDeprIntangibleLast) { }


            trigger OnAfterGetRecord()
            var
                CurrentYearStartExpr: Text;
                EndofLastYearExpr: Text;
                StartofLastYearExpr: Text;
                GLAccount: Record "G/L Account";
                GLEntry: Record "G/L Entry";
                AddtionsDatefilter: Text;

            begin
                CurrentYearStartExpr := '<-CY>';
                EndofLastYearExpr := '<-CY-1D>';
                StartofLastYearExpr := '<-CY-1Y>';


                CurrentYear := Date2DMY(CurrentDate, 3);
                LastYear := CurrentYear - 1;
                StartofcurrentDate := CalcDate(CurrentYearStartExpr, CurrentDate);
                EndoflastYear := CalcDate(EndofLastYearExpr, CurrentDate);
                StartofLastYear := CalcDate(StartofLastYearExpr, CurrentDate);

                ComputerAcccurrent := 0;
                FurnitureFittingscurrent := 0;
                OfficeEquipmentCurrent := 0;

                //computer Accesories
                ComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ComputerAcccurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                FurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            FurnitureFittingscurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                OfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OfficeEquipmentCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                IntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            IntangibleCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets


                //Depreciation Current
                //computer Accesories
                DeprComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprComputerAcccurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                DeprFurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprFurnitureFittingscurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                DeprOfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprOfficeEquipmentCurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                DeprIntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprIntangibleCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets
                //End of depreciation 


                //Start of the year

                //computer Accesories
                StartComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartComputerAcccurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                StartFurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartFurnitureFittingscurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                StartOfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartOfficeEquipmentCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                StartIntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartIntangibleCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets

                //Depreciation Start of the year
                //computer Accesories
                StartDeprComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprComputerAcccurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                StartDeprFurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprFurnitureFittingscurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment

                StartDeprOfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprOfficeEquipmentCurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                startDeprIntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '<=%1', StartofcurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            startDeprIntangibleCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets
                //End of depreciation 
                //End of StartofcurrentDatert of the yea
                //Additions

                AdditionsComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsComputerAcccurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsFurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsFurnitureFittingscurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsIntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsIntangibleCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsOfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsOfficeEquipmentCurrent += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of additions



                //Depreciations
                ChargeComputerAcccurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ChargeComputerAcccurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                ChargeFurnitureFittingscurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ChargeFurnitureFittingscurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                chargeIntangibleCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            chargeIntangibleCurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                chargeOfficeEquipmentCurrent := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentDate, CurrentDate);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            chargeOfficeEquipmentCurrent += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of Depreceation

                //............
                ChargeComputerAcccurrentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ChargeComputerAcccurrentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                ChargeFurnitureFittingscurrentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ChargeFurnitureFittingscurrentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                chargeIntangibleCurrentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            chargeIntangibleCurrentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                chargeOfficeEquipmentCurrentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            chargeOfficeEquipmentCurrentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of Depreceation last


                //End of the year

                //computer Accesories
                EndComputerAccLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            EndComputerAccLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                EndFurnitureFittingsLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            EndFurnitureFittingsLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                EndOfficeEquipmentlast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            EndOfficeEquipmentlast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                EndIntangibleLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            EndIntangibleLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets

                //end of start of last year

                //Start of last year

                //computer Accesories
                StartComputerAccLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartComputerAccLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                StartFurnitureFittingsLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartFurnitureFittingsLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                StartOfficeEquipmentlast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartOfficeEquipmentlast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                StartIntangibleLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartIntangibleLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of intagible assets
                //End of last year



                //Additions Last
                AdditionsComputerAcLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsComputerAcLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsFurnitureFittingsLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsFurnitureFittingsLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsIntangibleLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsIntangibleLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                AdditionsOfficeEquipmentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset", '%1', GLAccount."Type of Asset"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofLastYear, EndoflastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            AdditionsOfficeEquipmentLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of additions

                //Depreciation Last year
                //Start
                //computer Accesories
                StartDeprComputerAccLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprComputerAccLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                StartDeprFurnitureFittingsLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprFurnitureFittingsLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                StartDeprOfficeEquipmentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            StartDeprOfficeEquipmentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                startDeprIntangibleLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            startDeprIntangibleLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //End of Start
                //Start of last
                //computer Accesories
                DeprComputerAccLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Computer & Accessories");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprComputerAccLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Computer Accesories
                //Furniture & Fittings
                DeprFurnitureFittingsLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Furniture & Fittings");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprFurnitureFittingsLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                // End of furniture 
                //Office Equipment
                DeprOfficeEquipmentLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset Depr"::"Office Equipments");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprOfficeEquipmentLast += -GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //end of Office Equipment
                //Intagible Assets
                DeprIntangibleLast := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount."Type of Asset Depr", '%1', GLAccount."Type of Asset"::"Intangible Assets");
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofLastYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            DeprIntangibleLast += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                //End of Last

                //End of depreciations Last year



            end;


        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Date; CurrentDate)
                    {
                        ApplicationArea = all;
                        Caption = 'As at';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    var

        CurrentDate: Date;

        StartofcurrentDate: Date;
        EndoflastYear: Date;
        StartofLastYear: Date;
        CurrentYear: Integer;
        LastYear: Integer;
        ComputerAcccurrent: Decimal;
        FurnitureFittingscurrent: Decimal;
        OfficeEquipmentCurrent: Decimal;
        IntangibleCurrent: Decimal;
        StartComputerAcccurrent: Decimal;
        StartFurnitureFittingscurrent: Decimal;
        StartOfficeEquipmentCurrent: Decimal;
        StartIntangibleCurrent: Decimal;


        EndComputerAccLast: Decimal;
        EndFurnitureFittingsLast: Decimal;
        EndOfficeEquipmentlast: Decimal;
        EndIntangibleLast: Decimal;

        StartComputerAccLast: Decimal;
        StartFurnitureFittingsLast: Decimal;
        StartOfficeEquipmentlast: Decimal;
        StartIntangibleLast: Decimal;


        DeprComputerAcccurrent: Decimal;
        DeprFurnitureFittingscurrent: Decimal;
        DeprOfficeEquipmentCurrent: Decimal;
        DeprIntangibleCurrent: Decimal;

        StartDeprComputerAcccurrent: Decimal;
        StartDeprFurnitureFittingscurrent: Decimal;
        StartDeprOfficeEquipmentCurrent: Decimal;
        startDeprIntangibleCurrent: Decimal;


        AdditionsComputerAcccurrent: Decimal;
        AdditionsFurnitureFittingscurrent: Decimal;
        AdditionsOfficeEquipmentCurrent: Decimal;
        AdditionsIntangibleCurrent: Decimal;

        ChargeComputerAcccurrent: Decimal;
        ChargeFurnitureFittingscurrent: Decimal;
        chargeOfficeEquipmentCurrent: Decimal;
        chargeIntangibleCurrent: Decimal;
        //Charge last year
        ChargeComputerAcccurrentLast: Decimal;
        ChargeFurnitureFittingscurrentLast: Decimal;
        chargeOfficeEquipmentCurrentLast: Decimal;
        chargeIntangibleCurrentLast: Decimal;
        //End Of Charge Last year

        //Addtions last Year
        AdditionsComputerAcLast: Decimal;
        AdditionsFurnitureFittingsLast: Decimal;
        AdditionsOfficeEquipmentLast: Decimal;
        AdditionsIntangibleLast: Decimal;
        //End of Last year


        //End of depreciation Last year

        DeprComputerAccLast: Decimal;
        DeprFurnitureFittingsLast: Decimal;
        DeprOfficeEquipmentLast: Decimal;
        DeprIntangiblelast: Decimal;

        StartDeprComputerAccLast: Decimal;
        StartDeprFurnitureFittingsLast: Decimal;
        StartDeprOfficeEquipmentLast: Decimal;
        startDeprIntangibleLast: Decimal;
    //End of depreciation Last year

}