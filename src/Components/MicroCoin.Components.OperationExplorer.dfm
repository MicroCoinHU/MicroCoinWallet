object OperationExplorer: TOperationExplorer
  Left = 0
  Top = 0
  Width = 551
  Height = 395
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 551
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 11
      Top = 10
      Width = 102
      Height = 13
      Caption = 'Filter by blocks range'
      Color = clBtnFace
      ParentColor = False
    end
    object ebFilterOperationsStartBlock: TEdit
      Left = 125
      Top = 7
      Width = 57
      Height = 21
      TabOrder = 0
      OnExit = ebFilterOperationsAccountExit
    end
    object ebFilterOperationsEndBlock: TEdit
      Left = 188
      Top = 7
      Width = 57
      Height = 21
      TabOrder = 1
      OnExit = ebFilterOperationsAccountExit
    end
  end
  object dgOperationsExplorer: TDrawGrid
    Left = 0
    Top = 41
    Width = 551
    Height = 354
    Align = alClient
    TabOrder = 1
    OnDblClick = dgOperationsExplorerDblClick
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
end
