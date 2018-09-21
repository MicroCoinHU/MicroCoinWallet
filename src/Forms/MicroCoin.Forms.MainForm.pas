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
  ExtCtrls, ComCtrls, UWalletKeys, StdCtrls, ULog, Grids, MicroCoin.Application.Settings,
  Menus, ImgList, Styles, Themes,
  synautil, UCrypto, Buttons, IniFiles,  MicroCoin.Keys.KeyManager,
  System.Notification, PngImageList, Actions, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ImageList,
  VirtualTrees, PngBitBtn, PngSpeedButton, ActnCtrls,
  MicroCoin.Transaction.Base, MicroCoin.Transaction.TransferMoney, MicroCoin.Transaction.ChangeKey,
  MicroCoin.Forms.EditAccount,
  MicroCoin.Account.AccountKey, MicroCoin.Common.Lists, MicroCoin.Common,
  MicroCoin.Transaction.ITransaction,
  MicroCoin.Account.Data, Types, httpsend,
  MicroCoin.Node.Node, MicroCoin.Forms.BlockChain.Explorer,
  MicroCoin.Account.Storage, PlatformVclStylesActnCtrls,
  MicroCoin.RPC.Server, UAES, Math,
  MicroCoin.Mining.Server,  MicroCoin.Forms.ChangeAccountKey, MicroCoin.Node.Events,
  MicroCoin.Forms.Transaction.Explorer, MicroCoin.Forms.Common.Settings,
  MicroCoin.Net.Connection, MicroCoin.Net.Client, MicroCoin.Net.Statistics,
  MicroCoin.Forms.BuyAccount, MicroCoin.Transaction.ListAccount,
  MicroCoin.Transaction.CreateSubAccount,
  MicroCoin.Forms.Transaction.History, MicroCoin.Forms.Keys.Keymanager, UITypes,
  SyncObjs, DelphiZXIngQRCode, ShellApi,
  Tabs, ExtActns, MicroCoin.Forms.SellAccount, MicroCoin.Account.Editors,
  ToolWin, WinXCtrls, ActnPopup
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
    GeneralInfoPanel: TPanel;
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
    QRCodeDisplay: TImage;
    cbForSale: TCheckBox;
    HomePageAction: TAction;
    CommunityAction: TAction;
    PopupActionBar1: TPopupActionBar;
    menuItemTransactionHistory: TMenuItem;
    menuItemEdit: TMenuItem;
    menuItemChangekey: TMenuItem;
    menuItemSell: TMenuItem;
    menuItemRevokeSell: TMenuItem;
    menuItemBuy: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
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
    procedure accountVListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure cbForSaleClick(Sender: TObject);
    procedure CommunityActionExecute(Sender: TObject);
    procedure HomePageActionExecute(Sender: TObject);
    procedure accountVListInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
  private
    FBackgroundPanel: TPanel;
    FMinersBlocksFound: Integer;
    bShowLogs : TPngSpeedButton;
    FProgessBar: TProgressBar;
    procedure SetMinersBlocksFound(const Value: Integer);
    procedure FinishedLoadingApp;
  protected
    { Private declarations }
    FIsActivated: Boolean;
    FLog: TLog;
    FAppSettings: TAppSettings;
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
    procedure OnMiningServerNewBlockFound(Sender: TObject);
    procedure UpdateConnectionStatus;
    procedure UpdateAccounts(RefreshData: Boolean);
    procedure UpdateBlockChainState;
    procedure UpdatePrivateKeys;
    procedure LoadAppParams;
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

  { TThreadActivate }

