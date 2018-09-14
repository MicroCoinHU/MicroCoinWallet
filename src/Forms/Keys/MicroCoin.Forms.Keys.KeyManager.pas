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
| File:       MicroCoin.Forms.Keys.KeyManager.pas
| Created at: 2018-09-11
| Purpose:    Wallet key manager dialog
|==============================================================================}

unit MicroCoin.Forms.Keys.KeyManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, PngImageList, Vcl.PlatformDefaultStyleActnCtrls, System.Actions,
  Vcl.ActnList, Vcl.ActnMan, VirtualTrees, Vcl.Menus, Vcl.ActnPopup,
  Vcl.ToolWin, Vcl.ActnCtrls, UCrypto, UITypes;

type
  TWalletKeysForm = class(TForm)
    WalletKeyActions: TActionManager;
    keyList: TVirtualStringTree;
    WalletKeysToolbar: TActionToolBar;
    EditNameAction: TAction;
    ActionImages: TPngImageList;
    ExportPublicKey: TAction;
    ExportPrivateKey: TAction;
    DeleteKey: TAction;
    ListPopupMenu: TPopupActionBar;
    ExportPublicKey1: TMenuItem;
    ExportPrivateKey1: TMenuItem;
    Renamekey1: TMenuItem;
    N1: TMenuItem;
    DeleteKey1: TMenuItem;
    N2: TMenuItem;
    ImportPrivateKey: TAction;
    ImportPublicKey: TAction;
    SaveAll: TAction;
    ImportAll: TAction;
    AddNewKey: TAction;
    Secp256k1: TAction;
    Secp384r1: TAction;
    Sect283k1: TAction;
    Secp521r1: TAction;
    SaveKeysDialog: TSaveDialog;
    ChangePasswordAction: TAction;
    OpenWalletDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure keyListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure keyListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure EditNameActionUpdate(Sender: TObject);
    procedure ExportPublicKeyUpdate(Sender: TObject);
    procedure ExportPrivateKeyUpdate(Sender: TObject);
    procedure DeleteKeyUpdate(Sender: TObject);
    procedure ImportPrivateKeyUpdate(Sender: TObject);
    procedure ImportPublicKeyUpdate(Sender: TObject);
    procedure SaveAllUpdate(Sender: TObject);
    procedure ImportAllUpdate(Sender: TObject);
    procedure AddNewKeyUpdate(Sender: TObject);
    procedure EditNameActionExecute(Sender: TObject);
    procedure AddNewKeyExecute(Sender: TObject);
    procedure DeleteKeyExecute(Sender: TObject);
    procedure ExportPublicKeyExecute(Sender: TObject);
    procedure ExportPrivateKeyExecute(Sender: TObject);
    procedure ImportPublicKeyExecute(Sender: TObject);
    procedure ImportPrivateKeyExecute(Sender: TObject);
    procedure SaveAllExecute(Sender: TObject);
    procedure ImportAllExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChangePasswordActionExecute(Sender: TObject);
  private
    function UnlockWallet : Boolean;
    function ParseRawKey(AEC_OpenSSL_NID : Word; AEncodedKey : string) : TECPrivateKey;
    function ParseEncryptedKey(APassword, AKey: AnsiString) : TECPrivateKey;
  public
    { Public declarations }
  end;

var
  WalletKeysForm: TWalletKeysForm;

implementation

uses MicroCoin.Node.Node, MicroCoin.Account.AccountKey, UWalletKeys, PlatformVclStylesActnCtrls,
     UConst, Clipbrd, UAES;

{$R *.dfm}

procedure TWalletKeysForm.AddNewKeyExecute(Sender: TObject);
var
  xKey: TECPrivateKey;
  xName: string;
begin
  if not UnlockWallet then exit;
  if InputQuery('Key name:', 'Enter name:', xName) then begin
    xKey := TECPrivateKey.Create;
    xKey.GenerateRandomPrivateKey(TAction(Sender).Tag);
    TNode.Node.KeyManager.AddPrivateKey(xName, xKey);
    FreeAndNil(xKey);
    keyList.RootNodeCount := TNode.Node.KeyManager.Count;
    keyList.ReinitNode(nil, true);
  end;
