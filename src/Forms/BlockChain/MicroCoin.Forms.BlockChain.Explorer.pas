{==============================================================================|
| MicroCoin                                                                    |
| Copyright (c) 2018 MicroCoin Developers                                      |
|==============================================================================|
| Permission is hereby granted, free of charge, to any person obtaining a copy |
| of this software and associated documentation files (the "Software"), to     |
| deal in the Software without restriction, including without limitation the   |
| rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  |
| sell opies of the Software, and to permit persons to whom the Software is    |
| furnished to do so, subject to the following conditions:                     |
|                                                                              |
| The above copyright notice and this permission notice shall be included in   |
| all copies or substantial portions of the Software.                          |
|------------------------------------------------------------------------------|
| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   |
| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  |
| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       |
| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      |
| FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER          |
| DEALINGS IN THE SOFTWARE.                                                    |
|==============================================================================|
| File:       MicroCoin.Forms.BlockChain.Explorer.pas                          |
| Created at: 2018-09-11                                                       |
| Purpose:    Blockchain Explorer                                              |
|==============================================================================}

unit MicroCoin.Forms.BlockChain.Explorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MicroCoin.Node.Node,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.Buttons,
  PngSpeedButton, Vcl.StdCtrls, Vcl.ExtCtrls, MicroCoin.Node.Events,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart, Threading;

type
  TBlockChainExplorerForm = class(TForm)
    blockListView: TVirtualStringTree;
    Panel1: TPanel;
    labelUpdated: TLabel;
    btnRefresh: TPngSpeedButton;
    Chart1: TChart;
    Series1: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure blockListViewInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure blockListViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure blockListViewFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure blockListViewDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FNotifyEvents: TNodeNotifyEvents;
  public
    { Public declarations }
  end;

var
  Form: TBlockChainExplorerForm;

implementation

uses MicroCoin.BlockChain.Block, MicroCoin.BlockChain.BlockHeader, DateUtils,
     MicroCoin.Transaction.ITransaction, UCrypto, MicroCoin.Common;

{$R *.dfm}

type
  PBlockData = ^TBlockData;
  TBlockData = record
    BlockNumber: Cardinal;
    Time: integer;
    Transcations: word;
    Amount: Int64;
    Fee: Int64;
    Total: Int64;
    Difficulty: Cardinal;
    Hashrate: UInt64;
    Hashrateprev: UInt64;
    Pow: string;
    MinerPayload: string;
    Reward: UInt64;
  end;

procedure TBlockChainExplorerForm.blockListViewDrawText(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const Text: string; const CellRect: TRect;
  var DefaultDraw: Boolean);
var
  xData : PBlockData;
begin
  xData := PBlockData(Node.GetData^);

  if (Column = 10) or (Column = 7)
  then TargetCanvas.Font.Name := 'Courier New';

  if (Column = 2) and (xData.Transcations = 0)
  then TargetCanvas.Font.Color := clLtGray;

  if (Column = 4) and (xData.Amount = 0)
  then TargetCanvas.Font.Color := clLtGray;

  if (Column = 5) and (xData.Fee = 0)
  then TargetCanvas.Font.Color := clLtGray;

  if (Column = 6) and (xData.Total = 0)
  then TargetCanvas.Font.Color := clLtGray;

  if (Column=8)
  then begin
    if (xData.Hashrate >= xData.Hashrateprev)
    then TargetCanvas.Font.Color := clGreen
    else TargetCanvas.Font.Color := clRed;
  end;
end;

procedure TBlockChainExplorerForm.blockListViewFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  xData : PBlockData;
begin
  xData := PBlockData(Node.GetData^);
  xData^ := Default(TBlockData);
  Dispose(xData);
  xData := nil;
end;

procedure TBlockChainExplorerForm.blockListViewGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  xBlock: PBlockData;
  xHash: double;
  xMu : string;