procedure TThreadActivate.BCExecute;
begin
  TNode.Node.BlockManager.DiskRestoreFromTransactions(CT_MaxBlock);
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

  if xIndex < 0
  then exit;

  if MessageDlg('Really want to revoke sell?',mtConfirmation,[mbYes, mbNo],0) <> mrYes
  then exit;

  xPrivateKey := TNode.Node.KeyManager[xIndex].PrivateKey;
  xTransaction:=TDelistAccountTransaction.CreateDelistAccountForSale(
    xAccount.AccountNumber,
    xAccount.numberOfTransactions+1,
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

procedure TMainForm.accountVListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  xQRCode: TDelphiZXingQRCode;
  xRow, xCol: Integer;
  xQRCodeBitmap: TBitmap;
begin
  if Node=nil then exit;
  xQRCode := TDelphiZXingQRCode.Create;
  try
    xQRCodeBitmap := QRCodeDisplay.Picture.Bitmap;
    xQRCode.Data :='{"account":"'+ TAccount.AccountNumberToAccountTxtNumber(TAccount(Node.GetData^).AccountNumber)+'","amount":"","payload":""}';
    xQRCode.Encoding := TQRCodeEncoding(qrISO88591);
    xQRCode.QuietZone := 1;
    xQRCodeBitmap.SetSize(xQRCode.Rows, xQRCode.Columns);
    for xRow := 0 to xQRCode.Rows - 1 do
    begin
      for xCol := 0 to xQRCode.Columns - 1 do
      begin
        if (xQRCode.IsBlack[xRow, xCol]) then
        begin
          xQRCodeBitmap.Canvas.Pixels[xCol, xRow] := clBlack;
        end else
        begin
          xQRCodeBitmap.Canvas.Pixels[xCol, xRow] := clWhite;
        end;
      end;
    end;
    QRCodeDisplay.Picture.Bitmap := xQRCodeBitmap;
  finally
    xQRCode.Free;
  end;
end;

procedure TMainForm.accountVListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
      1: CellText := xPAccount.name {$IFDEF EXTENDEDACCOUNT} +' ' +IntToStr(xPAccount.ExtraData.DataType)+' '+BoolToStr(xPaccount.hasExtraData, true){$ENDIF};
      2: begin
           CellText := TCurrencyUtils.CurrencyToString(xPAccount.balance);
           if xPAccount.AccountInfo.state = as_ForSale then
           CellText := CellText + ' ('+TCurrencyUtils.CurrencyToString(xPAccount.AccountInfo.price)+')';
        end;
      3: CellText := xPAccount.numberOfTransactions.ToString;
    end;
  end else begin
  {$IFDEF EXTENDEDACCOUNT}
    xPAccount := TAccount(Sender.GetNodeData(Node.Parent)^);
    case Column of
      0: CellText := TAccount.AccountNumberToAccountTxtNumber(xPAccount.AccountNumber) + '/' +IntToStr(Node.Index);
      1: CellText := '';
      2: CellText := TCurrencyUtils.CurrencyToString(xPAccount.SubAccounts[Node.Index].Balance);
    end;
  {$ENDIF}
  end;
end;

procedure TMainForm.accountVListInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
begin
  {$IFDEF EXTENDEDACCOUNT}
  ChildCount := Length(TAccount(Node.GetData^).SubAccounts);
  {$ELSE}
  ChildCount := 0;
  {$ENDIF}
end;

procedure TMainForm.accountVListInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  xAccountNumber : Cardinal;
  xAccount: TAccount;
begin

  if cbExploreMyAccounts.Checked or cbForSale.Checked
  then xAccountNumber := FAccounts.Get(Node.Index)
  else xAccountNumber := Node.Index;

  if Sender.GetNodeLevel(Node) = 0
  then Node.CheckType := TCheckType.ctCheckBox
  else Node.CheckType := TCheckType.ctNone;

  xAccount := TNode.Node.Operations.AccountTransaction.Account(xAccountNumber);
  {$IFDEF EXTENDEDACCOUNT}
  if Sender.GetNodeLevel(Node) = 0 then begin
    Sender.ChildCount[Node] := Length(xAccount.SubAccounts);
  end else Sender.ChildCount[Node] := 0;
  {$ENDIF}
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
        E.Message := Format('Can not open wallet file: %s', [E.Message]);
        raise;
      end;
    end;
    xIPAddresses := FAppSettings.Entries[TAppSettingsEntry.apTryToConnectOnlyWithThisFixedServers].GetAsString('');
    TNode.DecodeIpStringToNodeServerAddressArray(xIPAddresses, xNodeServers);
    TConnectionManager.Instance.DiscoverFixedServersOnly(xNodeServers);
    setlength(xNodeServers, 0);
    // Creating Node:
    TNode.Node.NetServer.Port := FAppSettings.Entries[TAppSettingsEntry.apInternetServerPort].GetAsInteger(CT_NetServer_Port);
    TNode.Node.PeerCache := FAppSettings.Entries[TAppSettingsEntry.apPeerCache].GetAsString('') + ';' + CT_Discover_IPs;
    // Create RPC server
    FRPCServer := TRPCServer.Instance;
    FRPCServer.WalletKeys := TNode.Node.KeyManager;
    FRPCServer.Active := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCAllowedIPs].GetAsString('127.0.0.1');
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
      E.Message := Format('An error occoured: %s', [E.Message]);
      Application.MessageBox(PChar(E.Message), PChar(Application.Title), MB_ICONERROR + MB_OK);
      Halt;
    end;
  end;
  UpdatePrivateKeys;
  UpdateAccounts(false);
  if FAppSettings.Entries[TAppSettingsEntry.apFirstTime].GetAsBoolean(true) then
  begin
    FAppSettings.Entries[TAppSettingsEntry.apFirstTime].SetAsBoolean(false);
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
{
procedure TMainForm.Button1Click(Sender: TObject);
var
  i: integer;
  xErrors: AnsiString;
  xTransaction: ITransaction;
begin
  i := TNode.Node.KeyManager.IndexOfAccountKey(
      TAccount(accountVList.FocusedNode.GetData^).AccountInfo.AccountKey
  );
  xTransaction := TCreateSubAccountTransaction.Create(
    TAccount(accountVList.FocusedNode.GetData^).AccountNumber,
    0,
    TAccount(accountVList.FocusedNode.GetData^).n_operation+1,
    TNode.Node.KeyManager[i].PrivateKey,
    TAccount(accountVList.FocusedNode.GetData^).AccountInfo.AccountKey,
    10
  );
  if not TNode.Node.AddOperation(nil, xTransaction, xErrors) then begin
    MessageDlg(xErrors, TMsgDlgType.mtError, [mbOK],0);
    exit;
  end;
end;
}
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

