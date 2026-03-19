unit FileHandler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SpectrumCollection, Spectrum, specialtypes;

type
  TFileHandler = class(TObject)
  private
    _specrumList: TSpectrumCollection;
    _fileName: string;
  public
    constructor Create(fileName: string; spectrumList: TSpectrumCollection);
  published
    function ReadFile: boolean;
    function WriteFile: boolean;

  end;

implementation

{ TFileHandler }

constructor TFileHandler.Create(fileName: string; spectrumList: TSpectrumCollection);
begin
  Self._specrumList := spectrumList;
  Self._fileName := fileName;
end;

function TFileHandler.ReadFile: boolean;
var
  DataStream: TMemoryStream;
  rcount: byte;
var
  idFormat: AnsiString;
  spectrum: TSpectrum;
  Visible: boolean;
  ScaleX: TScaleXType;
  ScaleY: TScaleYType;
  Color: TColor;
  Parameters: string;
  Coment: string;
  Count: cardinal;
  DateTime: TDateTime;
  Matrix: TSpectrumMatrix;
  offset: integer;
  i: byte;
begin
  DataStream := TMemoryStream.Create;
  DataStream.LoadFromFile(_fileName);

  DataStream.ReadBuffer(idFormat, sizeof(Ansistring));
  DataStream.ReadBuffer(rcount, SizeOf(rcount));

  for i := 0 to rcount - 1 do
  begin

    offset := sizeof(Visible);
    DataStream.ReadBuffer(Visible, offset);

    offset := sizeof(ScaleX);
    DataStream.ReadBuffer(ScaleX, offset);

    offset := sizeof(ScaleY);
    DataStream.ReadBuffer(ScaleY, offset);

    offset := sizeof(Color);
    DataStream.ReadBuffer(Color, offset);

    offset := 1024;
    DataStream.ReadBuffer(Parameters, offset);

    offset := 1024;
    DataStream.ReadBuffer(Coment, offset);

    offset := sizeof(DateTime);
    DataStream.ReadBuffer(DateTime, offset);

    offset := sizeof(Count);
    DataStream.ReadBuffer(Count, offset);

    offset := Count * sizeof(TPointR);
    Setlength(Matrix, Count);
    DataStream.ReadBuffer(Matrix, offset);
  end;

  DataStream.Free;

end;

function TFileHandler.WriteFile: boolean;
var
  DataStream: TFileStream;
  memSteram: TMemoryStream;
  rcount: byte;
  i: byte;
  spectrum: TSpectrum;
  Visible: boolean;
  ScaleX: TScaleXType;
  ScaleY: TScaleYType;
  Color: TColor;
  Parameters: string;
  Coment: string;
  Count: cardinal;
  DateTime: TDateTime;
  Matrix: TSpectrumMatrix;
  offset: integer;
  id: AnsiString;
begin
  DataStream := TFileStream.Create(_fileName, fmCreate);
  rcount := Self._specrumList.Count;
  id := 'dfs';

  DataStream.WriteBuffer(id, sizeof(Ansistring));
  DataStream.WriteBuffer(rcount, sizeof(rcount));

  for i := 0 to Self._specrumList.Count - 1 do
  begin

    spectrum := _specrumList[i] as TSpectrum;

    Visible := spectrum.Visible;
    offset := sizeof(Visible);
    DataStream.WriteBuffer(Visible, offset);

    ScaleX := spectrum.ScaleX;
    offset := sizeof(ScaleX);
    DataStream.WriteBuffer(ScaleX, offset);

    ScaleY := spectrum.ScaleY;
    offset := sizeof(ScaleY);
    DataStream.WriteBuffer(ScaleY, offset);

    Color := spectrum.Color;
    offset := sizeof(Color);
    DataStream.WriteBuffer(Color, offset);

    Parameters := spectrum.Parameters;
    offset := 256;
    DataStream.WriteBuffer(Parameters, offset);

    Coment := spectrum.Coment;
    offset := 256;
    DataStream.WriteBuffer(Coment, offset);

    DateTime := spectrum.DateTime;
    offset := sizeof(DateTime);
    DataStream.WriteBuffer(DateTime, offset);

    Count := spectrum.Count;
    offset := sizeof(Count);
    DataStream.WriteBuffer(Count, offset);

    Matrix := spectrum.Matrix;
    offset := spectrum.Count * sizeof(TPointR);
    ShowMessage(IntToStr(sizeof(TPointR)));
    DataStream.WriteBuffer(Matrix, offset);

  end;

  DataStream.Free;

end;

end.

