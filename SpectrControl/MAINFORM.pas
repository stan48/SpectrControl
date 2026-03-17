{$A-,H+}
unit mainform;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ComCtrls,
  ExtCtrls, Menus, IniFiles, io, Dialogs, Math, MessDlgs, XiButton, logof,
  AppEvnts, AboutForm, crypt, SpectrumCollection, Spectrum, Drawer, FileHandler,
  substruction, process, SpecialTypes, ImgList, ToolWin, FloatUtils, SysInfo;

type
  TMain = class(TForm)
    SaveDialog: TSaveDialog;
    pnSpectr: TPanel;
    ilTool: TImageList;
    cbMenuBar: TControlBar;
    mboxmenu: TPopupMenu;
    mbreset: TMenuItem;
    lwmenu: TPopupMenu;
    lvEdit: TMenuItem;
    lvSave: TMenuItem;
    pnBottom: TPanel;
    pnScan: TPanel;
    MeasuringBox: TGroupBox;
    Label6: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    lbFrom: TLabel;
    lbTo: TLabel;
    lbSPM: TLabel;
    lbspeed: TLabel;
    Label1: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    eInterval: TEdit;
    eFrom: TEdit;
    eTowards: TEdit;
    StaticText1: TStaticText;
    espm: TComboBox;
    eActLine: TComboBox;
    eOver: TEdit;
    ePause: TEdit;
    HBox: TGroupBox;
    shapeHV: TShape;
    cbHigh: TCheckBox;
    cbAttention: TCheckBox;
    DirectionBox: TGroupBox;
    rbRight: TRadioButton;
    rbLeft: TRadioButton;
    pnGraph: TPanel;
    lwSpectrumList: TListView;
    Splitter: TSplitter;
    pnEngine: TPanel;
    boxX: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    exmin: TEdit;
    exmax: TEdit;
    boxY: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    eymin: TEdit;
    eymax: TEdit;
    lvDelete: TMenuItem;
    xbApplyGraph: TXiButton;
    ae1: TApplicationEvents;
    ehv: TEdit;
    Label2: TLabel;
    lbHv: TLabel;
    dlgOpenFile: TOpenDialog;
    lvProc: TMenuItem;
    Label4: TLabel;
    dlgSaveFile: TSaveDialog;
    lvDeleteAll: TMenuItem;
    xbStartMeasuring: TXiButton;
    xbOptimizeGraph: TXiButton;
    mbox: TPaintBox;
    lbCorrds: TLabel;
    mbDel: TMenuItem;
    lwSubstuct: TMenuItem;
    lvFindPeaks: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    btn1: TToolButton;
    btnGoToPosition: TToolButton;
    N1: TMenuItem;
    N2: TMenuItem;
    pbEngine: TPaintBox;
    lbl1: TLabel;

    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure btnGoToPositionClick(Sender: TObject);
    procedure lwSubstuctClick(Sender: TObject);

    procedure mbDelClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbHighClick(Sender: TObject);
    procedure tbParClick(Sender: TObject);
    procedure tbDFSClick(Sender: TObject);
    procedure mboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure mboxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure mbResetClick(Sender: TObject);
    procedure mboxPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure xbStartMeasuringClick(Sender: TObject);

    procedure lwSpectrumListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lwSpectrumListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lwSpectrumListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lwSpectrumListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvEditClick(Sender: TObject);

    procedure lvSaveClick(Sender: TObject);
    procedure exminKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure exmaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eyminKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eymaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure tbCymometrClick(Sender: TObject);
    procedure lvDeleteClick(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure xbApplyGraphClick(Sender: TObject);
    procedure ae1Exception(Sender: TObject; E: Exception);
    procedure tbNewBaseClick(Sender: TObject);
    procedure tbOpenBaseClick(Sender: TObject);
    procedure lvProcClick(Sender: TObject);
    procedure tbInitClick(Sender: TObject);
    procedure lvDeleteAllClick(Sender: TObject);
    procedure xbOptimizeGraphClick(Sender: TObject);
    procedure tbAboutClick(Sender: TObject);
    procedure pbEnginePaint(Sender: TObject);

  private
  { Private declarations }
    procedure LoadFile(fileName: string);
    procedure SaveFile(fileName: string);
    procedure SaveToFile(name: WideString; spectr: TSpectrum);
    procedure Start_SM_RightScan(steps: Byte; overridePause: Cardinal);
    procedure Start_SM_LeftScan(steps: Byte; overridePause: Cardinal);
    procedure Start_NM_LeftScan(steps: Byte; overridePause: Cardinal);
    procedure Start_NM_RightScan(steps: Byte; overridePause: Cardinal);
    function WaitNexStep(overridePause: cardinal; isAvg: boolean): boolean;
    function CalcTickStep(Range: Double; PixelWidth: Integer): Double;
    procedure DrawScale(Canvas: TCanvas; W, H: Integer);

  public
    { Public declarations }
    procedure Start_Point_Scan;
    procedure SetHz;
    function Average: TSpectrum;
    procedure RefreshTable;
    procedure PaintEngine;
    procedure RefreshDrawer(drawer: TDrawer);
    function ApplicationVersion: string;

  end;

var
  Main: TMain;
  Interval: cardinal;
  HighVoltage: byte;
  HvOff: cardinal;
  SpectrumList: TSpectrumCollection;
  WhatMatrix: byte;
  F, E, L: cardinal;
  T: integer;
  a, b, c: double;
  MinNM, MaxNM: double;
  MinSM, MaxSM: double;
  isAveraging: boolean;
  rep, fin, repfin: byte;
  currentYScale: TScaleYType;
  currentXScale: TScaleXType;
  a1, b1: real;
  MinNM1, MaxNM1: double;
  MinSM1, MaxSM1: double;
  CurrentStep: cardinal;
  j: byte;
  drawer: TDrawer;
  Stream: TFileStream;
  rotMarker: Boolean;
  sItem: TSubstractionItem;
  subtraction: TSubstruction;
  handler: TFileHandler;
  FAxisMin: Double;
  FAxisMax: Double;
  FCurrentPos: Double;

const
  ArrPhase: array[0..3] of byte = (3, 6, 12, 9);

const
  Vers: string = '2.5.6';

const
  paramError = 'Некорректные параметры!';

const
  internalError = 'Внутренняя ошибка программы! Постарайтесь вспомнить, чего такого страшного Вы сделали и свяжитесь с разарботчикамми.';

implementation

uses
  parametres, timef, dfs, measuring, dfscontrol, startup, proc, peaksForm;

{$R *.DFM}
{$R-}

procedure TMain.FormCreate(Sender: TObject);
var
  ini: tinifile;
  bt: byte;
begin

  Self.DoubleBuffered := True;  // убирает мерцание - WM_ERASEBKGND рисует в буфер

  logo.lbcpu.Caption := SysInfo.GetCPUName;
  HighVoltage := 0;
  j := 0;

  ini := TiniFile.Create(extractfilepath(paramstr(0)) + 'conf.ini');
  Lattice := ini.ReadInteger('CurrentLattice', 'Lattice', 0);
  Currentstep := ini.ReadInteger('step', 'current', 0);
  pass := crypt.DecryptEX(ini.ReadString('par', 'ps', '000'));

  bt := ini.ReadInteger('Scale', 'xtype', 1);
  case bt of
    0:
      currentXScale := steps;
    1:
      currentXScale := sm;
    2:
      currentXScale := nm;
    3:
      currentXScale := seconds;
  else
    currentXScale := sm;
  end;

  bt := ini.ReadInteger('Scale', 'ytype', 0);
  case bt of
    0:
      currentYScale := hertz;
    1:
      currentYScale := impulse;
  else
    currentYScale := hertz;
  end;

  efrom.Text := ini.Readstring('par', 'from', '500');
  eTowards.Text := ini.Readstring('par', 'tow', '520');
  espm.Text := ini.Readstring('par', 'int', '1,000');
  exmin.Text := ini.Readstring('par', 'xmin', '200');
  exmax.Text := ini.Readstring('par', 'xmax', '300');
  eymin.Text := ini.Readstring('par', 'ymin', '0');
  eymax.Text := ini.Readstring('par', 'ymax', '1000');

  einterval.Text := ini.Readstring('par', 'speed', '1000');
  ini.Free;
  SetHz;

  parform.GetIniParametres(Lattice);

  messdlgs.MsgOptions.UseGradient := true;
  messdlgs.MsgOptions.UseShapedForm := true;
  messdlgs.MsgOptions.UseBorder := false;
  messdlgs.MsgOptions.UseCustomFont := true;
  messdlgs.MsgOptions.UseCustomButtons := true;
  messdlgs.MsgOptions.UseCustomPanel := true;
  messdlgs.MsgOptions.CustomButtonsColorScheme := btncsNeoSilver;
  messdlgs.MsgOptions.CustomPanelColorScheme := pnlcsSilver;
  messdlgs.MsgOptions.CustomProgressColorScheme := procsSilver;
  messdlgs.MsgOptions.DefLang := ltRussian;

  startup.StartDriver;

 //io.PortWriteByte($37a,$0c);
// io.PortWriteByte($378,$0);

  ex := false;
  rotMarker := False;
  if StartCheckStatus = true then
    startup.Test;
  if ex = true then
    system.Exit;

  SpectrumList := TSpectrumCollection.Create();
  drawer := TDrawer.Create(mbox, SpectrumList);

  drawer.XScale := currentXScale;
  drawer.YScale := currentYScale;

  Self.xbApplyGraph.OnClick(Self);
  main.PaintEngine;
  main.RefreshTable;

// io.PortWriteByte($37a,$0c);
// io.PortWriteByte($378,$0);

  subtraction := TSubstruction.Create;
  drawer.Points := subtraction;

  if hints = true then
    main.ShowHint := true
  else
    main.ShowHint := false;

  // инициализация шкалы до первого вызова PaintEngine
  FAxisMin := 0;
  FAxisMax := 1;
  FCurrentPos := 0;
  pbEngine.OnPaint := pbEnginePaint;
end;

procedure TMain.FormShow(Sender: TObject);
var
  lat: string;
begin
  if logo.Showing then
  begin
    logo.Free;
  end;

  if currentXScale = sm then
    parform.NM2SM
  else
    parform.SM2NM;
  parform.SetScaleParametres(currentXScale);

  if Lattice = 0 then
    lat := '1200'
  else
    lat := '1800';
  main.Caption := 'ДФС-52 ' + '[Решетка ' + lat + ' штрихов/мм.]';

  application.Title := main.Caption;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TiniFile;
begin

  if MessageDlg('Вы действительно хотите выйти из программы с потерей всех несохраненных результатов?', mtConfirmation, mbOkCancel, 0) = mrOk then
    Action := caFree
  else
  begin
    Action := caNone;
    system.Exit;
  end;

  ini := TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'conf.ini');
  ini.WriteInteger('step', 'current', currentstep);
  ini.writestring('par', 'from', efrom.Text);
  ini.writestring('par', 'tow', eTowards.Text);
  ini.writestring('par', 'int', espm.Text);
  ini.writestring('par', 'speed', einterval.Text);
  ini.writestring('par', 'xmin', exmin.Text);
  ini.writestring('par', 'xmax', exmax.Text);
  ini.writestring('par', 'ymin', eymin.Text);
  ini.writestring('par', 'ymax', eymax.Text);

  ini.free;

  io.PortWriteByte($37a, $0c);
  io.PortWriteByte($378, 0);
  startup.StopDriver;