procedure TMainForm.cbForSaleClick(Sender: TObject);
begin
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
                xLastConnTime := ' - Last comunication <10 sec.';
              end
              else
              begin
                xLastConnTime := Format(' - Last comunication %.2dm%.2ds', [(hh * 60) + nn, ss]);
              end;
            end
            else
            begin
              xLastConnTime := '';
            end;
            if xNetConnection is TNetServerClient then
            begin
              xNSC.Add(Format('Client: IP:%s Block:%d Sent/Received:%d/%d Bytes - %s - ' + 'Time offset %d - Active since %s %s',
                [xNetConnection.ClientRemoteAddr, xNetConnection.RemoteOperationBlock.block, xNetConnection.Client.BytesSent,
                xNetConnection.Client.BytesReceived, xClientApp, xNetConnection.TimestampDiff, DateTimeElapsedTime(xNetConnection.CreatedTime),
                xLastConnTime]));
            end
            else
            begin
              if xNetConnection.IsMyselfServer then
                xNSC.Add(Format('MySelf IP:%s Sent/Received:%d/%d Bytes - %s - Time offset ' + '%d - Active since %s %s', [xNetConnection.ClientRemoteAddr, xNetConnection.Client.BytesSent, xNetConnection.Client.BytesReceived,
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

procedure TMainForm.CommunityActionExecute(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://discord.gg/ewQq5A6', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.ConfirmRestart;
begin
  if MessageDlg('Restart application?', {$IFDEF fpc} rsYouNeedResta, {$ENDIF} mtConfirmation, [mbYes, mbNo],{$IFDEF fpc}''{$ELSE}0{$ENDIF}) = mrYes then
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
  FPoolMiningServer.Port := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCMinerServerPort]
    .GetAsInteger(CT_JSONRPCMinerServer_Port);
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.MinerPayload := FAppSettings.Entries[TAppSettingsEntry.apMinerName].GetAsString('');
  TNode.Node.Operations.AccountKey := GetAccountKeyForMiner;
  FPoolMiningServer.Active := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCMinerServerActive].GetAsBoolean(true);
  FPoolMiningServer.OnMiningServerNewBlockFound := OnMiningServerNewBlockFound;
  for i:=0 to MainActions.ActionCount-1 do MainActions[i].Enabled := true;
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
    MessageDlg(Format('Can not load required library: %s', [SSL_C_LIB]), mtError, [mbOk], 0);
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
  FAppSettings := TAppSettings.Create;
  FAppSettings.FileName := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'AppParams.prm';
{$IFNDEF TESTNET}
  TStyleManager.TrySetStyle(FAppSettings.Entries[TAppSettingsEntry.apTheme].GetAsString('MicroCoin Light'), false);
{$ENDIF}
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
  FBackgroundPanel.Font.Size := 12;
  FBackgroundPanel.Alignment := TAlignment.taCenter;
  FProgessBar := TProgressBar.Create(FBackgroundPanel);
  FProgessBar.Parent := FBackgroundPanel;
  FProgessBar.Width := 250;
  FProgessBar.Top := 10 + Abs(FBackgroundPanel.Font.Height) + (FBackgroundPanel.Height div 2 - FProgessBar.Height div 2);
  FProgessBar.Left := FBackgroundPanel.Width div 2 - FProgessBar.Width div 2;
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
begin
  Self.Hide;
  Application.ProcessMessages;
  TLog.NewLog(ltinfo, Classname, 'Destroying form - START');
  try
    FreeAndNil(FRPCServer);
    FreeAndNil(FPoolMiningServer);
    FreeAndNil(FAppSettings);
    FLog.OnNewLog := nil;
    TConnectionManager.Instance.OnReceivedHelloMessage := nil;
    TConnectionManager.Instance.OnStatisticsChanged := nil;
    TConnectionManager.Instance.OnNetConnectionsUpdated := nil;
    TConnectionManager.Instance.OnNodeServersUpdated := nil;
    TConnectionManager.Instance.OnBlackListUpdated := nil;
    FreeAndNil(FNodeNotifyEvents);
    TConnectionManager.Instance.OnReceivedHelloMessage := nil;
    TConnectionManager.Instance.OnStatisticsChanged := nil;
    FreeAndNil(FOrderedAccountsKeyList);
    Application.ProcessMessages;
    TNode.FreeNode;
    Application.ProcessMessages;
    if Assigned(FAccounts)
    then FreeAndNil(FAccounts);
    TConnectionManager.ReleaseInstance;
  except
    on E: Exception do
    begin
      TLog.NewLog(lterror, Classname, 'Error destroying form. Errors (' + E.Classname + '): ' +
        E.Message);
    end;
  end;
  TLog.NewLog(ltinfo, Classname, 'Destroying form - END');
  FreeAndNil(FLog);
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
  if not Assigned(FAppSettings) then
    exit;
  case FMinerPrivateKeyType of
    mpk_NewEachTime:
      xPublicKey := CT_TECDSA_Public_Nul;
    mpk_Selected:
      begin
        xPublicKey := TAccountKey.FromRawString(FAppSettings.Entries[TAppSettingsEntry.apMinerPrivateKeySelectedPublicKey]
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

procedure TMainForm.HomePageActionExecute(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://microcoin.hu', nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.LoadAppParams;
var
  xMemoryStream: TMemoryStream;
  s: AnsiString;
  xFileVersionInfo: TFileVersionInfo;
begin
  xMemoryStream := TMemoryStream.Create;
  try
    s := FAppSettings.Entries[TAppSettingsEntry.apGridAccountsStream].GetAsString('');
    xMemoryStream.WriteBuffer(s[1], length(s));
    xMemoryStream.Position := 0;
    // Disabled on V2: FAccountsGrid.LoadFromStream(ms);
  finally
    xMemoryStream.Free;
  end;
  if FAppSettings.Find(TAppSettingsEntry.apMinerName) = nil then
  begin
    // New configuration... assigning a new random value
    xFileVersionInfo := TFolderHelper.GetTFileVersionInfo(Application.ExeName);
    FAppSettings.Entries[TAppSettingsEntry.apMinerName].SetAsString(Format('New Node %s - %s Build: %s', [DateTimeToStr(now), xFileVersionInfo.InternalName,
      xFileVersionInfo.FileVersion]));
  end;
  UpdateConfigChanged;
end;

procedure TMainForm.OnMiningServerNewBlockFound(Sender: TObject);
begin
  FPoolMiningServer.MinerAccountKey := GetAccountKeyForMiner;
end;

procedure TMainForm.OnNetBlackListUpdated(Sender: TObject);
var
  i, j, n: Integer;
  xNodeServer: PNodeServerAddress;
  xList: TList;
  xStrings: TStrings;
begin
  xList := TConnectionManager.Instance.NodeServersAddresses.LockList;
  try
    xStrings := memoNetBlackLists.Lines;
    xStrings.BeginUpdate;
    try
      xStrings.Clear;
      xStrings.Add(Format('BlackList Updated: %s by TID: %s', [DateTimeToStr(now), IntToHex(TThread.CurrentThread.ThreadID, 8)]));
      j := 0;
      n := 0;
      for i := 0 to xList.Count - 1 do
      begin
        xNodeServer := xList[i];
        if (xNodeServer^.is_blacklisted) then
        begin
          inc(n);
          if not xNodeServer^.its_myself then
          begin
            inc(j);
            xStrings.Add(Format('Blacklist IP: %s:%d LastConnection: %s Reason: %s', [xNodeServer^.ip, xNodeServer^.Port,
              DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(xNodeServer^.last_connection))), xNodeServer^.BlackListText]));
          end;
        end;
      end;
      xStrings.Add(Format('Total Blacklisted IPs: %d (Total %d)', [j, n]));
    finally
      xStrings.EndUpdate;
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
  xPNodeServerAddress: PNodeServerAddress;
  l: TList;
  xStrings: TStrings;
  s: string;
begin
  l := TConnectionManager.Instance.NodeServersAddresses.LockList;
  try
    xStrings := memoNetServers.Lines;
    xStrings.BeginUpdate;
    try
      xStrings.Clear;
      xStrings.Add(Format('NodeServers Updated: %s Count: %s', [DateTimeToStr(now), IntToStr(l.Count)]));
      for i := 0 to l.Count - 1 do
      begin
        xPNodeServerAddress := l[i];
        if not(xPNodeServerAddress^.is_blacklisted) then
        begin
          s := Format('Server IP: %s:%d', [xPNodeServerAddress^.ip, xPNodeServerAddress^.Port]);
          if Assigned(xPNodeServerAddress.NetConnection) then
          begin
            if xPNodeServerAddress.last_connection > 0 then
              s := Format('%s ** ACTIVE **', [s])
            else
              s := Format('%s ** TRYING TO CONNECT **', [s]);
          end;
          if xPNodeServerAddress.its_myself then
          begin
            s := Format('%s ** NOT VALID ** %s', [s, xPNodeServerAddress.BlackListText]);
          end;
          if xPNodeServerAddress.last_connection > 0 then
          begin
            s := Format('%s Last connection: %s',
              [s, DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(xPNodeServerAddress^.last_connection)))]);
          end;
          if xPNodeServerAddress.last_connection_by_server > 0 then
          begin
            s := Format('%s Last server connection: %s',
              [s, DateTimeToStr(UnivDateTime2LocalDateTime(UnixToUnivDateTime(xPNodeServerAddress^.last_connection_by_server)))]);
          end;
          if (xPNodeServerAddress.last_attempt_to_connect > 0) then
          begin
            s := Format('%s Last attempt to connect: %s', [s, DateTimeToStr(xPNodeServerAddress^.last_attempt_to_connect)]);
          end;
          if (xPNodeServerAddress.total_failed_attemps_to_connect > 0) then
          begin
            s := Format('%s (Attempts: %s)', [s, IntToStr(xPNodeServerAddress^.total_failed_attemps_to_connect)]);
          end;

          xStrings.Add(s);
        end;
      end;
    finally
      xStrings.EndUpdate;
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
  xThreadId: AnsiString;
