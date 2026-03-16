unit parametres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CustomizeDlg, ComCtrls, ExtCtrls, ImgList,
  Buttons,inifiles, Gradpanl,messdlgs, XiPanel, XiButton, ColorGrd,
  DrawComboBox, spectrum, io, FloatUtils;

type
  TParForm = class(TForm)
    tvPar: TTreeView;
    imlist: TImageList;
    maincontrol: TPageControl;
    tsRange: TTabSheet;
    tsPort: TTabSheet;
    gp1: TgradientPanel;
    Panel1: TPanel;
    CalibrBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    eA: TEdit;
    eB: TEdit;
    tsGraph: TTabSheet;
    GroupBox1: TGroupBox;
    lw2: TListView;
    xbSetScale: TXiButton;
    xbCancelAll: TXiButton;
    xbOkAll: TXiButton;
    xbApplyAll: TXiButton;
    gbGiveio: TGroupBox;
    XiButton1: TXiButton;
    XiButton2: TXiButton;
    XiButton3: TXiButton;
    XiButton4: TXiButton;
    XiButton5: TXiButton;
    XiButton6: TXiButton;
    Label11: TLabel;
    lbst: TLabel;
    gbPort: TGroupBox;
    rbSPP: TRadioButton;
    rbEPP: TRadioButton;
    Label3: TLabel;
    eRep: TEdit;
    Label4: TLabel;
    eFin: TEdit;
    Label5: TLabel;
    eRepFin: TEdit;
    GroupBox7: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    lbCor: TLabel;
    eCur: TEdit;
    eEt: TEdit;
    xbSetCorrect: TXiButton;
    TypeBox: TGroupBox;
    rbSM: TRadioButton;
    rbNM: TRadioButton;
    LatticeBox: TGroupBox;
    rbGreen: TRadioButton;
    rbRed: TRadioButton;
    tsExtend: TTabSheet;
    GroupBox5: TGroupBox;
    cbFilter: TCheckBox;
    cbComent: TCheckBox;
    cbPlantStatus: TCheckBox;
    cbHz: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label9: TLabel;
    memcoment: TMemo;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label13: TLabel;
    ePass: TEdit;
    ePassCommit: TEdit;
    xbSetPass: TXiButton;
    cbHint: TCheckBox;
    tsEngine: TTabSheet;
    GroupBox6: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    lbret: TLabel;
    eRet: TEdit;
    eInit: TEdit;
    cbHVoff: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    lbInit: TLabel;
    Label18: TLabel;
    eStarting: TEdit;
    Label19: TLabel;
    lbStarting: TLabel;
    jColorButton: TColorComboBoxEx;
    cb1: TComboBox;
    lbParams: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    lbDate: TLabel;
    cbIsAveraging: TCheckBox;
    procedure bbCancelAllClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure tvParClick(Sender: TObject);
    procedure xbOkParClick(Sender: TObject);

    procedure xbCancelAllClick(Sender: TObject);
    procedure rbGreenMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lw2CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure xbSetScaleClick(Sender: TObject);
    procedure rbRedMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure rbSMMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure rbNMMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure xbOkAllClick(Sender: TObject);
    procedure xbApplyAllClick(Sender: TObject);

    procedure cb1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure XiButton1Click(Sender: TObject);
    procedure XiButton4Click(Sender: TObject);
    procedure XiButton3Click(Sender: TObject);
    procedure XiButton2Click(Sender: TObject);
    procedure XiButton6Click(Sender: TObject);
    procedure XiButton5Click(Sender: TObject);
    procedure xbSetCorrectClick(Sender: TObject);
    procedure rbSPPMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure rbEPPMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure xbSetPassClick(Sender: TObject);
    procedure tsGraphShow(Sender: TObject);
    procedure eRetChange(Sender: TObject);
    procedure eInitChange(Sender: TObject);
    procedure eStartingChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetIniParametres(Number: byte);
    procedure SetIniParametres;
    procedure SM2NM;
    procedure NM2SM;
    procedure SetScaleParametres(tp: TScaleXType);
    procedure SetPortParametres;
    procedure UpdateTable;
    function SelectColor: tcolor;
    procedure SetFormParametres;
    procedure GetSpectrParametres;
    procedure SetSpectrParametres;
  end;

