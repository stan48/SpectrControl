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

constructor TMesThreadREW.Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: Real);
begin
  _towards := towards;
  _interval := interval;
  _spm := spm;
  _spectrum := spectrum;
  Self._actLine := actLine;
  inherited create(True);
end;

procedure TMesThreadREW.Execute;
var
  PriorityClass: Integer;
  Priority: Integer;
  i, s: cardinal;
  point: TPointR;
  count: word;
  count1, count2: byte;
  key: byte;
  ph: byte;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  dfscontrol.Boost_Left(_interval, 0);

  _stepmes := 0;
  i := 0;

  xygraph.xypen.Color := _spectrum.Color;
  repeat

    io.PortWriteByte($37A, $25);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $0C);

    s := 0;
    repeat

      dec(j);
      if j = 255 then
        j := 3;
      ph := ArrPhase[j];

      io.PortWriteByte($378, ph + HighVoltage);
      WaitMicroseconds(_interval);

      inc(s);

    until s = _spm;

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

    Inc(_stepmes, s);

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

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadREW.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;


constructor TMesThreadFRW.Create(spectrum: TSpectrum; towards, spm, interval: cardinal; actLine: real);
begin
  _towards := towards;
  _inetrval := interval;
  _spm := spm;
  _spectrum := spectrum;
  _actLine := actLine;

  inherited create(True);
end;

procedure TMesThreadFRW.Execute;
var
  PriorityClass: Integer;
  Priority: Integer;
  i, s: cardinal;
  count1, count2: byte;
  count: word;
  point: TpointR;
  key: byte;
  ph: byte;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  dfscontrol.Boost_Right(_inetrval, 0);

  _stepmes := 0;
  i := 5;

  xygraph.xypen.Color := _spectrum.Color;

  repeat

    io.PortWriteByte($37A, $25);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $0C);

    s := 0;
    repeat

      Inc(j);
      if j = 4 then
        j := 0;
      ph := ArrPhase[j];

      io.PortWriteByte($378, ph + HighVoltage);
      WaitMicroseconds(_inetrval);

      inc(s);
    until s = _spm;

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

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadFRW.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;


constructor TMesThreadTIME.Create(spectrum: TSpectrum; discr, duration: cardinal);
begin
  _discrTime := discr;
  _allTime := duration;
  _spectrum := spectrum;
  inherited create(True);

end;

procedure TMesThreadTIME.Execute;
var
  PriorityClass: Integer;
  Priority: Integer;
  i: cardinal;
  count: word;
  count1, count2: byte;
  point: TPointR;
  key: byte;
begin

  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  sleep(1200);
  io.PortWriteByte($37a, $0c);
  io.PortWriteByte($378, (0 + HighVoltage));

  _currentTime := 0;
  i := 5;

  xygraph.xypen.Color := _spectrum.Color;

  repeat

    io.PortWriteByte($37A, $25);
    WaitMicroseconds(1);

    io.PortWriteByte($37A, $0C);
    WaitMicroseconds(1);

    io.PortWriteByte($378, 80 + HighVoltage);
    WaitMicroseconds(_discrTime);

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

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

end;

function TMesThreadTIME.GetSpectrum: TSpectrum;
begin
  result := Self._spectrum;
end;

end.
