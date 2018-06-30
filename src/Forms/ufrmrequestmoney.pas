unit UFRMRequestMoney;
{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils, {$ifdef fpc}MaskEdit,FileUtil,{$endif} Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons,  ubarcodes, unode, UAccounts, UOpTransaction, UBlockChain,
  UWalletKeys, UECIES;

type

  { TRequestMoneyForm }

  TRequestMoneyForm = class(TForm)
    BitBtn1: TBitBtn;
    Amount: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure AmountChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    FNodeNotifyEvents : TNodeNotifyEvents;
    FAccount: string;
    FWalletKeys : TWalletKeys;
    FNode : TNode;
    FPaymentId : string;
  public
    BarcodeQR1: TBarcodeQR;
    class procedure RequestMoney(Owner: TComponent; ANode : TNode; account : string; AWalletKeys : TWalletKeys);
    constructor Create(AOwner: TComponent; ANode : TNode); overload;
    procedure OnOperationsChanged(Sender : TObject);
  end;

var
  RequestMoneyForm: TRequestMoneyForm;

implementation

{$R *.lfm}

{ TRequestMoneyForm }

procedure TRequestMoneyForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TRequestMoneyForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FreeAndNil(FNodeNotifyEvents);
end;

procedure TRequestMoneyForm.AmountChange(Sender: TObject);
begin
  BarcodeQR1.Text:= '{"account":"'+FAccount+'","amount":"'+Amount.Text+'","payload":"'+Memo1.Text+' PaymentId='+FPaymentId+'"}';
end;

procedure TRequestMoneyForm.FormCreate(Sender: TObject);
var
i : integer;
begin
  BarcodeQR1:= TBarcodeQR.Create(Self);
  BarcodeQR1.Parent := self;
  BarcodeQR1.BackgroundColor:= clWhite;

  BarcodeQR1.StrictSize:=true;
  BarcodeQR1.Height:= 320;
  BarcodeQR1.Width:= 320;
  BarcodeQR1.Top:=203;
  BarcodeQR1.Left:=228;
  BarcodeQR1.Visible:= True;
  for i:=1 to 10 do FPaymentId:= FPaymentId + Chr(ord('a') + Random(26));
  BarcodeQR1.Text:= '{"account":"'+FAccount+'","amount":"'+Amount.Text+'","payload":"'+Memo1.Text+' PaymentId='+FPaymentId+'"}';
end;

procedure TRequestMoneyForm.FormShow(Sender: TObject);
begin
  Amount.SelectAll;
  Amount.SetFocus;
end;

procedure TRequestMoneyForm.Memo1Change(Sender: TObject);
begin
  BarcodeQR1.Text:= '{"account":"'+FAccount+'","amount":"'+Amount.Text+'","payload":"'+Memo1.Text+' PaymentId='+FPaymentId+'"}';
end;

class procedure TRequestMoneyForm.RequestMoney(Owner: TComponent;  ANode : TNode; account: string; AWalletKeys : TWalletKeys);
begin
  RequestMoneyForm := TRequestMoneyForm.Create(owner, ANode);
  RequestMoneyForm.FNodeNotifyEvents := TNodeNotifyEvents.Create(RequestMoneyForm);
  RequestMoneyForm.FNodeNotifyEvents.OnOperationsChanged:= RequestMoneyForm.OnOperationsChanged;
  RequestMoneyForm.FNodeNotifyEvents.Node := ANode;
  RequestMoneyForm.FAccount := account;
  RequestMoneyForm.FWalletKeys := AWalletKeys;
//  RequestMoneyForm.BarcodeQR1.Text:= '{"account":"'+account+'","amount":"'+RequestMoneyForm.Amount.Text+'","payload":"'+RequestMoneyForm.Memo1.Text+'"}';
  RequestMoneyForm.ShowModal;
end;

constructor TRequestMoneyForm.Create(AOwner: TComponent; ANode : TNode);
begin
  FNode := ANode;
  inherited Create(AOwner);
end;

procedure TRequestMoneyForm.OnOperationsChanged(Sender: TObject);
var
   i,j : integer;
   Op : TPCOperation;
   OPR : TOperationResume;
   an : cardinal;
   Decrypted : String;
   WalletKey: TWalletKey;
   Result : Boolean;
begin
  for i:=0 to TNodeNotifyEvents(Sender).Node.Operations.Count - 1 do begin
     Op := TNodeNotifyEvents(Sender).Node.Operations.Operation[i];
     Op := TNodeNotifyEvents(Sender).Node.Operations.OperationsHashTree.GetOperation(i);
     TPCOperation.OperationToOperationResume(0,Op,Op.SignerAccount,OPR);
     if(TAccountComp.AccountNumberToAccountTxtNumber(OPR.DestAccount) <> Faccount) then
     begin
       continue;
     end;
     an := OPR.DestAccount;
     if (an<0) then continue;
     if FWalletKeys.IndexOfAccountKey(FNode.Bank.SafeBox.Account(an).accountInfo.accountkey)<0 then continue;
     Result:=False;
     for j := 0 to FWalletKeys.Count - 1 do begin
      WalletKey := FWalletKeys.Key[j];
      If Assigned(WalletKey.PrivateKey) then begin
       If ECIESDecrypt(WalletKey.PrivateKey.EC_OpenSSL_NID,WalletKey.PrivateKey.PrivateKey,false,OPR.OriginalPayload,Decrypted) then begin
         Result := true;
         break;
       end;
      end;
     end;
     if(pos(FPaymentId, Decrypted)>0) then begin
          MessageDlg('Az utalás megérkezett', Format('Utalás érkezett %s számláról %s számlára. Összeg: %s, Üzenet: %s',[
             TAccountComp.AccountNumberToAccountTxtNumber(OPR.AffectedAccount),
             TAccountComp.AccountNumberToAccountTxtNumber(OPR.DestAccount),
             TAccountComp.FormatMoney(-1*OPR.Amount),
             Decrypted
          ]),mtInformation,[mbOK],'');
     end;
     Close;
     exit;
  end;
end;

end.