var
  parform: TParForm;
  Lattice: byte;
  Filter, StartCheckStatus, ComentStatus, hints, HV: boolean;
  pass: string;
  Init, Ret, Starting: cardinal;

const
  Colors: array[0..20] of TColor = (clRed, clBlack, clBlue, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray, clSilver, clLime, clYellow, clFuchsia, clAqua, clLtGray, clDkGray, clMoneyGreen, clSkyBlue, clCream, clMedGray);

implementation

{$R *.dfm}

uses
  mainform, DFS, crypt;

procedure Tparform.bbCancelAllClick(Sender: TObject);
begin
  screen.ActiveForm.Close;
end;

procedure Tparform.SetIniParametres;
var
  ini: tinifile;
begin

  ini := TiniFile.Create(extractfilepath(paramstr(0)) + 'conf.ini');

  ini.WriteInteger('CurrentLattice', 'Lattice', Lattice);

  case currentXScale of
    sm:
      ini.WriteInteger('Scale', 'xtype', 1);
    nm:
      ini.WriteInteger('Scale', 'xtype', 2);
    seconds:
      ini.WriteInteger('Scale', 'xtype', 3);
    steps:
      ini.WriteInteger('Scale', 'xtype', 0);
  end;

  case currentYScale of
    hertz:
      ini.WriteInteger('Scale', 'ytype', 0);
    impulse:
      ini.WriteInteger('Scale', 'ytype', 1);

  end;

  ini.WriteInteger('step', 'current', currentstep);

  if lattice = 1 then
  begin
    ini.WriteFloat('GreenLattice', 'a', a);
    ini.WriteFloat('GreenLattice', 'b', b);
  end;

  if lattice = 0 then
  begin
    ini.WriteFloat('RedLattice', 'a', a);
    ini.WriteFloat('RedLattice', 'b', b);
  end;

  ini.WriteInteger('Sensor', 'rep', rep);
  ini.WriteInteger('Sensor', 'fin', fin);
  ini.WriteInteger('Sensor', 'repfin', repfin);
  ini.WriteInteger('Step', 'ret', ret);
  ini.WriteInteger('Step', 'initial', init);
  ini.WriteInteger('Step', 'starting', Starting);

  ini.WriteBool('Status', 'StartCheckStatus', StartCheckStatus);
  ini.WriteBool('Status', 'AveragingStatus', isAveraging);
  ini.WriteBool('Status', 'Hints', Hints);
  ini.WriteBool('Status', 'ComentStatus', ComentStatus);
  ini.WriteBool('Status', 'Filter', Filter);
  ini.WriteBool('Status', 'HVAfterScan', HV);
  ini.WriteInteger('step', 'current', currentstep);

  ini.free;
end;

procedure tparform.GetIniParametres(Number: byte);
var
  Ini: Tinifile;
begin

  Ini := TiniFile.Create(extractfilepath(paramstr(0)) + 'conf.ini');

  if Number = 1 then
  begin  //зеленая решетка
    a := Ini.ReadFloat('GreenLattice', 'a', 1000);
    b := Ini.ReadFloat('GreenLattice', 'b', 1000);

    MaxSM := b + 225000 * a;
    MinSM := b;
    MaxNM := 10000000 / MinSM;
    MinNM := 10000000 / MaxSM;
  end;

  if Number = 0 then
  begin  //красная решетка
    a := Ini.ReadFloat('RedLattice', 'a', 1000);
    b := Ini.ReadFloat('RedLattice', 'b', 1000);

    MaxSM := b + 225000 * a;
    MinSM := b;
    MaxNM := 10000000 / MinSM;
    MinNM := 10000000 / MaxSM;
  end;

  rep := Ini.ReadInteger('Sensor', 'rep', 0);
  fin := Ini.ReadInteger('Sensor', 'fin', 0);
  repfin := Ini.ReadInteger('Sensor', 'repfin', 0);

  StartCheckStatus := Ini.ReadBool('Status', 'StartCheckStatus', true);
  ComentStatus := Ini.ReadBool('Status', 'ComentStatus', false);
  isAveraging := Ini.ReadBool('Status', 'AveragingStatus', false);
  filter := Ini.ReadBool('Status', 'Filter', true);
  hints := Ini.ReadBool('Status', 'Hints', true);
  HV := Ini.ReadBool('Status', 'HVAfterScan', false);
  Init := Ini.ReadInteger('Step', 'initial', 50000);
  Ret := Ini.ReadInteger('Step', 'ret', 1000);
  Starting := Ini.ReadInteger('Step', 'starting', 100);
  Ini.Free;

