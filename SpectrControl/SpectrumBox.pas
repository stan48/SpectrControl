unit SpectrumBox;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, XYGraph;

type
  TSpectrumBox = class(TPaintBox)
  private
    function GetMaxX: integer;
    function GetMaxY: integer;
    function GetMinX: integer;
    function GetMinY: integer;
    function GetSpectColl: TSpectrumCollection;
    procedure SetMaxX(const Value: integer);
    procedure SetMaxY(const Value: integer);
    procedure SetMinX(const Value: integer);
    procedure SetMinY(const Value: integer);
    procedure SetSpectColl(const Value: TSpectrumCollection);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property MinX:integer read GetMinX write SetMinX;
		property MaxX:integer read GetMaxX write SetMaxX;
		property MinY:integer read GetMinY write SetMinY;
		property MaxY:integer read GetMaxY write SetMaxY;
		property SpectColl:TSpectrumCollection read GetSpectColl write SetSpectColl;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TSpectrumBox]);
end;

{ TSpectrumBox }

function TSpectrumBox.GetMaxX: integer;
begin

end;

function TSpectrumBox.GetMaxY: integer;
begin

end;

function TSpectrumBox.GetMinX: integer;
begin

end;

function TSpectrumBox.GetMinY: integer;
begin

end;

function TSpectrumBox.GetSpectColl: TSpectrumCollection;
begin

end;

procedure TSpectrumBox.SetMaxX(const Value: integer);
begin

end;

procedure TSpectrumBox.SetMaxY(const Value: integer);
begin

end;

procedure TSpectrumBox.SetMinX(const Value: integer);
begin

end;

procedure TSpectrumBox.SetMinY(const Value: integer);
begin

end;

procedure TSpectrumBox.SetSpectColl(const Value: TSpectrumCollection);
begin

end;

{$REGION 'MyRegion'}
//function BuildArea:boolean;
//label next;
//begin
//try
//  minx:=min(round(strtofloat(exmin.Text)),round(strtofloat(exmax.Text)));
//  maxx:=max(round(strtofloat(exmin.Text)),round(strtofloat(exmax.Text)));
//  miny:=min(round(strtofloat(eymin.Text)),round(strtofloat(eymax.Text)));
//  maxy:=max(round(strtofloat(eymin.Text)),round(strtofloat(eymax.Text)));
//
//  except on EConvertError do begin
//    exmin.Text:='0';
//    exmax.Text:='100';
//    eymin.Text:='0';
//    eymax.Text:='1000';
//    messdlgs.ShowError('Параметры графика заданы неверно.');
//    result:=false;
//    system.Exit; end;
//end;
//
//if (minx<0) or (maxx<=0) or (miny<0) or (maxy<=0) then begin
//    exmin.Text:='0';
//    exmax.Text:='100';
//    eymin.Text:='0';
//    eymax.Text:='1000';
//    messdlgs.ShowError('Параметры графика заданы неверно.');
//    result:=false;
//    system.Exit; end;
//    
//    xygraph.xycleargraph(mbox,$00E6E6E6,$00E6E6E6,1);
//    xygraph.xysetgridlines(5,-1,5,-1);
//    xygraph.xystartgraph(0,100,0,100,53,20,25,34,clipoff);
//
//    xygraph.xyxaxis(clBlack,minx,maxx,(maxx/400),0,name,gridon,lin,fixed);
//    xygraph.xyyaxis(clBlack,miny,maxy,(maxy/400),0,HzN,1,gridon,lin,fixed);
//    xygraph.xyinitruler(6,mbox.Width-65,5,0);
//    xygraph.xyfinish;
//  result:=true;
//  end;
//
//begin

//if ArrResult[0,0]=0 then begin
//    if scaletype= 0 then name:='шаги';
//    if scaletype= 1 then name:='обр.сант.';
//    if scaletype= 2 then name:='нм';
//    //if Hz=1 then HzN:='Гц' else HzN:='имп.';
  //  buildarea;
//end;
//
//if ArrResult[0,0]=1 then begin
//
//    if ArrResult[0,1] = 0 then name:='шаги';
//    if ArrResult[0,1] = 1 then name:='обр.сант.';
//    if ArrResult[0,1] = 2 then name:='нм';
//    if ArrResult[0,1] = 3 then name:='c';
//
//    if ArrResult[1,1] = 1 then HzN:='Гц';
//    if ArrResult[1,1] = 0 then HzN:='имп';
//
//    if BuildArea=true then begin
//
//    x:=-2;
//    repeat
//      inc(x,2);
//      if ArrResult[x,0]=0 then system.break;
//      if ArrResult[x,4]=0 then system.Continue;
//
//
//      y:=5;
//      //try
//      repeat
//          xygraph.xymove(ArrResult[x,y],ArrResult[(x+1),y]); inc(y);
//      until (ArrResult[x,y]>=minx) or (y=225900);
//      //except on  EVariantError do application.ExecuteAction(ae1Exception(self,EVariantError))
//      //end;
//
//       xygraph.xypen.Color:=arrresult[(x+1),3];
//
//      repeat
//       if ArrResult[(x+1),y]>miny then xygraph.xydraw(ArrResult[x,y],ArrResult[(x+1),y]); inc(y);
//      until ((y-5)>=( arrresult[x,3])) or (ArrResult[x,y]>(maxx+1));
//
//    until x = 14;
//    end;
//end;


{$ENDREGION}


end.
