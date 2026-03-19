unit peaksForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XiButton, mainform;

type
  TPeaksForm = class(TForm)
    eTreshold: TEdit;
    eDeep: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    btnOk: TXiButton;
    btnCancel: TXiButton;
    eSharp: TEdit;
    Label1: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    _result: boolean;
    _deep: Cardinal;
    _treshold: Cardinal;
    _sharp: Byte;
    function GetSharp: Byte;
    function GetDeep: Cardinal;
    function GetResult: Boolean;
    function GetTreshold: Cardinal;

    { Private declarations }
  public
    { Public declarations }
    property Result: Boolean read GetResult;
    property Treshold: Cardinal read GetTreshold;
    property Deep: Cardinal read GetDeep;
    property Sharp: Byte read GetSharp;
  end;

var
  pksForm: TPeaksForm;

implementation

{$R *.dfm}

procedure TPeaksForm.btnCancelClick(Sender: TObject);
begin
  Self._result := False;
  Self.Close;
end;

procedure TPeaksForm.btnOkClick(Sender: TObject);
begin
  try
    Self._deep := StrToInt(eDeep.Text);
    Self._treshold := StrToInt(eTreshold.Text);
    Self._sharp := StrToInt(eSharp.Text);
  except
    on EConvertError do
    begin
      ShowMessage('Ошибка!');
      Exit;
    end;
  end;
  MAINFORM.SpectrumList[Main.lwSpectrumList.Selected.Index].FindPeaks(Self.Treshold, Self.Deep, Self.Sharp);
  Self._result := True;

  Self.Close;
  MAINFORM.drawer.Refresh;
end;

function TPeaksForm.GetDeep: Cardinal;
begin
  Result := _deep;
end;

function TPeaksForm.GetResult: Boolean;
begin
  Result := _result;
end;

function TPeaksForm.GetSharp: Byte;
begin
  Result := _sharp;
end;

function TPeaksForm.GetTreshold: Cardinal;
begin
  Result := _treshold;
end;

end.

