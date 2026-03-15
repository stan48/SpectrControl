unit Startup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls, shellapi, ExtCtrls, Buttons, Variants, Menus, ToolWin, ImgList, io,
  Dialogs, CheckLst, gwiopm, messdlgs;

procedure Test;

procedure StartDriver;

procedure StopDriver;

var
  ex: boolean;

implementation

uses
  logof, dfscontrol, mainform;

procedure StartDriver;
var
  status: dword;
begin
  if sysutils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    status := gwiopm.GWIOPM_Driver.OpenSCM;
    logo.lbStatus.Caption := 'Открываю SCM:' + '  ' + gwiopm.GWIOPM_Driver.ErrorLookup(status);
    logo.Update;

    Sleep(500);

    status := gwiopm.GWIOPM_Driver.Start;
    logo.lbStatus.Caption := 'Запуск драйвера GIVEO:' + '  ' + gwiopm.GWIOPM_Driver.ErrorLookup(status);
    logo.Update;

    Sleep(500);

    status := gwiopm.GWIOPM_Driver.DeviceOpen;
    logo.lbStatus.Caption := 'Открываю устройство:' + '  ' + gwiopm.GWIOPM_Driver.ErrorLookup(status);
    logo.Update;

    Sleep(500);

    gwiopm.GWIOPM_Driver.LIOPM_Set_Ports($378, $37a, true);
    gwiopm.GWIOPM_Driver.LIOPM_Set_Ports($60, $60, true);
    status := gwiopm.GWIOPM_Driver.IOCTL_IOPMD_ACTIVATE_KIOPM;
    logo.lbStatus.Caption := 'Установка разрешений:' + '  ' + gwiopm.GWIOPM_Driver.ErrorLookup(status);
    gwiopm.GWIOPM_Driver.CloseSCM;
    logo.Update;
  end;

end;

procedure StopDriver;
begin
  if sysutils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    gwiopm.GWIOPM_Driver.OpenSCM;
    gwiopm.GWIOPM_Driver.LIOPM_Set_Ports($378, $37a, false);
    gwiopm.GWIOPM_Driver.LIOPM_Set_Ports($60, $60, false);
    gwiopm.GWIOPM_Driver.IOCTL_IOPMD_ACTIVATE_KIOPM;
    gwiopm.GWIOPM_Driver.DeviceClose;
    gwiopm.GWIOPM_Driver.Stop;
    gwiopm.GWIOPM_Driver.CloseSCM;
  end;
end;

procedure Test;
var
  pl: byte;
label
  next;
begin

  if dfscontrol.IsSpectEnabled = true then
  begin
    io.PortWriteByte($37a, $0c);
    io.PortWriteByte($378, $0);
    pl := messdlgs.MessageDlg('Установить монохроматор в начало шкалы', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 6 then
      dfscontrol.SetNull;
    if pl = 7 then
      system.Exit;
  end;

  if dfscontrol.IsSpectEnabled = false then
  begin
next:

    pl := messdlgs.MessageDlg('Для продолжения работы включите установку. Продолжить?', mtInformation, [mbYes, mbCancel], 0);
    if pl = 6 then
      if dfscontrol.IsSpectEnabled = false then
        goto next;
    if pl = 2 then
    begin
      stopdriver;
      application.Terminate;
      ex := true;
      system.Exit;
    end;

    ex := false;
    io.PortWriteByte($37a, $0c);
    io.PortWriteByte($378, $0);
    pl := messdlgs.MessageDlg('Установить монохроматор в начало шкалы', mtConfirmation, [mbYes, mbNo], 0);
    if pl = 6 then
      dfscontrol.SetNull;
    if pl = 7 then
      system.Exit;

  end;
end;

end.

