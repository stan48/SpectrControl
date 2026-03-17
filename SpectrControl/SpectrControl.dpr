{$A-,H+}
program SpectrControl;

uses
  Forms,
  IniFiles,
  Windows,
  SysUtils,
  mainform in 'MAINFORM.pas' {Main},
  parametres in 'parametres.pas' {parform},
  DFS in 'DFS.pas' {DFS52},
  timef in 'timef.pas' {timeform},
  Measuring in 'Measuring.pas',
  dfscontrol in 'dfscontrol.pas',
  logof in 'logof.pas' {logo},
  Startup in 'Startup.pas',
  proc in 'proc.pas' {fmProc},
  AboutForm in 'AboutForm.pas' {frmAbout},
  crypt in 'crypt.pas',
  Spectrum in 'Spectrum.pas',
  SpectrumCollection in 'SpectrumCollection.pas',
  Drawer in 'Drawer.pas',
  FileHandler in 'FileHandler.pas',
  substruction in 'substruction.pas',
  peak in 'peak.pas',
  process in 'process.pas',
  SpecialTypes in 'SpecialTypes.pas',
  peaksForm in 'peaksForm.pas',
  io in 'io.pas',
  FloatUtils in 'FloatUtils.pas',
  SysInfo in 'SysInfo.pas';

{$R *.RES}

var
  hMutex: THandle;

begin
  hMutex := CreateMutex(nil, False, 'DFS52MTX');
  if WaitForSingleObject(hMutex, 0) <> wait_TimeOut then
  begin
    Application.Initialize;
    logo := tlogo.Create(Application);
    logo.lbOs.Caption := SysInfo.GetOSVersionShort;

    logo.Position := poScreenCenter;
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
