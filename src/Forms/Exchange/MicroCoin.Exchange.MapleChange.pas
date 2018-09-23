unit MicroCoin.Exchange.MapleChange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, HttpSend, UJsonFunctions,
  ssl_openssl, ssl_openssl_lib, DateUtils, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  ShellApi,
  Vcl.ExtCtrls, Vcl.Buttons, PngBitBtn;

type
  TEntry = record
    Date: string;
    Price: string;
    Volume: string;
    Executed: string;
    Remaining: string;
    Side: string;
  end;

  TMapleChangeForm = class(TForm)
    bidList: TVirtualStringTree;
    Image1: TImage;
    PngBitBtn1: TPngBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bidListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure bidListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure bidListDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: string;
      const CellRect: TRect; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure bidListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure PngBitBtn1Click(Sender: TObject);
  private
    FBids : TPCJSONObject;
    FItems: array of TEntry;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MapleChangeForm: TMapleChangeForm;

implementation

{$R *.dfm}

procedure TMapleChangeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMapleChangeForm.FormCreate(Sender: TObject);
var
  xStrings : TStringList;
  xHttp: THTTPSend;
  i: integer;
begin
  xHttp := THTTPSend.Create;
  xStrings := TStringList.Create;
  try
    xHttp.Protocol := '1.1';
    xHttp.Headers.Add('Accept: */*');
    xHttp.AddPortNumberToHost := false;
    if xHttp.HTTPMethod('GET', 'https://maplechange.com/api/v2/order_book.json?market=mccbtc')
    then xStrings.LoadFromStream(xHttp.Document)
    else exit;
    FBids := TPCJSONObject( TPCJSONObject.ParseJSONValue(xStrings.Text) );
    SetLength(FItems, FBids.GetAsArray('bids').Count+FBids.GetAsArray('asks').Count);
    for I := 0 to FBids.GetAsArray('bids').Count-1 do
    begin
      FItems[i].Date := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('created_at').AsString('');
      FItems[i].Price := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('price').AsString('');
      FItems[i].Volume := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('volume').AsString('');
      FItems[i].Executed := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('executed_volume').AsString('');
      FItems[i].Remaining := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('remaining_volume').AsString('');
      FItems[i].Side := FBids.GetAsArray('bids').GetAsObject(i).GetAsVariant('side').AsString('');
    end;
    for I := 0 to FBids.GetAsArray('asks').Count-1 do
    begin
      FItems[i+FBids.GetAsArray('bids').Count].Date := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('created_at').AsString('');
      FItems[i+FBids.GetAsArray('bids').Count].Price := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('price').AsString('');
      FItems[i+FBids.GetAsArray('bids').Count].Volume := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('volume').AsString('');
      FItems[i+FBids.GetAsArray('bids').Count].Executed := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('executed_volume').AsString('');
      FItems[i+FBids.GetAsArray('bids').Count].Remaining := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('remaining_volume').AsString('');
      FItems[i+FBids.GetAsArray('bids').Count].Side := FBids.GetAsArray('asks').GetAsObject(i).GetAsVariant('side').AsString('');
    end;
    bidList.NodeDataSize := sizeof(TEntry);
    bidList.RootNodeCount := Length(FItems);
  finally
    xHttp.Free;
    xStrings.Free;
  end;

end;

procedure TMapleChangeForm.FormDestroy(Sender: TObject);
var i : integer;
begin
  for i := Low(FItems) to High(FItems)
  do begin
   FItems[i].Date := '';
   FItems[i].Volume := '';
   FItems[i].Price := '';
   FItems[i].Executed := '';
   FItems[i].Remaining := '';
  end;
  FreeAndNil(FBids);
  SetLength(FItems, 0);
end;

procedure TMapleChangeForm.PngBitBtn1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://maplechange.com/?ref=6737', nil, nil, SW_SHOWNORMAL);
end;

procedure TMapleChangeForm.bidListDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
begin
  if TEntry(Node.GetData^).Side='sell'
  then TargetCanvas.Font.Color := clRed
  else TargetCanvas.Font.Color := clGreen;
end;

procedure TMapleChangeForm.bidListFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TEntry(Node.GetData^) := Default(TEntry);
end;

procedure TMapleChangeForm.bidListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  case Column of
    0: CellText := TEntry(Node.GetData^).Date;
    1: CellText := TEntry(Node.GetData^).Volume + ' MCC';
    2: CellText := TEntry(Node.GetData^).Price+ ' BTC';
    3: CellText := TEntry(Node.GetData^).Executed + ' MCC';
    4: CellText := TEntry(Node.GetData^).Remaining + ' MCC';
    5: CellText := TEntry(Node.GetData^).Side;
  end;
end;

procedure TMapleChangeForm.bidListInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Sender.SetNodeData(Node, FItems[Node.Index]);
end;

end.

