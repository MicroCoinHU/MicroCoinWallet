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
| File:       MicroCoin.Forms.Common.About.pas
| Created at: 2018-09-11
| Purpose:    About box
|==============================================================================}

unit MicroCoin.Forms.Common.About;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  pngimage, Windows,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  TAboutForm = class(TForm)
    Label1: TLabel;
    bbClose: TBitBtn;
    Image1: TImage;
    Label2: TLabel;
    LinkLabel2: TLabel;
    LinkLabel1: TLabel;
    procedure LinkLabel1Click(Sender: TObject);
    procedure LinkLabel2Click(Sender: TObject);
  private
  public
  end;

implementation

{$R *.dfm}

uses ShellApi;

procedure TAboutForm.LinkLabel1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://discord.gg/ewQq5A6', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.LinkLabel2Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://microcoin.hu', nil, nil, SW_SHOWNORMAL);
end;

end.
