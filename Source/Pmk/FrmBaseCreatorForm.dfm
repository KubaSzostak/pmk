object BaseCreatorForm: TBaseCreatorForm
  Left = 313
  Top = 168
  BorderStyle = bsDialog
  Caption = 'BaseCreatorForm'
  ClientHeight = 373
  ClientWidth = 542
  Color = clBtnFace
  Constraints.MaxHeight = 407
  Constraints.MaxWidth = 550
  Constraints.MinHeight = 400
  Constraints.MinWidth = 550
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PnlButtons: TPanel
    Left = 0
    Top = 325
    Width = 542
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = PnlButtonsMouseDown
    DesignSize = (
      542
      48)
    object Bevel: TBevel
      Left = 0
      Top = 0
      Width = 542
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
    object BtnBack: TButton
      Left = 369
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '< Wstecz'
      TabOrder = 0
      OnClick = BtnBackClick
    end
    object BtnNext: TButton
      Left = 444
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Dalej >'
      Default = True
      TabOrder = 1
      OnClick = BtnNextClick
    end
    object BtnCancel: TButton
      Left = 40
      Top = 12
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Anuluj'
      TabOrder = 2
      OnClick = BtnCancelClick
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 49
    Width = 542
    Height = 276
    Align = alClient
    Style = tsFlatButtons
    TabHeight = 21
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 2
    object Bevel1: TBevel
      Left = 0
      Top = 41
      Width = 542
      Height = 8
      Align = alBottom
      Shape = bsBottomLine
    end
    object LblPageTitle: TLabel
      Left = 32
      Top = 8
      Width = 69
      Height = 13
      Caption = 'LblPageTitle'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblPageInfo: TLabel
      Left = 32
      Top = 24
      Width = 57
      Height = 13
      Caption = 'LblPageInfo'
    end
    object Image: TImage
      Left = 477
      Top = 4
      Width = 57
      Height = 41
      Center = True
      Transparent = True
    end
  end
end