end;

procedure Tparform.NM2SM;
var
  I: Integer;
  Obj: TObject;
begin

  main.eActLine.Enabled := true;
  main.rbRight.Enabled := true;
  main.rbleft.Enabled := true;

  for I := 0 to parform.ComponentCount - 1 do
  begin
    Obj := parform.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'нм.' then
        TLabel(Obj).Caption := 'обр.сант.';
    end;
  end;

  for I := 0 to main.ComponentCount - 1 do
  begin
    Obj := main.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'нм.' then
        TLabel(Obj).Caption := 'обр.сант.';
    end;
  end;

  for I := 0 to dfs52.ComponentCount - 1 do
  begin
    Obj := dfs52.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'нм.' then
      begin
        TLabel(Obj).Caption := 'обр.сант.';
      end;
    end;
  end;

end;

procedure Tparform.SM2NM;
var
  I: Integer;
  Obj: TObject;
begin

  main.eActLine.Enabled := false;
  main.rbRight.Enabled := false;
  main.rbleft.Enabled := false;

  for I := 0 to parform.ComponentCount - 1 do
  begin
    Obj := parform.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'обр.сант.' then
        TLabel(Obj).Caption := 'нм.';
    end;
  end;

  for I := 0 to main.ComponentCount - 1 do
  begin
    Obj := main.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'обр.сант.' then
        TLabel(Obj).Caption := 'нм.';
    end;
  end;

  for I := 0 to dfs52.ComponentCount - 1 do
  begin
    Obj := dfs52.Components[I];
    if Obj is TLabel then
    begin
      if tlabel(Obj).Caption = 'обр.сант.' then
      begin
        TLabel(Obj).Caption := 'нм.';
      end;
    end;
  end;
end;

procedure Tparform.SetScaleParametres(tp: TScaleXType);
var
  i: byte;
  q: real;
begin

  if lattice = 1 then
    rbgreen.Checked := true
  else
    rbred.Checked := true;

  if currentXScale = sm then
    parform.NM2SM;
  if currentXScale = nm then
    parform.SM2NM;

  if currentXScale = sm then
    rbsm.Checked := true;
  if currentXScale = nm then
    rbnm.Checked := true;

  if currentXScale = steps then
  begin
    rbsm.Checked := false;
    rbnm.Checked := false;
  end;

  main.espm.Clear;
  main.espm.Text := '1,000';

  for i := 1 to 30 do
  begin
    q := i * (a);
    main.espm.AddItem(Format('%.3f', [q]), self);
  end;

  main.espm.AddItem('2,000', self);
  main.espm.AddItem('3,000', self);
  main.espm.AddItem('4,000', self);
  main.espm.AddItem('5,000', self);
  main.espm.AddItem('10,000', self);
  main.espm.AddItem('15,000', self);
  main.espm.AddItem('20,000', self);
  parform.UpdateTable;
  main.paintengine;
  drawer.Refresh;
end;

