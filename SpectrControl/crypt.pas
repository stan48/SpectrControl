unit Crypt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ComCtrls,
  ExtCtrls, Buttons, Variants, Menus, Dialogs, CheckLst, gwiopm;

function EncryptEX(const InString: string): string;

function DecryptEX(const InString: string): string;

function StrToAscii(S: string): string;

function ASCIIToStr(AsciiString: string): string;

// об€зательно смените ключи до использовани€
const
  StartKey = 471; // Start default key
  MultKey = 62142; // Mult default key
  AddKey = 11719; // Add default key

implementation

function StrToAscii(S: string): string;
var
  I, X: Integer;
  RS: string;
  CurChar: string;
begin
  Result := '';
  if Length(S) = 0 then
    Exit;
  X := 1;
  for I := 1 to Length(S) do
  begin
    CurChar := ' ' + Inttostr(Ord(S[I]) + 1);
    Insert(CurChar, RS, X);
    X := X + Length(CurChar);
  end;
  Result := RS;
end;

function ASCIIToStr(AsciiString: string): string;
var
  I, X, L, Lastpos: Integer;
  CurDIGChar, CurrAddChar, RS: string;
begin
  RESULT := '';
  L := Length(AsciiString);
  if L = 0 then
    Exit;
  X := 0;
  Lastpos := 1;
  repeat
    I := X;
    CurDIGChar := '';
    repeat
      I := I + 1;
      if AsciiString[I] <> ' ' then
        CurDIGChar := CurDIGChar + AsciiString[I];
    until (AsciiString[I] = ' ') or (I = L);
    X := I;
    if CurDIGChar <> '' then
    begin
      try
        CurrAddChar := CHR(STRTOINT(CurDIGChar) - 1);
      except
        CurrAddChar := '';
      end;
      Insert(CurrAddChar, RS, Lastpos);
      Lastpos := Lastpos + Length(CurrAddChar);
    end;
  until (X >= L) or (I >= L);
  Result := RS;
end;

function EncryptEX(const InString: string): string;
begin
  Result := StrTOAscii(InString);
end;

function DecryptEX(const InString: string): string;
begin
  Result := asciitostr(InString);
end;

end.

