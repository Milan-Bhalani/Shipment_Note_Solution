namespace mbs.shipmentnote.sample;
using Microsoft.Sales.Document;
pageextension 50100 "MBS Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("MBS Shipment Note Required"; Rec."MBS Shipment Note Required")
            {
                ApplicationArea = Sales;
                ToolTip = 'Specifies whether a shipment note is required before posting the sales order.';
            }
        }
    }
}