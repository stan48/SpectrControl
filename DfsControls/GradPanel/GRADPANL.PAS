{a simple panel mik 29/04/98}
unit Gradpanl;

interface

uses WinTypes, WinProcs, Messages, SysUtils, Classes, Controls,
     Forms, Graphics, Stdctrls, ExtCtrls;

type
  TgradientPanel = class(TCustompanel)
    private
      colors : array[0..255] of tcolor;
      procedure AutoInitialize;
      Procedure setBcolor(value:Tcolor);
      Procedure setEcolor(value:Tcolor);
    protected
        procedure Paint; override;
    public
     FBeginColor,FEndColor: Tcolor;
     FNumberOfColors : integer;
     constructor Create(AOwner: TComponent); override;
     procedure GradientFill(canvas:Tcanvas;width,height:integer);
     procedure calcolor;
    published
     Property BeginColor: Tcolor read FBeginColor write SetBcolor;
     Property EndColor: Tcolor read FEndColor write SetEcolor;
     Property Caption;
     Property Font;
     Property Align;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Additional', [TgradientPanel]);
end;

procedure TgradientPanel.setBcolor(value:Tcolor);
Begin
If FBeginColor <> value then
 begin
   FBeginColor := value;
   Invalidate;
 end;
end;

procedure TgradientPanel.setEcolor(value:Tcolor);
Begin
If FEndColor <> value then
 begin
   FEndColor := value;
   Invalidate;
 end;
end;
procedure TgradientPanel.calcolor;
var
  BeginRGB  : array[0..2] of Byte;
  RGBDifference  : array[0..2] of integer;
  R         : Byte;
  G         : Byte;
  B         : Byte;
  I: Byte;

begin
  BeginRGB[0] := GetRValue (ColorToRGB (FBeginColor));
  BeginRGB[1] := GetGValue (ColorToRGB (FBeginColor));
  BeginRGB[2] := GetBValue (ColorToRGB (FBeginColor));

  RGBDifference[0] := GetRValue (ColorToRGB (FEndColor)) - BeginRGB[0];
  RGBDifference[1] := GetGValue (ColorToRGB (FEndColor)) - BeginRGB[1];
  RGBDifference[2] := GetBValue (ColorToRGB (FEndColor)) - BeginRGB[2];
 for i := 0 to 255 do
 begin
    R := BeginRGB[0] + MulDiv (I, RGBDifference[0], FNumberOfColors - 1);
    G := BeginRGB[1] + MulDiv (I, RGBDifference[1], FNumberOfColors - 1);
    B := BeginRGB[2] + MulDiv (I, RGBDifference[2], FNumberOfColors - 1);
    colors[i] := RGB (R, G, B);
 end;

end;

procedure TgradientPanel.GradientFill(canvas:Tcanvas;width,height:integer);
var
  Rc : TRect;
  I         : Integer;
  TmpBitmap   : TBitmap;

begin
calcolor;

TmpBitmap := TBitmap.Create;
TmpBitmap.Width := Width;
TmpBitmap.Height := Height;

Rc.Top := 0;
Rc.Bottom := Height;

with TmpBitmap do
  for I := 0 to FNumberOfColors do
    begin
     Rc.Left  := MulDiv (I   , Width, FNumberOfColors);
     Rc.Right := MulDiv (I + 1, Width, FNumberOfColors);
     Canvas.Brush.Color := colors[i];
     Canvas.FillRect (Rc);
    end;
   Canvas.Draw(0, 0, TmpBitmap);
   TmpBitmap.Free;
end;

{ Method to set variable and property values and create objects }
procedure TgradientPanel.AutoInitialize;
begin
     Height := 121;
     Width := 377;
   FBeginColor:= Clbtnshadow;
   FEndColor:= clsilver;
   FNumberOfColors := 255;
end; { of AutoInitialize }


constructor TgradientPanel.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     AutoInitialize;
     { Code to perform other tasks when the component is created }

end;


procedure TgradientPanel.Paint;
var fontheight : Integer;
   x,y : integer;
begin
  GradientFill(canvas,width,height);
  FontHeight := canvas.TextHeight('W');
  canvas.brush.style := bsclear;
  canvas.font := self.font;
  x := 4;
  y := (height - FontHeight) shr 1;
  canvas.textout(x,y,caption);
end;

end.
