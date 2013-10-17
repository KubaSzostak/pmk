unit FrmDeltaDh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseTabForm, Grids, DBGrids, Tabs, DB, DBClient;

type
  TFmDeltaDh = class(TBaseTabForm)
    DhCycles: TClientDataSet;
    DeltaDh: TClientDataSet;
    dsDhCycles: TDataSource;
    dsMDh: TDataSource;
    DeltaDhCycleNo: TIntegerField;
    DeltaDhBeginPoint: TStringField;
    DeltaDhEndPoint: TStringField;
    DeltaDhDh: TFloatField;
    DeltaDhDhErr: TFloatField;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
  public
    function DeleteTabEnabled: boolean; override;
    function AddTabEnabled: boolean; override;
    function EditTabEnabled: boolean; override;
    procedure EditTab; override;
  end;

var
  FmDeltaDh: TFmDeltaDh;

procedure ShowDeltaDh;

implementation

uses FrmDhCycle, DatMod, PmkResStr;

{$R *.dfm}

procedure ShowDeltaDh;
begin
  if not Assigned(FmDeltaDh) then
    FmDeltaDh:= TFmDeltaDh.Create(Application);
  FmDeltaDh.Show;
end;

{ TFmResMDh }

function TFmDeltaDh.AddTabEnabled: boolean;
begin
  Result:= False;
end;

function TFmDeltaDh.DeleteTabEnabled: boolean;
begin
  Result:= False;
end;

function TFmDeltaDh.EditTabEnabled: boolean;
begin
  Result:= True;
end;

procedure TFmDeltaDh.EditTab;
begin
  inherited;
  ShowDhCycle(DhCycles[fnCycleNo]);
end;

procedure TFmDeltaDh.FormDestroy(Sender: TObject);
begin
  inherited;
  FmDeltaDh:= nil;
end;

procedure TFmDeltaDh.FormCreate(Sender: TObject);
begin
  GetTabs:= Dm.GetDhCycleNamesEx;
  DhCycles.CloneCursor(Dm.DhCycles, False);
  DeltaDh.CloneCursor(Dm.DeltaDh, False);
  DeltaDh.MasterSource:= dsDhCycles;
  DeltaDh.MasterFields:= fnCycleNo;
  inherited;
end;

procedure TFmDeltaDh.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var NewTabName: string;
begin
  inherited;
  NewTabName:= TabSet.Tabs[NewTab];
  AllowChange:= DhCycles.Locate(fnName, NewTabName, [loCaseInsensitive]);
  if not AllowChange then begin // Teoretycznie nie powinno siê zdarzyæ, ale je¿eli ju¿...
    TabSet.Tabs.Delete(NewTab); // ...to usuñ t¹ zak³adkê
    ShowMessageFmt(emNoCycleName, [NewTabName]);
  end;
end;

end.
