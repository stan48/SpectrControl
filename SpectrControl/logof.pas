unit logof;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, XiPanel, jpeg;

type
  TLogo = class(TForm)
    XiPanel1: TXiPanel;
    Image1: TImage;
    lbOs: TLabel;
    lbCPU: TLabel;
    lbStatus: TLabel;
    lbVers: TLabel;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  logo: TLogo;

implementation 

{$R *.dfm}

end.

