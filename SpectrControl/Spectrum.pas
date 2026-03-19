unit Spectrum;

interface

uses
  windows, SysUtils, Classes, Forms, Graphics, peak, specialtypes,
  MessDlgs;

type
  TScaleYType = (hertz, impulse);

type
  TScaleXType = (sm, nm, steps, seconds);

type
  TSpectrumMatrix = array of TPointR;

type
  TSpectrum = class(TCollectionItem)
  private
    _innerMatrix: TSpectrumMatrix;
    _visible: boolean;
    _scaleX: TScaleXType;
    _scaleY: TScaleYType;
    _color: TColor;
    _parameters: string;
    _coment: string;
    _count: cardinal;
    _dateTime: TDateTime;
    _isAveraging: boolean;
    _peaks: Tpeaks;
    function GetPeaks: TPeaks;
    function GetIsAveraging: boolean;
    procedure SetIsAveraging(const Value: boolean);

    procedure SetMatrix(const Value: TSpectrumMatrix);
    function GetMatrix: TSpectrumMatrix;
    function GetColor: TColor;
    function GetComent: string;
    function GetDateTime: TDateTime;
    function GetNumberElements: cardinal;
    function GetParameters: string;
    function GetScaleXType: TScaleXType;
    function GetScaleYType: TScaleYType;
    function GetVisible: boolean;
    procedure SetColor(const Value: TColor);
    procedure SetComent(const Value: string);
    procedure SetVisible(const Value: boolean);

  public
    constructor Create(Collection: TCollection; scaleX: TScaleXType; scaleY: TScaleYType; color: TColor; visible: Boolean; parameters: string; dateTime: TDateTime; elements: Cardinal; coment: string; isAveraging: boolean);

    procedure Add(newValue: TPointR; position: Cardinal);
    function GetItem(Index: integer): TPointR;
    procedure SetItem(index: Integer; value: TPointR);
    function FindPeaks(treshold: Cardinal; deep: Cardinal; t: Byte): Cardinal;
  published
    property Visible: boolean read GetVisible write SetVisible default true;
    property ScaleX: TScaleXType read GetScaleXType;
    property ScaleY: TScaleYType read GetScaleYType;
    property Color: TColor read GetColor write SetColor;
    property Parameters: string read GetParameters;
    property Coment: string read GetComent write SetComent;
    property Count: cardinal read GetNumberElements;
    property DateTime: TDateTime read GetDateTime;
    property Matrix: TSpectrumMatrix read GetMatrix;
    property IsAveraging: boolean read GetIsAveraging write SetIsAveraging;
    property Peaks: TPeaks read GetPeaks;
  end;

implementation

{ TSpectrum }

constructor TSpectrum.Create(Collection: TCollection; scaleX: TScaleXType; scaleY: TScaleYType; color: TColor; visible: Boolean; parameters: string; dateTime: TDateTime; elements: Cardinal; coment: string; isAveraging: boolean);
begin
  inherited Create(Collection);

  Self._scaleX := scaleX;
  Self._scaleY := scaleY;
  Self._color := color;
  Self._visible := visible;
  Self._parameters := parameters;
  Self._dateTime := dateTime;
  Self._coment := coment;
  Self._isAveraging := isAveraging;
  SetLength(_innerMatrix, elements);
  Self._peaks := TPeaks.Create;
end;

function TSpectrum.FindPeaks(treshold: Cardinal; deep: Cardinal; t: Byte): Cardinal;

  function LeftFind(start: Cardinal; count: Cardinal; deep: Cardinal): Boolean;
  var
    i: Cardinal;
    isDeep: Boolean;
  begin
    Result := True;
    isDeep := false;
    for i := start - count to start do
    begin
      if (Self.GetItem(start).Y < Self.GetItem(i).Y) then
        Result := False;
      if Self.GetItem(i).Y <= (Self.GetItem(start).Y - deep) then
        isDeep := true;
    end;
    if (Result = True) and (isDeep = true) then
      Result := True
    else
      Result := False;
  end;

  function RightFind(start: Cardinal; count: Cardinal; deep: Cardinal): Boolean;
  var
    i: Cardinal;
    isDeep: Boolean;
  begin
    Result := True;
    isDeep := false;
    for i := start to start + count do
    begin
      if (Self.GetItem(start).Y < Self.GetItem(i).Y) then
        Result := False;
      if Self.GetItem(i).Y <= (Self.GetItem(start).Y - deep) then
        isDeep := True;
    end;
    if (Result = True) and (isDeep = true) then
      Result := True
    else
      Result := False;
  end;

var
  i: Cardinal;
begin
  Self.Peaks.Clear;
  if Self.Count < t * 2 then
  begin
    MessDlgs.ShowError('В спектре слишком мало точек для поиска с заданными параметрами!');
    Exit;
  end;

  for i := t to Self.Count - (t - 1) do
  begin
    if (Self.GetItem(i).Y > Self.GetItem(i - 1).Y) and (Self.GetItem(i).Y > treshold) and LeftFind(i, t, deep) and RightFind(i, t, deep) then
      TPeak.Create(_peaks, Self.GetItem(i));
  end;
  Result := _peaks.Count;
end;

function TSpectrum.GetColor: TColor;
begin
  result := _color;
end;

function TSpectrum.GetComent: string;
begin
  result := _coment;
end;

function TSpectrum.GetDateTime: TDateTime;
begin
  result := _dateTime;
end;

function TSpectrum.GetIsAveraging: boolean;
begin
  result := Self._isAveraging;
end;

function TSpectrum.GetItem(Index: integer): TPointR;
begin
  result := _innerMatrix[Index];
end;

function TSpectrum.GetMatrix: TSpectrumMatrix;
begin
  result := _innerMatrix;
end;

function TSpectrum.GetNumberElements: cardinal;
begin
  result := _count;
end;

function TSpectrum.GetParameters: string;
begin
  result := _parameters;
end;

function TSpectrum.GetPeaks: TPeaks;
begin
  Result := Self._peaks;
end;

function TSpectrum.GetScaleXType: TScaleXType;
begin
  Result := _scaleX;
end;

function TSpectrum.GetScaleYType: TScaleYType;
begin
  Result := _scaleY;
end;

function TSpectrum.GetVisible: boolean;
begin
  result := _visible;
end;

procedure TSpectrum.SetColor(const Value: TColor);
begin
  Self._color := Value;
end;

procedure TSpectrum.SetComent(const Value: string);
begin
  Self._coment := Value;
end;

procedure TSpectrum.SetIsAveraging(const Value: boolean);
begin
  Self.IsAveraging := Value;
end;

procedure TSpectrum.SetItem(index: Integer; value: TPointR);
begin
  Self._innerMatrix[index] := value;
end;

procedure TSpectrum.SetMatrix(const Value: TSpectrumMatrix);
begin
  _innermatrix := Value;
end;

procedure TSpectrum.SetVisible(const Value: boolean);
begin
  self._visible := Value;
end;

procedure TSpectrum.Add(newValue: TPointR; position: Cardinal);
begin
  _innerMatrix[position] := newValue;
  inc(_count);
end;

end.