begin
   if (logtype=ltdebug) then exit;
  if ThreadID = MainThreadID then
    xThreadId := ' MAIN:'
  else
    xThreadId := ' TID:';
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
    + ' [' + CT_LogType[logtype] + '] ' + { <'+sender+'> '+ } logtext);
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
  if FAppSettings.Entries[TAppSettingsEntry.apNotifyOnNewTransaction].GetAsBoolean(true)
  then begin
    for i:=0 to TNodeNotifyEvents(Sender).Node.Operations.Count - 1 do begin
       xTransaction := TNodeNotifyEvents(Sender).Node.Operations.TransactionHashTree.GetTransaction(i);
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
  end;
  UpdateAccounts(true);
end;

procedure TMainForm.OnNodeMessageEvent(NetConnection: TNetConnection; MessageData: TRawBytes);
begin
end;

procedure TMainForm.OnReceivedHelloMessage(Sender: TObject);
var
  xNodeServerArray: TNodeServerAddressArray;
  i: Integer;
  s: AnsiString;
begin
  // CheckMining;
  // Update node servers Peer Cache
  xNodeServerArray := TConnectionManager.Instance.GetValidNodeServers(true, 0);
  s := '';
  for i := low(xNodeServerArray) to high(xNodeServerArray) do
  begin
    if (s <> '') then
      s := s + ';';
    s := s + xNodeServerArray[i].ip + ':' + IntToStr(xNodeServerArray[i].Port);
  end;
  FAppSettings.Entries[TAppSettingsEntry.apPeerCache].SetAsString(s);
  TNode.Node.PeerCache := s;
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
  TTransactionExplorer.Create(nil).Show;
end;

procedure TMainForm.PendingTransactionsActionExecute(Sender: TObject);
begin
  with TTransactionHistoryForm.Create(nil) do begin
    Show;
  end;
end;

procedure TMainForm.SelectAllActionExecute(Sender: TObject);
var
  xNode: PVirtualNode;
  xAllAmount : UInt64;
begin
  xAllAmount := 0;
  accountVList.BeginUpdate;
  try
    xNode := accountVList.GetFirst;
    while Assigned(xNode) do
    begin
      if SelectAllAction.Checked
      then begin
         xNode.CheckState := TCheckState.csCheckedNormal;
         xAllAmount := xAllAmount + TAccount(xNode.GetData()^).balance;
      end
      else xNode.CheckState := TCheckState.csUncheckedNormal;
      xNode := accountVList.GetNextSibling(xNode);
    end;
    if SelectAllAction.Checked then begin
      amountEdit.ReadOnly := true;
      amountEdit.Text := TCurrencyUtils.CurrencyToString(xAllAmount);
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
    xSenderAccount.numberOfTransactions + 1,
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
    AppParams := FAppSettings;
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
  xRect : TRect;
  xDetails : TThemedElementDetails;
begin
  StatusBar.Canvas.Font.Color := StyleServices.GetSystemColor(clWindowText);
  xDetails := StyleServices.GetElementDetails(tsPane);
  if Panel.Index = 0 then begin
    xRect := Rect;
    xRect.Left := xRect.Left + 3;
    xRect.Top := xRect.Top+1;
    StyleServices.DrawIcon(StatusBar.Canvas.Handle, xDetails, xRect, miscIcons.Handle, 3);
    xRect.Left := xRect.Left + 23;
    xRect.Top := xRect.Top;
    if TNode.Node.NetServer.Active
    then xText := 'Active'
    else xText := 'Stopped';
    StyleServices.DrawText(StatusBar.Canvas.Handle, xDetails, xText, xRect, [tfLeft] , StatusBar.Canvas.Font.Color);
  end;
  if Panel.Index = 1 then begin

    if TConnectionManager.Instance.NetStatistics.ClientsConnections + TConnectionManager.Instance.NetStatistics.ServersConnections = 0
    then xIndex := 2
    else xIndex := 1;

    xRect := Rect;
    xRect.Left := xRect.Left + 3;
    StyleServices.DrawIcon(StatusBar.Canvas.Handle, xDetails, xRect, miscIcons.Handle, xIndex);
    xRect.Left := xRect.Left + 23;
    xRect.Top := xRect.Top;
    xText := Format('%d clients | %d servers', [TConnectionManager.Instance.NetStatistics.ClientsConnections, TConnectionManager.Instance.NetStatistics.ServersConnections]);
    StyleServices.DrawText(StatusBar.Canvas.Handle, xDetails, xText, xRect, [tfLeft] , StatusBar.Canvas.Font.Color);
  end;

 if Panel.Index = 2 then begin

    xRect := Rect;
    xRect.Left := xRect.Left + 3;
    StyleServices.DrawIcon(StatusBar.Canvas.Handle, xDetails, xRect, miscIcons.Handle, 6);
    xRect.Left := xRect.Left + 23;
    xRect.Top := xRect.Top;
    xText := Format('Traffic: %.0n Kb | %.0n Kb',
      [TConnectionManager.Instance.NetStatistics.BytesReceived/1024,
       TConnectionManager.Instance.NetStatistics.BytesSend/1024]);
       StyleServices.DrawText(StatusBar.Canvas.Handle, xDetails, xText, xRect, [tfLeft] , StatusBar.Canvas.Font.Color);
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
      E.Message := Format('Exception at TimerUpdate %s: %s', [E.Classname, E.Message]);
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
  xAccount: TAccount;
begin

  if not assigned(FAccounts)
  then FAccounts := TOrderedList.Create
  else FAccounts.Clear;

  FTotalAmount := 0;

  if not cbExploreMyAccounts.Checked
  then begin
    if not cbForSale.Checked
    then begin
      accountVList.RootNodeCount := TNode.Node.Operations.BlockManager.AccountStorage.AccountsCount;
      FTotalAmount := TNode.Node.Operations.BlockManager.AccountStorage.TotalBalance;
    end else begin
      for i := 0 to TNode.Node.Operations.BlockManager.AccountStorage.AccountsCount-1
      do begin
        xAccount := TNode.Node.Operations.AccountTransaction.Account(i);
        if xAccount.AccountInfo.state = as_ForSale
        then FAccounts.Add(xAccount.AccountNumber);
      end;
     accountVList.RootNodeCount := FAccounts.Count;
    end;
  end else begin
    if cbMyPrivateKeys.ItemIndex<0 then exit;
    if cbMyPrivateKeys.ItemIndex=0 then begin
      for i := 0 to TNode.Node.KeyManager.Count - 1 do begin
        j := FOrderedAccountsKeyList.IndexOfAccountKey(TNode.Node.KeyManager[i].AccountKey);
        if (j>=0) then begin
          l := FOrderedAccountsKeyList.AccountList[j];
          for k := 0 to l.Count - 1 do begin
            xAccount := TNode.Node.Operations.AccountTransaction.Account(l.Get(k));
            if cbForSale.Checked
            then if xAccount.AccountInfo.state <> as_ForSale then continue;
            FAccounts.Add(l.Get(k));
            FTotalAmount := FTotalAmount + xAccount.balance;
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
            xAccount := TNode.Node.Operations.AccountTransaction.Account(l.Get(k));
            if cbForSale.Checked
            then if xAccount.AccountInfo.state <> as_ForSale then continue;
            FAccounts.Add(l.Get(k));
            FTotalAmount := FTotalAmount + xAccount.balance;
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
  xIsMining: boolean;
begin
  UpdateNodeStatus;
  if true then
  begin
    if TNode.Node.BlockManager.BlocksCount > 0 then
    begin
      lblCurrentBlock.Caption := IntToStr(TNode.Node.BlockManager.BlocksCount) + ' (0..' +
        IntToStr(TNode.Node.BlockManager.BlocksCount - 1) + ')';;
    end
    else lblCurrentBlock.Caption := '(none)';
    lblCurrentAccounts.Caption := IntToStr(TNode.Node.BlockManager.AccountsCount);
    lblCurrentBlockTime.Caption := UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastBlock.timestamp);
    labelOperationsPending.Caption := IntToStr(TNode.Node.Operations.Count);
    lblCurrentDifficulty.Caption := IntToHex(TNode.Node.Operations.BlockHeader.compact_target, 8);
    if TConnectionManager.Instance.MaxRemoteOperationBlock.block > TNode.Node.BlockManager.BlocksCount
    then begin
      StatusBar.Panels[3].Text :=
      Format('Downloading blocks: %.0n / %.0n', [TNode.Node.BlockManager.BlocksCount+0.0,
                                                 TConnectionManager.Instance.MaxRemoteOperationBlock.block+0.0
      ]);
      if Assigned(FBackgroundPanel) then begin
        FBackgroundPanel.Caption := StatusBar.Panels[3].Text;
        FProgessBar.Max := TConnectionManager.Instance.MaxRemoteOperationBlock.block;
        FProgessBar.Position := TNode.Node.BlockManager.BlocksCount;
      end;
    end
    else begin
