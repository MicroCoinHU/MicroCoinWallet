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
| This unit contains portions from PascalCoin                                  |
| Copyright (c) Albert Molina 2016 - 2018                                      |
|                                                                              |
| Distributed under the MIT software license, see the accompanying file        |
| LICENSE or visit http://www.opensource.org/licenses/mit-license.php.         |
|==============================================================================|
| File:       MicroCoin.Forms.MainForm.pas                                     |
| Created at: 2018-09-11                                                       |
| Purpose:    Wallet Main form                                                 |
|==============================================================================}

unit MicroCoin.Forms.MainForm;

{$IFDEF FPC}
  {$MODE delphi}
{$ENDIF}


interface

{$I config.inc}

uses
{$IFNDEF FPC}
  pngimage, Windows, AppEvnts, ShlObj,
{$ELSE}
  LCLIntf, LCLType, LMessages, fpjson, jsonparser, LResources, LCLTranslator, Translations,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, UWalletKeys, StdCtrls, ULog, Grids, UAppParams,
  Menus, ImgList, Styles, Themes,
  synautil, UCrypto, Buttons, IniFiles,  MicroCoin.Keys.KeyManager,
  System.Notification, PngImageList, Actions, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ImageList,
  VirtualTrees, PngBitBtn, PngSpeedButton, Vcl.ActnCtrls,
  MicroCoin.Transaction.Base, MicroCoin.Transaction.TransferMoney, MicroCoin.Transaction.ChangeKey,
  MicroCoin.Forms.EditAccount,
  MicroCoin.Account.AccountKey, MicroCoin.Common.Lists, MicroCoin.Common,
  MicroCoin.Transaction.ITransaction,
  MicroCoin.Account.Data, Types, httpsend,
  MicroCoin.Node.Node, MicroCoin.Forms.BlockChain.Explorer,
  MicroCoin.Account.Storage, PlatformVclStylesActnCtrls,
  MicroCoin.RPC.Server, UAES,
  MicroCoin.Mining.Server,  MicroCoin.Forms.ChangeAccountKey, MicroCoin.Node.Events,
  MicroCoin.Forms.Transaction.Explorer, MicroCoin.Forms.Common.Settings,
  MicroCoin.Net.Connection, MicroCoin.Net.Client, MicroCoin.Net.Statistics,
  MicroCoin.Forms.BuyAccount, MicroCoin.Transaction.ListAccount,
  MicroCoin.Forms.Transaction.History, MicroCoin.Forms.Keys.Keymanager, UITypes,
  SyncObjs,
  Tabs, ExtActns, MicroCoin.Forms.SellAccount, MicroCoin.Account.Editors,
  ToolWin, WinXCtrls
 {$IFDEF WINDOWS}, Windows{$ENDIF};

const
  CM_PC_WalletKeysChanged = WM_USER + 1;
  CM_PC_NetConnectionUpdated = WM_USER + 2;

