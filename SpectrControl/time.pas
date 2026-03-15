unit time;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Ttimeform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    eTime: TEdit;
    eDiscr: TEdit;
    bbStart: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  timeform: Ttimeform;

implementation
uses mainform;
{$R *.dfm}

end.
