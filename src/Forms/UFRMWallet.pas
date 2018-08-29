unit UFRMWallet;

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

{$I ./../MicroCoin/Core/config.inc}

uses
{$IFnDEF FPC}
  pngimage, Windows, AppEvnts, ShlObj,
{$ELSE}
  LCLIntf, LCLType, LMessages, fpjson, jsonparser,LResources, LCLTranslator, Translations,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, UWalletKeys, StdCtrls, ULog, Grids, UAppParams,
  UGridUtils, Menus, ImgList,
  synautil, UCrypto, Buttons, IniFiles,
  MicroCoin.Transaction.Base, MicroCoin.Transaction.TransferMoney, MicroCoin.Transaction.ChangeKey,
  MicroCoin.Account.AccountKey, MicroCoin.Common.Lists, MicroCoin.Common,
  MicroCoin.Account.Data, UFRMAccountSelect, Types, httpsend, UFRMMineCoins,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList, MicroCoin.Node.Node,
  MicroCoin.Account.Storage, Vcl.PlatformVclStylesActnCtrls,
  UBlockExplorerForm, MicroCoin.RPC.Server,
  Vcl.PlatformDefaultStyleActnCtrls, System.ImageList,
  MicroCoin.Forms.TransactionHistory, MicroCoin.Mining.Server,
  MicroCoin.Forms.PendignTransaction, MicroCoin.Node.Events,
  MicroCoin.Net.Connection, MicroCoin.Net.Client, MicroCoin.Net.Statistics,
  Vcl.Samples.Gauges, MicroCoin.Components.BlockExplorer,
  MicroCoin.Forms.Log, MicroCoin.Components.Messages,
  Vcl.Tabs, JvExExtCtrls, JvExtComponent, JvCaptionPanel {$IFDEF WINDOWS},windows{$ENDIF};

Const
  CM_PC_WalletKeysChanged = WM_USER + 1;
  CM_PC_NetConnectionUpdated = WM_USER + 2;

type
  TMinerPrivateKey = (mpk_NewEachTime, mpk_Random, mpk_Selected);

  { TFRMWallet }

  TFRMWallet = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    mmEnglish: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    StatusBar: TStatusBar;
    Timer1: TTimer;
    TrayIcon: TTrayIcon;
    TimerUpdateStatus: TTimer;
    MainMenu: TMainMenu;
    miProject: TMenuItem;
    miOptions: TMenuItem;
    miPrivatekeys: TMenuItem;
    miN1: TMenuItem;
    miAbout: TMenuItem;
    miAboutMicroCoin: TMenuItem;
    miNewOperation: TMenuItem;
    N1: TMenuItem;
    MiClose: TMenuItem;
    MiDecodePayload: TMenuItem;
    ImageListIcons: TImageList;
    IPnodes1: TMenuItem;
    MiOperations: TMenuItem;
    MiAddaccounttoSelected: TMenuItem;
    MiRemoveaccountfromselected: TMenuItem;
    N2: TMenuItem;
    MiMultiaccountoperation: TMenuItem;
    N3: TMenuItem;
    MiFindnextaccountwithhighbalance: TMenuItem;
    MiFindpreviousaccountwithhighbalance: TMenuItem;
    MiFindaccount: TMenuItem;
    MiFindOperationbyOpHash: TMenuItem;
    MiAccountInformation: TMenuItem;
    ActionImages: TImageList;
    LargeActionImages: TImageList;
    ActionToolBar1: TActionToolBar;
    SmallActounImages: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Panel9: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Panel5: TPanel;
    GroupBox3: TGroupBox;
    TabSheet3: TTabSheet;
    dgSelectedAccounts: TDrawGrid;
    pnlSelectedAccountsLeft: TPanel;
    sbSelectedAccountsAdd: TSpeedButton;
    sbSelectedAccountsAddAll: TSpeedButton;
    sbSelectedAccountsDel: TSpeedButton;
    sbSelectedAccountsDelAll: TSpeedButton;
    Panel10: TPanel;
    bbSelectedAccountsOperation: TBitBtn;
    Panel4: TPanel;
    GroupBox2: TGroupBox;
    dgAccounts: TDrawGrid;
    Panel6: TPanel;
    bbAccountsRefresh: TBitBtn;
    Panel8: TPanel;
    cbExploreMyAccounts: TCheckBox;
    cbMyPrivateKeys: TComboBox;
    MainActions: TActionManager;
    PrivateKeys: TAction;
    CloseAction: TAction;
    Options: TAction;
    Nodes: TAction;
    Send: TAction;
    BlockExplorer: TAction;
    Operations: TAction;
    PendingOperations: TAction;
    AboutAction: TAction;
    ActoinMessage: TAction;
    Action1: TAction;
    Home: TAction;
    BalloonHint1: TBalloonHint;
    NodeStatsAction: TAction;
    ShowLogAction: TAction;
    logPanel: TPanel;
    MessagesFrame1: TMessagesFrame;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    logDisplay: TRichEdit;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    memoNetConnections: TMemo;
    memoNetBlackLists: TMemo;
    memoNetServers: TMemo;
    dgAccountOperations: TDrawGrid;
    MainPanel: TPanel;
    Panel3: TPanel;
    Label17: TLabel;
    lblAccountsCount: TLabel;
    Label19: TLabel;
    lblAccountsBalance: TLabel;
    lblOperationsPendingCaption: TLabel;
    lblOperationsPending: TLabel;
    lblMiningStatusCaption: TLabel;
    lblMinersClients: TLabel;
    lblBlocksFound: TLabel;
    lblNodeStatus: TLabel;
    Label8: TLabel;
    TabSheet8: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    lblCurrentAccounts: TLabel;
    Label10: TLabel;
    Label21: TLabel;
    lblCurrentBlockTime: TLabel;
    lblCurrentDifficulty: TLabel;
    lblTimeAverage: TLabel;
    lblTimeAverageAux: TLabel;
    lblCurrentBlock: TLabel;
    Panel1: TPanel;
    Label16: TLabel;
    Splitter1: TSplitter;
    procedure bbMineCoinsClick(Sender: TObject);
    procedure bbRequestMoneyClick(Sender: TObject);
    procedure dgAccountOperationsDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure mmEnglishClick(Sender: TObject);
    procedure sbSearchAccountClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerUpdateStatusTimer(Sender: TObject);
    procedure cbMyPrivateKeysChange(Sender: TObject);
    procedure dgAccountsClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miAboutMicroCoinClick(Sender: TObject);
    procedure miNewOperationClick(Sender: TObject);
    procedure miPrivatekeysClick(Sender: TObject);
    procedure dgAccountsColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure dgAccountsFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure PageControlChange(Sender: TObject);
    procedure cbExploreMyAccountsClick(Sender: TObject);
    procedure MiCloseClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure IPnodes1Click(Sender: TObject);
    procedure bbChangeKeyNameClick(Sender: TObject);
    procedure sbSelectedAccountsAddClick(Sender: TObject);
    procedure sbSelectedAccountsAddAllClick(Sender: TObject);
    procedure sbSelectedAccountsDelClick(Sender: TObject);
    procedure sbSelectedAccountsDelAllClick(Sender: TObject);
    procedure bbSelectedAccountsOperationClick(Sender: TObject);
    procedure bbAccountsRefreshClick(Sender: TObject);
    procedure ebFilterAccountByBalanceMinExit(Sender: TObject);
    procedure ebFilterAccountByBalanceMinKeyPress(Sender: TObject;
      var Key: Char);
    procedure cbFilterAccountsClick(Sender: TObject);
    procedure MiFindOperationbyOpHashClick(Sender: TObject);
    procedure MiAccountInformationClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrivateKeysExecute(Sender: TObject);
    procedure OperationsExecute(Sender: TObject);
    procedure PendingOperationsExecute(Sender: TObject);
    procedure ShowLogActionExecute(Sender: TObject);
    procedure ActoinMessageExecute(Sender: TObject);
  private
    FBackgroundPanel : TPanel;
    FMinersBlocksFound: Integer;
    procedure SetMinersBlocksFound(const Value: Integer);
    Procedure CheckIsReady;
    Procedure FinishedLoadingApp;
    Procedure FillAccountInformation(Const Strings : TStrings; Const AccountNumber : Cardinal);
    Procedure FillOperationInformation(Const Strings : TStrings; Const OperationResume : TTransactionData);
    Function ChangeAccountKey(account_signer, account_target : Cardinal; const new_pub_key : TAccountKey; fee : UInt64; const RawPayload : TRawBytes; Const Payload_method, EncodePwd : AnsiString) : Boolean;  protected
    { Private declarations }
    FNode : TNode;
    FIsActivated : Boolean;
    FWalletKeys : TWalletKeysExt;
    FLog : TLog;
    FAppParams : TAppParams;
    FNodeNotifyEvents : TNodeNotifyEvents;
    FAccountsGrid : TAccountsGrid;
    FSelectedAccountsGrid : TAccountsGrid;
    FOperationsAccountGrid : TOperationsGrid;
    FPendingOperationsGrid : TOperationsGrid;
    FOrderedAccountsKeyList : TOrderedAccountKeysList;
    FMinerPrivateKeyType : TMinerPrivateKey;
    FUpdating : Boolean;
    FMessagesUnreadCount : Integer;
    FMinAccountBalance : Int64;
    FMaxAccountBalance : Int64;
    FPoolMiningServer : TMiningServer;
    FRPCServer : TRPCServer;
    FMustProcessWalletChanged : Boolean;
    FMustProcessNetConnectionUpdated : Boolean;
    Procedure OnNewAccount(Sender : TObject);
    Procedure OnReceivedHelloMessage(Sender : TObject);
    Procedure OnNetStatisticsChanged(Sender : TObject);
    procedure OnNewLog(logtype : TLogType; Time : TDateTime; ThreadID : Cardinal; Const sender, logtext : AnsiString);
    procedure OnWalletChanged(Sender : TObject);
    procedure OnNetConnectionsUpdated(Sender : TObject);
    procedure OnNetNodeServersUpdated(Sender : TObject);
    procedure OnNetBlackListUpdated(Sender : TObject);
    Procedure OnNodeMessageEvent(NetConnection : TNetConnection; MessageData : TRawBytes);
    Procedure OnSelectedAccountsGridUpdated(Sender : TObject);
    Procedure OnMiningServerNewBlockFound(Sender : TObject);
    Procedure UpdateConnectionStatus;
    Procedure UpdateAccounts(RefreshData : Boolean);
    Procedure UpdateBlockChainState;
    Procedure UpdatePrivateKeys;
    Procedure UpdateOperations;
    Procedure LoadAppParams;
    Procedure SaveAppParams;
    Procedure UpdateConfigChanged;
    Procedure UpdateNodeStatus;
    Procedure UpdateAvailableConnections;
    procedure Activate; override;
    Function ForceMining : Boolean; virtual;
    Function GetAccountKeyForMiner : TAccountKey;
    Procedure DoUpdateAccounts;
    Function DoUpdateAccountsFilter : Boolean;
    procedure CM_WalletChanged(var Msg: TMessage); message CM_PC_WalletKeysChanged;
    procedure CM_NetConnectionUpdated(var Msg: TMessage); message CM_PC_NetConnectionUpdated;
    procedure ConfirmRestart;
  public
    { Public declarations }
    Property WalletKeys : TWalletKeysExt read FWalletKeys;
    Property MinersBlocksFound : Integer read FMinersBlocksFound write SetMinersBlocksFound;
  end;

