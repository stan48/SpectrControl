unit Drawer;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, XYGraph, SpectrumCollection,
  Spectrum, Graphics, substruction, specialtypes, peak;

type
  TDrawer = class(TObject)
  private
    _minx, _miny, _maxx, _maxy: integer;
    _list: TSpectrumCollection;
    _box: TPaintBox;
    _xscale: TScaleXType;
    _yscale: TScaleYType;
    _xname, _yname: string;
    _points: TSubstruction;
    function GetPoints: TSubstruction;
    procedure SetPoints(const Value: TSubstruction);
    function GetX: TScaleXType;
    function GetY: TScaleYType;
    procedure SetX(const Value: TScaleXType);
    procedure SetY(const Value: TScaleYType);
    function GetMaxX: integer;
    function GetMaxY: integer;
    function GetMinX: integer;
    function GetMinY: integer;
    function GetSpectColl: TSpectrumCollection;
    procedure SetMaxX(const Value: integer);
    procedure SetMaxY(const Value: integer);
    procedure SetMinX(const Value: integer);
    procedure SetMinY(const Value: integer);
    procedure SetSpectColl(const Value: TSpectrumCollection);
    procedure Paint;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(box: TPaintBox; list: TSpectrumCollection);

    procedure Refresh;
    procedure Draw(x, y: real);
    procedure UnZoom;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): TPointR;
    function MouseMove(Shift: TShiftState; X, Y: Integer): TPointR;
    function MouseUp(Button: TMouseButton; var Shift: TShiftState; X, Y: Integer): TPointR;

  published
    { Published declarations }
    property MinX: integer read GetMinX write SetMinX;
    property MaxX: integer read GetMaxX write SetMaxX;
    property MinY: integer read GetMinY write SetMinY;
    property MaxY: integer read GetMaxY write SetMaxY;
    property SpectColl: TSpectrumCollection read GetSpectColl write SetSpectColl;
    property YScale: TScaleYType read GetY write SetY;
    property XScale: TScaleXType read GetX write SetX;
    property Points: TSubstruction read GetPoints write SetPoints;

  end;

implementation

constructor TDrawer.Create(box: TPaintBox; list: TSpectrumCollection);
begin
  Self._box := box;
  Self._list := list;

end;

procedure TDrawer.Draw(x, y: real);
begin
  XYGraph.xydraw(x, y);
end;

function TDrawer.GetMaxX: integer;
begin

  result := Self._maxx;
end;

function TDrawer.GetMaxY: integer;
begin
  result := Self._maxy;
end;

function TDrawer.GetMinX: integer;
begin
  result := Self._minx;
end;

function TDrawer.GetMinY: integer;
begin
  result := Self._miny;
end;

function TDrawer.GetPoints: TSubstruction;
begin
  Result := Self._points;
end;

function TDrawer.GetSpectColl: TSpectrumCollection;
begin
  result := Self._list;
end;

function TDrawer.GetX: TScaleXType;
begin
  result := Self._xscale;
end;

function TDrawer.GetY: TScaleYType;
begin
  result := Self._yscale;
end;

procedure TDrawer.Paint;

  procedure BuildArea;
  begin
    xygraph.xycleargraph(_box, $00E6E6E6, $00E6E6E6, 1);
    xygraph.xysetgridlines(5, -1, 5, -1);
    xygraph.xystartgraph(0, 100, 0, 100, 53, 20, 25, 34, clipon);
    xygraph.xyxaxis(clBlack, _minx, _maxx, (_maxx / 400), 0, _xname, gridon, lin, fixed);
    xygraph.xyyaxis(clBlack, _miny, _maxy, (_maxy / 400), 0, _yname, 1, gridon, lin, fixed);
    xygraph.xyinitruler(6, _box.Width - 65, 5, 0);
    XYGraph.xyfinish;

  end;

var
  i, j: cardinal;
  spectrum: TSpectrum;
  point: TPointR;
  pk: TPeak;
  t: TCollectionItem;
  xlen, ylen: Real;
