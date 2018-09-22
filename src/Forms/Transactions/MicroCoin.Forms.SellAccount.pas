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
| File:       MicroCoin.Forms.SellAccount.pas                                  |
| Created at: 2018-09-04                                                       |
| Purpose:    Form to list account(s) for sale                                 |
|==============================================================================}

unit MicroCoin.Forms.SellAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
  PngBitBtn, MicroCoin.Forms.AccountSelectDialog,
  MicroCoin.Node.Node, MicroCoin.Account.AccountKey,
  MicroCoin.Account.Data, MicroCoin.Common, UCrypto,
  DateUtils,
  MicroCoin.Account.Editors, MicroCoin.Transaction.ITransaction,
  MicroCoin.Transaction.Base, MicroCoin.Transaction.ListAccount;

type
  TSellAccountForm = class(TForm)
    Label3: TLabel;
    edFee: TEdit;
    edPrice: TEdit;
    Label1: TLabel;
    edNewPublicKey: TLabeledEdit;
    CheckBox1: TCheckBox;
    payloadPanel: TPanel;
    Label7: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    cbEncryptMode: TComboBox;
    edPassword: TEdit;
    edPayload: TMemo;
    Panel2: TPanel;
    bbSave: TPngBitBtn;
    PngBitBtn2: TPngBitBtn;
    edSellerAccount: TAccountEditor;
    edSignerAccount: TAccountEditor;
    Label2: TLabel;
    Label4: TLabel;
    edValidUntil: TEdit;
    Label5: TLabel;
    lbOfferValidTime: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure cbEncryptModeChange(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edValidUntilChange(Sender: TObject);
  private
    FAccount: TAccount;
    procedure SetAccount(const Value: TAccount);
    { Private declarations }
  public
    { Public declarations }
    property Account : TAccount read FAccount write SetAccount;
  end;

var
  SellAccountForm: TSellAccountForm;

implementation

{$R *.dfm}

procedure TSellAccountForm.cbEncryptModeChange(Sender: TObject);
begin
  edPassword.Enabled := cbEncryptMode.ItemIndex = 3;
end;

procedure TSellAccountForm.CheckBox1Click(Sender: TObject);
begin
  edValidUntil.Enabled := CheckBox1.Checked;
  edNewPublicKey.Enabled := CheckBox1.Checked;
end;

procedure TSellAccountForm.edValidUntilChange(Sender: TObject);
var
  xBlock : Cardinal;
  xBlock2: Cardinal;
begin
  lbOfferValidTime.Caption := '';

  if edValidUntil.Text='' then exit;

  if not TryStrToUInt(edValidUntil.Text, xBlock) then exit;

  if xBlock < TNode.Node.BlockManager.BlocksCount
  then exit;

  xBlock := xBlock - TNode.Node.BlockManager.BlocksCount + 1;
  xBlock2 := Round(TNode.Node.BlockManager.GetActualTargetSecondsAverage(300));
  xBlock2 := xBlock * xBlock2;
  xBlock := xBlock * 5 * 60;
  if xBlock2>xBlock then
  lbOfferValidTime.Caption :=
  'Estimated valid until: '
   + FormatDateTime('c',UnixToDateTime(TNode.Node.BlockManager.LastBlockFound.TimeStamp + xBlock, false))
   + ' ~ ' + FormatDateTime('c',UnixToDateTime(TNode.Node.BlockManager.LastBlockFound.TimeStamp + xBlock2, false))

  else

  lbOfferValidTime.Caption :=
  'Estimated valid until: '
   + FormatDateTime('c',UnixToDateTime(TNode.Node.BlockManager.LastBlockFound.TimeStamp + xBlock2, false))
   + ' ~ ' + FormatDateTime('c',UnixToDateTime(TNode.Node.BlockManager.LastBlockFound.TimeStamp + xBlock, false));

end;

procedure TSellAccountForm.FormCreate(Sender: TObject);
begin
  edValidUntil.Text := IntToStr(TNode.Node.BlockManager.BlocksCount);
end;

procedure TSellAccountForm.SetAccount(const Value: TAccount);
begin
  FAccount := Value;
  edSignerAccount.AccountNumber := TAccount.AccountNumberToString(Value.AccountNumber);
end;

procedure TSellAccountForm.bbSaveClick(Sender: TObject);
var
  xTransaction : ITransaction;
  xPrice, xFee: Int64;
  xPrivateKey: TECPrivateKey;
  xPayload: AnsiString;
  xIndex: integer;
  xErrors: AnsiString;
  xNewkey: TAccountKey;
  xBlock : Cardinal;
  xPassword: string;
begin

  while not TNode.Node.KeyManager.IsValidPassword
  do begin
   if not InputQuery('Unlock wallet', [#30+'Password:'], xPassword) then exit;
   TNode.Node.KeyManager.WalletPassword := xPassword;
  end;

  if not TCurrencyUtils.ParseValue(edPrice.Text, xPrice) then begin
    MessageDlg('Invalid price', mtError, [mbOk], 0);
    exit;
  end;

  if not TCurrencyUtils.ParseValue(edFee.Text, xFee) then begin
    MessageDlg('Invalid fee', mtError, [mbOk], 0);
    exit;
  end;

  xIndex := TNode.Node.KeyManager.IndexOfAccountKey(edSignerAccount.Account.AccountInfo.AccountKey);
  if xIndex < 0 then begin
    MessageDlg('Private key not found', mtError, [mbOK], 0);
    exit;
  end;

  xPrivateKey := TNode.Node.KeyManager[xIndex].PrivateKey;

  if edValidUntil.Text<>''
  then xBlock := StrToInt(edValidUntil.Text)
  else xBlock := 0;

  xNewkey := CT_TECDSA_Public_Nul;

  if edNewPublicKey.Text<>''
  then if not TAccountKey.AccountKeyFromImport(edNewPublicKey.Text, xNewkey, xErrors)
       then begin
         MessageDlg('Invalid public key: ' + xErrors, mtError, [mbOK], 0);
         exit;
       end;

  xTransaction := TListAccountForSaleTransaction.CreateListAccountForSale(
          edSignerAccount.Account.AccountNumber,
          edSignerAccount.Account.NumberOfTransactions+1,
          FAccount.AccountNumber, xPrice, xFee, edSellerAccount.Account.AccountNumber,
          xNewkey, xBlock, xPrivateKey, xPayload);

  if not TNode.Node.AddTransaction(nil, xTransaction, xErrors) then begin
     MessageDlg(xErrors, mtError, [mbOk], 0);
  end else begin
     MessageDlg('Transaction sucessfully executed', mtInformation, [mbOk], 0);
     Close;
  end;
end;

end.
