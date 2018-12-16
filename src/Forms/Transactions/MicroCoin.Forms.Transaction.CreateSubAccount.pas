{==============================================================================|
| MicroCoin                                                                    |
| Copyright (c) 2017-2018 MicroCoin Developers                                 |
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
| File:       MicroCoin.Forms.Transaction.CreateSubAccount.pas                 |
| Created at: 2018-09-25                                                       |
| Purpose:    Dialog for create subaccount                                     |
|==============================================================================}
unit MicroCoin.Forms.Transaction.CreateSubAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, PngBitBtn,
  MicroCoin.Common,
  PngSpeedButton, Vcl.ExtCtrls;

type
  TCreateSubaccountForm = class(TForm)
    edInitialBalance: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edBalanceLimit: TEdit;
    edDailyLimit: TEdit;
    Label3: TLabel;
    edPublicKey: TLabeledEdit;
    PngBitBtn1: TPngBitBtn;
    PngBitBtn2: TPngBitBtn;
    procedure edInitialBalanceKeyPress(Sender: TObject; var Key: Char);
  private
    function GetBalanceLimit: Int64;
    function GetDailyLimit: Int64;
    function GetInitialBalance: UInt64;
    function GetPublicKey: string;
    { Private declarations }
  public
    property InitialBalance : UInt64 read GetInitialBalance;
    property BalanceLimit : Int64 read GetBalanceLimit;
    property DailyLimit : Int64 read GetDailyLimit;
    property PublicKey : string read GetPublicKey;
  end;

var
  CreateSubaccountForm: TCreateSubaccountForm;

implementation

{$R *.dfm}

procedure TCreateSubaccountForm.edInitialBalanceKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', '.', ','])
  then Key := #0;
end;

function TCreateSubaccountForm.GetBalanceLimit: Int64;
begin
  TCurrencyUtils.ParseValue(edBalanceLimit.Text, Result);
end;

function TCreateSubaccountForm.GetDailyLimit: Int64;
begin
  TCurrencyUtils.ParseValue(edDailyLimit.Text, Result);
end;

function TCreateSubaccountForm.GetInitialBalance: UInt64;
var
  xBal : Int64;
begin
  TCurrencyUtils.ParseValue(edInitialBalance.Text, xBal);
  Result := xBal;
end;

function TCreateSubaccountForm.GetPublicKey: string;
begin
  Result := edPublicKey.Text;
end;

end.
