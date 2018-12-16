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
  ExtCtrls, ComCtrls, MicroCoin.Application.Settings, UCrypto, UITypes,
  Vcl.Samples.Spin, Vcl.WinXCtrls, Styles, Themes;

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
    TabSheet1: TTabSheet;
    Label5: TLabel;
    cbSkin: TComboBox;
    swNewTransaction: TToggleSwitch;
    Label6: TLabel;
    Label7: TLabel;
    ToggleSwitch2: TToggleSwitch;
    Label8: TLabel;
    ToggleSwitch3: TToggleSwitch;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ToggleSwitch4: TToggleSwitch;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label12: TLabel;
    procedure radiousethiskeyClick(Sender: TObject);
    procedure radioRandomkeyClick(Sender: TObject);
    procedure radionewKeyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbSkinChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAppSettings: TAppSettings;
    procedure SetAppParams(const Value: TAppSettings);
    { Private declarations }
  public
    property AppParams : TAppSettings read FAppSettings write SetAppParams;
  end;

var
  SettingsForm: TSettingsForm;

implementation

uses UConst, MicroCoin.Node.Node, MicroCoin.Account.AccountKey;

resourcestring
  StrServerPortAndJSONRPCPortEquals = 'Server port and JSON RPC port are equ' +
  'al';

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
    MessageDlg(StrServerPortAndJSONRPCPortEquals, mtError, [mbOK], 0);
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
  then AppParams.Entries[TAppSettingsEntry.apMinerPrivateKeySelectedPublicKey].SetAsString(TNode.Node.KeyManager[cbMyKeys.ItemIndex].AccountKey.ToRawString );

  AppParams.Entries[TAppSettingsEntry.apInternetServerPort].SetAsInteger(editServerPort.Value);
  AppParams.Entries[TAppSettingsEntry.apMinerPrivateKeyType].SetAsInteger(xMiningMode);
  AppParams.Entries[TAppSettingsEntry.apJSONRPCMinerServerActive].SetAsBoolean(true);
  AppParams.Entries[TAppSettingsEntry.apMinerName].SetAsString(editMinerName.Text);
  AppParams.Entries[TAppSettingsEntry.apJSONRPCMinerServerPort].SetAsInteger(editMinerServerPort.Value);
  AppParams.Entries[TAppSettingsEntry.apJSONRPCEnabled].SetAsBoolean(checkEnableRPC.Checked);
  AppParams.Entries[TAppSettingsEntry.apJSONRPCAllowedIPs].SetAsString(memoAllowedIPs.Text);
  AppParams.Entries[TAppSettingsEntry.apTheme].SetAsString(cbSkin.Text);
  AppParams.Entries[TAppSettingsEntry.apNotifyOnNewTransaction].SetAsBoolean(swNewTransaction.State = TToggleSwitchState.tssOn);
  ModalResult := mrOk;
  CloseModal;
end;

procedure TSettingsForm.cbSkinChange(Sender: TObject);
begin
  TStylemanager.TrySetStyle(cbSkin.Text);
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  cbSkin.Clear;
  cbSkin.Items.AddStrings(TStyleManager.StyleNames);
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

procedure TSettingsForm.SetAppParams(const Value: TAppSettings);
var
  i: integer;
  xSelectedKey: AnsiString;
begin
  FAppSettings := Value;
  cbSkin.ItemIndex := cbSkin.Items.IndexOf(AppParams.Entries[TAppSettingsEntry.apTheme].GetAsString('MicroCoin Light'));
  editMinerName.Text := AppParams.Entries[TAppSettingsEntry.apMinerName].GetAsString('');
  editMinerServerPort.Value := AppParams.Entries[TAppSettingsEntry.apJSONRPCMinerServerPort].GetAsInteger(cMinerServerPort);
  checkEnableRPC.Checked := AppParams.Entries[TAppSettingsEntry.apJSONRPCEnabled].GetAsBoolean(false);
  memoAllowedIPs.Text := AppParams.Entries[TAppSettingsEntry.apJSONRPCAllowedIPs].GetAsString('127.0.0.1;');
  editServerPort.Value := AppParams.Entries[TAppSettingsEntry.apInternetServerPort].GetAsInteger(cNetServerPort);
  if AppParams.Entries[TAppSettingsEntry.apNotifyOnNewTransaction].GetAsBoolean(true)
  then swNewTransaction.State := TToggleSwitchState.tssOn
  else swNewTransaction.State := TToggleSwitchState.tssOff;

  case AppParams.Entries[TAppSettingsEntry.apMinerPrivateKeyType].GetAsInteger(Integer(1)) of
    0 : radionewKey.Checked := true;
    1 : radioRandomkey.Checked := true;
    2 : radiousethiskey.Checked := true;
    else radioRandomkey.Checked := true;
  end;

  xSelectedKey := FAppSettings.Entries[TAppSettingsEntry.apMinerPrivateKeySelectedPublicKey].GetAsString('');

  for i := 0 to TNode.Node.KeyManager.Count-1 do begin
    cbMyKeys.AddItem(TNode.Node.KeyManager[i].Name, TNode.Node.KeyManager[i].PrivateKey);
    if TNode.Node.KeyManager[i].AccountKey.Equals( TAccountKey.FromRawString(xSelectedKey) )
    then cbMyKeys.ItemIndex := i;
  end;
end;

end.
