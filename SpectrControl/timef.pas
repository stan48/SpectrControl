unit timef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MessDlgs, FloatUtils;

type
  TTimeForm = class(TForm)
    Label2: TLabel;
    eTime: TEdit;
    eDiscr: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure xbStartClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  timeform: TTimeForm;

implementation

uses
  mainform;
{$R *.dfm}

procedure TTimeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  main.Enabled := true;
end;

procedure TTimeForm.xbStartClick(Sender: TObject);
var
  ds, tm: real;
begin

  try
    ds := (StrToFloatSafe(ediscr.text)) / 1000;
    tm := StrToFloatSafe(etime.Text);
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if (ds <= 0) or (tm <= 0) then
  begin
    messdlgs.Showerror(ParamError);
    drawer.Refresh;
    system.Exit;
  end;

  if ds >= tm then
  begin
    messdlgs.showerror(ParamError);
    system.Exit;
  end;

  timeform.Close;
  main.Enabled := true;
  main.Start_Point_Scan;

end;

end.

