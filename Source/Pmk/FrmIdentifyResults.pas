unit FrmIdentifyResults;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Series, TeEngine, TeeProcs, Chart, ExtCtrls,
  ToolWin, ActnList, ImgList, Menus, Math,
  GeoMovements, GeoSysUtils;

type
  TGetNamesMethod = procedure (Names: TStrings) of object;

  TFmIdentifyResults = class(TForm)
    ToolBar: TToolBar;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    EdMinRepCount: TLabeledEdit;
    EdWspK: TLabeledEdit;
    Panel6: TPanel;
    LvRepGroups: TListView;
    Panel7: TPanel;
    PnlFixedPointCount: TPanel;
    PageCtlRepGroups: TPageControl;
    TsRepGroup: TTabSheet;
    LvRepGroup: TListView;
    TsGeneralChart: TTabSheet;
    GeneralChart: TChart;
    Series2: TPointSeries;
    Series1: TPointSeries;
    Series5: TLineSeries;
    Series4: TLineSeries;
    TsDetailChart: TTabSheet;
    DetailChart: TChart;
    PointSeries2: TPointSeries;
    PointSeries1: TPointSeries;
    Series3: TPointSeries;
    Series6: TLineSeries;
    TsSettings: TTabSheet;
    Panel4: TPanel;
    Label6: TLabel;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList: TImageList;
    ActionList: TActionList;
    ActSave: TAction;
    ActPrint: TAction;
    ActZoomIn: TAction;
    ActZoomOut: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ChartMenu: TPopupMenu;
    Zapiszwykres1: TMenuItem;
    Drukuj1: TMenuItem;
    N1: TMenuItem;
    Powiksz1: TMenuItem;
    Pomniejsz1: TMenuItem;
    Timer: TTimer;
    ActSeparator: TAction;
    DlgSave: TSaveDialog;
    DlgPrintSetup: TPrinterSetupDialog;
    ToolButton6: TToolButton;
    ActPrintSetup: TAction;
    Ustawieniadrukarki1: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure LvRepGroupChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure EdMinRepCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdMinRepCountChange(Sender: TObject);
    procedure EdMinRepCountEnter(Sender: TObject);
    procedure EdMinRepCountExit(Sender: TObject);
    procedure GeneralChartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActPrintExecute(Sender: TObject);
    procedure ActZoomInExecute(Sender: TObject);
    procedure ActZoomOutExecute(Sender: TObject);
    procedure ActSeparatorExecute(Sender: TObject);
    procedure ActPrintSetupExecute(Sender: TObject);
    procedure LvRepGroupsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
  private
    FFixedCountOK: Boolean;
    FOnChange: TNotifyEvent;
    procedure LoadDetailChart(Group: TFixedPointGroup);
    procedure LoadGeneralChart(Group: TFixedPointGroup);
    procedure LoadGroup(Group: TFixedPointGroup);
    procedure LoadGroups;
    procedure LoadReperList(Group: TFixedPointGroup);
    procedure ReloadActiveGroup;
    procedure SetChartAxises(Chart: TChart);
    procedure UpdateFixedRepersEdits;
    function ActiveChart: TChart;
    function GetCheckedPointCount: Integer;
    procedure Changed;
    procedure FixedCountChanged;
  protected
    FixedPoints: TCustomFixedPoints;
  public
    procedure GetSelectedGroup(Names: TStrings);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property FixedCountOK: Boolean read FFixedCountOK;
  end;

var
  FmIdentifyResults: TFmIdentifyResults;

function LoadIdentifyResults(OwnerControl: TWinControl; AFixedPoints: TCustomFixedPoints): TFmIdentifyResults;
function ShowIdentifyResults(AFixedPoints: TCustomFixedPoints): TFmIdentifyResults;
procedure ShowIdentifyResultsModal(AFixedPoints: TCustomFixedPoints);

implementation

{$R *.dfm}

resourcestring
  sCount = 'Iloœæ: %d';

