unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, DB, Menus, ImgList, ExtActns, StdActns,
  ActnList, ComCtrls, ToolWin, XpMan,
  FrmBaseForm, FrmBaseDBForm, FrmBaseTabForm,
  GeoSysUtils, GeoGenerators, GeoAbout, GeoConsts;

type
  TFmMain = class(TBaseForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    MnuMain: TMainMenu;
    ActionList: TActionList;
    ActNew: TAction;
    ActOpen: TAction;
    ActSave: TAction;
    ImgList: TImageList;
    ActTabAdd: TAction;
    ActTabDel: TAction;
    ActTabEdit: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ActDhObs: TAction;
    ToolButton14: TToolButton;
    Plik1: TMenuItem;
    Nowy1: TMenuItem;
    Otwrz1: TMenuItem;
    asdf1: TMenuItem;
    asdf2: TMenuItem;
    asdf3: TMenuItem;
    asfd1: TMenuItem;
    ActSaveAs: TAction;
    ActExit: TAction;
    ActClose: TAction;
    MnuRecentFiles: TPopupMenu;
    ActResDeltaH: TAction;
    ActResDeltaDh: TAction;
    ToolButton15: TToolButton;
    StatusBar: TStatusBar;
    ApplicationEvents1: TApplicationEvents;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ActAbout: TAction;
    ActFixedH: TAction;
    ToolButton18: TToolButton;
    sadf1: TMenuItem;
    ActCalc: TAction;
    ToolButton19: TToolButton;
    Obserwacje1: TMenuItem;
    Wyniki1: TMenuItem;
    ObserwacjeDh1: TMenuItem;
    Reperystae1: TMenuItem;
    Bdyrnicprzemiescze1: TMenuItem;
    WynikiDeltaH1: TMenuItem;
    N1: TMenuItem;
    ActCopyDhObs: TAction;
    Kopiujobserwacjezcykluwyjciowego1: TMenuItem;
    Pomoc1: TMenuItem;
    Info1: TMenuItem;
    ActWishList: TAction;
    Listaycze1: TMenuItem;
    ToolButton20: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton21: TToolButton;
    ToolButton8: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ActDelRec: TAction;
    ActAddRec: TAction;
    ActEmptyTable: TAction;
    ActPrintPreview: TAction;
    ActPrintSetup: TFilePrintSetup;
    ActFind: TSearchFind;
    ActFindNext: TSearchFindNext;
    ActReplace: TSearchReplace;
    PreviousTab1: TPreviousTab;
    NextTab1: TNextTab;
    ActPrintDlg: TPrintDlg;
    Ustawieniadrukarki1: TMenuItem;
    N2: TMenuItem;
    Dane1: TMenuItem;
    Zakocz1: TMenuItem;
    Znajd2: TMenuItem;
    Znajdnastpny1: TMenuItem;
    Zastp1: TMenuItem;
    N3: TMenuItem;
    Wtawwiersz1: TMenuItem;
    Usuwiersz1: TMenuItem;
    Usunwszystkiedaneztablicy1: TMenuItem;
    ActResH: TAction;
    ToolButton30: TToolButton;
    N4: TMenuItem;
    Drukuj1: TMenuItem;
    ActPrintPreview2: TMenuItem;
    ActPrint: TAction;
    ToolButton31: TToolButton;
    ActGenDh: TAction;
    ToolButton32: TToolButton;
    ActMyGenerate: TAction;
    Rzdnereperw1: TMenuItem;
    Dodajcykl1: TMenuItem;
    Usucykl1: TMenuItem;
    Edytujcykl1: TMenuItem;
    N5: TMenuItem;
    Obliczenia1: TMenuItem;
    ActCalc1: TMenuItem;
    Generatorobserwacji1: TMenuItem;
    N6: TMenuItem;
    mnuPrecyzja: TMenuItem;
    mnuPrecyzja1: TMenuItem;
    N0001: TMenuItem;
    N00001: TMenuItem;
    N000001: TMenuItem;
    N0000001: TMenuItem;
    N00000001: TMenuItem;
    ActExpExcel: TAction;
    EksportdoMicrosoftExcel1: TMenuItem;
    procedure ActNewExecute(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActTabAddExecute(Sender: TObject);
    procedure ActTabDelExecute(Sender: TObject);
    procedure ActTabEditExecute(Sender: TObject);
    procedure ActDhObsExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActResDeltaHExecute(Sender: TObject);
    procedure ActResDeltaDhExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActFixedHExecute(Sender: TObject);
    procedure ActCalcExecute(Sender: TObject);
    procedure ActCopyDhObsExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActWishListExecute(Sender: TObject);
    procedure ActDelRecExecute(Sender: TObject);
    procedure ActAddRecExecute(Sender: TObject);
    procedure ActEmptyTableExecute(Sender: TObject);
    procedure ActResHExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActPrintDlgAccept(Sender: TObject);
    procedure ActPrintExecute(Sender: TObject);
    procedure ActPrintPreviewExecute(Sender: TObject);
    procedure ActGenDhExecute(Sender: TObject);
    procedure ActMyGenerateExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure mnuPrecyzja1Click(Sender: TObject);
    procedure ActExpExcelExecute(Sender: TObject);
  private
    { Private declarations }
    procedure MenuRecentFileClick(Sender: TObject);
    function ActiveDBForm: TBaseDBForm;
    function ActiveTabForm: TBaseTabForm;
    function ActiveForm: TBaseForm;
  public
    { Public declarations }
    procedure Progress(P: double);
    procedure UpdateFormCaption;
    procedure CloseMDIChildren;
    procedure SetDisplayFormatMenu(DisplayFormat: string);
  end;

var
  FmMain: TFmMain;

implementation

uses
  DatMod, BaseUnit, GeoDlgs,
  FrmObsDh, PmkResStr, FrmDeltaH, FrmDeltaDh, FrmFixedH,
  FrmSelectMovement, FrmResH, PmkStorage, FrmPrintPreview,
  FrmGenDh, GeoFiles,
  Consts, PmkExpExc;

{$R *.dfm}

procedure UpdateStatusBar(StatusBar: TStatusBar);
var i, PanelWidth: Integer;
begin
  with StatusBar do
    if (not SimplePanel) and (Panels.Count>1) then begin
      PanelWidth:= ClientWidth;
      for i:= 1 to Panels.Count-1 do // Szerokosc wszystkich paneli bez pierwszego
        Dec(PanelWidth, Panels[i].Width);
      if SizeGrip then // uwzglêdnij tez szerokosc SizeGrip'a
        Dec(PanelWidth, ClientHeight);
      if PanelWidth > 50 then
        Panels[0].Width:= PanelWidth;
    end;
end;

procedure TFmMain.MenuRecentFileClick(Sender: TObject);
var MenuItem: TMenuItem;
begin
  if Sender is TMenuItem then begin
    MenuItem:= Sender as TMenuItem;
    Dm.LoadFromFile(StripHotkey(MenuItem.Caption));
  end;
end;

procedure TFmMain.UpdateFormCaption;
var i: Integer;

  function CreateMenuItem(FileName: string): TMenuItem;
  begin
    Result := TMenuItem.Create(MnuRecentFiles);
    with Result do begin
      Caption := FileName;
      OnClick := MenuRecentFileClick;
    end;
  end;

begin
  if fsClosed in Dm.PmkFile.FileState then
    Caption:= 'Pmk'
  else
    Caption:= 'Pmk - '+Dm.PmkFile.ShortFileName;
  MnuRecentFiles.Items.Clear;
  for i:= 0 to Dm.RecentFiles.Count-1 do
    MnuRecentFiles.Items.Add(CreateMenuItem(Dm.RecentFiles[i]))
end;   

function TFmMain.ActiveForm: TBaseForm;
begin
  if ActiveMDIChild is TBaseForm then
    Result:= ActiveMDIChild as TBaseForm
  else
    Result:= nil;
end;

function TFmMain.ActiveDBForm: TBaseDBForm;
begin
  if ActiveMDIChild is TBaseDBForm then
    Result:= ActiveMDIChild as TBaseDBForm
  else
    Result:= nil;
end;

function TFmMain.ActiveTabForm: TBaseTabForm;
begin
  if ActiveMDIChild is TBaseTabForm then
    Result:= ActiveMDIChild as TBaseTabForm
  else
    Result:= nil;
end;

procedure TFmMain.Progress(P: double);
begin
end;

procedure TFmMain.CloseMDIChildren;
var i: integer;
begin
  for i:= 0 to MDIChildCount-1 do
    MDIChildren[i].Close;
end;

procedure TFmMain.ActNewExecute(Sender: TObject);
begin
  CheckDBFormsInBrowseMode;
  Dm.CreateNewFile;
end;

procedure TFmMain.ActOpenExecute(Sender: TObject);
begin      
  CheckDBFormsInBrowseMode;
  Dm.LoadFromFileDlg;
end;

procedure TFmMain.ActSaveExecute(Sender: TObject);
begin     
  CheckDBFormsInBrowseMode;
  Dm.SaveToFile;
end;

procedure TFmMain.ActTabAddExecute(Sender: TObject);
begin
  if ActiveMDIChild is TBaseTabForm then
    TBaseTabForm(ActiveMDIChild).AddTab;
end;

procedure TFmMain.ActTabDelExecute(Sender: TObject);
begin
  if ActiveMDIChild is TBaseTabForm then
    TBaseTabForm(ActiveMDIChild).DeleteTab;
end;

procedure TFmMain.ActTabEditExecute(Sender: TObject);
begin
  if ActiveMDIChild is TBaseTabForm then
    TBaseTabForm(ActiveMDIChild).EditTab;
end;

procedure TFmMain.ActDhObsExecute(Sender: TObject);
begin
  ShowObsDh;
end;

procedure TFmMain.ActResDeltaHExecute(Sender: TObject);
begin
  ShowFmDeltaH;
end;

procedure TFmMain.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  ActTabAdd.Enabled:=  (ActiveTabForm <> nil) and ActiveTabForm.AddTabEnabled;
  ActTabDel.Enabled:=  (ActiveTabForm <> nil) and ActiveTabForm.DeleteTabEnabled;
  ActTabEdit.Enabled:=  (ActiveTabForm <> nil) and ActiveTabForm.EditTabEnabled;

  ActDelRec.Enabled:= (ActiveDBForm <> nil) and ActiveDBForm.DeleteRecordEnabled;
  ActAddRec.Enabled:= (ActiveDBForm <> nil) and ActiveDBForm.AddRecordEnabled;
  ActEmptyTable.Enabled:= (ActiveDBForm <> nil) and ActiveDBForm.EmptyTableEnabled;

  ActPrint.Enabled:= (ActiveForm <> nil) and ActiveForm.PrintEnabled;
  ActPrintPreview.Enabled:= (ActiveForm <> nil) and ActiveForm.PrintPreviewEnabled;
  ActExpExcel.Enabled:= ActPrint.Enabled;

  ActClose.Enabled:= not (fsClosed in Dm.PmkFile.FileState);
  ActSave.Enabled:=  ActClose.Enabled and Dm.Modified;
  ActSaveAs.Enabled:= ActClose.Enabled;

  ActCalc.Enabled:= not (fsClosed in Dm.PmkFile.FileState);
  ActDhObs.Enabled:= ActCalc.Enabled;
  ActFixedH.Enabled:= ActCalc.Enabled;

  ActResDeltaDh.Enabled:= ActCalc.Enabled and not Dm.DeltaDh.IsEmpty;
  ActResDeltaH.Enabled:= ActCalc.Enabled and not Dm.DeltaH.IsEmpty;   
  ActResH.Enabled:= ActCalc.Enabled and not Dm.ResH.IsEmpty;
  ActCopyDhObs.Enabled:= Assigned(FmObsDh) and not AnsiSameText(FmObsDh.ActiveTabName, Dm.BaseCycleName);

end;

procedure TFmMain.ActSaveAsExecute(Sender: TObject);
begin      
  CheckDBFormsInBrowseMode;
  Dm.SaveToFileDlg;
end;

procedure TFmMain.ActExitExecute(Sender: TObject);
begin 
  CheckDBFormsInBrowseMode;
  Close;
end;

procedure TFmMain.ActCloseExecute(Sender: TObject);
begin  
  CheckDBFormsInBrowseMode;
  CloseMDIChildren;
  Dm.CloseFile;
end;

procedure TFmMain.ActResDeltaDhExecute(Sender: TObject);
begin
  ShowDeltaDh;
end;

procedure TFmMain.ActFixedHExecute(Sender: TObject);
begin
  ShowFixedH;
end;

procedure TFmMain.ActCalcExecute(Sender: TObject);
begin
  CheckDBFormsInBrowseMode;    
  //if Dm.DhObs0.RecordCount < 3 then
  //  RaiseError(emNotEnoughObs);
  ShowCalcMovementsCreator;
end;

procedure TFmMain.FormResize(Sender: TObject);
begin
  inherited;
  UpdateStatusBar(StatusBar);
end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
  UpdateStatusBar(StatusBar);
  GeoIniFile.ReadFormPostion(Self);
end;

procedure TFmMain.FormDestroy(Sender: TObject);
begin
  GeoIniFile.WriteFormPostion(Self);
end;

procedure TFmMain.ActAboutExecute(Sender: TObject);
begin
  ShowAbout(sAppDsc, false);
end;

procedure TFmMain.ActCopyDhObsExecute(Sender: TObject);
begin
  CheckDBFormsInBrowseMode;
  if Assigned(FmObsDh) then begin
    Dm.CopyDhObsFromBaseCycle(FmObsDh.ActiveTabName);
  end;
end;

procedure TFmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Dm.CloseFile;
  // ToDo: Reagowaæ na SaveToFile.Result = Cancel
  ///Dm.SaveToFile;
  //CanClose:= Dm.CloseFile;
end;  

procedure TFmMain.ActWishListExecute(Sender: TObject);
begin
  ShowSendEmailEx(GeoSoftName, GeoSoftEmail, 'Pmk: Lista ¿yczeñ', 'Mama tak¹ propozycjê...'+CrLf);
end;

procedure TFmMain.ActDelRecExecute(Sender: TObject);
begin
  if ActiveDBForm <> nil then
    ActiveDBForm.DeleteRecord;
end;

procedure TFmMain.ActAddRecExecute(Sender: TObject);
begin
  if ActiveDBForm <> nil then
    ActiveDBForm.AddRecord;
end;

procedure TFmMain.ActEmptyTableExecute(Sender: TObject);
begin
  if ActiveDBForm <> nil then
    ActiveDBForm.EmptyTable;
end;

procedure TFmMain.ActResHExecute(Sender: TObject);
begin
  ShowResH;
end;

procedure TFmMain.ActPrintDlgAccept(Sender: TObject);
begin
  ActiveForm.Print;
end;

procedure TFmMain.ActPrintExecute(Sender: TObject);
begin
  ActiveForm.Print;
  //ActiveForm.Print;
end;

procedure TFmMain.ActPrintPreviewExecute(Sender: TObject);
begin
  ActiveForm.PrintPreview;
end; 

procedure TFmMain.ActExpExcelExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ActiveForm.ExportToExcel;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmMain.ActGenDhExecute(Sender: TObject);
begin
  with TFmGenDh.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFmMain.ActMyGenerateExecute(Sender: TObject);
var DhObsGen: THMovementsObsGenerator;
    Strings: TStrings;
begin      
  if Dm.DhCycles.RecordCount < 2 then
    Dm.AddDhCycle;
  Strings:= TStringList.Create;
  DhObsGen:= THMovementsObsGenerator.Create;
  Dm.GetDhCycleNames(Strings);
  with DhObsGen do
  try
    FuzzyMovements:= False;
    ActiveCycleName:= Strings[0];
    BaseCycleName:= Strings[1];
    FixedPointsGroupsCount:= 3;

    SetPointNames(TestPointNames, '', 20);
    SetPointNames(FixedPointNames, 'Rp', 20);

    GenerateDhObservations((FixedPointNames.Count + TestPointNames.Count)*2);

    CopyObsToDB(DhObsGen, nil);
    CopyFixedPointsToDB(DhObsGen, nil);
  finally
    Free;
    Strings.Free;
  end;
end; 

procedure SaveFormImageDlg(FileName: string);
begin
end;

procedure TFmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_PRINT, // Nie dzia³a
    VK_SCROLL:
      with TSaveDialog.Create(nil) do
      try
        Filter:= 'Bitmaps|*.bmp';
        FileName:= Name+'.bmp';
        if Execute then begin
          Screen.Cursor:= crNone;
          SaveFormImage(Self, FileName);
          Screen.Cursor:= crDefault;
        end;
      finally
        Free;
      end;
  end;
end;



procedure TFmMain.mnuPrecyzja1Click(Sender: TObject);
var i: Integer;
    mnuSender: TMenuItem;
begin
  inherited;
  for i:= 0 to mnuPrecyzja.Count-1 do begin// musi sprawdziæ wszyskie
    mnuPrecyzja.Items[i].Checked:=  mnuPrecyzja.Items[i] = Sender;
    if mnuPrecyzja.Items[i].Checked then
      Dm.DisplayFormat:= mnuPrecyzja.Items[i].Caption;
  end;
end;

procedure TFmMain.SetDisplayFormatMenu(DisplayFormat: string);
var i: Integer;
begin
  inherited;
  for i:= 0 to mnuPrecyzja.Count-1 do // musi sprawdziæ wszyskie
    with mnuPrecyzja.Items[i] do
      Checked:= Caption = DisplayFormat;
end;

end.
