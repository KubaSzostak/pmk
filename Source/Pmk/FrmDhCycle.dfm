object FmDhCycle: TFmDhCycle
  Left = 283
  Top = 218
  BorderStyle = bsDialog
  Caption = 'Cykl'
  ClientHeight = 195
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 337
    Height = 145
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 59
      Height = 13
      Caption = 'nazwa cyklu'
    end
    object Label2: TLabel
      Left = 176
      Top = 16
      Width = 21
      Height = 13
      Caption = 'data'
    end
    object Label3: TLabel
      Left = 16
      Top = 64
      Width = 19
      Height = 13
      Caption = 'opis'
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 32
      Width = 145
      Height = 21
      DataField = 'Name'
      DataSource = dsDhCycles
      TabOrder = 0
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 80
      Width = 305
      Height = 49
      DataField = 'Description'
      DataSource = dsDhCycles
      MaxLength = 255
      TabOrder = 1
    end
    object dtPicker: TDateTimePicker
      Left = 176
      Top = 32
      Width = 145
      Height = 21
      Date = 37373.638681099500000000
      Format = 'yyyy.mm.dd'
      Time = 37373.638681099500000000
      TabOrder = 2
      OnChange = dtPickerChange
    end
  end
  object btnOK: TButton
    Left = 272
    Top = 160
    Width = 73
    Height = 25
    Caption = 'ok'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnAnuluj: TButton
    Left = 184
    Top = 160
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'anuluj'
    TabOrder = 2
    OnClick = btnAnulujClick
  end
  object dsDhCycles: TDataSource
    DataSet = DhCycles
    Left = 112
    Top = 88
  end
  object DhCycles: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 88
  end
end
