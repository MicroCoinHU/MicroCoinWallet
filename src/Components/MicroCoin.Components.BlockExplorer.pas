unit MicroCoin.Components.BlockExplorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, UGridUtils, MicroCoin.Node.Node;

type
  TBlockExplorerFrame = class(TFrame)
    dgBlockChainExplorer: TDrawGrid;
    Panel2: TPanel;
    filterLabel: TLabel;
    ebBlockChainBlockStart: TEdit;
    ebBlockChainBlockEnd: TEdit;
    procedure ebBlockChainBlockStartExit(Sender: TObject);
  private
    FBlockChainGrid : TBlockChainGrid;
    FNode : TNode;
  public
    constructor Create(AOwner: TComponent; ANode : TNode);
  end;

implementation

{$R *.dfm}

{ TBlockExplorerFrame }

constructor TBlockExplorerFrame.Create(AOwner: TComponent; ANode: TNode);
begin
  inherited Create(AOwner);
  FNode := ANode;
  FBlockChainGrid := TBlockChainGrid.Create(Self);
  FBlockChainGrid.DrawGrid := dgBlockChainExplorer;
  FBlockChainGrid.ShowTimeAverageColumns:={$IFDEF SHOW_AVERAGE_TIME_STATS}True;{$ELSE}False;{$ENDIF}
  FBlockChainGrid.Node := FNode;
end;

procedure TBlockExplorerFrame.ebBlockChainBlockStartExit(Sender: TObject);
var bstart,bend : Int64;
begin
  Try
    bstart := StrToInt64Def(ebBlockChainBlockStart.Text,-1);
    bend := StrToInt64Def(ebBlockChainBlockEnd.Text,-1);
    FBlockChainGrid.SetBlocks(bstart,bend);
    if FBlockChainGrid.BlockStart>=0 then ebBlockChainBlockStart.Text := Inttostr(FBlockChainGrid.BlockStart) else ebBlockChainBlockStart.Text := '';
    if FBlockChainGrid.BlockEnd>=0 then ebBlockChainBlockEnd.Text := Inttostr(FBlockChainGrid.BlockEnd) else ebBlockChainBlockEnd.Text := '';
  Finally
  End;
end;

end.
