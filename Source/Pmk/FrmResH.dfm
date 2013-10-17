inherited FmResH: TFmResH
  Left = 434
  Top = 375
  Caption = 'Rz'#281'dne reper'#243'w po wyr'#243'wnaniu'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TDBGrid
    DataSource = dsResH
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
  object dsResH: TDataSource
    DataSet = ResH
    Left = 96
    Top = 104
  end
  object ResH: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 56
    Top = 104
    object ResHCycleNo: TIntegerField
      FieldName = 'CycleNo'
      Required = True
      Visible = False
    end
    object ResHName: TStringField
      FieldName = 'Name'
      Required = True
    end
    object ResHH: TFloatField
      FieldName = 'H'
      Required = True
      DisplayFormat = '#0.000'
    end
    object ResHHErr: TFloatField
      DisplayLabel = 'mH'
      FieldName = 'HErr'
      Required = True
      DisplayFormat = '#0.000'
    end
    object ResHV: TFloatField
      FieldName = 'V'
      DisplayFormat = '#0.000'
    end
  end
end
