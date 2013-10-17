unit FrmCalcAbsDhMvmnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, ExtCtrls, AppEvnts, StdCtrls, Series,
  TeEngine, TeeProcs, Chart, FrameSelectItems, ComCtrls, CheckLst,
  GeoMovements, BaseUnit, GeoEstimations;

type
  TFmCalcAbsDhMvmnt = class(TBaseCalcMovement)
    DhMovement: TDhMovement;
    DhFixedPoints: TDhFixedPoints;
    procedure FormCreate(Sender: TObject);
  public
  end;

var
  FmCalcAbsDhMvmnt: TFmCalcAbsDhMvmnt;

implementation

uses DatMod;

{$R *.dfm}

procedure TFmCalcAbsDhMvmnt.FormCreate(Sender: TObject);
begin
  Movement:= DhMovement;
  FixedPoints:= DhFixedPoints;
  DhFixedPoints.DhMovement:= DhMovement;
  inherited;
  with DhMovement do begin
    BaseObsSource.DataSet:= Dm.DhObs0;
    ObsSource.DataSet:= Dm.DhObs;
    DeltaDhSource.DataSet:= Dm.DeltaDh;
    DeltaHSource.DataSet:= Dm.DeltaH;
    VSource.DataSet:= Dm.DhObs;
  end;
end;

end.
