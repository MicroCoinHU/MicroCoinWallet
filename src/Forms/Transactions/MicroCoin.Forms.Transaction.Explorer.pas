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
| File:       MicroCoin.Forms.Transaction.Explorer                             |
| Created at: 2018-09-08                                                       |
| Purpose:    Transaction explorer                                             |
|==============================================================================}
unit MicroCoin.Forms.Transaction.Explorer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, VirtualTrees, System.Actions,
  ActnList, PlatformDefaultStyleActnCtrls, ActnMan,
  System.ImageList, ImgList, PngImageList, StdCtrls, Buttons,
  PngBitBtn, ExtCtrls, PngSpeedButton;
type
  TTransactionExplorer = class(TForm)
    transactionListView: TVirtualStringTree;
    Panel1: TPanel;
    Label1: TLabel;
    PngImageList1: TPngImageList;
    ActionManager1: TActionManager;
    RefreshAction: TAction;
    PngSpeedButton1: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure transactionListViewInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure transactionListViewFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure transactionListViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure transactionListViewInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure transactionListViewDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure transactionListViewGetCellIsEmpty(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var IsEmpty: Boolean);
    procedure RefreshActionExecute(Sender: TObject);
  private
  public
  end;

var
  TransactionExplorer: TTransactionExplorer;

implementation

uses MicroCoin.Node.Node, MicroCoin.BlockChain.Block, UConst,
  MicroCoin.Transaction.ITransaction, MicroCoin.Transaction.Base,
  DateUtils, MicroCoin.Common, MicroCoin.Account.Data, MicroCoin.BlockChain.BlockHeader;

resourcestring
  StrLastUpdated = 'Last updated: %s';
  StrTransactions = '%.0n transactions';
  StrBlockchainReward = 'Blockchain reward';

{$R *.dfm}

type
  TTreeNode = record
    BlockNumber: Cardinal;
    Timestamp: Cardinal;
    Transactions: TList;
  end;

procedure TTransactionExplorer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TTransactionExplorer.FormCreate(Sender: TObject);
begin
  transactionListView.RootNodeCount := TNode.Node.BlockManager.BlocksCount;
  transactionListView.NodeDataSize := SizeOf(TTreeNode);
  Label1.Caption := Format(StrLastUpdated, [FormatDateTime('c', Now)]);
end;

procedure TTransactionExplorer.RefreshActionExecute(Sender: TObject);
begin
  transactionListView.RootNodeCount := TNode.Node.BlockManager.BlocksCount;
  transactionListView.ReinitNode(nil, true);
  Label1.Caption := Format(StrLastUpdated, [FormatDateTime('c', Now)]);
end;

procedure TTransactionExplorer.transactionListViewDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  xP : pointer;
  xNode: TTreeNode;
begin
  if Sender.GetNodeLevel(Node) = 0
  then begin
    TargetCanvas.Font.Style := [fsBold];
    TargetCanvas.Font.Color := clGrayText;
  end
  else begin
    xP := Node.Parent.GetData;
    if xP = nil then
      exit;
    xNode := TTreeNode(xP^);
    if TTransactionData(Pointer(xNode.Transactions[Node.Index])^).transactionType = 0
    then TargetCanvas.Font.Color := clGreen;
  end;
end;

procedure TTransactionExplorer.transactionListViewFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  xPTransactionData: ^TTransactionData;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    if Node.GetData <> nil then
    begin
      for xPTransactionData in TTreeNode(Node.GetData^).Transactions
      do begin
        xPTransactionData^ := Default(TTransactionData);
        dispose(xPTransactionData);
      end;
      TTreeNode(Node.GetData^).Transactions.Clear;
      TTreeNode(Node.GetData^).Transactions.Free;
      TTreeNode(Node.GetData^).Transactions := nil;
    end;
  end;
end;

procedure TTransactionExplorer.transactionListViewGetCellIsEmpty(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var IsEmpty: Boolean);
begin
  IsEmpty := (Sender.GetNodeLevel(Node) > 0) and (Column in [1,2,3]);
end;

