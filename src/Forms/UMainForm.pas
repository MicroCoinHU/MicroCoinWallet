unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, URPC, UWalletKeys, UGridUtils, UNode, UAppParams;

type
  TMainForm = class(TForm)
    accountsGrid: TDrawGrid;
    procedure FormCreate(Sender: TObject);
  private
    FNode : TNode;
    FRPCServer : TRPCServer;
    WalletKeys : TWalletKey;
    FAccountsGrid : TAccountsGrid;
    FAppParams : TAppParams;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
    FNode := TNode.Node;
    FNode.NetServer.Port := FAppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);
    FNode.PeerCache := FAppParams.ParamByName[CT_PARAM_PeerCache].GetAsString('')+';'+CT_Discover_IPs;
    // Create RPC server
    FRPCServer := TRPCServer.Create;
    FRPCServer.WalletKeys := WalletKeys;
    FRPCServer.Active := FAppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
    FRPCServer.ValidIPs := FAppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1');
    WalletKeys.SafeBox := FNode.Bank.SafeBox;
    // Check Database
    FNode.Bank.StorageClass := TFileStorage;
    TFileStorage(FNode.Bank.Storage).DatabaseFolder := TFolderHelper.GetMicroCoinDataFolder+PathDelim+'Data';
    TFileStorage(FNode.Bank.Storage).Initialize;

  FAccountsGrid := TAccountsGrid.Create(Self);
  FAccountsGrid.DrawGrid := dgAccounts;
  FAccountsGrid.AllowMultiSelect := True;

end;

end.
