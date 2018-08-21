unit UFRMPayloadDecoder;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ 
  Copyright (c) Albert Molina 2016 - 2018 original code from PascalCoin https://pascalcoin.org/

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of Pascal Coin, a P2P crypto currency without need of
  historical operations.   

  If you like it, consider a donation using BitCoin:
    16K3HCZRhFUtM8GdWRcfKeaa6KsuyxZaYk

  }


interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UBlockChain, UCrypto, UWalletKeys, Buttons, ComCtrls,
  UAppParams, MicroCoin.Transaction.Base;

type

  { TFRMPayloadDecoder }

  TFRMPayloadDecoder = class(TForm)
    Label1: TLabel;
    lblBlock: TLabel;
    lblDateTime: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    lblOperationTxt: TLabel;
    PageControl: TPageControl;
    tsDecoded: TTabSheet;
    tsDecodeMethods: TTabSheet;
    cbMethodPublicPayload: TCheckBox;
    cbUsingPrivateKeys: TCheckBox;
    cbUsingPasswords: TCheckBox;
    memoPasswords: TMemo;
    Label7: TLabel;
    lblDecodedMethod: TLabel;
    Label3: TLabel;
    bbSaveMethods: TBitBtn;
    bbClose: TBitBtn;
    memoDecoded: TMemo;
    memoOriginalPayloadInHexa: TMemo;
    lblPasswordsInfo: TLabel;
    lblAmountCaption: TLabel;
    lblAmount: TLabel;
    lblFeeCaption: TLabel;
    lblFee: TLabel;
    Label4: TLabel;
    bbFind: TBitBtn;
    ebOphash: TEdit;
    lblSenderCaption: TLabel;
    lblSender: TLabel;
    lblReceiverCaption: TLabel;
    lblReceiver: TLabel;
    lblReceiverInfo: TLabel;
    cbShowAsHexadecimal: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure PageControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure cbMethodPublicPayloadClick(Sender: TObject);
    procedure bbSaveMethodsClick(Sender: TObject);
    procedure memoDecodedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bbFindClick(Sender: TObject);
    procedure ebOphashExit(Sender: TObject);
    procedure ebOphashKeyPress(Sender: TObject; var Key: Char);
    procedure cbShowAsHexadecimalClick(Sender: TObject);
  private
    FOpResume : TTransactionData;
    FWalletKeys : TWalletKeys;
    FSavedDecodeMethods : boolean;
    FAppParams : TAppParams;
    FSemaphor : Boolean;
    { Private declarations }
    Procedure TryToDecode;
    Procedure SaveMethods;
    procedure SetOpResume(const Value: TTransactionData);
  public
    { Public declarations }
    Procedure Init(Const AOperationResume : TTransactionData; WalletKeys : TWalletKeys; AppParams : TAppParams);
    Property OpResume : TTransactionData read FOpResume write SetOpResume;
    Procedure DoFind(Const OpHash : String);
  end;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Uses UNode, UTime, UECIES, UAES, UAccounts;

resourcestring
  rsSearchOperat = 'Search operation by OpHash';
  rsInsertOperat = 'Insert Operation Hash value (OpHash)';
  rsPossiblePass = 'Possible passwords: %d';
  rsValueIsNotAn = 'Value is not an hexadecimal string';
  rsValueIsNotAV = 'Value is not a valid OpHash';
  rsInternalErro = 'Internal error 20161114-1';
  rsSaveNewDecod = 'Save new decode methods?';
  rsPendingBlock = '(Pending block)';
  rsSender = 'Sender:';
  rsAccount = 'Account:';
  rsNotEncrypted = 'Not encrypted payload';
  rsEncryptedWit = 'Encrypted with EC %s';
  rsEncryptedWit2 = 'Encrypted with pwd:"%s"';
  rsCANNOTDECRYP = 'CANNOT DECRYPT';
  rsNoPayload = '(No payload)';

{ TFRMPayloadDecoder }

procedure TFRMPayloadDecoder.bbSaveMethodsClick(Sender: TObject);
begin
  SaveMethods;
  PageControl.ActivePage := tsDecoded;
  TryToDecode;
end;