begin

  BuildArea;

  if (_points <> nil) and (_points.Count > 0) then
  begin
    xygraph.xypen.Color := clRed;
    point := _points[0].point;
    XYGraph.xymove(point.X, point.Y);
    for i := 0 to _points.Count - 1 do
    begin
      point := _points[i].point;
      XYGraph.xydraw(point.X, point.Y);
      XYGraph.xysymbol(1, 6, 2);
    end;

  end;

  XYGraph.xyfinish;

  if Self._list = nil then
    exit;

  if _list.Count > 0 then
  begin
    for i := 0 to _list.Count - 1 do
    begin
      spectrum := _list[i];
      if spectrum.Visible = false then
        Continue;
      if spectrum.Count = 0 then
        Continue;

      if spectrum.Peaks.Count > 0 then
      begin
        for t in spectrum.Peaks do
        begin
          pk := TPeak(t);
          point := pk.Point;
          ylen := (Self._maxy - Self._miny) / 20;
          xlen := (Self._maxx - Self._minx) / 200;
          point.Y := point.Y + ylen / 10;
          xypen.Color := spectrum.Color;
          xygraph.xymove(point.X, ylen + point.Y);
          xygraph.xydraw(point.X, point.Y);
          xygraph.xydraw(point.X - xlen, point.Y + ylen / 3);
          xygraph.xydraw(point.X, point.Y);
          xygraph.xydraw(point.X + xlen, point.Y + ylen / 3);
          xygraph.xytext(spectrum.Color, Format('%.2f', [point.Y]), point.x + xlen / 2, point.Y + ylen, 1, 1, 1);
        end;

      end;

      point := spectrum.GetItem(0);
      xygraph.xymove(point.X, point.Y);
      xygraph.xypen.Color := spectrum.Color;

      for j := 0 to spectrum.Count - 1 do
      begin
        point := spectrum.GetItem(j);
        xygraph.xydraw(point.X, point.Y);
      end;
    end;
  end;

end;

procedure TDrawer.Refresh;
begin
  Self.Paint;
end;

procedure TDrawer.SetMaxX(const Value: integer);
begin
  _maxx := Value;
end;

procedure TDrawer.SetMaxY(const Value: integer);
begin
  _maxy := Value;
end;

procedure TDrawer.SetMinX(const Value: integer);
begin
  _minx := Value;
end;

procedure TDrawer.SetMinY(const Value: integer);
begin
  _miny := Value;
end;

procedure TDrawer.SetPoints(const Value: TSubstruction);
begin
  _points := Value;
end;

procedure TDrawer.SetSpectColl(const Value: TSpectrumCollection);
begin
  Self._list := Value;
end;

procedure TDrawer.SetX(const Value: TScaleXType);
begin
  Self._xscale := Value;
  case _xscale of
    sm:
      _xname := 'обр.см.';
    nm:
      _xname := 'нм.';
    steps:
      _xname := 'шаги';
    seconds:
      _xname := 'секунды';
  end;

end;

procedure TDrawer.SetY(const Value: TScaleYType);
begin
  Self._yscale := Value;
  case _yscale of
    hertz:
      _yname := 'Гц';
    impulse:
      _yname := 'Имп.';
  end;
end;

procedure TDrawer.UnZoom;
begin
  XYGraph.xyunzoom;
end;

function TDrawer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): TPointR;
begin
  Result := XYGraph.XYMouseDown(Button, Shift, X, Y);
end;

function TDrawer.MouseMove(Shift: TShiftState; X, Y: Integer): TPointR;
begin
  Result := XYGraph.XYMouseMove(Shift, X, Y);
end;

function TDrawer.MouseUp(Button: TMouseButton; var Shift: TShiftState; X, Y: Integer): TPointR;
begin
  Result := XYGraph.XYMouseUp(Button, Shift, X, Y);
end;

end.

