unit MicroCoin.Forms.PendignTransaction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MicroCoin.Components.PendingTransactionsExplorer, MicroCoin.Node.Node;

type
  TPendingTransactionsForm = class(TForm)
  private
  public
    constructor Create(AOwner : TComponent; ANode : TNode);
  end;

var
  PendingTransactionsForm: TPendingTransactionsForm;

implementation

{$R *.dfm}

constructor TPendingTransactionsForm.Create(AOwner: TComponent; ANode: TNode);
begin
  inherited Create(AOwner);
  with TPendingTransactionsExplorer.Create(self, ANode) do begin
    Parent := self;
    Align := alClient;
  end;
end;

end.
