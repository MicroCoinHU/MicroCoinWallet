unit UBlockExplorerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, UGridUtils,
  MicroCoin.Components.BlockExplorer, MicroCoin.Node.Node;

type
  TBlockExplorerForm = class(TForm)
  private
    FBlockChainGrid : TBlockChainGrid;
    FNode : TNode;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; ANode : TNode);
    { Public declarations }
  end;

var
  BlockExplorerForm: TBlockExplorerForm;

implementation

{$R *.dfm}

constructor TBlockExplorerForm.Create(AOwner: TComponent; ANode : TNode);
begin
  inherited Create(AOwner);
  FNode := ANode;
  with TBlockExplorerFrame.Create(self, FNode) do begin
    Parent := self;
    Align := alClient;
  end;
end;

end.
