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
// SetupIconFile=MicroCoinWallet_Icon.ico
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
// vcredist
Source: "vcredist_x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall

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
; add the Parameters, WorkingDir and StatusMsg as you wish, just keep here
; the conditional installation Check
Filename: "{tmp}\vcredist_x86.exe"; Check: VCRedistNeedsInstall

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

#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF
type
  INSTALLSTATE = Longint;
const
  INSTALLSTATE_INVALIDARG = -2;  { An invalid parameter was passed to the function. }
  INSTALLSTATE_UNKNOWN = -1;     { The product is neither advertised or installed. }
  INSTALLSTATE_ADVERTISED = 1;   { The product is advertised but not installed. }
  INSTALLSTATE_ABSENT = 2;       { The product is installed for a different user. }
  INSTALLSTATE_DEFAULT = 5;      { The product is installed for the current user. }

  VC_2005_REDIST_X86 = '{A49F249F-0C91-497F-86DF-B2585E8E76B7}';
  VC_2005_REDIST_X64 = '{6E8E85E8-CE4B-4FF5-91F7-04999C9FAE6A}';
  VC_2005_REDIST_IA64 = '{03ED71EA-F531-4927-AABD-1C31BCE8E187}';
  VC_2005_SP1_REDIST_X86 = '{7299052B-02A4-4627-81F2-1818DA5D550D}';
  VC_2005_SP1_REDIST_X64 = '{071C9B48-7C32-4621-A0AC-3F809523288F}';
  VC_2005_SP1_REDIST_IA64 = '{0F8FB34E-675E-42ED-850B-29D98C2ECE08}';
  VC_2005_SP1_ATL_SEC_UPD_REDIST_X86 = '{837B34E3-7C30-493C-8F6A-2B0F04E2912C}';
  VC_2005_SP1_ATL_SEC_UPD_REDIST_X64 = '{6CE5BAE9-D3CA-4B99-891A-1DC6C118A5FC}';
  VC_2005_SP1_ATL_SEC_UPD_REDIST_IA64 = '{85025851-A784-46D8-950D-05CB3CA43A13}';

  VC_2008_REDIST_X86 = '{FF66E9F6-83E7-3A3E-AF14-8DE9A809A6A4}';
  VC_2008_REDIST_X64 = '{350AA351-21FA-3270-8B7A-835434E766AD}';
  VC_2008_REDIST_IA64 = '{2B547B43-DB50-3139-9EBE-37D419E0F5FA}';
  VC_2008_SP1_REDIST_X86 = '{9A25302D-30C0-39D9-BD6F-21E6EC160475}';
  VC_2008_SP1_REDIST_X64 = '{8220EEFE-38CD-377E-8595-13398D740ACE}';
  VC_2008_SP1_REDIST_IA64 = '{5827ECE1-AEB0-328E-B813-6FC68622C1F9}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_X86 = '{1F1C2DFC-2D24-3E06-BCB8-725134ADF989}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_X64 = '{4B6C7001-C7D6-3710-913E-5BC23FCE91E6}';
  VC_2008_SP1_ATL_SEC_UPD_REDIST_IA64 = '{977AD349-C2A8-39DD-9273-285C08987C7B}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_X86 = '{9BE518E6-ECC6-35A9-88E4-87755C07200F}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_X64 = '{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}';
  VC_2008_SP1_MFC_SEC_UPD_REDIST_IA64 = '{515643D1-4E9E-342F-A75A-D1F16448DC04}';

  VC_2010_REDIST_X86 = '{196BB40D-1578-3D01-B289-BEFC77A11A1E}';
  VC_2010_REDIST_X64 = '{DA5E371C-6333-3D8A-93A4-6FD5B20BCC6E}';
  VC_2010_REDIST_IA64 = '{C1A35166-4301-38E9-BA67-02823AD72A1B}';
  VC_2010_SP1_REDIST_X86 = '{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}';
  VC_2010_SP1_REDIST_X64 = '{1D8E6291-B0D5-35EC-8441-6616F567A0F7}';
  VC_2010_SP1_REDIST_IA64 = '{88C73C1C-2DE5-3B01-AFB8-B46EF4AB41CD}';

  { Microsoft Visual C++ 2012 x86 Minimum Runtime - 11.0.61030.0 (Update 4) }
  VC_2012_REDIST_MIN_UPD4_X86 = '{BD95A8CD-1D9F-35AD-981A-3E7925026EBB}';
  VC_2012_REDIST_MIN_UPD4_X64 = '{CF2BEA3C-26EA-32F8-AA9B-331F7E34BA97}';
  { Microsoft Visual C++ 2012 x86 Additional Runtime - 11.0.61030.0 (Update 4)  }
  VC_2012_REDIST_ADD_UPD4_X86 = '{B175520C-86A2-35A7-8619-86DC379688B9}';
  VC_2012_REDIST_ADD_UPD4_X64 = '{37B8F9C7-03FB-3253-8781-2517C99D7C00}';

  { Visual C++ 2013 Redistributable 12.0.21005 }
  VC_2013_REDIST_X86_MIN = '{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E}';
  VC_2013_REDIST_X64_MIN = '{A749D8E6-B613-3BE3-8F5F-045C84EBA29B}';

  VC_2013_REDIST_X86_ADD = '{F8CFEB22-A2E7-3971-9EDA-4B11EDEFC185}';
  VC_2013_REDIST_X64_ADD = '{929FBD26-9020-399B-9A7A-751D61F0B942}';

  { Visual C++ 2015 Redistributable 14.0.23026 }
  VC_2015_REDIST_X86_MIN = '{A2563E55-3BEC-3828-8D67-E5E8B9E8B675}';
  VC_2015_REDIST_X64_MIN = '{0D3E9E15-DE7A-300B-96F1-B4AF12B96488}';

  VC_2015_REDIST_X86_ADD = '{BE960C1C-7BAD-3DE6-8B1A-2616FE532845}';
  VC_2015_REDIST_X64_ADD = '{BC958BD2-5DAC-3862-BB1A-C1BE0790438D}';

  { Visual C++ 2015 Redistributable 14.0.24210 }
  VC_2015_REDIST_X86 = '{8FD71E98-EE44-3844-9DAD-9CB0BBBC603C}';
  VC_2015_REDIST_X64 = '{C0B2C673-ECAA-372D-94E5-E89440D087AD}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE; 
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

function VCRedistNeedsInstall: Boolean;
begin
  { here the Result must be True when you need to install your VCRedist }
  { or False when you don't need to, so now it's upon you how you build }
  { this statement, the following won't install your VC redist only when }
  { the Visual C++ 2010 Redist (x86) and Visual C++ 2010 SP1 Redist(x86) }
  { are installed for the current user }
  Result := not (VCVersionInstalled(VC_2010_REDIST_X86) and VCVersionInstalled(VC_2010_SP1_REDIST_X86));
end;

