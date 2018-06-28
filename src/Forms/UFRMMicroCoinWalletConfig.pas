unit UFRMMicroCoinWalletConfig;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ Copyright (c) 2017 by Peter Nemeth

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of Micro Coin, a P2P crypto currency without need of
  historical operations.

  If you like it, consider a donation using BitCoin:
  16K3HCZRhFUtM8GdWRcfKeaa6KsuyxZaYk

  }

interface

uses
{$IFnDEF FPC}
  Windows,
  ShellApi,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, UAppParams, UWalletKeys;

type

  TMinerPrivateKey = (mpk_NewEachTime, mpk_Random, mpk_Selected);

  { TFRMMicroCoinWalletConfig }

  TFRMMicroCoinWalletConfig = class(TForm)
    cbJSONRPCMinerServerActive: TCheckBox;
    ebDefaultFee: TEdit;
    Label1: TLabel;
    cbSaveLogFiles: TCheckBox;
    cbShowLogs: TCheckBox;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    udInternetServerPort: TUpDown;
    ebInternetServerPort: TEdit;
    Label2: TLabel;
    lblDefaultInternetServerPort: TLabel;
    bbUpdatePassword: TBitBtn;
    Label3: TLabel;
    ebMinerName: TEdit;
    Label4: TLabel;
    cbShowModalMessages: TCheckBox;
    Label5: TLabel;
    udJSONRPCMinerServerPort: TUpDown;
    ebJSONRPCMinerServerPort: TEdit;
    lblDefaultJSONRPCMinerServerPort: TLabel;
    gbMinerPrivateKey: TGroupBox;
    rbGenerateANewPrivateKeyEachBlock: TRadioButton;
    rbUseARandomKey: TRadioButton;
    rbMineAllwaysWithThisKey: TRadioButton;
    cbPrivateKeyToMine: TComboBox;
    cbSaveDebugLogs: TCheckBox;
    bbOpenDataFolder: TBitBtn;
    cbJSONRPCPortEnabled: TCheckBox;
    ebJSONRPCAllowedIPs: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure bbUpdatePasswordClick(Sender: TObject);
    procedure cbSaveLogFilesClick(Sender: TObject);
    procedure bbOpenDataFolderClick(Sender: TObject);
    procedure cbJSONRPCPortEnabledClick(Sender: TObject);
  private
    FAppParams: TAppParams;
    FWalletKeys: TWalletKeys;
    procedure SetAppParams(const Value: TAppParams);
    procedure SetWalletKeys(const Value: TWalletKeys);
    Procedure UpdateWalletConfig;
    { Private declarations }
  public
    { Public declarations }
    Property AppParams : TAppParams read FAppParams write SetAppParams;
    Property WalletKeys : TWalletKeys read FWalletKeys write SetWalletKeys;
  end;

implementation

uses UConst, UAccounts, ULog, UCrypto, UFolderHelper;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

resourcestring
  rsServerPortAn = 'Server port and JSON-RPC Server miner port are equal!';
  rsInvalidFeeVa = 'Invalid Fee value';
  rsMustSelectAP = 'Must select a private key';
  rsInvalidPriva = 'Invalid private key';
  rsWalletPasswo = 'Wallet Password';
  rsInsertWallet = 'Insert Wallet Password';
  rsInvalidPassw = 'Invalid password';
  rsChangePasswo = 'Change password';
  rsTypeNewPassw = 'Type new password';
  rsPasswordCann = 'Password cannot start or end with a space character';
  rsTypeNewPassw2 = 'Type new password again';
  rsTwoPasswords = 'Two passwords are different!';
  rsPasswordChan = 'Password changed!%s%sPlease note that your new password is'
    +' "%s"%s%s(If you lose this password, you will lose your Wallet forever !)';
  rsDefaultD = '(Default %d)';
  rsExceptionAtS = 'Exception at SetAppParams: %s';
  rsWalletWithou = 'Wallet without password, protect it!';
  rsChangeWallet = 'Change Wallet password';
  rsWalletWithPa = 'Wallet with password, change it!';
  rsWalletPasswo2 = '(Wallet password)';

procedure TFRMMicroCoinWalletConfig.bbOkClick(Sender: TObject);
Var df : Int64;
  mpk : TMinerPrivateKey;
  i : Integer;