procedure TTransactionExplorer.transactionListViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  xNode: TTreeNode;
  xData: TTransactionData;
  pData: ^TTransactionData;
  xTransaction: ITransaction;
  xP: Pointer;
  xList: TList;
  xFee, xAmount : Int64;
  xTransactionCount: integer;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    xP := Node.GetData;
    xNode := TTreeNode(xP^);
    xList := xNode.Transactions;
    xTransactionCount := 0;
    xAmount := 0;
    xFee := 0;
    for pData in xList do begin
      xAmount := xAmount + Abs(pdata.Amount);
      xFee := xFee + Abs(pData.Fee);
      inc(xTransactionCount);
    end;
    case Column of
      0: CellText := FormatDateTime('c', UnixToDateTime(xNode.Timestamp, false));
      1: CellText := Format('%.0n', [xNode.BlockNumber+0.0]);
      3: CellText := Format(StrTransactions, [xTransactionCount+0.0]);
      4: CellText :=  TCurrencyUtils.CurrencyToString(xAmount);
      5: CellText :=  TCurrencyUtils.CurrencyToString(xFee);
      6: CellText :=  TCurrencyUtils.CurrencyToString(Abs(xFee)+Abs(xAmount));
      else CellText:='';
    end;
  end else begin
    xP := Node.Parent.GetData;
    if xP = nil
    then exit;
    xNode := TTreeNode(xP^);
    if xNode.Timestamp = 0
    then exit;
    if not Assigned(xNode.Transactions)
    then exit;
    xData := TTransactionData(Pointer(xNode.Transactions[Node.Index])^);
    case Column of
      0: CellText := xData.TransactionAsString;
      4: CellText := TCurrencyUtils.CurrencyToString(xData.Amount);
      5: CellText := TCurrencyUtils.CurrencyToString(xData.Fee);
      6: CellText := TCurrencyUtils.CurrencyToString(xData.Balance);
      7: CellText := UTF8ToString( xData.PrintablePayload );
      else CellText := '';
    end;
  end;
end;

procedure TTransactionExplorer.transactionListViewInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var ChildCount: Cardinal);
var
  xBlockNumber: Cardinal;
  xBlock: TBlock;
  i: integer;
  xData: ^TTransactionData;
begin
  xBlock := TBlock.Create(nil);
  try
    xBlockNumber := TTreeNode(Node.GetData^).BlockNumber;
    if not TNode.Node.BlockManager.Storage.LoadBlockChainBlock(xBlock, xBlockNumber) then
      ChildCount := 0
    else
    begin
      ChildCount := xBlock.Count;
      TTreeNode(Node.GetData^).Transactions := TList.Create;
      for i := 0 to xBlock.Count - 1 do
      begin
        new(xData);
        xBlock.Transaction[i].GetTransactionData(xBlockNumber, xBlock.Transaction[i].SignerAccount, xData^);
        TTreeNode(Node.GetData^).Transactions.Add(xData);
      end;
    end;
  finally
    FreeAndNil(xBlock);
  end;
end;

procedure TTransactionExplorer.transactionListViewInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  xBlock: TBlockHeader;
  xNode: TTreeNode;
  xBlockTr: TBlock;
  i: integer;
  xData: ^TTransactionData;
  xBlockNumber: Cardinal;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    xBlockNumber := TNode.Node.BlockManager.BlocksCount - Node.Index - 1;
    xBlock := TNode.Node.BlockManager.AccountStorage.Block(xBlockNumber).BlockHeader;
    xNode.Timestamp := xBlock.Timestamp;
    xNode.BlockNumber := xBlock.Block;
    xNode.Transactions := TList.Create;
    new(xData);
    xData^ := TTransactionData.Empty;
    xData^.valid := true;
    xData^.Block := xBlock.Block;
    xData^.time := xBlock.Timestamp;
    xData^.AffectedAccount := xBlock.Block * cAccountsPerBlock;
    xData^.TransactionAsString := StrBlockchainReward;
    xData^.Amount := xBlock.reward;
    xData^.Fee := xBlock.Fee;
    xData^.Balance := xBlock.reward + xBlock.Fee;
    xData^.PrintablePayload := xBlock.block_payload;
    xNode.Transactions.Add(xData);
    xBlockTr := TBlock.Create(nil);
    if TNode.Node.BlockManager.LoadTransactions(xBlockTr, xBlock.Block)
    then begin
      for i := 0 to xBlockTr.Count - 1
      do begin
        new(xData);
        xBlockTr.Transaction[i].GetTransactionData(xBlockNumber, xBlockTr.Transaction[i].SignerAccount, xData^);
        xNode.Transactions.Add(xData);
      end;
    end;
    Sender.ChildCount[Node] := xNode.Transactions.Count;
    xBlockTr.Free;
    Include(InitialStates, ivsExpanded);
    Sender.SetNodeData(Node, xNode);
  end
  else Sender.SetNodeData(Node, xNode);
end;

end.
