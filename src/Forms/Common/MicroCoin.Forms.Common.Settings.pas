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
| File:       MicroCoin.Forms.Common.Settings.pas                              |
| Created at: 2018-09-13                                                       |
| Purpose:    Form for wallet and miner server configuration                   |
|==============================================================================}

unit MicroCoin.Forms.Common.Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, PngBitBtn,
  ExtCtrls, ComCtrls, UAppParams, UCrypto, UITypes,
  Vcl.Samples.Spin;

type
  TSettingsForm = class(TForm)
    PageControl1: TPageControl;
    MiningTab: TTabSheet;
    NetOptions: TTabSheet;
    editMinerName: TLabeledEdit;
    editMinerServerPort: TSpinEdit;
    Label1: TLabel;
    Panel1: TPanel;
    radionewKey: TRadioButton;
    radioRandomkey: TRadioButton;
    radiousethiskey: TRadioButton;
    cbMyKeys: TComboBox;
    Panel2: TPanel;
    btnSave: TPngBitBtn;
    btnCancel: TPngBitBtn;
    editServerPort: TSpinEdit;
    Label2: TLabel;
    checkEnableRPC: TCheckBox;
    editJSONRPCPort: TSpinEdit;
    Label3: TLabel;
    memoAllowedIPs: TMemo;
    Label4: TLabel;
    procedure radiousethiskeyClick(Sender: TObject);
    procedure radioRandomkeyClick(Sender: TObject);
    procedure radionewKeyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FAppParams: TAppParams;
    procedure SetAppParams(const Value: TAppParams);
    { Private declarations }
  public
    property AppParams : TAppParams read FAppParams write SetAppParams;
  end;

var
  SettingsForm: TSettingsForm;

implementation

uses UConst, MicroCoin.Node.Node, MicroCoin.Account.AccountKey;

{$R *.dfm}

procedure TSettingsForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  CloseModal;
end;

procedure TSettingsForm.btnSaveClick(Sender: TObject);
var
  xMiningMode: integer;
begin
  if editMinerServerPort.Value = editJSONRPCPort.Value
  then begin
    MessageDlg('Server port and JSON RPC port are equal', mtError, [mbOK], 0);
    exit;
  end;
  xMiningMode := 0;

  if radiousethiskey.Checked
  then xMiningMode := 2
  else if radioRandomkey.Checked
       then xMiningMode := 1
       else if radionewKey.Checked
            then xMiningMode := 0;

  if radiousethiskey.Checked
  then AppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey].SetAsString(TNode.Node.KeyManager[cbMyKeys.ItemIndex].AccountKey.ToRawString );

  AppParams.ParamByName[CT_PARAM_InternetServerPort].SetAsInteger(editServerPort.Value);
  AppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].SetAsInteger(xMiningMode);
  AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerActive].SetAsBoolean(true);
  AppParams.ParamByName[CT_PARAM_MinerName].SetAsString(editMinerName.Text);
  AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].SetAsInteger(editMinerServerPort.Value);
  AppParams.ParamByName[CT_PARAM_JSONRPCEnabled].SetAsBoolean(checkEnableRPC.Checked);
  AppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].SetAsString(memoAllowedIPs.Text);
  ModalResult := mrOk;
  CloseModal;
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSettingsForm.radionewKeyClick(Sender: TObject);
begin
  cbMyKeys.Enabled := radiousethiskey.Checked;
end;

procedure TSettingsForm.radioRandomkeyClick(Sender: TObject);
begin
  cbMyKeys.Enabled := radiousethiskey.Checked;
end;

procedure TSettingsForm.radiousethiskeyClick(Sender: TObject);
begin
  cbMyKeys.Enabled := radiousethiskey.Checked;
end;

procedure TSettingsForm.SetAppParams(const Value: TAppParams);
var
  i: integer;
  xSelectedKey: AnsiString;
begin
  FAppParams := Value;
  editMinerName.Text := AppParams.ParamByName[CT_PARAM_MinerName].GetAsString('');
  editMinerServerPort.Value := AppParams.ParamByName[CT_PARAM_JSONRPCMinerServerPort].GetAsInteger(CT_JSONRPCMinerServer_Port);
  checkEnableRPC.Checked := AppParams.ParamByName[CT_PARAM_JSONRPCEnabled].GetAsBoolean(false);
  memoAllowedIPs.Text := AppParams.ParamByName[CT_PARAM_JSONRPCAllowedIPs].GetAsString('127.0.0.1;');
  editServerPort.Value := AppParams.ParamByName[CT_PARAM_InternetServerPort].GetAsInteger(CT_NetServer_Port);

  case AppParams.ParamByName[CT_PARAM_MinerPrivateKeyType].GetAsInteger(Integer(1)) of
    0 : radionewKey.Checked := true;
    1 : radioRandomkey.Checked := true;
    2 : radiousethiskey.Checked := true;
    else radioRandomkey.Checked := true;
  end;

  xSelectedKey := FAppParams.ParamByName[CT_PARAM_MinerPrivateKeySelectedPublicKey].GetAsString('');

  for i := 0 to TNode.Node.KeyManager.Count-1 do begin
    cbMyKeys.AddItem(TNode.Node.KeyManager[i].Name, TNode.Node.KeyManager[i].PrivateKey);
    if TNode.Node.KeyManager[i].AccountKey.Equals( TAccountKey.FromRawString(xSelectedKey) )
    then cbMyKeys.ItemIndex := i;
  end;
end;

end.
