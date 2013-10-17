unit FrmCalcRelDhMvmnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, ExtCtrls, AppEvnts, StdCtrls, Series,
  TeEngine, TeeProcs, Chart, FrameSelectItems, ComCtrls, CheckLst,
  BaseUnit, GeoMovements, GeoEstimations;

type
  TFmCalcRelDhMvmnt = class(TBaseCalcMovement)
    DhMovement: TDhMovement;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
  public
  end;

var
  FmCalcRelDhMvmnt: TFmCalcRelDhMvmnt;

implementation

uses DatMod;

{$R *.dfm}

procedure TFmCalcRelDhMvmnt.FormCreate(Sender: TObject);
begin
  GetFixedPointNames:= GetSelectedItems;
  SelectItems.MultiSelect:= False;
  Movement:= DhMovement;
  FixedPoints:= nil;
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
