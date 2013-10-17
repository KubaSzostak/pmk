unit FrmDhCycle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, ComCtrls, DB, DBClient, CDSUtils;

type
  TFmDhCycle = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    btnOK: TButton;
    btnAnuluj: TButton;
    dtPicker: TDateTimePicker;
    dsDhCycles: TDataSource;
    DhCycles: TClientDataSet;
    procedure dtPickerChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAnulujClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmDhCycle: TFmDhCycle;

procedure ShowDhCycle(CycleNo: integer);

implementation

uses DatMod, FrmBaseTabForm;

procedure ShowDhCycle(CycleNo: integer);
begin
  with TFmDhCycle.Create(Application) do
  try
    DhCycles.Locate(fnCycleNo, CycleNo, []);
    ShowModal;
  finally
    Close;
    Free;
  end;
end;

{$R *.dfm}

procedure TFmDhCycle.dtPickerChange(Sender: TObject);
begin
  DhCycles[fnDate]:= dtPicker.Date;
end;

procedure TFmDhCycle.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with DhCycles do
    if State in dsEditModes then Cancel;
  Action:= caFree;
  FmDhCycle:= nil;
end;

procedure TFmDhCycle.btnAnulujClick(Sender: TObject);
begin
  Close;
end;

procedure TFmDhCycle.btnOKClick(Sender: TObject);
begin
  with DhCycles do
    if State in dsEditModes then Post;
  Close;
end;

procedure TFmDhCycle.FormShow(Sender: TObject);
begin
  DhCycles.Edit;
  dtPicker.Date:= DhCycles[fnDate];
end;

procedure TFmDhCycle.FormCreate(Sender: TObject);
begin
  cdsUtils.CloneDataSet(Dm.DhCycles, DhCycles);
end;

end.
