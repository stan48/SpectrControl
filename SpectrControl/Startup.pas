unit Startup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls, shellapi, ExtCtrls, Buttons, Variants, Menus, ToolWin, ImgList, io,
  Dialogs, CheckLst, messdlgs;

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
  ok: Boolean;
begin
  ok := io.InitIO;
  if ok then
  begin
    logo.lbStatus.Caption := 'Загрузка InpOut32: Успешно';
    logo.Update;
    Sleep(500);
  end
  else
  begin
    logo.lbStatus.Caption := 'Загрузка InpOut32: Ошибка! Проверьте наличие inpout32.dll';
    logo.Update;
    Sleep(1000);
  end;
end;

procedure StopDriver;
begin
  io.FreeIO;
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

    pl := messdlgs.MessageDlg('Нет подключенных систем контроля спектров. Продолжить?', mtInformation, [mbYes, mbCancel], 0);
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
