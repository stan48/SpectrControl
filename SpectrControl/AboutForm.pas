unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmAbout = class(TForm)
    lblOs: TLabel;
    lblMem: TLabel;
    lblCpu: TLabel;
    lblAppVersion: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lblInpOut: TLabel;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  mainform, io, SysInfo;
{$R *.dfm}

procedure TfrmAbout.FormShow(Sender: TObject);
var
  memStatus: TMemoryStatus;
begin
  lblOs.Caption := SysInfo.GetOSVersionFull;
  memStatus.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(memStatus);

  lblAppVersion.Caption := main.ApplicationVersion;
  lblMem.Caption := FormatFloat('#,###" KB"', memStatus.dwTotalPhys div 1024);
  lblCpu.Caption := SysInfo.GetCPUName;

  if not io.IsIOReady then
    lblInpOut.Caption := 'DLL не загружена'
  else if io.IsDriverOpen then
    lblInpOut.Caption := 'Драйвер активен'
  else
    lblInpOut.Caption := 'DLL загружена, драйвер не активен';
end;

end.
