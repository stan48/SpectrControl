unit SpectrumCollection;

interface

uses
  Classes, Spectrum, Math, SpecialTypes;

type
  TSpectrumCollection = class(TCollection)
    type
      TMinMax = record
        Min_X: integer;
        Max_X: integer;
        Min_Y: integer;
        Max_Y: integer;
      end;

    {private declaration}

  private
    minMaxRecord: TMinMax;

    function GetItem(Index: Integer): TSpectrum;
    procedure SetItem(Index: Integer; const Value: TSpectrum);

    function GetMaxX: Integer;
    function GetMaxY: Integer;
    function GetMinX: Integer;
    function GetMinY: Integer;

    function FindMinMax: TminMax;

    {public declaration}
  public
    constructor Create();

    property MinX: Integer read GetMinX;
    property MaxX: Integer read GetMaxX;
    property MinY: Integer read GetMinY;
    property MaxY: Integer read GetMaxY;
    property Items[Index: Integer]: TSpectrum read GetItem write SetItem; default;

  published
  end;

implementation

constructor TSpectrumCollection.Create();
begin
  inherited Create(TSpectrum);
end;

function TSpectrumCollection.GetItem(Index: Integer): TSpectrum;
begin
  Result := TSpectrum(inherited GetItem(Index))
end;

function TSpectrumCollection.GetMaxX: Integer;
begin
  Self.FindMinMax;
  result := minmaxrecord.Max_X;
end;

function TSpectrumCollection.GetMaxY: Integer;
begin
  Self.FindMinMax;
  result := minmaxrecord.Max_Y;
end;

function TSpectrumCollection.GetMinX: Integer;
begin
  Self.FindMinMax;
  result := minmaxrecord.Min_X;
end;

function TSpectrumCollection.GetMinY: Integer;
begin
  Self.FindMinMax;
  result := minmaxrecord.Min_Y;
end;

procedure TSpectrumCollection.SetItem(Index: Integer; const Value: TSpectrum);
begin

end;

function TSpectrumCollection.FindMinMax: TMinMax;
var
  i, j: integer;
  MinValue, MaxValue, CurrentPoint: TPointR;
  res: TMinMax;
begin
  MinValue.X := 1000000000;
  MinValue.Y := 1000000000;
  MaxValue.Y := 0;
  MaxValue.X := 0;

  for i := 0 to Self.Count - 1 do
  begin
    if Self[i].Visible = False then
      Continue;

    for j := 0 to Self[i].Count - 1 do
    begin
      CurrentPoint := Self[i].GetItem(j);
      MinValue.X := min(MinValue.X, CurrentPoint.X);
      MinValue.Y := min(MinValue.Y, CurrentPoint.Y);
      MaxValue.X := max(MaxValue.X, CurrentPoint.X);
      MaxValue.Y := max(MaxValue.Y, CurrentPoint.Y)
    end;
  end;

  res.Min_X := Round(MinValue.X - ((MaxValue.X - MaxValue.X) / 5));
  res.Min_Y := Round(MinValue.Y - ((MaxValue.Y - MaxValue.Y) / 5));
  res.Max_X := Round(MaxValue.X + ((MaxValue.X - MaxValue.X) / 5));
  res.Max_Y := Round(MaxValue.Y + ((MaxValue.Y - MaxValue.Y) / 5));
  Self.minMaxRecord := res;
  result := res;
end;

end.

