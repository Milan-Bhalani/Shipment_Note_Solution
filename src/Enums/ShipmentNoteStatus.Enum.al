namespace mbs.shipmentnote.sample;
enum 50100 "MBS Shipment Note Status"
{
    Extensible = false;

    value(0; Draft)
    {
        Caption = 'Draft';
    }

    value(1; Pending)
    {
        Caption = 'Pending';
    }

    value(2; Approved)
    {
        Caption = 'Approved';
    }

    value(3; Released)
    {
        Caption = 'Released';
    }
}