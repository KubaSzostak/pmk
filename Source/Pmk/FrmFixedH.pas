unit FrmFixedH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseDBForm, Grids, DBGrids, DB, DBClient;

type
  TFmFixedH = class(TBaseDBForm)
    FixedH: TClientDataSet;
    dsFixedH: TDataSource;
    DBGrid1: TDBGrid;
    FixedHName: TStringField;
    FixedHH: TFloatField;
    FixedHHErr: TFloatField;
    FixedHV: TFloatField;
    FixedHVErr: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    procedure CheckBrowseMode; override;
  end;

var
  FmFixedH: TFmFixedH;

procedure ShowFixedH;

implementation

uses DatMod;

{$R *.dfm}    

procedure ShowFixedH;
begin
  if not Assigned(FmFixedH) then
    FmFixedH:= TFmFixedH.Create(Application);
  FmFixedH.Show;
end;

{ TFmObsDh }

procedure TFmFixedH.CheckBrowseMode;
begin
  InternalCheckBrowseMode(dsFixedH.DataSet);
end;

procedure TFmFixedH.FormCreate(Sender: TObject);
begin
  inherited;
  FixedH.CloneCursor(Dm.FixedH, False);
  DataSet:= FixedH;
end;

procedure TFmFixedH.FormDestroy(Sender: TObject);
begin
  inherited;
  FmFixedH:= nil;
end;

procedure TFmFixedH.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action:= caFree;
end;

end.
