object BlockExplorerFrame: TBlockExplorerFrame
  Left = 0
  Top = 0
  Width = 581
  Height = 390
  TabOrder = 0
  object dgBlockChainExplorer: TDrawGrid
    Left = 0
    Top = 41
    Width = 581
    Height = 349
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 703
    ExplicitHeight = 396
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 703
    object filterLabel: TLabel
      Left = 17
      Top = 10
      Width = 102
      Height = 13
      Caption = 'Filter by blocks range'
      Color = clBtnFace
      ParentColor = False
    end
    object ebBlockChainBlockStart: TEdit
      Left = 125
      Top = 7
      Width = 57
      Height = 21
      TabOrder = 0
      OnExit = ebBlockChainBlockStartExit
    end
    object ebBlockChainBlockEnd: TEdit
      Left = 185
      Top = 7
      Width = 57
      Height = 21
      TabOrder = 1
    end
  end
end