begin
  if udInternetServerPort.Position = udJSONRPCMinerServerPort.Position
    then raise Exception.Create(rsServerPortAn);

  if TAccountComp.TxtToMoney(ebDefaultFee.Text,df) then begin
    AppParams.ParamByName[CT_PARAM_DefaultFee].SetAsInt64(df);
  end else begin
    ebDefaultFee.Text := TAccountComp.FormatMoney(AppParams.ParamByName[CT_PARAM_DefaultFee].GetAsInteger(0));
    raise Exception.Create(rsInvalidFeeVa);
  end;
  AppParams.ParamByName[CT_PARAM_InternetServerPort].SetAsInteger(udInternetServerPort.Position );
  if rbGenerateANewPrivateKeyEachBlock.Checked then mpk := mpk_NewEachTime
  else if rbUseARandomKey.Checked then mpk := mpk_Random
  else if rbMineAllwaysWithThisKey.Checked then begin
    mpk := mpk_Selected;
    if cbPrivateKeyToMine.ItemIndex<0 then raise Exception.Create(rsMustSelectAP
      );
    i := PtrInt(cbPrivateKeyToMine.Items.Objects[cbPrivateKeyToMine.ItemIndex]);
    if (i<0) Or (i>=FWalletKeys.Count) then raise Exception.Create(
      rsInvalidPriva);
    AppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey].SetAsString( TAccountComp.AccountKey2RawString( FWalletKeys.Key[i].AccountKey ) );
  end else mpk := mpk_Random;

  AppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].SetAsInteger(integer(mpk));
  AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].SetAsBoolean(cbJSONRPCMinerServerActive.Checked );
  AppParams.ParamByName[CT_PARAM_SaveLogFiles].SetAsBoolean(cbSaveLogFiles.Checked );
  AppParams.ParamByName[CT_PARAM_ShowLogs].SetAsBoolean(cbShowLogs.Checked );
  AppParams.ParamByName[CT_PARAM_SaveDebugLogs].SetAsBoolean(cbSaveDebugLogs.Checked);
  AppParams.ParamByName[CT_PARAM_MinerName].SetAsString(ebMinerName.Text);
  AppParams.ParamByName[CT_PARAM_ShowModalMessages].SetAsBoolean(cbShowModalMessages.Checked);
  AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].SetAsInteger(udJSONRPCMinerServerPort.Position);
  AppParams.ParamByName[CT_PARAM_JSONRPCEnabled].SetAsBoolean(cbJSONRPCPortEnabled.Checked);
  AppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].SetAsString(ebJSONRPCAllowedIPs.Text);

  ModalResult := MrOk;
end;

procedure TFRMMicroCoinWalletConfig.bbOpenDataFolderClick(Sender: TObject);
begin
  {$IFDEF FPC}
  OpenDocument(pchar(TFolderHelper.GetMicroCoinDataFolder))
  {$ELSE}
  shellexecute(0, 'open', pchar(TFolderHelper.GetMicroCoinDataFolder), nil, nil, SW_SHOW)
  {$ENDIF}
end;

