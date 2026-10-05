namespace mbs.shipmentnote.sample;
page 50100 "MBS Shipment Note Setup"
{
    Caption = 'Shipment Note Setup';
    PageType = Card;
    SourceTable = "MBS Shipment Note Setup";
    ApplicationArea = Sales;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Shipment Note Nos."; Rec."Shipment Note Nos.")
                {
                    ApplicationArea = Sales;
                    ToolTip = 'Specifies the number series used to assign numbers to shipment notes.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('') then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}