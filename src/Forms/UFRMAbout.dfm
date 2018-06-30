object FRMAbout: TFRMAbout
  Left = 632
  Top = 211
  ActiveControl = bbClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'About...'
  ClientHeight = 405
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 372
    Height = 25
    Caption = 'Micro Coin Wallet, Miner && Explorer'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lblBuild: TLabel
    Left = 15
    Top = 356
    Width = 30
    Height = 13
    Caption = 'Build:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lblProtocolVersion: TLabel
    Left = 15
    Top = 375
    Width = 50
    Height = 13
    Caption = 'Protocol:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 32
    Top = 48
    Width = 478
    Height = 266
    BorderStyle = bsNone
    Lines.Strings = (
      'Copyright (c) 2017 - 2017 Peter Nemeth'
      ''
      
        'Micro Coin is P2P cryptocurrency without the need for historical' +
        ' operations. This software '
      
        'comprises a node within the Micro Coin network and can be used t' +
        'o Mine and Explore blocks and '
      'operations.'
      ''
      
        'Distributed under the MIT software license, see the accompanying' +
        ' file LICENSE  or visit '
      'http://www.opensource.org/licenses/mit-license.php.'
      ''
      'THIS IS EXPERIMENTAL SOFTWARE.'
      ''
      
        'This product includes software developed by the OpenSSL Project ' +
        'and Denis Grinyuk '
      
        '(https://github.com/Arvur/OpenSSL-Delphi), some cryptographic fu' +
        'nctions inspirated in code '
      
        'written by Ladar Levison and Marco Ferrante, and Synapse Socket ' +
        'code copyright of Lukas '
      'Gebauer.'
      '')
    ParentColor = True
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object bbClose: TBitBtn
    Left = 456
    Top = 358
    Width = 111
    Height = 31
    Caption = 'Close'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
end
