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
| File:       MicroCoin.Forms.EditAccount.pas                                  |
| Created at: 2018-09-04                                                       |
| Purpose:    Dialog for edit account data (name, key, etc)                    |
|==============================================================================}

unit MicroCoin.Forms.EditAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
  MicroCoin.Transaction.ITransaction, MicroCoin.Transaction.ChangeAccountInfo,
  MicroCoin.Common, UCrypto, UECIES, UAES,
  PngBitBtn, MicroCoin.Node.Node, MicroCoin.Account.Data, UWalletkeys, MicroCoin.Account.AccountKey,
  MicroCoin.Account.Editors;

type
  TEditAccountForm = class(TForm)
    edAccountName: TLabeledEdit;
    cbPrivateKey: TComboBox;
    Label1: TLabel;
    edAccountType: TEdit;
    Label2: TLabel;
    bbSave: TPngBitBtn;
    PngBitBtn2: TPngBitBtn;
    Label3: TLabel;
    payloadPanel: TPanel;
    cbEncryptMode: TComboBox;
    Label7: TLabel;
    edPassword: TEdit;
    Label9: TLabel;
    edPayload: TMemo;
    Label6: TLabel;
    Panel2: TPanel;
    edFee: TEdit;
    edSignerAccount: TAccountEditor;
    Label4: TLabel;
    procedure cbEncryptModeChange(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure edAccountNameKeyPress(Sender: TObject; var Key: Char);
  private
    FAccountNumber: cardinal;
    procedure SetAccountNumber(const Value: cardinal);
    { Private declarations }
  public
    { Public declarations }
  published
   property AccountNumber : cardinal read FAccountNumber write SetAccountNumber;
  end;

var
  EditAccountForm: TEditAccountForm;

implementation

resourcestring
  StrTransactionSuccessfullyExecuted = 'Transaction successfully executed';
  StrDoYouWantExecute = 'Do you want execute this transaction: ';
  StrPrivateKeyNotFound = 'Private key not found in wallet';
  StrInvalidFee = 'Invalid fee';
  StrUnlockWallet = 'Unlock wallet';
  StrPassword = 'Password:';

{$R *.dfm}

{ TEditAccountForm }

procedure TEditAccountForm.bbSaveClick(Sender: TObject);
var
  xTransaction : ITransaction;
  xAccount : TAccount;
  xWalletKey: TWalletKey;
  xSignerKey: TWalletKey;
  xFee: int64;
  xPayload, xErrors: AnsiString;
  xSignerAccount: TAccount;
  xIndex: integer;
  xPassword: string;
begin

  while not TNode.Node.KeyManager.IsValidPassword
  do begin
   if not InputQuery(StrUnlockWallet, [#30+StrPassword], xPassword) then exit;
   TNode.Node.KeyManager.WalletPassword := xPassword;
  end;

  xAccount := TNode.Node.BlockManager.AccountStorage.Accounts[FAccountNumber];
  if edSignerAccount.AccountNumber <> '' then begin
    xSignerAccount := edSignerAccount.Account;
  end else xSignerAccount := xAccount;

  xIndex := Integer(cbPrivateKey.Items.Objects[cbPrivateKey.ItemIndex]);
  xWalletKey := TNode.Node.KeyManager.Key[xIndex];

  xIndex := TNode.Node.KeyManager.IndexOfAccountKey(xAccount.AccountInfo.AccountKey);
  xSignerKey := TNode.Node.KeyManager[xIndex];

  if not TCurrencyUtils.ParseValue(edFee.Text, xFee) then begin
    MessageDlg(StrInvalidFee, mtError, [mbOk], 0);
    exit;
  end;

  xIndex :=  TNode.Node.KeyManager.IndexOfAccountKey(xAccount.AccountInfo.AccountKey);
  if xIndex<0 then begin
    MessageDlg(StrPrivateKeyNotFound, mtError, [mbOk],0);
    exit;
  end;

  if Trim(edPayload.Text)<>'' then begin
     case cbEncryptMode.ItemIndex of
      0: xPayload := edPayload.Text;
      1: xPayload := ECIESEncrypt(xAccount.AccountInfo.AccountKey, edPayload.Text);
      2: xPayload := ECIESEncrypt(xSignerAccount.AccountInfo.AccountKey, edPayload.Text);
      3: xPayload := TAESComp.EVP_Encrypt_AES256(edPayload.Text, edPassword.Text);
     end;
  end else xPayload := '';

  xTransaction := TChangeAccountInfoTransaction.CreateChangeAccountInfo(
     xSignerAccount.AccountNumber, xSignerAccount.NumberOfTransactions+1,
     xAccount.AccountNumber,
     xSignerKey.PrivateKey,
     not (xWalletKey.AccountKey = xAccount.AccountInfo.AccountKey),
     xWalletKey.AccountKey,
     (edAccountName.Text<>xAccount.Name),
     edAccountName.Text,
     edAccountType.Text<>IntToStr(xAccount.AccountType),
     StrToUInt(edAccountType.Text),
     xFee, xPayload);
    if MessageDlg(StrDoYouWantExecute+xTransaction.ToString+'?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then exit;
    if not TNode.Node.AddTransaction(nil, xTransaction, xErrors)
    then MessageDlg(xErrors, mtError, [mbOk], 0)
    else begin
      MessageDlg(StrTransactionSuccessfullyExecuted, mtInformation, [mbOK], 0);
      Close;
    end;
end;

procedure TEditAccountForm.cbEncryptModeChange(Sender: TObject);
begin
  edPassword.Enabled := cbEncryptMode.ItemIndex = 3;
end;

procedure TEditAccountForm.edAccountNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = ' ' then Key := #0;
end;

procedure TEditAccountForm.SetAccountNumber(const Value: cardinal);
var
  xAccount : TAccount;
  i : integer;
  xWalletKey: TWalletKey;
begin
  FAccountNumber := Value;
  xAccount := TNode.Node.BlockManager.AccountStorage.Accounts[FAccountNumber];
  edAccountName.Text := xAccount.Name;
  edAccountType.Text := IntToStr(xAccount.AccountType);
  Caption := Caption + ' - ' +TAccount.AccountNumberToString(Value);
  xAccount := TNode.Node.BlockManager.AccountStorage.Accounts[FAccountNumber];
  for i:=0 to TNode.Node.KeyManager.Count-1 do begin
    xWalletKey:=TNode.Node.KeyManager[i];
    cbPrivateKey.Items.AddObject(xWalletKey.Name,TObject(i));
    if xAccount.AccountInfo.AccountKey = xWalletKey.AccountKey then begin
      cbPrivateKey.ItemIndex := cbPrivateKey.Items.Count-1;
    end;
  end;
end;


end.
