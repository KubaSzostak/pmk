inherited FmDeltaH: TFmDeltaH
  Left = 271
  Top = 217
  Caption = 'Przemieszczenia reper'#243'w'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000200000000000000020000000000000002000000000000000200000000
    0000000200000000D00000020000000DDD000000000000DDDDD0000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFC7FFFFFFC7FFFFFFC7FFFFFFC7FFFFFFC7FFFFF701
    FFFFE383FFFFC1C7FFFF80EFFFFF80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TDBGrid
    DataSource = dsDeltaH
    ReadOnly = True
  end
  object DhCycles: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 64
  end
  object dsDhCycles: TDataSource
    DataSet = DhCycles
    Left = 96
    Top = 64
  end
  object DeltaH: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 56
    Top = 104
    object DeltaHCycleNo: TIntegerField
      FieldName = 'CycleNo'
      Visible = False
    end
    object DeltaHName: TStringField
      DisplayLabel = 'Nazwa'
      FieldName = 'Name'
    end
    object DeltaHDelta: TFloatField
      FieldName = 'Delta'
      DisplayFormat = '#0.000'
    end
    object DeltaHDeltaErr: TFloatField
      DisplayLabel = 'mDelta'
      FieldName = 'DeltaErr'
      DisplayFormat = '#0.000'
    end
  end
  object dsDeltaH: TDataSource
    DataSet = DeltaH
    Left = 96
    Top = 104
  end
end