end;

procedure TWalletKeysForm.AddNewKeyUpdate(Sender: TObject);
begin
  AddNewKey.Enabled := true;
end;

procedure TWalletKeysForm.ChangePasswordActionExecute(Sender: TObject);
var
  xPassword: array[0..1] of string;
begin
  if not UnlockWallet then exit;
  repeat
    if not InputQuery('Change wallet password', [#30+'New password', #30+'Password again'], xPassword)
    then exit;
    if xPassword[0] <> xPassword[1]
    then MessageDlg('Passwords not match', mtError, [mbOk], 0)
    else break;
  until true;
  TNode.Node.KeyManager.WalletPassword := xPassword[0];
  MessageDlg('Password changed', mtInformation, [mbOK], 0);
end;

procedure TWalletKeysForm.DeleteKeyExecute(Sender: TObject);
begin
  if not UnlockWallet then exit;
  if MessageDlg('Do you want to DELETE this key? Delete is unreversible!!!', mtWarning, [mbYes, mbNo], 0) = mrYes
  then begin
    TNode.Node.KeyManager.Delete(keyList.FocusedNode.Index);
    keyList.RootNodeCount := TNode.Node.KeyManager.Count;
    keyList.ReinitNode(nil, true);
  end;
end;

procedure TWalletKeysForm.DeleteKeyUpdate(Sender: TObject);
begin
  DeleteKey.Enabled := keyList.FocusedNode<>nil;
end;

procedure TWalletKeysForm.EditNameActionExecute(Sender: TObject);
var
  xName: String;
begin
  if not UnlockWallet then exit;
  if InputQuery('Change name','Input new key name:',xName) then begin
    if xName = '' then exit;
    TNode.Node.KeyManager.SetName(keyList.FocusedNode.Index, xName);
    keyList.ReinitNode(keyList.FocusedNode, true);
  end;
end;

procedure TWalletKeysForm.EditNameActionUpdate(Sender: TObject);
begin
  EditNameAction.Enabled := keyList.FocusedNode<>nil;
end;

procedure TWalletKeysForm.ExportPrivateKeyExecute(Sender: TObject);
var
  xPass: array[0..1] of string;
begin
  if not UnlockWallet then exit;
  if InputQuery('Encrypt exported key', [#30+'Enter password', #30+'Repeat password'], {$IFDEF FPC}true,{$ENDIF} xPass)
  then begin
    if xPass[0]<>xPass[1] then raise Exception.Create('Passwords not match');
    if xPass[0]<>''
    then Clipboard.AsText := TCrypto.ToHexaString( TAESComp.EVP_Encrypt_AES256( TNode.Node.KeyManager[keyList.FocusedNode.Index].PrivateKey.ExportToRaw, xPass[0]) )
    else Clipboard.AsText := TCrypto.PrivateKey2Hexa(TNode.Node.KeyManager[keyList.FocusedNode.Index].PrivateKey);
    MessageDlg('Private key copied to clipboard', mtInformation, [mbOk], 0);
  end else exit;
end;

procedure TWalletKeysForm.ExportPrivateKeyUpdate(Sender: TObject);
begin
  ExportPrivateKey.Enabled := keyList.FocusedNode<>nil;
end;

procedure TWalletKeysForm.ExportPublicKeyExecute(Sender: TObject);
begin
  if not UnlockWallet then exit;
  Clipboard.AsText := TWalletKey(keyList.FocusedNode.GetData^).AccountKey.AccountPublicKeyExport;
  MessageDlg('Public key copied to clipboard', mtInformation, [mbOk], 0);
end;

procedure TWalletKeysForm.ExportPublicKeyUpdate(Sender: TObject);
begin
  ExportPublicKey.Enabled := keyList.FocusedNode<>nil;
end;

procedure TWalletKeysForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TNode.Node.KeyManager.LockWallet;
  Action := caFree;
end;

procedure TWalletKeysForm.FormCreate(Sender: TObject);
begin
  keyList.NodeDataSize := SizeOf(TWalletKey);
  keyList.RootNodeCount := TNode.Node.KeyManager.Count;
  WalletKeyActions.Style := PlatformVclStylesStyle;
end;

procedure TWalletKeysForm.ImportAllExecute(Sender: TObject);
var
  xKeys: TWalletKeys;
  xPassword: string;
  i: integer;
begin
  if OpenWalletDialog.Execute then begin
    xKeys := TWalletKeys.Create(nil);
    xKeys.WalletFileName := OpenWalletDialog.FileName;
    if not xKeys.IsValidPassword then begin
      if not InputQuery('Import keys', #30+'Enter password', xPassword)
      then exit;
        xKeys.WalletPassword := xPassword;
        if not xKeys.IsValidPassword
        then begin
          MessageDlg('Invalid password', mtError, [mbOk], 0);
          exit;
        end;
      end;
      for i := 0 to xKeys.Count-1 do begin
        if TNode.Node.KeyManager.IndexOfAccountKey(xKeys[i].AccountKey) > -1
        then continue;
        if assigned(xKeys[i].PrivateKey)
        then TNode.Node.KeyManager.AddPrivateKey(xKeys[i].Name, xKeys[i].PrivateKey)
        else TNode.Node.KeyManager.AddPublicKey(xKeys[i].Name, xKeys[i].AccountKey);
      end;
      FreeAndNil(xKeys);
      keyList.RootNodeCount := TNode.Node.KeyManager.Count;
      keyList.ReinitNode(nil, true);
  end;
end;

procedure TWalletKeysForm.ImportAllUpdate(Sender: TObject);
begin
  ImportAll.Enabled := true;
end;

function TWalletKeysForm.ParseRawKey(AEC_OpenSSL_NID : Word; AEncodedKey : string) : TECPrivateKey;
begin
  Result := TECPrivateKey.Create;
  Try
    Result.SetPrivateKeyFromHexa(AEC_OpenSSL_NID, TCrypto.ToHexaString(AEncodedKey));
  Except
    On E:Exception do begin
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TWalletKeysForm.ParseEncryptedKey(APassword, AKey: AnsiString) : TECPrivateKey;
var
  xDecryptedKey: AnsiString;
begin
  Result := nil;
  if TAESComp.EVP_Decrypt_AES256(AKey, APassword, xDecryptedKey) then begin
    if (xDecryptedKey<>'') then begin
      Result := TECPrivateKey.ImportFromRaw(xDecryptedKey);
      Exit;
    end
  end;
end;


procedure TWalletKeysForm.ImportPrivateKeyExecute(Sender: TObject);
var
  xRawkey, xEncodedKey: string;
  xData: array[0..2] of string;
  xResult: TECPrivateKey;
begin
  if not UnlockWallet then exit;
  if not InputQuery('Import private key', ['Name', 'Private key', #30+'Password'], xData )
  then exit;
  xData[0] := trim(xData[0]);
  xData[1] := trim(xData[1]);
  xData[2] := trim(xData[2]);
  if xData[1] = '' then exit;
  xEncodedKey := TCrypto.HexaToRaw(xData[1]);
  if xEncodedKey = '' then begin
    MessageDlg('Invalid key', mtError, [mbOk], 0);
    exit;
  end;
  case Length(xEncodedKey) of
       32: xResult := ParseRawKey(CT_NID_secp256k1, xEncodedKey);
       35,36: xResult := ParseRawKey(CT_NID_sect283k1, xEncodedKey);
       48: xResult := ParseRawKey(CT_NID_secp384r1, xEncodedKey);
       65,66: xResult := ParseRawKey(CT_NID_secp521r1, xEncodedKey);
       64, 80, 96: xResult := ParseEncryptedKey(xData[2], xEncodedKey);
       else begin
          MessageDlg('Invalid key', mtError, [mbOk], 0);
          exit;
       end;
  end;
  if xResult = nil then begin
    MessageDlg('Invalid key or password', mtError, [mbOk], 0);
    exit;
  end;
  if xData[0] = ''
  then xData[0] := DateTimeToStr(Now);
  TNode.Node.KeyManager.AddPrivateKey(xData[0], xResult);
  keyList.RootNodeCount := TNode.Node.KeyManager.Count;
  keyList.ReinitNode(nil, true);
end;

procedure TWalletKeysForm.ImportPrivateKeyUpdate(Sender: TObject);
begin
  ImportPrivateKey.Enabled := true;
end;

procedure TWalletKeysForm.ImportPublicKeyExecute(Sender: TObject);
var
  xData : array[0..1] of string;
  xAccountKey: TAccountKey;
  xErrors: AnsiString;
  xRawKey: string;
begin
  if not UnlockWallet then exit;
  if not InputQuery('Import public key', ['Key name', 'Encoded public key'], xData)
  then exit;
  if not TAccountKey.AccountPublicKeyImport(xData[1], xAccountKey, xErrors)
  then begin
    xRawKey := TCrypto.HexaToRaw(xData[1]);
    if trim(xRawKey)='' then begin
      MessageDlg(xErrors, mtError, [mbOk], 0);
      exit;
    end;
   xAccountKey := TAccountKey.FromRawString(xRawKey);
  end;
  if not xAccountKey.IsValidAccountKey(xErrors)
  then begin
    MessageDlg(xErrors, mtError, [mbOk], 0);
    exit;
  end;
  if TNode.Node.KeyManager.IndexOfAccountKey(xAccountKey) > -1
  then begin
    MessageDlg('Account key already exists in wallet', mtInformation, [mbOk], 0);
    exit;
  end;
  if xData[0] = ''
  then xData[0] := DateTimeToStr(Now);
  TNode.Node.KeyManager.AddPublicKey(xData[0], xAccountKey);
  keyList.RootNodeCount := TNode.Node.KeyManager.Count;
  keyList.ReinitNode(nil, true);
end;

procedure TWalletKeysForm.ImportPublicKeyUpdate(Sender: TObject);
begin
  ImportPublicKey.Enabled := true;
end;

procedure TWalletKeysForm.keyListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  xKey: TWalletKey;
begin
  xKey := TWalletKey(Node.GetData^);
  case Column of
    0: CellText := UTF8ToString(xKey.Name);
    1: CellText := TAccountKey.GetECInfoTxt(xKey.AccountKey.EC_OpenSSL_NID);
    2: if Assigned(xKey.PrivateKey) then CellText := 'Private & Public key' else CellText := 'Public key';
  end;
end;

procedure TWalletKeysForm.keyListInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Sender.SetNodeData(Node, TNode.Node.KeyManager[Node.Index]);
end;

procedure TWalletKeysForm.SaveAllExecute(Sender: TObject);
var
  xStream : TStream;
  xFilename: TFilename;
begin
  if SaveKeysDialog.Execute then begin
    xFilename := SaveKeysDialog.FileName;
    xStream := TFileStream.Create(xFilename, fmCreate);
    try
      TNode.Node.KeyManager.SaveToStream(xStream);
      MessageDlg(Format('Wallet saved to %s', [xFilename]), mtInformation, [mbOk], 0);
    finally
      FreeAndNil(xStream);
    end;
  end;
end;

procedure TWalletKeysForm.SaveAllUpdate(Sender: TObject);
begin
  SaveAll.Enabled := keyList.RootNodeCount > 0;
end;

function TWalletKeysForm.UnlockWallet: Boolean;
var
  xPassword: string;
begin
  Result := TNode.Node.KeyManager.IsValidPassword;
  while not TNode.Node.KeyManager.IsValidPassword
  do begin
    if not InputQuery('Unlock wallet', #30+'Your password:', xPassword)
    then exit;
    TNode.Node.KeyManager.WalletPassword := xPassword;
  end;
  Result := TNode.Node.KeyManager.IsValidPassword;
end;

end.
