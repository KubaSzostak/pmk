unit FrmResH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseTabForm, Grids, DBGrids, Tabs, DB, DBClient, PmkResStr;

type
  TFmResH = class(TBaseTabForm)
    DhCycles: TClientDataSet;
    dsDhCycles: TDataSource;
    dsResH: TDataSource;
    ResH: TClientDataSet;
    ResHCycleNo: TIntegerField;
    ResHName: TStringField;
    ResHH: TFloatField;
    ResHHErr: TFloatField;
    ResHV: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
  public
  end;

var
  FmResH: TFmResH;

procedure ShowResH;

implementation

uses DatMod;

{$R *.dfm}     

procedure ShowResH;
begin
  if not Assigned(FmResH) then
    FmResH:= TFmResH.Create(Application);
  FmResH.Show;
end;

procedure TFmResH.FormCreate(Sender: TObject);
begin
  DhCycles.CloneCursor(Dm.DhCycles, False);
  ResH.CloneCursor(Dm.ResH, False);
  ResH.MasterSource:= dsDhCycles;
  ResH.MasterFields:= fnCycleNo;
  //ResH.ReadOnly wywo³uje zmiany we wszystkich klonach, zrobi³em Grid.ReadOnly = True
  GetTabs:= Dm.GetDhCycleNames;
  inherited;
end;

procedure TFmResH.FormDestroy(Sender: TObject);
begin
  inherited;
  FmResH:= nil;
end;

procedure TFmResH.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action:= caFree;
end;

procedure TFmResH.TabSetChange(Sender: TObject; NewTab: Integer;
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
