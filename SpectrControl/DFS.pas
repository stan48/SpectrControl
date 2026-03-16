unit DFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ImgList, messdlgs,
  XiButton, ExtCtrls, FloatUtils;

type
  TDFS52 = class(TForm)
    ImageList1: TImageList;
    EngineBOX: TGroupBox;
    Label12: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    eRew: TEdit;
    rbFRW: TRadioButton;
    rbREW: TRadioButton;
    eSpeed: TEdit;
    xbStart: TXiButton;
    GroupBox1: TGroupBox;
    xbCalobr: TXiButton;
    Label14: TLabel;
    Label18: TLabel;
    procedure FormShow(Sender: TObject);
    procedure xbCalobrClick(Sender: TObject);
    procedure xbStartClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function SMcalculate(NM: real): real;

  end;

var
  DFS52: TDFS52;

implementation

{$R *.dfm}

uses
  mainform, dfscontrol;

procedure TDFS52.FormShow(Sender: TObject);
begin
  main.Enabled := false;
end;

function TDFS52.SMcalculate(NM: real): real;
var
  nm0, nm1, sm0, sm1: real;
begin
  sm0 := (a * currentstep + b);
  nm0 := 10000000 / sm0;
  nm1 := nm0 + NM;
  sm1 := 10000000 / nm1;
  result := sm1 - sm0;
end;

procedure TDFS52.xbCalobrClick(Sender: TObject);
begin
  if messdlgs.MessageDlg('Выполнить калибровку?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    dfs52.Close;
    mainform.Main.mbox.Repaint;
    //main.Calibrate;
  end;
end;

procedure TDFS52.xbStartClick(Sender: TObject);
begin
  if rbFRW.Checked then
    dfscontrol.RewindFRW(round(StrToFloatSafe(erew.Text)), strtoint(espeed.Text));
  if rbREW.Checked then
    dfscontrol.RewindREW(round(StrToFloatSafe(erew.Text)), strtoint(espeed.Text));
end;

end.

