unit MicroCoin.Forms.TransactionHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MicroCoin.Node.Node, UWalletKeys, UAppParams, MicroCoin.Components.OperationExplorer;

type
  TTransactionHistory = class(TForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; ANode: TNode; AWalletKeys : TWalletKeys; AAppParams : TAppParams);
  end;

var
  TransactionHistory: TTransactionHistory;

implementation

{$R *.dfm}

{ TTransactionHistory }

constructor TTransactionHistory.Create(AOwner: TComponent; ANode: TNode;
  AWalletKeys: TWalletKeys; AAppParams: TAppParams);
begin
  inherited Create(AOwner);
  with TOperationExplorer.Create(self, ANode, AWalletKeys, AAppParams) do begin
    Parent := self;
    Align := alClient;
  end;
end;

end.
