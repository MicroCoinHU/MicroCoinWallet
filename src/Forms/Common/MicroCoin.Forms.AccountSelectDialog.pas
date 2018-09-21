{==============================================================================|
| MicroCoin                                                                    |
| Copyright (c) 2017-2018 MicroCoin Developers                                 |
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
| File:       MicroCoin.Forms.AccountSelectDialog.pas
| Created at: 2018-09-04
| Purpose:    Account Selector dialog
|==============================================================================}

unit MicroCoin.Forms.AccountSelectDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees,
  MicroCoin.Node.Node, MicroCoin.Account.Data, MicroCoin.Common, Vcl.Menus,
  MicroCoin.Common.Lists, System.Actions, Vcl.ActnList, Vcl.ListActns,
  Vcl.Buttons, PngBitBtn, UITypes;

type
  TAccountSelectDialog = class(TForm)
    accountVList: TVirtualStringTree;
    Panel1: TPanel;
    Panel2: TPanel;
    cbMyAccounts: TCheckBox;
    cbForSale: TCheckBox;
    btnOk: TPngBitBtn;
    btnCancel: TPngBitBtn;
    procedure accountVListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure accountVListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormCreate(Sender: TObject);
    procedure cbMyAccountsClick(Sender: TObject);
    procedure cbForSaleClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edAccountNameExit(Sender: TObject);
    procedure accountVListNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure accountVListFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    FAccounts: TOrderedList;
    FSelectedAccount : TAccount;
    FJustForSale: boolean;
    FJustMyAccounts: boolean;
    procedure UpdateAccounts;
    procedure SetJustForSale(const Value: boolean);
    procedure SetJustMyAccounts(const Value: boolean);
  public

    property SelectedAccount : TAccount read FSelectedAccount;
    property JustMyAccounts : boolean read FJustMyAccounts write SetJustMyAccounts;
    property JustForSale : boolean read FJustForSale write SetJustForSale;
  end;

var
  AccountSelectDialog: TAccountSelectDialog;

implementation

{$R *.dfm}

procedure TAccountSelectDialog.accountVListFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TAccount(Node.GetData^):=Default(TAccount);
end;

procedure TAccountSelectDialog.accountVListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  xPa : PAccount;
begin
  if Sender.GetNodeLevel(Node) = 0 then begin
    xPa := Sender.GetNodeData(Node);
    case Column of
      0: CellText := string(TAccount.AccountNumberToAccountTxtNumber(xPa.AccountNumber));
      1: CellText := string(xPa.name);
      2: CellText := string(TCurrencyUtils.CurrencyToString(xPa.balance));
      3: CellText := xPa.numberOfTransactions.ToString;
    end;
  end;
end;

procedure TAccountSelectDialog.accountVListInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  xAccount : TAccount;
begin
  if cbMyAccounts.Checked or cbForSale.Checked then
  begin
    xAccount := TNode.Node.TransactionStorage.BlockManager.AccountStorage.Account(FAccounts.Get(Node.Index));
  end
  else begin
    xAccount := TNode.Node.TransactionStorage.BlockManager.AccountStorage.Account(Node.Index);
  end;
  Sender.SetNodeData(Node, xAccount);
end;

procedure TAccountSelectDialog.accountVListNodeDblClick(
  Sender: TBaseVirtualTree; const HitInfo: THitInfo);
begin
  FSelectedAccount := PAccount(HitInfo.HitNode.GetData)^;
  ModalResult := mrOk;
  CloseModal;
end;

procedure TAccountSelectDialog.btnOkClick(Sender: TObject);
begin
  if accountVList.FocusedNode = nil
  then begin
    MessageDlg('Please select an account', mtError, [mbOK],0);
    exit;
  end;
  FSelectedAccount := PAccount(accountVList.FocusedNode.GetData)^;
end;

procedure TAccountSelectDialog.cbForSaleClick(Sender: TObject);
begin
  UpdateAccounts;
end;

procedure TAccountSelectDialog.cbMyAccountsClick(Sender: TObject);
begin
  UpdateAccounts;
end;

procedure TAccountSelectDialog.edAccountNameExit(Sender: TObject);
begin
  accountVList.ReinitNode(nil, true);
end;

procedure TAccountSelectDialog.FormCreate(Sender: TObject);
begin
  accountVList.NodeDataSize := sizeof(TAccount);
  accountVList.RootNodeCount := TNode.Node.TransactionStorage.BlockManager.AccountStorage.AccountsCount;
end;

procedure TAccountSelectDialog.FormDestroy(Sender: TObject);
begin
  if assigned(FAccounts) then FreeAndNil(FAccounts);
end;

procedure TAccountSelectDialog.SetJustForSale(const Value: boolean);
begin
  FJustForSale := Value;
  cbForSale.Checked := Value;
  cbForSale.Enabled := not Value;
end;

procedure TAccountSelectDialog.SetJustMyAccounts(const Value: boolean);
begin
  FJustMyAccounts := Value;
  cbMyAccounts.Checked := Value;
  cbMyAccounts.Enabled := not Value;
end;

procedure TAccountSelectDialog.UpdateAccounts;
var
  i: integer;
begin
  if cbForSale.Checked then begin
    if not assigned(FAccounts)
    then FAccounts := TOrderedList.Create
    else FAccounts.Clear;
      if cbMyAccounts.Checked then begin
        for i := 0 to FAccounts.Count - 1 do begin
           if TNode.Node.TransactionStorage.BlockManager.AccountStorage.Account(FAccounts.Get(i)).AccountInfo.state <> as_ForSale
           then FAccounts.Delete(i);
        end;
      end else begin
        FAccounts.Clear;
        for i := 0 to TNode.Node.TransactionStorage.BlockManager.AccountStorage.AccountsCount - 1 do
        begin
          if TNode.Node.TransactionStorage.BlockManager.AccountStorage.Account(i).AccountInfo.state = as_ForSale
          then FAccounts.Add(TNode.Node.TransactionStorage.BlockManager.AccountStorage.Account(i).AccountNumber);
        end;
      end;
    accountVList.RootNodeCount := FAccounts.Count;
  end else begin
  if cbMyAccounts.Checked then begin
    if not assigned(FAccounts)
    then FAccounts := TOrderedList.Create
    else FAccounts.Clear;

    for i:=0 to TNode.Node.KeyManager.AccountsKeyList.Count - 1 do begin
     FAccounts.AppendFrom(TNode.Node.KeyManager.AccountsKeyList.AccountList[i]);
    end;
    accountVList.RootNodeCount := FAccounts.Count;
  end else begin
    accountVList.RootNodeCount := TNode.Node.TransactionStorage.BlockManager.AccountStorage.AccountsCount;
    FreeAndNil(FAccounts);
  end;
  end;
  accountVList.ReinitNode(nil, true);
end;

end.
