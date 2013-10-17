unit DatMod;

{

  Ten modu³ jest odpowiedzialny za tworzenie struktury danych
  wykorzystywanych w programie oraz ich zapis do pliku. Dane
  przechowujê przy u¿yciu TClientDataSet'ów.
  DataSet'y w tym module s¹ "czyste": brak po³¹czeñ z kontolkami
  bazodanowymi, brak pól kalkulowanych.

}


interface

uses
  SysUtils, Classes, Variants, Dialogs, Controls, Forms, DB, DBClient,
  GeoFiles, PmkFiles, Matrices, midas, TypInfo, GeoSysUtils;

type
  TDm = class(TDataModule)
    DhCycles: TClientDataSet;
    DhObs0: TClientDataSet;
    DlgOpen: TOpenDialog;
    DlgSave: TSaveDialog;
    InternalDhCycles: TClientDataSet;
    DhCyclesMaxCycleNo: TAggregateField;
    DhCyclesCycleNo: TIntegerField;
    DhCyclesName: TStringField;
    DhCyclesDescription: TMemoField;
    DhCyclesBaseCycle: TBooleanField;
    DhCyclesCalc: TBooleanField;
    DhCyclesDate: TDateTimeField;
    DeltaH: TClientDataSet;
    DeltaDh: TClientDataSet;
    dsDhCycles: TDataSource;
    DhCyclesEstimatedVariance: TFloatField;
    DhCyclesStandartError: TFloatField;
    DhCyclesFreeEstimation: TBooleanField;
    DhCyclesFixedPoints: TMemoField;
    DhCyclesStandartErrorErr: TFloatField;
    DhObs: TClientDataSet;
    FixedH: TClientDataSet;
    DhCyclesEstimationType: TIntegerField;
    ResH: TClientDataSet;
    ResH0: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure DhCyclesBeforePost(DataSet: TDataSet);
    procedure DhCyclesAfterPost(DataSet: TDataSet);
    procedure DhCyclesAfterDelete(DataSet: TDataSet);
    procedure ResH0BeforePost(DataSet: TDataSet);
  private
    FPmkFile: TPmkXMLFile;
    FRecentFiles: TStringList;
    FDisplayFormat: string;
    function GetModified: Boolean;
    procedure SetNotModified;
    procedure EmptyDataSets;
    function DefaultCycleName(CyklNo: Integer): string;
    procedure SetUpdateControls(Owner: TComponent; EnableControls: boolean);
    procedure InitializeRecentFiles;
    procedure InitializePmkFile;
    procedure SetDisplayFormat(const Value: string);
    procedure UpdateDisplayFormat(Owner: TComponent; DisplayFormat: string);
    function BaseCycleNo: Integer;
    
  public
    // FileUtils
    function SaveToFileDlg: Boolean;
    function SaveToFile: Boolean;
    function LoadFromFileDlg: Boolean;
    procedure LoadFromFile(FileName: string);
    procedure CreateNewFile;
    function CloseFile: Boolean;
    property Modified: Boolean read GetModified;
    procedure UpdateInternalDatasets;
    procedure AddRecentFile(FileName: string);

    procedure GetDhCycleNames(Names: TStrings);
    procedure GetDhCycleNamesEx(Names: TStrings); //Nazwy cykli bez cyklu bazowego
    function AddDhCycle: string; // result:= CycleName
    procedure DeleteCykl(CycleName: string);
    procedure DeleteDhObs(CycleName: string);
    function DhCyclesLocate(CycleName: string): Boolean;
    procedure SetActiveDhCycleInfo(Accuracy: TLeastSquaresAccuracy;
      FreeEstimation: Boolean; FixedPoints: string);
    procedure CopyDhObsFromBaseCycle(DestCycle: string);
    function BaseCycleName: string;
    procedure SetBaseCycleName(BaseCycle: string);
    procedure SetDefaultDisplayFormat(Owner: TComponent);

    procedure EnableControls;
    procedure DisableControls;

    property PmkFile: TPmkXMLFile read FPmkFile;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat;

  published
    property RecentFiles: TStringList read FRecentFiles;
  end;

