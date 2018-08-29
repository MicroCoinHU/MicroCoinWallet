unit UFRMNodesIp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UAppParams;

type
  TFRMNodesIp = class(TForm)
    memoNodesIp: TMemo;
    Label1: TLabel;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    cbTryOnlyWithThisServers: TCheckBox;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbTryOnlyWithThisServersClick(Sender: TObject);
  private
    FAppParams: TAppParams;
    procedure SetAppParams(const Value: TAppParams);
    { Private declarations }
  public
    { Public declarations }
    Procedure PrepareData;
    Property AppParams : TAppParams read FAppParams write SetAppParams;
  end;

implementation

uses
  MicroCoin.Node.Node, UConst, MicroCoin.Net.NodeServer, MicroCoin.Net.ConnectionManager;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

resourcestring
  rsNoValidIPInL = 'No valid IP in list!';
  rsRestartAppli = 'Restart application to take effect';
  rsALERTIfIsChe = 'ALERT:%sIf "%s" is checked %sand no valid server found, '
    +'you will be alone!';

{ TFRMNodesIp }

procedure TFRMNodesIp.bbOkClick(Sender: TObject);
Var nsarr : TNodeServerAddressArray;
  ips : AnsiString;
begin
  TNode.DecodeIpStringToNodeServerAddressArray(memoNodesIp.Lines.Text,nsarr);
  if (length(nsarr)=0) And (cbTryOnlyWithThisServers.Checked) then begin
    raise Exception.Create(rsNoValidIPInL);
  end;
  // Encode
  ips := TNode.EncodeNodeServerAddressArrayToIpString(nsarr);
  if Assigned(FAppParams) then begin
    FAppParams.ParamByName[CT_PARAM_PeerCache].SetAsString(ips);
    if cbTryOnlyWithThisServers.Checked then Begin
      FAppParams.ParamByName[CT_PARAM_TryToConnectOnlyWithThisFixedServers].SetAsString(ips);
      TConnectionManager.NetData.DiscoverFixedServersOnly(nsarr);
      Application.MessageBox(PChar(rsRestartAppli), PChar(Application.Title),
        MB_OK);
    end else begin
      FAppParams.ParamByName[CT_PARAM_TryToConnectOnlyWithThisFixedServers].SetAsString('');
      setlength(nsarr,0);
      TConnectionManager.NetData.DiscoverFixedServersOnly(nsarr);
    end;
  end;
  setlength(nsarr,0);
  ModalResult := MrOk;
end;

procedure TFRMNodesIp.cbTryOnlyWithThisServersClick(Sender: TObject);
begin
  if cbTryOnlyWithThisServers.Checked then begin
    cbTryOnlyWithThisServers.Font.Color := clRed;
    cbTryOnlyWithThisServers.Font.Style := [fsBold];
  end else begin
    cbTryOnlyWithThisServers.ParentFont := true;
  end;
  if cbTryOnlyWithThisServers.Checked then begin
    Application.MessageBox(PChar(Format(rsALERTIfIsChe, [#10,
      cbTryOnlyWithThisServers.Caption, #10]))
      ,PChar(Application.Title),MB_OK+MB_ICONWARNING);
  end;
end;

procedure TFRMNodesIp.FormCreate(Sender: TObject);
begin
  FAppParams := Nil;
  PrepareData;
end;

procedure TFRMNodesIp.PrepareData;
Var
  nsarr : TNodeServerAddressArray;
  i : Integer;
  ips : AnsiString;
  aux : AnsiString;
begin
  memoNodesIp.Clear;
  if Not Assigned(FAppParams) then exit;
  setlength(nsarr,0);
  ips := FAppParams.ParamByName[CT_PARAM_TryToConnectOnlyWithThisFixedServers].GetAsString('');
  if trim(ips)<>'' then begin
    cbTryOnlyWithThisServers.Checked := true;
    TNode.DecodeIpStringToNodeServerAddressArray(ips,nsarr);
  end else begin
    cbTryOnlyWithThisServers.Checked := false;
    nsarr := TConnectionManager.NetData.GetValidNodeServers(false,0);
  end;
  for i := low(nsarr) to high(nsarr) do begin
    aux := nsarr[i].ip;
    if nsarr[i].port>0 then aux := aux +':'+ InttoStr(nsarr[i].port);
    memoNodesIp.Lines.Add( aux );
  end;
  if cbTryOnlyWithThisServers.Checked then begin
    cbTryOnlyWithThisServers.Font.Color := clRed;
    cbTryOnlyWithThisServers.Font.Style := [fsBold];
  end else begin
    cbTryOnlyWithThisServers.ParentFont := true;
  end;
  setlength(nsarr,0);
end;

procedure TFRMNodesIp.SetAppParams(const Value: TAppParams);
begin
  FAppParams := Value;
  PrepareData;
end;

end.
