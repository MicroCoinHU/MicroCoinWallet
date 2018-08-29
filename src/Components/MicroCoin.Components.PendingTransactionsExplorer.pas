unit MicroCoin.Components.PendingTransactionsExplorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, UGridUtils, MicroCoin.Node.Node;

type
  TPendingTransactionsExplorer = class(TFrame)
    dgPendingOperations: TDrawGrid;
  private
    FPendingOperationsGrid : TOperationsGrid;
  public
    constructor Create(AOwner : TComponent; ANode : TNode);
  end;

implementation

{$R *.dfm}

{ TPendingTransactionsExplorer }

constructor TPendingTransactionsExplorer.Create(AOwner: TComponent; ANode : TNode);
begin
  inherited Create(AOwner);
  FPendingOperationsGrid := TOperationsGrid.Create(Self);
  FPendingOperationsGrid.DrawGrid := dgPendingOperations;
  FPendingOperationsGrid.AccountNumber := -1; // all
  FPendingOperationsGrid.PendingOperations := true;
  FPendingOperationsGrid.Node := ANode;
end;

end.
