unit FloatUtils;

interface

uses SysUtils;

// Конвертирует строку в Float, принимая и точку и запятую как разделитель
function StrToFloatSafe(const S: string): Extended;

implementation

function StrToFloatSafe(const S: string): Extended;
var
  Tmp: string;
begin
  Tmp := S;
  // заменяем запятую на точку (или наоборот — подстраиваемся под системный разделитель)
  Tmp := StringReplace(Tmp, '.', DecimalSeparator, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloat(Tmp);
end;

end.