end;

procedure TMain.Start_SM_LeftScan(steps: Byte; overridePause: Cardinal);
var
  u: Integer;
  minx, maxx, Act, From, Towords, spm, int: real;
  coment, parameters: string;
  pl: byte;
  avg: boolean;
  cStep: byte;
  laser: boolean;
  Spectrum: TSpectrum;
  tempStart: Cardinal;
label
  next, nextstep;
begin
  try
    Act := StrToFloatSafe(eactline.Text);
    From := StrToFloatSafe(efrom.Text);
    Towords := StrToFloatSafe(eTowards.Text);
    spm := StrToFloatSafe(espm.Text);
    int := StrToFloatSafe(einterval.Text);
    HvOff := strtoint(ehv.Text);
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if SpectrumList.Count > 0 then
  begin
    if (SpectrumList[0].ScaleX = seconds) then
    begin
      pl := messdlgs.MessageDlg('Все результаты сканирования по времени будут удалены. Продолжить?', mtConfirmation, [mbYes, mbNo], 0);
      if pl = 7 then
        system.Exit;
      if pl = 6 then
      begin
        SpectrumList.Clear;
        main.RefreshTable;
        drawer.Refresh;
      end;
    end;
  end;

  if (Act <= 0) or (From <= 0) or (Towords <= 0) or (spm <= 0) or (int <= 0) or (hvoff <= 0) or (overridePause <= 0) then
  begin
    messdlgs.Showerror(ParamError);
    drawer.Refresh;
    system.Exit;
  end;

  if From > Towords then
  begin
    messdlgs.Showerror(ParamError);
    main.eFrom.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if (Act > (b + c + (a * 225000))) or (Act < (b + c)) then
  begin
    messdlgs.Showerror('Ошибка диапазона!');
    drawer.Refresh;
    main.eActLine.SetFocus;
    system.Exit;
  end;

  if (Act - (Towords)) <= (b + c) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    drawer.Refresh;
    system.Exit;
  end;

  if int > 3000 then
  begin
    showerror('Скорость слишком велика!');
    main.eInterval.SetFocus;
    system.Exit;
  end;
  if spm < (a) then
  begin
    showerror('Слишком маленький шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;
  if spm > (abs(Towords - From)) then
  begin
    showerror('Слишком большой шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;

  if (comentstatus = true) and (rotMarker <> True) then
    coment := messdlgs.InputBox('', 'Введите комментарий', '')
  else
    coment := '';
  parameters := '<-- ' + efrom.Text + ':' + eTowards.Text;

  minx := min(From, Towords);
  maxx := max(From, Towords);
  exmin.Text := floattostr(minx);
  exmax.Text := floattostr(maxx);
  main.xbApplyGraph.OnClick(self);
  cStep := 0;
  application.ProcessMessages;

  L := round((Act - (b + c)) / a);
  F := round(((Act - From) - (b + c)) / a);
  T := abs(round(((Towords - From) / a)));
  E := round(spm / a);
  Interval := trunc(1000000 / ((int / 60) / a));

NextStep:
  laser := false;
  if currentstep > L then
  begin
    messdlgs.MessageDlg('Внимание, при перестройке монохроматора может быть пройдена возбуждающая линия. Закройте шторку на выходе лазера!', mtWarning, [mbOk], 0);
    laser := true;
  end;
  drawer.Refresh;
  application.ProcessMessages;

  inc(cStep);
  if (steps > 1) and (isAveraging = true) then
    avg := true
  else
    avg := false;

  if rotMarker = True then
  begin
    tempStart := Starting;
    Starting := 1;
  end;

  if currentstep = F then
  begin
    dfscontrol.RewindFRW(starting, ret);
    goto next;
  end;

  if currentstep < F then
  begin
    u := F + starting - currentstep;
    dfscontrol.RewindFRW(Abs(u), ret);
    goto next;
  end;

  if currentstep > F then
  begin
    u := Currentstep - (F + starting);
    dfscontrol.RewindREW(Abs(u), ret);
  end;
next:

  if rotMarker = True then
  begin
    rotMarker := False;
    Starting := tempStart;
    Exit;
  end;

  Spectrum := TSpectrum.Create(SpectrumList, sm, currentYScale, parform.SelectColor, true, parameters, sysutils.Date + sysutils.Time, round(T / E), coment, avg);

  if laser = true then
    messdlgs.MessageDlg('Подготовка к сканированию завершена. Откройте шторку на выходе лазера.', mtwarning, [mbOk], 0);
  drawer.Refresh;
  application.ProcessMessages;

  if cbAttention.Checked = false then
    HvOff := 10000000;
  if HighVoltage = 0 then
    dfscontrol.HW_Status(true);

  MesReverse := TMesThreadREW.Create(Spectrum, T, E, interval, Act);
  MesReverse.Priority := tpTimeCritical;

  application.ProcessMessages;

  MesReverse.Resume;
  MesReverse.WaitFor;
  MesReverse.Free;

  application.ProcessMessages;

  if isAveraging = False then
    Main.RefreshTable;

  if cStep <> steps then
    if Main.WaitNexStep(overridePause, avg) = false then
      goto NextStep;

  Main.Average;
  Main.RefreshTable;

end;

procedure TMain.Start_SM_RightScan(steps: Byte; overridePause: Cardinal);
var
  u: Integer;
  Act, From, Towords, spm, int: real;
  coment, pr: string;
  minx, maxx: real;
  wp: cardinal;
  cStep, pl: byte;
  avg, laser: boolean;
  spectrum: TSpectrum;
  tempstart: Cardinal;
label
  next, nextstep;
begin
  try
    Act := StrToFloatSafe(eactline.Text);
    From := StrToFloatSafe(efrom.Text);
    Towords := StrToFloatSafe(eTowards.Text);
    spm := StrToFloatSafe(espm.Text);
    int := StrToFloatSafe(einterval.Text);
    HvOff := strtoint(ehv.Text);
    wp := round(StrToFloatSafe(epause.Text));
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if SpectrumList[0].ScaleX = seconds then
  begin
    pl := messdlgs.MessageDlg('Все результаты сканирования по времени будут удалены. Продолжить?', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 7 then
      system.Exit;
    if pl = 6 then
    begin
      SpectrumList.Clear;
      main.RefreshTable;
      drawer.Refresh;
    end;
  end;

  if (Act <= 0) or (From <= 0) or (Towords <= 0) or (spm <= 0) or (int <= 0) or (hvoff <= 0) or (wp <= 0) then
  begin
    messdlgs.Showerror(ParamError);
    drawer.Refresh;
    system.Exit;
  end;

  if From > Towords then
  begin
    messdlgs.Showerror(ParamError);
    main.eFrom.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if (Act > (b + c + (a * 225000))) or (Act < (b + c)) then
  begin
    messdlgs.Showerror('Ошибка диапазона!');
    drawer.Refresh;
    main.eActLine.SetFocus;
    system.Exit;
  end;

  if (Act + Towords) >= (c + b + a * 225000) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    drawer.Refresh;
    system.Exit;
  end;

  if int > 3000 then
  begin
    showerror('Скорость слишком велика!');
    main.eInterval.SetFocus;
    system.Exit;
  end;
  if spm < (a) then
  begin
    showerror('Слишком маленький шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;
  if spm > (abs(Towords - From)) then
  begin
    showerror('Слишком большой шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;

  if (comentstatus = true) and (rotMarker <> True) then
    coment := messdlgs.InputBox('', 'Введите комментарий', '')
  else
    coment := '';
  pr := '<-- ' + efrom.Text + ':' + eTowards.Text;

  minx := min(From, Towords);
  maxx := max(From, Towords);
  exmin.Text := floattostr(minx);
  exmax.Text := floattostr(maxx);
  cStep := 0;
  main.xbApplyGraph.OnClick(self);
  application.ProcessMessages;

  L := round((Act - (b + c)) / a);
  F := (L + round(From / a));
  T := abs(round(((Towords - From) / a)));
  E := round(spm / a);
  Interval := trunc(1000000 / ((int / 60) / a));

  laser := false;
  if currentstep < L then
  begin
    messdlgs.MessageDlg('Внимание, при перестройке монохроматора может быть пройдена возбуждающая линия. Закройте шторку на выходе лазера!', mtWarning, [mbOk], 0);
    laser := true;
  end;
  drawer.Refresh;
  application.ProcessMessages;

NextStep:
  inc(cStep);
  if (steps > 1) and (isAveraging = true) then
    avg := true
  else
    avg := false;

  if rotMarker = True then
  begin
    tempstart := Starting;
    Starting := 1;
  end;

  if currentstep = F then
  begin
    dfscontrol.RewindREW(starting, ret);
    goto next;
  end;

  if currentstep < F then
  begin
    u := F - starting - currentstep;
    dfscontrol.RewindFRW(Abs(u), ret);
    goto next;
  end;

  if currentstep > F then
  begin
    u := starting + currentstep - F;
    dfscontrol.RewindREW(Abs(u), ret);
  end;
next:

  if rotMarker = True then
  begin
    rotMarker := False;
    Starting := tempstart;
    Exit;
  end;

  spectrum := TSpectrum.Create(SpectrumList, sm, currentYScale, parform.SelectColor, true, pr, sysutils.Date + sysutils.Time, round(T / E), coment, avg);

  if laser = true then
    messdlgs.MessageDlg('Подготовка к сканированию завершена. Откройте шторку на выходе лазера.', mtwarning, [mbOk], 0);
  drawer.Refresh;
  application.ProcessMessages;

  if cbAttention.Checked = false then
    HvOff := 10000000;
  if HighVoltage = 0 then
    dfscontrol.HW_Status(true);

  MesForward := tmesthreadfrw.Create(spectrum, T, E, interval, Act);
  MesForward.Priority := tpTimeCritical;

  application.ProcessMessages;

  MesForward.Resume;
  MesForward.WaitFor;
  MesForward.Free;

  drawer.Refresh;
  application.ProcessMessages;

  if isAveraging = False then
    Main.RefreshTable;

  if cStep <> steps then
    if Main.WaitNexStep(overridePause, avg) = false then
      goto NextStep;

  Main.Average;
  Main.RefreshTable;
end;

procedure TMain.Start_NM_LeftScan(steps: Byte; overridePause: Cardinal);
var
  u: Integer;
  minx, maxx, from, upto, spm, int: real;
  coment, pr: string;
  cStep, pl: byte;
  wp: integer;
  spectrum: TSpectrum;
  avg: boolean;
  tempStart: Cardinal;
label
  next, nextstep;
begin
  try
    from := 10000000 / (StrToFloatSafe(efrom.Text));
    upto := 10000000 / (StrToFloatSafe(eTowards.Text));
    spm := StrToFloatSafe(espm.Text);
    int := StrToFloatSafe(einterval.Text);
    HvOff := strtoint(ehv.Text);
    wp := round(StrToFloatSafe(epause.Text));
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if SpectrumList[0].ScaleX = seconds then
  begin
    pl := messdlgs.MessageDlg('Все результаты сканирования по времени будут удалены. Продолжить?', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 7 then
      system.Exit;
    if pl = 6 then
    begin
      SpectrumList.Clear;
      main.RefreshTable;
      drawer.Refresh;
    end;
  end;

  if (from <= 0) or (upto <= 0) or (spm <= 0) or (int <= 0) or (hvoff <= 0) or (wp <= 0) then
  begin
    messdlgs.Showerror(ParamError);
    drawer.Refresh;
    system.Exit;
  end;

  if (from < (b + c)) or (from > (b + c + (225000 * a))) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    main.eFrom.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if (upto < (b + c)) or (upto > (b + c + (225000 * a))) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    main.eTowards.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if int > 3000 then
  begin
    showerror('Скорость слишком велика!');
    main.eInterval.SetFocus;
    system.Exit;
  end;
  if spm < (a) then
  begin
    showerror('Слишком маленький шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;
  if spm > (abs(from - upto)) then
  begin
    showerror('Слишком большой шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;

  if (comentstatus = true) and (rotMarker <> True) then
    coment := messdlgs.InputBox('', 'Введите комментарий', '')
  else
    coment := '';
  pr := efrom.Text + ':' + eTowards.Text;

  cStep := 0;
  minx := min((StrToFloatSafe(efrom.Text)), (StrToFloatSafe(eTowards.Text)));
  maxx := max((StrToFloatSafe(efrom.Text)), (StrToFloatSafe(eTowards.Text)));
  exmin.Text := floattostr(minx);
  exmax.Text := floattostr(maxx);

  main.xbApplyGraph.OnClick(self);
  application.ProcessMessages;

  F := round((from - (b + c)) / a);
  T := abs(round((from - upto) / a));
  E := round(spm / a);
  Interval := trunc(1000000 / ((int / 60) / a));

NextStep:
  inc(cStep);
  if (steps > 1) and (isAveraging = true) then
    avg := true
  else
    avg := false;

  if rotMarker = True then
  begin
    tempStart := Starting;
    Starting := 1;
  end;

  if currentstep = F then
  begin
    dfscontrol.RewindFRW(starting, ret);
    goto next;
  end;

  if currentstep < F then
  begin
    u := F + starting - currentstep;
    dfscontrol.RewindFRW(Abs(u), ret);
    goto next;
  end;

  if currentstep > F then
  begin
    u := Currentstep - (F + starting);
    if u < 0 then
    begin
      dfscontrol.RewindFRW(abs(u), ret);
      goto next;
    end;
    dfscontrol.RewindREW(Abs(u), ret);
  end;
next:

  if rotMarker = True then
  begin
    rotMarker := False;
    Starting := tempStart;
    Exit;
  end;

  spectrum := TSpectrum.Create(SpectrumList, nm, currentYScale, parform.SelectColor, true, pr, sysutils.Date + sysutils.Time, round(T / E), coment, avg);

  if cbAttention.Checked = false then
    HvOff := 10000000;
  if HighVoltage = 0 then
    dfscontrol.HW_Status(true);

  MesReverse := tmesthreadrew.Create(spectrum, T, E, interval, 0);
  MesReverse.Priority := tpTimeCritical;
  application.ProcessMessages;
  MesReverse.Resume;
  MesReverse.WaitFor;
  MesReverse.Free;

  Application.ProcessMessages;

  if isAveraging = False then
    Main.RefreshTable;

  if cStep <> steps then
    if Main.WaitNexStep(overridePause, avg) = false then
      goto NextStep;

  Main.Average;
  Main.RefreshTable;
end;

procedure TMain.Start_NM_RightScan(steps: Byte; overridePause: Cardinal);
var
  u: integer;
  From, upto, spm, int: real;
  coment, pr: string;
  minx, maxx: real;
  cStep, pl: byte;
  wp: cardinal;
  spectrum: TSpectrum;
  avg: boolean;
  tempStart: Cardinal;
label
  next, nextstep;
begin
  try
    From := 10000000 / (StrToFloatSafe(efrom.Text));
    upto := 10000000 / (StrToFloatSafe(eTowards.Text));
    spm := StrToFloatSafe(espm.Text);
    int := StrToFloatSafe(einterval.Text);
    HvOff := strtoint(ehv.Text);
    wp := round(StrToFloatSafe(epause.Text));
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if SpectrumList[0].ScaleX = seconds then
  begin
    pl := messdlgs.MessageDlg('Все результаты сканирования по времени будут удалены. Продолжить?', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 7 then
      system.Exit;
    if pl = 6 then
    begin
      SpectrumList.Clear;
      main.RefreshTable;
      drawer.Refresh;
    end;
  end;

  if (From <= 0) or (upto <= 0) or (spm <= 0) or (int <= 0) or (hvoff <= 0) or (wp <= 0) then
  begin
    messdlgs.Showerror(ParamError);
    drawer.Refresh;
    system.Exit;
  end;

  if (From < (b + c)) or (From > (b + c + (225000 * a))) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    main.eFrom.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if (upto < (b + c)) or (upto > (b + c + (225000 * a))) then
  begin
    messdlgs.ShowError('Ошибка диапазона!');
    main.eTowards.SetFocus;
    drawer.Refresh;
    system.Exit;
  end;

  if int > 3000 then
  begin
    showerror('Скорость слишком велика!');
    main.eInterval.SetFocus;
    system.Exit;
  end;
  if spm < (a) then
  begin
    showerror('Слишком маленький шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;
  if spm > (abs(From - upto)) then
  begin
    showerror('Слишком большой шаг!');
    main.espm.SetFocus;
    system.Exit;
  end;

  if (comentstatus = true) and (rotMarker <> True) then
    coment := messdlgs.InputBox('', 'Введите комментарий', '')
  else
    coment := '';
  pr := efrom.Text + ':' + eTowards.Text;

  minx := min((StrToFloatSafe(efrom.Text)), (StrToFloatSafe(eTowards.Text)));
  maxx := max((StrToFloatSafe(efrom.Text)), (StrToFloatSafe(eTowards.Text)));
  exmin.Text := floattostr(minx);
  exmax.Text := floattostr(maxx);
  cStep := 0;

  main.xbApplyGraph.OnClick(self);
  application.ProcessMessages;

  F := round((From - (c + b)) / a);
  T := abs(round((upto - From) / a));
  E := round(spm / a);
  Interval := trunc(1000000 / ((int / 60) / a));

NextStep:
  inc(cStep);
  if (steps > 1) and (isAveraging = true) then
    avg := true
  else
    avg := false;

  if rotMarker = True then
  begin
    tempStart := Starting;
    Starting := 1;
  end;

  if currentstep = F then
  begin
    dfscontrol.RewindREW(starting, ret);
    goto next;
  end;

  if currentstep < F then
  begin
    u := F - starting - currentstep;
    if u < 0 then
    begin
      dfscontrol.RewindREW(abs(u), ret);
      goto next;
    end;
    dfscontrol.RewindFRW(u, ret);
    goto next;
  end;

  if currentstep > F then
  begin
    u := starting + currentstep - F;
    dfscontrol.RewindREW(u, ret);
  end;
next:

  if rotMarker = True then
  begin
    rotMarker := False;
    Starting := tempStart;
    Exit;
  end;

  spectrum := TSpectrum.Create(SpectrumList, nm, currentYScale, parform.SelectColor, true, pr, sysutils.Date + sysutils.Time, round(T / E), coment, avg);

  if cbAttention.Checked = false then
    HvOff := 10000000;
  if HighVoltage = 0 then
    dfscontrol.HW_Status(true);

  MesForward := tmesthreadfrw.Create(spectrum, T, E, interval, 0);
  MesForward.Priority := tpTimeCritical;
  application.ProcessMessages;
  MesForward.Resume;
  MesForward.WaitFor;
  MesForward.Free;

  drawer.Refresh;
  application.ProcessMessages;

  if isAveraging = False then
    Main.RefreshTable;

  if cStep <> steps then
    if Main.WaitNexStep(overridePause, avg) = false then
      goto NextStep;

  Main.Average;
  Main.RefreshTable;

end;

procedure TMain.Start_Point_Scan;
var
  u: cardinal;
  act, place, AllTime, Discr: real;
  D, T, pl: cardinal;
  p: cardinal;
  coment, pr: string;
  spectrum: tspectrum;
label
  next, nextstep;
begin
  if (SpectrumList[0].ScaleX <> seconds) and (SpectrumList[0].ScaleX <> steps) then
  begin
    pl := messdlgs.MessageDlg('Переход в режим сканирования по времени удалит все предыдущие результаты. Продолжить?', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 7 then
      system.Exit;
    if pl = 6 then
    begin
      SpectrumList.Clear;
      main.RefreshTable;
    end;
  end;

  drawer.Refresh;

  try
    act := StrToFloatSafe(eactline.Text);
    place := StrToFloatSafe(efrom.Text);
    AllTime := StrToFloatSafe(timeform.eTime.Text);
    Discr := StrToFloatSafe(timeform.eDiscr.Text);
    HvOff := strtoint(main.ehv.Text);
  except
    on EConvertError do
    begin
      messdlgs.ShowError(Paramerror);
      system.Exit;
    end;
  end;

  T := round(AllTime * 1000000);
  D := round(Discr * 1000);

  case currentXScale of
    sm:
      begin
        if rbleft.Checked then
          p := round(((act - place) - (b + c)) / a);
        if rbright.Checked then
          p := round(((act + place) - (b + c)) / a);
      end;

    nm:
      begin
        place := 10000000 / place;
        p := round((place - (b + c)) / a);
      end;
  end;

  if (p <= 0) or (p >= 225000) then
  begin
    showerror('Ошибка диапазона!');
    main.efrom.SetFocus;
    system.Exit;
  end;

  if comentstatus = true then
    coment := messdlgs.InputBox('', 'Введите комментарий', '')
  else
    coment := '';
  pr := timeform.eTime.Text + ' c. : ' + timeform.eDiscr.Text + ' мс.';

  if cbAttention.Checked = false then
    HvOff := 10000000;

nextstep:
  spectrum := TSpectrum.Create(SpectrumList, seconds, currentYScale, parform.SelectColor, true, pr, sysutils.Date + sysutils.Time, (round(T / E) + 1), coment, false);

  if currentstep = p then
    goto next;

  if currentstep < p then
  begin
    u := p - currentstep;
    dfscontrol.RewindFRW(u, ret);
    goto next;
  end;

  if currentstep > p then
  begin
    u := currentstep - p;
    dfscontrol.RewindREW(u, ret);
  end;

next:
  main.exmin.Text := '0';
  main.exmax.Text := floattostr(AllTime);

  if HighVoltage = 0 then
    dfscontrol.HW_Status(true);

  Mestime := tmesthreadtime.Create(spectrum, D, T);
  mestime.Priority := tpTimeCritical;
  drawer.Refresh;
  application.ProcessMessages;
  mestime.Resume;
  mestime.WaitFor;
  mestime.Free;

  main.RefreshTable;

  main.xbApplyGraph.OnClick(self);
  application.ProcessMessages;
end;

procedure TMain.tbInitClick(Sender: TObject);
begin
  if messdlgs.MessageDlg('Выполнить установку в начало шкалы?', mtConfirmation, [mbYes, mbCancel], 0) = 6 then
    dfscontrol.SetNull;
end;

procedure TMain.tbCymometrClick(Sender: TObject);
begin
  dfscontrol.Cymomentr;
end;

procedure TMain.tbParClick(Sender: TObject);
begin
  parform.ShowModal;
end;

procedure TMain.tbNewBaseClick(Sender: TObject);
begin
  if (SpectrumList.Count > 0) then
  begin
    if (dlgSaveFile.Execute = True) then
      main.SaveFile(dlgSaveFile.FileName)
  end
  else
    ShowError('Спектры отсутствуют!');
end;

procedure TMain.tbOpenBaseClick(Sender: TObject);
begin
  if dlgOpenFile.Execute = True then
    main.LoadFile(dlgOpenFile.FileName);
end;

procedure TMain.tbDFSClick(Sender: TObject);
var
  q: string;
label
  loop, next;
begin
loop:
  q := messdlgs.InputBoxI('', 'Для доступа к этим настройкам введите пароль!', '', ltRussian, true);
  if q = pass then
    goto next;
  if q = '' then
    system.Exit;
  if q <> '' then
  begin
    messdlgs.ShowError('Неверный пароль!');
    goto loop;
  end;

next:

  dfs52.ShowModal;
end;

procedure TMain.tbAboutClick(Sender: TObject);
begin
  frmabout.ShowModal;
end;

procedure TMain.SaveToFile(name: WideString; spectr: TSpectrum);
var
  f: TextFile;
  filter, i: cardinal;
  progress: cardinal;
  point: TPointR;
begin

  if savedialog.execute = true then
    savedialog.InitialDir := extractfilepath(savedialog.FileName)
  else
    system.Exit;

  if parform.cbFilter.Checked = true then
    filter := strtoint(messdlgs.InputBox('', 'Фильтр', '0'))
  else
    filter := 0;

  AssignFile(f, savedialog.FileName);
  Rewrite(f);
  WriteLn(f, '');
  Flush(f);
  CloseFile(f);

  i := 0;
  messdlgs.ShowStatus('Идет сохранение');
  for point in spectr.Matrix do
    if point.Y > filter then
    begin
      Append(f);
      WriteLn(f, Format('%.4f', [point.X]) + '  ' + Format('%.4f', [point.Y]));
    end;
  progress := round(100 * i / spectr.Count);
  messdlgs.UpdateStatus(progress);
  application.ProcessMessages;
  inc(i);

  messdlgs.CloseStatus;
  Flush(f);
  CloseFile(f);
end;

procedure TMain.SetHz;
begin
  if currentYScale = hertz then
  begin
    main.label7.Caption := 'Гц';
    main.label9.Caption := 'Гц';
    main.lbhv.Caption := 'Гц';
  end;

  if currentYScale = impulse then
  begin
    main.label7.Caption := 'имп.';
    main.label9.Caption := 'имп.';
    main.lbhv.Caption := 'имп.';
  end;

end;

procedure TMain.mbResetClick(Sender: TObject);
begin
  drawer.UnZoom;
  mbox.Repaint;
end;

procedure TMain.N1Click(Sender: TObject);
begin
  peaksForm.pksForm.Show;
end;

procedure TMain.N2Click(Sender: TObject);
begin
  SpectrumList[lwSpectrumList.Selected.Index].Peaks.Clear;
  Drawer.Refresh;
end;

{$REGION ' mBox Events '}
procedure TMain.mboxPaint(Sender: TObject);
begin
  drawer.PaintNow;  // рисуем сразу — мы уже внутри WM_PAINT
end;

procedure TMain.mbDelClick(Sender: TObject);
begin
  subtraction.Clear;
  drawer.Refresh;
end;

procedure TMain.mboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ssAlt in Shift) then
    Button := mbLeft;
  drawer.MouseDown(Button, Shift, X, Y);
end;

procedure TMain.mboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  drawer.MouseMove(Shift, X, Y);
end;

procedure TMain.mboxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  point: TPointR;
  i: Cardinal;
begin
  sItem := nil;

  point := drawer.MouseUp(mbLeft, Shift, X, Y);
  ;
  if (point.X <= 0) or (point.Y <= 0) or (point.X > 30000) or (point.Y > 100000000) then
    Exit;

  if (ssAlt in Shift) or (ssShift in Shift) then
  begin
    if subtraction.Count > 0 then
      for i := 0 to subtraction.Count - 1 do
        if ((point.x >= subtraction[i].point.X - drawer.MaxX / 100) and (point.x <= subtraction[i].point.X + drawer.MaxX / 100)) and ((point.y >= subtraction[i].point.y - drawer.MaxY / 100) and (point.y <= subtraction[i].point.y + drawer.MaxY / 100)) then
          sItem := subtraction[i];

    if (Button = mbLeft) and ((ssAlt in Shift)) then
    begin

      TSubstractionItem.Create(subtraction, point);
      subtraction.Sort;
      drawer.Refresh;
      sItem := nil;
    end;
    if (ssShift in Shift) and (sItem <> nil) then
    begin
      subtraction.Delete(sItem.Index);
      subtraction.Sort;
      drawer.Refresh;
      sItem := nil;
    end;
  end;

  eFrom.SetFocus;

end;

procedure TMain.lwSpectrumListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item = nil then
    system.Exit;

  if SpectrumList[Item.Index].Index = Item.Index then
  begin
    Sender.canvas.brush.Color := SpectrumList[Item.Index].Color;
    Sender.Canvas.Font.Color := clwhite;
  end
  else
    Sender.canvas.brush.Color := clwhite;

end;

procedure TMain.lwSpectrumListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item = nil then
    exit;

  if trunc((Item.Index) / 2) < (Item.Index / 2) then
    Sender.canvas.brush.Color := cl3DLight
  else
    Sender.canvas.brush.Color := clwhite;
end;

procedure TMain.lwSpectrumListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: byte;
  Item: TListItem;
  HitTest: THitTests;
begin
  Item := lwSpectrumList.GetItemAt(X, Y);
  HitTest := lwSpectrumList.GetHitTestInfoAt(X, Y);
  if (Item <> nil) and (HitTest = [htOnStateIcon]) then
  begin
    for i := 0 to SpectrumList.Count - 1 do
    begin
      if lwSpectrumList.items.Item[i] = nil then
        system.Break;
      if lwSpectrumList.Items.Item[i].Checked = true then
        SpectrumList[i].Visible := true
      else
        SpectrumList[i].Visible := false;
      drawer.Refresh;
    end;
  end;

end;

procedure TMain.lwSubstuctClick(Sender: TObject);
begin
  process.Subst(spectrumlist[lwSpectrumList.ItemIndex], subtraction);
  Drawer.Refresh;
end;

procedure TMain.lwSpectrumListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  pl: byte;
  lwList: TListView;
begin
  lwList := Sender as TListView;
  if ord(Key) = VK_DELETE then
  begin
    pl := messdlgs.MessageDlg('Удалить выбранный спектр?', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 7 then
      system.Exit;
    if pl = 6 then
      SpectrumList.Delete(lwList.ItemIndex);
  end;
  main.RefreshTable;
  drawer.Refresh;
end;

procedure TMain.lvProcClick(Sender: TObject);
begin
  fmproc.ShowModal;
end;

procedure TMain.lvDeleteAllClick(Sender: TObject);
var
  pl: byte;
begin

  pl := messdlgs.MessageDlg('Удалить все спектры?', mtConfirmation, [mbYes, mbNo], 0);
  if pl = 7 then
    system.Exit;
  if pl = 6 then
  begin
    SpectrumList.Clear;
    main.RefreshTable;
    drawer.Refresh;
  end;
end;

procedure TMain.lvEditClick(Sender: TObject);
begin
  if main.lwSpectrumList.Items[0] = nil then
    system.Exit;
  parform.Show;
  parform.maincontrol.ActivePageIndex := 3;
  parform.tvPar.Items.Item[3].Selected := true;
end;

procedure TMain.lvDeleteClick(Sender: TObject);
var
  pl: byte;
begin
  pl := messdlgs.MessageDlg('Удалить выбранный спектр?', mtConfirmation, [mbYes, mbNo], 0);
  if pl = 7 then
    system.Exit;
  if pl = 6 then
    SpectrumList.Delete(lwSpectrumList.ItemIndex);

  main.RefreshTable;
  drawer.Refresh;
end;

procedure TMain.lvSaveClick(Sender: TObject);
var
  spectr: TSpectrum;
  obj: TObject;
begin
  try
    obj := lwSpectrumList.Items[lwSpectrumList.ItemIndex].data;
    spectr := obj as TSpectrum;
    main.SaveToFile('', spectr);
  except
    on EAccessViolation do
      showmessage('А нечего сохранять!');
  end;
end;

procedure TMain.cbHighClick(Sender: TObject);
begin
  if cbHigh.Checked = true then
    dfscontrol.HW_Status(true);
  if cbHigh.Checked = false then
    dfscontrol.HW_Status(false);
end;

procedure TMain.xbStartMeasuringClick(Sender: TObject);
var
  fr, tow: real;
  nsteps: byte;
  pause: cardinal;
begin

  try
    nsteps := round(StrToFloatSafe(eover.Text));
    fr := StrToFloatSafe(efrom.Text);
    tow := StrToFloatSafe(eTowards.Text);
    pause := round(StrToFloatSafe(ePause.Text));
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;

  if nsteps <= 0 then
  begin
    messdlgs.ShowError(ParamError);
    main.eOver.SetFocus;
    system.Exit;
  end;

  case currentXScale of
    sm:
      begin
        if fr = tow then
        begin
          timeform.Show;
          main.Enabled := false;
          system.Exit;
        end;
        if rbright.Checked then
          main.Start_SM_RightScan(nsteps, pause);
        if rbleft.Checked then
          main.Start_SM_LeftScan(nsteps, pause);
      end;

    nm:
      begin
        if fr = tow then
        begin
          timeform.Show;
          main.Enabled := false;
          system.Exit;
        end;
        if fr < tow then
          main.Start_NM_LeftScan(nsteps, pause);
        if fr > tow then
          main.Start_NM_RightScan(nsteps, pause);
      end;
  end;
end;

procedure TMain.RefreshDrawer(drawer: TDrawer);
var
  minx, miny, maxx, maxy: Integer;
begin

  try
    minx := min(round(StrToFloatSafe(exmin.Text)), round(StrToFloatSafe(exmax.Text)));
    maxx := max(round(StrToFloatSafe(exmin.Text)), round(StrToFloatSafe(exmax.Text)));
    miny := min(round(StrToFloatSafe(eymin.Text)), round(StrToFloatSafe(eymax.Text)));
    maxy := max(round(StrToFloatSafe(eymin.Text)), round(StrToFloatSafe(eymax.Text)));
  except
    on E: EConvertError do
    begin
      exmin.Text := '0';
      exmax.Text := '100';
      eymin.Text := '0';
      eymax.Text := '1000';
      messdlgs.ShowError('Параметры графика заданы неверно.');
      system.Exit;
    end;
  end;

  if (minx < 0) or (maxx <= 0) or (miny < 0) or (maxy <= 0) then
  begin
    exmin.Text := '0';
    exmax.Text := '100';
    eymin.Text := '0';
    eymax.Text := '1000';
    messdlgs.ShowError('Параметры графика заданы неверно.');
    system.Exit;
  end;
  drawer.XScale := currentXScale;
  drawer.YScale := currentYScale;

  drawer.MinX := minx;
  drawer.MaxX := maxx;
  drawer.MinY := miny;
  drawer.MaxY := maxy;

  drawer.Refresh;

end;

procedure TMain.RefreshTable;
var
  i, index: smallint;
  com, dt, pr: string;
begin

  lwSpectrumList.Items.BeginUpdate;  // блокируем перерисовку на время обновления
  try
    lwSpectrumList.Clear;
    if SpectrumList.Count = 0 then
    begin
      for index := 0 to lwmenu.Items.Count - 1 do
        lwmenu.Items.Items[index].Enabled := false;
      system.Exit;
    end;

    for i := 0 to SpectrumList.Count - 1 do
    begin

      lwSpectrumList.AddItem(floattostr(i + 1), SpectrumList[i]);

      com := SpectrumList[i].coment;
      dt := DateTimeToStr(SpectrumList[i].DateTime);
      pr := SpectrumList[i].parameters;

      lwSpectrumList.Items.Item[i].SubItems.Add(com);
      lwSpectrumList.Items.Item[i].SubItems.Add(pr);
      lwSpectrumList.Items.Item[i].SubItems.Add(dt);

      if SpectrumList[i].Visible then
        lwSpectrumList.Items.Item[i].Checked := true
      else
        lwSpectrumList.Items.Item[i].Checked := false;

    end;

    for index := 0 to lwmenu.Items.Count - 1 do
      lwmenu.Items.Items[index].Enabled := true;
  finally
    lwSpectrumList.Items.EndUpdate;  // одна перерисовка вместо N
  end;
end;

procedure TMain.PaintEngine;
begin
  if currentXScale = steps then
  begin
    FAxisMin := -20;
    FAxisMax := 225000;
    FCurrentPos := currentstep;
  end;

  if currentXScale = sm then
  begin
    FAxisMin := minsm - 20;
    FAxisMax := maxsm + 20;
    FCurrentPos := (a * currentstep) + b;
  end;

  if currentXScale = nm then
  begin
    FAxisMin := minnm - 1;
    FAxisMax := maxnm + 1;
    FCurrentPos := 10000000 / ((a * currentstep) + b);
  end;

  pbEngine.Invalidate;
end;

procedure TMain.exminKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
  begin
    drawer.UnZoom;
    drawer.Refresh;
  end;
end;

procedure TMain.exmaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
  begin
    drawer.UnZoom;
    drawer.Refresh;
  end;
end;

procedure TMain.eyminKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
  begin
    drawer.UnZoom;
    drawer.Refresh;
  end;
end;

procedure TMain.eymaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ord(Key) = VK_RETURN then
  begin
    drawer.UnZoom;
    drawer.Refresh;
  end;

end;

procedure TMain.xbApplyGraphClick(Sender: TObject);
begin

  main.RefreshDrawer(drawer);
end;

procedure TMain.xbOptimizeGraphClick(Sender: TObject);
begin
  exmin.Text := FloatToStr(SpectrumList.MinX);
  exmax.Text := FloatToStr(SpectrumList.MaxX);
  eymin.Text := FloatToStr(SpectrumList.MinY);
  eymax.Text := FloatToStr(SpectrumList.MaxY);
  main.xbApplyGraphClick(self);
end;

procedure TMain.SplitterMoved(Sender: TObject);
begin
  pnSpectr.Update;
end;

procedure TMain.ae1Exception(Sender: TObject; E: Exception);
var
  Filename: string;
  LogFile: TextFile;
begin
  Filename := ChangeFileExt(Application.Exename, '.log');
  AssignFile(LogFile, Filename);
  if FileExists(Filename) then
    Append(LogFile)
  else
    Rewrite(LogFile);
  ShowError(InternalError);
  Writeln(LogFile, DateTimeToStr(Now) + ':' + E.Message);
  // close the file
  CloseFile(LogFile);
end;

function TMain.ApplicationVersion: string;
var
  S: string;
  n, Len: Cardinal;
  Buf, Value: PChar;
  FName: string;
begin
  FName := Application.ExeName;
  Result := '';

  S := FName;
  n := GetFileVersionInfoSize(PChar(S), n);
  if n = 0 then
    Exit;
  Buf := AllocMem(n);
  GetFileVersionInfo(PChar(S), 0, n, Buf);
  if VerQueryValue(Buf, PChar('StringFileInfo\041904E3\FileVersion'), Pointer(Value), Len) then
    Result := Value;
  FreeMem(Buf, n);
end;

function TMain.Average: TSpectrum;
var
  i, firstSpectrum, spectrumsCount, divisor: byte;
  x, y, elementsCount: cardinal;
  currentSpectrum, newSpectrum: TSpectrum;
  newPointR, pointR: TPointR;
  tempValue, value: real;
  matrix: array of array of TPointR;
label
  next;
begin

  firstSpectrum := 0;
  elementsCount := 0;
  spectrumsCount := 0;

  for i := 0 to SpectrumList.Count - 1 do
  begin
    if SpectrumList[i].IsAveraging = true then
    begin
      firstSpectrum := i;
      currentSpectrum := SpectrumList[i];
      elementsCount := Max(elementsCount, currentSpectrum.Count);
      firstSpectrum := i - spectrumsCount;
      Inc(spectrumsCount);
    end;
  end;
  if spectrumsCount = 0 then
    exit;

  SetLength(matrix, spectrumsCount, elementsCount);

  for x := 0 to spectrumsCount - 1 do
  begin
    currentSpectrum := SpectrumList[x + firstSpectrum];
    for y := 0 to currentSpectrum.Count - 1 do
      matrix[x, y] := currentSpectrum.GetItem(y)
  end;

  newSpectrum := TSpectrum.Create(SpectrumList, SpectrumList[firstSpectrum].ScaleX, SpectrumList[firstSpectrum].ScaleY, SpectrumList[firstSpectrum].Color, true, SpectrumList[firstSpectrum].parameters, SpectrumList[firstSpectrum].DateTime, elementsCount, SpectrumList[firstSpectrum].coment, false);

  for y := 0 to elementsCount - 1 do
  begin
    tempValue := 0;
    divisor := 0;
    for x := 0 to spectrumsCount - 1 do
    begin
      pointR := matrix[x, y];
      if pointR.Y > 0 then
      begin
        tempValue := tempValue + pointR.Y;
        newPointR.X := pointR.X;
        Inc(divisor);
      end;
    end;
    value := tempValue / divisor;
    newPointR.Y := value;
    newSpectrum.Add(newPointR, y);
  end;

next:
  for i := 0 to SpectrumList.Count - 1 do
  begin
    if SpectrumList[i].IsAveraging = true then
    begin
      SpectrumList.Delete(i);
      goto next;
    end;
  end;
  result := newSpectrum;
  Main.xbApplyGraph.OnClick(self);
end;

procedure TMain.LoadFile(fileName: string);
var
  DataStream: TMemoryStream;
  rcount: byte;
var
  spectrum: TSpectrum;
  Visible: boolean;
  ScaleX: TScaleXType;
  ScaleY: TScaleYType;
  Color: TColor;
  Parameters: string;
  Coment: string;
  Count: cardinal;
  DateTime: TDateTime;
  Matrix: TSpectrumMatrix;
  offset: integer;
  i, j: Cardinal;
  pntR: TPointR;
  strRead: string;
  statusRead: string;
  cChar: Char;
  b: Byte;
  ar: array of Byte;
  p: Int64;
begin
  DataStream := TMemoryStream.Create;
  DataStream.LoadFromFile(fileName);

  SetLength(strRead, 5);
  for i := 0 to 4 do
  begin
    DataStream.Read(cChar, SizeOf(char));
    strRead[i + 1] := cChar;
  end;

  if strRead <> 'DFS52' then
  begin
    ShowError('Неверный формат.');
  end;

  DataStream.Read(rcount, SizeOf(rcount));

  for i := 0 to rcount - 1 do
  begin

    SetLength(statusRead, 9);
    for j := 0 to 8 do
    begin
      DataStream.Read(cChar, SizeOf(char));
      statusRead[j + 1] := cChar;
    end;

    offset := sizeof(Visible);
    DataStream.Read(Visible, offset);

    offset := sizeof(ScaleX);
    DataStream.Read(ScaleX, offset);

    offset := sizeof(ScaleY);
    DataStream.Read(ScaleY, offset);

    offset := sizeof(Color);
    DataStream.Read(Color, offset);

    DataStream.Read(offset, SizeOf(Cardinal));
    SetLength(strRead, offset);
    for j := 0 to offset - 1 do
    begin
      DataStream.Read(cChar, SizeOf(char));
      strRead[j + 1] := cChar;
    end;
    Parameters := strRead;

    offset := 0;
    DataStream.Read(offset, SizeOf(Cardinal));
    SetLength(strRead, offset);
    if offset <> 0 then
      for j := 0 to offset - 1 do
      begin
        DataStream.Read(cChar, SizeOf(char));
        strRead[j + 1] := cChar;
      end;
    Coment := strRead;

    offset := sizeof(DateTime);
    DataStream.Read(DateTime, offset);

    offset := sizeof(Cardinal);
    DataStream.Read(Count, offset);

    offset := Count * sizeof(TPointR);

    Setlength(Matrix, Count);

    spectrum := TSpectrum.Create(SpectrumList, ScaleX, ScaleY, Color, Visible, Parameters, DateTime, Count, Coment, false);

    for j := 0 to Count - 1 do
    begin
      DataStream.Read(pntR, SizeOf(TPointR));
      spectrum.Add(pntR, j);
    end;

    SetLength(statusRead, 7);
    for j := 0 to 6 do
    begin
      DataStream.Read(cChar, SizeOf(Char));
      statusRead[j + 1] := cChar;
    end;
    RefreshTable;
    drawer.Refresh;
  end;

  DataStream.Free;

end;

procedure TMain.SaveFile(fileName: string);
var
  DataStream: TFileStream;
  memSteram: TMemoryStream;
  rcount: byte;
  i: byte;
  spectrum: TSpectrum;
  j: Cardinal;
  Visible: boolean;
  ScaleX: TScaleXType;
  ScaleY: TScaleYType;
  Color: TColor;
  id: string;
  Parameters: string;
  Coment: string;
  Count: cardinal;
  DateTime: TDateTime;
  Matrix: TSpectrumMatrix;
  writeString: array of Char;
  cChar: Char;
  offset: integer;
  pntR: TPointR;
begin
  DataStream := TFileStream.Create(fileName, fmCreate);

  id := 'DFS52';

  SetLength(writeString, Length(id));
  for i := 0 to Length(id) - 1 do
    writeString[i] := id[i + 1];

  for cChar in writeString do
    DataStream.Write(cChar, SizeOf(cChar));

  rcount := SpectrumList.Count;

  DataStream.Write(rcount, sizeof(rcount));

  for i := 0 to SpectrumList.Count - 1 do
  begin

    spectrum := SpectrumList[i];

    id := 'STARTPART';

    SetLength(writeString, Length(id));
    for j := 0 to Length(id) - 1 do
      writeString[j] := id[j + 1];

    for cChar in writeString do
      DataStream.Write(cChar, SizeOf(cChar));

    Visible := spectrum.Visible;
    offset := sizeof(Visible);
    DataStream.Write(Visible, offset);

    ScaleX := spectrum.ScaleX;
    offset := sizeof(ScaleX);
    DataStream.Write(ScaleX, offset);

    ScaleY := spectrum.ScaleY;
    offset := sizeof(ScaleY);
    DataStream.Write(ScaleY, offset);

    Color := spectrum.Color;
    offset := sizeof(Color);
    DataStream.Write(Color, offset);

    Parameters := spectrum.Parameters;
    SetLength(writeString, 0);
    SetLength(writeString, Length(Parameters));
    for j := 0 to Length(Parameters) - 1 do
      writeString[j] := Parameters[j + 1];

    offset := Length(Parameters);
    DataStream.WriteBuffer(offset, SizeOf(offset));

    for cChar in writeString do
      DataStream.Write(cChar, SizeOf(cChar));

    Coment := spectrum.Coment;
    SetLength(writeString, Length(Coment));
    if Length(Coment) > 0 then
      for j := 0 to Length(Coment) - 1 do
        writeString[j] := Coment[j + 1];

    offset := Length(Coment);
    DataStream.WriteBuffer(offset, SizeOf(offset));

    for cChar in writeString do
      DataStream.Write(cChar, SizeOf(cChar));

    DateTime := spectrum.DateTime;
    offset := sizeof(DateTime);
    DataStream.Write(DateTime, offset);

    Count := spectrum.Count;
    offset := sizeof(Count);
    DataStream.WriteBuffer(Count, offset);

    Matrix := spectrum.Matrix;
    for pntR in Matrix do
      DataStream.Write(pntR, SizeOf(TPointR));

    id := 'ENDPART';

    SetLength(writeString, Length(id));
    for j := 0 to Length(id) - 1 do
      writeString[j] := id[j + 1];

    for cChar in writeString do
      DataStream.Write(cChar, SizeOf(cChar));

  end;

  DataStream.Free;

end;

function TMain.WaitNexStep(overridePause: cardinal; isAvg: boolean): boolean;
var
  key: byte;
  i: cardinal;
  pauseMs: cardinal;
begin
  Result := false;
  MessDlgs.ShowStatus('Пауза перед следующим проходом: ' + epause.Text + ' c.');
  main.Enabled := false;

  // полная пауза в мс / 100 итераций
  pauseMs := round(StrToFloatSafe(epause.Text) * 1000) div 100;

  GetAsyncKeyState(VK_ESCAPE);

  for i := 1 to 100 do
  begin
    Sleep(pauseMs);
    MessDlgs.UpdateStatus(100 - i, 'Пауза перед следующим проходом: ' + inttostr(trunc(overridePause - (overridePause / 100) * i)) + ' c.');
    application.ProcessMessages;

    if GetAsyncKeyState(VK_ESCAPE) and $8000 <> 0 then
      key := 1;
    Break;
  end;

  MessDlgs.CloseStatus;
  drawer.Refresh;
  main.Enabled := true;

  if key = 1 then
  begin
    Result := true;
    Exit;
  end;
end;

procedure TMain.btnGoToPositionClick(Sender: TObject);
begin
  if MessDlgs.MessageDlg('Выполнить перестройку в указанную точку диапазона?', mtConfirmation, [mbYes, mbCancel], 0) = 6 then
  begin
    rotMarker := True;
    xbStartMeasuringClick(self);
  end;
end;

function TMain.CalcTickStep(Range: Double; PixelWidth: Integer): Double;
var
  RawStep, Magnitude: Double;
  NiceSteps: array[0..4] of Double;
  i: Integer;
begin
  // минимум ~80px между мажорными метками
  RawStep := Range / (PixelWidth / 80);
  Magnitude := Power(10, Floor(Log10(RawStep)));
  NiceSteps[0] := 1 * Magnitude;
  NiceSteps[1] := 2 * Magnitude;
  NiceSteps[2] := 2.5 * Magnitude;
  NiceSteps[3] := 5 * Magnitude;
  NiceSteps[4] := 10 * Magnitude;
  Result := NiceSteps[4];
  for i := 0 to 4 do
    if NiceSteps[i] >= RawStep then
    begin
      Result := NiceSteps[i];
      Break;
    end;
end;

procedure TMain.DrawScale(Canvas: TCanvas; W, H: Integer);
const
  TopOffset = 12;  // отступ сверху до линии
  SideOffset = 6;
var
  Range, Step, MinorStep, v: Double;
  x, tx: Integer;
  MajorH, MinorH: Integer;
  s: string;
begin
  Range := FAxisMax - FAxisMin;
  if Range <= 0 then
    Exit;

  MajorH := 8;
  MinorH := 3;

  Canvas.Font.Name := 'Arial';
  Canvas.Font.Height := -9;
  Canvas.Font.Color := clGray;
  Canvas.Font.Style := [];
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Width := 1;

  // горизонтальная линия
  Canvas.MoveTo(SideOffset, TopOffset);
  Canvas.LineTo(W - SideOffset, TopOffset);

  Step := CalcTickStep(Range, W);
  MinorStep := Step / 6;

  v := Ceil(FAxisMin / MinorStep) * MinorStep;
  while v <= FAxisMax + MinorStep do
  begin
    x := SideOffset + Round((v - FAxisMin) / Range * (W - 2 * SideOffset));
    if (x >= SideOffset) and (x <= W - SideOffset) then
    begin
      if Abs(v / Step - Round(v / Step)) < 0.01 then
      begin
        // мажорный тик - вниз от линии
        Canvas.Pen.Color := clGray;
        Canvas.MoveTo(x, TopOffset);
        Canvas.LineTo(x, TopOffset + MajorH);

        // подпись - под тиком
        if Range >= 10 then
          s := FormatFloat('#,##0', Round(v))
        else
          s := FormatFloat('#,##0.##', v);
        s := StringReplace(s, ',', ' ', [rfReplaceAll]);
        tx := x - Canvas.TextWidth(s) div 2;
        if tx < SideOffset then
          tx := SideOffset;
        if tx + Canvas.TextWidth(s) > W - SideOffset then
          tx := W - SideOffset - Canvas.TextWidth(s);
        Canvas.Brush.Style := bsClear;
        Canvas.TextOut(tx, TopOffset + MajorH + 1, s);
      end
      else
      begin
        // минорный тик — вниз от линии
        Canvas.Pen.Color := clGray;
        Canvas.MoveTo(x, TopOffset);
        Canvas.LineTo(x, TopOffset + MinorH);
      end;
    end;
    v := v + MinorStep;
  end;

  // треугольник - размер пропорционален TopOffset
  if (FCurrentPos >= FAxisMin) and (FCurrentPos <= FAxisMax) then
  begin
    x := SideOffset + Round((FCurrentPos - FAxisMin) / Range * (W - 2 * SideOffset));
    Canvas.Brush.Color := clBlack;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsSolid;
    Canvas.Polygon([point(x - (TopOffset - 2) * 3 div 5, 2),  // левый верх
      point(x + (TopOffset - 2) * 3 div 5, 2),                // правый верх
      point(x, TopOffset - 2)                                 // острие
      ]);
  end;
end;

procedure TMain.pbEnginePaint(Sender: TObject);
var
  pb: TPaintBox;
begin
  pb := TPaintBox(Sender);
  pb.Canvas.Brush.Color := $00E6E6E6; // = RGB(230,230,230)
  pb.Canvas.Brush.Style := bsSolid;
  pb.Canvas.FillRect(pb.ClientRect);
  DrawScale(pb.Canvas, pb.Width, pb.Height);
end;

end.

