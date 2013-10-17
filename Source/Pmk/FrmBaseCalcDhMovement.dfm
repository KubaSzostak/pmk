inherited BaseCalcDhMovement: TBaseCalcDhMovement
  Left = 254
  Top = 200
  Caption = 'Kreator obliczania przemieszcze'#324' pionowych'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    inherited TsFixedPoints: TTabSheet
      inherited SelectItems: TSelectItems
        inherited PnlCenter: TPanel
          inherited BtnFilter: TSpeedButton
            Visible = False
          end
        end
      end
    end
    inherited TsFixedPointGroup: TTabSheet
      inherited PageCtlRepGroups: TPageControl
        inherited TsRepGroup: TTabSheet
          inherited LvRepGroup: TListView
            OnChange = nil
          end
        end
        inherited TsGeneralChart: TTabSheet
          inherited GeneralChart: TChart
            OnMouseMove = nil
          end
        end
      end
      inherited Panel2: TPanel
        inherited Panel3: TPanel
          inherited Panel5: TPanel
            inherited EdMinRepCount: TLabeledEdit
              OnChange = nil
              OnEnter = nil
              OnExit = nil
              OnKeyDown = nil
            end
            inherited EdWspK: TLabeledEdit
              OnChange = nil
              OnEnter = nil
              OnExit = nil
              OnKeyDown = nil
            end
          end
        end
        inherited Panel6: TPanel
          inherited LvRepGroups: TListView
            OnChange = nil
          end
        end
      end
    end
  end
  object DhMovement: TDhMovement [3]
    FreeEstimation = False
    Left = 144
    Top = 144
  end
end
