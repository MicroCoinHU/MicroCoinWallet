unit MicroCoin.Components.Messages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MicroCoin.Net.ConnectionManager,
  MicroCoin.Net.Connection, MicroCoin.Node.Node;

type
  TMessagesFrame = class(TFrame)
    memoMessages: TMemo;
    lbNetConnections: TListBox;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    memoMessageToSend: TMemo;
    bbSendAMessage: TButton;
    procedure bbSendAMessageClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner : TComponent);
    { Public declarations }
  end;

implementation

{$R *.dfm}

resourcestring
  rsSendThisMess = 'Send this message to %s nodes?%sNOTE: Sending unauthorized'
    +' messages will be considered spam and you will be banned%s%sMessage: %s%s';
  rsSentTo = '%s Sent to %s > %s';
  rsMessageSentT = 'Message sent to %s nodes%sMessage: %s%s';


procedure TMessagesFrame.bbSendAMessageClick(Sender: TObject);
Var basem,m : String;
  them, errors : AnsiString;
  i,n : Integer;
  nc : TNetConnection;
begin
//  CheckIsReady;
  if (lbNetConnections.SelCount<=0) Or (lbNetConnections.ItemIndex<0)
    then raise Exception.Create('Select least one');
  if lbNetConnections.SelCount<=0 then n := 1
  else n := lbNetConnections.SelCount;

  basem := memoMessageToSend.Lines.Text;
  m := '';
  // Clear non valid characters:
  for i := 1 to length(basem) do begin
    if basem[i] in [#32..#127] then m := m + basem[i]
    else m:=m+'.';
  end;

  if trim(m)='' then raise Exception.Create('No message');

  if Application.MessageBox(PChaR(Format(rsSendThisMess, [inttostr(n), #10,
    #10, #10, #10, m])), PChar(Application.Title), MB_ICONQUESTION+MB_YESNO+
    MB_DEFBUTTON1)<>IdYes then exit;
  them := m;
  if n>1 then begin
    for i := 0 to lbNetConnections.Items.Count - 1 do begin
      if lbNetConnections.Selected[i] then begin
        nc := TNetConnection(lbNetconnections.Items.Objects[i]);
        if TConnectionManager.NetData.ConnectionExistsAndActive(nc) then begin
          TNode.Node.SendNodeMessage(nc,m,errors);
          memoMessages.Lines.Add(Format(rsSentTo, [DateTimeToStr(now),
            nc.ClientRemoteAddr, m]));
        end;
      end;
    end;
  end else begin
    nc := TNetConnection(lbNetconnections.Items.Objects[lbNetconnections.ItemIndex]);
    if TConnectionManager.NetData.ConnectionExistsAndActive(nc) then begin
      TNode.Node.SendNodeMessage(nc,m,errors);
      memoMessages.Lines.Add(Format(rsSentTo, [DateTimeToStr(now),
        nc.ClientRemoteAddr, m]));
    end;
  end;

  Application.MessageBox(PChaR(Format(rsMessageSentT, [inttostr(n), #10, #10, m]
    )), PChar(Application.Title), MB_ICONINFORMATION+MB_OK);
end;

constructor TMessagesFrame.Create(AOwner: TComponent);
begin
  inherited;
  memoMessages.Lines.Clear;
  memoMessageToSend.Lines.Clear;
end;

end.
