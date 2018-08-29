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
  {$endif }
  {$else}
  windows,
  {$ENDIF }
  Interfaces,
  {$ENDIF }
  Forms,
  UCrypto in 'src\MicroCoin\Core\UCrypto.pas',
  UTime in 'src\MicroCoin\Core\UTime.pas',
  UWalletKeys in 'src\MicroCoin\Core\UWalletKeys.pas',
  UConst in 'src\MicroCoin\Core\UConst.pas',
  UThread in 'src\MicroCoin\Core\UThread.pas',
  ULog in 'src\MicroCoin\Core\ULog.pas',
  UECIES in 'src\MicroCoin\Core\UECIES.pas',
  UAES in 'src\MicroCoin\Core\UAES.pas',
  UFRMWallet in 'src\Forms\UFRMWallet.pas' {FRMWallet},
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
  UCommon in 'src\MicroCoin\Utils\UCommon.pas',
  MicroCoin.Common.Lists in 'src\MicroCoin\Core\Common\MicroCoin.Common.Lists.pas',
  MicroCoin.Common in 'src\MicroCoin\Core\Common\MicroCoin.Common.pas',
  Vcl.PlatformVclStylesActnCtrls in 'src\Forms\Vcl.PlatformVclStylesActnCtrls.pas',
  UBlockExplorerForm in 'src\Forms\UBlockExplorerForm.pas' {BlockExplorerForm},
  MicroCoin.Components.BlockExplorer in 'src\Components\MicroCoin.Components.BlockExplorer.pas' {BlockExplorerFrame: TFrame},
  MicroCoin.Components.OperationExplorer in 'src\Components\MicroCoin.Components.OperationExplorer.pas' {OperationExplorer: TFrame},
  MicroCoin.Account.AccountKey in 'src\MicroCoin\Core\Account\MicroCoin.Account.AccountKey.pas',
  MicroCoin.Account.Data in 'src\MicroCoin\Core\Account\MicroCoin.Account.Data.pas',
  MicroCoin.Account.RPC in 'src\MicroCoin\Core\Account\MicroCoin.Account.RPC.pas',
  MicroCoin.Account.Storage in 'src\MicroCoin\Core\Account\MicroCoin.Account.Storage.pas',
  MicroCoin.Account.Transaction in 'src\MicroCoin\Core\Account\MicroCoin.Account.Transaction.pas',
  MicroCoin.RPC.Handler in 'src\MicroCoin\Core\RPC\MicroCoin.RPC.Handler.pas',
  MicroCoin.RPC.PluginManager in 'src\MicroCoin\Core\RPC\MicroCoin.RPC.PluginManager.pas',
  MicroCoin.RPC.Server in 'src\MicroCoin\Core\RPC\MicroCoin.RPC.Server.pas',
  MicroCoin.Forms.TransactionHistory in 'src\Forms\MicroCoin.Forms.TransactionHistory.pas' {TransactionHistory},
  MicroCoin.Components.PendingTransactionsExplorer in 'src\Components\MicroCoin.Components.PendingTransactionsExplorer.pas' {PendingTransactionsExplorer: TFrame},
  MicroCoin.Forms.PendignTransaction in 'src\Forms\MicroCoin.Forms.PendignTransaction.pas' {PendingTransactionsForm},
  MicroCoin.Mining.Server in 'src\MicroCoin\Core\Mining\MicroCoin.Mining.Server.pas',
  MicroCoin.Node.Events in 'src\MicroCoin\Core\Node\MicroCoin.Node.Events.pas',
  MicroCoin.Node.Node in 'src\MicroCoin\Core\Node\MicroCoin.Node.Node.pas',
  MicroCoin.BlockChain.Base in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.Base.pas',
  MicroCoin.BlockChain.Block in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.Block.pas',
  MicroCoin.BlockChain.BlockHeader in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.BlockHeader.pas',
  MicroCoin.BlockChain.BlockManager in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.BlockManager.pas',
  MicroCoin.BlockChain.Events in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.Events.pas',
  MicroCoin.BlockChain.FileStorage in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.FileStorage.pas',
  MicroCoin.BlockChain.Storage in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.Storage.pas',
  MicroCoin.Net.Client in 'src\MicroCoin\Core\Net\MicroCoin.Net.Client.pas',
  MicroCoin.Net.Connection in 'src\MicroCoin\Core\Net\MicroCoin.Net.Connection.pas',
  MicroCoin.Net.ConnectionManager in 'src\MicroCoin\Core\Net\MicroCoin.Net.ConnectionManager.pas',
  MicroCoin.Net.Discovery in 'src\MicroCoin\Core\Net\MicroCoin.Net.Discovery.pas',
  MicroCoin.Net.Events in 'src\MicroCoin\Core\Net\MicroCoin.Net.Events.pas',
  MicroCoin.Net.NodeServer in 'src\MicroCoin\Core\Net\MicroCoin.Net.NodeServer.pas',
  MicroCoin.Net.Protocol in 'src\MicroCoin\Core\Net\MicroCoin.Net.Protocol.pas',
  MicroCoin.Net.Server in 'src\MicroCoin\Core\Net\MicroCoin.Net.Server.pas',
  MicroCoin.Net.Statistics in 'src\MicroCoin\Core\Net\MicroCoin.Net.Statistics.pas',
  MicroCoin.Net.Time in 'src\MicroCoin\Core\Net\MicroCoin.Net.Time.pas',
  MicroCoin.Net.Utils in 'src\MicroCoin\Core\Net\MicroCoin.Net.Utils.pas',
  MicroCoin.RPC.Client in 'src\MicroCoin\Core\RPC\MicroCoin.RPC.Client.pas',
  MicroCoin.Mining.Client in 'src\MicroCoin\Core\Mining\MicroCoin.Mining.Client.pas',
  MicroCoin.Mining.Common in 'src\MicroCoin\Core\Mining\MicroCoin.Mining.Common.pas',
  MicroCoin.BlockChain.Protocol in 'src\MicroCoin\Core\BlockChain\MicroCoin.BlockChain.Protocol.pas',
  MicroCoin.Forms.Log in 'src\Forms\MicroCoin.Forms.Log.pas' {LogForm},
  MicroCoin.Components.Messages in 'src\Components\MicroCoin.Components.Messages.pas' {MessagesFrame: TFrame};

{.$R *.res}
{$R *.res}

var
  Storage : TIniFile;
  lang : String;
begin
  ReportMemoryLeaksOnShutdown := true;
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
  {$endif}
  TStyleManager.TrySetStyle('Silver');
  Application.Title := 'Micro Coin Wallet, Miner & Explorer';
  Application.CreateForm(TFRMWallet, FRMWallet);
  Application.CreateForm(TLogForm, LogForm);
  Application.Run;
end.