procedure TFRMPayloadDecoder.bbFindClick(Sender: TObject);
Var oph : String;
begin
  oph := TCrypto.ToHexaString( FOpResume.OperationHash );
  if not InputQuery(rsSearchOperat, rsInsertOperat, oph
    ) then exit;
  DoFind(oph);
end;

procedure TFRMPayloadDecoder.cbMethodPublicPayloadClick(Sender: TObject);
begin
  FSavedDecodeMethods := false;
  lblPasswordsInfo.Caption := Format(rsPossiblePass, [memoPasswords.Lines.Count]
    );
end;

procedure TFRMPayloadDecoder.cbShowAsHexadecimalClick(Sender: TObject);
begin
  TryToDecode;
end;

procedure TFRMPayloadDecoder.DoFind(Const OpHash : String);
Var
  r : TRawBytes;
  pcops : TPCOperationsComp;
  b : Cardinal;
  opbi : Integer;
  opr : TTransactionData;
begin
  // Search for an operation based on "ophash"
  if (trim(OpHash)='') then begin
    OpResume := TTransactionData.Empty;
    exit;
  end;
  try
    r := TCrypto.HexaToRaw(trim(ophash));
    if (r='') then begin
      raise Exception.Create(rsValueIsNotAn);
    end;
    pcops := TPCOperationsComp.Create(Nil);
    try
      If not TNode.Node.FindOperation(pcops,r,b,opbi) then begin
        raise Exception.Create(rsValueIsNotAV);
      end;
      If not pcops.Operation[opbi].GetTransactionData(b,pcops.Operation[opbi].SignerAccount,opr) then begin
        raise Exception.Create(rsInternalErro);
      end;
      opr.NOpInsideBlock:=opbi;
      opr.time:=pcops.OperationBlock.timestamp;
      OpResume := opr;
    finally
      pcops.Free;
    end;
  Except
    OpResume := TTransactionData.Empty;
    try
      FSemaphor := true;
      ebOphash.Text := trim(ophash);
    finally
      FSemaphor := false;
    end;
    Raise;
  end;
end;

procedure TFRMPayloadDecoder.ebOphashExit(Sender: TObject);
begin
  DoFind(ebOphash.Text);
end;

procedure TFRMPayloadDecoder.ebOphashKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then DoFind(ebOphash.Text);
end;

procedure TFRMPayloadDecoder.FormCreate(Sender: TObject);
begin
  FSemaphor := true;
  try
    FWalletKeys := Nil;
    FAppParams := Nil;
    memoDecoded.Lines.Clear;
    memoOriginalPayloadInHexa.Lines.Clear;
    lblPasswordsInfo.Caption := '';
    OpResume := TTransactionData.Empty;
  finally
    FSemaphor := false;
  end;
end;

procedure TFRMPayloadDecoder.Init(Const AOperationResume : TTransactionData; WalletKeys : TWalletKeys; AppParams : TAppParams);
begin
  FWalletKeys := WalletKeys;
  FAppParams := AppParams;
  OpResume := AOperationResume;
  FSavedDecodeMethods := true;
  PageControl.ActivePage := tsDecoded;
  TryToDecode;
end;

procedure TFRMPayloadDecoder.memoDecodedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_ESCAPE then Close;

end;

procedure TFRMPayloadDecoder.PageControlChanging(Sender: TObject; var AllowChange: Boolean);
begin
  //
  if PageControl.ActivePage=tsDecodeMethods then begin
    If not FSavedDecodeMethods then begin
      case Application.MessageBox(PChar(rsSaveNewDecod), PChar(Application.Title
        ), MB_YESNOCANCEL+MB_ICONQUESTION) of
        IDYES : Begin
          SaveMethods;
        End;
        IDCANCEL : begin
          AllowChange := false;
        end;
      end;

    end;
  end else begin
    FSavedDecodeMethods := true;
  end;
end;

