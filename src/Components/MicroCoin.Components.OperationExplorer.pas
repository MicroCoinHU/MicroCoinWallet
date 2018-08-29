unit MicroCoin.Components.OperationExplorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, MicroCoin.Node.Node, UGridUtils, UWalletKeys, UAppParams;

type
  TOperationExplorer = class(TFrame)
    Panel1: TPanel;
    Label2: TLabel;
    ebFilterOperationsStartBlock: TEdit;
    ebFilterOperationsEndBlock: TEdit;
    dgOperationsExplorer: TDrawGrid;
    procedure dgOperationsExplorerDblClick(Sender: TObject);
    procedure ebFilterOperationsAccountExit(Sender: TObject);
  private
    FOperationsExplorerGrid : TOperationsGrid;
    FUpdating : boolean;
    FWalletKeys : TWalletKeys;
    FAppParams : TAppParams;
  public
    constructor Create(AOwner: TComponent; ANode: TNode; AWalletKeys : TWalletKeys; AAppParams : TAppParams);
  end;

implementation

{$R *.dfm}
constructor TOperationExplorer.Create(AOwner: TComponent; ANode: TNode; AWalletKeys : TWalletKeys; AAppParams : TAppParams);
begin
  inherited Create(AOwner);
  FOperationsExplorerGrid := TOperationsGrid.Create(Self);
  FOperationsExplorerGrid.DrawGrid := dgOperationsExplorer;
  FOperationsExplorerGrid.AccountNumber := -1;
  FOperationsExplorerGrid.PendingOperations := False;
  ebFilterOperationsStartBlock.Text := '';
  ebFilterOperationsEndBlock.Text := '';
  FWalletKeys := AWalletKeys;
  FAppParams := AAppParams;
end;

procedure TOperationExplorer.dgOperationsExplorerDblClick(Sender: TObject);
begin
  FOperationsExplorerGrid.ShowModalDecoder(FWalletKeys, FAppParams);
end;

procedure TOperationExplorer.ebFilterOperationsAccountExit(Sender: TObject);
Var bstart,bend : Int64;
begin
  If FUpdating then exit;
  FUpdating := True;
  Try
    bstart := StrToInt64Def(ebFilterOperationsStartBlock.Text,-1);
    if bstart>=0 then ebFilterOperationsStartBlock.Text := Inttostr(bstart) else ebFilterOperationsStartBlock.Text := '';
    bend := StrToInt64Def(ebFilterOperationsEndBlock.Text,-1);
    if bend>=0 then ebFilterOperationsEndBlock.Text := Inttostr(bend) else ebFilterOperationsEndBlock.Text := '';
    FOperationsExplorerGrid.SetBlocks(bstart,bend);
  Finally
    FUpdating := false;
  End;
end;

end.
