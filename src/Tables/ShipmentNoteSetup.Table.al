namespace mbs.shipmentnote.sample;
using Microsoft.Foundation.NoSeries;
table 50100 "MBS Shipment Note Setup"
{
    Caption = 'Shipment Note Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[1])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }

        field(2; "Shipment Note Nos."; Code[20])
        {
            Caption = 'Shipment Note Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}