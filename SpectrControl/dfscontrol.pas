unit dfscontrol;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, io, xygraph, messdlgs;

procedure SetNull;

procedure HW_Status(Enabled: boolean);

procedure Boost_Left(Fin: cardinal; Action: byte);

procedure Boost_Right(Fin: cardinal; Action: byte);

procedure RewindFRW(Steps, Speed: cardinal);

procedure RewindREW(Steps, Speed: cardinal);

procedure Cymomentr;

function IsSpectEnabled: boolean;

procedure WaitMicroseconds(Microseconds: Cardinal);

implementation

uses
  mainform, parametres;

var
  QPCFreq: Int64;

// Пауза в микросекундах на основе QueryPerformanceCounter.
procedure WaitMicroseconds(Microseconds: Cardinal);
var
  Start, Now: Int64;
  Target: Int64;
begin
  Target := (QPCFreq * Microseconds) div 1000000;
  QueryPerformanceCounter(Start);
  repeat
    QueryPerformanceCounter(Now);
  until (Now - Start) >= Target;
end;

procedure HW_Status(Enabled: boolean);
var
  portstatus: byte;
begin
  if Enabled = true then
  begin
    HighVoltage := 128;
    io.PortWriteByte($37a, $0c);
    WaitMicroseconds(1000);
    portstatus := io.PortReadByte($378);
    WaitMicroseconds(1000);
    io.PortWriteByte($378, (128 + portstatus));
    main.shapeHV.Brush.Color := clRed;
    main.cbHigh.Checked := true;
    application.ProcessMessages;
  end;

  if Enabled = false then
  begin
    io.PortWriteByte($37a, $0c);
    WaitMicroseconds(1000);
    portstatus := io.PortReadByte($378);
    WaitMicroseconds(1000);
    io.PortWriteByte($378, (portstatus - HighVoltage));
    HighVoltage := 0;
    main.shapeHV.Brush.Color := clGray;
    main.cbHigh.Checked := false;
    application.ProcessMessages;
  end;
end;

procedure SetNull;
var
  PriorityClass: Integer;
  Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  dfscontrol.HW_Status(false);
  io.PortWriteByte($37a, $0c);
  messdlgs.ShowStatus('Этап 1 из 4. Перестройка монохроматора.', true);

 //проверяем, что стоит на рабочему
  if (io.PortReadByte($379) = repfin) or (io.PortReadByte($379) = fin) then
  begin
    repeat
      Inc(j);
      if j = 4 then
        j := 0;
      io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
      WaitMicroseconds(700);

    until io.PortReadByte($379) = rep;
    messdlgs.UpdateStatus(20, 'Этап 2 из 4. Привязка к началу шкалы.');
  end;

  //крутим влево, пока не встретим конец+отражение
  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(700);
  until io.PortReadByte($379) = repfin;
  messdlgs.UpdateStatus(40, 'Этап 2 из 4. Привязка к началу шкалы.');
 //крутим вправо до финального сигнала отражения
  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(5000);
  until io.PortReadByte($379) = rep;
  messdlgs.UpdateStatus(60, 'Этап 3 из 4. Коррекция положения.');

 //крутим влево пока не выловим конец + отражение
  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(5000);
  until io.PortReadByte($379) = repfin;
  messdlgs.UpdateStatus(80, 'Этап 4 из 4. Завершение установки.');

 //крутим вправо до финального конца
  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(50000);
  until io.PortReadByte($379) = fin;

  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(50000);
  until (io.PortReadByte($379) = repfin) or (io.PortReadByte($379) = rep);
  messdlgs.UpdateStatus(100, 'Установка в начало шкалы завершена.');
  WaitMicroseconds(500000);
  messdlgs.CloseStatus;
  CurrentStep := 0;
  main.paintengine;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

procedure Boost_Left(Fin: cardinal; Action: byte);
var
  pause, step: cardinal;
  Vinit, Vfin, V: real;
  PriorityClass: Integer;
  Priority: Integer;