function LoadIdentifyResults(OwnerControl: TWinControl; AFixedPoints: TCustomFixedPoints): TFmIdentifyResults;
begin
  Result:= TFmIdentifyResults.Create(OwnerControl);
  with Result do begin
    FixedPoints:= AFixedPoints;
    Parent:= OwnerControl;
    Align:= alClient;
    BorderStyle:= bsNone;
    ToolBar.Hide;
    Show;
  end;
end;

function ShowIdentifyResults(AFixedPoints: TCustomFixedPoints): TFmIdentifyResults;
begin
  Result:= TFmIdentifyResults.Create(Application);
  with Result do begin
    FixedPoints:= AFixedPoints;
    Show;
  end;
end;

procedure ShowIdentifyResultsModal(AFixedPoints: TCustomFixedPoints);
begin
  with TFmIdentifyResults.Create(Application) do
  try
    FixedPoints:= AFixedPoints;
    ShowModal;
  finally
    Free;
  end;
end;

{ TFmIdentifyResults }

procedure TFmIdentifyResults.Changed;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TFmIdentifyResults.LoadGroup(Group: TFixedPointGroup);
begin
  LoadReperList(Group);
  LoadGeneralChart(Group);
  LoadDetailChart(Group);
  PnlFixedPointCount.Caption:= Format(sCount, [Group.Count]);
end;

procedure TFmIdentifyResults.LoadGroups;
var i: Integer;
begin
  try
    FixedPoints.MinPointCount:= Round(StrAsFloat(EdMinRepCount.Text));
    FixedPoints.IdentifyTolerance:= StrAsFloat(EdWspK.Text);
  except
    UpdateFixedRepersEdits;
    Raise;
  end;

  FixedPoints.IdentifyGroups;

  with LvRepGroups do begin
    Items.BeginUpdate;
    try
      Clear;
      for i:= 0 to FixedPoints.GroupCount-1 do
        Items.Add.Caption:= Format('Grupa %d', [i+1]);
      Items.Add.Caption:= 'Wszystkie';
    finally
      Items.EndUpdate;
    end;
    Selected:= Items[0];
  end;
  UpdateFixedRepersEdits; 
  LvRepGroup.Repaint;
end;

procedure TFmIdentifyResults.LoadReperList(Group: TFixedPointGroup);
var i: Integer;
begin
  with LvRepGroup do begin
    Items.BeginUpdate;
    try
      Clear;
      for i:= 0 to Group.Count-1 do
        with Items.Add, Group do begin
          Caption:= Points[i].Name;
          SubItems.Add(FormatFloat('0.00', Points[i].Movement));
          SubItems.Add(FormatFloat('0.00', Points[i].Error));   
          SubItems.Add(FormatFloat('0.00', Points[i].Error*FixedPoints.IdentifyTolerance));
          Checked:= Points[i].Checked;
          Data:= @Group.Points[i];
        end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TFmIdentifyResults.ReloadActiveGroup;
begin
  LvRepGroupsSelectItem(Self, LvRepGroups.Selected, True);
end;

procedure TFmIdentifyResults.UpdateFixedRepersEdits;
begin
  EdMinRepCount.Text:= IntToStr(FixedPoints.MinPointCount);
  EdWspK.Text:= FormatFloat('0.00', FixedPoints.IdentifyTolerance);
  Timer.Enabled:= False;
end;

procedure TFmIdentifyResults.LoadDetailChart(Group: TFixedPointGroup);
var i: Integer;
    IdentifyRange: Double;
begin
  with DetailChart do begin
    for i:= 0 to SeriesCount-1 do begin
      Series[i].Clear;
    end;
    for i:= 0 to Group.Count-1 do
      with Group.Points[i] do
        if Checked then begin
          IdentifyRange:= Group.Points[i].Error * FixedPoints.IdentifyTolerance;
          // Movement
          Series[0].AddXY(i, Movement, Name);
          // Min, Max
          Series[1].AddXY(i, Movement-IdentifyRange);
          Series[2].AddXY(i, Movement+IdentifyRange);
          // Range
          Series[3].AddXY(i, Movement-IdentifyRange);
          Series[3].AddXY(i, Movement+IdentifyRange);
          Series[3].AddNullXY(i, Movement-IdentifyRange, '');
        end;
    SetChartAxises(DetailChart);
  end;