//      if Assigned(FBackgroundPanel) then FreeAndNil(FBackgroundPanel);
      StatusBar.Panels[3].Text := 'Blocks: ' + Format('%.0n', [TNode.Node.BlockManager.BlocksCount+0.0]) + ' | ' + 'Difficulty: 0x' +
        IntToHex(TNode.Node.Operations.BlockHeader.compact_target, 8);
    end;
    favg := TNode.Node.BlockManager.GetActualTargetSecondsAverage(CT_CalcNewTargetBlocksAverage);
    F := (CT_NewLineSecondsAvg - favg) / CT_NewLineSecondsAvg;
    lblTimeAverage.Caption := Format('Last %s: %s sec. (Optimal %ss) Deviation %s', [IntToStr(CT_CalcNewTargetBlocksAverage), FormatFloat('0.0', favg),
      IntToStr(CT_NewLineSecondsAvg), FormatFloat('0.00%', F * 100)]);
    if favg >= CT_NewLineSecondsAvg then
    begin
      lblTimeAverage.Font.Color := clNavy;
    end
    else
    begin
      lblTimeAverage.Font.Color := clOlive;
    end;
    lblTimeAverageAux.Caption := Format('Last %d: %s sec. - %d: %s sec. - %d: %s sec. - %d: %s sec.' + ' - %d: %s sec.', [CT_CalcNewTargetBlocksAverage * 2,
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
    xIsMining := false;
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
      labelMinersClients.Caption := Format('%s connected JSON-RPC clients', [IntToStr(FPoolMiningServer.ClientsCount)]);
      labelMinersClients.Font.Color := clNavy;
    end
    else
    begin
      labelMinersClients.Caption := 'No JSON-RPC clients';
      labelMinersClients.Font.Color := clDkGray;
    end;
    MinersBlocksFound := FPoolMiningServer.ClientsWins;
  end
  else
  begin
    MinersBlocksFound := 0;
    labelMinersClients.Caption := 'JSON-RPC server not active';
    labelMinersClients.Font.Color := clRed;
  end;
  //if TConnectionManager.Instance.IsGettingNewBlockChainFromClient then begin
  //  ProgressBar2.Max := TConnectionManager.Instance.MaxRemoteOperationBlock.block;
  //  ProgressBar2.Position := TNode.Node.BlockManager.BlocksCount;
  //end;
end;

procedure TMainForm.UpdateConfigChanged;
var
  xIsNetServerActive: Boolean;
  i: Integer;
begin
  FLog.OnNewLog := OnNewLog;
  if FAppSettings.Entries[TAppSettingsEntry.apSaveLogFiles].GetAsBoolean(false) then
  begin
    if FAppSettings.Entries[TAppSettingsEntry.apSaveDebugLogs].GetAsBoolean(false) then
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
  xIsNetServerActive := TNode.Node.NetServer.Active;
  TNode.Node.NetServer.Port := FAppSettings.Entries[TAppSettingsEntry.apInternetServerPort].GetAsInteger(CT_NetServer_Port);
  TNode.Node.NetServer.Active := xIsNetServerActive;
  TNode.Node.Operations.BlockPayload := FAppSettings.Entries[TAppSettingsEntry.apMinerName].GetAsString('');
  TNode.Node.NodeLogFilename := TFolderHelper.GetMicroCoinDataFolder + PathDelim + 'blocks.log';
  if Assigned(FPoolMiningServer) then
  begin
    if FPoolMiningServer.Port <> FAppSettings.Entries[TAppSettingsEntry.apJSONRPCMinerServerPort]
      .GetAsInteger(CT_JSONRPCMinerServer_Port) then
    begin
      FPoolMiningServer.Active := false;
      FPoolMiningServer.Port := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCMinerServerPort]
        .GetAsInteger(CT_JSONRPCMinerServer_Port);
    end;
    FPoolMiningServer.Active := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCMinerServerActive].GetAsBoolean(true);
    FPoolMiningServer.UpdateAccountAndPayload(GetAccountKeyForMiner,
      FAppSettings.Entries[TAppSettingsEntry.apMinerName].GetAsString(''));
  end;
  if Assigned(FRPCServer) then
  begin
    FRPCServer.Active := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppSettings.Entries[TAppSettingsEntry.apJSONRPCAllowedIPs].GetAsString('127.0.0.1');
  end;
  i := FAppSettings.Entries[TAppSettingsEntry.apMinerPrivateKeyType].GetAsInteger(Integer(mpk_Random));
  if (i >= Integer(low(TMinerPrivateKey))) and (i <= Integer(high(TMinerPrivateKey))) then
    FMinerPrivateKeyType := TMinerPrivateKey(i)
  else
    FMinerPrivateKeyType := mpk_Random;
