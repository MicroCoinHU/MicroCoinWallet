unit MicroCoin.Exchange.MapleChange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, HttpSend, UJsonFunctions,
  ssl_openssl, ssl_openssl_lib, DateUtils, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  ShellApi,
  Vcl.ExtCtrls, Vcl.Buttons, PngBitBtn, PngSpeedButton, Vcl.ComCtrls;

type
  TEntry = record
    Date: TDateTime;
    Price: double;
    PriceHUF: double;
    Volume: double;
    Executed: double;
    Remaining: double;
    Side: string;
    RemainingHUF : double;
    Total : double;
    TotalHuf: double;
  end;

  TMapleChangeForm = class(TForm)
    Image1: TImage;
    PngBitBtn1: TPngSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    bidList: TVirtualStringTree;
    askList: TVirtualStringTree;
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
    procedure askListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    FBids : TPCJSONObject;
    FItems: array of TEntry;
    FItems2: array of TEntry;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MapleChangeForm: TMapleChangeForm;

implementation

uses Threading;

{$R *.dfm}

procedure TMapleChangeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMapleChangeForm.FormCreate(Sender: TObject);
begin
TTask.Create(procedure
function parse(A: string) : double;
var
  xVal : string;
begin
  xVal := StringReplace(a, '.', FormatSettings.DecimalSeparator, []);
  xVal := StringReplace(xVal, ',', FormatSettings.DecimalSeparator, []);
  Result := StrToFloat(xVal);
end;
var
  xStrings : TStringList;
  xHttp: THTTPSend;
  i: integer;
  xPrice : String;
  xHUF: double;
begin
  xHttp := THTTPSend.Create;
  xStrings := TStringList.Create;
  try
    xHttp.Protocol := '1.1';
    xHttp.Headers.Add('Accept: */*');
    xHttp.AddPortNumberToHost := false;
    if xHttp.HTTPMethod('GET', 'https://maplechange.com/api/v2/order_book.json?market=mccbtc&asks_limit=200&bids_limit=200')
    then xStrings.LoadFromStream(xHttp.Document)
    else exit;
    FBids := TPCJSONObject( TPCJSONObject.ParseJSONValue(xStrings.Text) );
    xStrings.Clear;
    xHttp.Free;
    xHttp := THTTPSend.Create;
    xHttp.Protocol := '1.1';
    xHttp.Headers.Add('Accept: */*');
    xHttp.AddPortNumberToHost := false;
    if xHttp.HTTPMethod('GET', 'https://api.coindesk.com/v1/bpi/currentprice/HUF.json')
    then xStrings.LoadFromStream(xHttp.Document);
    xHUF := TPCJSONObject( TPCJSONObject.ParseJSONValue(xStrings.Text) ).GetAsObject('bpi').GetAsObject('HUF').GetAsVariant('rate_float').AsDouble(0);
    SetLength(FItems, FBids.GetAsArray('bids').Count);
    SetLength(FItems2, FBids.GetAsArray('asks').Count);
    for I := 0 to FBids.GetAsArray('bids').Count-1 do
    begin
      with FBids.GetAsArray('bids').GetAsObject(i) do begin
        FItems[i].Date := ISO8601ToDate(GetAsVariant('created_at').AsString(''), false);
        FItems[i].Price := parse(GetAsVariant('price').AsString(''));
        FItems[i].PriceHUF := FItems[i].Price * xHuf;
        FItems[i].Volume := parse(GetAsVariant('volume').AsString(''));
        FItems[i].Executed := parse(GetAsVariant('executed_volume').AsString(''));
        FItems[i].Remaining := parse(GetAsVariant('remaining_volume').AsString(''));
        FItems[i].RemainingHUF := FItems[i].Remaining*FItems[i].Price*xHuf;
        FItems[i].Total := FItems[i].Remaining*FItems[i].Price;
        FItems[i].TotalHuf := FItems[i].Remaining*FItems[i].Price*xHuf;
        FItems[i].Side := 'buy';
      end;
    end;
    for I := 0 to FBids.GetAsArray('asks').Count-1 do
    begin
      with FBids.GetAsArray('asks').GetAsObject(i) do begin
        FItems2[i].Side := 'sell';
        FItems2[i].Date := ISO8601ToDate(GetAsVariant('created_at').AsString(''), false);
        FItems2[i].Price := parse(GetAsVariant('price').AsString(''));
        FItems2[i].PriceHUF := FItems2[i].Price * xHuf;
        FItems2[i].Volume := parse(GetAsVariant('volume').AsString(''));
        FItems2[i].Executed := parse(GetAsVariant('executed_volume').AsString(''));
        FItems2[i].Remaining := parse(GetAsVariant('remaining_volume').AsString(''));
        FItems2[i].RemainingHUF := FItems2[i].Remaining*FItems2[i].Price*xHuf;
        FItems2[i].Total := FItems2[i].Remaining*FItems2[i].Price;
        FItems2[i].TotalHuf := FItems2[i].Remaining*FItems2[i].Price*xHuf;
      end;
    end;
    TThread.Synchronize(nil, procedure begin
      bidList.NodeDataSize := sizeof(TEntry);
      bidList.RootNodeCount := Length(FItems);
      askList.NodeDataSize := sizeof(TEntry);
      askList.RootNodeCount := Length(FItems2);
    end);
  finally
    xHttp.Free;
    xStrings.Free;
  end;
end).Start;

end;

procedure TMapleChangeForm.FormDestroy(Sender: TObject);
var i : integer;
begin
  FreeAndNil(FBids);
  SetLength(FItems, 0);
end;

procedure TMapleChangeForm.PngBitBtn1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://maplechange.com/?ref=6737', nil, nil, SW_SHOWNORMAL);
end;

procedure TMapleChangeForm.askListInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Sender.SetNodeData(Node, FItems2[Node.Index]);
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
    0: CellText := FormatDateTime('c',  TEntry(Node.GetData^).Date);
    1: CellText := Format('%.4n MCC',  [TEntry(Node.GetData^).Volume]);
    2: CellText := Format('%.8n BTC',  [TEntry(Node.GetData^).Price]);
    3: CellText := Format('%.4n Ft',   [TEntry(Node.GetData^).PriceHUF]);
    4: CellText := Format('%.4n MCC',  [TEntry(Node.GetData^).Executed]);
    5: CellText := Format('%.4n MCC',  [TEntry(Node.GetData^).Remaining]);
    6: CellText := Format('%.8n BTC',  [TEntry(Node.GetData^).Total]);
    7: CellText := Format('%.4n Ft',   [TEntry(Node.GetData^).TotalHUF]);
  end;
end;

procedure TMapleChangeForm.bidListInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Sender.SetNodeData(Node, FItems[Node.Index]);
end;

end.