label
  exit;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  case Action of
    0:
      begin
        Vinit := 1000000 / init;
        V := Vinit;
        Vfin := 1000000 / Fin;
        pause := init;
        step := 0;
        WaitMicroseconds(1000000);

        repeat
          Dec(j);
          if j = 255 then
            j := 3;
          Inc(step);
          io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
          WaitMicroseconds(pause);
          V := V + ((Vfin - Vinit)) / starting;
          pause := round(1000000 / V);
        until step = starting;
      end;

    1:
      begin
        Vinit := 1000000 / Fin;
        V := Vinit;
        Vfin := 1000000 / init;
        step := 0;

        io.PortWriteByte($37a, $0c);

        repeat
          Dec(j);
          if j = 255 then
            j := 3;
          Inc(step);
          io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
          V := V + ((Vfin - Vinit)) / starting;
          pause := round(1000000 / V);
          WaitMicroseconds(pause);
        until step = starting;

      end;
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  dec(CurrentStep, starting);
end;

procedure Boost_Right(Fin: cardinal; Action: byte);
var
  pause, step: cardinal;
  Vinit, V, Vfin: real;
  PriorityClass: Integer;
  Priority: Integer;
label
  exit;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  case Action of
    0:
      begin
        Vinit := 1000000 / init;
        V := Vinit;
        Vfin := 1000000 / Fin;
        pause := init;
        step := 0;
        WaitMicroseconds(1000000);

        repeat
          Inc(j);
          if j = 4 then
            j := 0;
          Inc(step);
          io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
          WaitMicroseconds(pause);
          V := V + ((Vfin - Vinit)) / starting;
          pause := round(1000000 / V);
        until step = starting;
      end;

    1:
      begin
        Vinit := 1000000 / Fin;
        V := Vinit;
        Vfin := 1000000 / init;
        step := 0;

        io.PortWriteByte($37a, $0c);

        repeat
          Inc(j);
          if j = 4 then
            j := 0;
          Inc(step);
          io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
          V := V + ((Vfin - Vinit)) / starting;
          pause := round(1000000 / V);
          WaitMicroseconds(pause);
        until step = starting;
      end;
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Inc(currentstep, starting);
end;

procedure RewindFRW(steps, Speed: cardinal);
var
  pause, step: cardinal;
  V, Vinit, Vfin: real;
  PriorityClass: Integer;
  Priority: Integer;
  Aborted: Boolean;

  function EscPressed: Boolean;
  begin
    Result := (step mod 100 = 0) and
              (GetAsyncKeyState(VK_ESCAPE) and $8000 <> 0);
  end;

label
  exit, small;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  messdlgs.ShowStatus('Идет перестройка монохроматора.', false);

  application.ProcessMessages;

  Aborted := False;
  Vinit := 1000000 / init;
  V := Vinit;
  Vfin := 1000000 / Speed;
  pause := init;
  step := 0;

  io.PortWriteByte($37a, $0c);

  if steps = 0 then
    goto exit;
  if steps < (starting + 10) then
    goto small;

  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(pause);
    if EscPressed then begin Aborted := True; goto exit; end;
    V := V + ((Vfin - Vinit)) / starting;
    pause := round(1000000 / V);
  until step = starting;

  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(Speed);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step >= (steps - starting);

  Vinit := 1000000 / Speed;
  V := Vinit;
  Vfin := 1000000 / init;

  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    V := V + ((Vfin - Vinit)) / starting;
    pause := round(1000000 / V);
    WaitMicroseconds(pause);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step = steps;
  goto exit;

small:
  repeat
    Inc(j);
    if j = 4 then
      j := 0;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(20000);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step = steps;

exit:
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  messdlgs.CloseStatus;
  Inc(CurrentStep, step);
  xygraph.xygetbuffer(1);
  main.paintengine;

end;

