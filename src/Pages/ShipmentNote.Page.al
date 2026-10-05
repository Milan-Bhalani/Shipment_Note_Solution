namespace mbs.shipmentnote.sample;
using Microsoft.Foundation.NoSeries;

page 50101 "MBS Shipment Note"
{
    Caption = 'Shipment Note';
    PageType = Card;
    SourceTable = "MBS Shipment Note";
    ApplicationArea = Sales;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = Sales;
                    Editable = false;
                    ToolTip = 'Specifies the number of the shipment note.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Sales;
                    ToolTip = 'Specifies the description of the shipment note.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = Sales;
                    ToolTip = 'Specifies the status of the shipment note.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Sales;
                    ToolTip = 'Specifies the posting date of the shipment note.';
                }

                field("Sales Header No."; Rec."Sales Header No.")
                {
                    ApplicationArea = Sales;
                    ToolTip = 'Specifies the sales order number related to the shipment note.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ShipmentNoteSetup: Record "MBS Shipment Note Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if not ShipmentNoteSetup.Get('1') then
            Error(SetupMissingErr);

        ShipmentNoteSetup.TestField("Shipment Note Nos.");

        Rec."No." := NoSeries.GetNextNo(
            ShipmentNoteSetup."Shipment Note Nos.",
            WorkDate(),
            true);

        exit(true);
    end;

    var
        SetupMissingErr: Label 'Shipment Note Setup must be configured before creating a Shipment Note.';
}