var
  Dm: TDm;

const
  // FieldNames
  fnCycleNo = 'CycleNo';
  fnMaxCycleNo = 'MaxCycleNo';
  fnName = 'Name';
  fnDescription = 'Description';
  fnBaseCycle = 'BaseCycle';
  fnDate = 'Date';
  fnObs = 'Obs';
  fnCalc = 'Calc';

  fnBeginPoint = 'BeginPoint';
  fnEndPoint = 'EndPoint';
  fnN = 'N';
  fnDh = 'Dh';
  fnMDh = 'DhErr';
  fnV = 'V';
  fnMV = 'VErr'; 
  fnH = 'H';

  MaxRecentFilesCount = 9;

implementation

{$R *.dfm}

uses
  PmkResStr, FrmMain, FrmObsDh,
  FrmBaseTabForm, GeoDlgs, PmkStorage, FrmBaseDBForm;

const
  {PmkFileHeader: TGeoFileHeader =
  (AppName: 'Pmk';
    Description: 'Program Pmk umo¿liwia obliczanie przemieszczeñ pionowych';
    MajorVersion: 1;
    MinorVersion: 0;
    FileVersion: 1);    }

  DefStringSize = 50;
  DefCycleName = 'Cykl %d';
  NewFileName = 'Bez nazwy%s.pmk';
  FileMode = fmCreate or fmOpenReadWrite or fmShareExclusive;

//==============================================================================
//              TDm
//------------------------------------------------------------------------------
procedure TDm.CreateNewFile;
begin
  CloseFile;
  DisplayFormat:= '0.0000';
  EmptyDataSets; // mo¿e siê zda¿yæ, ¿e PmkFile.Closed = True; i CloseFile nie zadzia³a
  AddDhCycle;
  PmkFile.NewFile;
  PmkFile.DisplayFormat:= DisplayFormat;
  UpdateInternalDatasets;
  SetNotModified;
end;
//------------------------------------------------------------------------------
function TDm.CloseFile: Boolean;
begin
  Result:= True;
  if (fsClosed in Dm.PmkFile.FileState) then
    Exit;
  CheckDBFormsInBrowseMode;
  if Modified then
    case ShowDlg(dmSaveChanges) of
      mrYes: Result:= SaveToFile;
      mrNo: Result:= False;// Nic nie rób
      mrCancel: begin
        Result:= False;
        Abort;
      end;
    end;
  PmkFile.CloseFile;
  EmptyDataSets;
  FmMain.CloseMDIChildren;
  UpdateInternalDatasets;
end;
//------------------------------------------------------------------------------
procedure TDm.LoadFromFile(FileName: string);
//var i: Integer;
begin
  CheckFileExists(FileName);
  CloseFile;
  //try
    PmkFile.OpenFile(FileName);
  {except
    on E: Exception do begin
      RaiseError(emInvalidFile, [FileName, E.Message]);
    end;
  end; }
 // for i:= 0 to 250 do
 //   DhObs.AppendRecord([1, 'p'+IntToStr(i), 'p_'+IntToStr(i), 1,2,3,4]);
  SetNotModified;
  AddRecentFile(PmkFile.FileName);
  UpdateInternalDatasets;
  DisplayFormat:= PmkFile.DisplayFormat;
end;
//------------------------------------------------------------------------------
function TDm.LoadFromFileDlg: Boolean;
begin
  Result:= DlgOpen.Execute;
  if Result then
    LoadFromFile(DlgOpen.FileName);
end;
//------------------------------------------------------------------------------
procedure TDm.AddRecentFile(FileName: string);
var i: Integer;
begin
  with FRecentFiles do begin
    i:= IndexOf(FileName);
    if i>=0 then
      Move(i, 0)
    else
      Insert(0,FileName);
    while Count > MaxRecentFilesCount do
      Delete(Count-1);
  end;
