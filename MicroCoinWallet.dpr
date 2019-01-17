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
| File:       MicroCoinWallet.dpr                                              |
| Created at: 2018-09-21                                                       |
| Purpose:    MicroCoin Wallet Project                                         |
|==============================================================================}
program MicroCoinWallet;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  windows,
  Forms,
  Classes,
  sysutils,
  Vcl.Themes,
  Vcl.Styles,
  MicroCoin.Account.AccountKey in 'src\MicroCoin\Account\MicroCoin.Account.AccountKey.pas',
  MicroCoin.Account.Data in 'src\MicroCoin\Account\MicroCoin.Account.Data.pas',
  MicroCoin.Account.Editors in 'src\MicroCoin\Account\MicroCoin.Account.Editors.pas',
  MicroCoin.Account.RPC in 'src\MicroCoin\Account\MicroCoin.Account.RPC.pas',
  MicroCoin.Account.Storage in 'src\MicroCoin\Account\MicroCoin.Account.Storage.pas',
  MicroCoin.Account.Transaction in 'src\MicroCoin\Account\MicroCoin.Account.Transaction.pas',
  MicroCoin.Application.Settings in 'src\MicroCoin\Application\MicroCoin.Application.Settings.pas',
  MicroCoin.BlockChain.Base in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.Base.pas',
  MicroCoin.BlockChain.Block in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.Block.pas',
  MicroCoin.BlockChain.BlockHeader in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.BlockHeader.pas',
  MicroCoin.BlockChain.BlockManager in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.BlockManager.pas',
  MicroCoin.BlockChain.Events in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.Events.pas',
  MicroCoin.BlockChain.FileStorage in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.FileStorage.pas',
  MicroCoin.BlockChain.Protocol in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.Protocol.pas',
  MicroCoin.BlockChain.Storage in 'src\MicroCoin\BlockChain\MicroCoin.BlockChain.Storage.pas',
  MicroCoin.Common.AppSettings in 'src\MicroCoin\Common\MicroCoin.Common.AppSettings.pas',
  MicroCoin.Common.IniFileSettings in 'src\MicroCoin\Common\MicroCoin.Common.IniFileSettings.pas',
  MicroCoin.Common.Lists in 'src\MicroCoin\Common\MicroCoin.Common.Lists.pas',
  MicroCoin.Common in 'src\MicroCoin\Common\MicroCoin.Common.pas',
  UAES in 'src\MicroCoin\Deprecated\UAES.pas',
  UBaseTypes in 'src\MicroCoin\Deprecated\UBaseTypes.pas',
  UChunk in 'src\MicroCoin\Deprecated\UChunk.pas',
  UCrypto in 'src\MicroCoin\Deprecated\UCrypto.pas',
  UECIES in 'src\MicroCoin\Deprecated\UECIES.pas',
  UJSONFunctions in 'src\MicroCoin\Deprecated\UJSONFunctions.pas',
  ULog in 'src\MicroCoin\Deprecated\ULog.pas',
  UTCPIP in 'src\MicroCoin\Deprecated\UTCPIP.pas',
  UThread in 'src\MicroCoin\Deprecated\UThread.pas',
  UTime in 'src\MicroCoin\Deprecated\UTime.pas',
  UWalletKeys in 'src\MicroCoin\Deprecated\UWalletKeys.pas',
  MicroCoin.Keys.KeyManager in 'src\MicroCoin\Keys\MicroCoin.Keys.KeyManager.pas',
  MicroCoin.Mining.Common in 'src\MicroCoin\Mining\MicroCoin.Mining.Common.pas',
  MicroCoin.Mining.Server in 'src\MicroCoin\Mining\MicroCoin.Mining.Server.pas',
  MicroCoin.Net.Client in 'src\MicroCoin\Net\MicroCoin.Net.Client.pas',
  MicroCoin.Net.Connection in 'src\MicroCoin\Net\MicroCoin.Net.Connection.pas',
  MicroCoin.Net.ConnectionBase in 'src\MicroCoin\Net\MicroCoin.Net.ConnectionBase.pas',
  MicroCoin.Net.ConnectionManager in 'src\MicroCoin\Net\MicroCoin.Net.ConnectionManager.pas',
  MicroCoin.Net.Discovery in 'src\MicroCoin\Net\MicroCoin.Net.Discovery.pas',
  MicroCoin.Net.Events in 'src\MicroCoin\Net\MicroCoin.Net.Events.pas',
  MicroCoin.Net.INetNotificationSource in 'src\MicroCoin\Net\MicroCoin.Net.INetNotificationSource.pas',
  MicroCoin.Net.NodeServer in 'src\MicroCoin\Net\MicroCoin.Net.NodeServer.pas',
  MicroCoin.Net.Protocol in 'src\MicroCoin\Net\MicroCoin.Net.Protocol.pas',
  MicroCoin.Net.Server in 'src\MicroCoin\Net\MicroCoin.Net.Server.pas',
  MicroCoin.Net.Statistics in 'src\MicroCoin\Net\MicroCoin.Net.Statistics.pas',
  MicroCoin.Net.Time in 'src\MicroCoin\Net\MicroCoin.Net.Time.pas',
  MicroCoin.Net.Utils in 'src\MicroCoin\Net\MicroCoin.Net.Utils.pas',
  MicroCoin.Node.Events in 'src\MicroCoin\Node\MicroCoin.Node.Events.pas',
  MicroCoin.Node.Node in 'src\MicroCoin\Node\MicroCoin.Node.Node.pas',
  MicroCoin.RPC.Client in 'src\MicroCoin\RPC\MicroCoin.RPC.Client.pas',
  MicroCoin.RPC.Handler in 'src\MicroCoin\Rpc\MicroCoin.RPC.Handler.pas',
  MicroCoin.RPC.MethodHandler in 'src\MicroCoin\RPC\MicroCoin.RPC.MethodHandler.pas',
  MicroCoin.RPC.Plugin in 'src\MicroCoin\RPC\MicroCoin.RPC.Plugin.pas',
  MicroCoin.RPC.PluginManager in 'src\MicroCoin\RPC\MicroCoin.RPC.PluginManager.pas',
  MicroCoin.RPC.Result in 'src\MicroCoin\RPC\MicroCoin.RPC.Result.pas',
  MicroCoin.RPC.RPCMethodAttribute in 'src\MicroCoin\RPC\MicroCoin.RPC.RPCMethodAttribute.pas',
  MicroCoin.RPC.Server in 'src\MicroCoin\RPC\MicroCoin.RPC.Server.pas',
  MicroCoin.Transaction.Base in 'src\MicroCoin\Transaction\MicroCoin.Transaction.Base.pas',
  MicroCoin.Transaction.Events in 'src\MicroCoin\Transaction\MicroCoin.Transaction.Events.pas',
  MicroCoin.Transaction.HashTree in 'src\MicroCoin\Transaction\MicroCoin.Transaction.HashTree.pas',
  MicroCoin.Transaction.ITransaction in 'src\MicroCoin\Transaction\MicroCoin.Transaction.ITransaction.pas',
  MicroCoin.Transaction.Manager in 'src\MicroCoin\Transaction\MicroCoin.Transaction.Manager.pas',
  MicroCoin.Transaction.Transaction in 'src\MicroCoin\Transaction\MicroCoin.Transaction.Transaction.pas',
  MicroCoin.Transaction.TransactionList in 'src\MicroCoin\Transaction\Lists\MicroCoin.Transaction.TransactionList.pas',
  MicroCoin.Transaction.ChangeAccountInfo in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.ChangeAccountInfo.pas',
  MicroCoin.Transaction.ChangeKey in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.ChangeKey.pas',
  MicroCoin.Transaction.CreateSubAccount in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.CreateSubAccount.pas',
  MicroCoin.Transaction.ListAccount in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.ListAccount.pas',
  MicroCoin.Transaction.RecoverFounds in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.RecoverFounds.pas',
  MicroCoin.Transaction.TransferMoney in 'src\MicroCoin\Transaction\Plugins\MicroCoin.Transaction.TransferMoney.pas',
  MicroCoin.Forms.AccountSelectDialog in 'src\Forms\Common\MicroCoin.Forms.AccountSelectDialog.pas' {AccountSelectDialog},
  MicroCoin.Forms.BlockChain.Explorer in 'src\Forms\BlockChain\MicroCoin.Forms.BlockChain.Explorer.pas' {BlockChainExplorerForm},
  MicroCoin.Forms.Common.About in 'src\Forms\Common\MicroCoin.Forms.Common.About.pas' {AboutForm},
  MicroCoin.Forms.Common.Settings in 'src\Forms\Common\MicroCoin.Forms.Common.Settings.pas' {SettingsForm},
  MicroCoin.Forms.Keys.KeyManager in 'src\Forms\Keys\MicroCoin.Forms.Keys.KeyManager.pas' {WalletKeysForm},
  MicroCoin.Forms.BuyAccount in 'src\Forms\Transactions\MicroCoin.Forms.BuyAccount.pas' {BuyAccountForm},
  MicroCoin.Forms.ChangeAccountKey in 'src\Forms\Transactions\MicroCoin.Forms.ChangeAccountKey.pas' {ChangeAccountKeyForm},
  MicroCoin.Forms.EditAccount in 'src\Forms\Transactions\MicroCoin.Forms.EditAccount.pas' {EditAccountForm},
  MicroCoin.Forms.SellAccount in 'src\Forms\Transactions\MicroCoin.Forms.SellAccount.pas' {SellAccountForm},
  MicroCoin.Forms.Transaction.Explorer in 'src\Forms\Transactions\MicroCoin.Forms.Transaction.Explorer.pas' {TransactionExplorer},
  MicroCoin.Forms.Transaction.History in 'src\Forms\Transactions\MicroCoin.Forms.Transaction.History.pas' {TransactionHistoryForm},
  MicroCoin.Forms.MainForm in 'src\Forms\MicroCoin.Forms.MainForm.pas' {MainForm},
  MicroCoin.Common.Stream in 'src\MicroCoin\Common\MicroCoin.Common.Stream.pas',
  MicroCoin.Common.Config in 'src\MicroCoin\Common\MicroCoin.Common.Config.pas',
  MicroCoin.Crypto.BigNum in 'src\MicroCoin\Crypto\MicroCoin.Crypto.BigNum.pas',
  MicroCoin.Crypto.Errors in 'src\MicroCoin\Crypto\MicroCoin.Crypto.Errors.pas',
  OpenSSL in 'src\MicroCoin\3rdParty\OpenSSL\OpenSSL.pas',
  OpenSSLdef in 'src\MicroCoin\3rdParty\OpenSSL\OpenSSLdef.pas',
  MicroCoin.Crypto.Keys in 'src\MicroCoin\Crypto\MicroCoin.Crypto.Keys.pas';

