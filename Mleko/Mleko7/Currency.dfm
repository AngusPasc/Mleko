inherited CurrencyForm: TCurrencyForm
  Left = 784
  Top = 241
  Width = 502
  Height = 327
  Caption = ''
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 486
    Height = 288
    Align = alClient
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1074#1072#1083#1102#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object DBGridEh1: TDBGridEh
      Left = 2
      Top = 39
      Width = 482
      Height = 206
      Align = alClient
      DataSource = dmDataModule.dsCurrency
      Flat = False
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = [fsBold]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
      TitleLines = 3
      OnDrawColumnCell = DBGridEh1DrawColumnCell
      Columns = <
        item
          EditButtons = <>
          FieldName = 'ID'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          EditButtons = <>
          FieldName = 'NAME'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          EditButtons = <>
          FieldName = 'L_CODE'
          Footers = <>
          Title.Alignment = taCenter
          Width = 70
        end
        item
          EditButtons = <>
          FieldName = 'SHORT_NAME'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'IsDefault'
          Footers = <>
          Title.Alignment = taCenter
        end>
    end
    object ToolBar: TToolBar
      Left = 2
      Top = 15
      Width = 482
      Height = 24
      AutoSize = True
      Caption = 'ToolBar'
      Flat = True
      Images = dmDataModule.ImageListToolBar
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Caption = 'ToolButton1'
        ImageIndex = 0
        OnClick = ToolButton1Click
      end
      object ToolButton2: TToolButton
        Left = 23
        Top = 0
        Caption = 'ToolButton2'
        ImageIndex = 1
        OnClick = ToolButton2Click
      end
      object ToolButton3: TToolButton
        Left = 46
        Top = 0
        Caption = 'ToolButton3'
        ImageIndex = 2
        OnClick = ToolButton3Click
      end
      object ToolButton5: TToolButton
        Left = 69
        Top = 0
        Width = 9
        Caption = 'ToolButton5'
        ImageIndex = 31
        Style = tbsSeparator
      end
      object ToolBtnRefresh: TToolButton
        Left = 78
        Top = 0
        ImageIndex = 3
        OnClick = ToolBtnRefreshClick
      end
    end
    object Panel1: TPanel
      Left = 2
      Top = 245
      Width = 482
      Height = 41
      Align = alBottom
      TabOrder = 2
      object BitBtn3: TBitBtn
        Left = 160
        Top = 8
        Width = 81
        Height = 25
        Caption = #1054#1050
        ModalResult = 1
        TabOrder = 0
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
      object BitBtn4: TBitBtn
        Left = 245
        Top = 8
        Width = 81
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  inherited ActionList: TActionList
    Left = 0
    Top = 56
  end
end
