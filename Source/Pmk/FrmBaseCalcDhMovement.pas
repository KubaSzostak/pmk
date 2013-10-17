unit FrmBaseCalcDhMovement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, StdCtrls, FrameSelectItems, ComCtrls,
  ExtCtrls, CheckLst, BaseUnit, GeoCalc, GeoMovement, AppEvnts,
  GeoEstimation, PmkResStr, Series, TeEngine, TeeProcs, Chart;

type
  TBaseCalcDhMovement = class(TBaseCalcMovement)
    DhMovement: TDhMovement;
  private
  public
  end;

var
  BaseCalcDhMovement: TBaseCalcDhMovement;

implementation

uses DatMod;

{$R *.dfm}

end.
