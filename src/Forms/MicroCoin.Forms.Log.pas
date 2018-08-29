unit MicroCoin.Forms.Log;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvComponentBase, JvEmbeddedForms,
  Vcl.StdCtrls;

type
  TLogForm = class(TForm)
    JvEmbeddedFormLink1: TJvEmbeddedFormLink;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

end.