end;
//------------------------------------------------------------------------------
function TDm.SaveToFileDlg: Boolean;
begin
  DlgSave.FileName:= PmkFile.ShortFileName;
  Result:= DlgSave.Execute;
  if Result then begin     
    PmkFile.DisplayFormat:= DisplayFormat;
    PmkFile.SaveFileAs(DlgSave.FileName);
    FmMain.UpdateFormCaption;
    AddRecentFile(PmkFile.FileName); 
    FmMain.UpdateFormCaption;
    SetNotModified;
  end;
end;
//------------------------------------------------------------------------------
function TDm.SaveToFile: Boolean;
begin
  Result:= False;
  if (fsNew in Dm.PmkFile.FileState) then
    Result:= SaveToFileDlg
  else begin
    if Modified then begin  
      PmkFile.DisplayFormat:= DisplayFormat;
      PmkFile.SaveFile;
      Result:= True;
      AddRecentFile(PmkFile.FileName);
      FmMain.UpdateFormCaption;
      SetNotModified;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TDm.UpdateInternalDatasets;
begin
  // cdsInternalDhCycles nie jest pod³¹czony do ¿adnych kontrolek
  // i jest wykorzystywany do szybkiego wyszukiwania
  InternalDhCycles.CloneCursor(DhCycles, False);

  DhObs0.CloneCursor(DhObs, True); //KeepSetnins = True -> Filter, Filtered, MasterSource

  // ToDo: zapytaæ na grupie:
  // Z niewiadomych mi przyczyn klonowanie kursora (niezale¿nie
  // od parametru Reset) nie resetuje ca³kowicie
  // DataSeta gdy Ÿród³o klonowania ma ustawiony zakres za pomoc¹
  // MasterSource i MasterFields. W takim przypadku zklonowany DataSet
  // wyœwietla tylko te rekordy, które by³y widoczne w Ÿródle
  // klonowania . Moja partyzancka metoda,
  // ¿eby to omin¹æ polega na przypisaniu jakiego kolwiek MasterSource
  // a potem jego usuniêciu:
  DhObs0.MasterSource:= dsDhCycles;
  DhObs0.MasterSource:= nil;

  // Inna sprawa polega na tym, ¿e przy klonowaniu z parametrami Restet = False,
  // KeepSettings = True filtrowanie nie dzia³a :-(
  DhObs0.Filter:= 'CycleNo = '+IntToStr(BaseCycleNo);
  DhObs0.Filtered:= True;

  ResH0.CloneCursor(ResH, True);
  ResH0.MasterSource:= dsDhCycles;
  ResH0.MasterSource:= nil;
  ResH0.Filter:= 'CycleNo = '+IntToStr(BaseCycleNo);
  ResH0.Filtered:= True;

  UpdateTabForms;
  FmMain.UpdateFormCaption;
end;
//------------------------------------------------------------------------------
procedure TDm.EmptyDataSets;
begin
  DhCycles.EmptyDataSet;
  DhObs.EmptyDataSet;
  DeltaH.EmptyDataSet;
  DeltaDh.EmptyDataSet;
  FixedH.EmptyDataSet;
end;
//==============================================================================
//------------------------------------------------------------------------------
function TDm.GetModified: Boolean;

  function CDSModified(DataSet: TClientDataSet): Boolean;
  begin
    Result:= (DataSet.ChangeCount > 0); // or (DataSet.UpdateStatus <> usUnmodified);
  end;

var i: Integer;
begin
  Result:= False;  
  if (fsClosed in Dm.PmkFile.FileState) then
    Exit;
  //CheckDBFormsInBrowseMode;
  for i:= 0 to ComponentCount-1 do
    if Components[i] is TClientDataSet then
      Result:= Result or CDSModified(TClientDataSet(Components[i]));