end;

procedure TFmIdentifyResults.LoadGeneralChart(Group: TFixedPointGroup);
var i: Integer;
    MinRange, MaxRange: Double;
begin
  with GeneralChart do begin
    for i:= 0 to SeriesCount-1 do begin
      Series[i].Clear;
    end;

    for i:= 0 to FixedPoints.Points.Count-1 do
      with FixedPoints.Points.Points[i] do begin
        Series[0].AddXY(i, Movement, Name); // All Repers
        if FixedPoints.IsChecked(Group, Name) then
          Series[1].AddXY(i, Movement)  // Group
      end;
    MinRange:= Series[1].MinYValue;
    MaxRange:= Series[1].MaxYValue;

    SetChartAxises(GeneralChart);

    with BottomAxis do begin
      // MaxRange
      Series[2].AddXY(Minimum, MaxRange);
      Series[2].AddXY(Maximum, MaxRange);
      // MinRange
      Series[3].AddXY(Minimum, MinRange);
      Series[3].AddXY(Maximum, MinRange);
    end;
  end;
end;

procedure TFmIdentifyResults.SetChartAxises(Chart: TChart);

  procedure SetAxis(Axis: TChartAxis; Min, Max: Double);
  begin
    Assert(Min < Max);
    Axis.Automatic:= False;
    Axis.Increment:= 0;
    if Min < Axis.Maximum  then begin // kolejnoœæ jest wa¿na
      Axis.Minimum:= Min; // najpierw Min
      Axis.Maximum:= Max; 
    end
    else begin
      Axis.Maximum:= Max; // najpierw Max
      Axis.Minimum:= Min;
    end;
  end;

var
  Minimum, Maximum: Double;

begin
  with Chart do begin
    Minimum:= Floor(MinYValue(LeftAxis))-0.3; //Zaokr¹glenie w dó³
    Maximum:= Ceil(MaxYValue(LeftAxis))+0.3;  //Zaokr¹glenie w górê
    SetAxis(LeftAxis, Minimum, Maximum);

    Minimum:= Floor(MinXValue(BottomAxis))-0.3; //Zaokr¹glenie w dó³
    Maximum:= Ceil(MaxXValue(BottomAxis))+0.3;  //Zaokr¹glenie w górê
    SetAxis(BottomAxis, Minimum, Maximum);
  end;
end;   

function TFmIdentifyResults.GetCheckedPointCount: Integer;
var i: Integer;
begin
  Result:= 0;
  with LvRepGroup.Items do
    for i:= 0 to Count-1 do
      if Item[i].Checked then
        Inc(Result);
end;    

procedure TFmIdentifyResults.FixedCountChanged;
begin
  // Zawsze aktualizuj, bo liczba mo¿e byæ ta sama, ale inne repery
  FFixedCountOk:= GetCheckedPointCount >= FixedPoints.MinPointCount;
  TsGeneralChart.TabVisible:= FixedCountOk;
  TsDetailChart.TabVisible:= FixedCountOk;
  TsSettings.TabVisible:= FixedCountOk;
  Changed;
end;

procedure TFmIdentifyResults.LvRepGroupChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var FixedReper: PFixedPoint;
begin
  inherited;
  if Assigned(Item) and Assigned(Item.Data) then begin
    FixedReper:= Item.Data;
    if FixedReper.Checked <> Item.Checked then begin
      FixedReper.Checked:= Item.Checked;
      FixedCountChanged;
      if FixedCountOk then
        ReloadActiveGroup
      else
        PageCtlRepGroups.ActivePageIndex:= 0;
    end;
  end;
end;

procedure TFmIdentifyResults.LvRepGroupsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Assigned(Item) and Selected then begin
    if Item.Index = FixedPoints.GroupCount then
      LoadGroup(FixedPoints.Points)
    else
      LoadGroup(FixedPoints.Groups[Item.Index]);
    FixedCountChanged;
  end;