type
  TMinerPrivateKey = (mpk_NewEachTime, mpk_Random, mpk_Selected);

  { TFRMWallet }

  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    Timer1: TTimer;
    TrayIcon: TTrayIcon;
    TimerUpdateStatus: TTimer;
    MainToolbar: TActionToolBar;
    MainActions: TActionManager;
    PrivateKeysAction: TAction;
    SettingsAction: TAction;
    NodesAction: TAction;
    BlockExplorerAction: TAction;
    TransactionsAction: TAction;
    PendingTransactionsAction: TAction;
    AboutAction: TAction;
    logPanel: TPanel;
    bottomPageControl: TPageControl;
    logSheet: TTabSheet;
    logDisplay: TRichEdit;
    activeConnectionsSheet: TTabSheet;
    blackListedIPsSheet: TTabSheet;
    serversSheet: TTabSheet;
    memoNetConnections: TMemo;
    memoNetBlackLists: TMemo;
    memoNetServers: TMemo;
    MainPanel: TPanel;
    miscInfoSheet: TTabSheet;
    labelBlocksCountCaption: TLabel;
    labelAllAccountsCaption: TLabel;
    lblCurrentAccounts: TLabel;
    labelDifficultyCaption: TLabel;
    labelLastBlockCaption: TLabel;
    lblCurrentBlockTime: TLabel;
    lblCurrentDifficulty: TLabel;
    lblTimeAverage: TLabel;
    lblTimeAverageAux: TLabel;
    lblCurrentBlock: TLabel;
    rootPanel: TPanel;
    Splitter1: TSplitter;
    AccountListActions: TActionManager;
    SelectAllAction: TAction;
    AccountInfoAction: TAction;
    ContentPanel: TPanel;
    leftPanel: TPanel;
    rightPanel: TPanel;
    SellAccountAction: TAction;
    EditAccountAction: TAction;
    BuyAction: TAction;
    ChangeKeyAction: TAction;
    accountVList: TVirtualStringTree;
    accountsFilterPanel: TPanel;
    cbExploreMyAccounts: TCheckBox;
    cbMyPrivateKeys: TComboBox;
    AccountsListToolbar: TActionToolBar;
    RefreshAction: TAction;
    MainActionImages: TPngImageList;
    miscIcons: TPngImageList;
    AccountListActionImages: TPngImageList;
    NotificationCenter: TNotificationCenter;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    payloadEdit: TMemo;
    btnSendCoins: TPngBitBtn;
    Image1: TImage;
    accountsPanelHeader: THeaderControl;
    Panel5: TPanel;
    HeaderControl3: THeaderControl;
    labelAccountsCaption: TLabel;
    labelAccountsCount: TLabel;
    labelBalanceCaption: TLabel;
    labelAccountsBalance: TLabel;
    labelPendingCaption: TLabel;
    labelOperationsPending: TLabel;
    labelBlocksFoundCaption: TLabel;
    labelBlocksFound: TLabel;
    labelMiningStatusCaption: TLabel;
    labelMinersClients: TLabel;
    lblNodeStatus: TLabel;
    labelNodeStatusCaption: TLabel;
    encryptModeSelect: TComboBox;
    Label7: TLabel;
    amountEdit: TEdit;
    feeEdit: TEdit;
    encryptionPassword: TEdit;
    Label9: TLabel;
    HeaderControl1: THeaderControl;
    ApplicationEvents: TApplicationEvents;
    RevokeSellAction: TAction;
    targetAccountEdit: TAccountEditor;
    MiscActions: TActionManager;
    MiscImages: TPngImageList;
    ShowLogAction: TAction;
    Send: TAction;
    ChangeThemeAction: TAction;
    TransactionHistoryAction: TAction;
    accountListImages: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerUpdateStatusTimer(Sender: TObject);
    procedure cbMyPrivateKeysChange(Sender: TObject);
    procedure cbExploreMyAccountsClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure bbAccountsRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TransactionsActionExecute(Sender: TObject);
    procedure PendingTransactionsActionExecute(Sender: TObject);
    procedure ShowLogActionExecute(Sender: TObject);
    procedure SelectAllActionExecute(Sender: TObject);
    procedure accountVListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure accountVListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure accountVListGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure MultipleTransactionActionExecute(Sender: TObject);
    procedure accountVListNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure SellAccountActionExecute(Sender: TObject);
    procedure ChangeKeyActionExecute(Sender: TObject);
    procedure BuyActionExecute(Sender: TObject);
    procedure EditAccountActionExecute(Sender: TObject);
    procedure SendExecute(Sender: TObject);
    procedure RefreshActionExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure SendUpdate(Sender: TObject);
    procedure accountVListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure CloseActionExecute(Sender: TObject);
    procedure EditAccountActionUpdate(Sender: TObject);
    procedure ChangeKeyActionUpdate(Sender: TObject);
    procedure SellAccountActionUpdate(Sender: TObject);
    procedure SelectAllActionUpdate(Sender: TObject);
    procedure AccountInfoActionUpdate(Sender: TObject);
    procedure BuyActionUpdate(Sender: TObject);
    procedure RevokeSellActionUpdate(Sender: TObject);
    procedure RevokeSellActionExecute(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TransactionHistoryActionUpdate(Sender: TObject);
    procedure TransactionHistoryActionExecute(Sender: TObject);
    procedure PrivateKeysActionExecute(Sender: TObject);
    procedure SettingsActionExecute(Sender: TObject);
    procedure BlockExplorerActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure encryptModeSelectChange(Sender: TObject);
    procedure accountVListFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    FBackgroundPanel: TPanel;
    FMinersBlocksFound: Integer;
    bShowLogs : TPngSpeedButton;
    procedure SetMinersBlocksFound(const Value: Integer);
    procedure FinishedLoadingApp;
  protected
    { Private declarations }
    FIsActivated: Boolean;
    FLog: TLog;
    FAppParams: TAppParams;
    FNodeNotifyEvents: TNodeNotifyEvents;
    FOrderedAccountsKeyList: TOrderedAccountKeysList;
    FMinerPrivateKeyType: TMinerPrivateKey;
    FUpdating: Boolean;
    FMessagesUnreadCount: Integer;
    FMinAccountBalance: Int64;
    FMaxAccountBalance: Int64;
    FPoolMiningServer: TMiningServer;
    FRPCServer: TRPCServer;
    FMustProcessWalletChanged: Boolean;
    FMustProcessNetConnectionUpdated: Boolean;
    FAccounts: TOrderedList;
    FTotalAmount : Int64;
    procedure OnNewAccount(Sender: TObject);
    procedure OnNewOperation(Sender: TObject);
    procedure OnReceivedHelloMessage(Sender: TObject);
    procedure OnNetStatisticsChanged(Sender: TObject);
    procedure OnNewLog(logtype: TLogType; Time: TDateTime; ThreadID: Cardinal; const Sender, logtext: AnsiString);
    procedure OnWalletChanged(Sender: TObject);
    procedure OnNetConnectionsUpdated(Sender: TObject);
    procedure OnNetNodeServersUpdated(Sender: TObject);
    procedure OnNetBlackListUpdated(Sender: TObject);
    procedure OnNodeMessageEvent(NetConnection: TNetConnection; MessageData: TRawBytes);
    procedure OnSelectedAccountsGridUpdated(Sender: TObject);
    procedure OnMiningServerNewBlockFound(Sender: TObject);
    procedure UpdateConnectionStatus;
    procedure UpdateAccounts(RefreshData: Boolean);
    procedure UpdateBlockChainState;
    procedure UpdatePrivateKeys;
    procedure LoadAppParams;
    procedure SaveAppParams;
    procedure UpdateConfigChanged;
    procedure UpdateNodeStatus;
    procedure Activate; override;
    function ForceMining: Boolean; virtual;
    function GetAccountKeyForMiner: TAccountKey;
    procedure DoUpdateAccounts;
    procedure CM_WalletChanged(var Msg: TMessage); message CM_PC_WalletKeysChanged;
    procedure CM_NetConnectionUpdated(var Msg: TMessage); message CM_PC_NetConnectionUpdated;
    procedure ConfirmRestart;
  public
    class constructor Create;
    property MinersBlocksFound: Integer read FMinersBlocksFound write SetMinersBlocksFound;
  end;

var
  MainForm: TMainForm;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses UFolderHelper, OpenSSL, OpenSSLdef, UConst, UTime, MicroCoin.BlockChain.FileStorage,
  UThread, UECIES,
  MicroCoin.Forms.Common.About,
  MicroCoin.Net.NodeServer, MicroCoin.Net.ConnectionManager;

type
  TThreadActivate = class(TPCThread)
  protected
    procedure BCExecute; override;
  end;

resourcestring
  rsConnectedJSO = '%s connected JSON-RPC clients';
  rsNoJSONRPCCli = 'No JSON-RPC clients';
  rsJSONRPCServe = 'JSON-RPC server not active';
  rsDiscoveringS = 'Discovering servers';
  rsObtainingNew = 'Obtaining new blockchain';
  rsRunning = 'Running';
  rsAloneInTheWo = 'Alone in the world...';
  rsPleaseWaitUn = 'Please wait until finished: %s';
  rsAllMyPrivate = '(All my private keys)';
  rsNone = '(none)';
  rsLastDSSecDSS = 'Last %d: %s sec. - %d: %s sec. - %d: %s sec. - %d: %s sec.' + ' - %d: %s sec.';
  rsLast00SecOpt = 'Last %s: %s sec. (Optimal %ss) Deviation %s';
  rsConnectionsD = 'Connections: %d Clients: %d Servers: %d - Rcvd: %d Kb Send: %d Kb';
  rsActivePort = 'Active (Port %s)';
  rsServerStoppe = 'Server stopped';
  rsNodeServersU = 'NodeServers Updated: %s Count: %s';
  rsServerIPSD = 'Server IP:%s:%d';
  rsTRYINGTOCONN = '%s ** TRYING TO CONNECT **';
  rsACTIVE = '%s ** ACTIVE **';
  rsNOTVALID = '%s ** NOT VALID ** %s';
  rsLastConnecti = '%s Last connection: %s';
  rsLastServerCo = '%s Last server connection: %s';
  rsLastAttemptT = '%s Last attempt to connect: %s';
  rsAttempts = '%s (Attempts: %s)';
  rsTotalBlackli = 'Total Blacklisted IPs: %d (Total %d)';
  rsOperationInf = 'Operation info:';
  rsOperationInf2 = 'Operation info';
  rsSelectAnAcco = 'Select an account';
  rsAccountInfo = 'Account %s info';
  rsNewNodeBuild = 'New Node %s - %s Build:%s';
  rsNoInfoAvaila = 'No info available';
  rsNotFoundAnyA = 'Not found any account higher than %s with balance higher ' + 'than %s';
  rsSearchOperat = 'Search operation by OpHash';
  rsInsertOperat = 'Insert Operation Hash value (OpHash)';
  rsNotFoundAnyA2 = 'Not found any account lower than %s with balance higher ' + 'than %s';
  rsNoRowSelecte = 'No row selected';
  rsBlackListUpd = 'BlackList Updated: %s by TID:%s';
  rsBlacklistIPS = 'Blacklist IP:%s:%d LastConnection:%s Reason: %s';
  rsDdMmYyyyHhNn2 = 'dd/mm/yyyy hh:nn:ss';
  rsMessageRecei = '%s Message received from %s';
  rsMessageRecei2 = '%s Message received from %s Length %s bytes';
  rsRECEIVED = 'RECEIVED> %s';
  rsMessageFromL = '%s Message from %s%sLength %s bytes%s%s';
  rsValueInHexad = '%sValue in hexadecimal:%s%s';
  rsInternalMess = '%s Internal message: %s';
  rsYouHaveRecei = 'You have received %d messages';
  rsYouHaveRecei2 = 'You have received 1 message';
  rsNoAccountSel = 'No account selected';
  rsYouCannotAdd = 'You cannot add %s account because private key not found in' +
    ' your wallet.%s%sYou''re not the owner!';
  rsExceptionAtT = 'Exception at TimerUpdate %s: %s';
  rsClientIPS = 'Client: IP:%s';
  rsServerIPS = 'Server: IP:%s';
  rsCannotLoadTo = 'Cannot load %s%sTo use this software make sure this file ' +
    'is available on you system or reinstall the application';
  rsCannotOpenYo = 'Cannot open your wallet... Perhaps another instance of ' + 'Micro Coin is active!%s%s%s';
  rsAnErrorOccur = 'An error occurred during initialization. Application ' +
    'cannot continue:%s%s%s%s%sApplication will close...';
  rsChangeKeyNam = 'Change Key name';
  rsInputNewName = 'Input new name';
  rsMustSelectAK = 'Must select a Key';
  rsMustSelectAt = 'Must select at least 1 account';
  rsSendThisMess = 'Send this message to %s nodes?%sNOTE: Sending unauthorized' +
    ' messages will be considered spam and you will be banned%s%sMessage: %s%s';
  rsSelectAtLeas = 'Select at least one connection';
  rsSentTo = '%s Sent to %s > %s';
  rsYouCannotDoT = 'You cannot do this operation now:%s%s%s';
  rsLastComunica = ' - Last comunication <10 sec.';
  rsLastComunica2 = ' - Last comunication %.2dm%.2ds';
  rsClientIPSBlo = 'Client: IP:%s Block:%d Sent/Received:%d/%d Bytes - %s - ' + 'Time offset %d - Active since %s %s';
  rsMySelfIPSSen = 'MySelf IP:%s Sent/Received:%d/%d Bytes - %s - Time offset ' + '%d - Active since %s %s';
  rsRestartAppli = 'Restart application?';
  rsYouNeedResta = 'You need restart Application to apply changes. Close ' + 'application?';

  { TThreadActivate }

procedure TThreadActivate.BCExecute;
begin
  // Read Operations saved from disk
  TNode.Node.BlockManager.DiskRestoreFromOperations(CT_MaxBlock);
  TNode.Node.AutoDiscoverNodes(CT_Discover_IPs);
  TNode.Node.NetServer.Active := true;
  Synchronize(MainForm.DoUpdateAccounts);
  Synchronize(MainForm.FinishedLoadingApp);
end;

{ TFRMWallet }

procedure TMainForm.PrivateKeysActionExecute(Sender: TObject);
begin
  TWalletKeysForm.Create(nil).ShowModal;
end;

procedure TMainForm.RefreshActionExecute(Sender: TObject);
begin
  UpdateAccounts(true);
end;

procedure TMainForm.RevokeSellActionExecute(Sender: TObject);
var
  xTransaction: ITransaction;
  xAccount: TAccount;
  xPrivateKey: TECPrivateKey;
  xErrors: AnsiString;
  xIndex: integer;
begin
  if accountVList.FocusedNode = nil
  then exit;

  xAccount := TAccount(accountVList.FocusedNode.GetData()^);
  xIndex := TNode.Node.KeyManager.IndexOfAccountKey(xAccount.AccountInfo.AccountKey);

  if xIndex<0 then exit;
  if MessageDlg('Really want to revoke sell?',mtConfirmation,[mbYes, mbNo],0) <> mrYes
  then exit;

  xPrivateKey := TNode.Node.KeyManager[xIndex].PrivateKey;
  xTransaction:=TOpDelistAccountForSale.CreateDelistAccountForSale(
    xAccount.AccountNumber,
    xAccount.n_operation+1,
    xAccount.AccountNumber,
    0,
    xPrivateKey,
    ''
  );
  if not TNode.Node.AddOperation(nil, xTransaction, xErrors) then begin
     MessageDlg(xErrors, mtError, [mbOk],0);
  end else begin
     MessageDlg('Transaction executed sucessfully', mtInformation, [mbOk], 0);
  end;
end;

procedure TMainForm.RevokeSellActionUpdate(Sender: TObject);
var
  xAccount : TAccount;
  xIndex : integer;
  xIsReady: AnsiString;
begin
  if accountVList.FocusedNode <> nil then begin
    xAccount := TAccount(accountVList.FocusedNode.GetData()^);
    xIndex := TNode.Node.KeyManager.IndexOfAccountKey(xAccount.AccountInfo.AccountKey);
    RevokeSellAction.Enabled := TNode.Node.IsReady(xIsReady) and
     (TNode.Node.KeyManager.IndexOfAccountKey(
    xAccount.AccountInfo.AccountKey) > -1)
    and (xIndex >= 0)
    and (xAccount.AccountInfo.state = as_ForSale);
  end
  else RevokeSellAction.Enabled := false;
end;

procedure TMainForm.AboutActionExecute(Sender: TObject);
begin
  with TAboutForm.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainForm.AccountInfoActionUpdate(Sender: TObject);
begin
  AccountInfoAction.Enabled := accountVList.FocusedNode <> nil;
end;

procedure TMainForm.accountVListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  xPCheckedNode : PVirtualNode;
  xAllAmount: Int64;
begin
  xAllAmount := 0;
  for xPCheckedNode in accountVList.CheckedNodes(TCheckState.csCheckedNormal) do begin
    xAllAmount := xAllAmount + TAccount(xPCheckedNode.GetData()^).balance;
  end;
  if xAllAmount>0 then begin
    amountEdit.Text := TCurrencyUtils.CurrencyToString(xAllAmount);
    amountEdit.ReadOnly := True;
  end else begin
    amountEdit.Clear;
    amountEdit.ReadOnly := false;
  end;
end;

procedure TMainForm.accountVListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  xAccount: TAccount;
begin
  TAccount(Node.GetData()^).AccountInfo.AccountKey.x := '';
  TAccount(Node.GetData()^).AccountInfo.AccountKey.y := '';
  TAccount(Node.GetData()^).AccountInfo.new_publicKey.x := '';
  TAccount(Node.GetData()^).AccountInfo.new_publicKey.y := '';
  TAccount(Node.GetData()^) := Default(TAccount);
end;

procedure TMainForm.accountVListGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  xBlockDifference: Cardinal;
  xAccount: TAccount;
begin
  xAccount := TAccount(Sender.GetNodeData(Node)^);
  xBlockDifference := TNode.Node.BlockManager.BlocksCount - xAccount.updated_block;
 if (Kind in [ikNormal, ikSelected]) and (Column = 0) then begin
   case xAccount.AccountInfo.state of
    as_Unknown: ImageIndex := 2;
    as_Normal:
      if TAccount.IsAccountBlockedByProtocol(xAccount.AccountNumber, TNode.Node.BlockManager.BlocksCount)
      then ImageIndex := 2
      else if xBlockDifference < 10 then ImageIndex := 1
      else ImageIndex := 0;
    as_ForSale: ImageIndex := 3
   end;
 end else Ghosted := true;
end;

procedure TMainForm.accountVListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  xPAccount : TAccount;
begin
  if Sender.GetNodeLevel(Node) = 0 then begin
    xPAccount := TAccount(Sender.GetNodeData(Node)^);
    case Column of
      0: CellText := TAccount.AccountNumberToAccountTxtNumber(xPAccount.AccountNumber);
      1: CellText := xPAccount.name;
      2: begin
           CellText := TCurrencyUtils.CurrencyToString(xPAccount.balance);
           if xPAccount.AccountInfo.state = as_ForSale then
           CellText := CellText + ' ('+TCurrencyUtils.CurrencyToString(xPAccount.AccountInfo.price)+')';
        end;
      3: CellText := xPAccount.n_operation.ToString;
    end;
  end;
end;

procedure TMainForm.accountVListInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  xAccountNumber : Cardinal;
  xAccount: TAccount;
begin

  if cbExploreMyAccounts.Checked
  then xAccountNumber := FAccounts.Get(Node.Index)
  else xAccountNumber := Node.Index;

  Node.CheckType := TCheckType.ctCheckBox;

  xAccount := TNode.Node.Operations.AccountTransaction.Account(xAccountNumber);
  Sender.SetNodeData(Node, xAccount);
end;

procedure TMainForm.accountVListNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
begin
  TransactionHistoryAction.Execute;
end;

procedure TMainForm.Activate;
var
  xIPAddresses: AnsiString;
  xNodeServers: TNodeServerAddressArray;
begin
  inherited;
  if FIsActivated then
    exit;
  FIsActivated := true;
  try
    try
      TNode.Node.KeyManager.WalletFileName := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'WalletKeys.dat';
    except
      on E: Exception do
      begin
        E.Message := Format(rsCannotOpenYo, [#10, #10, E.Message]);
        raise;
      end;
    end;
    xIPAddresses := FAppParams.ParamByName[CT_PARAM_TryToConnectOnlyWithThisFixedServers].GetAsString('');
    TNode.DecodeIpStringToNodeServerAddressArray(xIPAddresses, xNodeServers);
    TConnectionManager.Instance.DiscoverFixedServersOnly(xNodeServers);
    setlength(xNodeServers, 0);
    // Creating Node:
    TNode.Node.NetServer.Port := FAppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
    TNode.Node.PeerCache := FAppParams.ParamByName[CT_PARAM_PeerCache].GetAsString('') + ';' + CT_Discover_IPs;
    // Create RPC server
    FRPCServer := TRPCServer.Instance;
    FRPCServer.WalletKeys := TNode.Node.KeyManager;
    FRPCServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1');
    //    TNode.Node.KeyManager := TNode.Node.KeyManager;
    // Check Database
    TNode.Node.BlockManager.StorageClass := TFileStorage;
    TFileStorage(TNode.Node.BlockManager.Storage).DatabaseFolder := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'Data';
    TFileStorage(TNode.Node.BlockManager.Storage).Initialize;
    // Init Grid
    TNode.Node.KeyManager.OnChanged := OnWalletChanged;
    // Reading database
    TThreadActivate.Create(false).FreeOnTerminate := true;
    FNodeNotifyEvents.Node := TNode.Node;
    // Init
    TConnectionManager.Instance.OnReceivedHelloMessage := OnReceivedHelloMessage;
    TConnectionManager.Instance.OnStatisticsChanged := OnNetStatisticsChanged;
    TConnectionManager.Instance.OnNetConnectionsUpdated := OnNetConnectionsUpdated;
    TConnectionManager.Instance.OnNodeServersUpdated := OnNetNodeServersUpdated;
    TConnectionManager.Instance.OnBlackListUpdated := OnNetBlackListUpdated;
    //
    TimerUpdateStatus.Interval := 1000;
    TimerUpdateStatus.Enabled := true;
    UpdateConfigChanged;
  except
    on E: Exception do
    begin
      E.Message := Format(rsAnErrorOccur, [#10, #10, E.Message, #10, #10]);
      Application.MessageBox(PChar(E.Message), PChar(Application.Title), MB_ICONERROR + MB_OK);
      Halt;
    end;
  end;
  UpdatePrivateKeys;
  UpdateAccounts(false);
  if FAppParams.ParamByName[CT_PARAM_FirstTime].GetAsBoolean(true) then
  begin
    FAppParams.ParamByName[CT_PARAM_FirstTime].SetAsBoolean(false);
    AboutAction.Execute;
  end;
end;

procedure TMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  MessageDlg(E.Message, TMsgDlgType.mtError, [mbOK], 0);
end;

procedure TMainForm.ApplicationEvents1Minimize(Sender: TObject);
begin
{$IFNDEF FPC}
  Hide();
  WindowState := wsMinimized;
  TimerUpdateStatus.Enabled := false;
  TrayIcon.Visible := true;
  TrayIcon.ShowBalloonHint;
{$ENDIF}
end;

procedure TMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
{$IFNDEF FPC}
  Hide();
  WindowState := wsMinimized;
  TimerUpdateStatus.Enabled := false;
  { Show the animated tray icon and also a hint balloon. }
  TrayIcon.Visible := true;
  TrayIcon.ShowBalloonHint;
{$ENDIF}
end;

procedure TMainForm.bbAccountsRefreshClick(Sender: TObject);
begin
  UpdateAccounts(true);
end;

procedure TMainForm.BlockExplorerActionExecute(Sender: TObject);
begin
 TBlockChainExplorerForm.Create(nil).Show;
end;

procedure TMainForm.BuyActionExecute(Sender: TObject);
begin
  with TBuyAccountForm.Create(self) do begin
    Account := TAccount(Self.accountVList.FocusedNode.GetData()^);
    ShowModal;
    Free;
  end;
end;

procedure TMainForm.BuyActionUpdate(Sender: TObject);
var
  xIsReady: AnsiString;
begin
 if accountVList.FocusedNode <> nil then
    BuyAction.Enabled := (TNode.Node.KeyManager.IndexOfAccountKey(
    TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.AccountKey) < 0)
    and TNode.Node.IsReady(xIsReady)
    and (TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.state = as_ForSale)
 else BuyAction.Enabled := false;

end;

procedure TMainForm.cbExploreMyAccountsClick(Sender: TObject);
begin
  cbMyPrivateKeys.Enabled := cbExploreMyAccounts.Checked;
  UpdateAccounts(true);
end;

procedure TMainForm.cbMyPrivateKeysChange(Sender: TObject);
begin
  UpdateAccounts(true);
end;


procedure TMainForm.CloseActionExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.CM_NetConnectionUpdated(var Msg: TMessage);
const
  cBooleanToString: array [Boolean] of string = ('False', 'True');
var
  i: Integer;
  xNetConnection: TNetConnection;
  l: TList;
  xClientApp, xLastConnTime: string;
  xStrings, xNSC, xRS, xDisc: TStrings;
  hh, nn, ss, ms: Word;
begin
  try
    if not TConnectionManager.Instance.NetConnections.TryLockList(100, l) then
      exit;
    try
      xStrings := memoNetConnections.Lines;
      xNSC := TStringList.Create;
      xRS := TStringList.Create;
      xDisc := TStringList.Create;
      xStrings.BeginUpdate;
      try
        for i := 0 to l.Count - 1 do
        begin
          xNetConnection := l[i];
          if xNetConnection.Client.BytesReceived > 0 then
          begin
            xClientApp := '[' + IntToStr(xNetConnection.NetProtocolVersion.protocol_version) + '-' +
              IntToStr(xNetConnection.NetProtocolVersion.protocol_available) + '] ' + xNetConnection.ClientAppVersion;
          end
          else
          begin
            xClientApp := '(no data)';
          end;

          if xNetConnection.Connected then
          begin
            if xNetConnection.Client.LastCommunicationTime > 1000 then
            begin
              DecodeTime(now - xNetConnection.Client.LastCommunicationTime, hh, nn, ss, ms);
              if (hh = 0) and (nn = 0) and (ss < 10) then
              begin
                xLastConnTime := rsLastComunica;
              end
              else
              begin
                xLastConnTime := Format(rsLastComunica2, [(hh * 60) + nn, ss]);
              end;
            end
            else
            begin
              xLastConnTime := '';
            end;
            if xNetConnection is TNetServerClient then
            begin
              xNSC.Add(Format(rsClientIPSBlo, [xNetConnection.ClientRemoteAddr, xNetConnection.RemoteOperationBlock.block, xNetConnection.Client.BytesSent,
                xNetConnection.Client.BytesReceived, xClientApp, xNetConnection.TimestampDiff, DateTimeElapsedTime(xNetConnection.CreatedTime),
                xLastConnTime]));
            end
            else
            begin
              if xNetConnection.IsMyselfServer then
                xNSC.Add(Format(rsMySelfIPSSen, [xNetConnection.ClientRemoteAddr, xNetConnection.Client.BytesSent, xNetConnection.Client.BytesReceived,
                  xClientApp, xNetConnection.TimestampDiff, DateTimeElapsedTime(xNetConnection.CreatedTime), xLastConnTime]))
              else
              begin
                xRS.Add(Format
                  ('Remote Server: IP:%s Block:%d Sent/Received:%d/%d Bytes - %s - Time offset %d - Active since %s %s',
                  [xNetConnection.ClientRemoteAddr, xNetConnection.RemoteOperationBlock.block, xNetConnection.Client.BytesSent, xNetConnection.Client.BytesReceived,
                  xClientApp, xNetConnection.TimestampDiff, DateTimeElapsedTime(xNetConnection.CreatedTime), xLastConnTime]));
              end;
            end;
          end
          else
          begin
            if xNetConnection is TNetServerClient then
            begin
              xDisc.Add(Format('Disconnected client: IP:%s - %s', [xNetConnection.ClientRemoteAddr, xClientApp]));
            end
            else if xNetConnection.IsMyselfServer then
            begin
              xDisc.Add(Format('Disconnected MySelf IP:%s - %s', [xNetConnection.ClientRemoteAddr, xClientApp]));
            end
            else
            begin
              xDisc.Add(Format('Disconnected Remote Server: IP:%s %s - %s',
                [xNetConnection.ClientRemoteAddr, cBooleanToString[xNetConnection.Connected], xClientApp]));
            end;
          end;
        end;
        xStrings.Clear;
        xStrings.Add(Format('Connections Updated %s Clients:%d Servers:%d (valid servers:%d)',
          [DateTimeToStr(now), xNSC.Count, xRS.Count,
          TConnectionManager.Instance.NetStatistics.ServersConnectionsWithResponse]));
        xStrings.AddStrings(xRS);
        xStrings.AddStrings(xNSC);
        if xDisc.Count > 0 then
        begin
          xStrings.Add('');
          xStrings.Add('Disconnected connections: ' + IntToStr(xDisc.Count));
          xStrings.AddStrings(xDisc);
        end;
      finally
        xStrings.EndUpdate;
        xNSC.Free;
        xRS.Free;
        xDisc.Free;
      end;
      // CheckMining;
    finally
      TConnectionManager.Instance.NetConnections.UnlockList;
    end;
  finally
    FMustProcessNetConnectionUpdated := false;
  end;
end;

procedure TMainForm.ConfirmRestart;
begin
  if MessageDlg(rsRestartAppli, {$IFDEF fpc} rsYouNeedResta, {$ENDIF} mtConfirmation, [mbYes, mbNo],{$IFDEF fpc}''{$ELSE}0{$ENDIF}) = mrYes then
    Application.Terminate;
end;

class constructor TMainForm.Create;
begin
end;

procedure TMainForm.CM_WalletChanged(var Msg: TMessage);
begin
  UpdatePrivateKeys;
  FMustProcessWalletChanged := false;
end;

procedure TMainForm.DoUpdateAccounts;
begin
  UpdateAccounts(true);
end;

procedure TMainForm.EditAccountActionExecute(Sender: TObject);
begin
  if accountVList.FocusedNode = nil then exit;
  with TEditAccountForm.Create(self) do begin
    AccountNumber := TAccount(accountVList.FocusedNode.GetData()^).AccountNumber;
    ShowModal;
    Free;
  end;
end;

procedure TMainForm.EditAccountActionUpdate(Sender: TObject);
var
  xIsReady : AnsiString;
begin
  if accountVList.FocusedNode<>nil then
  EditAccountAction.Enabled :=
    TNode.Node.IsReady(xIsReady) and
    (TNode.Node.KeyManager.IndexOfAccountKey(
    TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.AccountKey) > -1)
  else EditAccountAction.Enabled := false;

end;

procedure TMainForm.encryptModeSelectChange(Sender: TObject);
begin
  encryptionPassword.Enabled := encryptModeSelect.ItemIndex = 3;
  if encryptionPassword.Enabled then encryptionPassword.SetFocus
  else encryptionPassword.Text := '';
end;

procedure TMainForm.FinishedLoadingApp;
var
  i : integer;
begin
  FPoolMiningServer := TMiningServer.Create;
  FPoolMiningServer.Port := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort]
    .GetAsInteger(CT_JSONRPCMinerServer_Port);
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.MinerPayload := FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
  TNode.Node.Operations.AccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].GetAsBoolean(true);
  FPoolMiningServer.OnMiningServerNewBlockFound := OnMiningServerNewBlockFound;
  for i:=0 to MainActions.ActionCount-1 do
    MainActions[i].Enabled := true;
  if Assigned(FBackgroundPanel) then
  begin
    FreeAndNil(FBackgroundPanel);
  end;
end;

function TMainForm.ForceMining: Boolean;
begin
  Result := false;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerUpdateStatus.Enabled := false;
  Timer1.Enabled := false
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Caption := Application.Title;
  if not LoadSSLCrypt then begin
    MessageDlg(Format(rsCannotLoadTo, [SSL_C_LIB, #10]), mtError, [mbOk], 0);
    Free;
    Exit;
  end;
  TCrypto.InitCrypto;
  TimerUpdateStatus.Enabled := true;
  logPanel.Height := 250;
  feeEdit.Text := TCurrencyUtils.CurrencyToString(0);
  amountEdit.TextHint := TCurrencyUtils.CurrencyToString(12345678);
  bShowLogs := TPngSpeedButton.Create(Self);
  bShowLogs.Name := 'bShowLogs';
  bShowLogs.GroupIndex := 1;
  bShowLogs.AllowAllUp := true;
  bShowLogs.Action := ShowLogAction;
  bShowLogs.Flat := true;
  bShowLogs.Parent := StatusBar;
  ShowLogAction.Caption := '';
  bShowLogs.Action := ShowLogAction;
  bShowLogs.ShowHint := true;
  accountVList.NodeDataSize := sizeof(TAccount);
  accountVList.CheckImageKind := TCheckImageKind.ckSystemDefault;
  MainActions.Style := PlatformVclStylesStyle;
  AccountListActions.Style := PlatformVclStylesStyle;
  FBackgroundPanel := nil;
  FMustProcessWalletChanged := false;
  FMustProcessNetConnectionUpdated := false;
  FRPCServer := nil;
  FPoolMiningServer := nil;
  FMinAccountBalance := 0;
  FMaxAccountBalance := CT_MaxWalletAmount;
  FMessagesUnreadCount := 0;
  memoNetConnections.Lines.Clear;
  memoNetServers.Lines.Clear;
  memoNetBlackLists.Lines.Clear;
  FUpdating := false;
  FOrderedAccountsKeyList := nil;
  TimerUpdateStatus.Enabled := false;
  FIsActivated := false;
//  FWalletKeys := TKeyManager.Create(Self);
  for i := 0 to StatusBar.Panels.Count - 1 do
  begin
    StatusBar.Panels[i].Text := '';
  end;
  FLog := TLog.Create(Self);
  FLog.OnNewLog := OnNewLog;
  FLog.SaveTypes := [];
  if not ForceDirectories(TFolderHelper.GetMicroCoinDataFolder) then
    raise Exception.Create('Cannot create dir: ' + TFolderHelper.GetMicroCoinDataFolder);
  FAppParams := TAppParams.Create(Self);
  FAppParams.FileName := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'AppParams.prm';
  FNodeNotifyEvents := TNodeNotifyEvents.Create(Self);
  FNodeNotifyEvents.OnBlocksChanged := OnNewAccount;
  FNodeNotifyEvents.OnNodeMessageEvent := OnNodeMessageEvent;
  FNodeNotifyEvents.OnOperationsChanged:= OnNewOperation;
  TNode.Node.KeyManager := TKeyManager.Create(self);
  TNode.Node.KeyManager.OnChanged := OnWalletChanged;
  LoadAppParams;
  UpdatePrivateKeys;
  UpdateBlockChainState;
  UpdateConnectionStatus;
  cbExploreMyAccountsClick(nil);
  TrayIcon.Visible := true;
  TrayIcon.Hint := Self.Caption;
  TrayIcon.BalloonTitle := 'Restoring the window.';
  TrayIcon.BalloonHint := 'Double click the system tray icon to restore MicroCoin Wallet';
  TrayIcon.BalloonFlags := bfInfo;
  MinersBlocksFound := 0;
  FBackgroundPanel := TPanel.Create(Self);
  FBackgroundPanel.Parent := MainPanel;
  FBackgroundPanel.Align := alClient;
  FBackgroundPanel.BorderStyle := bsNone;
  FBackgroundPanel.BevelKind := bkNone;
  FBackgroundPanel.BevelInner := bvNone;
  FBackgroundPanel.BevelOuter := bvNone;
  FBackgroundPanel.BorderWidth := 0;
  FBackgroundPanel.Font.Size := 15;
end;

procedure TMainForm.ChangeKeyActionExecute(Sender: TObject);
begin
 with TChangeAccountKeyForm.Create(self) do begin
   Account := TAccount(accountVList.FocusedNode.GetData()^);
   ShowModal;
   Free;
 end;
end;

procedure TMainForm.ChangeKeyActionUpdate(Sender: TObject);
var
  xIsReady : AnsiString;
begin
 if accountVList.FocusedNode <> nil then
    ChangeKeyAction.Enabled := TNode.Node.IsReady(xIsReady) and
    (TNode.Node.KeyManager.IndexOfAccountKey(
    TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.AccountKey) > -1)
 else ChangeKeyAction.Enabled := false;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  step: string;
begin
  Self.Hide;
  Application.ProcessMessages;
  TLog.NewLog(ltinfo, Classname, 'Destroying form - START');
  try
    FreeAndNil(FRPCServer);
    FreeAndNil(FPoolMiningServer);
    step := 'Saving params';
    SaveAppParams;
    FreeAndNil(FAppParams);
    //
    step := 'Assigning nil events';

    FLog.OnNewLog := nil;
    // FNodeNotifyEvents.Node := Nil;
    // FOperationsAccountGrid.Node := Nil;
    // FPendingOperationsGrid.Node := Nil;
    // FAccountsGrid.Node := Nil;
    // FSelectedAccountsGrid.Node := Nil;
    TConnectionManager.Instance.OnReceivedHelloMessage := nil;
    TConnectionManager.Instance.OnStatisticsChanged := nil;
    TConnectionManager.Instance.OnNetConnectionsUpdated := nil;
    TConnectionManager.Instance.OnNodeServersUpdated := nil;
    TConnectionManager.Instance.OnBlackListUpdated := nil;
    //

    step := 'Destroying NodeNotifyEvents';
    FreeAndNil(FNodeNotifyEvents);
    //
    step := 'Assigning Nil to TNetData';
    TConnectionManager.Instance.OnReceivedHelloMessage := nil;
    TConnectionManager.Instance.OnStatisticsChanged := nil;

    step := 'Ordered Accounts Key list';
    FreeAndNil(FOrderedAccountsKeyList);

    step := 'Desactivating Node';
    // TNode.Node.NetServer.Active := false;
 
//    TConnectionManager.Instance.Free;

    step := 'Processing messages 1';
    Application.ProcessMessages;

    step := 'Destroying Node';
    TNode.FreeNode;
    step := 'Destroying Wallet';
//    FreeAndNil(TNode.Node.KeyManager);
    step := 'Processing messages 2';
    Application.ProcessMessages;
    step := 'Destroying stringslist';
    if Assigned(FAccounts)
    then FreeAndNil(FAccounts);
    TConnectionManager.ReleaseInstance;

  except
    on E: Exception do
    begin
      TLog.NewLog(lterror, Classname, 'Error destroying Form step: ' + step + ' Errors (' + E.Classname + '): ' +
        E.Message);
    end;
  end;
  TLog.NewLog(ltinfo, Classname, 'Destroying form - END');
  FreeAndNil(FLog);
  Sleep(100);
end;

procedure TMainForm.MultipleTransactionActionExecute(Sender: TObject);
begin
  if accountVList.CheckedCount = 0
  then begin
    MessageDlg('Please select accounts', TMsgDlgType.mtWarning, [mbOK], 0);
    exit;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  UpdateAccounts(true);
end;

function TMainForm.GetAccountKeyForMiner: TAccountKey;
var
  xPrivateKey: TECPrivateKey;
  i: Integer;
  xPublicKey: TECDSA_Public;
begin
  Result := CT_TECDSA_Public_Nul;
  if not Assigned(TNode.Node.KeyManager) then
    exit;
  if not Assigned(FAppParams) then
    exit;
  case FMinerPrivateKeyType of
    mpk_NewEachTime:
      xPublicKey := CT_TECDSA_Public_Nul;
    mpk_Selected:
      begin
        xPublicKey := TAccountKey.FromRawString(FAppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey]
          .GetAsString(''));
      end;
  else
    // Random
    xPublicKey := CT_TECDSA_Public_Nul;
    if TNode.Node.KeyManager.Count > 0 then
      xPublicKey := TNode.Node.KeyManager.Key[Random(TNode.Node.KeyManager.Count)].AccountKey;
  end;
  i := TNode.Node.KeyManager.IndexOfAccountKey(xPublicKey);
  if i >= 0 then
  begin
    if (TNode.Node.KeyManager.Key[i].CryptedKey = '') then
      i := -1;
  end;
  if i < 0 then
  begin
    xPrivateKey := TECPrivateKey.Create;
    try
      xPrivateKey.GenerateRandomPrivateKey(CT_Default_EC_OpenSSL_NID);
      TNode.Node.KeyManager.AddPrivateKey('New for miner ' + DateTimeToStr(now), xPrivateKey);
      xPublicKey := xPrivateKey.PublicKey;
    finally
      xPrivateKey.Free;
    end;
  end;
  Result := xPublicKey;
end;

procedure TMainForm.LoadAppParams;
var
  xMemoryStream: TMemoryStream;
  s: AnsiString;
  xFileVersionInfo: TFileVersionInfo;
begin
  xMemoryStream := TMemoryStream.Create;
  try
    s := FAppParams.ParamByName[CT_PARAM_GridAccountsStream].GetAsString('');
    xMemoryStream.WriteBuffer(s[1], length(s));
    xMemoryStream.Position := 0;
    // Disabled on V2: FAccountsGrid.LoadFromStream(ms);
  finally
    xMemoryStream.Free;
  end;
  if FAppParams.FindParam(CT_PARAM_MinerName) = nil then
  begin
    // New configuration... assigning a new random value
    xFileVersionInfo := TFolderHelper.GetTFileVersionInfo(Application.ExeName);
    FAppParams.ParamByName[CT_PARAM_MinerName].SetAsString(Format(rsNewNodeBuild, [DateTimeToStr(now), xFileVersionInfo.InternalName,
      xFileVersionInfo.FileVersion]));
  end;
  UpdateConfigChanged;
end;

procedure TMainForm.OnMiningServerNewBlockFound(Sender: TObject);
begin
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
end;

procedure TMainForm.OnNetBlackListUpdated(Sender: TObject);
const
  CT_TRUE_FALSE: array [Boolean] of AnsiString = ('FALSE', 'TRUE');
var
  i, j, n: Integer;
  P: PNodeServerAddress;
  l: TList;
  Strings: TStrings;
begin
  l := TConnectionManager.Instance.NodeServersAddresses.LockList;
  try
    Strings := memoNetBlackLists.Lines;
    Strings.BeginUpdate;
    try
      Strings.Clear;
      Strings.Add(Format(rsBlackListUpd, [DateTimeToStr(now), IntToHex(TThread.CurrentThread.ThreadID, 8)]));
      j := 0;
      n := 0;
      for i := 0 to l.Count - 1 do
      begin
        P := l[i];
        if (P^.is_blacklisted) then
        begin
          inc(n);
          if not P^.its_myself then
          begin
            inc(j);
            Strings.Add(Format(rsBlacklistIPS, [P^.ip, P^.Port,
              DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(P^.last_connection))), P^.BlackListText]));
          end;
        end;
      end;
      Strings.Add(Format(rsTotalBlackli, [j, n]));
    finally
      Strings.EndUpdate;
    end;
  finally
    TConnectionManager.Instance.NodeServersAddresses.UnlockList;
  end;
end;

procedure TMainForm.OnNetConnectionsUpdated(Sender: TObject);
begin
  if FMustProcessNetConnectionUpdated then
    exit;
  FMustProcessNetConnectionUpdated := true;
  PostMessage(Self.Handle, CM_PC_NetConnectionUpdated, 0, 0);
end;

procedure TMainForm.OnNetNodeServersUpdated(Sender: TObject);
var
  i: Integer;
  P: PNodeServerAddress;
  l: TList;
  Strings: TStrings;
  s: string;
begin
  l := TConnectionManager.Instance.NodeServersAddresses.LockList;
  try
    Strings := memoNetServers.Lines;
    Strings.BeginUpdate;
    try
      Strings.Clear;
      Strings.Add(Format(rsNodeServersU, [DateTimeToStr(now), IntToStr(l.Count)]));
      for i := 0 to l.Count - 1 do
      begin
        P := l[i];
        if not(P^.is_blacklisted) then
        begin
          s := Format(rsServerIPSD, [P^.ip, P^.Port]);
          if Assigned(P.NetConnection) then
          begin
            if P.last_connection > 0 then
              s := Format(rsACTIVE, [s])
            else
              s := Format(rsTRYINGTOCONN, [s]);
          end;
          if P.its_myself then
          begin
            s := Format(rsNOTVALID, [s, P.BlackListText]);
          end;
          if P.last_connection > 0 then
          begin
            s := Format(rsLastConnecti,
              [s, DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(P^.last_connection)))]);
          end;
          if P.last_connection_by_server > 0 then
          begin
            s := Format(rsLastServerCo,
              [s, DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(P^.last_connection_by_server)))]);
          end;
          if (P.last_attempt_to_connect > 0) then
          begin
            s := Format(rsLastAttemptT, [s, DateTimeToStr(P^.last_attempt_to_connect)]);
          end;
          if (P.total_failed_attemps_to_connect > 0) then
          begin
            s := Format(rsAttempts, [s, IntToStr(P^.total_failed_attemps_to_connect)]);
          end;

          Strings.Add(s);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    TConnectionManager.Instance.NodeServersAddresses.UnlockList;
  end;
