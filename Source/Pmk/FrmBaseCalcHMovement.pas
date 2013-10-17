unit FrmBaseCalcHMovement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, StdCtrls, FrameSelectItems, ComCtrls,
  ExtCtrls, CheckLst, AppEvnts, BaseUnit, GeoCalc, GeoEstimation,
  GeoMovement, PmkResStr, Series, TeEngine, TeeProcs, Chart;

type
  TBaseCalcHMovement = class(TBaseCalcMovement)
    HMovement: THMovement;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BaseCalcHMovement: TBaseCalcHMovement;

implementation

uses DatMod;

{$R *.dfm}

end.