end;

procedure TMainForm.UpdateConnectionStatus;
var
  xErrors: AnsiString;
begin
  UpdateNodeStatus;
  OnNetStatisticsChanged(nil);
  if TNode.Node.IsBlockChainValid(xErrors) then
  begin
    StatusBar.Panels[4].Text := 'Last block: ' + UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastBlock.timestamp);
  end
  else
  begin
    StatusBar.Panels[4].Text := 'Last block: ' + UnixTimeToLocalElapsedTime(TNode.Node.BlockManager.LastBlock.timestamp);
  end;
end;

procedure TMainForm.UpdateNodeStatus;
var
  xStatus: AnsiString;
begin
  if TNode.Node.isready(xStatus) then
  begin
    if TConnectionManager.Instance.NetStatistics.ActiveConnections > 0 then
    begin
      lblNodeStatus.Font.Color := clGreen;
      if TConnectionManager.Instance.IsDiscoveringServers then
      begin
        lblNodeStatus.Caption := 'Discovering servers';
      end
      else if TConnectionManager.Instance.IsGettingNewBlockChainFromClient then
      begin
        lblNodeStatus.Caption := 'Obtaining new blockchain';
      end
      else
      begin
        lblNodeStatus.Caption := 'Running';
      end;
    end
    else
    begin
      lblNodeStatus.Font.Color := clRed;
      lblNodeStatus.Caption := 'Alone in the world...';
    end;
  end
  else
  begin
    lblNodeStatus.Font.Color := clRed;
    lblNodeStatus.Caption := xStatus;
  end;
  if Assigned(FBackgroundPanel) then
  begin
    FBackgroundPanel.Font.Color := lblNodeStatus.Font.Color;
    FProgessBar.Top := 10 + Abs(FBackgroundPanel.Font.Height) + (FBackgroundPanel.Height div 2 - FProgessBar.Height div 2);
    FProgessBar.Left := FBackgroundPanel.Width div 2 - FProgessBar.Width div 2;
    FBackgroundPanel.Caption := Format('%s', [lblNodeStatus.Caption]);
    if TNode.Node.BlockManager.IsLoadingBlocks
    then begin
      FBackgroundPanel.Caption := Format('%s', [lblNodeStatus.Caption]);
      FProgessBar.Max := Max(1,TNode.Node.BlockManager.Storage.LastBlock mod 100);
      FProgessBar.Position := TNode.Node.BlockManager.BlocksCount mod 100;
    end else begin
      FProgessBar.Max := Max(TNode.Node.BlockManager.Storage.LastBlock,1);
      FProgessBar.Position := TNode.Node.BlockManager.BlocksCount;
    end;
  end;