end;

procedure TFmIdentifyResults.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:= False;
  LoadGroups;
  ReloadActiveGroup;
end;

procedure TFmIdentifyResults.EdMinRepCountKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 {vk_return} then begin
    TimerTimer(Sender);
    Key:= 0;
  end;
end;

procedure TFmIdentifyResults.EdMinRepCountChange(Sender: TObject);
begin
  Timer.Enabled:= False; // Zresetuj odliczanie
  Timer.Enabled:= True;
end;

procedure TFmIdentifyResults.EdMinRepCountEnter(Sender: TObject);
begin
  Changed;
  //BtnNext.Default:= False;
end;

procedure TFmIdentifyResults.EdMinRepCountExit(Sender: TObject);
begin
  Changed;
  //BtnNext.Default:= True;
  //TimerTimer(Sender);
end;

procedure TFmIdentifyResults.GeneralChartMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var Indx: Integer;
    sMovement, sError: string;
begin
  inherited;
  Indx:= GeneralChart.SeriesList[0].Clicked(X, Y);
  if (Indx > -1) and (Indx < FixedPoints.Points.Count) then
    with FixedPoints.Points.Points[Indx] do begin
      sMovement:= FormatFloat('0.00', Movement);
      sError:= FormatFloat('0.00', Error{*FixedPoints.IdentifyTolerance});
      Hint:= Format('%s (%s '#177'%s)', [Name, sMovement, sError]);
    end
  else
    Hint:= '';
end;     

procedure TFmIdentifyResults.GetSelectedGroup(Names: TStrings);
var i: Integer;
begin
  Names.BeginUpdate;
  try
    Names.Clear;
    with LvRepGroup.Items do
    for i:= 0 to Count-1 do
      if Item[i].Checked then
        Names.Add(Item[i].Caption);
  finally
    Names.EndUpdate;
  end;
end;

function TFmIdentifyResults.ActiveChart: TChart;
begin
  if PageCtlRepGroups.ActivePage = TsGeneralChart then
    Result:= GeneralChart
  else
    if PageCtlRepGroups.ActivePage = TsDetailChart then
      Result:= DetailChart
    else
      Result:= nil;
end;

procedure TFmIdentifyResults.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  ActSave.Enabled:= ActiveChart <> nil;
  ActPrint.Enabled:= ActSave.Enabled;
  ActPrintSetup.Enabled:= ActSave.Enabled;
  ActZoomIn.Enabled:= ActSave.Enabled;
  ActZoomOut.Enabled:= ActSave.Enabled;
end;

procedure TFmIdentifyResults.ActSaveExecute(Sender: TObject);
var Ext: string;
begin
  if ActiveChart <> nil then begin
    DlgSave.FileName:= ActiveChart.Title.Text[0];
    if DlgSave.Execute then begin
      Ext:= ExtractFileExt(DlgSave.FileName);
      if SameText(Ext, '.wmf') then
        ActiveChart.SaveToMetafile(DlgSave.FileName)
      else if SameText(Ext, '.emf') then
        ActiveChart.SaveToMetafileEnh(DlgSave.FileName)
      else
        ActiveChart.SaveToBitmapFile(DlgSave.FileName);
    end;
  end;
end;

procedure TFmIdentifyResults.ActPrintExecute(Sender: TObject);
begin
  if ActiveChart <> nil then
    ActiveChart.Print;
end;

procedure TFmIdentifyResults.ActPrintSetupExecute(Sender: TObject);
begin
  DlgPrintSetup.Execute;
end;

procedure TFmIdentifyResults.ActZoomInExecute(Sender: TObject);
begin
  //
end;

procedure TFmIdentifyResults.ActZoomOutExecute(Sender: TObject);
begin
  //
end;

procedure TFmIdentifyResults.ActSeparatorExecute(Sender: TObject);
begin
  //
end;

procedure TFmIdentifyResults.FormShow(Sender: TObject);
begin
  UpdateFixedRepersEdits;
  LoadGroups;
end;

end.
