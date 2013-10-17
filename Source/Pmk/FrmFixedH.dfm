inherited FmFixedH: TFmFixedH
  Width = 324
  Caption = 'Repery sta'#322'e'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000333000000000000003B0000000000000
    00BB000000000000000BB000000000000000BB000000000000000BB000000000
    000000BB00000000D000000BB000000DDD0000008D0000DDDDD0000005D00000
    000000000550000000000000000000000000000000000000000000000000FFFF
    FFFFF7FFFFFFF1FFFFFFF8FFFFFFF87FFFFFFC3FFFFFFE1FFFFFFF0FFFFFF787
    FFFFE3C3FFFFC1E1FFFF80F1FFFF80F9FFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 316
    Height = 265
    Align = alClient
    DataSource = dsFixedH
    TabOrder = 0
    TitleFont.Charset = EASTEUROPE_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object FixedH: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    Left = 144
    Top = 48
    object FixedHName: TStringField
      DisplayLabel = 'Nazwa'
      FieldName = 'Name'
      Required = True
    end
    object FixedHH: TFloatField
      FieldName = 'H'
      Required = True
      DisplayFormat = '0.000'
    end
    object FixedHHErr: TFloatField
      DisplayLabel = 'mH'
      FieldName = 'HErr'
      Visible = False
      DisplayFormat = '0.000'
    end
    object FixedHV: TFloatField
      FieldName = 'V'
      Visible = False
    end
    object FixedHVErr: TFloatField
      DisplayLabel = 'mV'
      FieldName = 'VErr'
      Visible = False
    end
  end
  object dsFixedH: TDataSource
    DataSet = FixedH
    Left = 112
    Top = 48
  end
end