end;
//------------------------------------------------------------------------------
procedure TDm.SetNotModified;

  procedure MergeChangeLog(DataSet: TClientDataSet);
  begin
    DataSet.CheckBrowseMode;
    DataSet.MergeChangeLog;
  end;

var i: Integer;
begin
  for i:= 0 to ComponentCount-1 do
    if Components[i] is TClientDataSet then
      MergeChangeLog(TClientDataSet(Components[i]));
end;
//------------------------------------------------------------------------------
procedure TDm.SetActiveDhCycleInfo(Accuracy: TLeastSquaresAccuracy;
  FreeEstimation: Boolean; FixedPoints: string);
begin
  DhCycles.Edit;
  DhCyclesEstimatedVariance.AsFloat:= Accuracy.EstimatedVariance;
  DhCyclesStandartError.AsFloat:= Accuracy.StandartError;
  DhCyclesStandartErrorErr.AsFloat:= Accuracy.StandartErrorErr;
  DhCyclesFreeEstimation.AsBoolean:= FreeEstimation;
  DhCyclesFixedPoints.AsString:= FixedPoints;
  DhCycles.Post;
end;
//------------------------------------------------------------------------------
procedure TDm.GetDhCycleNames(Names: TStrings);
begin
  with InternalDhCycles do begin
    Names.Clear;
    First;
    while not Eof do begin
      Names.AddObject(FieldByName(fnName).AsString, GetBookmark);
      Next;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TDm.GetDhCycleNamesEx(Names: TStrings);
begin
  with InternalDhCycles do begin
    Names.Clear;
    First;
    while not Eof do begin
      if not FieldByName(fnBaseCycle).AsBoolean then
        Names.AddObject(FieldByName(fnName).AsString, GetBookmark);
      Next;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TDm.AddDhCycle: string;
var
  NewCycleNo: Integer;
  MaxCycleNo: Variant;
  dcn: string;
begin
  MaxCycleNo:= DhCyclesMaxCycleNo.Value;
  if VarIsNull(MaxCycleNo) then
    NewCycleNo:= 1
  else
    NewCycleNo:= MaxCycleNo + 1;
  DhCycles.Append;
  DhCycles[fnCycleNo]:= NewCycleNo;
  dcn:= DefaultCycleName(NewCycleNo);
  DhCyclesName.AsString:= dcn;
  DhCyclesDate.AsDateTime:= Now;
  DhCyclesCalc.AsBoolean:= True;
  DhCyclesBaseCycle.AsBoolean:= NewCycleNo = 1;
  DhCycles.Post;
  Result:= DhCyclesName.AsString;
end;          
//------------------------------------------------------------------------------
procedure TDm.DeleteDhObs(CycleName: string);
begin
  if DhCyclesLocate(CycleName) then begin
    DhObs.DisableControls;
    try
      DhObs.First;
      while not DhObs.Eof do
        DhObs.Delete;
    finally
      DhObs.EnableControls;
    end;
  end
  else
    RaiseError(emNoCycleName, [CycleName]);
end;
//------------------------------------------------------------------------------
procedure TDm.DeleteCykl(CycleName: string);
begin
  if DhCyclesLocate(CycleName) then begin
    if DhCycles[fnBaseCycle] then
      RaiseError(emDeleteCykl1);
    if ShowDlg(dmDeleteCycle, [DhCycles[fnName]]) = mrYes then begin
      DeleteDhObs(CycleName);
      //DeleteNestedDataSets(DhCycles);
      DhCycles.Delete;
    end;
  end
  else
    RaiseError(emNoCycleName, [CycleName]);
