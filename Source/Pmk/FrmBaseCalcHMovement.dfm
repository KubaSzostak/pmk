inherited BaseCalcHMovement: TBaseCalcHMovement
  Left = 304
  Top = 173
  Caption = 'BaseCalcHMovement'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    ActivePage = TsResults
    TabIndex = 9
  end
  inherited ApplicationEvents: TApplicationEvents
    Left = 384
  end
  object HMovement: THMovement
    FreeEstimation = False
    Left = 336
    Top = 8
  end
end
