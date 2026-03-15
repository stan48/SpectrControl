unit measuring;

interface

uses
  windows, SysUtils, Classes, Forms, io, xygraph, spectrum, messages, 
  specialtypes;

type
  TMesThreadFRW = class(TThread)
  private
    _towards, _inetrval, _spm, _stepmes: cardinal;
    _spectrum: TSpectrum;
    _cpuspd: int64;
    _actLine: real;
    function GetSpectrum: TSpectrum;
  public
    constructor Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: real);
    procedure Execute; override;
    property RecordedSpectrum: TSpectrum read GetSpectrum;
  end;

  TMesThreadREW = class(TThread)
  private
    _towards, _interval, _spm, _stepmes: cardinal;
    _cpuspd: int64;
    _spectrum: TSpectrum;
    _actLine: Real;
    function GetSpectrum: TSpectrum;
  public
    constructor Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: Real);
    procedure Execute; override;
    property RecordedSpectrum: TSpectrum read GetSpectrum;
  end;

  TMesThreadTIME = class(TThread)
  private
    _allTime, _currentTime, _discrTime: cardinal;
    _cpuspd: int64;
    _spectrum: TSpectrum;
    function GetSpectrum: TSpectrum;
  public
    constructor Create(spectrum: TSpectrum; discr, duration: cardinal);
    procedure Execute; override;
    property RecordedSpectrum: TSpectrum read GetSpectrum;
  end;

var
  MesForward: TMesThreadFRW;
  MesReverse: TmesThreadREW;
  MesTime: TMesThreadTIME;

implementation

uses
  mainform, dfscontrol, parametres;

	{$REGION 'Reverse scanning'}

constructor TMesThreadREW.Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: Real);
begin
  _towards := towards;
  _interval := interval;
  _spm := spm;
  _cpuspd := cpuspd;
  _spectrum := spectrum;
  Self._actLine := actLine;
  inherited create(True);
end;

procedure TMesThreadREW.Execute;

  function RDTSC: int64;
  asm
        db      $0F, $31
  end;

var
  PriorityClass: Integer;
  Priority: Integer;
  i, s: cardinal;
  point: TPointR;
  count: word;
  count1, count2: byte;
  x1, x2: int64;
  key: byte;
  ph: byte;
label
  exit;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

 {asm
    cli
  end;}

  dfscontrol.Boost_Left(_interval, 0);

  _stepmes := 0;
  i := 0;

  xygraph.xypen.Color := _spectrum.Color;
  repeat  //начало всего цикла измерения

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 025h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 00ch
        mov     dx, 037ah
        OUT     dx, al
    end;

    s := 0;
    repeat //начало вращения двигателя

      dec(j);
      if j = 255 then
        j := 3;
      ph := ArrPhase[j];

      asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, ph
        add     al, HighVoltage
        mov     dx, 0378h
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
      end;

      x1 := rdtsc;
      repeat
        asm
        XOR     eax, eax
        XOR     edx, edx
        end;
        x2 := rdtsc
      until x2 >= (_cpuspd * _interval + x1);

      inc(s);

    until s = _spm; //окончание вращения двигателя

//начало снятие показаний счетчика
    asm
        mov     al, 2fh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2dh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2bh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count1, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 29h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count2, al
        XOR     ax, ax
        mov     ah, count2
        mov     al, count1
        mov     count, ax
        XOR     eax, eax
        XOR     edx, edx
        mov     key, 0
        IN      AL, 60h
        cmp     al, 1
        jne     @metka
        mov     key, 1

@metka:
    end;

    Inc(_stepmes, s);

    x1 := rdtsc;

    case _spectrum.ScaleX of
      sm:
        point.X := (_actLine) - ((a * (currentstep - _stepmes)) + (b + c));
      nm:
        point.X := 10000000 / (a * (currentstep - _stepmes) + (b + c));
      steps:
        point.X := _stepmes;
      seconds:
        point.X := 0;
    end;

    case _spectrum.ScaleY of
      hertz:
        point.Y := (count / ((_interval / 1000000) * s)) * 4;
      impulse:
        point.Y := count;
    end;

    if point.Y >= hvoff then
    begin
      dfscontrol.HW_Status(false);
      application.ProcessMessages;
    end;

    if _spectrum.Count = 0 then
      xygraph.xymove(point.X, point.Y);

    xygraph.xydraw(point.X, point.Y);
    _spectrum.Add(point, i);

    inc(i);
    x2 := rdtsc;
//showmessage(FloatToStr((x2-x1)));

    if key = 1 then
    begin
      system.Break;
    end;
  until (_stepmes >= _towards) or (Terminated);

  Dec(CurrentStep, _stepmes);

  dfscontrol.Boost_Left(_interval, 1);

  MesReverse.Terminate;
  main.paintengine;

  if HV = true then
  begin
    sleep(1200);
    io.PortWriteByte($37a, $0c);
    io.PortWriteByte($378, (0 + HighVoltage));
  end;

{asm
sti
end;}

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadREW.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;

{$ENDREGION}

	{$REGION 'Forward Scanning'}

constructor TMesThreadFRW.Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: real);
begin
  _towards := towards;
  _inetrval := interval;
  _spm := spm;
  _cpuspd := cpuspd;
  _spectrum := spectrum;
  _actLine := actLine;

  inherited create(True);
end;

procedure TMesThreadFRW.Execute;

  function RDTSC: int64;
  asm
        db      $0F, $31
  end;

var
  PriorityClass: Integer;
  Priority: Integer;
  i, s: cardinal;
  count1, count2: byte;
  count: word;
  point: TpointR;
  x1, x2: int64;
  key: byte;
  ph: byte;
