// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
// Page 50568 "Cheque Receipt List-Family"
// {
//     ApplicationArea = Basic;
//     CardPageID = "Cheque Receipt Header-Family";
//     DeleteAllowed = true;
//     Editable = false;
//     InsertAllowed = true;
//     PageType = List;
//     SourceTable = "Cheque Receipts-Family";
//     UsageCategory = Lists;
//     SourceTableView = where(Posted = const(false));

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("No."; Rec."No.")
//                 {
//                     ApplicationArea = Basic;
//                     Editable = false;
//                 }
//                 field("Transaction Date"; Rec."Transaction Date")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Refference Document"; Rec."Refference Document")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Transaction Time"; Rec."Transaction Time")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field("Created By"; Rec."Created By")
//                 {
//                     ApplicationArea = Basic;
//                     Style = StrongAccent;
//                 }
//                 field("No of Cheques"; Rec."No of Cheques")
//                 {
//                     ApplicationArea = Basic;
//                     Style = StrongAccent;
//                 }
//                 field("Posted By"; Rec."Posted By")
//                 {
//                     ApplicationArea = Basic;
//                 }
//                 field(Imported; Rec.Imported)
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field(Processed; Rec.Processed)
//                 {
//                     ApplicationArea = Basic;
//                     Visible = false;

//                 }
//                 field("Document Name"; Rec."Document Name")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field(Posted; Rec.Posted)
//                 {
//                     ApplicationArea = Basic;
//                     Style = Strong;
//                 }
//                 field("Bank Account"; Rec."Bank Account")
//                 {
//                     ApplicationArea = Basic;
//                     Style = StrongAccent;
//                 }
//                 field("No. Series"; Rec."No. Series")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field("Unpaid By"; Rec."Unpaid By")
//                 {
//                     ApplicationArea = Basic;
//                     visible = false;
//                 }
//                 field(Unpaid; Rec.Unpaid)
//                 {

//                     ApplicationArea = Basic;
//                     Visible = false;
//                 }

//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnOpenPage()
//     begin
//         Rec.Ascending(false)
//     end;
// }

