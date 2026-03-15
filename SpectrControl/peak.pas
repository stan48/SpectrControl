unit peak;

interface

uses
  windows, SysUtils, Classes, Forms, Graphics, specialtypes;

type
  TPeak = class(TCollectionItem)
  private
    _point: TPointR;
    function GetPoint: TPointR;
  public
    constructor Create(Collection: TCollection; Point: TPointR);
    property Point: TPointR read GetPoint;

  end;

type
  TPeaks = class(TCollection)
  private
    function GetItem(Index: Integer): TPeak;
  public
    constructor Create();
    property Items[Index: Integer]: TPeak read GetItem; default;
  end;

implementation

{ TPeaks }

constructor TPeaks.Create;
begin
  inherited Create(TPeak);

end;

function TPeaks.GetItem(Index: Integer): TPeak;
begin
  Result := TPeak(inherited GetItem(Index))
end;

{ TPeak }

constructor TPeak.Create(Collection: TCollection; point: TPointR);
begin
  inherited Create(Collection);
  Self._point := point;
end;

function TPeak.GetPoint: TPointR;
begin
  Result := Self._point;
end;

end.

