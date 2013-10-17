inherited FmSelectMovement: TFmSelectMovement
  Left = 300
  Top = 129
  Caption = 'Obliczanie przemiescze'#324
  ClientWidth = 544
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlButtons: TPanel
    Width = 544
    inherited BtnBack: TButton
      Visible = False
    end
  end
  inherited PageControl: TPageControl
    Width = 544
    ActivePage = TsSelectMovement
    object TsSelectMovement: TTabSheet
      Caption = 'TsSelectMovement'
      object Bevel2: TBevel
        Left = 40
        Top = 32
        Width = 460
        Height = 9
        Shape = bsTopLine
      end
      object Bevel3: TBevel
        Left = 40
        Top = 144
        Width = 460
        Height = 9
        Shape = bsTopLine
      end
      object Label1: TLabel
        Left = 72
        Top = 36
        Width = 170
        Height = 13
        Caption = ' Przemiesczenia bezwzgl'#281'dne '
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label2: TLabel
        Left = 72
        Top = 148
        Width = 150
        Height = 13
        Caption = ' Przemiesczenia wzgl'#281'dne '
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rbAbsoluteDh: TRadioButton
        Left = 104
        Top = 64
        Width = 369
        Height = 17
        Caption = 'Na podstawie zmian r'#243#380'nic przewy'#380'sze'#324' h-h'#39' (metoda r'#243#380'nicowa)'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbAbsoluteH: TRadioButton
        Left = 104
        Top = 88
        Width = 369
        Height = 17
        Caption = 'Na podstawie r'#243#380'nic rz'#281'dnych H i H'#39' '
        TabOrder = 1
      end
      object rbRelativeDh: TRadioButton
        Left = 104
        Top = 176
        Width = 369
        Height = 17
        Caption = 'Na podstawie zmian r'#243#380'nic przewy'#380'sze'#324' h-h'#39' (metoda r'#243#380'nicowa)'
        TabOrder = 2
      end
      object rbRelativeH: TRadioButton
        Left = 104
        Top = 200
        Width = 369
        Height = 17
        Caption = 'Na podstawie r'#243#380'nic rz'#281'dnych H i H'#39' '
        TabOrder = 3
      end
    end
  end
  inherited Panel1: TPanel
    Width = 544
    inherited LblPageTitle: TLabel
      Width = 252
      Caption = 'Kreator obliczania przemieszcze'#324' pionowych'
      ExplicitWidth = 252
    end
    inherited LblPageInfo: TLabel
      Width = 196
      Caption = 'Wyb'#243'r sposobu obliczania przemieszcze'#324
      ExplicitWidth = 196
    end
  end
end