procedure Tparform.FormShow(Sender: TObject);
begin
  if sysutils.Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
  begin
    gbgiveio.Enabled := false;
    lbst.Caption := 'Функция доступна только при работе с Windows NT/2000/XP';
  end;

  maincontrol.ActivePageIndex := 0;
  gp1.Caption := 'Шкала';
  erep.Text := inttostr(rep);
  efin.Text := inttostr(fin);
  erepfin.Text := inttostr(repfin);
  if rep = 255 then
    rbSPP.Checked := true
  else
    rbEPP.Checked := true;

  if currentYScale = impulse then
    cbhz.Checked := false
  else
    cbhz.Checked := true;
  if StartCheckStatus = true then
    cbPlantStatus.Checked := true
  else
    cbPlantStatus.Checked := false;
  if comentstatus = true then
    cbcoment.Checked := true
  else
    cbcoment.Checked := false;
  if filter = true then
    cbfilter.Checked := true
  else
    cbfilter.Checked := false;
  if hints = true then
    parform.cbHint.Checked := true
  else
    parform.cbHint.Checked := false;
  if HV = true then
    parform.cbHvoff.Checked := true
  else
    parform.cbHvoff.Checked := false;
  if isAveraging = true then
    parform.cbIsAveraging.Checked := true
  else
    parform.cbIsAveraging.Checked := false;

  eret.Text := inttostr(ret);
  einit.Text := inttostr(init);
  estarting.Text := inttostr(starting);

end;

procedure Tparform.SetPortParametres;
begin
  try
    rep := strtoint(erep.Text);
    fin := strtoint(efin.Text);
    repfin := strtoint(erepfin.Text);

    ret := strtoint(eret.Text);
    init := strtoint(einit.Text);
    starting := strtoint(estarting.Text);
  except
    on EConvertError do
    begin
      messdlgs.ShowError(ParamError);
      system.Exit;
    end;
  end;
end;

procedure Tparform.tvParClick(Sender: TObject);
var
  q: string;
  cts: integer;
label
  loop, next;
begin
  cts := maincontrol.ActivePageIndex;
  if (tvpar.Selected.StateIndex = 1) or (tvpar.Selected.StateIndex = 2) then
  begin
loop:
    q := messdlgs.InputBoxI('', 'Для доступа к этим настройкам введите пароль.', '', ltRussian, true);
    if q = pass then
      goto next;
    if q = '' then
    begin
      tvpar.Select(tvpar.Items[cts]);
    end;
    if q <> '' then
    begin
      messdlgs.ShowError('Неверный пароль!');
      goto loop;
    end;
  end;
next:
  maincontrol.ActivePageIndex := tvpar.Selected.StateIndex;
  gp1.Caption := tvpar.Selected.Text;
end;

