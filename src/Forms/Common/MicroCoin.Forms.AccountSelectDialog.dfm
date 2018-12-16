object AccountSelectDialog: TAccountSelectDialog
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Select account'
  ClientHeight = 387
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object accountVList: TVirtualStringTree
    Left = 0
    Top = 41
    Width = 548
    Height = 305
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ClipboardFormats.Strings = (
      'CSV'
      'HTML Format')
    EmptyListMessage = 'No accounts.'#13#10'(Maybe you want to mine one, or ask on Discord)'
    Header.AutoSizeIndex = 3
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes, toAutoChangeScale, toDisableAutoscrollOnEdit]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toStaticBackground]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnFreeNode = accountVListFreeNode
    OnGetText = accountVListGetText
    OnInitChildren = accountVListInitChildren
    OnInitNode = accountVListInitNode
    OnNodeDblClick = accountVListNodeDblClick
    ExplicitTop = 45
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 100
        WideText = 'Account'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Name'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Balance'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 198
        WideText = 'Transactions'
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 548
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object cbMyAccounts: TCheckBox
      Left = 16
      Top = 12
      Width = 82
      Height = 17
      Caption = 'My accounts'
      TabOrder = 0
      OnClick = cbMyAccountsClick
    end
    object cbForSale: TCheckBox
      Left = 104
      Top = 12
      Width = 75
      Height = 17
      Caption = 'For sale'
      TabOrder = 1
      OnClick = cbForSaleClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 346
    Width = 548
    Height = 41
    Align = alBottom
    BevelEdges = [beTop]
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 2
    object btnOk: TPngBitBtn
      Left = 454
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F
        530000000373424954080808DBE14FE00000000970485973000001BB000001BB
        013AECE3E20000001974455874536F667477617265007777772E696E6B736361
        70652E6F72679BEE3C1A0000010E504C5445FFFFFF004E00004900005500004C
        00004F00004D00004E00004D00004B00004E00004D00004C00004D00004C0000
        4E00004C00025002045304045304035203024E02024E02024D02024802005B00
        136412015B010E680C176615176915156B12116B0E0E680B095F07126B10105C
        0D185D141756111A54121C50111C50142C842347BA0E4A8D304D7D294E822D4E
        8B3150AC2A54832D57C21858A042599F415B9C3F5DB22D64B15064BA3273B464
        76B56376BC5977C05579B8617BBB667FC0687FC83582C64583C24A88C27A89BD
        4B89C67B8AC1578AC15B8EC4608EC7448FC95C90BD6B90C16F91C56991DE3E93
        C67093C86A96C36C98D54799D08F99D2909AC8689ACB7B9DC96DA6D077B6EAA1
        29ECEFA80000002B74524E53000D0E181B1D21243233343536466B6C728D9091
        959A9DA0A3BCD6D8DBE6E7E9EBEDF5F5F6F7F9F9FAFAFE0D0EC0F10000009D49
        44415478DA636440038CF80458B93FFD43166093967CF8EC3F428055DA8CF9C9
        9DE740017E910F6F191858A40D58FFFF3CF78C91814F46EFF6FD77CCD2FA3FFE
        715C7FF6839141C6F289F893079CDADFFF0B5F7EFA1D68A8A0B4F407E1D782DF
        FECB9C7BFA0D6CADA894F03BC1EFFFF81E3DF90675879884D06B76F17B4FBEC2
        1D262E25CB72FDD15724974A88FE7EF205C5E9BCBF7E12E339300000628A3711
        66E994D80000000049454E44AE426082}
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btnCancel: TPngBitBtn
      Left = 373
      Top = 10
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000000970485973000001BB000001
        BB013AECE3E20000001974455874536F667477617265007777772E696E6B7363
        6170652E6F72679BEE3C1A000002FD4944415478DA9D934B6813511486FF9BC9
        CC6492994993368DAD2F5AEBAB8D288AF5515FB8115A501716A58B8042458C01
        5D880B5D0A821B1751100445F1DD2EC44711146BB1D6AAB50ADA4AA94AAB440D
        4D2624334D329366C6DBD280F85AF86FEEE2DEF371FF73FE432CCBC23F649B3E
        CDBF3D20BF02DE1C3B561BEBEA6A537A7A726275F512469248666464500A04EC
        FE0D1B9A971D3F3EF857C0E3969648ACA3A3B574CD6ADE531780E8F78310026D
        6C0CF1BE3E245EBDD22B1A1BCF6DBA7A35FC1B60B2F8DBFD8ED0BC6090F04E27
        461E3DC678340A41E021D7CC837BE16264D53446AF5DB7666DDB7EA6089902BC
        A0DF1E387DBABF6A6B130FC3C0BB3B7715DE983821B2EC759E652B448E7D80FA
        156EDE3F137A3A89E8C34EBDEEC081E5F5D4CE14A06DFDFA01928CD5FA57AEC1
        EBF6F6246391C5214D8BB589A25F92A51EE7DAFAEA0258A8E329302C8FCCA761
        C0533ED8FCE449DD14E0424D4DC233B3CC9B513524DF0E1D09E5F327AF8962B9
        C72DF7FAB66CAAD2A309A8BA86FEDE97289F3B1B25BE32A4BF2794DD1F3E944E
        026C1151CCCE58BD944B0F7F0489AB95022105D9E5ECAD5CB7B2CAA4C539A680
        67AFDF9ABEACBE7FC25772362B70B012E34658D38429C0290A30799393E9D839
        1D4B3D027F4B72D9AAA40C41DE61A13BAE9AA5593D28000FAD52E9FB98918569
        F2C6A1690022D482A57CF6BA08039F5D54EDA62679E339D8253B3A75D3741B66
        70AF655DB92C8A075D2E722A9ED791F3CE51C2D3167096361103CF6B2DAD8019
        E50EC8D10C44994567AE604AB438448B2FD28656940843E931C59D7232C80756
        0DEE2B36F1111DE3D348A47FB660F0AE580E3E1F8F2E75020EC33A2C72DC4D99
        657755781D47EDC9941C176C789FE5F4867078F9E6E2182775890669B4FD4668
        918F23654A1E7031506D76B8EC2CBC8C099B92C157378BBEB861CDDDB1F34CF0
        E72015759E4286EFDD6B5DC0EB7C25475006028E4659A1775F8C020672BC3EBF
        A9E9DC9E3F45B9A8DBD4CE105DA6D1EEEE9C2849011B437F924ABD9BD3D0E058
        B87163F3D67F2DD3FFACF30F51A56FF4789ABE890000000049454E44AE426082}
    end
  end
end
