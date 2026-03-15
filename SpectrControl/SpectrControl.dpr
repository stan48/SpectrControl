{$A-,H+}
program SpectrControl;

uses
  Forms,
  IniFiles,
  Windows,
  SysUtils,
  mainform in 'mainform.pas' {Main},
  parametres in 'parametres.pas' {parform},
  DFS in 'DFS.pas' {DFS52},
  timef in 'timef.pas' {timeform},
  Measuring in 'Measuring.pas',
  dfscontrol in 'dfscontrol.pas',
  logof in 'logof.pas' {logo},
  Startup in 'Startup.pas',
  proc in 'proc.pas' {fmProc},
  about in 'about.pas' {frmAbout},
  crypt in 'crypt.pas',
  Spectrum in 'Spectrum.pas',
  SpectrumCollection in 'SpectrumCollection.pas',
  Drawer in 'Drawer.pas',
  FileHandler in 'FileHandler.pas',
  substruction in 'substruction.pas',
  peak in 'peak.pas',
  process in 'process.pas',
  SpecialTypes in 'SpecialTypes.pas',
  peaksForm in 'peaksForm.pas';

{$R *.RES}
procedure getosinfo;
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
      logof.logo.lbOs.Caption := Format('%s %d.%d (Build %d)', [platform, Win32MajorVersion, Win32MinorVersion, BuildNumber])
    else
      logof.logo.lbOs.Caption := Format('%s %d.%d (Build %d: %s)', [platform, Win32MajorVersion, Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    logof.logo.lbOs.Caption := Format('%s %d.%d', [platform, Win32MajorVersion, Win32MinorVersion])
end;

var
  hMutex: THandle;

begin
  hMutex := CreateMutex(nil, False, 'UniqueProgrammMutex');
  if WaitForSingleObject(hMutex, 0) <> wait_TimeOut then
  begin
    Application.Initialize;
    logo := tlogo.Create(Application);
    getosinfo;

    logo.Position := poDesktopCenter;
    logo.lbVers.Caption := main.ApplicationVersion;
    logo.Show;

    logo.Update;

    Application.Title := 'ДФС52: Управление';
    Application.CreateForm(TMain, Main);
    Application.CreateForm(Tparform, parform);
    Application.CreateForm(Ttimeform, timeform);
    Application.CreateForm(TDFS52, DFS52);
    Application.CreateForm(TfmProc, fmProc);
    Application.CreateForm(TfrmAbout, frmAbout);
    Application.CreateForm(TPeaksForm, pksForm);
    Application.Run;
  end
end.
