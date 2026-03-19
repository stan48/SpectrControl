unit SysInfo;

interface

// e.g. Windows 11 Enterprise
function GetOSVersionShort: string;
// e.g. Windows 11 Enterprise 24H2 (Build 26200)
function GetOSVersionFull: string;
// e.g. Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
function GetCPUName: string;

implementation

uses
  Windows, SysUtils, Registry;

type
  TRtlOSVersionInfoExW = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar;
    wServicePackMajor: Word;
    wServicePackMinor: Word;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;

  TRtlGetVersion = function(var VersionInfo: TRtlOSVersionInfoExW): LongInt; stdcall;

var
  CachedOsName: string;
  CachedDisplayVersion: string;
  CachedBuild: DWORD;
  CacheReady: Boolean = False;

procedure EnsureCache;
var
  hNtDll: THandle;
  RtlGetVersion: TRtlGetVersion;
  VerInfo: TRtlOSVersionInfoExW;
  Major, Minor: DWORD;
  ProductName, Edition: string;
  Reg: TRegistry;
begin
  if CacheReady then Exit;
  CacheReady := True;

  Major := 0;
  Minor := 0;
  CachedBuild := 0;

  hNtDll := GetModuleHandle('ntdll.dll');
  if hNtDll <> 0 then
  begin
    @RtlGetVersion := GetProcAddress(hNtDll, 'RtlGetVersion');
    if Assigned(RtlGetVersion) then
    begin
      FillChar(VerInfo, SizeOf(VerInfo), 0);
      VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
      if RtlGetVersion(VerInfo) = 0 then
      begin
        Major := VerInfo.dwMajorVersion;
        Minor := VerInfo.dwMinorVersion;
        CachedBuild := VerInfo.dwBuildNumber;
      end;
    end;
  end;

  if (Major = 10) and (CachedBuild >= 22000) then
    CachedOsName := 'Windows 11'
  else if Major = 10 then
    CachedOsName := 'Windows 10'
  else if (Major = 6) and (Minor = 3) then
    CachedOsName := 'Windows 8.1'
  else if (Major = 6) and (Minor = 2) then
    CachedOsName := 'Windows 8'
  else if (Major = 6) and (Minor = 1) then
    CachedOsName := 'Windows 7'
  else if (Major = 6) and (Minor = 0) then
    CachedOsName := 'Windows Vista'
  else if (Major = 5) and (Minor = 1) then
    CachedOsName := 'Windows XP'
  else
    CachedOsName := Format('Windows %d.%d', [Major, Minor]);

  ProductName := '';
  CachedDisplayVersion := '';
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      if Reg.ValueExists('ProductName') then
        ProductName := Reg.ReadString('ProductName');
      if Reg.ValueExists('DisplayVersion') then
        CachedDisplayVersion := Reg.ReadString('DisplayVersion');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  // Берём только редакцию (Pro, Enterprise, Home)
  if ProductName <> '' then
  begin
    Edition := '';
    if Copy(ProductName, 1, 11) = 'Windows 11 ' then
      Edition := Copy(ProductName, 12, Length(ProductName))
    else if Copy(ProductName, 1, 11) = 'Windows 10 ' then
      Edition := Copy(ProductName, 12, Length(ProductName))
    else if Copy(ProductName, 1, 8) = 'Windows ' then
      Edition := Copy(ProductName, 9, Length(ProductName));

    if Edition <> '' then
      CachedOsName := CachedOsName + ' ' + Edition;
  end;
end;

function GetOSVersionShort: string;
begin
  EnsureCache;
  Result := CachedOsName;
end;

function GetOSVersionFull: string;
begin
  EnsureCache;
  if CachedDisplayVersion <> '' then
    Result := Format('%s %s (Build %d)', [CachedOsName, CachedDisplayVersion, CachedBuild])
  else
    Result := Format('%s (Build %d)', [CachedOsName, CachedBuild]);
end;

function GetCPUName: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('HARDWARE\DESCRIPTION\System\CentralProcessor\0') then
    begin
      if Reg.ValueExists('ProcessorNameString') then
        Result := Trim(Reg.ReadString('ProcessorNameString'));
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  if Result = '' then
    Result := 'Unknown CPU';
end;

end.
