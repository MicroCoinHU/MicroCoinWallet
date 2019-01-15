;|==============================================================================|
;| MicroCoin                                                                    |
;| Copyright (c) 2017-2018 MicroCoin Developers                                 |
;|==============================================================================|
;| Permission is hereby granted, free of charge, to any person obtaining a copy |
;| of this software and associated documentation files (the "Software"), to     |
;| deal in the Software without restriction, including without limitation the   |
;| rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  |
;| sell opies of the Software, and to permit persons to whom the Software is    |
;| furnished to do so, subject to the following conditions:                     |
;|                                                                              |
;| The above copyright notice and this permission notice shall be included in   |
;| all copies or substantial portions of the Software.                          |
;|------------------------------------------------------------------------------|
;| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   |
;| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
;| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  |
;| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       |
;| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      |
;| FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER          |
;| DEALINGS IN THE SOFTWARE.                                                    |
;|==============================================================================|
;| File:       setup.iss                                                        |
;| Created at: 2018-12-17                                                       |
;| Purpose:    MicroCoin Wallet Setup Project                                   |
;|==============================================================================|
;| Setup theme from: The road to delphi                                         |
;| https://github.com/RRUZ/vcl-styles-plugins                                   |
;|==============================================================================|


// Uncomment next line to digital sign executables & setup
#define sign 

#define MyAppName "MicroCoin"
#define MyAppVersion "1.3.5"
#define MyAppPublisher "MicroCoin"
#define MyAppURL "https://microcoin.hu"
#define MyAppExeName "MicroCoinWallet.exe"
#define VCLStyle "SlateClassico.vsf"

[Setup]
AppId={{A5A6FB7C-FCF0-45AA-AC9B-624792E07C07}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} - {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppCopyright=Copyright (C) 2017-2018 MicroCoin Developers
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
DisableWelcomePage=no
LicenseFile=License.rtf
OutputDir=output
OutputBaseFilename=MicroCoinSetup
SetupIconFile=MicroCoinWallet_Icon.ico
Compression=lzma
SolidCompression=yes
DefaultGroupName={#MyAppPublisher}
WizardImageFile=WizModernImage-IS_Orange.bmp
WizardSmallImageFile=MicroCoinWallet.bmp
AppComments=MicroCoin is a peer-to-peer Internet currency that enables instant, near-zero cost payments to anyone in the world.
#ifdef sign
SignTool=signtool
SignedUninstaller=true
#endif
;WindowVisible=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
Name: "desktopiconminer"; Description: "{cm:CreateDesktopIconForMiner}"; GroupDescription: "{cm:AdditionalIcons}"; Components: miner/gui
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Types]
Name: "full"; Description: "{cm:FullInstallation}";
Name: "custom"; Description: "{cm:CustomInstallation}"; Flags: iscustom

[Files]
// Wallet
Source: "..\..\bin\Win32\Release\MicroCoinWallet.exe"; DestDir: "{app}"; Flags: ignoreversion sign; Components: main/program
// OpenSSL
Source: "..\..\bin\Win32\Release\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: main\openssl
Source: "..\..\bin\Win32\Release\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: main\openssl 
// Localization
Source: "..\..\bin\Win32\Release\MicroCoinWallet.ENU"; DestDir: "{app}"; Flags: ignoreversion sign; Components: Translations\english
Source: "..\..\bin\Win32\Release\MicroCoinWallet.HUN"; DestDir: "{app}"; Flags: ignoreversion sign; Components: Translations\hungarian
// Miner
Source: "..\..\bin\Win32\Release\microcoinsha.cl"; DestDir: "{app}"; Flags: ignoreversion; Components: miner
Source: "..\..\bin\Win32\Release\MicroCoinMiner.exe"; DestDir: "{app}"; Flags: ignoreversion sign; Components: miner\gui
Source: "..\..\bin\Win32\Release\MicroCoinGUIMiner.exe"; DestDir: "{app}"; Flags: ignoreversion sign; Components: miner\console
// License
Source: "License.rtf"; DestDir: "{app}"; Flags: ignoreversion; Components: main
// Setup theme
Source: VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: {#VCLStyle}; DestDir: {app}; Flags: dontcopy

[Components]
Name: "main"; Description: "{cm:Wallet}"; Flags: fixed; Types: full custom;
Name: "main\program"; Description: "{cm:Program}"; Flags: fixed; Types: full custom;
Name: "main\openssl"; Description: "{cm:OpenSSL}"; Flags: fixed; Types: full custom;

Name: "miner"; Description: "{cm:Miner}"; Types: full custom;
Name: "miner\console"; Description: "{cm:ConsoleMiner}"; Types: full custom;
Name: "miner\gui"; Description: "{cm:GuiMiner}";

Name: "Translations"; Description: "{cm:Translations}"; Types: full custom;
Name: "Translations\english"; Description: "{cm:English}"; Types: full custom;
Name: "Translations\hungarian"; Description: "{cm:Hungarian}"; Types: full custom;

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:GUIMiner}"; Filename: "{app}\MicroCoinGUIMiner.exe"; Components: miner\gui; Tasks: desktopiconminer
Name: "{group}\{cm:ProgramOnTheWeb,{#StringChange(MyAppName, '&', '&&')}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:SourceCode}"; Filename: "https://github.com/MicroCoinHU/MicroCoinWallet"
Name: "{group}\{cm:UninstallProgram,{#StringChange(MyAppName, '&', '&&')}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "https://discordapp.com/invite/a7G6Van"; Description:"{cm:Community}"; Flags: shellexec runasoriginaluser postinstall skipifsilent nowait
Filename: "https://microcoin.hu/"; Description:"{cm:ProgramOnTheWeb,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec runasoriginaluser unchecked postinstall skipifsilent nowait

[Code]

//Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';

function InitializeSetup(): Boolean;
begin
  ExtractTemporaryFile('{#VCLStyle}');
  LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
  Result := True;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;

[Messages]
BeveledLabel={#MyAppName} - {#MyAppUrl}

[CustomMessages]
CreateDesktopIconForMiner=Create desktop icon for miner
Miner=Miner
OpenSSL=OpenSSL library files
Program=Main program files
ConsoleMiner=Console miner
GUIMiner=MicroCoin GUI miner (experimental)
Wallet=MicroCoin Wallet
Translations=Translations
English=English translation
Hungarian=Hungarian translation
FullInstallation=Recommended installation
CustomInstallation=Custom installation
SourceCode=Source code
Community=Join to our Discord community (AirDrop)

;Hungarian
hungarian.Wallet=MicroCoin Tárca
hungarian.Translations=Fordítások
hungarian.English=Angol nyelv
hungarian.Hungarian=Magyar nyelv
hungarian.FullInstallation=Ajánlott telepítés
hungarian.CustomInstallation=Egyéni telepítés
hungarian.SourceCode=Forráskód
hungarian.Miner=Bányászó program
hungarian.ConsoleMiner=Konzolos bányászprogram
hungarian.GUIMiner=MicroCoin grafikus bányász program (instabil)
hungarian.CreateDesktopIconForMiner=Bányászó program ikon létrehozása az asztalon
hungarian.OpenSSL=OpenSSL fájlok
hungarian.Program=Program fájlok
hungarian.Community=Csatlakozás a Discord szerverhez (AirDrop)
