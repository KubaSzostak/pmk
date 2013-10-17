object FmDhCycleInfo: TFmDhCycleInfo
  Left = 261
  Top = 203
  Width = 491
  Height = 305
  Caption = 'Podsumowanie'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 483
    Height = 237
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Label1: TLabel
      Left = 264
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 264
      Top = 40
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 264
      Top = 56
      Width = 32
      Height = 13
      Caption = 'Label3'
    end
    object Label4: TLabel
      Left = 264
      Top = 80
      Width = 32
      Height = 13
      Caption = 'Label4'
    end
    object DBGrid1: TDBGrid
      Left = 4
      Top = 4
      Width = 229
      Height = 229
      Align = alLeft
      DataSource = Dm.dsDhCycles
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Name'
          Width = 200
          Visible = True
        end>
    end
    object DBEdit1: TDBEdit
      Left = 312
      Top = 24
      Width = 121
      Height = 21
      DataField = 'FixedPoints'
      DataSource = Dm.dsDhCycles
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 237
    Width = 483
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 483
      Height = 4
      Align = alTop
      Shape = bsTopLine
    end
  end
end
