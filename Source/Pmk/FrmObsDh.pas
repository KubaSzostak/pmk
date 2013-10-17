unit FrmObsDh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseTabForm, Grids, DBGrids, Tabs, DB, PmkResStr, DBClient,
  Math, BaseUnit;

type
  TFmObsDh = class(TBaseTabForm)
    DhCycles: TClientDataSet;
    DhObs: TClientDataSet;
    dsDhObs: TDataSource;
    dsDhCycles: TDataSource;
    DhObsCycleNo: TIntegerField;
    DhObsBeginPoint: TStringField;
    DhObsEndPoint: TStringField;
    DhObsN: TIntegerField;
    DhObsDh: TFloatField;
    DhObsV: TFloatField;
    DhObsVErr: TFloatField;
    DhObsDh_Dh0: TFloatField;
    DhObsV_VErr: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure DhObsCalcFields(DataSet: TDataSet);
    procedure DhObsBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function DeleteTabEnabled: boolean; override;
    function AddTabEnabled: boolean; override;
    function EditTabEnabled: boolean; override;

    procedure AddTab; override;
    procedure DeleteTab; override;
    procedure EditTab; override;
  end;

var
  FmObsDh: TFmObsDh;

procedure ShowObsDh;

implementation

uses DatMod, FrmDhCycle, Matrices;

{$R *.dfm}

procedure ShowObsDh;
begin
  if not Assigned(FmObsDh) then
    FmObsDh:= TFmObsDh.Create(Application);
  FmObsDh.Show;
end;

{ TFmObsDh }

function TFmObsDh.AddTabEnabled: boolean;
begin
  result:= True;
end;

function TFmObsDh.DeleteTabEnabled: boolean;
begin
  result:= True;
end;

function TFmObsDh.EditTabEnabled: boolean;
begin
  result:= True;
end;

procedure TFmObsDh.AddTab;
begin
  Dm.AddDhCycle; // Powoduje prze³adowanie zak³adek
  inherited;
end;

procedure TFmObsDh.DeleteTab;
begin
  Dm.DeleteCykl(ActiveTabName);
  //inherited;
end;

procedure TFmObsDh.EditTab;
begin
  inherited;
  ShowDhCycle(DhCycles[fnCycleNo]);
end;

procedure TFmObsDh.FormCreate(Sender: TObject);
begin
  DhCycles.CloneCursor(Dm.DhCycles, False);
  DhObs.CloneCursor(Dm.DhObs, False); 
  DhObs.MasterSource:= dsDhCycles;
  DhObs.MasterFields:= fnCycleNo;
  GetTabs:= Dm.GetDhCycleNames;
  inherited;
end;

procedure TFmObsDh.FormDestroy(Sender: TObject);
begin
  inherited;
  FmObsDh:= nil;
end;

procedure TFmObsDh.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var NewTabName: string;
begin
  inherited;
  if csLoading in ComponentState then
    exit;
  NewTabName:= TabSet.Tabs[NewTab];
  AllowChange:= DhCycles.Locate(fnName, NewTabName, [loCaseInsensitive]);
  if not AllowChange then begin // Teoretycznie nie powinno siê zdarzyæ, ale je¿eli ju¿...
    TabSet.Tabs.Delete(NewTab); // ...to usuñ t¹ zak³adkê
    //LoadTabs; powoduje wywo³anie metody TabSetChange czyli nie koñcz¹c¹ siê rekurencjê
    ShowMessageFmt(emNoCycleName, [NewTabName]);
  end;
  DhObsDh_Dh0.Visible:= not AnsiSameText(NewTabName, Dm.BaseCycleName);
end;

procedure TFmObsDh.DhObsCalcFields(DataSet: TDataSet);
var BeginEndNames: Variant;
begin
  inherited;
  if not IsZero(DhObsVErr.AsFloat) then
    DhObsV_VErr.AsFloat:= DhObsV.AsFloat / DhObsVErr.AsFloat;
  BeginEndNames:= VarArrayOf([DhObsBeginPoint.AsString, DhObsEndPoint.AsString]);
  if Dm.DhObs0.Locate('BeginPoint;EndPoint', BeginEndNames, [loCaseInsensitive]) then
    DhObsDh_Dh0.AsFloat:= DhObsDh.AsFloat - Dm.DhObs0['Dh'];
end;

procedure TFmObsDh.DhObsBeforePost(DataSet: TDataSet);
begin
  inherited;
  if SameText( DhObsBeginPoint.AsString, DhObsEndPoint.AsString) then
    RaiseError(emSameBeginEndPoint);
end;

end.
