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
| File:       MicroCoin.Forms.BuyAccount.pas                                   |
| Created at: 2018-09-05                                                       |
| Purpose:    Dialog for purchase account                                      |
|==============================================================================}

unit MicroCoin.Forms.BuyAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, PngBitBtn,
  ExtCtrls, MicroCoin.Account.Editors, MicroCoin.Common, MicroCoin.Account.Data,
  MicroCoin.Account.AccountKey, UCrypto, MicroCoin.Transaction.ITransaction,
  MicroCoin.Keys.KeyManager, UWalletKeys,
  MicroCoin.Transaction.TransferMoney, MicroCoin.Node.Node;

type
  TBuyAccountForm = class(TForm)
    edSignerAccount: TAccountEditor;
    Label1: TLabel;
    edFee: TEdit;
    Label2: TLabel;
    cbKey: TComboBox;
    Label3: TLabel;
    Panel2: TPanel;
    btnSave: TPngBitBtn;
    btnCancel: TPngBitBtn;
    payloadPanel: TPanel;
    Label7: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    cbEncryptMode: TComboBox;
    edPassword: TEdit;
    edPayload: TMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAccount: TAccount;
    procedure SetAccount(const Value: TAccount);
  public
    property Account : TAccount read FAccount write SetAccount;
  end;

var
  BuyAccountForm: TBuyAccountForm;

implementation

uses UECIES, UAES;

{$R *.dfm}

procedure TBuyAccountForm.btnSaveClick(Sender: TObject);
var
  xFee: Int64;
  xPrivateKey: TECPrivateKey;
  xIndex: integer;
  xNewkey: TECDSA_Public;
  xPayload : AnsiString;
  xTransaction: ITransaction;
  xErrors: AnsiString;
  xPassword: string;
begin
  while not TNode.Node.KeyManager.IsValidPassword
  do begin
   if not InputQuery('Unlock wallet', [#30+'Password:'], xPassword) then exit;
   TNode.Node.KeyManager.WalletPassword := xPassword;
  end;

  if not TCurrencyUtils.ParseValue(edFee.Text, xFee)
  then begin
    MessageDlg('Invalid fee', mtError, [mbOk], 0);
    exit;
  end;

 xIndex := TNode.Node.KeyManager.IndexOfAccountKey(edSignerAccount.Account.AccountInfo.AccountKey);
 xPrivateKey := TNode.Node.KeyManager.Key[xIndex].PrivateKey;

 if Trim(edPayload.Text)<>'' then begin
    case cbEncryptMode.ItemIndex of
      0: xPayload := edPayload.Text;
      1: xPayload := ECIESEncrypt(account.AccountInfo.AccountKey, edPayload.Text);
      2: xPayload := ECIESEncrypt(edSignerAccount.Account.AccountInfo.AccountKey, edPayload.Text);
      3: xPayload := TAESComp.EVP_Encrypt_AES256(edPayload.Text, edPassword.Text);
    end;
  end else xPayload := '';

  xNewkey := TNode.Node.KeyManager[Integer(cbKey.Items.Objects[cbKey.ItemIndex])].AccountKey;
  xTransaction := TBuyAccountTransaction.CreateBuy(
          edSignerAccount.Account.AccountNumber,
          edSignerAccount.Account.NumberOfTransactions+1,
          Account.AccountNumber,
          Account.AccountInfo.AccountToPay,
          Account.AccountInfo.Price,
          Account.AccountInfo.Price,
          xFee,
          xNewkey,
          xPrivateKey,
          xPayload
        );
  if not TNode.Node.AddTransaction(nil, xTransaction, xErrors)
  then MessageDlg(xErrors, mtError, [mbOk], 0)
  else begin
    MessageDlg('Account purchased', mtInformation, [mbOk], 0);
    Close;
  end;
end;

procedure TBuyAccountForm.FormCreate(Sender: TObject);
var
  i: integer;
  xWalletKey: TWalletKey;
begin
  cbKey.Clear;
  for i:=0 to TNode.Node.KeyManager.Count-1 do begin
    xWalletKey:=TNode.Node.KeyManager[i];
    cbKey.Items.AddObject(xWalletKey.Name,TObject(i));
  end;
  if cbKey.Items.Count>0 then cbKey.ItemIndex := 0;
end;

procedure TBuyAccountForm.SetAccount(const Value: TAccount);
begin
  FAccount := Value;
  Caption := Format('Buy account: %s', [ TAccount.AccountNumberToString(Account.AccountNumber) ]);
end;

end.
