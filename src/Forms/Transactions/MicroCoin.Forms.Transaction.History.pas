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
| File:       MicroCoin.Forms.Transaction.History.pas                          |
| Created at: 2018-09-11                                                       |
| Purpose:    Transaction history for individual accounts & Pending list       |
|==============================================================================}

unit MicroCoin.Forms.Transaction.History;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,
  MicroCoin.Account.Data, MicroCoin.Transaction.Base, MicroCoin.Transaction.TransactionList,
  MicroCoin.Node.Events;

type
  TTransactionHistoryForm = class(TForm)
    transactionListView: TVirtualStringTree;
    procedure transactionListViewInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure transactionListViewGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure FormCreate(Sender: TObject);
    procedure transactionListViewDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FAccount: TAccount;
    FAccountTransactionList : TList;
    FTrList: TTransactionList;
    FShowAll: boolean;
    FNodenotifyEvent: TNodeNotifyEvents;
    procedure SetAccount(const Value: TAccount);
    procedure SetShowAll(const Value: boolean);
    procedure Refresh(Sender: TObject);
  public
    property Account: TAccount read FAccount write SetAccount;
    property ShowAll : boolean read FShowAll write SetShowAll;
  end;

var
  TransactionHistoryForm: TTransactionHistoryForm;

implementation

uses
  MicroCoin.Node.Node, MicroCoin.Transaction.ITransaction, DateUtils,
  MicroCoin.Common;

{$R *.dfm}

procedure TTransactionHistoryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TTransactionHistoryForm.FormCreate(Sender: TObject);
begin
  transactionListView.NodeDataSize := sizeof(TTransactionData);
  transactionListView.RootNodeCount := TNode.Node.Operations.TransactionHashTree.TransactionCount;
  FNodenotifyEvent := TNodeNotifyEvents.Create(self);
  FNodenotifyEvent.OnOperationsChanged := Refresh;
end;

procedure TTransactionHistoryForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FNodenotifyEvent);
  if Assigned(FAccountTransactionList) then FreeAndNil(FAccountTransactionList);
  if Assigned(FTrList) then begin
    FTrList.Clear;
    FreeAndNil(FTrList);
  end;
end;

procedure TTransactionHistoryForm.Refresh(Sender: TObject);
begin
  transactionListView.RootNodeCount := TNode.Node.Operations.TransactionHashTree.TransactionCount;
  transactionListView.ReinitNode(nil, true);
end;

procedure TTransactionHistoryForm.SetAccount(const Value: TAccount);
begin
  FAccount := Value;
  if Assigned(FAccountTransactionList) then FreeAndNil(FAccountTransactionList);
  FAccountTransactionList := TList.Create;
  TNode.Node.Operations.TransactionHashTree.GetTransactionsAffectingAccount(Faccount.AccountNumber, FAccountTransactionList);
  transactionListView.RootNodeCount := 0;
  transactionListView.Clear;
  if Assigned(FTrList) then FreeAndNil(FTrList);

  FTrList := TTransactionList.Create;
  TNode.Node.GetStoredOperationsFromAccount(FTrList, Account.AccountNumber, 500, 0, 10000);
  transactionListView.RootNodeCount := FAccountTransactionList.Count + FTrList.Count;
  transactionListView.ReinitNode(nil, true);
end;

procedure TTransactionHistoryForm.SetShowAll(const Value: boolean);
begin
  FShowAll := Value;
end;

procedure TTransactionHistoryForm.transactionListViewDrawText(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const Text: string; const CellRect: TRect;
  var DefaultDraw: Boolean);
var
  xTransactionData : TTransactionData;
begin
   xTransactionData := TTransactionData(Node.GetData^);
   if xTransactionData.time = 0
   then TargetCanvas.Font.Color := clGrayText;
   if (xTransactionData.transactionType = 0) and (xTransactionData.transactionSubtype = 0)
   then TargetCanvas.Font.Color := clGreen;
   {else if xTransactionData.Amount<0
        then TargetCanvas.Font.Color := clRed
        else if xTransactionData.Amount>0
             then TargetCanvas.Font.Color := clGreen;
             }
   DefaultDraw := true;
end;

procedure TTransactionHistoryForm.transactionListViewGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  xData: TTransactionData;
begin
  xData := TTransactionData(Node.GetData^);
  case Column of
     0: if xData.time>0
        then CellText := FormatDateTime('c', DateUtils.UnixToDateTime(xData.time, false))
        else CellText := 'Pending';
     1: CellText := IntToStr(xData.Block);
     2: CellText := TAccount.AccountNumberToAccountTxtNumber(xData.AffectedAccount);
     3: CellText := xData.OperationTxt;
     4: CellText := TCurrencyUtils.CurrencyToString(xData.Amount);
     5: CellText := TCurrencyUtils.CurrencyToString(xData.Fee);
     6: CellText := TCurrencyUtils.CurrencyToString(xData.Balance);
     7: CellText := UTF8ToString( xData.PrintablePayload );
  end;
end;

procedure TTransactionHistoryForm.transactionListViewInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  xTransaction : ITransaction;
  xData : TTransactionData;
begin
  if Assigned(FAccountTransactionList) and Assigned(FTrList) then begin
    if Node.Index > FAccountTransactionList.Count - 1 then begin
      xData := FTrList.TransactionData[Node.Index-FAccountTransactionList.Count];
    end else begin
     xTransaction := TNode.Node.Operations.TransactionHashTree.GetTransaction(Integer(FAccountTransactionList[Node.Index]));
     xTransaction.GetTransactionData(0, xTransaction.SignerAccount, xData);
     xData.NOpInsideBlock := Node.Index;
     xData.Block := TNode.Node.Operations.BlockHeader.block;
     xData.Balance := TNode.Node.Operations.AccountTransaction.Account(Account.AccountNumber).balance;
    end;
  end else begin
    xTransaction := TNode.Node.Operations.TransactionHashTree.GetTransaction(Node.Index);
    if xTransaction.GetTransactionData(0, xTransaction.SignerAccount, xData) then
    begin
      xData.NOpInsideBlock := Node.Index;
      xData.Block := TNode.Node.BlockManager.BlocksCount;
      xData.Balance := TNode.Node.Operations.AccountTransaction.Account(xTransaction.SignerAccount).balance;
    end;
  end;
  Sender.SetNodeData(Node, xData);
end;

end.
