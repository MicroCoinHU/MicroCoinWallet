object BlockChainExplorerForm: TBlockChainExplorerForm
  Left = 0
  Top = 0
  Caption = 'Blokk felfedez'#337
  ClientHeight = 545
  ClientWidth = 1033
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
  object blockListView: TVirtualStringTree
    Left = 0
    Top = 41
    Width = 1033
    Height = 254
    Align = alClient
    Header.AutoSizeIndex = 10
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale, toDisableAutoscrollOnEdit]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnDrawText = blockListViewDrawText
    OnFreeNode = blockListViewFreeNode
    OnGetText = blockListViewGetText
    OnInitNode = blockListViewInitNode
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 60
        WideText = 'Blokk'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 175
        WideText = 'Id'#337
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 80
        WideText = 'Tranzakci'#243'k'
      end
      item
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coEditable]
        Position = 3
        Width = 80
        WideText = 'Jutalom'
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
        WideText = #214'ssz'
      end
      item
        Alignment = taCenter
        Position = 7
        Width = 139
        WideText = 'Neh'#233'zs'#233'g'
      end
      item
        Alignment = taRightJustify
        Position = 8
        Width = 119
        WideText = 'Sebess'#233'g'
      end
      item
        Position = 9
        Width = 137
        WideText = 'B'#225'ny'#225'sz'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coEditable]
        Position = 10
        Width = 276
        WideText = 'Proof Of Work'
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1033
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1033
      41)
    object labelUpdated: TLabel
      Left = 20
      Top = 14
      Width = 63
      Height = 13
      Caption = 'labelUpdated'
    end
    object btnRefresh: TPngSpeedButton
      Left = 960
      Top = 8
      Width = 63
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Friss'#237't'#233's'
      Flat = True
      OnClick = btnRefreshClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000000970485973000001BB000001
        BB013AECE3E20000001974455874536F667477617265007777772E696E6B7363
        6170652E6F72679BEE3C1A000003394944415478DA6D534B681D5518FECE9973
        E6751F699C84DE382D7941E32BD650ACA9D5A0AD12B098765150E84245976EC4
        AEBA35C48D0B154471E3420415E45241424BB10A49210A31369AD8D492F49147
        AFBD69676EEEDC799D399E7B69208B1EF8F999E1FBBEF3FD8F43A494D879C818
        E907C5292DAF1DE9757B879CBC4397D796172A1B950B10F84AFE28FFBD8FDBA3
        1223DB02EA0705C17B4E9F337EECE963A6DBE9A2ABA30B1AD5E0791EAEAD5F43
        F95239DCBCBEF90132FCDEE6167F88BC286C0934C9D420170F0D0F1F7A71E828
        A73AC5838E88052E5D9E4AFEBC3947DE7AE96DF6C9771FA325404F90D3438383
        1323C347B990421921A856AB585D5F550082FEBDFDB076592D11AA8C2A07A01A
        C567DF7FAA90AF62A0B3B46BEEC833A3A66EEA10A9C0EC1FB3B8BABC04437058
        BA053FABA1DD7570F0C041B417DB0155B526357C3BF90D0819C3F8FE7D4F9CD9
        D3D3439A37CCFF358FFF2A6B92311A07717241191436E5A3517BAAC3D5C8C863
        2330A5091213FCFCEB3910F3753E3DD035F06CCE29C2F77CFCB3B800DBE681DF
        88F6373BAEFA3354E0C674F8BCB0767797E032176C8BC1BBED61656E4992C21B
        46FDE1B61E9B190C953B15F81B77911AD9D9B42C4E341D155EB35ED68BF43C9E
        D3A13738E001B5DB35C87A86D41393C43EC5E3ACAE7130203112F084208EC579
        51CE4677EC86A9521B87A6FA2B45A6424899C8B3B246D8493AC57C7A387452A0
        13306C06BA82B0514F9F52255CB92FD04709F99C0D6AEFA75A5AD537D916BFA7
        85FED7A1BA6E0C67F29931BED51D11EC067881A2B3C1E5BD051934FCF827D566
        A233ED95B6BDE64C3A9095A32459099374CD5CE41BF5345E6B8EF151CBE4B3E8
        85199752D85C47CED0E1301B4955A861115825960624BDA188F3411C2F26B5EC
        7AE34A72AEF165B2B2BD89A79D923D110EA63C6770144C037925422D8AC414AD
        B91B014314A64B5194FDBD7AD17B32B81BBFA34AFC655BA0B903936E7FF185DC
        E3BAC1735AAB945A4784309F826404B6CFD1B16E8B1B339E7FEBAA37A5448F2B
        01B9F3313545DE2D3C647E68F531CB7DA448C37D29EA4E0CED16C59D99BA14BF
        6541B0954C28DC478A1CB7780F78CEDD2ABDA9E2B046C981A6C14CCACBEA7B5A
        C5178A787327FE7F06D57A57397C47CE0000000049454E44AE426082}
      ExplicitLeft = 820
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 295
    Width = 1033
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'NetHash')
    View3D = False
    Align = alBottom
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      37
      15
      37)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Marks.Style = smsValue
      Marks.DrawEvery = 100
      PercentFormat = '##0.##,%'
      Title = 'Nethash'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        001900000000000000000084400000000000AC87400000000000908A40000000
        0000708C400000000000DC8E400000000000F48F400000000000369040000000
        0000B890400000000000008E4000000000002C8A400000000000608840000000
        0000348C400000000000008E4000000000007C8F400000000000188F40000000
        00006C914000000000008E924000000000003E924000000000008A9140000000
        00003091400000000000CA9240000000000030914000000000006C9140000000
        0000188F400000000000808B40}
      Detail = {0000000000}
    end
  end
end
