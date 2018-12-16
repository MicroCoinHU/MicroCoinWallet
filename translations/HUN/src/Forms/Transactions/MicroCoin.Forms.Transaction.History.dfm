object TransactionHistoryForm: TTransactionHistoryForm
  Left = 0
  Top = 0
  Caption = 'Sz'#225'mlat'#246'rt'#233'net'
  ClientHeight = 517
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object transactionListView: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 922
    Height = 517
    Align = alClient
    Header.AutoSizeIndex = 7
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnDrawText = transactionListViewDrawText
    OnFreeNode = transactionListViewFreeNode
    OnGetText = transactionListViewGetText
    OnInitNode = transactionListViewInitNode
    Columns = <
      item
        Position = 0
        Width = 130
        WideText = 'Id'#337
      end
      item
        Alignment = taRightJustify
        Position = 1
        Width = 60
        WideText = 'Blokk'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Sz'#225'mla'
      end
      item
        Position = 3
        Width = 275
        WideText = 'Tranzakci'#243
      end
      item
        Alignment = taRightJustify
        Position = 4
        Width = 80
        WideText = #214'sszeg'
      end
      item
        Alignment = taRightJustify
        Position = 5
        Width = 60
        WideText = 'Ktsg'
      end
      item
        Alignment = taRightJustify
        Position = 6
        Width = 80
        WideText = #218'j egyenleg'
      end
      item
        Position = 7
        Width = 133
        WideText = 'K'#246'zlem'#233'ny'
      end>
  end
end