resourcestring
  StrMicroCoinWallet = 'MicroCoin Wallet';

{$R *.res}

function SetResourceHInstance(NewInstance: Longint): LongInt;
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  Result := 0;
  while CurModule <> nil do
  begin
    if CurModule.Instance = HInstance then
    begin
      if CurModule.ResInstance <> CurModule.Instance then
        FreeLibrary(CurModule.ResInstance);
      CurModule.ResInstance := NewInstance;
      Result := NewInstance;
      Exit;
    end;
    CurModule := CurModule.Next;
  end;
end;


function LoadNewResourceModule(Locale: LCID): LongInt;
var
  FileName: array [0..260] of char;
  P: PChar;
  LocaleName: array[0..4] of Char;
  NewInst: LongInt;

begin
  GetModuleFileName(HInstance, FileName, SizeOf(FileName));
  GetLocaleInfo(Locale, LOCALE_SABBREVLANGNAME, LocaleName, SizeOf(LocaleName));
  P := PChar(@FileName) + lstrlen(FileName);
  while (P^ <> '.') and (P <> @FileName) do Dec(P);
  NewInst := 0;
  Result := 0;
  if P <> @FileName then
  begin
    Inc(P);
    if LocaleName[0] <> #0 then
    begin
      lstrcpy(P, LocaleName);
      NewInst := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      if NewInst = 0 then
      begin
        LocaleName[2] := #0;
        lstrcpy(P, LocaleName);
        NewInst := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      end;
    end;
  end;
  if NewInst <> 0 then
    Result := SetResourceHInstance(NewInst)
end;

const
  HUN = LANG_HUNGARIAN;

var
  wLang: LangID;
begin
  wLang := GetSystemDefaultLCID;
  if wlang = 1038 // Hungarian
  then LoadNewResourceModule(HUN);
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
  Application.Initialize;
  {$IFDEF WINDOWS}
    GetLocaleFormatSettings(GetUserDefaultLCID, DefaultFormatSettings);
    DefaultFormatSettings.DecimalSeparator := '.';
    DefaultFormatSettings.ThousandSeparator := ',';
  {$ENDIF}

  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.Title := StrMicroCoinWallet + ' - '+ClientAppVersion{$IFDEF TESTNET}+' - TESTNET'{$ENDIF}{$IFDEF DEVNET}+' - DEVNET'{$ENDIF};
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
