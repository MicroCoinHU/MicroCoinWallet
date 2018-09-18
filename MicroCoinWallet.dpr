program MicroCoinWallet;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  windows,
  Forms,
  Classes,
  MicroCoin.Forms.MainForm,
  sysutils,
  Vcl.Themes,
  Vcl.Styles;

procedure GetBuildInfo(var V1, V2, V3, V4: word);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
      GetMem(VerInfo, VerInfoSize);
      try
        if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
        begin
          VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
        end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
  end;
end;

function GetBuildInfoAsString: string;
var
  V1, V2, V3, V4: word;
begin
  GetBuildInfo(V1, V2, V3, V4);
  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' +
    IntToStr(V3) + '.' + IntToStr(V4);
end;

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
  Application.Initialize;
  {$IFDEF WINDOWS}
    GetLocaleFormatSettings(GetUserDefaultLCID, DefaultFormatSettings);
    DefaultFormatSettings.DecimalSeparator := '.';
    DefaultFormatSettings.ThousandSeparator := ',';
  {$ENDIF}
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.Title := 'MicroCoin Wallet - '+GetBuildInfoAsString{$IFDEF TESTNET}+' - TESTNET'{$ENDIF};
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