procedure TFRMMicroCoinWalletConfig.bbUpdatePasswordClick(Sender: TObject);
Var s,s2 : String;
begin
  if Not Assigned(FWalletKeys) then exit;
  if Not FWalletKeys.IsValidPassword then begin
    s := '';
    Repeat
      if not InputQuery(rsWalletPasswo, rsInsertWallet, s) then exit;
      FWalletKeys.WalletPassword := s;
      if not FWalletKeys.IsValidPassword then Application.MessageBox(PChar(
        rsInvalidPassw), PChar(Application.Title), MB_ICONERROR+MB_OK);
    Until FWalletKeys.IsValidPassword;
  end;
  if FWalletKeys.IsValidPassword then begin
    s := ''; s2 := '';
    if not InputQuery(rsChangePasswo, rsTypeNewPassw, s) then exit;
    if trim(s)<>s then raise Exception.Create(rsPasswordCann);
    if not InputQuery(rsChangePasswo, rsTypeNewPassw2, s2) then exit;
    if s<>s2 then raise Exception.Create(rsTwoPasswords);

    FWalletKeys.WalletPassword := s;
    Application.MessageBox(PChar(Format(rsPasswordChan, [#10, #10, s, #10, #10])
      ),
      PChar(Application.Title),MB_ICONWARNING+MB_OK);
  end;
  UpdateWalletConfig;
end;

procedure TFRMMicroCoinWalletConfig.cbJSONRPCPortEnabledClick(Sender: TObject);
begin
  ebJSONRPCAllowedIPs.Enabled := cbJSONRPCPortEnabled.Checked;
end;

procedure TFRMMicroCoinWalletConfig.cbSaveLogFilesClick(Sender: TObject);
begin
  cbSaveDebugLogs.Enabled := cbSaveLogFiles.Checked;
end;

procedure TFRMMicroCoinWalletConfig.FormCreate(Sender: TObject);
begin
  lblDefaultInternetServerPort.Caption := Format(rsDefaultD, [CT_NetServer_Port]
    );
  udInternetServerPort.Position := CT_NetServer_Port;
  ebDefaultFee.Text := TAccountComp.FormatMoney(0);
  ebMinerName.Text := '';
  bbUpdatePassword.Enabled := false;
  UpdateWalletConfig;
  lblDefaultJSONRPCMinerServerPort.Caption := Format(rsDefaultD, [
    CT_JSONRPCMinerServer_Port]);
end;

procedure TFRMMicroCoinWalletConfig.SetAppParams(const Value: TAppParams);
Var i : Integer;
begin
  FAppParams := Value;
  if Not Assigned(Value) then exit;
  Try
    udInternetServerPort.Position := AppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
    ebDefaultFee.Text := TAccountComp.FormatMoney(AppParams.ParamByName[CT_PARAM_DefaultFee].GetAsInt64(0));
    cbJSONRPCMinerServerActive.Checked := AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].GetAsBoolean(true);
    case TMinerPrivateKey(AppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].GetAsInteger(Integer(mpk_Random))) of
      mpk_NewEachTime : rbGenerateANewPrivateKeyEachBlock.Checked := true;
      mpk_Random : rbUseARandomKey.Checked := true;
      mpk_Selected : rbMineAllwaysWithThisKey.Checked := true;
    else rbUseARandomKey.Checked := true;
    end;
    UpdateWalletConfig;
    cbSaveLogFiles.Checked := AppParams.ParamByName[CT_PARAM_SaveLogFiles].GetAsBoolean(false);
    cbShowLogs.Checked := AppParams.ParamByName[CT_PARAM_ShowLogs].GetAsBoolean(false);
    cbSaveDebugLogs.Checked := AppParams.ParamByName[CT_PARAM_SaveDebugLogs].GetAsBoolean(false);
    ebMinerName.Text := AppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
    cbShowModalMessages.Checked := AppParams.ParamByName[CT_PARAM_ShowModalMessages].GetAsBoolean(false);
    udJSONRPCMinerServerPort.Position := AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].GetAsInteger(CT_JSONRPCMinerServer_Port);
    cbJSONRPCPortEnabled.Checked := AppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    ebJSONRPCAllowedIPs.Text := AppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1;');
  Except
    On E:Exception do begin
      TLog.NewLog(lterror, ClassName, Format(rsExceptionAtS, [E.Message]));
    end;
  End;
  cbSaveLogFilesClick(nil);
  cbJSONRPCPortEnabledClick(nil);
end;

procedure TFRMMicroCoinWalletConfig.SetWalletKeys(const Value: TWalletKeys);
begin
  FWalletKeys := Value;
  UpdateWalletConfig;
end;


procedure TFRMMicroCoinWalletConfig.UpdateWalletConfig;
Var i, iselected : Integer;
  s : String;
  wk : TWalletKey;
begin
  if Assigned(FWalletKeys) then begin
    if FWalletKeys.IsValidPassword then begin
      if FWalletKeys.WalletPassword='' then begin
        bbUpdatePassword.Caption := rsWalletWithou;
      end else begin
        bbUpdatePassword.Caption := rsChangeWallet;
      end;
    end else begin
        bbUpdatePassword.Caption := rsWalletWithPa;
    end;
    cbPrivateKeyToMine.Items.Clear;
    for i := 0 to FWalletKeys.Count - 1 do begin
      wk := FWalletKeys.Key[i];
      if (wk.Name='') then begin
        s := TCrypto.ToHexaString( TAccountComp.AccountKey2RawString(wk.AccountKey));
      end else begin
        s := wk.Name;
      end;
      if wk.CryptedKey<>'' then begin
        cbPrivateKeyToMine.Items.AddObject(s,TObject(i));
      end;
    end;
    cbPrivateKeyToMine.Sorted := true;
    if Assigned(FAppParams) then begin
      s := FAppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey].GetAsString('');
      iselected := FWalletKeys.IndexOfAccountKey(TAccountComp.RawString2Accountkey(s));
      if iselected>=0 then begin
        iselected :=  cbPrivateKeyToMine.Items.IndexOfObject(TObject(iselected));
        cbPrivateKeyToMine.ItemIndex := iselected;
      end;

    end;

  end else bbUpdatePassword.Caption := rsWalletPasswo2;
  bbUpdatePassword.Enabled := Assigned(FWAlletKeys);
end;

end.
