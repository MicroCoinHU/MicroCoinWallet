object EditAccountForm: TEditAccountForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Edit account'
  ClientHeight = 299
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Top = 10
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 10
    Width = 58
    Height = 13
    Caption = 'Private key:'
  end
  object Label2: TLabel
    Left = 8
    Top = 58
    Width = 68
    Height = 13
    Caption = 'Account type:'
  end
  object Label3: TLabel
    Left = 264
    Top = 58
    Width = 79
    Height = 13
    Caption = 'Transaction fee:'
  end
  object Label4: TLabel
    Left = 392
    Top = 58
    Width = 75
    Height = 13
    Caption = 'Signer account:'
  end
  object edAccountName: TLabeledEdit
    Left = 8
    Top = 27
    Width = 244
    Height = 21
    EditLabel.Width = 72
    EditLabel.Height = 13
    EditLabel.Caption = 'Account name:'
    TabOrder = 0
  end
  object cbPrivateKey: TComboBox
    Left = 264
    Top = 27
    Width = 244
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object edAccountType: TEdit
    Left = 8
    Top = 73
    Width = 244
    Height = 21
    Alignment = taRightJustify
    NumbersOnly = True
    TabOrder = 2
  end
  object payloadPanel: TPanel
    Left = 0
    Top = 110
    Width = 521
    Height = 148
    Align = alBottom
    BevelEdges = [beTop, beBottom]
    BevelKind = bkSoft
    BevelOuter = bvNone
    Caption = 'payloadPanel'
    ShowCaption = False
    TabOrder = 4
    object Label7: TLabel
      Left = 8
      Top = 88
      Width = 135
      Height = 13
      Alignment = taRightJustify
      Caption = 'Payload encryption method:'
    end
    object Label9: TLabel
      Left = 258
      Top = 88
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password:'
    end
    object Label6: TLabel
      Left = 8
      Top = 7
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Payload:'
    end
    object cbEncryptMode: TComboBox
      Left = 8
      Top = 107
      Width = 244
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbEncryptModeChange
      Items.Strings = (
        'No encryption'
        'Encrypt with target public key'
        'Encrypt with your public key'
        'Password')
    end
    object edPassword: TEdit
      Left = 258
      Top = 107
      Width = 250
      Height = 21
      Enabled = False
      PasswordChar = #8226
      TabOrder = 1
    end
    object edPayload: TMemo
      Left = 8
      Top = 25
      Width = 500
      Height = 57
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 258
    Width = 521
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 5
    object bbSave: TPngBitBtn
      Left = 433
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = bbSaveClick
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
    object PngBitBtn2: TPngBitBtn
      Left = 352
      Top = 7
      Width = 75
      Height = 25
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
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
  end
  object edFee: TEdit
    Left = 264
    Top = 73
    Width = 117
    Height = 21
    Alignment = taRightJustify
    TabOrder = 3
    Text = '0'
  end
  object edSignerAccount: TAccountEditor
    Left = 392
    Top = 73
    Width = 116
    Height = 21
    Glyph.Data = {
      89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
      610000000473424954080808087C086488000000097048597300000AF000000A
      F00142AC34980000001874455874536F6674776172650041646F626520466972
      65776F726B734FB31F4E000002104944415478DAAD934F68134114C6DFFCD9EC
      A6D9AA49B3110FB1E9A901414A52ACC941688F221E048FE2218807A1D853B120
      143C880862D183A08857A12AE2A128B12AD42ED816914221C6042A455A68F3C7
      B5249BEECEF8B2B11749B050071ECCCEDBEFC7F7F69B25524AD8CF22FF1DF07C
      7ABAAB37161B2494F8AA95EAF2F0C8C8C69E014B8B0B9739576E08290DAF49A0
      2E8478904824C7FE09585CF87411C54F544D83886100A114CAA5125896050879
      9448262F7504BC9E99F18523C60FBFE6EFE98FF703A5ACD5440BC54201CA9532
      34ECC6B1543ABDD21660CECF1F679C7F8946A3601861701CC76B527451ABD520
      9FFF06C275474F0C0DDD6B0BF8383737C039FF1CEB8B41301802DBAE375BC039
      839D1D07BEE67260284EA67720F5B82DE06D36ABE9BABEAE77771F8CE308CD33
      2124F87C0A148B45286D6EC1ED6567E269267DB3E347C431AEA08BFB8140008C
      480418A3B08942625BF022F70BC63F6C83CAC454FDEE99AB1D63344D739C517A
      1DB781E6B3A65061162AAB632FBFF7B93812650C98146FD470CFF9AD3B677FB6
      BD48EF6667C3AAAA9EC404D4909F2EC513A9D5AED3B71E2AD2C9484241623214
      6045276270EDD5B5DA9EAFF2E15313A3A2519FF2DE4788A61F38B2969D5C27AD
      C4E11056104BC552B09AC7D48BA2B5840BB0113A3A7C8EEBD10BD2D97E5FCD3F
      9BB4856C39E0C4E3F03FA25D21F9DB8523A5B5BB67A871A574F7FD37FE06FFAF
      E4E1AECBFBD30000000049454E44AE426082}
    JustMyAccounts = True
  end
end