var
  FRMWallet: TFRMWallet;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Uses UFolderHelper, UOpenSSL, UOpenSSLdef, UConst, UTime, MicroCoin.BlockChain.FileStorage,
  UThread, UECIES, UFRMMicroCoinWalletConfig,
  UFRMAbout, UFRMOperation, UFRMWalletKeys, UFRMPayloadDecoder, UFRMNodesIp, UFRMMemoText,
  MicroCoin.Net.NodeServer, MicroCoin.Net.ConnectionManager;

Type
  TThreadActivate = Class(TPCThread)
  protected
    procedure BCExecute; override;
  End;

resourcestring
  rsConnectedJSO = '%s connected JSON-RPC clients';
  rsNoJSONRPCCli = 'No JSON-RPC clients';
  rsJSONRPCServe = 'JSON-RPC server not active';
  rsLastAccountT = 'Last account time:%s';
  rsDdMmYyyyHhNn = 'dd/mm/yyyy hh:nn:ss';
  rsNOBLOCKCHAIN = 'NO BLOCKCHAIN: %s';
  rsInitializing = 'Initializing...';
  rsDiscoveringS = 'Discovering servers';
  rsObtainingNew = 'Obtaining new blockchain';
  rsRunning = 'Running';
  rsAloneInTheWo = 'Alone in the world...';
  rsPleaseWaitUn = 'Please wait until finished: %s';
  rsAllMyPrivate = '(All my private keys)';
  rsNone = '(none)';
  rsLastDSSecDSS = 'Last %d: %s sec. - %d: %s sec. - %d: %s sec. - %d: %s sec.'
    +' - %d: %s sec.';
  rsLast00SecOpt = 'Last %s: %s sec. (Optimal %ss) Deviation %s';
  rsConnectionsD = 'Connections:%d Clients:%d Servers:%d - Rcvd:%d Kb Send:%d '
    +'Kb';
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
  rsNotFoundAnyA = 'Not found any account higher than %s with balance higher '
    +'than %s';
  rsSearchOperat = 'Search operation by OpHash';
  rsInsertOperat = 'Insert Operation Hash value (OpHash)';
  rsNotFoundAnyA2 = 'Not found any account lower than %s with balance higher '
    +'than %s';
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
  rsYouCannotAdd = 'You cannot add %s account because private key not found in'
    +' your wallet.%s%sYou''re not the owner!';
  rsExceptionAtT = 'Exception at TimerUpdate %s: %s';
  rsClientIPS = 'Client: IP:%s';
  rsServerIPS = 'Server: IP:%s';
  rsCannotLoadTo = 'Cannot load %s%sTo use this software make sure this file '
    +'is available on you system or reinstall the application';
  rsCannotOpenYo = 'Cannot open your wallet... Perhaps another instance of '
    +'Micro Coin is active!%s%s%s';
  rsAnErrorOccur = 'An error occurred during initialization. Application '
    +'cannot continue:%s%s%s%s%sApplication will close...';
  rsChangeKeyNam = 'Change Key name';
  rsInputNewName = 'Input new name';
  rsMustSelectAK = 'Must select a Key';
  rsMustSelectAt = 'Must select at least 1 account';
  rsSendThisMess = 'Send this message to %s nodes?%sNOTE: Sending unauthorized'
    +' messages will be considered spam and you will be banned%s%sMessage: %s%s';
  rsSelectAtLeas = 'Select at least one connection';
  rsSentTo = '%s Sent to %s > %s';
  rsYouCannotDoT = 'You cannot do this operation now:%s%s%s';
  rsLastComunica = ' - Last comunication <10 sec.';
  rsLastComunica2 = ' - Last comunication %.2dm%.2ds';
  rsClientIPSBlo = 'Client: IP:%s Block:%d Sent/Received:%d/%d Bytes - %s - '
    +'Time offset %d - Active since %s %s';
  rsMySelfIPSSen = 'MySelf IP:%s Sent/Received:%d/%d Bytes - %s - Time offset '
    +'%d - Active since %s %s';
  rsRestartAppli = 'Restart application?';
  rsYouNeedResta = 'You need restart Application to apply changes. Close '
    +'application?';

{ TThreadActivate }

procedure TThreadActivate.BCExecute;
begin
  // Read Operations saved from disk
  TNode.Node.Bank.DiskRestoreFromOperations(CT_MaxBlock);
  TNode.Node.AutoDiscoverNodes(CT_Discover_IPs);
  TNode.Node.NetServer.Active := true;
  Synchronize( FRMWallet.DoUpdateAccounts );
  Synchronize( FRMWallet.FinishedLoadingApp );
end;

{ TFRMWallet }

procedure TFRMWallet.PrivateKeysExecute(Sender: TObject);
begin
//
end;

procedure TFRMWallet.Activate;
Var ips : AnsiString;
  nsarr : TNodeServerAddressArray;
