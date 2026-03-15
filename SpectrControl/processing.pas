unit processing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, Series,
  XiPanel, StdCtrls;

type
  Tproc = class(TForm)
    ControlBar2: TControlBar;
    tbControl: TToolBar;
    ToolButton5: TToolButton;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    tbMenu: TToolBar;
    ToolButton2: TToolButton;
    ToolButton8: TToolButton;
    ToolButton7: TToolButton;
    Chart1: TChart;
    GroupBox3: TGroupBox;
    Series1: TLineSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  proc: Tproc;

implementation
uses mainform;
{$R *.dfm}

end.