procedure TFRMPayloadDecoder.SaveMethods;
begin
  FAppParams.ParamByName['PayloadDecoder.notencrypted'].SetAsBoolean(cbMethodPublicPayload.Checked);
  FAppParams.ParamByName['PayloadDecoder.usingprivatekeys'].SetAsBoolean(cbUsingPrivateKeys.Checked);
  FAppParams.ParamByName['PayloadDecoder.usingpasswords'].SetAsBoolean(cbUsingPasswords.Checked);
  FAppParams.ParamByName['PayloadDecoder.passwords'].SetAsString(memoPasswords.Lines.Text);
  FAppParams.ParamByName['PayloadDecoder.showashexadecimal'].SetAsBoolean(cbShowAsHexadecimal.Checked);
  FSavedDecodeMethods := true;
end;

procedure TFRMPayloadDecoder.SetOpResume(const Value: TTransactionData);
Var sem : Boolean;
begin
  sem := FSemaphor;
  Try
    FSemaphor := false;
    FOpResume := Value;
    if Not Value.valid then begin
      lblBlock.Caption := '';
      lblDateTime.Caption := '';
      lblOperationTxt.Caption := '';
      lblDecodedMethod.Caption := '';
      lblFee.Caption := '';
      lblPasswordsInfo.Caption := '';
      lblAmount.Caption := '';
      lblSender.Caption := '';
      lblReceiver.Caption := '';
      lblReceiverInfo.Visible := false;
      exit;
    end;
    If (Value.NOpInsideBlock>=0) then
      lblBlock.Caption := inttostr(Value.Block)+'/'+inttostr(Value.NOpInsideBlock+1)
    else lblBlock.Caption := inttostr(Value.Block);
    if Value.time>10000 then begin
      lblDateTime.Caption := DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(Value.time)));
      lblDateTime.Font.Color := clBlack;
    end else begin
      lblDateTime.Caption := rsPendingBlock;
      lblDateTime.Font.Color := clRed;
    end;
    lblOperationTxt.Caption := Value.OperationTxt;
    lblAmount.Caption := TAccountComp.FormatMoney(value.Amount);
    if Value.Amount>0 then lblAmount.Font.Color := clGreen
    else if Value.Amount=0 then lblAmount.Font.Color := clGray
    else lblAmount.Font.Color := clRed;
    If (Value.SignerAccount>=0) And (Value.DestAccount>=0) then begin
      lblSenderCaption.Caption := rsSender;
      lblSender.Caption := TAccountComp.AccountNumberToAccountTxtNumber(Value.SignerAccount);
      lblReceiverCaption.Visible := true;
      lblReceiver.Caption := TAccountComp.AccountNumberToAccountTxtNumber(Value.DestAccount);
      lblReceiver.Visible := true;
      lblFeeCaption.Visible := Value.AffectedAccount=Value.SignerAccount;
      lblFee.Visible := lblFeeCaption.Visible;
      lblReceiverInfo.Visible := Not lblFee.Visible;
    end else begin
      lblSenderCaption.Caption := rsAccount;
      lblSender.caption := TAccountComp.AccountNumberToAccountTxtNumber(Value.AffectedAccount);
      lblReceiverCaption.Visible := false;
      lblReceiver.Visible := false;
      lblFeeCaption.Visible := true;
      lblFee.Visible := true;
      lblReceiverInfo.Visible := false;
    end;
    lblFee.Caption := TAccountComp.FormatMoney(value.Fee);
    if Value.Fee>0 then lblFee.Font.Color := clGreen
    else if Value.Fee=0 then lblFee.Font.Color := clGray
    else lblFee.Font.Color := clRed;
    ebOpHash.text := TCrypto.ToHexaString(Value.OperationHash);
    memoOriginalPayloadInHexa.Lines.Text := TCrypto.ToHexaString(Value.OriginalPayload);
    if Assigned(FWalletKeys) then begin
      cbMethodPublicPayload.Checked := FAppParams.ParamByName['PayloadDecoder.notencrypted'].GetAsBoolean(true);
      cbUsingPrivateKeys.Checked := FAppParams.ParamByName['PayloadDecoder.usingprivatekeys'].GetAsBoolean(true);
      cbUsingPasswords.Checked := FAppParams.ParamByName['PayloadDecoder.usingpasswords'].GetAsBoolean(true);
      memoPasswords.Lines.Text := FAppParams.ParamByName['PayloadDecoder.passwords'].GetAsString('');
      cbShowAsHexadecimal.Checked := FAppParams.ParamByName['PayloadDecoder.showashexadecimal'].GetAsBoolean(false);
    end else begin
      cbMethodPublicPayload.Checked := true;
      cbUsingPrivateKeys.Checked := true;
      cbUsingPasswords.Checked := true;
      memoPasswords.Lines.Text := '';
    end;
    FSavedDecodeMethods := true;
    PageControl.ActivePage := tsDecoded;
    TryToDecode;
  Finally
    FSemaphor := sem;
  End;