end;
//------------------------------------------------------------------------------
function TDm.DefaultCycleName(CyklNo: Integer): string;
begin
  if CyklNo < 1 then
    CyklNo:= 1;
  if DhCycles.RecordCount < 1 then
    Result:= Format(DefCycleName, [CyklNo]) + ' (pomiar wyjœciowy)'
  else begin
    while InternalDhCycles.Locate(fnName, Format(DefCycleName, [CyklNo]), [loCaseInsensitive]) do
      Inc(CyklNo);
    Result:= Format(DefCycleName, [CyklNo]);
  end;
end;
//------------------------------------------------------------------------------
function TDm.BaseCycleNo: Integer;
begin
  if InternalDhCycles.Locate(fnBaseCycle, True, []) then
    Result:= InternalDhCycles[fnCycleNo]
  else
    Result:= -MaxInt;
end;
//------------------------------------------------------------------------------
function TDm.BaseCycleName: string;
begin
  if InternalDhCycles.Locate(fnBaseCycle, True, []) then
    Result:= InternalDhCycles[fnName]
  else
    Result:= '';
end;
//------------------------------------------------------------------------------
procedure TDm.SetBaseCycleName(BaseCycle: string);
begin
  if Self.BaseCycleName = BaseCycle then
    Exit;
  with InternalDhCycles do
  if Locate(fnName, BaseCycle, []) then begin
    if Locate(fnBaseCycle, True, []) then begin
      Edit;
      FieldValues[fnBaseCycle]:= False;
      Post;
    end;
    if InternalDhCycles.Locate(fnName, BaseCycle, []) then begin
      Edit;
      FieldValues[fnBaseCycle]:= True;
      Post;
    end;
  end;
  UpdateInternalDatasets();
end;
//------------------------------------------------------------------------------
procedure TDm.CopyDhObsFromBaseCycle(DestCycle: string);
var KeyFields: string;
    Values: Variant;
begin
  if DhCyclesLocate(DestCycle) then begin
    if DhCyclesBaseCycle.AsBoolean then
      RaiseError(emCantCopyDhObs);
    KeyFields:= 'BeginPoint;EndPoint';
    DhObs0.First;
    while not DhObs0.Eof do begin
      Values:= VarArrayOf([DhObs0['BeginPoint'], DhObs0['EndPoint']]);
      if not DhObs.Locate(KeyFields, Values, [loCaseInsensitive]) then begin
        DhObs.Append;
        DhObs['BeginPoint']:= DhObs0['BeginPoint'];
        DhObs['EndPoint']:= DhObs0['EndPoint'];
        DhObs['Dh']:= DhObs0['Dh'];
        DhObs['N']:= DhObs0['N'];
        DhObs.Post;
      end;
      DhObs0.Next;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TDm.InitializeRecentFiles;
var i: Integer;
begin
  FRecentFiles:= TStringList.Create;
  GeoIniFile.ReadStrings(Name, 'RecentFiles', FRecentFiles);
  for i:= FRecentFiles.Count-1 downto 0 do
    if not FileExists(FRecentFiles[i]) then
      FRecentFiles.Delete(i);
end;
//------------------------------------------------------------------------------
procedure TDm.InitializePmkFile;
begin
  //FPmkFile:= TPmkFile.Create(PmkFileHeader);  
  FPmkFile:= TPmkXMLFile.Create;
  FPmkFile.Cycles:= DhCycles;
  FPmkFile.DhObservations:= DhObs;
  FPmkFile.DeltaDh:= DeltaDh;
  FPmkFile.DeltaH:= DeltaH;
  FPmkFile.FixedH:= FixedH;
  FPmkFile.ResH:= ResH;
end;
//------------------------------------------------------------------------------
procedure TDm.DataModuleCreate(Sender: TObject);
var
  FName: string;
begin
  InitializeRecentFiles;
  InitializePmkFile;
  FName:= ParamStr(1);
  UpdateInternalDatasets; // Pierwsza inicjalizacja danych
  if FName = '' then
    CreateNewFile
  else
    try
      LoadFromFile(FName);
    except
      //ShowMessage('Nie mo¿na wczytaæ pliku: ' + FName);
      CreateNewFile;  // Usuñ wczytane dane
      raise;
    end;
