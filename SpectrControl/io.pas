unit io;

interface

function PortReadByte(Addr: Word): Byte;

function PortReadWord(Addr: Word): Word;

function PortReadWordLS(Addr: Word): Word;

procedure PortWriteByte(Addr: Word; Value: Byte);

procedure PortWriteWord(Addr: Word; Value: Word);

procedure PortWriteWordLS(Addr: Word; Value: Word);

function InitIO: Boolean;
procedure FreeIO;
function IsIOReady: Boolean;
function IsDriverOpen: Boolean;

implementation

uses
  Windows, SysUtils;

type
  TInp32 = function(Addr: SmallInt): SmallInt; stdcall;
  TOut32 = procedure(Addr: SmallInt; Value: SmallInt); stdcall;
  TIsInpOutDriverOpen = function: Boolean; stdcall;

var
  hInpOutDll: THandle = 0;
  fnInp32: TInp32 = nil;
  fnOut32: TOut32 = nil;
  fnIsDriverOpen: TIsInpOutDriverOpen = nil;

function IsIOReady: Boolean;
begin
  Result := (hInpOutDll <> 0) and Assigned(fnInp32) and Assigned(fnOut32);
end;

function IsDriverOpen: Boolean;
begin
  if Assigned(fnIsDriverOpen) then
    Result := fnIsDriverOpen
  else
    Result := False;
end;

function InitIO: Boolean;
var
  DllPath: string;
begin
  Result := False;
  if hInpOutDll <> 0 then
  begin
    Result := True;
    Exit;
  end;

  DllPath := ExtractFilePath(ParamStr(0)) + 'inpout32.dll';
  hInpOutDll := LoadLibrary(PChar(DllPath));
  if hInpOutDll = 0 then
    Exit;

  @fnInp32 := GetProcAddress(hInpOutDll, 'Inp32');
  @fnOut32 := GetProcAddress(hInpOutDll, 'Out32');
  @fnIsDriverOpen := GetProcAddress(hInpOutDll, 'IsInpOutDriverOpen');

  if not Assigned(fnInp32) or not Assigned(fnOut32) then
  begin
    FreeLibrary(hInpOutDll);
    hInpOutDll := 0;
    fnInp32 := nil;
    fnOut32 := nil;
    fnIsDriverOpen := nil;
    Exit;
  end;

  Result := True;
end;

procedure FreeIO;
begin
  if hInpOutDll <> 0 then
  begin
    FreeLibrary(hInpOutDll);
    hInpOutDll := 0;
    fnInp32 := nil;
    fnOut32 := nil;
    fnIsDriverOpen := nil;
  end;
end;

function PortReadByte(Addr: Word): Byte;
begin
  Result := Byte(fnInp32(SmallInt(Addr)));
end;

function PortReadWord(Addr: Word): Word;
begin
  Result := Word(fnInp32(SmallInt(Addr)));
end;

function PortReadWordLS(Addr: Word): Word;
var
  Lo, Hi: Byte;
  i: Integer;
begin
  Lo := Byte(fnInp32(SmallInt(Addr)));
  // small delay loop matching original ~150 cycle delay
  for i := 0 to 149 do ;
  Hi := Byte(fnInp32(SmallInt(Addr + 1)));
  Result := Word(Hi) or (Word(Lo) shl 8);
end;

procedure PortWriteByte(Addr: Word; Value: Byte);
begin
  fnOut32(SmallInt(Addr), SmallInt(Value));
end;

procedure PortWriteWord(Addr: Word; Value: Word);
begin
  fnOut32(SmallInt(Addr), SmallInt(Value));
end;

procedure PortWriteWordLS(Addr: Word; Value: Word);
var
  i: Integer;
begin
  fnOut32(SmallInt(Addr), SmallInt(Lo(Value)));
  // small delay loop matching original ~150 cycle delay
  for i := 0 to 149 do ;
  fnOut32(SmallInt(Addr + 1), SmallInt(Hi(Value)));
end;

end.
