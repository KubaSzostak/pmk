unit FrmCalcAbsHMvmnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, ExtCtrls, AppEvnts, StdCtrls, Series,
  TeEngine, TeeProcs, Chart, FrameSelectItems, ComCtrls, CheckLst,
  GeoMovements, BaseUnit, GeoEstimations;

type
  TFmCalcAbsHMvmnt = class(TBaseCalcMovement)
    HMovement: THMovement;
    HFixedPoints: THFixedPoints;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  FmCalcAbsHMvmnt: TFmCalcAbsHMvmnt;

implementation

uses DatMod;

{$R *.dfm}


procedure TFmCalcAbsHMvmnt.FormCreate(Sender: TObject);
begin
  Movement:= HMovement;
  FixedPoints:= HFixedPoints;    
  HFixedPoints.HMovement:= HMovement;
  inherited;
  with HMovement do begin
    BaseObsSource.DataSet:= Dm.DhObs0;
    ObsSource.DataSet:= Dm.DhObs;
    DeltaDhSource.DataSet:= Dm.DeltaDh;
    DeltaHSource.DataSet:= Dm.DeltaH;
    VSource.DataSet:= Dm.DhObs;

    BaseVSource.DataSet:= Dm.DhObs0;
    with BaseVSource do begin
      BeginPointField:= 'BeginPoint';
      EndPointField:= 'EndPoint';
      ValueField:= 'V';
      ErrorField:= 'VErr';
    end;

    FixedHSource.DataSet:= Dm.FixedH;
    with FixedHSource do begin
      NameField:= 'Name';
      ValueField:= 'H';
      ErrorField:= 'HErr';
    end;

    HSource.DataSet:= Dm.ResH;
    with HSource do begin
      NameField:= 'Name';
      ValueField:= 'H';
      ErrorField:= 'HErr';
    end;

    BaseHSource.DataSet:= Dm.ResH0;
    with BaseHSource do begin
      NameField:= 'Name';
      ValueField:= 'H';
      ErrorField:= 'HErr';
    end;
  end;

end;

end.
