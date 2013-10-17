object Dm: TDm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 396
  Width = 336
  object DhCycles: TClientDataSet
    Active = True
    Aggregates = <>
    AggregatesActive = True
    Constraints = <
      item
        FromDictionary = False
      end>
    FieldDefs = <
      item
        Name = 'CycleNo'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Name'
        Attributes = [faRequired]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Description'
        DataType = ftMemo
      end
      item
        Name = 'BaseCycle'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'Calc'
        DataType = ftBoolean
      end
      item
        Name = 'Date'
        DataType = ftDateTime
      end
      item
        Name = 'EstimatedVariance'
        DataType = ftFloat
      end
      item
        Name = 'StandartError'
        DataType = ftFloat
      end
      item
        Name = 'StandartErrorErr'
        DataType = ftFloat
      end
      item
        Name = 'FreeEstimation'
        DataType = ftBoolean
      end
      item
        Name = 'FixedPoints'
        DataType = ftMemo
        Size = 1
      end
      item
        Name = 'EstimationType'
        DataType = ftInteger
      end>
    IndexDefs = <
      item
        Name = 'CycleNo'
        Fields = 'CycleNo'
        Options = [ixUnique]
      end
      item
        Name = 'Name'
        Fields = 'Name'
        Options = [ixUnique, ixCaseInsensitive]
      end>
    IndexName = 'CycleNo'
    Params = <>
    StoreDefs = True
    BeforePost = DhCyclesBeforePost
    AfterPost = DhCyclesAfterPost
    AfterDelete = DhCyclesAfterDelete
    Left = 24
    Top = 64
    Data = {
      400100009619E0BD01000000180000000C000000000003000000400107437963
      6C654E6F0400010004000000044E616D65010049000400010005574944544802
      00020032000B4465736372697074696F6E04004B000000010007535542545950
      45020049000500546578740009426173654379636C6502000300040000000443
      616C6302000300000000000444617465080008000000000011457374696D6174
      656456617269616E636508000400000000000D5374616E646172744572726F72
      0800040000000000105374616E646172744572726F7245727208000400000000
      000E46726565457374696D6174696F6E02000300000000000B4669786564506F
      696E747304004B00000002000753554254595045020049000500546578740005
      57494454480200020001000E457374696D6174696F6E54797065040001000000
      00000000}
    object DhCyclesCycleNo: TIntegerField
      FieldName = 'CycleNo'
      Required = True
    end
    object DhCyclesName: TStringField
      FieldName = 'Name'
      Required = True
      Size = 50
    end
    object DhCyclesDescription: TMemoField
      FieldName = 'Description'
      BlobType = ftMemo
    end
    object DhCyclesBaseCycle: TBooleanField
      FieldName = 'BaseCycle'
      Required = True
    end
    object DhCyclesCalc: TBooleanField
      FieldName = 'Calc'
    end
    object DhCyclesDate: TDateTimeField
      FieldName = 'Date'
    end
    object DhCyclesEstimatedVariance: TFloatField
      FieldName = 'EstimatedVariance'
      DisplayFormat = '0.000'
    end
    object DhCyclesStandartError: TFloatField
      FieldName = 'StandartError'
      DisplayFormat = '0.000'
    end
    object DhCyclesStandartErrorErr: TFloatField
      FieldName = 'StandartErrorErr'
    end
    object DhCyclesFreeEstimation: TBooleanField
      FieldName = 'FreeEstimation'
    end
    object DhCyclesFixedPoints: TMemoField
      FieldName = 'FixedPoints'
      BlobType = ftMemo
      Size = 1
    end
    object DhCyclesEstimationType: TIntegerField
      FieldName = 'EstimationType'
    end
    object DhCyclesMaxCycleNo: TAggregateField
      FieldName = 'MaxCycleNo'
      Active = True
      Expression = 'MAX(CycleNo)'
    end
  end
  object InternalDhCycles: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 16
  end
  object DhObs0: TClientDataSet
    Aggregates = <>
    ObjectView = False
    Params = <
      item
        DataType = ftInteger
        Name = 'CycleNo'
        ParamType = ptInputOutput
        Value = 1
      end>
    Left = 80
    Top = 112
  end
  object DlgOpen: TOpenDialog
    DefaultExt = 'pmk'
    Filter = 'Pliki programu pmk (*.gxml)|*.gxml'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Otw'#243'rz...'
    Left = 224
    Top = 24
  end
  object DlgSave: TSaveDialog
    DefaultExt = 'pmk'
    Filter = 'Pliki programu pmk (*.gxml)|*.gxml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing]
    Title = 'Zapisz jako...'
    Left = 224
    Top = 72
  end
  object DeltaH: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CycleNo'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Name'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Delta'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'DeltaErr'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    IndexDefs = <
      item
        Name = 'Name'
        Fields = 'Name'
      end>
    IndexFieldNames = 'CycleNo'
    MasterFields = 'CycleNo'
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 160
    Data = {
      620000009619E0BD010000001800000004000000000003000000620007437963
      6C654E6F0400010004000000044E616D65010049000400010005574944544802
      00020014000544656C746108000400040000000844656C746145727208000400
      040000000000}
  end
  object DeltaDh: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CycleNo'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'BeginPoint'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'EndPoint'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Dh'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'DhErr'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    IndexDefs = <>
    IndexFieldNames = 'CycleNo'
    MasterFields = 'CycleNo'
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 208
    Data = {
      7F0000009619E0BD0100000018000000050000000000030000007F0007437963
      6C654E6F04000100040000000A426567696E506F696E74010049000400010005
      574944544802000200140008456E64506F696E74010049000400010005574944
      5448020002001400024468080004000400000005446845727208000400040000
      000000}
  end
  object dsDhCycles: TDataSource
    DataSet = DhCycles
    Left = 80
    Top = 64
  end
  object DhObs: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CycleNo'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'BeginPoint'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'EndPoint'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Dh'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'DhErr'
        DataType = ftFloat
      end
      item
        Name = 'N'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'V'
        DataType = ftFloat
      end
      item
        Name = 'VErr'
        DataType = ftFloat
      end>
    IndexDefs = <>
    IndexFieldNames = 'CycleNo'
    MasterFields = 'CycleNo'
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 112
    Data = {
      A00000009619E0BD010000001800000008000000000003000000A00007437963
      6C654E6F04000100040000000A426567696E506F696E74010049000400010005
      574944544802000200140008456E64506F696E74010049000400010005574944
      5448020002001400024468080004000400000005446845727208000400000000
      00014E0400010004000000015608000400000000000456457272080004000000
      00000000}
  end
  object FixedH: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Name'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'H'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'HErr'
        DataType = ftFloat
      end
      item
        Name = 'V'
        DataType = ftFloat
      end
      item
        Name = 'VErr'
        DataType = ftFloat
      end>
    IndexDefs = <
      item
        Name = 'PrimaryIndex'
        Fields = 'Name'
        Options = [ixPrimary, ixUnique]
      end>
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 256
    Data = {
      610000009619E0BD0100000018000000050000000000030000006100044E616D
      6501004900040001000557494454480200020014000148080004000400000004
      4845727208000400000000000156080004000000000004564572720800040000
      0000000000}
  end
  object ResH: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CycleNo'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Name'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'H'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'HErr'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'V'
        DataType = ftFloat
      end>
    IndexDefs = <
      item
        Name = 'PrimaryIndex'
        Fields = 'CycleNo;Name'
        Options = [ixPrimary, ixUnique]
      end>
    IndexFieldNames = 'CycleNo'
    MasterFields = 'CycleNo'
    MasterSource = dsDhCycles
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    Left = 64
    Top = 256
    Data = {
      640000009619E0BD010000001800000005000000000003000000640007437963
      6C654E6F0400010004000000044E616D65010049000400010005574944544802
      0002001400014808000400040000000448457272080004000400000001560800
      0400000000000000}
  end
  object ResH0: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = ResH0BeforePost
    Left = 104
    Top = 256
  end
end
