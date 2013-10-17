unit FrmBaseTabForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseDBForm, Grids, DBGrids, DB, DBClient, Tabs;

type
  TGetTabsProcedure = procedure (Tabs: TStrings) of object;

  TBaseTabForm = class(TBaseDBForm)
    TabSet: TTabSet;
    Grid: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLastTabIndex: integer;
    function GetActiveTabName: string;
    procedure SetActiveTabName(const Value: string);
  protected
    GetTabs: TGetTabsProcedure;
  public
    procedure Print; override;
    procedure PrintPreview; override;
    function DeleteTabEnabled: boolean; virtual;
    function AddTabEnabled: boolean; virtual;
    function EditTabEnabled: boolean; virtual;

    procedure AddTab; virtual;
    procedure DeleteTab; virtual;
    procedure EditTab; virtual;
    procedure SetTabIndex(Index: integer); virtual;
    procedure LoadTabs;  virtual;
    procedure UpdateActiveTab; virtual;
    procedure CheckBrowseMode; override;

    property ActiveTabName: string read GetActiveTabName write SetActiveTabName;
  end;

var
  BaseTabForm: TBaseTabForm;


procedure UpdateTabForms;

implementation

uses FrmPrintPreview;

{$R *.dfm}

procedure UpdateTabForms;
var i: integer;
begin
  with Application.MainForm do
  for i:=0 to MDIChildCount do
  if MDIChildren[i] is TBaseTabForm then
    TBaseTabForm(MDIChildren[i]).LoadTabs;
end;

{ TBaseTabForm }    

procedure TBaseTabForm.Print;
begin
  if PrintEnabled then
    TFmPrintPreview.PrintDataSet(DataSet, Caption+': '+ActiveTabName);
end;

procedure TBaseTabForm.PrintPreview;
begin
  if PrintPreviewEnabled then
    TFmPrintPreview.PreviewDataSet(DataSet, Caption+': '+ActiveTabName);
end;

procedure TBaseTabForm.CheckBrowseMode;
begin
  if Assigned(Grid.DataSource) then
    InternalCheckBrowseMode(Grid.DataSource.DataSet);
end;


procedure TBaseTabForm.LoadTabs;
var ActiveTabName: string;
    ActiveTabIndex, OldTabIndex: integer;
begin
  inherited;
  if Assigned(GetTabs) then
  with TabSet do begin
    OldTabIndex:= TabIndex;
    if (TabIndex < Tabs.Count) and (TabIndex > -1) then
      ActiveTabName:= Tabs[TabIndex];
    Tabs.BeginUpdate;
    try
    GetTabs(TabSet.Tabs);
    ActiveTabIndex:= Tabs.IndexOf(ActiveTabName);  // Najpierw próbujê szukaæ po nazwach zak³adek...
    if ActiveTabIndex < 0 then
      ActiveTabIndex:= OldTabIndex;  // ...a je¿eli nie znajdê to po Indeksie (Przy zmianie nazwy zak³adki)
    if (ActiveTabIndex > -1) and (ActiveTabIndex < Tabs.Count)  then
      TabIndex:= ActiveTabIndex
    else
      if Tabs.Count > 0 then
        TabIndex:= 0;
    finally
      Tabs.EndUpdate;
    end;
  end;
end;

procedure TBaseTabForm.UpdateActiveTab;
begin

end;

procedure TBaseTabForm.SetTabIndex(Index: integer);
begin
  with TabSet do
    if (Index < Tabs.Count) and (Index > -1) then
      TabIndex:= Index;
end;

procedure TBaseTabForm.FormCreate(Sender: TObject);
begin
  inherited;
  if Assigned(Grid.DataSource) then
    DataSet:= Grid.DataSource.DataSet;
  ReadOnly:= Grid.ReadOnly;
  LoadTabs;
end;

procedure TBaseTabForm.AddTab;
begin
  // Set addet tab as active
  with TabSet do
    TabIndex := Tabs.Count -1;
end;

procedure TBaseTabForm.DeleteTab;
begin
  with TabSet do
  if TabIndex > -1 then
    Tabs.Delete(TabIndex);
end;

procedure TBaseTabForm.EditTab;
begin

end;

function TBaseTabForm.GetActiveTabName: string;
begin
  with TabSet do
  if TabIndex > -1 then
    result:= Tabs[TabIndex]
  else
    result:= '';
end;

procedure TBaseTabForm.SetActiveTabName(const Value: string);
begin
  with TabSet do
  if TabIndex > -1 then
    Tabs[TabIndex]:= Value;
end;

function TBaseTabForm.AddTabEnabled: boolean;
begin
  result:= false;
end;

function TBaseTabForm.DeleteTabEnabled: boolean;
begin
  result:= false;
end;

function TBaseTabForm.EditTabEnabled: boolean;
begin
  result:= false;
end;

procedure TBaseTabForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and not (ssAlt in Shift) then
    case Key of
      Ord('l'), Ord('L'):  // Set last tab
        SetTabIndex(FLastTabIndex);
    end;
end;

procedure TBaseTabForm.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  inherited;
  FLastTabIndex:= TabSet.TabIndex;
  if not (csLoading in ComponentState) then
    inherited;
end;

procedure TBaseTabForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action:= caNone;
  CheckBrowseMode;
  Action:= caFree;
end;

end.
