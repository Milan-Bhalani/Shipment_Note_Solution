namespace mbs.shipmentnote.sample;

using mbs.shipmentnote.sample;

permissionset 50100 ShipmentSolution
{
    Assignable = true;
    Permissions = tabledata "MBS Shipment Note"=RIMD,
        tabledata "MBS Shipment Note Setup"=RIMD,
        table "MBS Shipment Note"=X,
        table "MBS Shipment Note Setup"=X,
        codeunit "MBS Shipment Note Sales Post"=X,
        page "MBS Shipment Note"=X,
        page "MBS Shipment Note Setup"=X;
}