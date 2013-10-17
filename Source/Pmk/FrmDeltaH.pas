unit FrmDeltaH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseTabForm, Grids, DBGrids, Tabs, DB, DBClient;

type
  TFmDeltaH = class(TBaseTabForm)
    DhCycles: TClientDataSet;
    dsDhCycles: TDataSource;
    DeltaH: TClientDataSet;
    dsDeltaH: TDataSource;
    DeltaHCycleNo: TIntegerField;
    DeltaHName: TStringField;
    DeltaHDelta: TFloatField;
    DeltaHDeltaErr: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }  
    function DeleteTabEnabled: boolean; override;
    function AddTabEnabled: boolean; override;
    function EditTabEnabled: boolean; override;
    procedure EditTab; override;
  end;

var
  FmDeltaH: TFmDeltaH;

procedure ShowFmDeltaH;

implementation

uses DatMod, FrmDhCycle, PmkResStr;

procedure ShowFmDeltaH;
begin
  if not Assigned(FmDeltaH) then
    FmDeltaH:= TFmDeltaH.Create(Application);
  FmDeltaH.Show;
end;

{$R *.dfm}

function TFmDeltaH.AddTabEnabled: boolean;
begin
  Result:= False;
end;

function TFmDeltaH.DeleteTabEnabled: boolean;
begin
  Result:= False;
end;

function TFmDeltaH.EditTabEnabled: boolean;
begin
  Result:= True;
end;

procedure TFmDeltaH.EditTab;
begin
  inherited;    
  ShowDhCycle(DhCycles[fnCycleNo]);
end;

procedure TFmDeltaH.FormCreate(Sender: TObject);
begin
  GetTabs:= Dm.GetDhCycleNamesEx;
  DhCycles.CloneCursor(Dm.DhCycles, False);
  DeltaH.CloneCursor(Dm.DeltaH, False);
  DeltaH.MasterSource:= dsDhCycles;
  DeltaH.MasterFields:= fnCycleNo;
  inherited;
end;

procedure TFmDeltaH.FormDestroy(Sender: TObject);
begin
  inherited;
  FmDeltaH:= nil;
end;

procedure TFmDeltaH.TabSetChange(Sender: TObject; NewTab: Integer;
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
