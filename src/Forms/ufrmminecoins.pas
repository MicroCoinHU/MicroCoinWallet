unit UFRMMineCoins;
{$ifdef fpc}
  {$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils,  Forms, Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons,
  UBlockChain, UPoolMinerThreads,
    UPoolMining, ULog, UThread, UAccounts, UCrypto,
    UConst, UTime, UJSONFunctions, UNode, UNetProtocol, USha256,
    UOpenSSL {$ifdef unix},cthreads{$endif};

type

  { TFrmMineCoins }

  TFrmMineCoins = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    mmOutput: TMemo;
    StatusBar1: TStatusBar;
    tbCPUCount: TTrackBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
   FPoolMinerThread : TPoolMinerThread;
   devt:TCPUDeviceThread;
   FPrivateKey : TECPrivateKey;

  public
    procedure OnConnectionStateChanged(Sender : TObject);
    procedure OnDeviceStateChanged(Sender : TObject);
    procedure OnMinerValuesChanged(Sender : TObject);
    procedure OnFoundNOnce(Sender : TCustomMinerDeviceThread; Timestamp, nOnce : Cardinal);
  end;

var
  FrmMineCoins: TFrmMineCoins;

implementation

{$R *.lfm}

resourcestring
  rsMINING = 'MINING';
  rsNotMining = '*** Not mining ***';
  rsCurrentBlock = 'Current block: %d Wallet Name: "%s" Target: %s';
  rsHhNnSsBlockN = '%s Block:%s NOnce:%s Timestamp:%s Miner:%s';
  rsStarting = 'Starting...';
  rsStopping = 'Stopping...';
  rsStopped = 'Stopped';

procedure TFrmMineCoins.FormCreate(Sender: TObject);
begin
  tbCPUCount.Max := CPUCount;
end;

procedure TFrmMineCoins.OnConnectionStateChanged(Sender: TObject);
begin

end;

procedure TFrmMineCoins.OnDeviceStateChanged(Sender: TObject);
begin
  If Sender is TCustomMinerDeviceThread then begin
    If TCustomMinerDeviceThread(Sender).IsMining
    then StatusBar1.Panels[0].Text:=rsMINING // clear line
    else StatusBar1.Panels[0].Text:=(rsNotMining);
  end;
end;

procedure TFrmMineCoins.OnMinerValuesChanged(Sender: TObject);
begin
  exit;
  If Sender is TCustomMinerDeviceThread then begin
    If TCustomMinerDeviceThread(Sender).MinerValuesForWork.block>0 then begin
      mmOutput.Lines.Add(Format(rsCurrentBlock,
        [TCustomMinerDeviceThread(Sender).MinerValuesForWork.block,
         FPoolMinerThread.GlobalMinerValuesForWork.payload_start,
         IntToHex(TCustomMinerDeviceThread(Sender).MinerValuesForWork.target,8)
         ]));
    end;
  end;
end;

procedure TFrmMineCoins.OnFoundNOnce(Sender: TCustomMinerDeviceThread;
  Timestamp, nOnce: Cardinal);
begin
    mmOutput.Lines.Add(Format(rsHhNnSsBlockN, [FormatDateTime('hh:nn:ss', now),
      IntToStr(Sender.MinerValuesForWork.block), Inttostr(nOnce), inttostr(
      Timestamp), Sender.MinerValuesForWork.payload_start]));
end;


procedure TFrmMineCoins.BitBtn1Click(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:=rsStarting;
  FPrivateKey := TECPrivateKey.Create;
  FPrivateKey.GenerateRandomPrivateKey(CT_Default_EC_OpenSSL_NID);

  FPoolMinerThread := TPoolMinerThread.Create('127.0.0.1',CT_JSONRPCMinerServer_Port ,FPrivateKey.PublicKey);

  devt:= TCPUDeviceThread.Create(FPoolMinerThread,CT_TMinerValuesForWork_NULL);
  FPoolMinerThread.FreeOnTerminate:=True;
  devt.FreeOnTerminate:=true;
  devt.OnStateChanged := OnDeviceStateChanged;
  devt.OnMinerValuesChanged := OnMinerValuesChanged;
  devt.OnFoundNOnce:=OnFoundNOnce;
  TCPUDeviceThread(devt).CPUs:=tbCPUCount.Position;
  devt.Paused:=false;
  BitBtn2.Enabled:= True;
  BitBtn1.Enabled:= False;
  tbCPUCount.Enabled:= False;
end;

procedure TFrmMineCoins.BitBtn2Click(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:=rsStopping;
  try
   devt.Terminate;
   FPoolMinerThread.Terminate;
   while not devt.Terminated do;
  except on exception do
  end;
  try
    while not FPoolMinerThread.Terminated  do;  //then KillThread(FPoolMinerThread.Handle);
  except on exception do
  end;
  BitBtn2.Enabled:= False;
  BitBtn1.Enabled:= True;
  tbCPUCount.Enabled:= True;
 StatusBar1.Panels[0].Text:=rsStopped;
end;

end.

