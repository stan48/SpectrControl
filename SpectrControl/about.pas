unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFrmAbout = class(TForm)
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
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    procedure GetOSinfo;
  end;

var
  frmAbout: TFrmAbout;

implementation

uses
  mainform;
{$R *.dfm}         

{ TFrmAbout }
procedure TFrmAbout.GetOSinfo;
var
  platform: string;
  BuildNumber: Integer;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        platform := 'Windows 95';
        BuildNumber := Win32BuildNumber and $0000FFFF;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        platform := 'Windows NT';
        BuildNumber := Win32BuildNumber;
      end;
  else
    begin
      platform := 'Windows';
      BuildNumber := 0;
    end;
  end;

  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or (Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
      if Win32CSDVersion = '' then
        lblOs.Caption := Format('%s %d.%d (Build %d)', [platform, Win32MajorVersion, Win32MinorVersion, BuildNumber])
      else
        lblOs.Caption := Format('%s %d.%d (Build %d: %s)', [platform, Win32MajorVersion, Win32MinorVersion, BuildNumber, Win32CSDVersion]);
    end
  else
    lblOs.Caption := Format('%s %d.%d', [platform, Win32MajorVersion, Win32MinorVersion])

end;

procedure TFrmAbout.FormShow(Sender: TObject);
var
  memStatus: TMemoryStatus;
begin
  GetOSInfo;
  memStatus.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(memStatus);

  lblAppVersion.Caption := main.ApplicationVersion;
  lblMem.Caption := FormatFloat('#,###" KB"', memStatus.dwTotalPhys div 1024);
  lblCpu.Caption := inttostr(cpuspd) + ' МГц';
end;

end.

