namespace mbs.shipmentnote.sample;
using Microsoft.Sales.Document;
tableextension 50100 "MBS Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "MBS Shipment Note Required"; Boolean)
        {
            Caption = 'Shipment Note Required';
            DataClassification = CustomerContent;
            AllowInCustomizations = ToBeClassified;
        }
    }
}