procedure RewindREW(Steps, Speed: cardinal);
var
  pause, step: cardinal;
  V, Vinit, Vfin: real;
  PriorityClass: Integer;
  Priority: Integer;
  Aborted: Boolean;
label
  exit, small;

  function EscPressed: Boolean;
  begin
    Result := (step mod 100 = 0) and
              (GetAsyncKeyState(VK_ESCAPE) and $8000 <> 0);
  end;

begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  messdlgs.ShowStatus('Идет перестройка монохроматора.', false);

  application.ProcessMessages;

  Aborted := False;
  Vinit := 1000000 / init;
  V := Vinit;
  Vfin := 1000000 / Speed;
  pause := init;
  step := 0;

  io.PortWriteByte($37a, $0c);

  if Steps = 0 then
    goto exit;
  if Steps < (starting + 10) then
    goto small;

  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(pause);
    if EscPressed then begin Aborted := True; goto exit; end;
    V := V + ((Vfin - Vinit)) / starting;
    pause := round(1000000 / V);
  until step = starting;

  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(Speed);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step >= (Steps - starting);

  Vinit := 1000000 / Speed;
  V := Vinit;
  Vfin := 1000000 / init;

  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    V := V + ((Vfin - Vinit)) / starting;
    pause := round(1000000 / V);
    WaitMicroseconds(pause);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step = Steps;
  goto exit;

small:
  repeat
    Dec(j);
    if j = 255 then
      j := 3;
    Inc(step);
    io.PortWriteByte($378, (ArrPhase[j] + HighVoltage));
    WaitMicroseconds(20000);
    if EscPressed then begin Aborted := True; goto exit; end;
  until step = Steps;

Exit:

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Dec(CurrentStep, step);
  messdlgs.CloseStatus;
  xygraph.xygetbuffer(1);
  main.paintengine;
  application.ProcessMessages;
  if (io.PortReadByte($379) = repfin) or (io.PortReadByte($379) = Fin) then
    SetNull;

end;

procedure Cymomentr;
var
  PriorityClass: Integer;
  Priority: Integer;
  count: word;
  count1, count2: byte;
  key: byte;
label
  exit;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  main.mbox.Visible := false;
  application.ProcessMessages;
  key := 0;

  repeat

    io.PortWriteByte($37A, $25);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $0C);
    WaitMicroseconds(1);

    io.PortWriteByte($378, 80 + HighVoltage);
    WaitMicroseconds(1000000);

    io.PortWriteByte($37A, $2F);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $2D);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $2B);
    WaitMicroseconds(1);

    count1 := io.PortReadByte($378);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $29);
    WaitMicroseconds(1);

    count2 := io.PortReadByte($378);
    count := Word(count2) shl 8 + Word(count1);

    if GetAsyncKeyState(VK_ESCAPE) and $8000 <> 0 then
      key := 1
    else
      key := 0;

    main.pnSpectr.Caption := Inttostr(round((count / ((100000 / 100000))) * 4));
    application.ProcessMessages;
  until key = 1;

  io.PortWriteByte($37a, $0c);
  io.PortWriteByte($378, (0 + HighVoltage));

  main.mbox.Visible := true;
  main.pnSpectr.Caption := '';

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
end;

function IsSpectEnabled: boolean;
var
  count1, count2: byte;
  count: word;
begin

  io.PortWriteByte($37a, $25);
  io.PortWriteByte($37a, $2f);
  WaitMicroseconds(1);

  io.PortWriteByte($37a, $2d);
  WaitMicroseconds(1);

  io.PortWriteByte($37a, $2b);
  WaitMicroseconds(1);

  count1 := io.PortReadByte($378);
  WaitMicroseconds(1);

  io.PortWriteByte($37A, $29);
  WaitMicroseconds(1);

  count2 := io.PortReadByte($378);
  count := Word(count2) shl 8 + Word(count1);

  if count = 65535 then
    result := false;
  if count = 0 then
    result := true
  else
    result := false;

end;

initialization
  QueryPerformanceFrequency(QPCFreq);

end.
