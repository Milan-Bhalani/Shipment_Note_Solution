namespace mbs.shipmentnote.sample;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
codeunit 50100 "MBS Shipment Note Sales Post"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(
        var Sender: Codeunit "Sales-Post";
        var SalesHeader: Record "Sales Header";
        CommitIsSuppressed: Boolean;
        PreviewMode: Boolean;
        var HideProgressWindow: Boolean;
        var IsHandled: Boolean;
        var CalledBy: Integer)
    begin
        if SalesHeader."MBS Shipment Note Required" then
            Error(ShipmentNoteRequiredErr);
    end;

    var
        ShipmentNoteRequiredErr: Label 'The sales order cannot be posted because Shipment Note Required is enabled.';
}