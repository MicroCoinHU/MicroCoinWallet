program MicroCoinWallet;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFnDEF FPC}
  {$ELSE}
  {$IFDEF LINUX}
  {$ifdef FPC}
  cthreads,
  {$endif}
  {$else}
  windows,
  {$ENDIF}
  Interfaces,
  {$ENDIF}
  Forms,
  {$IFDEF FPC}LCLTranslator,{$endif}
  UBlockChain in 'src\MicroCoin\Core\UBlockChain.pas',
  UCrypto in 'src\MicroCoin\Core\UCrypto.pas',
  UTime in 'src\MicroCoin\Core\UTime.pas',
  UWalletKeys in 'src\MicroCoin\Core\UWalletKeys.pas',
  UOpTransaction in 'src\MicroCoin\Core\UOpTransaction.pas',
  UNetProtocol in 'src\MicroCoin\Core\UNetProtocol.pas',
  UAccounts in 'src\MicroCoin\Core\UAccounts.pas',
  UConst in 'src\MicroCoin\Core\UConst.pas',
  UThread in 'src\MicroCoin\Core\UThread.pas',
  ULog in 'src\MicroCoin\Core\ULog.pas',
  UNode in 'src\MicroCoin\Core\UNode.pas',
  UECIES in 'src\MicroCoin\Core\UECIES.pas',
  UAES in 'src\MicroCoin\Core\UAES.pas',
  UFRMWallet in 'src\Forms\UFRMWallet.pas' {FRMWallet},
  UFileStorage in 'src\MicroCoin\Core\UFileStorage.pas',
  UFolderHelper in 'src\MicroCoin\Utils\UFolderHelper.pas',
  UAppParams in 'src\MicroCoin\Utils\UAppParams.pas',
  UGridUtils in 'src\MicroCoin\Utils\UGridUtils.pas',
  UFRMMicroCoinWalletConfig in 'src\Forms\UFRMMicroCoinWalletConfig.pas' {FRMMicroCoinWalletConfig},
  UFRMAbout in 'src\Forms\UFRMAbout.pas' {FRMAbout},
  UFRMOperation in 'src\Forms\UFRMOperation.pas' {FRMOperation},
  UFRMWalletKeys in 'src\Forms\UFRMWalletKeys.pas' {FRMWalletKeys},
  UFRMNewPrivateKeyType in 'src\Forms\UFRMNewPrivateKeyType.pas' {FRMNewPrivateKeyType},
  UFRMPayloadDecoder in 'src\Forms\UFRMPayloadDecoder.pas' {FRMPayloadDecoder},
  UFRMNodesIp in 'src\Forms\UFRMNodesIp.pas' {FRMNodesIp},
  UTCPIP in 'src\MicroCoin\Core\UTCPIP.pas',
  UJSONFunctions in 'src\MicroCoin\Utils\UJSONFunctions.pas',
  URPC in 'src\MicroCoin\Core\URPC.pas',
  UPoolMining in 'src\MicroCoin\Core\UPoolMining.pas',
  UOpenSSL in 'src\MicroCoin\Core\UOpenSSL.pas',
  UOpenSSLdef in 'src\MicroCoin\Core\UOpenSSLdef.pas',
  {$ifndef FPC}
  Vcl.Themes,
  Vcl.Styles,
  {$endif }
  {$IFnDEF FPC}
  System.inifiles,
  {$ELSE}
  IniFiles,
  {$ENDIF }
  sysutils,
  MicroCoin.Account.AccountKey in 'src\MicroCoin\Core\Account\MicroCoin.Account.AccountKey.pas',
  MicroCoin.Common.Lists in 'src\MicroCoin\Core\Common\MicroCoin.Common.Lists.pas',
  MicroCoin.Transaction.TransactionList in 'src\MicroCoin\Core\Transaction\Lists\MicroCoin.Transaction.TransactionList.pas',
  MicroCoin.Transaction.Base in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.Base.pas',
  MicroCoin.Transaction.ChangeAccountInfo in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.ChangeAccountInfo.pas',
  MicroCoin.Transaction.ChangeKey in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.ChangeKey.pas',
  MicroCoin.Transaction.HashTree in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.HashTree.pas',
  MicroCoin.Transaction.ListAccount in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.ListAccount.pas',
  MicroCoin.Transaction.Manager in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.Manager.pas',
  MicroCoin.Transaction.RecoverFounds in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.RecoverFounds.pas',
  MicroCoin.Transaction.Transaction in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.Transaction.pas',
  MicroCoin.Transaction.TransferMoney in 'src\MicroCoin\Core\Transaction\MicroCoin.Transaction.TransferMoney.pas',
  UCommon in 'src\MicroCoin\Utils\UCommon.pas';

{.$R *.res}
{$R *.res}

var
  Storage : TIniFile;
  lang : String;
begin
  Application.Initialize;
  with TIniFile.Create('MicroCoinWallet.ini') do
  begin
    try
      lang := ReadString('Localize', 'language','hu');
    finally
      Free;
    end;
  end;
  {$ifdef fpc}
  SetDefaultLang(lang);
  {$endif}
  {$IFDEF WINDOWS}
    GetLocaleFormatSettings(GetUserDefaultLCID, DefaultFormatSettings);
    DefaultFormatSettings.DecimalSeparator := '.';
    DefaultFormatSettings.ThousandSeparator := ',';
  {$ENDIF}
  Application.MainFormOnTaskbar := True;
  {$ifndef fpc}
  TStyleManager.TrySetStyle('Silver');
  {$endif}
  Application.Title := 'Micro Coin Wallet, Miner & Explorer';
  Application.CreateForm(TFRMWallet, FRMWallet);
  Application.Run;
end.