end;

procedure TMainForm.OnNetStatisticsChanged(Sender: TObject);
begin
  StatusBar.Invalidate;
end;

procedure TMainForm.OnNewAccount(Sender: TObject);
begin
  try
    UpdateAccounts(false);
    UpdateBlockChainState;
  except
    on E: Exception do
    begin
      E.Message := 'Error at OnNewAccount ' + E.Message;
      raise;
    end;
  end;
end;

procedure TMainForm.OnNewLog(logtype: TLogType; Time: TDateTime; ThreadID: Cardinal;
  const Sender, logtext: AnsiString);
var
  s: AnsiString;
begin
   if (logtype=ltdebug) then exit;
  if ThreadID = MainThreadID then
    s := ' MAIN:'
  else
    s := ' TID:';
  if logDisplay.Lines.Count > 300 then
  begin
    logDisplay.Lines.BeginUpdate;
    try
      while logDisplay.Lines.Count > 250 do
        logDisplay.Lines.Delete(0);
    finally
      logDisplay.Lines.EndUpdate;
    end;
  end;
  case logtype of
    ltinfo:
      logDisplay.SelAttributes.Color := clWindowText;
    ltdebug:
      logDisplay.SelAttributes.Color := clGray;
    ltupdate:
      logDisplay.SelAttributes.Color := clGreen;
    lterror:
      logDisplay.SelAttributes.Color := clRed;
  end;
  logDisplay.Lines.Add(formatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.LongTimeFormat, Time)
    { +s+IntToHex(ThreadID,
      8) } + ' [' + CT_LogType[logtype] + '] ' + { <'+sender+'> '+ } logtext);
  if logPanel.Visible and (bottomPageControl.ActivePageIndex = 0) and Visible then
    logDisplay.SetFocus;
  logDisplay.SelStart := logDisplay.GetTextLen;
  logDisplay.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TMainForm.OnNewOperation(Sender: TObject);
var
  i:integer;
  xTransaction: ITransaction;
  xIndex: integer;
  xNotification: TNotification;
begin
  for i:=0 to TNodeNotifyEvents(Sender).Node.Operations.Count - 1 do begin
     xTransaction := TNodeNotifyEvents(Sender).Node.Operations.OperationsHashTree.GetOperation(i);
     if FAccounts.Find(xTransaction.DestinationAccount, xIndex)
     then begin
       xNotification := NotificationCenter.CreateNotification;
       try
         xNotification.Title := 'New transaction';
         xNotification.AlertBody := xTransaction.ToString;
         xNotification.Name := xTransaction.ToString;
         NotificationCenter.PresentNotification(xNotification);
       finally
         xNotification.Free;
       end;
     end;
  end;
  UpdateAccounts(true);
end;

procedure TMainForm.OnNodeMessageEvent(NetConnection: TNetConnection; MessageData: TRawBytes);
begin
end;

procedure TMainForm.OnReceivedHelloMessage(Sender: TObject);
var
  nsarr: TNodeServerAddressArray;
  i: Integer;
  s: AnsiString;
begin
  // CheckMining;
  // Update node servers Peer Cache
  nsarr := TConnectionManager.Instance.GetValidNodeServers(true, 0);
  s := '';
  for i := low(nsarr) to high(nsarr) do
  begin
    if (s <> '') then
      s := s + ';';
    s := s + nsarr[i].ip + ':' + IntToStr(nsarr[i].Port);
  end;
  FAppParams.ParamByName[CT_PARAM_PeerCache].SetAsString(s);
  TNode.Node.PeerCache := s;
end;

procedure TMainForm.OnSelectedAccountsGridUpdated(Sender: TObject);
begin
end;

procedure TMainForm.OnWalletChanged(Sender: TObject);
begin
  if FMustProcessWalletChanged then
    exit;
  FMustProcessWalletChanged := true;
  PostMessage(Self.Handle, CM_PC_WalletKeysChanged, 0, 0);
end;

procedure TMainForm.TransactionHistoryActionExecute(Sender: TObject);
begin
  with TTransactionHistoryForm.Create(nil) do begin
    Account := TAccount(accountVList.FocusedNode.GetData()^);
    Show;
  end;
end;

procedure TMainForm.TransactionHistoryActionUpdate(Sender: TObject);
begin
  if accountVList.FocusedNode<>nil
  then TransactionHistoryAction.Enabled := true
  else TransactionHistoryAction.Enabled := false;
end;

procedure TMainForm.TransactionsActionExecute(Sender: TObject);
begin
//  TTransactionHistory.Create(Self, TNode.Node, FWalletKeys, FAppParams).Show;
  TTransactionExplorer.Create(nil).Show;
end;

procedure TMainForm.PendingTransactionsActionExecute(Sender: TObject);
begin
  with TTransactionHistoryForm.Create(nil) do begin
    Show;
  end;
end;

procedure TMainForm.SaveAppParams;
begin
end;

procedure TMainForm.SelectAllActionExecute(Sender: TObject);
var
  Node: PVirtualNode;
  allAmount : UInt64;
begin
  allAmount := 0;
  accountVList.BeginUpdate;
  try
    Node := accountVList.GetFirst;
    while Assigned(Node) do
    begin
      if SelectAllAction.Checked
      then begin
         Node.CheckState := TCheckState.csCheckedNormal;
         allAmount := allAmount + TAccount(Node.GetData()^).balance;
      end
      else Node.CheckState := TCheckState.csUncheckedNormal;
      Node := accountVList.GetNextSibling(Node);
    end;
    if SelectAllAction.Checked then begin
      amountEdit.ReadOnly := true;
      amountEdit.Text := TCurrencyUtils.CurrencyToString(allAmount);
      amountEdit.readOnly := True;
    end else begin
      amountEdit.Clear;
      amountEdit.readOnly := False;
    end;
  finally
    accountVList.EndUpdate;
  end;
end;

procedure TMainForm.SelectAllActionUpdate(Sender: TObject);
begin
  SelectAllAction.Enabled := accountVList.RootNodeCount > 0;
end;

procedure TMainForm.SellAccountActionExecute(Sender: TObject);
begin
 with  TSellAccountForm.Create(self) do begin
   Account := TAccount(accountVList.FocusedNode.GetData()^);
   ShowModal;
   Free;
 end;
end;

procedure TMainForm.SellAccountActionUpdate(Sender: TObject);
var
  xIsReady: AnsiString;
begin
 if accountVList.FocusedNode <> nil then
    SellAccountAction.Enabled := (TNode.Node.KeyManager.IndexOfAccountKey(
    TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.AccountKey) > -1)
    and TNode.Node.IsReady(xIsReady)
    and (TAccount(accountVList.FocusedNode.GetData()^).AccountInfo.state = as_Normal)
 else SellAccountAction.Enabled := false;
end;

procedure TMainForm.SendExecute(Sender: TObject);
var
  i : integer;
  xTransaction : ITransaction;
  xSenderAccount: TAccount;
  xTargetAccount: TAccount;
  xTargetAccountNumber : Cardinal;
  xWalletKey : TWalletKey;
  xAmount, xFee : int64;
  xErrors: AnsiString;
  xPayload : AnsiString;
  xPassword: string;
begin

  while not TNode.Node.KeyManager.IsValidPassword
  do begin
   if not InputQuery('Unlock wallet', [#30+'Password:'], xPassword) then exit;
   TNode.Node.KeyManager.WalletPassword := xPassword;
  end;

  xPassword := '';

  if not TCurrencyUtils.ParseValue(amountEdit.Text, xAmount) then begin
    MessageDlg('Invalid amount', mtError, [mbOK], 0);
    exit;
  end;

  if not TCurrencyUtils.ParseValue(feeEdit.Text, xFee) then begin
    MessageDlg('Invalid fee', mtError, [mbOK], 0);
    exit;
  end;

  if not TAccount.AccountTxtNumberToAccountNumber(targetAccountEdit.AccountNumber, xTargetAccountNumber) then
  begin
    MessageDlg('Invalid account number', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  if accountVList.FocusedNode = nil then begin
    MessageDlg('Please select sender account from the list on the right side', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  xSenderAccount := TAccount(accountVList.FocusedNode.GetData()^);
  i := TNode.Node.KeyManager.IndexOfAccountKey(xSenderAccount.AccountInfo.AccountKey);
  if i<0 then begin
    MessageDlg('Sender private key not found', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  if (xAmount + xFee) > xSenderAccount.balance then begin
    MessageDlg('Not enough money', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  try
    xTargetAccount := TNode.Node.Operations.BlockManager.AccountStorage.Account(xTargetAccountNumber);
  except on E:Exception do
    begin
      MessageDlg('Invalid target account, account does not exists', TMsgDlgType.mtError, [mbOK],0);
      exit;
    end;
  end;

  if xTargetAccount.IsAccountBlockedByProtocol(xTargetAccount.AccountNumber, TNode.Node.BlockManager.BlocksCount-1)
  then begin
    MessageDlg('Target Account is locked. Please try after 10 blocks', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  if xSenderAccount.IsAccountBlockedByProtocol(xSenderAccount.AccountNumber, TNode.Node.BlockManager.BlocksCount-1)
  then begin
    MessageDlg('Sender Account is locked. Please try after 10 blocks', TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;

  if Trim(payloadEdit.Text)<>'' then begin
     case encryptModeSelect.ItemIndex of
      0: xPayload := payloadEdit.Text;
      1: xPayload := ECIESEncrypt(xTargetAccount.AccountInfo.AccountKey, xPayload);
      2: xPayload := ECIESEncrypt(xSenderAccount.AccountInfo.AccountKey, xPayload);
      3: xPayload := TAESComp.EVP_Encrypt_AES256(xPayload, encryptionPassword.Text);
     end;
  end else xPayload := '';

  xWalletKey := TNode.Node.KeyManager.Key[i];
  xTransaction := TTransferMoneyTransaction.CreateTransaction(xSenderAccount.AccountNumber,
    xSenderAccount.n_operation + 1,
    xTargetAccount.AccountNumber, xWalletKey.PrivateKey, xAmount, xFee, xPayload);

  if MessageDlg('Execute transaction? '+xTransaction.ToString, mtConfirmation, [mbYes, mbNo], 0)<>mrYes
  then exit;

  if not TNode.Node.AddOperation(nil, xTransaction, xErrors) then begin
    MessageDlg(xErrors, TMsgDlgType.mtError, [mbOK],0);
    exit;
  end else begin
    amountEdit.Clear;
    feeEdit.Text := TCurrencyUtils.CurrencyToString(0);
    payloadEdit.Lines.Clear;
    encryptionPassword.Clear;
    targetAccountEdit.AccountNumber := '';
    MessageDlg('Transaction successfully executed', TMsgDlgType.mtInformation, [mbOK], 0);
  end;
end;

procedure TMainForm.SetMinersBlocksFound(const Value: Integer);
begin
  FMinersBlocksFound := Value;
  labelBlocksFound.Caption := IntToStr(Value);
  if Value > 0 then
    labelBlocksFound.Font.Color := clGreen
  else
    labelBlocksFound.Font.Color := clDkGray;
end;

procedure TMainForm.SettingsActionExecute(Sender: TObject);
begin
  with TSettingsForm.Create(nil) do begin
    AppParams := FAppParams;
    if ShowModal = mrOk then begin
        UpdateConfigChanged;
    end;
  end;
end;

procedure TMainForm.ShowLogActionExecute(Sender: TObject);
begin
  logPanel.Visible := not logPanel.Visible;
  Splitter1.Top := logPanel.Top;
end;

procedure TMainForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  xText : string;
  xIndex: integer;
begin
  if Panel.Index = 0 then begin
    miscIcons.Draw(StatusBar.Canvas, Rect.Left + 3, Rect.Top, 3, TNode.Node.NetServer.Active);
    if TNode.Node.NetServer.Active
    then xText := 'Active'
    else xText := 'Stopped';
    StatusBar.Canvas.TextOut(Rect.Left + 24, 1+(Rect.Height div 2) - (Canvas.TextExtent(xText).Height div 2), xText);
  end;
  if Panel.Index = 1 then begin

    if TConnectionManager.Instance.NetStatistics.ClientsConnections + TConnectionManager.Instance.NetStatistics.ServersConnections = 0
    then xIndex := 2
    else xIndex := 1;

    miscIcons.Draw(Statusbar.Canvas, Rect.Left+3, Rect.Top, xIndex, True);
    xText := Format('%d clients | %d servers', [TConnectionManager.Instance.NetStatistics.ClientsConnections, TConnectionManager.Instance.NetStatistics.ServersConnections]);
    StatusBar.Canvas.TextOut(22 + Rect.Left, 1+(Rect.Height div 2) - (Canvas.TextExtent(xText).Height div 2), xText);
  end;

 if Panel.Index = 2 then begin
    miscIcons.Draw(Statusbar.Canvas, Rect.Left+3, Rect.Top, 6, True);
    xText := Format('Traffic: %.0n Kb | %.0n Kb',[TConnectionManager.Instance.NetStatistics.BytesReceived/1024, TConnectionManager.Instance.NetStatistics.BytesSend/1024]);
    StatusBar.Canvas.TextOut(Rect.Left + 23+3, 1+(Rect.Height div 2) - (Canvas.TextExtent(xText).Height div 2), xText);
  end;
  if Panel.Index = 5 then begin
    bShowLogs.Top := Rect.Top;
    bShowLogs.Left := Rect.Right - 35;
    bShowLogs.Width := 30;
    bShowLogs.Height := Rect.Bottom - Rect.Top - 3;
  end;
end;

procedure TMainForm.TimerUpdateStatusTimer(Sender: TObject);
begin
  try
    UpdateConnectionStatus;
    UpdateBlockChainState;
    UpdateNodeStatus;
  except
    on E: Exception do
    begin
      E.Message := Format(rsExceptionAtT, [E.Classname, E.Message]);
      TLog.NewLog(lterror, Classname, E.Message);
    end;
  end;
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
  TimerUpdateStatus.Enabled := true;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TMainForm.UpdateAccounts(RefreshData: Boolean);
var
  l: TOrderedList;
  i, j, k: Integer;
  acc: TAccount;
begin
  if not assigned(FAccounts)
  then FAccounts := TOrderedList.Create
  else FAccounts.Clear;

  FTotalAmount := 0;

  if not cbExploreMyAccounts.Checked then begin
    accountVList.RootNodeCount := TNode.Node.BlockManager.AccountStorage.AccountsCount;
    FTotalAmount := TNode.Node.Operations.BlockManager.AccountStorage.TotalBalance;
  end else begin
    if cbMyPrivateKeys.ItemIndex<0 then exit;
    if cbMyPrivateKeys.ItemIndex=0 then begin
      for i := 0 to TNode.Node.KeyManager.Count - 1 do begin
        j := FOrderedAccountsKeyList.IndexOfAccountKey(TNode.Node.KeyManager[i].AccountKey);
        if (j>=0) then begin
          l := FOrderedAccountsKeyList.AccountList[j];
          for k := 0 to l.Count - 1 do begin
            FAccounts.Add(l.Get(k));
            acc := TNode.Node.Operations.AccountTransaction.Account(l.Get(k));
            FTotalAmount := FTotalAmount + acc.balance;
          end;
        end;
      end;
    end else begin
      i := PtrInt(cbMyPrivateKeys.Items.Objects[cbMyPrivateKeys.ItemIndex]);
      if (i>=0) And (i<TNode.Node.KeyManager.Count) then begin
        j := FOrderedAccountsKeyList.IndexOfAccountKey(TNode.Node.KeyManager[i].AccountKey);
        if (j>=0) then begin
          l := FOrderedAccountsKeyList.AccountList[j];
          for k := 0 to l.Count - 1 do begin
            FAccounts.Add(l.Get(k));
            acc := TNode.Node.Operations.AccountTransaction.Account(l.Get(k));
            FTotalAmount := FTotalAmount + acc.balance;
          end;
        end;
      end;
    end;
  accountVList.RootNodeCount := FAccounts.Count;
  end;
  accountVList.Invalidate;
  accountVList.ReinitNode(nil, true);
  labelAccountsBalance.Caption := TCurrencyUtils.CurrencyToString(FTotalAmount);
  labelAccountsCount.Caption := Format('%.0n', [accountVList.RootNodeCount+0.0]);
end;

procedure TMainForm.UpdateBlockChainState;
var
  F, favg: real;
  isMining: boolean;
begin
  UpdateNodeStatus;
  if true then
  begin
    if TNode.Node.BlockManager.BlocksCount > 0 then
    begin
      lblCurrentBlock.Caption := IntToStr(TNode.Node.BlockManager.BlocksCount) + ' (0..' +
        IntToStr(TNode.Node.BlockManager.BlocksCount - 1) + ')';;
    end
    else lblCurrentBlock.Caption := rsNone;
    lblCurrentAccounts.Caption := IntToStr(TNode.Node.BlockManager.AccountsCount);
    lblCurrentBlockTime.Caption := UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastOperationBlock.timestamp);
    labelOperationsPending.Caption := IntToStr(TNode.Node.Operations.Count);
    lblCurrentDifficulty.Caption := IntToHex(TNode.Node.Operations.BlockHeader.compact_target, 8);
    if TConnectionManager.Instance.MaxRemoteOperationBlock.block>TNode.Node.BlockManager.BlocksCount
    then begin
      StatusBar.Panels[3].Text :=
      Format('Downloading blocks: %.0n / %.0n', [TConnectionManager.Instance.MaxRemoteOperationBlock.block+0.0,
                                                 TNode.Node.BlockManager.BlocksCount+0.0]);
    end
    else begin
      StatusBar.Panels[3].Text := 'Blocks: ' + Format('%.0n', [TNode.Node.BlockManager.BlocksCount+0.0]) + ' | ' + 'Difficulty: 0x' +
        IntToHex(TNode.Node.Operations.BlockHeader.compact_target, 8);
    end;
    favg := TNode.Node.BlockManager.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage);
    F := (CT_NewLineSecondsAvg - favg) / CT_NewLineSecondsAvg;
    lblTimeAverage.Caption := Format(rsLast00SecOpt, [IntToStr(CT_CalcNewTargetBlocksAverage), FormatFloat('0.0', favg),
      IntToStr(CT_NewLineSecondsAvg), FormatFloat('0.00%', F * 100)]);
    if favg >= CT_NewLineSecondsAvg then
    begin
      lblTimeAverage.Font.Color := clNavy;
    end
    else
    begin
      lblTimeAverage.Font.Color := clOlive;
    end;
    lblTimeAverageAux.Caption := Format(rsLastDSSecDSS, [CT_CalcNewTargetBlocksAverage * 2,
      FormatFloat('0.0', TNode.Node.BlockManager.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage * 2)),
      ((CT_CalcNewTargetBlocksAverage * 3) div 2), FormatFloat('0.0',
      TNode.Node.BlockManager.GetActualTargetSecondsAverage((CT_CalcNewTargetBlocksAverage * 3) div 2)),
      ((CT_CalcNewTargetBlocksAverage div 4) * 3), FormatFloat('0.0',
      TNode.Node.BlockManager.GetActualTargetSecondsAverage(((CT_CalcNewTargetBlocksAverage div 4) * 3))),
      CT_CalcNewTargetBlocksAverage div 2, FormatFloat('0.0',
      TNode.Node.BlockManager.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage div 2)),
      CT_CalcNewTargetBlocksAverage div 4, FormatFloat('0.0',
      TNode.Node.BlockManager.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage div 4))]);
  end
  else
  begin
    isMining := false;
    StatusBar.Panels[3].Text := '';
    lblCurrentBlock.Caption := '';
    lblCurrentAccounts.Caption := '';
    lblCurrentBlockTime.Caption := '';
    labelOperationsPending.Caption := '';
    lblCurrentDifficulty.Caption := '';
    lblTimeAverage.Caption := '';
    lblTimeAverageAux.Caption := '';
  end;
  if (Assigned(FPoolMiningServer)) and (FPoolMiningServer.Active) then
  begin
    if FPoolMiningServer.ClientsCount > 0 then
    begin
      labelMinersClients.Caption := Format(rsConnectedJSO, [IntToStr(FPoolMiningServer.ClientsCount)]);
      labelMinersClients.Font.Color := clNavy;
    end
    else
    begin
      labelMinersClients.Caption := rsNoJSONRPCCli;
      labelMinersClients.Font.Color := clDkGray;
    end;
    MinersBlocksFound := FPoolMiningServer.ClientsWins;
  end
  else
  begin
    MinersBlocksFound := 0;
    labelMinersClients.Caption := rsJSONRPCServe;
    labelMinersClients.Font.Color := clRed;
  end;
  //if TConnectionManager.Instance.IsGettingNewBlockChainFromClient then begin
  //  ProgressBar2.Max := TConnectionManager.Instance.MaxRemoteOperationBlock.block;
  //  ProgressBar2.Position := TNode.Node.BlockManager.BlocksCount;
  //end;
end;

procedure TMainForm.UpdateConfigChanged;
var
  wa: Boolean;
  i: Integer;
begin
  // tsLogs.TabVisible := FAppParams.ParamByName[CT_PARAM_ShowLogs].GetAsBoolean(false);
  FLog.OnNewLog := OnNewLog;
  if FAppParams.ParamByName[CT_PARAM_SaveLogFiles].GetAsBoolean(false) then
  begin
    if FAppParams.ParamByName[CT_PARAM_SaveDebugLogs].GetAsBoolean(false) then
      FLog.SaveTypes := CT_TLogTypes_ALL
    else
      FLog.SaveTypes := CT_TLogTypes_DEFAULT;
    FLog.FileName := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'MicroCointWallet.log';
  end
  else
  begin
    FLog.SaveTypes := [];
    FLog.FileName := '';
  end;
  wa := TNode.Node.NetServer.Active;
  TNode.Node.NetServer.Port := FAppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
  TNode.Node.NetServer.Active := wa;
  TNode.Node.Operations.BlockPayload := FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
  TNode.Node.NodeLogFilename := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'blocks.log';
  if Assigned(FPoolMiningServer) then
  begin
    if FPoolMiningServer.Port <> FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort]
      .GetAsInteger(CT_JSONRPCMinerServer_Port) then
    begin
      FPoolMiningServer.Active := false;
      FPoolMiningServer.Port := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort]
        .GetAsInteger(CT_JSONRPCMinerServer_Port);
    end;
    FPoolMiningServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].GetAsBoolean(true);
    FPoolMiningServer.UpdateAccountAndPayload(GetAccountKeyForMiner,
      FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString(''));
  end;
  if Assigned(FRPCServer) then
  begin
    FRPCServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1');
  end;
  i := FAppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].GetAsInteger(Integer(mpk_Random));
  if (i >= Integer(low(TMinerPrivateKey))) and (i <= Integer(high(TMinerPrivateKey))) then
    FMinerPrivateKeyType := TMinerPrivateKey(i)
  else
    FMinerPrivateKeyType := mpk_Random;
