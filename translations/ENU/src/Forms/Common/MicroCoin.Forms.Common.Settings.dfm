object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'MicroCoin settings'
  ClientHeight = 335
  ClientWidth = 480
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 26
    Top = 191
    Width = 78
    Height = 13
    Caption = 'New transaction'
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 460
    Height = 281
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Application options'
      ImageIndex = 2
      object Label5: TLabel
        Left = 12
        Top = 6
        Width = 27
        Height = 13
        Caption = 'Skin:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 12
        Top = 147
        Width = 78
        Height = 13
        Caption = 'New transaction'
      end
      object Label8: TLabel
        Left = 212
        Top = 147
        Width = 48
        Height = 13
        Caption = 'New block'
      end
      object Label9: TLabel
        Left = 12
        Top = 186
        Width = 80
        Height = 13
        Caption = 'System message'
      end
      object Label10: TLabel
        Left = 12
        Top = 116
        Width = 116
        Height = 13
        Caption = 'Notification settings:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 212
        Top = 186
        Width = 59
        Height = 13
        Caption = 'New version'
      end
      object Label12: TLabel
        Left = 12
        Top = 65
        Width = 100
        Height = 13
        Caption = 'Software updates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbSkin: TComboBox
        Left = 12
        Top = 25
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Native'
        OnChange = cbSkinChange
        Items.Strings = (
          'Native'
          'Light'
          'Dark')
      end
      object swNewTransaction: TToggleSwitch
        Left = 104
        Top = 143
        Width = 72
        Height = 20
        TabOrder = 1
      end
      object ToggleSwitch2: TToggleSwitch
        Left = 304
        Top = 143
        Width = 72
        Height = 20
        Enabled = False
        TabOrder = 2
      end
      object ToggleSwitch3: TToggleSwitch
        Left = 104
        Top = 182
        Width = 72
        Height = 20
        Enabled = False
        TabOrder = 3
      end
      object ToggleSwitch4: TToggleSwitch
        Left = 304
        Top = 182
        Width = 72
        Height = 20
        Enabled = False
        TabOrder = 4
      end
      object CheckBox1: TCheckBox
        Left = 12
        Top = 84
        Width = 116
        Height = 17
        Caption = 'Auto check updates'
        Enabled = False
        TabOrder = 5
      end
      object CheckBox2: TCheckBox
        Left = 144
        Top = 84
        Width = 97
        Height = 17
        Caption = 'Auto update'
        Enabled = False
        TabOrder = 6
      end
    end
    object MiningTab: TTabSheet
      Caption = 'Mining options'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 12
        Top = 69
        Width = 87
        Height = 13
        Caption = 'Miner server port:'
      end
      object editMinerName: TLabeledEdit
        Left = 12
        Top = 32
        Width = 276
        Height = 21
        EditLabel.Width = 59
        EditLabel.Height = 13
        EditLabel.Caption = 'Miner name:'
        TabOrder = 0
      end
      object editMinerServerPort: TSpinEdit
        Left = 12
        Top = 88
        Width = 121
        Height = 22
        MaxValue = 65535
        MinValue = 1
        TabOrder = 1
        Value = 4009
      end
      object Panel1: TPanel
        Left = 3
        Top = 116
        Width = 346
        Height = 129
        BevelOuter = bvNone
        TabOrder = 2
        object radionewKey: TRadioButton
          Left = 9
          Top = 8
          Width = 276
          Height = 17
          Caption = 'Generate a new private key for each generated block'
          TabOrder = 0
          OnClick = radionewKeyClick
        end
        object radioRandomkey: TRadioButton
          Left = 9
          Top = 36
          Width = 149
          Height = 17
          Caption = 'Use a random existing key'
          TabOrder = 1
          OnClick = radioRandomkeyClick
        end
        object radiousethiskey: TRadioButton
          Left = 9
          Top = 64
          Width = 149
          Height = 17
          Caption = 'Always mine with this key:'
          TabOrder = 2
          OnClick = radiousethiskeyClick
        end
        object cbMyKeys: TComboBox
          Left = 9
          Top = 96
          Width = 276
          Height = 21
          Style = csDropDownList
          Enabled = False
          TabOrder = 3
        end
      end
    end
    object NetOptions: TTabSheet
      Caption = 'Server options'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 12
        Top = 21
        Width = 101
        Height = 13
        Caption = 'Internet server port:'
      end
      object Label3: TLabel
        Left = 12
        Top = 109
        Width = 111
        Height = 13
        Caption = 'JSON RPC Server port:'
      end
      object Label4: TLabel
        Left = 152
        Top = 109
        Width = 134
        Height = 13
        Caption = 'Allowed client IP addresses:'
      end
      object editServerPort: TSpinEdit
        Left = 12
        Top = 40
        Width = 101
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object checkEnableRPC: TCheckBox
        Left = 12
        Top = 84
        Width = 141
        Height = 17
        Caption = 'Enable JSON RPC Server'
        TabOrder = 1
      end
      object editJSONRPCPort: TSpinEdit
        Left = 12
        Top = 128
        Width = 101
        Height = 22
        MaxValue = 0
        MinValue = 0
        ReadOnly = True
        TabOrder = 2
        Value = 4003
      end
      object memoAllowedIPs: TMemo
        Left = 152
        Top = 128
        Width = 261
        Height = 89
        TabOrder = 3
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 294
    Width = 480
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSave: TPngBitBtn
      Left = 380
      Top = 9
      Width = 86
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000000970485973000001BB000001
        BB013AECE3E20000001974455874536F667477617265007777772E696E6B7363
        6170652E6F72679BEE3C1A000002444944415478DA63FCFFFF3F032580116480
        AF8FCFFB1F3F7E0AE41796A24A3281482606262646064646209F0182BBBB3A18
        3838D83F6CDEB245106C80B3A3D37F09490986E9B3173220BB07AC01A4114880
        0C0122309D9391CE70F7EE5D86BDFBF731820D70B477F8AFA4A4C4307DD61C86
        C57B2EA1BA024A3032405C11E7AAC7909A9CCC70EFDE3D86FD070F400CB0B3B5
        FBAFA8A0C03077C10286BF7FFF8135C15C0292FFF71F4A83182017A4A530DC7F
        F080E1D0E14310036CAC6DFE2BC8CB334C9E351762234C33C40410021AF21F82
        818694E4A4333C78F890E1C8D1231003AC2C2CFFCBC9C931744F9DCDB072C771
        142FC06309E40A200C763567A82EC86478F4E811C3B113C72106589899FF9795
        956568E899CAF0E73F8A6EA82B209A41668122A6B52297E1F1E3C70C274E9D84
        18606662F25F465A86A4F87FF2F409C3A933672006181B1AFD97969222C980A7
        CF9E319C3D7F0E6280A19EFE7F490909B0444B473B03272727DCF9A03400027F
        FFFE65080B0E01D3CAC0287FFEE205C3F94B172106E86869FF171713032B4C05
        26921953A7317CFBFE8DA1B2BA1AC5D6299326333C7BFE8C414E4616EC822BD7
        AE420C505755FB2F2A220256149798C0307BC64C862F5FBE30945755A218B068
        FE02B046136363863367CF32DCBC7D0B6280AAB2F25B4E0E0E210E760E86B0C8
        488605F3E6015DF09D21BFB000C580658B9730BC7EF386C1404F8FE1D2E5CB0C
        77EEDF8318A0A6A0A0FFEBDFBFBDFFFFFD170E8F8A64606666C61A708B172E02
        C7290B330B031333D3877B0F1E403213250000225113F06C9904500000000049
        454E44AE426082}
    end
    object btnCancel: TPngBitBtn
      Left = 283
      Top = 9
      Width = 86
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
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