procedure Tparform.xbOkParClick(Sender: TObject);
begin
  if messdlgs.MessageDlg('Применить измененные параметры?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    b := b1;
    MinSM := MinSM1;
    MaxSM := MaxSM1;

    MinNM := MinNM1;
    MaxNM := MaxNM1;
    parform.Repaint;
    messdlgs.ShowMessage('Новые параметры активированы. Для сохранения их в конфигурационный файл, нажмите кнопку "Применить"');
    if rbred.Checked = true then
      lattice := 0;
    if rbgreen.Checked = true then
      lattice := 1;
  end;

end;

procedure Tparform.xbCancelAllClick(Sender: TObject);
begin
  parform.Close;
end;

procedure Tparform.lw2CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  i: word;
begin
  if Item = nil then
    EXIT;
  i := Item.Index;
  if trunc((i) / 2) < (i / 2) then
    Sender.canvas.brush.Color := cl3DLight
  else
    Sender.canvas.brush.Color := clwhite;

end;

procedure Tparform.xbSetScaleClick(Sender: TObject);
var
  pl: byte;
  q: string;
label
  loop, next;
begin
  try
    a1 := StrToFloatSafe(ea.Text);
    b1 := StrToFloatSafe(eb.Text);
  except
    on EConvertError do
    begin
      messdlgs.ShowError('Некорректные параметры!');
      system.Exit;
    end;
  end;

  MinSM1 := b1;
  MaxSM1 := (b1 + (225000 * a));

  MaxNM1 := (10000000 / b1);
  MinNM1 := (10000000 / (b1 + (225000 * a)));

  pl := messdlgs.MessageDlg('Принять новые параметры: ' + 'Минимум ' + Format('%f', [minnm1]) + ' нм.  и  ' + Format('%f', [minsm1]) + ' обр.сант.' + '     Максимум ' + Format('%f', [maxnm1]) + ' нм.  и  ' + Format('%f', [maxsm1]) + ' обр.сант.', mtConfirmation, [mbYes, mbCancel], 0);

  if pl = 2 then
    system.exit;
  if pl = 6 then
  begin

loop:
    q := messdlgs.InputBoxI('', 'Для доступа к этим настройкам введите пароль.', '', ltRussian, true);
    if q = pass then
      goto next;
    if q = '' then
      system.Exit;
    if q <> '' then
    begin
      messdlgs.ShowError('Неверный пароль!');
      goto loop;
    end;
  end;

next:

  a := a1;
  b := b1;
  MinSM := MinSM1;
  MaxSM := MaxSM1;
  MinNM := MinNM1;
  MaxNM := MaxNM1;
  parform.SetScaleParametres(currentXScale);
  showmessage('Новые параметры шкалы успешно активизированы');
  parform.SetIniParametres;
  parform.FormShow(self);

end;

procedure Tparform.UpdateTable;
begin
  lw2.Clear;
  lw2.AddItem('a', self);
  lw2.Items.Item[0].SubItems.Add(floattostr(a));
  lw2.AddItem('b', self);
  lw2.Items.Item[1].SubItems.Add(floattostr(b));
  lw2.AddItem('min, нм.', self);
  lw2.Items.Item[2].SubItems.Add(Format('%f', [minnm]));
  lw2.AddItem('min, обр.сант.', self);
  lw2.Items.Item[3].SubItems.Add(Format('%f', [minsm]));
  lw2.AddItem('max, нм.', self);
  lw2.Items.Item[4].SubItems.Add(Format('%f', [maxnm]));
  lw2.AddItem('max, обр.сант.', self);
  lw2.Items.Item[5].SubItems.Add(Format('%f', [maxsm]));
end;

procedure Tparform.rbRedMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if lattice = 0 then
    system.Exit;
  if messdlgs.MessageDlg('Сменить решетки?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    lattice := 0;
  end;

  parform.GetIniParametres(lattice);
  parform.SetScaleParametres(currentXScale);
  parform.FormShow(self);
  main.FormShow(self);
end;

procedure Tparform.rbGreenMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if lattice = 1 then
    system.Exit;
  if messdlgs.MessageDlg('Сменить решетки?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    lattice := 1;
  end;

  parform.GetIniParametres(lattice);
  parform.SetScaleParametres(currentXScale);
  parform.FormShow(self);
  main.FormShow(self);
end;

procedure Tparform.rbSMMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if currentXScale = sm then
    system.Exit;

  if messdlgs.MessageDlg('Переключиться на шкалу в обратных сантиметрах?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    currentXScale := sm;
    SpectrumList.Clear;
    main.RefreshTable;
    parform.SetScaleParametres(sm);
    parform.FormShow(self);
  end;
end;

procedure Tparform.rbNMMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if currentXScale = nm then
    system.Exit;

  if messdlgs.MessageDlg('Переключиться на шкалу в нанометрах?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin
    currentXScale := nm;
    SpectrumList.Clear;
    main.RefreshTable;
    parform.SetScaleParametres(nm);
    parform.FormShow(self);
  end;
end;

procedure Tparform.xbOkAllClick(Sender: TObject);
begin
  parform.xbApplyAllClick(self);
  screen.ActiveForm.Close;
end;

procedure Tparform.xbApplyAllClick(Sender: TObject);
begin
  parform.SetPortParametres;
  parform.SetFormParametres;
  parform.SetIniParametres;
  parform.SetSpectrParametres;
end;

function Tparform.SelectColor: tcolor;
var
  col: tcolor;

  function IsColorPresent(whatcolor: tcolor): boolean;
  var
    i: byte;
  begin
    for i := 0 to SpectrumList.Count - 1 do
    begin
      if SpectrumList.Count > 0 then
      begin
        if whatcolor = SpectrumList[i].Color then
        begin
          result := true;
          system.Exit;
        end;
      end;
      result := false;
    end;
  end;

begin

  for col in colors do
    if iscolorpresent(col) = false then
    begin
      result := col;
      system.exit;
    end;
  result := Round(Random * 1000);
end;

procedure Tparform.SetFormParametres;
begin
  if cbplantstatus.Checked = true then
    StartCheckStatus := true
  else
    StartCheckStatus := false;
  if cbcoment.Checked = true then
    comentstatus := true
  else
    comentstatus := false;
  if cbfilter.Checked = true then
    filter := true
  else
    filter := false;
  if cbhz.Checked = true then
    currentyscale := hertz
  else
    currentyscale := impulse;
  if cbHvOff.Checked = true then
    Hv := true
  else
    Hv := false;
  if cbIsAveraging.Checked = true then
    isAveraging := true
  else
    isAveraging := false;

  with cbhint do
  begin
    if checked = true then
    begin
      main.ShowHint := true;
      hints := true;
    end;
    if checked = false then
    begin
      main.ShowHint := false;
      hints := false;
    end;
  end;

  case currentYScale of
    impulse:
      begin
        main.label7.Caption := 'имп.';
        main.label9.Caption := 'имп.';
        main.lbhv.Caption := 'имп.';
        drawer.Refresh;
      end;

    hertz:
      begin
        main.label7.Caption := 'Гц';
        main.label9.Caption := 'Гц';
        main.lbhv.Caption := 'Гц';
        drawer.Refresh;
      end;
  end;
  main.xbApplyGraphClick(self);
end;

procedure Tparform.GetSpectrParametres;
var
  i: byte;
  c: TColor;
begin
  i := strtoint(cb1.Text) - 1;
  c := SpectrumList[i].Color;
  // добавляем цвет если его нет в списке
  jColorButton.AddColor(c, '$' + IntToHex(c, 8));
  jColorButton.ColorValue := c;
  memcoment.Text := SpectrumList[i].Coment;
  lbParams.Caption := SpectrumList[i].Parameters;
  lbDate.Caption := DateTimeToStr(SpectrumList[i].DateTime);
end;

procedure Tparform.SetSpectrParametres;
var
  i: byte;
begin
  if cb1.Text = '' then
    system.Exit;
  i := strtoint(cb1.Text) - 1;
  SpectrumList[i].Color := jColorButton.ColorValue;
  SpectrumList[i].Coment := memcoment.Text;
  main.RefreshTable;
  drawer.Refresh;
end;

procedure Tparform.cb1Change(Sender: TObject);
begin
  Self.GetSpectrParametres;
end;

procedure Tparform.FormCreate(Sender: TObject);
begin
  memcoment.Text := 'Нет результатов для обработки';
end;

procedure Tparform.XiButton1Click(Sender: TObject);
begin
  if io.InitIO then
    lbst.Caption := 'InpOut32: Инициализирован'
  else
    lbst.Caption := 'InpOut32: Ошибка загрузки';
end;

procedure Tparform.XiButton4Click(Sender: TObject);
begin
  io.FreeIO;
  lbst.Caption := 'InpOut32: Выгружен';
end;

procedure Tparform.XiButton3Click(Sender: TObject);
begin
  if io.InitIO then
    lbst.Caption := 'InpOut32: Инициализирован'
  else
    lbst.Caption := 'InpOut32: Ошибка загрузки';
end;

procedure Tparform.XiButton2Click(Sender: TObject);
begin
  lbst.Caption := 'InpOut32: Драйвер GIVEO больше не нужен';
end;

procedure Tparform.XiButton6Click(Sender: TObject);
begin
  if io.InitIO then
    lbst.Caption := 'InpOut32: Инициализирован'
  else
    lbst.Caption := 'InpOut32: Ошибка загрузки';
end;

procedure Tparform.XiButton5Click(Sender: TObject);
begin
  io.FreeIO;
  lbst.Caption := 'InpOut32: Выгружен';
end;

procedure Tparform.xbSetCorrectClick(Sender: TObject);
var
  x1, x2: real;
  pl: byte;
begin
  try
    x1 := StrToFloatSafe(eet.Text);
    x2 := StrToFloatSafe(ecur.Text);
  except
    on eConvertError do
    begin
      messdlgs.ShowError('Некорректные параметры!');
      system.Exit;
    end;
  end;

  pl := messdlgs.MessageDlg('Поправка действительна только на время текущего сеанса работы! Продолжить?', mtConfirmation, [mbYes, mbCancel], 0);

  if pl = 2 then
  begin
    c := 0;
    system.exit;
  end;
  if pl = 6 then
    c := x2 - x1;
  ;
  MaxSM := (b + c) + 225000 * a;
  MinSM := (b + c);
  MaxNM := 10000000 / MinSM;
  MinNM := 10000000 / MaxSM;

  lbcor.Caption := Format('%.1f', [c]) + ' обр.сант.';
  main.PaintEngine;
end;

procedure Tparform.rbSPPMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  erep.Text := '255';
  efin.Text := '95';
  erepfin.Text := '223';
end;

procedure Tparform.rbEPPMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  erep.Text := '254';
  efin.Text := '94';
  erepfin.Text := '222';
end;

procedure Tparform.xbSetPassClick(Sender: TObject);
var
  ini: tinifile;
  q: string;
label
  next;
begin
  if epass.Text <> epasscommit.Text then
  begin
    epass.Text := '';
    epasscommit.Text := '';
    showerror('Пароль и подтверждение не совпадают!');
    exit;
  end;

  if messdlgs.MessageDlg('Вы уверены, что хотите изменить пароль?', mtConfirmation, [mbYes, mbNo], 0) = 6 then
  begin

    q := messdlgs.InputBoxI('', 'Введите текущий пароль', '', ltRussian, true);
    if q = pass then
      goto next;
    if q = '' then
      system.Exit;
    if q <> '' then
    begin
      messdlgs.ShowError('Неверный пароль!');
      epass.Text := '';
      epasscommit.Text := '';
      system.Exit;
    end;

next:

    pass := epass.Text;
    epass.Text := '';
    epasscommit.Text := '';
    ini := TiniFile.Create(extractfilepath(paramstr(0)) + 'conf.ini');
    ini.WriteString('Par', 'Ps', crypt.EncryptEX(pass));
    ini.free;
    messdlgs.MessageDlg('Пароль успешно изменен!', mtInformation, [mbOk], 0);
  end;

end;

procedure Tparform.tsGraphShow(Sender: TObject);
var
  i: byte;
begin
  if main.lwSpectrumList.Items[0] = nil then
    system.Exit;

  if main.lwSpectrumList.Selected = nil then
    main.lwSpectrumList.SelectAll;
  i := 0;
  cb1.Clear;
  cb1.Text := main.lwSpectrumList.Selected.Caption;
  repeat
    cb1.AddItem(main.lwSpectrumList.Items[i].Caption, self);
    inc(i);
  until main.lwSpectrumList.Items[i] = nil;
  getspectrparametres;

end;

procedure Tparform.eRetChange(Sender: TObject);
begin
  if eret.Text <> '' then
    lbret.Caption := floattostr(trunc((1000000 * a * 60) / (StrToFloatSafe(eret.Text)))) + ' обр.см./мин.';
end;

procedure Tparform.eInitChange(Sender: TObject);
begin
  if einit.Text <> '' then
    lbinit.Caption := floattostr(trunc((1000000 * a * 60) / (StrToFloatSafe(einit.Text)))) + ' обр.см./мин.';
end;

procedure Tparform.eStartingChange(Sender: TObject);
begin
  if eStarting.Text <> '' then
    lbstarting.Caption := Format('%.2f', [(StrToFloatSafe(estarting.Text) * a)]) + ' обр.см.';
end;

end.

