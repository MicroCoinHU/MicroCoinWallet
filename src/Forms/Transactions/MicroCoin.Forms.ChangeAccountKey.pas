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
| File:       MicroCoin.Forms.ChangeAccountKey.pas                             |
| Created at: 2018-09-04                                                       |
| Purpose:    Form to change account key                                       |
|==============================================================================}

unit MicroCoin.Forms.ChangeAccountKey;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, PngBitBtn,
  Vcl.ExtCtrls, MicroCoin.Account.Editors, MicroCoin.Account.AccountKey, UCrypto,
  MicroCoin.Common, MicroCoin.Account.Data, MicroCoin.Transaction.ChangeKey,
  MicroCoin.Node.Node,
  MicroCoin.Transaction.Base, MicroCoin.Transaction.ITransaction, MicroCoin.Transaction.Transaction;

type
  TChangeAccountKeyForm = class(TForm)
    edNewPublicKey: TLabeledEdit;
    Label3: TLabel;
    edFee: TEdit;
    payloadPanel: TPanel;
    Label7: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    cbEncryptMode: TComboBox;
    edPassword: TEdit;
    edPayload: TMemo;
    Panel2: TPanel;
    btnSave: TPngBitBtn;
    btnCancel: TPngBitBtn;
    edSignerAccount: TAccountEditor;
    Label1: TLabel;
    procedure cbEncryptModeChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FAccount: TAccount;
    procedure SetAccount(const Value: TAccount);
    { Private declarations }
  public
    { Public declarations }
  published
    property Account : TAccount read FAccount write SetAccount;
  end;

var
  ChangeAccountKeyForm: TChangeAccountKeyForm;

implementation
uses UECIES, UAES;
{$R *.dfm}

procedure TChangeAccountKeyForm.btnSaveClick(Sender: TObject);
var
  xNewkey: TECDSA_Public;
  xErrors: AnsiString;
  xFee: Int64;
  xSignerAccount: TAccount;
  xTransaction: ITransaction;
  xPayload : AnsiString;
  xIndex: integer;
  xPassword: string;
begin

  while not TNode.Node.KeyManager.IsValidPassword
  do begin
   if not InputQuery('Unlock wallet', [#30+'Password:'], xPassword) then exit;
   TNode.Node.KeyManager.WalletPassword := xPassword;
  end;

 if not TAccountKey.AccountKeyFromImport(edNewPublicKey.Text, xNewkey, xErrors) then
 begin
   MessageDlg('Invalid key: ' + xErrors, mtError, [mbOK],0);
   exit;
 end;

 if not TCurrencyUtils.ParseValue(edFee.Text, xFee) then begin
   MessageDlg('Invalid fee', mtError, [mbOk], 0);
   exit;
 end;

 xIndex := TNode.Node.KeyManager.IndexOfAccountKey(Account.AccountInfo.AccountKey);
 if xIndex<0 then begin
   MessageDlg('Key not found', mtError, [mbOk], 0);
   exit;
 end;

 xSignerAccount := edSignerAccount.Account;

 if Trim(edPayload.Text)<>'' then begin
    case cbEncryptMode.ItemIndex of
      0: xPayload := edPayload.Text;
      1: xPayload := ECIESEncrypt(account.AccountInfo.AccountKey, xPayload);
      2: xPayload := ECIESEncrypt(xSignerAccount.AccountInfo.AccountKey, xPayload);
      3: xPayload := TAESComp.EVP_Encrypt_AES256(xPayload, edPassword.Text);
    end;
  end else xPayload := '';

 xTransaction := TChangeKeyTransaction.Create(xSignerAccount.AccountNumber, xSignerAccount.n_operation+1, Account.AccountNumber,
         TNode.Node.KeyManager.Key[xIndex].PrivateKey,
         xNewkey, xFee, xPayload);

 if MessageDlg('Do you want execute this transaction: '+xTransaction.ToString+'?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
 then exit;

 if not TNode.Node.AddOperation(nil, xTransaction, xErrors) then begin
   MessageDlg(xErrors, mtError, [mbOK], 0);
 end else begin
   MessageDlg(xErrors, mtInformation, [mbOK], 0);
 end;
end;

procedure TChangeAccountKeyForm.cbEncryptModeChange(Sender: TObject);
begin
  edPassword.Enabled := cbEncryptMode.ItemIndex = 3;
end;

procedure TChangeAccountKeyForm.SetAccount(const Value: TAccount);
begin
  FAccount := Value;
  edSignerAccount.AccountNumber := TAccount.AccountNumberToAccountTxtNumber(account.AccountNumber);
end;

end.