label
  exit, loop;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  dfscontrol.Boost_Right(_inetrval, 0);

  _stepmes := 0;
  i := 5;

  xygraph.xypen.Color := _spectrum.Color;

  repeat //начало цикла измерений

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 025h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 00ch
        mov     dx, 037ah
        OUT     dx, al
    end;

    s := 0;
    repeat //начало вращения двигателя

      Inc(j);
      if j = 4 then
        j := 0;
      ph := ArrPhase[j];

      asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, ph
        add     al, HighVoltage
        mov     dx, 0378h
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
      end;

      x1 := rdtsc;
      repeat
        asm
        XOR     eax, eax
        XOR     edx, edx
        end;
        x2 := rdtsc
      until x2 >= (_cpuspd * _inetrval + x1);

      inc(s);
    until s = _spm; //окончание вращения двигателя

//опрос счетчика
    asm
        mov     al, 2fh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2dh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2bh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count1, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 29h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count2, al
        XOR     ax, ax
        mov     ah, count2
        mov     al, count1
        mov     count, ax
        XOR     eax, eax
        XOR     edx, edx
//проверяем, не остановлен ли процесс
        mov     key, 0
        IN      AL, 60h
        cmp     al, 1
        jne     @metka
        mov     key, 1

@metka:
    end;

    Inc(_stepmes, s);

    case _spectrum.ScaleX of
      sm:
        point.X := (a * (currentstep + _stepmes) + (b + c)) - _actLine;
      nm:
        point.X := 10000000 / (a * (currentstep + _stepmes) + (b + c));
      steps:
        point.X := _stepmes;
      seconds:
        point.X := 0;
    end;

    case _spectrum.ScaleY of
      hertz:
        point.Y := (count / ((_inetrval / 1000000) * s)) * 4;
      impulse:
        point.Y := count;
    end;

    if point.Y >= hvoff then
    begin
      dfscontrol.HW_Status(false);
      application.ProcessMessages;
    end;

    if _spectrum.Count = 0 then
      xygraph.xymove(point.X, point.Y);

    xygraph.xydraw(point.X, point.Y);

    _spectrum.Add(point, i);

    Inc(i);

    if key = 1 then
    begin
      system.Break;
    end;

  until (_stepmes >= _towards) or (Terminated);

  Inc(CurrentStep, _stepmes);

  dfscontrol.Boost_Right(_inetrval, 1);

  MesForward.Terminate;
  main.paintengine;

  if HV = true then
  begin
    sleep(1200);
    io.PortWriteByte($37a, $0c);
    io.PortWriteByte($378, (0 + HighVoltage));
  end;

{asm
   sti
 end;}

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadFRW.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;

{$ENDREGION}

	{$REGION 'Time Scanning'}

constructor TMesThreadTIME.Create(spectrum: TSpectrum; discr, duration: cardinal);
begin
  _discrTime := discr;
  _allTime := duration;
  _cpuspd := cpuspd;
  _spectrum := spectrum;
  inherited create(True);

end;

procedure TMesThreadTIME.Execute;

  function RDTSC: int64;
  asm
        db      $0F, $31
  end;

var
  PriorityClass: Integer;
  Priority: Integer;
  i: cardinal;
  count: word;
  count1, count2: byte;
  x1, x2: int64;
  point: TPointR;
  key: byte;
label
  exit;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

 //asm
 // cli
 // end;
  sleep(1200);
  io.PortWriteByte($37a, $0c);
  io.PortWriteByte($378, (0 + HighVoltage));

  _currentTime := 0;
  i := 5;

  xygraph.xypen.Color := _spectrum.Color;

  repeat  //начало всего цикла измерения

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 025h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 00ch
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 80
        add     al, HighVoltage
        mov     dx, 0378h
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      asm
        XOR     eax, eax
        XOR     edx, edx
      end;
      x2 := rdtsc
    until x2 >= (_cpuspd * _discrTime + x1);


//начало снятие показаний счетчика
    asm
        mov     al, 2fh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2dh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        mov     al, 2bh
        mov     dx, 037ah
        OUT     dx, al
        XOR     eax, eax
        XOR     edx, edx
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count1, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     al, 29h
        mov     dx, 037ah
        OUT     dx, al
    end;

    x1 := rdtsc;
    repeat
      x2 := rdtsc
    until x2 >= (_cpuspd + x1);

    asm
        XOR     eax, eax
        XOR     edx, edx
        mov     dx, 0378h
        IN      al, dx
        mov     count2, al
        XOR     ax, ax
        mov     ah, count2
        mov     al, count1
        mov     count, ax
        XOR     eax, eax
        XOR     edx, edx
//проверяем нажатие Esc
        mov     key, 0
        IN      al, 60h
        cmp     al, 1
        jne     @metka
        mov     key, 1

@metka:
    end;

    Inc(_currentTime, _discrTime);

    point.X := _currentTime / 1000000;

    case _spectrum.ScaleY of
      hertz:
        point.Y := count;
      impulse:
        point.Y := (count / ((_discrTime / 1000000))) * 4;
    end;

    if point.Y >= hvoff then
    begin
      dfscontrol.HW_Status(false);
      application.ProcessMessages;
    end;

    if _spectrum.Count = 0 then
      xygraph.xymove(point.X, point.Y);

    xygraph.xydraw(point.X, point.Y);

    _spectrum.Add(point, i);

    inc(i);

    if key = 1 then
    begin
      system.Break;
    end;
  until (_currentTime >= _allTime) or (Terminated);

  mestime.Terminate;

  io.PortWriteByte($37a, $0c);
  io.PortWriteByte($378, (0 + HighVoltage));

//asm
// sti
//end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadTIME.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;

{$ENDREGION}

end.

