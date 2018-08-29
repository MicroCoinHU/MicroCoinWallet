object MessagesFrame: TMessagesFrame
  Left = 0
  Top = 0
  Width = 815
  Height = 384
  TabOrder = 0
  DesignSize = (
    815
    384)
  object Label13: TLabel
    Left = 15
    Top = 11
    Width = 109
    Height = 13
    Caption = 'Available Connections:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label12: TLabel
    Left = 315
    Top = 11
    Width = 85
    Height = 13
    Caption = 'Message to send:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label14: TLabel
    Left = 410
    Top = 11
    Width = 361
    Height = 13
    Caption = 
      '(Messages will be encrypted, so only dest connection will be abl' +
      'e to read it)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object memoMessages: TMemo
    Left = 217
    Top = 140
    Width = 572
    Height = 181
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object lbNetConnections: TListBox
    Left = 15
    Top = 30
    Width = 190
    Height = 291
    ItemHeight = 13
    MultiSelect = True
    ScrollWidth = 273
    TabOrder = 1
  end
  object memoMessageToSend: TMemo
    Left = 217
    Top = 30
    Width = 572
    Height = 61
    TabOrder = 2
    WantReturns = False
  end
  object bbSendAMessage: TButton
    Left = 655
    Top = 105
    Width = 134
    Height = 25
    Caption = 'Send a Message'
    TabOrder = 3
    OnClick = bbSendAMessageClick
  end
end
