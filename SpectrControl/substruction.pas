unit substruction;

interface

uses
  Classes, SpecialTypes;

type
  TSubstractionPoints = array of TPointR;

type
  TSubstractionItem = class(TCollectionItem)
  private
    _point: TPointR;
    function GetPoint: TPointR;
    procedure SetPoint(const Value: TPointR);

  public
    constructor Create(Collection: TCollection; point: TPointR);
    destructor Destroy; override;

  published
    property Point: TPointR read GetPoint write SetPoint;
  end;

type
  TSubstruction = class(TCollection)
  private
    function GetItem(Index: Integer): TSubstractionItem;
    procedure SetItem(Index: Integer; const Value: TSubstractionItem);

  public
    constructor Create;
    destructor Destroy;
    procedure Sort();
    property Items[Index: Integer]: TSubstractionItem read GetItem write SetItem; default;
  end;

implementation

constructor TSubstruction.Create;
begin
  inherited Create(TSubstractionItem);

end;

destructor TSubstruction.Destroy;
begin

  inherited;
end;

function TSubstruction.GetItem(Index: Integer): TSubstractionItem;
begin
  Result := TSubstractionItem(inherited GetItem(Index))
end;

procedure TSubstruction.SetItem(Index: Integer; const Value: TSubstractionItem);
begin

end;

procedure TSubstruction.Sort();
var
  k: Integer; // текущий элемент массива
  i: integer; // индекс для ввода и вывода массива
  changed: boolean; // TRUE, если в текущем цикле были обмены
  buf: TPointR; // буфер для обмена элементами массива
begin

  if Self.Count = 1 then
    Exit;

  repeat
    changed := False; // пусть в текущем цикле нет обменов
    for k := 0 to Self.Count - 2 do
      if (Self[k].Point.X > Self[k + 1].Point.X) then
      begin // обменяем k-й и k+1-й элементы
        buf := Self[k].Point;
        Self[k].Point := Self[k + 1].Point;
        Self[k + 1].Point := buf;
        changed := True;
      end;
  until not changed;
end;

constructor TSubstractionItem.Create(Collection: TCollection; point: TPointR);
begin
  inherited Create(Collection);
  Self._point := point;
end;

destructor TSubstractionItem.Destroy;
begin
  inherited;
end;

function TSubstractionItem.GetPoint: TPointR;
begin
  Result := _point;
end;

procedure TSubstractionItem.SetPoint(const Value: TPointR);
begin
  _point := Value;
end;

end.

