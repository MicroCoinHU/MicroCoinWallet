unit UFRMAbout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ Copyright (c) 2017 by MicroCoin Developers

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  }

interface

uses
{$IFnDEF FPC}
  pngimage, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  { TFRMAbout }

  TFRMAbout = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    bbClose: TBitBtn;
    lblBuild: TLabel;
    lblProtocolVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
    Procedure OpenURL(Url : String);
  public
    { Public declarations }
  end;

implementation

uses
{$IFnDEF FPC}
  ShellApi,
{$ELSE}
{$ENDIF}
  UFolderHelper, UConst, UNode;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
 resourcestring
   rsBlockChainPr = 'BlockChain Protocol: %d (%d)  -  Net Protocol: %d (%d)';
   rsBuild = 'Build: %s';

procedure TFRMAbout.FormCreate(Sender: TObject);
{$IFnDEF FPC}
Var fvi : TFileVersionInfo;
{$ENDIF}
begin
  {$IFDEF FPC}
  lblBuild.Caption :=  Format(rsBuild, [CT_ClientAppVersion]);
  {$ELSE}
  fvi := TFolderHelper.GetTFileVersionInfo(Application.ExeName);
  lblBuild.Caption :=  'Build: '+fvi.FileVersion;
  {$ENDIF}
  lblProtocolVersion.Caption := Format(rsBlockChainPr, [
    TNode.Node.Bank.SafeBox.CurrentProtocol, CT_BlockChain_Protocol_Available,
    CT_NetProtocol_Version, CT_NetProtocol_Available]);
end;

procedure TFRMAbout.Label4Click(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

procedure TFRMAbout.Label5Click(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

procedure TFRMAbout.Memo1Change(Sender: TObject);
begin

end;


procedure TFRMAbout.OpenURL(Url: String);
begin
  {$IFDEF FPC}
  OpenDocument(pchar(URL))
  {$ELSE}
  shellexecute(0, 'open', pchar(URL), nil, nil, SW_SHOW)
  {$ENDIF}
end;

end.