begin
  inherited;
  if FIsActivated then exit;
  FIsActivated := true;
  try
    // Check OpenSSL dll
    if not LoadSSLCrypt then raise Exception.Create(Format(rsCannotLoadTo, [
      SSL_C_LIB, #10]));
    TCrypto.InitCrypto;
    // Read Wallet
    Try
      FWalletKeys.WalletFileName := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'WalletKeys.dat';
    Except
      On E:Exception do begin
        E.Message := Format(rsCannotOpenYo, [#10, #10, E.Message]);
        Raise;
      end;
    End;
    ips := FAppParams.ParamByName[CT_PARAM_TryToConnectOnlyWithThisFixedServers].GetAsString('');
    TNode.DecodeIpStringToNodeServerAddressArray(ips,nsarr);
    TConnectionManager.NetData.DiscoverFixedServersOnly(nsarr);
    setlength(nsarr,0);
    // Creating Node:
    FNode := TNode.Node;
    FNode.NetServer.Port := FAppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
    FNode.PeerCache := FAppParams.ParamByName[CT_PARAM_PeerCache].GetAsString('')+';'+CT_Discover_IPs;
    // Create RPC server
    FRPCServer := TRPCServer.Instance;
    FRPCServer.WalletKeys := WalletKeys;
    FRPCServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1');
    WalletKeys.SafeBox := FNode.Bank.AccountStorage;
    // Check Database
    FNode.Bank.StorageClass := TFileStorage;
    TFileStorage(FNode.Bank.Storage).DatabaseFolder := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'Data';
    TFileStorage(FNode.Bank.Storage).Initialize;
    // Init Grid
    //FAccountsGrid.Node := FNode;
    FSelectedAccountsGrid.Node := FNode;
    FWalletKeys.OnChanged := OnWalletChanged;
    FAccountsGrid.Node := FNode;
    FOperationsAccountGrid.Node := FNode;
    // Reading database
    TThreadActivate.Create(false).FreeOnTerminate := true;
    FNodeNotifyEvents.Node := FNode;
    // Init
    TConnectionManager.NetData.OnReceivedHelloMessage := OnReceivedHelloMessage;
    TConnectionManager.NetData.OnStatisticsChanged := OnNetStatisticsChanged;
    TConnectionManager.NetData.OnNetConnectionsUpdated := onNetConnectionsUpdated;
    TConnectionManager.NetData.OnNodeServersUpdated := OnNetNodeServersUpdated;
    TConnectionManager.NetData.OnBlackListUpdated := OnNetBlackListUpdated;
    //
    TimerUpdateStatus.Interval := 1000;
    TimerUpdateStatus.Enabled := true;
    UpdateConfigChanged;
  Except
    On E:Exception do begin
      E.Message := Format(rsAnErrorOccur, [#10, #10, E.Message, #10, #10]);
      Application.MessageBox(PChar(E.Message),PChar(Application.Title),MB_ICONERROR+MB_OK);
      Halt;
    end;
  end;
  UpdatePrivateKeys;
  UpdateAccounts(false);
  if FAppParams.ParamByName[CT_PARAM_FirstTime].GetAsBoolean(true) then begin
    FAppParams.ParamByName[CT_PARAM_FirstTime].SetAsBoolean(false);
    miAboutMicroCoinClick(Nil);
  end;

end;

procedure TFRMWallet.ActoinMessageExecute(Sender: TObject);
begin
//
end;

procedure TFRMWallet.ApplicationEventsMinimize(Sender: TObject);
begin
  {$IFnDEF FPC}
  Hide();
  WindowState := wsMinimized;
  TimerUpdateStatus.Enabled := false;
  { Show the animated tray icon and also a hint balloon. }
  TrayIcon.Visible := True;
  TrayIcon.ShowBalloonHint;
  {$ENDIF}
end;

procedure TFRMWallet.bbAccountsRefreshClick(Sender: TObject);
begin
  UpdateAccounts(true);
end;

procedure TFRMWallet.bbChangeKeyNameClick(Sender: TObject);
var i : Integer;
  name : String;
begin
  if (cbMyPrivateKeys.ItemIndex<0) then  exit;
  i := PtrInt(cbMyPrivateKeys.Items.Objects[cbMyPrivateKeys.ItemIndex]);
  if (i<0) Or (i>=FWalletKeys.Count) then raise Exception.Create(rsMustSelectAK
    );
  name := FWalletKeys.Key[i].Name;
  if InputQuery(rsChangeKeyNam, rsInputNewName, name) then begin
    FWalletKeys.SetName(i,name);
  end;
  UpdatePrivateKeys;
end;

procedure TFRMWallet.bbSelectedAccountsOperationClick(Sender: TObject);
var l : TOrderedList;
begin
  CheckIsReady;
  if FSelectedAccountsGrid.AccountsCount<=0 then raise Exception.Create(
    rsMustSelectAt);
  With TFRMOperation.Create(Self) do
  Try
    l := FSelectedAccountsGrid.LockAccountsList;
    try
      SenderAccounts.CopyFrom(l);
    finally
      FSelectedAccountsGrid.UnlockAccountsList;
    end;
    DefaultFee := FAppParams.ParamByName[CT_PARAM_DefaultFee].GetAsInt64(0);
    WalletKeys := FWalletKeys;
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TFRMWallet.cbExploreMyAccountsClick(Sender: TObject);
begin
  cbMyPrivateKeys.Enabled := cbExploreMyAccounts.Checked;
  UpdateAccounts(true);
  UpdateOperations;
end;

procedure TFRMWallet.cbFilterAccountsClick(Sender: TObject);
begin
  If not DoUpdateAccountsFilter then UpdateAccounts(true);
end;

procedure TFRMWallet.cbMyPrivateKeysChange(Sender: TObject);
begin
  UpdateAccounts(true);
end;

procedure TFRMWallet.CheckIsReady;
Var isready : AnsiString;
begin
  if Not Assigned(FNode) then Abort;

  if Not FNode.IsReady(isready) then begin
    raise Exception.Create(Format(rsYouCannotDoT, [#10, #10, isready]));
  end;
end;

procedure TFRMWallet.CM_NetConnectionUpdated(var Msg: TMessage);
Const CT_BooleanToString : Array[Boolean] of String = ('False','True');
Var i : integer;
 NC : TNetConnection;
 l : TList;
 sClientApp, sLastConnTime : String;
 strings, sNSC, sRS, sDisc : TStrings;
 hh,nn,ss,ms : Word;
begin
  Try
    if Not TConnectionManager.NetData.NetConnections.TryLockList(100,l) then exit;
    try
      strings := memoNetConnections.Lines;
      sNSC := TStringList.Create;
      sRS := TStringList.Create;
      sDisc := TStringList.Create;
      strings.BeginUpdate;
      Try
        for i := 0 to l.Count - 1 do begin
          NC := l[i];
          If NC.Client.BytesReceived>0 then begin
            sClientApp := '['+IntToStr(NC.NetProtocolVersion.protocol_version)+'-'+IntToStr(NC.NetProtocolVersion.protocol_available)+'] '+NC.ClientAppVersion;
          end else begin
            sClientApp := '(no data)';
          end;

          if NC.Connected then begin
            if NC.Client.LastCommunicationTime>1000 then begin
              DecodeTime(now - NC.Client.LastCommunicationTime,hh,nn,ss,ms);
              if (hh=0) and (nn=0) And (ss<10) then begin
                sLastConnTime := rsLastComunica;
              end else begin
                sLastConnTime := Format(rsLastComunica2, [(hh*60)+nn, ss]);
              end;
            end else begin
              sLastConnTime := '';
            end;
            if NC is TNetServerClient then begin
              sNSC.Add(Format(rsClientIPSBlo,
                [NC.ClientRemoteAddr,NC.RemoteOperationBlock.block,NC.Client.BytesSent,NC.Client.BytesReceived,sClientApp,NC.TimestampDiff,DateTimeElapsedTime(NC.CreatedTime),sLastConnTime]));
            end else begin
              if NC.IsMyselfServer then sNSC.Add(Format(rsMySelfIPSSen,
                [NC.ClientRemoteAddr,NC.Client.BytesSent,NC.Client.BytesReceived,sClientApp,NC.TimestampDiff,DateTimeElapsedTime(NC.CreatedTime),sLastConnTime]))
              else begin
                sRS.Add(Format('Remote Server: IP:%s Block:%d Sent/Received:%d/%d Bytes - %s - Time offset %d - Active since %s %s',
                [NC.ClientRemoteAddr,NC.RemoteOperationBlock.block,NC.Client.BytesSent,NC.Client.BytesReceived,sClientApp,NC.TimestampDiff,DateTimeElapsedTime(NC.CreatedTime),sLastConnTime]));
              end;
            end;
          end else begin
            if NC is TNetServerClient then begin
              sDisc.Add(Format('Disconnected client: IP:%s - %s',[NC.ClientRemoteAddr,sClientApp]));
            end else if NC.IsMyselfServer then begin
              sDisc.Add(Format('Disconnected MySelf IP:%s - %s',[NC.ClientRemoteAddr,sClientApp]));
            end else begin
              sDisc.Add(Format('Disconnected Remote Server: IP:%s %s - %s',[NC.ClientRemoteAddr,CT_BooleanToString[NC.Connected],sClientApp]));
            end;
          end;
        end;
        strings.Clear;
        strings.Add(Format('Connections Updated %s Clients:%d Servers:%d (valid servers:%d)',[DateTimeToStr(now),sNSC.Count,sRS.Count,TConnectionManager.NetData.NetStatistics.ServersConnectionsWithResponse]));
        strings.AddStrings(sRS);
        strings.AddStrings(sNSC);
        if sDisc.Count>0 then begin
          strings.Add('');
          strings.Add('Disconnected connections: '+Inttostr(sDisc.Count));
          strings.AddStrings(sDisc);
        end;
      Finally
        strings.EndUpdate;
        sNSC.Free;
        sRS.Free;
        sDisc.Free;
      End;
      //CheckMining;
    finally
      TConnectionManager.NetData.NetConnections.UnlockList;
    end;
  Finally
    FMustProcessNetConnectionUpdated := false;
  End;
end;

procedure TFRMWallet.ConfirmRestart;
begin
 if MessageDlg(rsRestartAppli, {$ifdef fpc} rsYouNeedResta, {$endif} mtConfirmation, [mbYes, mbNo], {$ifdef fpc}''{$else}0{$endif}) = mrYes
 then Application.Terminate;
end;

procedure TFRMWallet.CM_WalletChanged(var Msg: TMessage);
begin
  UpdatePrivateKeys;
  FMustProcessWalletChanged := false;
end;

procedure TFRMWallet.dgAccountsClick(Sender: TObject);
begin
  UpdateOperations;
end;

procedure TFRMWallet.dgAccountsColumnMoved(Sender: TObject; FromIndex, ToIndex: Integer);
begin
  SaveAppParams;
end;

procedure TFRMWallet.dgAccountsFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  SaveAppParams;
end;

procedure TFRMWallet.DoUpdateAccounts;
begin
  UpdateAccounts(true);
end;

function TFRMWallet.DoUpdateAccountsFilter: Boolean;
Var m,bmin,bmax:Int64;
  doupd : Boolean;
begin
  if FUpdating then exit;
  FUpdating := true;
  Try
    if (bmax<bmin) or (bmax=0) then bmax := CT_MaxWalletAmount;
    if bmin>bmax then bmin := 0;
    doupd := (bmin<>FMinAccountBalance) Or (bmax<>FMaxAccountBalance);
    FMinAccountBalance := bmin;
    FMaxAccountBalance := bmax;
  Finally
    FUpdating := false;
  End;
  if doupd then UpdateAccounts(true);
  Result := doupd;
end;

procedure TFRMWallet.ebFilterAccountByBalanceMinExit(Sender: TObject);
begin
  DoUpdateAccountsFilter;
end;

procedure TFRMWallet.ebFilterAccountByBalanceMinKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then DoUpdateAccountsFilter;
end;

procedure TFRMWallet.FinishedLoadingApp;
begin
  FPoolMiningServer := TMiningServer.Create;
  FPoolMiningServer.Port := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].GetAsInteger(CT_JSONRPCMinerServer_Port);
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.MinerPayload := FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
  FNode.Operations.AccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].GetAsBoolean(true);
  FPoolMiningServer.OnMiningServerNewBlockFound := OnMiningServerNewBlockFound;
  If Assigned(FBackgroundPanel) then begin
    FreeAndNil(FBackgroundPanel);
  end;
  PageControl.Visible:=True;
  PageControl.Enabled:=True;
end;

procedure TFRMWallet.FillAccountInformation(const Strings: TStrings;
  const AccountNumber: Cardinal);
Var account : TAccount;
  s : String;
begin
  if AccountNumber<0 then exit;
  account := FNode.Operations.SafeBoxTransaction.Account(AccountNumber);
  if account.name<>'' then s:='Name: '+account.name
  else s:='';
  Strings.Add(Format('Account: %s %s Type:%d',[TAccount.AccountNumberToAccountTxtNumber(AccountNumber),s,account.account_type]));
  Strings.Add('');
  Strings.Add(Format('Current balance: %s',[TCurrencyUtils.FormatMoney(account.balance)]));
  Strings.Add('');
  Strings.Add(Format('Updated on block: %d  (%d blocks ago)',[account.updated_block,FNode.Bank.BlocksCount-account.updated_block]));
  Strings.Add(Format('Public key type: %s',[TAccountKey.GetECInfoTxt(account.accountInfo.accountKey.EC_OpenSSL_NID)]));
  Strings.Add(Format('Base58 Public key: %s',[(account.accountInfo.accountKey.AccountPublicKeyExport)]));
  if account.accountInfo.IsAccountForSale then begin
    Strings.Add('');
    Strings.Add('** Account is for sale: **');
    Strings.Add(Format('Price: %s',[TCurrencyUtils.FormatMoney(account.accountInfo.price)]));
    Strings.Add(Format('Seller account (where to pay): %s',[TAccount.AccountNumberToAccountTxtNumber(account.accountInfo.account_to_pay)]));
    if account.accountInfo.IsAccountForSaleAcceptingTransactions then begin
      Strings.Add('');
      Strings.Add('** Private sale **');
      Strings.Add(Format('New Base58 Public key: %s',[account.accountInfo.new_publicKey.AccountPublicKeyExport]));
      Strings.Add('');
      if account.accountInfo.IsLocked(FNode.Bank.BlocksCount) then begin
        Strings.Add(Format('PURCHASE IS SECURE UNTIL BLOCK %d (current %d, remains %d)',
          [account.accountInfo.locked_until_block,FNode.Bank.BlocksCount,account.accountInfo.locked_until_block-FNode.Bank.BlocksCount]));
      end else begin
        Strings.Add(Format('PURCHASE IS NOT SECURE (Expired on block %d, current %d)',
          [account.accountInfo.locked_until_block,FNode.Bank.BlocksCount]));
      end;
    end;
  end;
end;

procedure TFRMWallet.FillOperationInformation(const Strings: TStrings;
  const OperationResume: TTransactionData);
begin
  If (not OperationResume.valid) then exit;
  If OperationResume.Block<FNode.Bank.BlocksCount then
    if (OperationResume.NOpInsideBlock>=0) then begin
      Strings.Add(Format('Block: %d/%d',[OperationResume.Block,OperationResume.NOpInsideBlock]))
    end else begin
      Strings.Add(Format('Block: %d',[OperationResume.Block]))
    end
  else Strings.Add('** Pending operation not included on blockchain **');
  Strings.Add(Format('%s',[OperationResume.OperationTxt]));
  Strings.Add(Format('OpType:%d Subtype:%d',[OperationResume.OpType,OperationResume.OpSubtype]));
  Strings.Add(Format('Operation Hash (ophash): %s',[TCrypto.ToHexaString(OperationResume.OperationHash)]));
  If (OperationResume.OperationHash_OLD<>'') then begin
    Strings.Add(Format('Old Operation Hash (old_ophash): %s',[TCrypto.ToHexaString(OperationResume.OperationHash_OLD)]));
  end;
  if (OperationResume.OriginalPayload<>'') then begin
    Strings.Add(Format('Payload length:%d',[length(OperationResume.OriginalPayload)]));
    If OperationResume.PrintablePayload<>'' then begin
      Strings.Add(Format('Payload (human): %s',[OperationResume.PrintablePayload]));
    end;
    Strings.Add(Format('Payload (Hexadecimal): %s',[TCrypto.ToHexaString(OperationResume.OriginalPayload)]));
  end;
  If OperationResume.Balance>=0 then begin
    Strings.Add(Format('Final balance: %s',[TCurrencyUtils.FormatMoney(OperationResume.Balance)]));
  end;
end;

function TFRMWallet.ForceMining: Boolean;
begin
  Result := false;
end;

procedure TFRMWallet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Timer1.Enabled:=false
end;

procedure TFRMWallet.FormCreate(Sender: TObject);
Var i : Integer;
    page : integer;
begin
  TCrypto.InitCrypto;
  MainActions.Style := PlatformVclStylesStyle;
  FBackgroundPanel := Nil;
  FMustProcessWalletChanged := false;
  FMustProcessNetConnectionUpdated := false;
  FRPCServer := Nil;
  FNode := Nil;
  FPoolMiningServer := Nil;
  FMinAccountBalance := 0;
  FMaxAccountBalance := CT_MaxWalletAmount;
  FMessagesUnreadCount := 0;
  // lblReceivedMessages.Visible := false;
  memoNetConnections.Lines.Clear;
  memoNetServers.Lines.Clear;
  memoNetBlackLists.Lines.Clear;
  FUpdating := false;
  FOrderedAccountsKeyList := Nil;
  TimerUpdateStatus.Enabled := false;
  FIsActivated := false;
  FWalletKeys := TWalletKeysExt.Create(Self);
  for i := 0 to StatusBar.Panels.Count - 1 do begin
    StatusBar.Panels[i].Text := '';
  end;
  FLog := TLog.Create(Self);
  FLog.OnNewLog := OnNewLog;
  FLog.SaveTypes := [];
  If Not ForceDirectories(TFolderHelper.GetMicroCoinDataFolder) then raise Exception.Create('Cannot create dir: '+TFolderHelper.GetMicroCoinDataFolder);
  FAppParams := TAppParams.Create(self);
  FAppParams.FileName := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'AppParams.prm';
  FNodeNotifyEvents := TNodeNotifyEvents.Create(Self);
  FNodeNotifyEvents.OnBlocksChanged := OnNewAccount;
  FNodeNotifyEvents.OnNodeMessageEvent := OnNodeMessageEvent;
//  FNodeNotifyEvents.OnOperationsChanged:= OnOperationsChanged;
  FAccountsGrid := TAccountsGrid.Create(Self);
  FAccountsGrid.DrawGrid := dgAccounts;
  FAccountsGrid.AllowMultiSelect := True;
  FSelectedAccountsGrid := TAccountsGrid.Create(Self);
  FSelectedAccountsGrid.DrawGrid := dgSelectedAccounts;
  FSelectedAccountsGrid.OnUpdated := OnSelectedAccountsGridUpdated;
  FOperationsAccountGrid := TOperationsGrid.Create(Self);
  FOperationsAccountGrid.DrawGrid := dgAccountOperations;
  FOperationsAccountGrid.MustShowAlwaysAnAccount := true;
  FWalletKeys.OnChanged := OnWalletChanged;
  LoadAppParams;
  UpdatePrivateKeys;
  UpdateBlockChainState;
  UpdateConnectionStatus;
  PageControl.ActivePage := TabSheet1;
  cbExploreMyAccountsClick(nil);

  TrayIcon.Visible := true;
  TrayIcon.Hint := Self.Caption;
  TrayIcon.BalloonTitle := 'Restoring the window.';
  TrayIcon.BalloonHint :=
    'Double click the system tray icon to restore Micro Coin';
  TrayIcon.BalloonFlags := bfInfo;
  MinersBlocksFound := 0;

  {$IFDEF TESTNET}
  Image1.visible := true;
  Label1.Caption:='TESTNET';
  {$ENDIF}
  PageControl.Enabled := False;
  PageControl.Visible := False;
  FBackgroundPanel := TPanel.Create(Self);
  FBackgroundPanel.Parent:=Self;
  FBackgroundPanel.Align:=alClient;
  FBackgroundPanel.BorderStyle := bsNone;
  FBackgroundPanel.BevelKind := bkNone;
  FBackgroundPanel.BevelInner := bvNone;
  FBackgroundPanel.BevelOuter := bvNone;
  FBackgroundPanel.BorderWidth:=0;
  FBackgroundPanel.Font.Size:=15;
{$ifndef fpc}
  for page := 0 to PageControl.PageCount - 1 do
  begin
    PageControl.Pages[page].TabVisible:=false;
  end;
  PageControl.ActivePageIndex := 0;
{$endif}
end;

function TFRMWallet.ChangeAccountKey(account_signer, account_target: Cardinal;
  const new_pub_key: TAccountKey; fee: UInt64; const RawPayload: TRawBytes;
  const Payload_method, EncodePwd: AnsiString): Boolean;

Function CreateOperationChangeKey(account_signer, account_last_n_operation, account_target : Cardinal; const account_pubkey, new_pubkey : TAccountKey; fee : UInt64; RawPayload : TRawBytes; Const Payload_method, EncodePwd : AnsiString) : TChangeKeyTransaction;
// "payload_method" types: "none","dest"(default),"sender","aes"(must provide "pwd" param)
var i : Integer;
  errors : AnsiString;
  f_raw : TRawBytes;
Begin
  Result := Nil;
  i := FWalletKeys.IndexOfAccountKey(account_pubkey);
  if (i<0) then begin
     {
    ErrorDesc:='Private key not found in wallet: '+TAccountComp.AccountPublicKeyExport(account_pubkey);
    ErrorNum:=CT_RPC_ErrNum_InvalidPubKey;
    }
    Exit;

  end;
  if (Not assigned(FWalletKeys.Key[i].PrivateKey)) then begin
    if FWalletKeys.Key[i].CryptedKey<>'' then begin
      {
      // Wallet is password protected
      ErrorDesc := 'Wallet is password protected';
      ErrorNum := CT_RPC_ErrNum_WalletPasswordProtected;
      }
    end else begin
{      ErrorDesc := 'Wallet private key not found in Wallet';
      ErrorNum := CT_RPC_ErrNum_InvalidAccount;
      }
    end;
    exit;
  end;
  if (length(RawPayload)>0) then begin
    if (Payload_method='none') then f_raw:=RawPayload
    else if (Payload_method='dest') then begin
      f_raw := ECIESEncrypt(new_pubkey,RawPayload);
    end else if (Payload_method='sender') then begin
      f_raw := ECIESEncrypt(account_pubkey,RawPayload);
//    end else if (Payload_method='aes') then begin
//      f_raw := TAESComp.EVP_Encrypt_AES256(RawPayload,EncodePwd);
    end else begin
  //    ErrorNum:=CT_RPC_ErrNum_InvalidOperation;
  //    ErrorDesc:='Invalid encode payload method: '+Payload_method;
      exit;
    end;
  end else f_raw := '';
  If account_signer=account_target then begin
    Result := TChangeKeyTransaction.Create(account_signer,account_last_n_operation+1,account_target,FWalletKeys.Key[i].PrivateKey,new_pubkey,fee,f_raw);
  end else begin
    Result := TChangeKeySignedTransaction.Create(account_signer,account_last_n_operation+1,account_target,FWalletKeys.Key[i].PrivateKey,new_pubkey,fee,f_raw);
  end;
  if Not Result.HasValidSignature then begin
    FreeAndNil(Result);
//    ErrorNum:=CT_RPC_ErrNum_InternalError;
//    ErrorDesc:='Invalid signature';
    exit;
  end;
End;

  Var opck : TChangeKeyTransaction;
    acc_signer : TAccount;
    errors : AnsiString;
    opr : TTransactionData;
  begin
    FNode.OperationSequenceLock.Acquire;  // Use lock to prevent N_Operation race-condition on concurrent invocations
    try
      Result := false;
      if (account_signer<0) or (account_signer>=FNode.Bank.AccountsCount) then begin
        {
        ErrorDesc:='Invalid account '+Inttostr(account_signer);
        ErrorNum:=CT_RPC_ErrNum_InvalidAccount;
        Exit;
        }
      end;
      acc_signer := FNode.Operations.SafeBoxTransaction.Account(account_signer);

      opck := CreateOperationChangeKey(account_signer,acc_signer.n_operation,account_target,acc_signer.accountInfo.accountKey,new_pub_key,fee,RawPayload,Payload_method,EncodePwd);
      if not assigned(opck) then exit;
      try
        If not FNode.AddOperation(Nil,opck,errors) then begin
         { ErrorDesc := 'Error adding operation: '+errors;
          ErrorNum := CT_RPC_ErrNum_InvalidOperation;
          Exit;
          }
        end;
        opck.GetTransactionData(0,account_signer,opr);
      //  FillOperationResumeToJSONObject(opr,GetResultObject);
        Result := true;
      finally
        opck.free;
      end;
    finally
      FNode.OperationSequenceLock.Release;
    end;
  end;

procedure TFRMWallet.bbRequestMoneyClick(Sender: TObject);
var
   an : Cardinal;
   accnumber : String;
begin
  an := FAccountsGrid.AccountNumber(dgAccounts.Row);
  if (an<0) then raise Exception.Create(rsNoAccountSel);
  if FWalletKeys.IndexOfAccountKey(FNode.Bank.AccountStorage.Account(an).accountInfo.accountkey)<0 then
    raise Exception.Create(Format(rsYouCannotAdd, [
      TAccount.AccountNumberToAccountTxtNumber(an),#10, #10]));
  accnumber := TAccount.AccountNumberToAccountTxtNumber(an);

end;

procedure TFRMWallet.bbMineCoinsClick(Sender: TObject);
begin
  FrmMineCoins := TFrmMineCoins.Create(self);
  FrmMineCoins.Show;
end;

procedure TFRMWallet.dgAccountOperationsDblClick(Sender: TObject);
begin
    FOperationsAccountGrid.ShowModalDecoder(FWalletKeys,FAppParams);
end;

procedure TFRMWallet.FormDestroy(Sender: TObject);
Var i : Integer;
  step : String;
begin
  Self.Hide;
  Application.ProcessMessages;
  TLog.NewLog(ltinfo,Classname,'Destroying form - START');
  Try
  FreeAndNil(FRPCServer);
  FreeAndNil(FPoolMiningServer);
  step := 'Saving params';
  SaveAppParams;
  FreeAndNil(FAppParams);
  //
  step := 'Assigning nil events';
  FLog.OnNewLog :=Nil;
//  FNodeNotifyEvents.Node := Nil;
//  FOperationsAccountGrid.Node := Nil;
//  FPendingOperationsGrid.Node := Nil;
//  FAccountsGrid.Node := Nil;
//  FSelectedAccountsGrid.Node := Nil;
  TConnectionManager.NetData.OnReceivedHelloMessage := Nil;
  TConnectionManager.NetData.OnStatisticsChanged := Nil;
  TConnectionManager.NetData.OnNetConnectionsUpdated := Nil;
  TConnectionManager.NetData.OnNodeServersUpdated := Nil;
  TConnectionManager.NetData.OnBlackListUpdated := Nil;
  //

  step := 'Destroying NodeNotifyEvents';
  FreeAndNil(FNodeNotifyEvents);
  //
  step := 'Assigning Nil to TNetData';
  TConnectionManager.NetData.OnReceivedHelloMessage := Nil;
  TConnectionManager.NetData.OnStatisticsChanged := Nil;

  step := 'Destroying grids operators';
  FreeAndNil(FOperationsAccountGrid);

  step := 'Ordered Accounts Key list';
  FreeAndNil(FOrderedAccountsKeyList);

  step := 'Desactivating Node';
//  TNode.Node.NetServer.Active := false;
  FNode := Nil;

  TConnectionManager.NetData.Free;

  step := 'Processing messages 1';
  Application.ProcessMessages;

  step := 'Destroying Node';
  TNode.Node.Free;

  step := 'Destroying Wallet';
  FreeAndNil(FWalletKeys);
  step := 'Processing messages 2';
  Application.ProcessMessages;
  step := 'Destroying stringslist';
  Except
    On E:Exception do begin
      TLog.NewLog(lterror,Classname,'Error destroying Form step: '+step+' Errors ('+E.ClassName+'): ' +E.Message);
    end;
  End;
  TLog.NewLog(ltinfo,Classname,'Destroying form - END');
  FreeAndNil(FLog);
  Sleep(100);
end;

procedure TFRMWallet.MenuItem13Click(Sender: TObject);
begin
  with TIniFile.Create('MicroCoinWallet.ini') do
  begin
    WriteString('Localize', 'language','hu');
    Free;
  end;
  {$ifdef fpc}
  SetDefaultLang('hu');
  {$endif}
  ConfirmRestart;
end;

procedure TFRMWallet.MenuItem4Click(Sender: TObject);
begin
  TBlockExplorerForm.Create(self, FNode).Show;
end;

procedure TFRMWallet.MenuItem5Click(Sender: TObject);
begin
    PageControlChange(Sender);
end;

procedure TFRMWallet.MenuItem8Click(Sender: TObject);
begin
  PageControl.ActivePage := TabSheet1;
  PageControlChange(Sender);
end;

procedure TFRMWallet.mmEnglishClick(Sender: TObject);
begin
  with TIniFile.Create('MicroCoinWallet.ini') do
  begin
    WriteString('Localize', 'language','en');
    Free;
  end;
  {$ifdef fpc}
  SetDefaultLang('en');
  {$endif}
  ConfirmRestart;
end;

procedure TFRMWallet.sbSearchAccountClick(Sender: TObject);
Var F : TFRMAccountSelect;
begin
  F := TFRMAccountSelect.Create(Self);
  try
    F.Node := FNode;
    F.WalletKeys := FWalletKeys;
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TFRMWallet.Timer1Timer(Sender: TObject);
begin
  UpdateAccounts(true);
  UpdateOperations;
end;

function TFRMWallet.GetAccountKeyForMiner: TAccountKey;
Var PK : TECPrivateKey;
  i : Integer;
  PublicK : TECDSA_Public;
begin
  Result := CT_TECDSA_Public_Nul;
  if Not Assigned(FWalletKeys) then exit;
  if Not Assigned(FAppParams) then exit;
  case FMinerPrivateKeyType of
    mpk_NewEachTime: PublicK := CT_TECDSA_Public_Nul;
    mpk_Selected: begin
      PublicK := TAccountKey.FromRawString(FAppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey].GetAsString(''));
    end;
  else
    // Random
    PublicK := CT_TECDSA_Public_Nul;
    if FWalletKeys.Count>0 then PublicK := FWalletKeys.Key[Random(FWalletKeys.Count)].AccountKey;
  end;
  i := FWalletKeys.IndexOfAccountKey(PublicK);
  if i>=0 then begin
    if (FWalletKeys.Key[i].CryptedKey='') then i:=-1;
  end;
  if i<0 then begin
    PK := TECPrivateKey.Create;
    try
      PK.GenerateRandomPrivateKey(CT_Default_EC_OpenSSL_NID);
      FWalletKeys.AddPrivateKey('New for miner '+DateTimeToStr(Now), PK);
      PublicK := PK.PublicKey;
    finally
      PK.Free;
    end;
  end;
  Result := PublicK;
end;

procedure TFRMWallet.IPnodes1Click(Sender: TObject);
Var FRM : TFRMNodesIp;
begin
  FRM := TFRMNodesIp.Create(Self);
  Try
    FRM.AppParams := FAppParams;
    FRM.ShowModal;
  Finally
    FRM.Free;
  End;
end;

procedure TFRMWallet.LoadAppParams;
Var ms : TMemoryStream;
  s : AnsiString;
  fvi : TFileVersionInfo;
begin
  ms := TMemoryStream.Create;
  Try
    s := FAppParams.ParamByName[CT_PARAM_GridAccountsStream].GetAsString('');
    ms.WriteBuffer(s[1],length(s));
    ms.Position := 0;
    // Disabled on V2: FAccountsGrid.LoadFromStream(ms);
  Finally
    ms.Free;
  End;
  If FAppParams.FindParam(CT_PARAM_MinerName)=Nil then begin
    // New configuration... assigning a new random value
    fvi := TFolderHelper.GetTFileVersionInfo(Application.ExeName);
    FAppParams.ParamByName[CT_PARAM_MinerName].SetAsString(Format(
      rsNewNodeBuild, [DateTimeToStr(Now), fvi.InternalName, fvi.FileVersion]));
  end;
  UpdateConfigChanged;
end;

procedure TFRMWallet.miAboutMicroCoinClick(Sender: TObject);
begin
  With TFRMAbout.Create(Self) do
  try
    showmodal;
  finally
    free;
  end;
end;

procedure TFRMWallet.MiAccountInformationClick(Sender: TObject);
Var F : TFRMMemoText;
  accn : Int64;
  s,title : String;
  account : TAccount;
  strings : TStrings;
  i : Integer;
  opr : TTransactionData;
begin
  accn := -1;
  title := '';
  strings := TStringList.Create;
  try
    opr := TTransactionData.Empty;
    if PageControl.ActivePage=TabSheet1 then begin
      accn := FAccountsGrid.AccountNumber(dgAccounts.Row);
      if accn<0 then raise Exception.Create(rsSelectAnAcco);
      FillAccountInformation(strings,accn);
      title := Format(rsAccountInfo, [
        TAccount.AccountNumberToAccountTxtNumber(accn)]);
      i := FOperationsAccountGrid.DrawGrid.Row;
      if (i>0) and (i<=FOperationsAccountGrid.OperationsResume.Count) then begin
        opr := FOperationsAccountGrid.OperationsResume.TransactionData[i-1];
      end;
    end;
    If (opr.valid) then begin
      if accn>=0 then strings.Add('')
      else title := rsOperationInf2;
      strings.Add(rsOperationInf);
      FillOperationInformation(strings,opr);
    end else if accn<0 then raise Exception.Create(rsNoInfoAvaila);
    F := TFRMMemoText.Create(Self);
    Try
      F.Caption := title;
      F.Memo.Lines.Assign(strings);
      F.ShowModal;
    Finally
      F.Free;
    End;
  finally
    strings.free;
  end;
end;

procedure TFRMWallet.MiCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFRMWallet.MiFindOperationbyOpHashClick(Sender: TObject);
Var FRM : TFRMPayloadDecoder;
  oph : String;
begin
  oph := '';
  if not InputQuery(rsSearchOperat, rsInsertOperat, oph
    ) then exit;
  //
  FRM := TFRMPayloadDecoder.Create(Self);
  try
    FRM.Init(TTransactionData.Empty,WalletKeys,FAppParams);
    FRM.DoFind(oph);
    FRM.ShowModal;
  finally
    FRM.Free;
  end;
end;

procedure TFRMWallet.miNewOperationClick(Sender: TObject);
var l : TOrderedList;
begin
  CheckIsReady;
  With TFRMOperation.Create(Self) do
  Try
    l := TOrderedList.Create;
    try
      if FAccountsGrid.SelectedAccounts(l)<1 then raise Exception.Create(
        rsNoRowSelecte);
      SenderAccounts.CopyFrom(l);
    finally
      l.Free;
    end;
    DefaultFee := FAppParams.ParamByName[CT_PARAM_DefaultFee].GetAsInt64(0);
    WalletKeys := FWalletKeys;
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TFRMWallet.miOptionsClick(Sender: TObject);
begin
  With TFRMMicroCoinWalletConfig.Create(Self) do
  try
    AppParams := Self.FAppParams;
    WalletKeys := Self.FWalletKeys;
    if ShowModal=MrOk then begin
      SaveAppParams;
      UpdateConfigChanged;
    end;
  finally
    free;
  end;
end;

procedure TFRMWallet.miPrivatekeysClick(Sender: TObject);
Var FRM : TFRMWalletKeys;
begin
  FRM := TFRMWalletKeys.Create(Self);
  Try
    FRM.WalletKeys := FWalletKeys;
    FRM.ShowModal;
    UpdatePrivateKeys;
  Finally
    FRM.Free;
  End;
end;

procedure TFRMWallet.OnMiningServerNewBlockFound(Sender: TObject);
begin
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
end;

procedure TFRMWallet.OnNetBlackListUpdated(Sender: TObject);
Const CT_TRUE_FALSE : Array[Boolean] Of AnsiString = ('FALSE','TRUE');
Var i,j,n : integer;
 P : PNodeServerAddress;
 l : TList;
 strings : TStrings;
begin
  l := TConnectionManager.NetData.NodeServersAddresses.LockList;
  try
    strings := memoNetBlackLists.Lines;
    strings.BeginUpdate;
    Try
      strings.Clear;
      strings.Add(Format(rsBlackListUpd, [DateTimeToStr(now), IntToHex(
        TThread.CurrentThread.ThreadID, 8)]));
      j := 0; n:=0;
      for i := 0 to l.Count - 1 do begin
        P := l[i];
        if (P^.is_blacklisted) then begin
          inc(n);
          if Not P^.its_myself then begin
            inc(j);
            strings.Add(Format(rsBlacklistIPS,
              [
               P^.ip,P^.port,
               DateTimeToStr(UnivDateTime2LocalDateTime( UnixToUnivDateTime(P^.last_connection))),P^.BlackListText]));
          end;
        end;
      end;
      Strings.Add(Format(rsTotalBlackli, [j, n]));
    Finally
      strings.EndUpdate;
    End;
  finally
    TConnectionManager.NetData.NodeServersAddresses.UnlockList;
  end;
end;

procedure TFRMWallet.OnNetConnectionsUpdated(Sender: TObject);
begin
  if FMustProcessNetConnectionUpdated then exit;
  FMustProcessNetConnectionUpdated := true;
  PostMessage(Self.Handle,CM_PC_NetConnectionUpdated,0,0);
end;

procedure TFRMWallet.OnNetNodeServersUpdated(Sender: TObject);
Var i : integer;
 P : PNodeServerAddress;
 l : TList;
 strings : TStrings;
 s : String;
begin
  l := TConnectionManager.NetData.NodeServersAddresses.LockList;
  try
    strings := memoNetServers.Lines;
    strings.BeginUpdate;
    Try
      strings.Clear;
      strings.Add(Format(rsNodeServersU, [DateTimeToStr(now), inttostr(l.Count)]
        ));
      for i := 0 to l.Count - 1 do begin
        P := l[i];
        if Not (P^.is_blacklisted) then begin
          s := Format(rsServerIPSD, [P^.ip, P^.port]);
          if Assigned(P.netConnection) then begin
            if P.last_connection>0 then  s := Format(rsACTIVE, [s])
            else s := Format(rsTRYINGTOCONN, [s]);
          end;
          if P.its_myself then begin
            s := Format(rsNOTVALID, [s, P.BlackListText]);
          end;
          if P.last_connection>0 then begin
            s := Format(rsLastConnecti, [s, DateTimeToStr(
              UnivDateTime2LocalDateTime( UnixToUnivDateTime(P^.last_connection)
              ))]);
          end;
          if P.last_connection_by_server>0 then begin
            s := Format(rsLastServerCo, [s, DateTimeToStr(
              UnivDateTime2LocalDateTime( UnixToUnivDateTime(P
              ^.last_connection_by_server)))]);
          end;
          if (P.last_attempt_to_connect>0) then begin
            s := Format(rsLastAttemptT, [s, DateTimeToStr(P
              ^.last_attempt_to_connect)]);
          end;
          if (P.total_failed_attemps_to_connect>0) then begin
            s := Format(rsAttempts, [s, inttostr(P
              ^.total_failed_attemps_to_connect)]);
          end;

          strings.Add(s);
        end;
      end;
    Finally
      strings.EndUpdate;
    End;
  finally
    TConnectionManager.NetData.NodeServersAddresses.UnlockList;
  end;
end;

procedure TFRMWallet.OnNetStatisticsChanged(Sender: TObject);
Var NS : TNetStatistics;
begin
  //CheckMining;
  if Assigned(FNode) then begin
    If FNode.NetServer.Active then begin
      StatusBar.Panels[0].Text := 'Active';
    end else StatusBar.Panels[0].Text := rsServerStoppe;
    NS := TConnectionManager.NetData.NetStatistics;
    StatusBar.Panels[1].Text := Format(rsConnectionsD,
      [NS.ActiveConnections,NS.ClientsConnections,NS.ServersConnections,NS.BytesReceived DIV 1024,NS.BytesSend DIV 1024]);
  end else begin
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
  end;
end;

procedure TFRMWallet.OnNewAccount(Sender: TObject);
begin
  Try
    UpdateAccounts(false);
    UpdateBlockChainState;
  Except
    On E:Exception do begin
      E.Message := 'Error at OnNewAccount '+E.Message;
      Raise;
    end;
  end;
end;

procedure TFRMWallet.OnNewLog(logtype: TLogType; Time : TDateTime; ThreadID : Cardinal; const sender,logtext: AnsiString);
Var s : AnsiString;
begin
//  if (logtype=ltdebug) And (Not cbShowDebugLogs.Checked) then exit;
  if ThreadID=MainThreadID then s := ' MAIN:' else s:=' TID:';
  if logDisplay.Lines.Count>300 then begin
    logDisplay.Lines.BeginUpdate;
    try
      while logDisplay.Lines.Count>250 do logDisplay.Lines.Delete(0);
    finally
      logDisplay.Lines.EndUpdate;
    end;
  end;
  case logtype of
    ltinfo: logDisplay.SelAttributes.Color:=clWindowText;
    ltdebug: logDisplay.SelAttributes.Color:=clGray;
    ltupdate: logDisplay.SelAttributes.Color:=clGreen;
    lterror:  logDisplay.SelAttributes.Color:=clRed;
  end;
  logDisplay.Lines.Add(formatDateTime(FormatSettings.ShortDateFormat+' '+FormatSettings.LongTimeFormat, Time){+s+IntToHex(ThreadID,
    8)}+' ['+CT_LogType[Logtype]+'] '+{ <'+sender+'> '+}logtext);
  if logPanel.Visible and (PageControl2.ActivePageIndex=0 )and Visible then logDisplay.SetFocus;
  logDisplay.SelStart := logDisplay.GetTextLen;
  logDisplay.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TFRMWallet.OnNodeMessageEvent(NetConnection: TNetConnection; MessageData: TRawBytes);
Var s : String;
begin
  inc(FMessagesUnreadCount);
  if Assigned(NetConnection) then begin
    s := Format(rsMessageRecei, [DateTimeToStr(now),
      NetConnection.ClientRemoteAddr]);
    MessagesFrame1.memoMessages.Lines.Add(Format(rsMessageRecei2, [DateTimeToStr(now),
      NetConnection.ClientRemoteAddr, inttostr(Length(MessageData))]));
    MessagesFrame1.memoMessages.Lines.Add(Format(rsRECEIVED, [MessageData]));
    if FAppParams.ParamByName[CT_PARAM_ShowModalMessages].GetAsBoolean(false) then begin
      s := Format(rsMessageFromL, [DateTimeToStr(now),
        NetConnection.ClientRemoteAddr, #10, inttostr(length(MessageData)),
        #10, #10]);
      if TCrypto.IsHumanReadable(MessageData) then begin
         s := s + MessageData;
      end else begin
         s := Format(rsValueInHexad, [s, #10, TCrypto.ToHexaString(MessageData)]
           );
      end;
      Application.MessageBox(PChar(s),PChar(Application.Title),MB_ICONINFORMATION+MB_OK);
    end;
  end else begin
    MessagesFrame1.memoMessages.Lines.Add(Format(rsInternalMess, [DateTimeToStr(now),
      MessageData]));
  end;
//  if FMessagesUnreadCount>1;
  { lblReceivedMessages.Caption := Format(rsYouHaveRecei, [FMessagesUnreadCount])
  else lblReceivedMessages.Caption := rsYouHaveRecei2;
  lblReceivedMessages.Visible := true; }
end;

procedure TFRMWallet.OnReceivedHelloMessage(Sender: TObject);
Var nsarr : TNodeServerAddressArray;
  i : Integer;
  s : AnsiString;
begin
  //CheckMining;
  // Update node servers Peer Cache
  nsarr := TConnectionManager.NetData.GetValidNodeServers(true,0);
  s := '';
  for i := low(nsarr) to High(nsarr) do begin
    if (s<>'') then s := s+';';
    s := s + nsarr[i].ip+':'+IntToStr( nsarr[i].port );
  end;
  FAppParams.ParamByName[CT_PARAM_PeerCache].SetAsString(s);
  TNode.Node.PeerCache := s;
end;

procedure TFRMWallet.OnSelectedAccountsGridUpdated(Sender: TObject);
begin
end;

procedure TFRMWallet.OnWalletChanged(Sender: TObject);
begin
  if FMustProcessWalletChanged then exit;
  FMustProcessWalletChanged := true;
  PostMessage(Self.Handle,CM_PC_WalletKeysChanged,0,0);
end;

procedure TFRMWallet.OperationsExecute(Sender: TObject);
begin
  TTransactionHistory.Create(self, FNode, FWalletKeys, FAppParams).Show;
end;

procedure TFRMWallet.PageControlChange(Sender: TObject);
begin
  MiDecodePayload.Enabled := false;
end;

procedure TFRMWallet.PendingOperationsExecute(Sender: TObject);
begin
  TPendingTransactionsForm.Create(self, FNode).Show;
end;

procedure TFRMWallet.SaveAppParams;
Var ms : TMemoryStream;
  s : AnsiString;
begin
  ms := TMemoryStream.Create;
  Try
    FAccountsGrid.SaveToStream(ms);
    ms.Position := 0;
    setlength(s,ms.Size);
    ms.ReadBuffer(s[1],ms.Size);
    FAppParams.ParamByName[CT_PARAM_GridAccountsStream].SetAsString(s);
  Finally
    ms.Free;
  End;
end;

procedure TFRMWallet.sbSelectedAccountsAddAllClick(Sender: TObject);
Var lsource,ltarget : TOrderedList;
  i : Integer;
begin
  lsource := FAccountsGrid.LockAccountsList;
  Try
    ltarget := FSelectedAccountsGrid.LockAccountsList;
    Try
      for i := 0 to lsource.Count-1 do begin
        if FWalletKeys.IndexOfAccountKey(FNode.Bank.AccountStorage.Account(lsource.Get(i)).accountInfo.accountKey)<0 then raise Exception.Create(Format('You cannot operate with account %d because private key not found in your wallet',[lsource.Get(i)]));
        ltarget.Add(lsource.Get(i));
      end;
    Finally
      FSelectedAccountsGrid.UnlockAccountsList;
    End;
  Finally
    FAccountsGrid.UnlockAccountsList;
  End;
end;

procedure TFRMWallet.sbSelectedAccountsAddClick(Sender: TObject);
Var l, selected : TOrderedList;
  an : Int64;
  i : Integer;
begin
  an := FAccountsGrid.AccountNumber(dgAccounts.Row);
  if (an<0) then raise Exception.Create(rsNoAccountSel);
  if FWalletKeys.IndexOfAccountKey(FNode.Bank.AccountStorage.Account(an).accountInfo.accountkey)<0 then
    raise Exception.Create(Format(rsYouCannotAdd, [
      TAccount.AccountNumberToAccountTxtNumber(an),#10, #10]));
  // Add
  l := FSelectedAccountsGrid.LockAccountsList;
  selected := TOrderedList.Create;
  Try
    FAccountsGrid.SelectedAccounts(selected);
    for i := 0 to selected.Count-1 do begin
      l.Add(selected.Get(i));
    end;
  Finally
    selected.Free;
    FSelectedAccountsGrid.UnlockAccountsList;
  End;
end;

procedure TFRMWallet.sbSelectedAccountsDelAllClick(Sender: TObject);
Var l : TOrderedList;
begin
  l := FSelectedAccountsGrid.LockAccountsList;
  try
    l.Clear;
  finally
    FSelectedAccountsGrid.UnlockAccountsList;
  end;
end;

procedure TFRMWallet.sbSelectedAccountsDelClick(Sender: TObject);
Var an : Int64;
  l : TOrderedList;
begin
  l := FSelectedAccountsGrid.LockAccountsList;
  try
    an := FSelectedAccountsGrid.AccountNumber(dgSelectedAccounts.Row);
    if an>=0 then l.Remove(an);
  finally
    FSelectedAccountsGrid.UnlockAccountsList;
  end;
end;

procedure TFRMWallet.SetMinersBlocksFound(const Value: Integer);
begin
  FMinersBlocksFound := Value;
  lblBlocksFound.Caption := Inttostr(Value);
  if Value>0 then lblBlocksFound.Font.Color := clGreen
  else lblBlocksFound.Font.Color := clDkGray;
end;

procedure TFRMWallet.ShowLogActionExecute(Sender: TObject);
begin
  logPanel.Visible := not logPanel.Visible;
  Splitter1.Top := logPanel.Top;
end;

procedure TFRMWallet.TimerUpdateStatusTimer(Sender: TObject);
begin
  Try
    UpdateConnectionStatus;
    UpdateBlockChainState;
    UpdateNodeStatus;
  Except
    On E:Exception do begin
      E.Message := Format(rsExceptionAtT, [E.ClassName, E.Message]);
      TLog.NewLog(lterror,ClassName,E.Message);
    end;
  End;
end;

procedure TFRMWallet.TrayIconDblClick(Sender: TObject);
begin
  TrayIcon.Visible := False;
  TimerUpdateStatus.Enabled := true;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TFRMWallet.UpdateAccounts(RefreshData : Boolean);
Var accl : TOrderedList;
  l : TOrderedList;
  i,j,k : Integer;
  c  : Cardinal;
  applyfilter : Boolean;
  acc : TAccount;
begin
  If Not Assigned(FOrderedAccountsKeyList) Then exit;
  if Not RefreshData then begin
    dgAccounts.Invalidate;
    exit;
  end;
  applyfilter := ((FMinAccountBalance>0) Or (FMaxAccountBalance<CT_MaxWalletAmount));
  FAccountsGrid.ShowAllAccounts := (Not cbExploreMyAccounts.Checked) And (not applyfilter);
  if Not FAccountsGrid.ShowAllAccounts then begin
    accl := FAccountsGrid.LockAccountsList;
    Try
      accl.Clear;
      if cbExploreMyAccounts.Checked then begin
        if cbMyPrivateKeys.ItemIndex<0 then exit;
        if cbMyPrivateKeys.ItemIndex=0 then begin
          // All keys in the wallet
          for i := 0 to FWalletKeys.Count - 1 do begin
            j := FOrderedAccountsKeyList.IndexOfAccountKey(FWalletKeys[i].AccountKey);
            if (j>=0) then begin
              l := FOrderedAccountsKeyList.AccountKeyList[j];
              for k := 0 to l.Count - 1 do begin
                if applyfilter then begin
                  acc := FNode.Bank.AccountStorage.Account(l.Get(k));
                  if (acc.balance>=FMinAccountBalance) And (acc.balance<=FMaxAccountBalance) then accl.Add(acc.account);
                end else accl.Add(l.Get(k));
              end;
            end;
          end;
        end else begin
          i := PtrInt(cbMyPrivateKeys.Items.Objects[cbMyPrivateKeys.ItemIndex]);
          if (i>=0) And (i<FWalletKeys.Count) then begin
            j := FOrderedAccountsKeyList.IndexOfAccountKey(FWalletKeys[i].AccountKey);
            if (j>=0) then begin
              l := FOrderedAccountsKeyList.AccountKeyList[j];
              for k := 0 to l.Count - 1 do begin
                if applyfilter then begin
                  acc := FNode.Bank.AccountStorage.Account(l.Get(k));
                  if (acc.balance>=FMinAccountBalance) And (acc.balance<=FMaxAccountBalance) then accl.Add(acc.account);
                end else accl.Add(l.Get(k));
              end;
            end;
          end;
        end;
      end else begin
        // There is a filter... check every account...
        c := 0;
        while (c<FNode.Bank.AccountStorage.AccountsCount) do begin
          acc := FNode.Bank.AccountStorage.Account(c);
          if (acc.balance>=FMinAccountBalance) And (acc.balance<=FMaxAccountBalance) then accl.Add(acc.account);
          inc(c);
        end;
      end;
    Finally
      FAccountsGrid.UnlockAccountsList;
    End;
    lblAccountsCount.Caption := inttostr(accl.Count);
  end else begin
    lblAccountsCount.Caption := inttostr(FNode.Bank.AccountsCount);
  end;
  // Show Totals:
  lblAccountsBalance.Caption := TCurrencyUtils.FormatMoney(FAccountsGrid.AccountsBalance);
  UpdateOperations;
end;

procedure TFRMWallet.UpdateAvailableConnections;
Var i : integer;
 NC : TNetConnection;
 l : TList;
begin
  if Not TConnectionManager.NetData.NetConnections.TryLockList(100,l) then exit;
  try
    MessagesFrame1.lbNetConnections.Items.BeginUpdate;
    Try
      MessagesFrame1.lbNetConnections.Items.Clear;
      for i := 0 to l.Count - 1 do begin
        NC := l[i];
        if NC.Connected then begin
          if NC is TNetServerClient then begin
            if Not NC.IsMyselfServer then begin
              MessagesFrame1.lbNetConnections.Items.AddObject(Format(rsClientIPS, [
                NC.ClientRemoteAddr]), NC);
            end;
          end else begin
            if Not NC.IsMyselfServer then begin
              MessagesFrame1.lbNetConnections.Items.AddObject(Format(rsServerIPS, [
                NC.ClientRemoteAddr]), NC);
            end;
          end;
        end;
      end;
    Finally
      MessagesFrame1.lbNetConnections.Items.EndUpdate;
    End;
  finally
    TConnectionManager.NetData.NetConnections.UnlockList;
  end;
end;

procedure TFRMWallet.UpdateBlockChainState;
Var isMining : boolean;
//  hr : Int64;
  i,mc : Integer;
  s : String;
  mtl : TList;
  f, favg : real;
begin
  UpdateNodeStatus;
  mc := 0;
//  hr := 0;
  if Assigned(FNode) then begin
    if FNode.Bank.BlocksCount>0 then begin
      lblCurrentBlock.Caption :=  Inttostr(FNode.Bank.BlocksCount)+' (0..'+Inttostr(FNode.Bank.BlocksCount-1)+')'; ;
    end else lblCurrentBlock.Caption :=  rsNone;
    lblCurrentAccounts.Caption := Inttostr(FNode.Bank.AccountsCount);
    lblCurrentBlockTime.Caption := UnixTimeToLocalElapsedTime(FNode.Bank.LastOperationBlock.timestamp);
    lblOperationsPending.Caption := Inttostr(FNode.Operations.Count);
    lblCurrentDifficulty.Caption := InttoHex(FNode.Operations.OperationBlock.compact_target,8);
    StatusBar.Panels[2].Text := 'Blocks: '+Inttostr(FNode.Bank.BlocksCount)+' / '+
    'Difficulty: '+ InttoHex(FNode.Operations.OperationBlock.compact_target,8);
    favg := FNode.Bank.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage);
    f := (CT_NewLineSecondsAvg - favg) / CT_NewLineSecondsAvg;
    lblTimeAverage.Caption := Format(rsLast00SecOpt, [Inttostr(
      CT_CalcNewTargetBlocksAverage), FormatFloat('0.0', favg), Inttostr(
      CT_NewLineSecondsAvg), FormatFloat('0.00%', f*100)]);
    if favg>=CT_NewLineSecondsAvg then begin
      lblTimeAverage.Font.Color := clNavy;
    end else begin
      lblTimeAverage.Font.Color := clOlive;
    end;
    lblTimeAverageAux.Caption := Format(rsLastDSSecDSS, [
        CT_CalcNewTargetBlocksAverage * 2 ,FormatFloat('0.0',FNode.Bank.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage * 2)),
        ((CT_CalcNewTargetBlocksAverage * 3) DIV 2) ,FormatFloat('0.0',FNode.Bank.GetActualTargetSecondsAverage((CT_CalcNewTargetBlocksAverage * 3) DIV 2)),
        ((CT_CalcNewTargetBlocksAverage DIV 4)*3),FormatFloat('0.0',FNode.Bank.GetActualTargetSecondsAverage(((CT_CalcNewTargetBlocksAverage DIV 4)*3))),
        CT_CalcNewTargetBlocksAverage DIV 2,FormatFloat('0.0',FNode.Bank.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage DIV 2)),
        CT_CalcNewTargetBlocksAverage DIV 4,FormatFloat('0.0',FNode.Bank.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage DIV 4))]);
  end else begin
    isMining := false;
    StatusBar.Panels[2].Text:='';
    lblCurrentBlock.Caption := '';
    lblCurrentAccounts.Caption := '';
    lblCurrentBlockTime.Caption := '';
    lblOperationsPending.Caption := '';
    lblCurrentDifficulty.Caption := '';
    lblTimeAverage.Caption := '';
    lblTimeAverageAux.Caption := '';
  end;
  if (Assigned(FPoolMiningServer)) And (FPoolMiningServer.Active) then begin
    If FPoolMiningServer.ClientsCount>0 then begin
      lblMinersClients.Caption := Format(rsConnectedJSO, [IntToStr(
        FPoolMiningServer.ClientsCount)]);
      lblMinersClients.Font.Color := clNavy;
    end else begin
      lblMinersClients.Caption := rsNoJSONRPCCli;
      lblMinersClients.Font.Color := clDkGray;
    end;
    MinersBlocksFound := FPoolMiningServer.ClientsWins;
  end else begin
    MinersBlocksFound := 0;
    lblMinersClients.Caption := rsJSONRPCServe;
    lblMinersClients.Font.Color := clRed;
  end;
end;

procedure TFRMWallet.UpdateConfigChanged;
Var wa : Boolean;
  i : Integer;
begin
//  tsLogs.TabVisible := FAppParams.ParamByName[CT_PARAM_ShowLogs].GetAsBoolean(false);
  FLog.OnNewLog := OnNewLog;
  if FAppParams.ParamByName[CT_PARAM_SaveLogFiles].GetAsBoolean(false) then begin
    if FAppParams.ParamByName[CT_PARAM_SaveDebugLogs].GetAsBoolean(false) then FLog.SaveTypes := CT_TLogTypes_ALL
    else FLog.SaveTypes := CT_TLogTypes_DEFAULT;
    FLog.FileName := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'MicroCointWallet.log';
  end else begin
    FLog.SaveTypes := [];
    FLog.FileName := '';
  end;
  if Assigned(FNode) then begin
    wa := FNode.NetServer.Active;
    FNode.NetServer.Port := FAppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
    FNode.NetServer.Active := wa;
    FNode.Operations.BlockPayload := FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
    FNode.NodeLogFilename := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'blocks.log';
  end;
  if Assigned(FPoolMiningServer) then begin
    if FPoolMiningServer.Port<>FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].GetAsInteger(CT_JSONRPCMinerServer_Port) then begin
      FPoolMiningServer.Active := false;
      FPoolMiningServer.Port := FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].GetAsInteger(CT_JSONRPCMinerServer_Port);
    end;
    FPoolMiningServer.Active :=FAppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].GetAsBoolean(true);
    FPoolMiningServer.UpdateAccountAndPayload(GetAccountKeyForMiner,FAppParams.ParamByName[CT_PARAM_MinerName].GetAsString(''));
  end;
  if Assigned(FRPCServer) then begin
    FRPCServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1');
  end;
  i := FAppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].GetAsInteger(Integer(mpk_Random));
  if (i>=Integer(Low(TMinerPrivatekey))) And (i<=Integer(High(TMinerPrivatekey))) then FMinerPrivateKeyType := TMinerPrivateKey(i)
  else FMinerPrivateKeyType := mpk_Random;
end;

procedure TFRMWallet.UpdateConnectionStatus;
var errors : AnsiString;
begin
  UpdateNodeStatus;
  OnNetStatisticsChanged(Nil);
  if Assigned(FNode) then begin
    if FNode.IsBlockChainValid(errors) then begin
      StatusBar.Panels[3].Text := 'Last block: '+UnixTimeToLocalElapsedTime(FNode.Bank.LastOperationBlock.timestamp);
{       Format(rsLastAccountT,
       [FormatDateTime(rsDdMmYyyyHhNn, UnivDateTime2LocalDateTime(
         UnixToUnivDateTime( FNode.Bank.LastOperationBlock.timestamp )))]);
   }
    end else begin
      StatusBar.Panels[3].Text := 'Last block: '+UnixTimeToLocalElapsedTime(FNode.Bank.LastOperationBlock.timestamp);
//      StatusBar.Panels[3].Text := Format(rsNOBLOCKCHAIN, [errors]);
    end;
  end else begin
    StatusBar.Panels[3].Text := '';
  end;
end;

procedure TFRMWallet.UpdateNodeStatus;
Var status : AnsiString;
begin
  If Not Assigned(FNode) then begin
    lblNodeStatus.Font.Color := clRed;
    lblNodeStatus.Caption := rsInitializing;
  end else begin
    If FNode.IsReady(status) then begin
      if TConnectionManager.NetData.NetStatistics.ActiveConnections>0 then begin
        lblNodeStatus.Font.Color := clGreen;
        if TConnectionManager.NetData.IsDiscoveringServers then begin
          lblNodeStatus.Caption := rsDiscoveringS;
        end else if TConnectionManager.NetData.IsGettingNewBlockChainFromClient then begin
          lblNodeStatus.Caption := rsObtainingNew;
        end else begin
          lblNodeStatus.Caption := rsRunning;
        end;
      end else begin
        lblNodeStatus.Font.Color := clRed;
        lblNodeStatus.Caption := rsAloneInTheWo;
      end;
    end else begin
      lblNodeStatus.Font.Color := clRed;
      lblNodeStatus.Caption := status;
    end;
  end;
  If Assigned(FBackgroundPanel) then begin
    FBackgroundPanel.Font.Color:=lblNodeStatus.Font.Color;
    FBackgroundPanel.Caption:=Format(rsPleaseWaitUn, [lblNodeStatus.Caption]);
  end;
end;

procedure TFRMWallet.UpdateOperations;
Var accn : Int64;
begin
  accn := FAccountsGrid.AccountNumber(dgAccounts.Row);
  FOperationsAccountGrid.AccountNumber := accn;
end;

procedure TFRMWallet.UpdatePrivateKeys;
Var i,last_i : Integer;
  wk : TWalletKey;
  s : AnsiString;
begin
  If (Not Assigned(FOrderedAccountsKeyList)) And (Assigned(FNode)) Then begin
    FOrderedAccountsKeyList := TOrderedAccountKeysList.Create(FNode.Bank.AccountStorage,false);
  end;
  if (cbMyPrivateKeys.ItemIndex>=0) then last_i := PtrInt(cbMyPrivateKeys.Items.Objects[cbMyPrivateKeys.ItemIndex])
  else last_i := -1;
  cbMyPrivateKeys.items.BeginUpdate;
  Try
    cbMyPrivateKeys.Items.Clear;
    For i:=0 to FWalletKeys.Count-1 do begin
      wk := FWalletKeys.Key[i];
      if assigned(FOrderedAccountsKeyList) then begin
        FOrderedAccountsKeyList.AddAccountKey(wk.AccountKey);
      end;
      if (wk.Name='') then begin
        s := 'Sha256='+TCrypto.ToHexaString( TCrypto.DoSha256( wk.AccountKey.ToRawString ) );
      end else begin
        s := wk.Name;
      end;
      if Not Assigned(wk.PrivateKey) then s := s + '(*)';
      cbMyPrivateKeys.Items.AddObject(s,TObject(i));
    end;
    cbMyPrivateKeys.Sorted := true;
    cbMyPrivateKeys.Sorted := false;
    cbMyPrivateKeys.Items.InsertObject(0, rsAllMyPrivate, TObject(-1));
  Finally
    cbMyPrivateKeys.Items.EndUpdate;
  End;
  last_i := cbMyPrivateKeys.Items.IndexOfObject(TObject(last_i));
  if last_i<0 then last_i := 0;
  if cbMyPrivateKeys.Items.Count>last_i then cbMyPrivateKeys.ItemIndex := last_i
  else if cbMyPrivateKeys.Items.Count>=0 then cbMyPrivateKeys.ItemIndex := 0;
end;

initialization
  FRMWallet := Nil;
end.