end;
//------------------------------------------------------------------------------
procedure TDm.DataModuleDestroy(Sender: TObject);
begin
  GeoIniFile.WriteStrings(Name, 'RecentFiles', FRecentFiles);
  FreeAndNil(FPmkFile);
end;
//------------------------------------------------------------------------------
// Zmiany w sklonowanym DataSet'cie s¹ widoczne we wszystkich sklonowanych
// DataSet'ach (korzystaj¹ z tego samego obrazu danych). Dlatego trzeba przerekurowaæ
// po wszystkich DataSet'ach w aplikacji i niezale¿nie ka¿demu ustawiaæ
// Disable/EnableControls;
procedure TDm.SetUpdateControls(Owner: TComponent; EnableControls: boolean);
var
  i: Integer;
begin
  // Blokowanie edycji kontrolek bazodanowych dotyczy tylko DataSet'ów
  // klonowanych na formach. DataSet'y w DataModule musz¹ byæ zawsze aktywne.
  if Owner <> Self then
  with Owner do
    for i:= 0 to ComponentCount - 1 do begin
      SetUpdateControls(Components[i], EnableControls);
      if Components[i] is TDataSet then begin
        if EnableControls then
          TDataSet(Components[i]).EnableControls
        else
          TDataSet(Components[i]).DisableControls;
      end;
    end;
end;
//------------------------------------------------------------------------------
procedure TDm.DisableControls;
begin
  SetUpdateControls(Application, False);
end;
//------------------------------------------------------------------------------
procedure TDm.EnableControls;
begin
  SetUpdateControls(Application, True);
end;

function TDm.DhCyclesLocate(CycleName: string): Boolean;
begin
  Result:= DhCycles.Locate(fnName, CycleName, [loCaseInsensitive]);
end;

procedure TDm.DhCyclesBeforePost(DataSet: TDataSet);
var
  NewCycleName: string;
begin
  NewCycleName:= DataSet[fnName];
  if InternalDhCycles.Active then
    if InternalDhCycles.Locate(fnName, NewCycleName, [loCaseInsensitive]) then
      if InternalDhCycles[fnCycleNo] <> DataSet[fnCycleNo] then
        RaiseError(emCycleExists, [NewCycleName]);
end;

procedure TDm.DhCyclesAfterPost(DataSet: TDataSet);
begin
  UpdateTabForms;
end;

procedure TDm.DhCyclesAfterDelete(DataSet: TDataSet);
begin
  UpdateTabForms;
end;

procedure TDm.ResH0BeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName(fnCycleNo).AsInteger:= 1;
end;

procedure TDm.UpdateDisplayFormat(Owner: TComponent; DisplayFormat: string);
var CmpIndx, FldIndx: integer;
begin
  for CmpIndx:= 0 to Owner.ComponentCount-1 do
    if Owner.Components[CmpIndx] is TDataSet then
      with TDataSet(Owner.Components[CmpIndx]) do begin
        for fldIndx:= 0 to Fields.Count-1 do
          if Fields[FldIndx] is TFloatField then
            TFloatField(Fields[FldIndx]).DisplayFormat:= DisplayFormat;
      end;
end;

procedure TDm.SetDisplayFormat(const Value: string);
var i: Integer;
begin
  FDisplayFormat := Value;
  UpdateDisplayFormat(Self, FDisplayFormat);
  with Application.MainForm do
    for i:= 0 to MDIChildCount-1 do
      UpdateDisplayFormat(MDIChildren[i], FDisplayFormat);
  FmMain.SetDisplayFormatMenu(FDisplayFormat);
end;

procedure TDm.SetDefaultDisplayFormat(Owner: TComponent);
begin
  UpdateDisplayFormat(Owner, DisplayFormat);
end;

end.

