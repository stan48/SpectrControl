unit proc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XiButton, messdlgs, Math, SpecialTypes;

type
  TRealArray = array of Double;

type
  TfmProc = class(TForm)
    GroupBox1: TGroupBox;
    eFu: TEdit;
    Label2: TLabel;
    xbSliceApply: TXiButton;
    procedure xbSliceApplyClick(Sender: TObject);
    procedure eFuKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure SmoothFourier(var ValueArray: TRealArray; NumGarmonics: integer);
  public
    { Public declarations }
  end;

var
  fmProc: TfmProc;

implementation

uses
  mainform;
{$R *.dfm}

procedure TfmProc.SmoothFourier(var ValueArray: TRealArray; NumGarmonics: integer);
var
  i, j, N: integer;
  yn, ap, bp: double;
  AFCoef, BFCoef: TRealArray;
begin
  N := Length(ValueArray);
  SetLength(AFCoef, NumGarmonics);
  SetLength(BFCoef, NumGarmonics);

  AFCoef[0] := Sum(ValueArray) / N;

  BFCoef[0] := 0;
  for i := 1 to NumGarmonics - 1 do
  begin
    AFCoef[i] := 0;
    BFCoef[i] := 0;
    for j := 0 to N - 1 do
    begin
      AFCoef[i] := AFCoef[i] + ValueArray[j] * cos(Pi * i * j * 2 / N);
      BFCoef[i] := BFCoef[i] + ValueArray[j] * sin(Pi * i * j * 2 / N);
    end;
    AFCoef[i] := AFCoef[i] * 2 / N;
    BFCoef[i] := BFCoef[i] * 2 / N;
  end;
  for j := 0 to N - 1 do
  begin
    yn := 0;
    ap := 0;
    bp := 0;
    for i := 1 to NumGarmonics - 1 do
    begin
      ap := ap + AFCoef[i] * cos(2 * Pi * i * (j / N));
      bp := bp + BFCoef[i] * sin(2 * Pi * i * (j / N));
    end;
    yn := AFCoef[0] + ap + bp;
    ValueArray[j] := yn;
  end;
  AFCoef := nil;
  BFCoef := nil;

end;

procedure TfmProc.xbSliceApplyClick(Sender: TObject);
var
  i, j: cardinal;
  SliceArr: TRealArray;
  coef2: integer;
  tPoint: TPointR;
begin

  try
    coef2 := round(strtofloat(proc.fmProc.efu.text));
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  j := round(main.lwSpectrumList.Selected.Index);
  SetLength(SliceArr, mainform.SpectrumList[j].Count);

  for i := 0 to mainform.SpectrumList[j].Count - 1 do
  begin
    SliceArr[i] := mainform.SpectrumList[j].GetItem(i).Y;
  end;

  Self.SmoothFourier(SliceArr, coef2);

  for i := 0 to mainform.SpectrumList[j].Count - 1 do
  begin
    tPoint := mainform.SpectrumList[j].GetItem(i);
    tPoint.Y := SliceArr[i];
    mainform.SpectrumList[j].SetItem(i, tPoint);
  end;

  fmproc.Close;
  mainform.drawer.Refresh;
end;

procedure TfmProc.eFuKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
    proc.fmProc.xbSliceApplyClick(self);

end;

end.