end;

procedure TMainForm.UpdatePrivateKeys;
var
  i, last_i: Integer;
  xWalletKey: TWalletKey;
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
      xWalletKey := TNode.Node.KeyManager.Key[i];
      if Assigned(FOrderedAccountsKeyList) then
      begin
        FOrderedAccountsKeyList.AddAccountKey(xWalletKey.AccountKey);
      end;
      if (xWalletKey.name = '') then
      begin
        s := 'Sha256=' + TCrypto.ToHexaString(TCrypto.DoSha256(xWalletKey.AccountKey.ToRawString));
      end
      else
      begin
        s := xWalletKey.name;
      end;
      if not Assigned(xWalletKey.PrivateKey) then
        s := s + '(*)';
      cbMyPrivateKeys.Items.AddObject(s, TObject(i));
    end;
    cbMyPrivateKeys.Sorted := true;
    cbMyPrivateKeys.Sorted := false;
    cbMyPrivateKeys.Items.InsertObject(0, '(All my private keys)', TObject(-1));
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
  xTemp : Cardinal;
  xTemp2: Int64;
  xIsReady: AnsiString;
begin
  Send.Enabled := (accountVList.FocusedNode <> nil)
    and TNode.Node.IsReady(xIsReady)
    and TAccount.AccountTxtNumberToAccountNumber(targetAccountEdit.AccountNumber, xTemp)
    and TCurrencyUtils.ParseValue(amountEdit.Text, xTemp2)
    and TCurrencyUtils.ParseValue(feeEdit.Text, xTemp2);
end;

initialization

MainForm := nil;

end.