begin
  xBlock := PBlockData(Node.GetData^);
  if xBlock.Hashrate>1000000000
  then begin xHash := xBlock.Hashrate / 1000000000; xMu := 'TH/s'; end
  else if xBlock.Hashrate>1000000
       then begin xHash := xBlock.Hashrate / 1000000; ; xMu := 'GH/s'; end
       else if xBlock.Hashrate>1000
            then begin xHash := xBlock.Hashrate / 1000; ; xMu := 'MH/s'; end
            else begin xHash := xBlock.Hashrate; xMu := 'kH/s'; end;

  case Column of
    0: CellText := Format('%.0n', [xBlock.BlockNumber+0.0]);
    1: CellText := FormatDateTime('c', UnixToDateTime(xBlock.time, false));
    2: CellText := Format('%.0n', [xBlock.Transcations+0.0]);
    3: CellText := TCurrencyUtils.CurrencyToString(xBlock.Reward+xBlock.Fee);
    4: CellText := TCurrencyUtils.CurrencyToString(xBlock.Amount);
    5: CellText := TCurrencyUtils.CurrencyToString(xBlock.Fee);
    6: CellText := TCurrencyUtils.CurrencyToString(xBlock.Total);
    7: CellText := Format('0x%X', [xBlock.Difficulty]);
    8: CellText := Format('%.4n %s',[ xHash, xMu ]);
    9: CellText := xBlock.MinerPayload;
    10: CellText := xBlock.Pow;
  end;
end;

procedure TBlockChainExplorerForm.blockListViewInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  xBlock: TBlock;
  xBlockHeader: TBlockHeader;
  xBlockNumber: Cardinal;
  xData : PBlockData;
  xTransaction: ITransaction;
  i : integer;
begin
  xBlock := TBlock.Create(nil);
  try
    xBlockNumber := TNode.Node.BlockManager.BlocksCount - Node.Index - 1;
    TNode.Node.BlockManager.Storage.LoadBlockChainBlock(xBlock, xBlockNumber);
    new(xData);
    xData^.BlockNumber := xBlockNumber;
    xData^.Time := xBlock.timestamp;
    xData^.Transcations := xBlock.Count;
    xData^.Amount := 0;
    xData^.Fee := 0;
    xData^.Total := 0;
    xData^.Reward := xBlock.BlockHeader.reward;
    for i := 0 to xBlock.Count - 1
    do begin
     xData^.Amount := xData.Amount + Abs(xBlock.Transaction[i].Amount);
     xData^.Fee := xData.Fee + Abs(xBlock.Transaction[i].Fee);
    end;
    xData^.Total := xData.Amount + xData.Fee;
    xData^.Difficulty := xBlock.BlockHeader.compact_target;
    xData^.Hashrate := TNode.Node.BlockManager.AccountStorage.CalcBlockHashRateInKhs(xBlockNumber, 50);
    if xBlockNumber > 0
    then xData^.HashratePrev := TNode.Node.BlockManager.AccountStorage.CalcBlockHashRateInKhs(xBlockNumber-1, 50)
    else xData^.HashratePrev := 0;

    xData^.Pow := TCrypto.ToHexaString(xBlock.BlockHeader.proof_of_work);
    xData^.MinerPayload := UTF8ToString( xBlock.BlockPayload );
    Sender.SetNodeData(Node, xData);
  finally
    FreeAndNil(xBlock);
  end;
end;

procedure TBlockChainExplorerForm.btnRefreshClick(Sender: TObject);
begin
  blockListView.RootNodeCount := TNode.Node.BlockManager.BlocksCount;
  blockListView.ReinitNode(nil, true);
  labelUpdated.Caption := Format('Updated: %s',[FormatDateTime('c', Now)]);
end;

procedure TBlockChainExplorerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBlockChainExplorerForm.FormCreate(Sender: TObject);
begin
  blockListView.NodeDataSize := SizeOf(TBlockData);
  blockListView.RootNodeCount := TNode.Node.BlockManager.BlocksCount;
  labelUpdated.Caption := Format('Updated: %s',[FormatDateTime('c', Now)]);
  FNotifyEvents := TNodeNotifyEvents.Create(self);
  FNotifyEvents.OnBlocksChanged := btnRefreshClick;
  Chart1.Series[0].Clear;
  TTask.Create(procedure
var
  i: integer;
  xBlock: TBlock;

  begin
  xBlock := TBlock.Create(self);
  for i:=TNode.Node.BlockManager.BlocksCount-1001 to TNode.Node.BlockManager.BlocksCount - 1
  do begin
    TNode.Node.BlockManager.Storage.LoadBlockChainBlock(xBlock, i);
{     TThread.Synchronize(nil, procedure begin}
     if assigned(Chart1) then
        Chart1.Series[0].Add(
          TNode.Node.BlockManager.AccountStorage.CalcBlockHashRateInKhs(xBlock.BlockHeader.block, 50) / (1000*1000)
          ,FormatDateTime('c', UnixToDateTime(xBlock.timestamp, false)))
      else exit;
{     end);}
  end;
  Chart1.Update;
  xBlock.Free;
  end).Start;
end;

procedure TBlockChainExplorerForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FNotifyEvents);
end;

end.
