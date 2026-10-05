namespace mbs.shipmentnote.sample;
using Microsoft.Sales.Document;
table 50101 "MBS Shipment Note"
{
    Caption = 'Shipment Note';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(3; Status; Enum "MBS Shipment Note Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (xRec.Status = xRec.Status::Draft) and
                   (Rec.Status = Rec.Status::Released)
                then
                    Error(DirectReleaseErr);
            end;
        }

        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(5; "Sales Header No."; Code[20])
        {
            Caption = 'Sales Header No.';
            TableRelation = "Sales Header"."No."
                where("Document Type" = const(Order));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        DirectReleaseErr: Label 'A Shipment Note cannot be changed directly from Draft to Released.';
}