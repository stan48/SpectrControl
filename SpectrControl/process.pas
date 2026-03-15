unit process;

interface

uses
  messdlgs, Classes, Spectrum, Substruction, specialtypes;

type
  TPart = record
    b: TPointR;
    e: TPointR;
  end;

procedure Subst(spectr: TSpectrum; subs: TSubstruction);

implementation

procedure Subst(spectr: TSpectrum; subs: TSubstruction);

{$REGION ' Внутренния функции '}
  function IsInside(fPoint: TPointR; part: TPart): Boolean;
  begin
    Result := False;
    if (fPoint.X > part.b.X) and (fPoint.X < part.e.X) then
      Result := True;
  end;

  function GetPoint(fPoint: TPointR; part: TPart): TPointR;
  var
    x1, x2, y1, y2, a, b: Real;
    resPoint: TPointR;
  begin
    x1 := part.b.X;
    x2 := part.e.X;
    y1 := part.b.Y;
    y2 := part.e.Y;

    a := (y1 - y2) / (x1 - x2);
    b := y1 - a * x1;

    resPoint.X := fPoint.X;
    resPoint.Y := a * resPoint.X + b;

    Result := resPoint;

  end;
{$ENDREGION}

var
  i, j: Integer;
  spectrItem, subsItem: TPointR;
  part: TPart;
  parts: array of TPart;
begin

 {страхуемся на случай ошибки}
  if subs.Count <= 1 then
  begin
    ShowError('Для одной точки вычитание не возможно!');
    Exit;
  end;

  {преобразуем точки вычитания в отрезки}
  SetLength(parts, subs.Count - 1);
  for i := 1 to subs.Count - 1 do
  begin
    parts[i - 1].b := subs[i - 1].Point;
    parts[i - 1].e := subs[i].Point;
  end;

  {проверим попадания в узлы}
  for i := 0 to spectr.Count - 1 do
  begin
    spectrItem := spectr.GetItem(i);
    for j := 0 to subs.Count - 1 do
    begin
      subsItem := subs[j].Point;
      if spectrItem.X = subsItem.X then
      begin
        spectrItem.Y := spectrItem.Y - subsItem.Y;
        if spectrItem.Y < 0 then
          spectrItem.Y := 0;
        spectr.SetItem(i, spectrItem);
      end;
    end;
  end;

  {проверим попадания в отрезки}
  for i := 0 to spectr.Count - 1 do
  begin
    spectrItem := spectr.GetItem(i);
    for part in parts do
      if IsInside(spectrItem, part) = True then
      begin
        spectrItem.Y := spectrItem.Y - GetPoint(spectrItem, part).Y;
        if spectrItem.Y < 0 then
          spectrItem.Y := 0;
        spectr.SetItem(i, spectrItem);
      end;
  end;
{конец процедуры}
end;

end.

