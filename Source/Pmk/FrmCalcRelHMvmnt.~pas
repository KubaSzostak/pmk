unit FrmCalcRelHMvmnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCalcMovement, ExtCtrls, AppEvnts, StdCtrls, Series,
  TeEngine, TeeProcs, Chart, FrameSelectItems, ComCtrls, CheckLst,
  BaseUnit, GeoMovements, GeoEstimations;

type
  TFmCalcRelHMvmnt = class(TBaseCalcMovement)
    Label7: TLabel;
    HMovement: THMovement;
    procedure FormCreate(Sender: TObject);
  public
  end;

var
  FmCalcRelHMvmnt: TFmCalcRelHMvmnt;

implementation

uses DatMod;

{$R *.dfm}

procedure TFmCalcRelHMvmnt.FormCreate(Sender: TObject);
begin
  GetFixedPointNames:= GetSelectedItems;
  SelectItems.MultiSelect:= False;
  Movement:= HMovement;
  FixedPoints:= nil;
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