end;

procedure TMainForm.UpdateConnectionStatus;
var
  errors: AnsiString;
begin
  UpdateNodeStatus;
  OnNetStatisticsChanged(nil);
  if TNode.Node.IsBlockChainValid(errors) then
  begin
    StatusBar.Panels[4].Text := 'Last block: ' + UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastOperationBlock.timestamp);
  end
  else
  begin
    StatusBar.Panels[4].Text := 'Last block: ' + UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastOperationBlock.timestamp);
  end;
end;

procedure TMainForm.UpdateNodeStatus;
var
  status: AnsiString;
begin
  if TNode.Node.isready(status) then
  begin
    if TConnectionManager.Instance.NetStatistics.ActiveConnections > 0 then
    begin
      lblNodeStatus.Font.Color := clGreen;
      if TConnectionManager.Instance.IsDiscoveringServers then
      begin
        lblNodeStatus.Caption := rsDiscoveringS;
      end
      else if TConnectionManager.Instance.IsGettingNewBlockChainFromClient then
      begin
        lblNodeStatus.Caption := rsObtainingNew;
      end
      else
      begin
        lblNodeStatus.Caption := rsRunning;
      end;
    end
    else
    begin
      lblNodeStatus.Font.Color := clRed;
      lblNodeStatus.Caption := rsAloneInTheWo;
    end;
  end
  else
  begin
    lblNodeStatus.Font.Color := clRed;
    lblNodeStatus.Caption := status;
  end;
  if Assigned(FBackgroundPanel) then
  begin
    FBackgroundPanel.Font.Color := lblNodeStatus.Font.Color;
    FBackgroundPanel.Caption := Format(rsPleaseWaitUn, [lblNodeStatus.Caption]);
  end;
