inherited MlekoSelectVidNaklDlg: TMlekoSelectVidNaklDlg
  Left = 978
  Top = 314
  Width = 484
  Height = 354
  Caption = #1042#1080#1076' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    Width = 472
    Height = 258
    inherited TabSheet1: TTabSheet
      inherited Splitter: TSplitter
        Left = 242
        Height = 230
      end
      inherited PanelGrid: TPanel
        Width = 242
        Height = 230
        inherited DBGrid: TcitDBGrid
          Width = 240
          Height = 206
        end
        inherited ToolBar: TToolBar
          Width = 240
        end
      end
      inherited PanelSelect: TPanel
        Left = 245
        Height = 230
        inherited DBGridSelection: TcitDBGrid
          Height = 206
        end
      end
    end
  end
  inherited ButtonSelect: TButton
    Left = 393
    Top = 266
  end
  inherited ButtonCancel: TButton
    Left = 393
    Top = 298
  end
  inherited FilterPanel: TTargetFilter_Panel
    Top = 266
    Width = 376
  end
  inherited ActionList: TActionList
    Left = 116
  end
  inherited ComponentProps: TcitComponentProps
    Left = 32
  end
  inherited DS: TDataSource
    Left = 116
  end
  inherited SQLBuilder: TTargetSQLBuilder
    Select.Strings = (
      'VidNaklNo as id, VidNaklNo,VidNaklName')
    From.Strings = (
      'VidNakl a')
    Left = 63
    Top = 41
  end
  inherited Query: TMSQuery
    Left = 87
  end
  inherited QueryProp: TMSQuery
    Left = 31
  end
  inherited DSSelection: TDataSource
    Left = 88
  end
  inherited QuSelectList: TMSQuery
    Left = 55
    Top = 196
  end
end
