inherited FmDeltaDh: TFmDeltaDh
  Left = 294
  Top = 258
  Caption = 'B'#322#281'dy przemiescze'#324' par reper'#243'w'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000011101110005555551115111
    5552220001110111000262000000000000026200000000000002620000000000
    0002620000000000022262220000000000266620000000000002620001110000
    000020055111011100055550011151115550000000000111000000000000FFFF
    FFFFFFFFFFFFFFF8FFFF8E00FFFF0038FFFF8E3FFFFFFE3FFFFFFE3FFFFFFE3F
    FFFFF80FFFFFFC1FFFFFFE38FFFFFF60FFFF8E18FFFF01FFFFFF8FFFFFFF}
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TDBGrid
    DataSource = dsMDh
    ReadOnly = True
  end
  object DhCycles: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 56
  end
  object DeltaDh: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 96
    object DeltaDhCycleNo: TIntegerField
      FieldName = 'CycleNo'
      Required = True
      Visible = False
    end
    object DeltaDhBeginPoint: TStringField
      DisplayLabel = 'Punkt pocz'#261'tkowy'
      FieldName = 'BeginPoint'
      Required = True
    end
    object DeltaDhEndPoint: TStringField
      DisplayLabel = 'Punkt ko'#324'cowy'
      FieldName = 'EndPoint'
      Required = True
    end
    object DeltaDhDh: TFloatField
      FieldName = 'Dh'
      Required = True
      DisplayFormat = '#0.000'
    end
    object DeltaDhDhErr: TFloatField
      DisplayLabel = 'mDh'
      FieldName = 'DhErr'
      Required = True
      DisplayFormat = '#0.000'
    end
  end
  object dsDhCycles: TDataSource
    DataSet = DhCycles
    Left = 128
    Top = 56
  end
  object dsMDh: TDataSource
    DataSet = DeltaDh
    Left = 128
    Top = 96
  end
end