end;

procedure TMainForm.UpdatePrivateKeys;
var
  i, last_i: Integer;
  wk: TWalletKey;
  s: AnsiString;
begin
  if (not Assigned(FOrderedAccountsKeyList)) then
  begin
    FOrderedAccountsKeyList := TOrderedAccountKeysList.Create(TNode.Node.BlockManager.AccountStorage, false);
  end;
  if (cbMyPrivateKeys.ItemIndex >= 0) then
    last_i := PtrInt(cbMyPrivateKeys.Items.Objects[cbMyPrivateKeys.ItemIndex])
  else
    last_i := -1;
  cbMyPrivateKeys.Items.BeginUpdate;
  try
    cbMyPrivateKeys.Items.Clear;
    for i := 0 to TNode.Node.KeyManager.Count - 1 do
    begin
      wk := TNode.Node.KeyManager.Key[i];
      if Assigned(FOrderedAccountsKeyList) then
      begin
        FOrderedAccountsKeyList.AddAccountKey(wk.AccountKey);
      end;
      if (wk.name = '') then
      begin
        s := 'Sha256=' + TCrypto.ToHexaString(TCrypto.DoSha256(wk.AccountKey.ToRawString));
      end
      else
      begin
        s := wk.name;
      end;
      if not Assigned(wk.PrivateKey) then
        s := s + '(*)';
      cbMyPrivateKeys.Items.AddObject(s, TObject(i));
    end;
    cbMyPrivateKeys.Sorted := true;
    cbMyPrivateKeys.Sorted := false;
    cbMyPrivateKeys.Items.InsertObject(0, rsAllMyPrivate, TObject(-1));
  finally
    cbMyPrivateKeys.Items.EndUpdate;
  end;
  last_i := cbMyPrivateKeys.Items.IndexOfObject(TObject(last_i));
  if last_i < 0 then
    last_i := 0;
  if cbMyPrivateKeys.Items.Count > last_i then
    cbMyPrivateKeys.ItemIndex := last_i
  else if cbMyPrivateKeys.Items.Count >= 0 then
    cbMyPrivateKeys.ItemIndex := 0;
end;

procedure TMainForm.SendUpdate(Sender: TObject);
var
  temp : Cardinal;
  temp2: Int64;
  xIsReady: AnsiString;
begin
  Send.Enabled := (accountVList.FocusedNode <> nil)
    and TNode.Node.IsReady(xIsReady)
    and TAccount.AccountTxtNumberToAccountNumber(targetAccountEdit.AccountNumber, temp)
    and TCurrencyUtils.ParseValue(amountEdit.Text, temp2)
    and TCurrencyUtils.ParseValue(feeEdit.Text, temp2);
end;

initialization

MainForm := nil;

end.