end;

procedure TFRMPayloadDecoder.TryToDecode;
  Function UseWallet(Const raw : TRawBytes; var Decrypted : AnsiString; var WalletKey : TWalletKey) : Boolean;
  Var i : Integer;
  begin
    Result := false;
    if Not assigned(FWalletKeys) then exit;

    for i := 0 to FWalletKeys.Count - 1 do begin
      WalletKey := FWalletKeys.Key[i];
      If Assigned(WalletKey.PrivateKey) then begin
        If ECIESDecrypt(WalletKey.PrivateKey.EC_OpenSSL_NID,WalletKey.PrivateKey.PrivateKey,false,raw,Decrypted) then begin
          Result := true;
          exit;
        end;
      end;
    end;

  end;

  Function  UsePassword(const raw : TRawBytes; var Decrypted,PasswordUsed : AnsiString) : Boolean;
  Var i : Integer;
  Begin
    Result := false;
    for i := 0 to memoPasswords.Lines.Count - 1 do begin
      if (TAESComp.EVP_Decrypt_AES256(raw,memoPasswords.Lines[i],Decrypted)) then begin
        if (TCrypto.IsHumanReadable(Decrypted)) then begin
          Result := true;
          PasswordUsed := memoPasswords.Lines[i];
          exit;
        end;
      end;
    end;
  End;


Var raw : TRawBytes;
  WalletKey : TWalletKey;
  Decrypted,PasswordUsed : AnsiString;
  ok : boolean;
begin
  ok := true;
  if Assigned(FWalletKeys) And Assigned(FAppParams) then begin
    raw := FOpResume.OriginalPayload;
    if raw<>'' then begin
      // First try to a human readable...
      if (cbMethodPublicPayload.Checked) and (TCrypto.IsHumanReadable(raw)) then begin
        if cbShowAsHexadecimal.Checked then memoDecoded.Lines.Text := TCrypto.ToHexaString(raw)
        else memoDecoded.Lines.Text := raw;
        lblDecodedMethod.Caption := rsNotEncrypted;
      end else if (cbUsingPrivateKeys.Checked) And (UseWallet(raw,Decrypted,WalletKey)) then begin
        if cbShowAsHexadecimal.Checked then memoDecoded.Lines.Text := TCrypto.ToHexaString(Decrypted)
        else memoDecoded.Lines.Text := Decrypted;
        lblDecodedMethod.Caption := Format(rsEncryptedWit, [
          TAccountComp.GetECInfoTxt(WalletKey.PrivateKey.EC_OpenSSL_NID)]);
      end else if (cbUsingPasswords.Checked) And (UsePassword(raw,Decrypted,PasswordUsed)) then begin
        if cbShowAsHexadecimal.Checked then memoDecoded.Lines.Text := TCrypto.ToHexaString(Decrypted)
        else memoDecoded.Lines.Text := Decrypted;
        lblDecodedMethod.Caption := Format(rsEncryptedWit2, [PasswordUsed]);
      end else begin
        memoDecoded.Lines.Text := rsCANNOTDECRYP;
        lblDecodedMethod.Caption := '';
        ok := false;
      end;
      if ok then begin
        memoDecoded.Font.Color := clBlack;
        memoDecoded.Color := clWhite;
      end else begin
        memoDecoded.Font.Color := clRed;
        memoDecoded.Color := clBtnFace;
      end;
    end else begin
      memoDecoded.Lines.Text := rsNoPayload;
      memoDecoded.Font.Color := clDkGray;
      memoDecoded.Color := clLtGray;
      lblDecodedMethod.Caption := '';
    end;
  end else begin
    memoDecoded.Lines.Text := '';
    lblDecodedMethod.Caption := '';
  end;
end;

end.
