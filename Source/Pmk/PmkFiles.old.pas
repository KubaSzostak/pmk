unit PmkFiles.old;

interface

uses
  SysUtils, Classes, GeoFiles, DB, DbClient, Variants;

type
  TCycleData = record
    CycleNo: Integer;
    Name: ShortString;
    Description: ShortString;
  end;


  TPmkFile = class(TGeoBinaryFile)
  private
    FWritedDataSets: Integer;
    FDhObservations: TClientDataSet;
    FCycles: TClientDataSet;
    FWritePosition: Integer;
    FWriteTotal: Integer;
    FFixedH: TClientDataSet;
    FDeltaH: TClientDataSet;
    FDeltaDh: TClientDataSet;
    FResH: TClientDataSet;
    procedure ReadFromDataSet(DataSet: TClientDataSet; Fields: array of string);
    procedure WriteDataSet(DataSet: TClientDataSet; Fields: array of string);
    procedure SetCycles(const Value: TClientDataSet);
    procedure SetDhObservations(const Value: TClientDataSet);
    procedure ReadDataFromFile_1;
    procedure WriteDataToFile_1;
    procedure SetFixedH(const Value: TClientDataSet);
    procedure SetDeltaH(const Value: TClientDataSet);
    procedure SetDeltaDh(const Value: TClientDataSet);
    procedure SetResH(const Value: TClientDataSet);
  protected
    procedure ReadDataFromFile(FileName: string; Header: TGeoFileHeader); override;
    procedure WriteDataToFile; override;
    procedure DoWriteProgress(Sender: TObject); override;
  public
    property Cycles: TClientDataSet read FCycles write SetCycles;
    property DhObservations: TClientDataSet read FDhObservations write SetDhObservations;
    property DeltaDh: TClientDataSet read FDeltaDh write SetDeltaDh;
    property DeltaH: TClientDataSet read FDeltaH write SetDeltaH;
    property FixedH: TClientDataSet read FFixedH write SetFixedH;
    property ResH: TClientDataSet read FResH write SetResH;
  published
    property WritePercent;
  end;

implementation

const         
  MaxDataSetCount = 256; // Nie zmnienaæ. Maksymalna iloœæ tabel w pliku

  PmkFileHeader: TGeoFileHeader =
  (Name: 'Pmk';
    Description: 'Program Pmk umo¿liwia obliczanie przemieszczeñ pionowych';
    MajorVersion: 1;
    MinorVersion: 0;
    RelaseVersion: 0;
    FileVersion: 1); // Todo wczytywaæ te dane w sekcji initialization

{ TPmkFile }

procedure TPmkFile.DoWriteProgress(Sender: TObject);
begin
  SetWritePercent(100 * FWritePosition / FWriteTotal);
  inherited;
end;

procedure TPmkFile.ReadFromDataSet(DataSet: TClientDataSet;
  Fields: array of string);
var RecIndx, FldIndx, RecCount: Integer;
begin
  DataSet.EmptyDataSet;
  RecCount:= ReadInteger;
  for RecIndx:= 0 to RecCount-1 do begin
    DataSet.Append;
    for FldIndx:= Low(Fields) to High(Fields) do
      DataSet[Fields[FldIndx]]:= ReadVariant;
    DataSet.Post;
  end;
end;

procedure TPmkFile.WriteDataSet(DataSet: TClientDataSet;
  Fields: array of string);
var RecIndx, FldIndx, RecCount: Integer;
    MasterSource: TDataSource;
begin
  Assert(FWritedDataSets < MaxDataSetCount);
  MasterSource:= DataSet.MasterSource;
  DataSet.MasterSource:= nil;
  try
    DataSet.First;
    RecCount:= DataSet.RecordCount;
    WriteInteger(RecCount);
    for RecIndx:= 0 to RecCount-1 do begin
      for FldIndx:= Low(Fields) to High(Fields) do
        WriteVariant(DataSet[Fields[FldIndx]]);
      DataSet.Next;
      Inc(FWritePosition);
    end;
  finally
    DataSet.MasterSource:= MasterSource;
  end;
  Inc(FWritedDataSets);
end;

const
  CyclesFields_1: array[0..11] of string = (
    'CycleNo',
    'Name',
    'Description',
    'BaseCycle',
    'Calc',
    'Date',
    'EstimationType',
    'EstimatedVariance',
    'StandartError',
    'StandartErrorErr',
    'FreeEstimation',
    'FixedPoints');

  DhObservationsFields_1: array[0..6] of string = (
    'CycleNo',  // Numer cyklu musi byæ pierwszy dla nastêpnych wersji programu
    'BeginPoint',
    'EndPoint',
    'N',
    'Dh',
    'V',
    'VErr');

  DeltaDhFields_1: array[0..4] of string = (
    'CycleNo',
    'BeginPoint',
    'EndPoint',  
    'Dh',
    'DhErr');

  DeltaHFields_1: array[0..3] of string = (
    'CycleNo',
    'Name',
    'Delta',
    'DeltaErr');

  FixedHFields_1: array[0..4] of string = (
    'Name',
    'H',
    'HErr',
    'V',
    'VErr');      

  ResHFields_1: array[0..4] of string = (
    'CycleNo',
    'Name',
    'H',
    'HErr',
    'V');

procedure TPmkFile.ReadDataFromFile_1;
begin
  ReadFromDataSet(Cycles, CyclesFields_1);
  ReadFromDataSet(DhObservations, DhObservationsFields_1);
  ReadFromDataSet(DeltaH, DeltaHFields_1);
  ReadFromDataSet(DeltaDh, DeltaDhFields_1);
  ReadFromDataSet(FixedH, FixedHFields_1);
  ReadFromDataSet(ResH, ResHFields_1);
end;

procedure TPmkFile.WriteDataToFile_1;
begin
  FWriteTotal:= 1 + Cycles.RecordCount +
                  + DhObservations.RecordCount
                  + DeltaH.RecordCount
                  + DeltaDh.RecordCount
                  + FixedH.RecordCount
                  + ResH.RecordCount;

  WriteDataSet(Cycles, CyclesFields_1);
  WriteDataSet(DhObservations, DhObservationsFields_1);
  WriteDataSet(DeltaH, DeltaHFields_1);
  WriteDataSet(DeltaDh, DeltaDhFields_1);
  WriteDataSet(FixedH, FixedHFields_1);
  WriteDataSet(ResH, ResHFields_1);
end;

procedure TPmkFile.ReadDataFromFile(FileName: string; Header: TGeoFileHeader);
begin
  inherited;
  case FileHeader.FileVersion of
    1: ReadDataFromFile_1;
    else FileVersionError;
  end;
end;

procedure TPmkFile.WriteDataToFile;
var i: Integer;
begin
  inherited;
  FWritedDataSets:= 0;
  FWritePosition:= 0;
  WriteDataToFile_1;
  
  // Zapisanie zer na koñcu pliku.
  // Gdy dojd¹ jakieœ nowe datasety to nie bêdzie problemu z odczytywaniem
  // danych przez nowsze programy. (Stream read error poniewa¿ jest ju¿ koniec pliku)
  for i:= FWritedDataSets+1 to MaxDataSetCount do
    WriteInteger(0);
end;

procedure TPmkFile.SetCycles(const Value: TClientDataSet);
begin
  FCycles := Value;
end;

procedure TPmkFile.SetDhObservations(const Value: TClientDataSet);
begin
  FDhObservations := Value;
end;

procedure TPmkFile.SetFixedH(const Value: TClientDataSet);
begin
  FFixedH := Value;
end;

procedure TPmkFile.SetDeltaH(const Value: TClientDataSet);
begin
  FDeltaH := Value;
end;

procedure TPmkFile.SetDeltaDh(const Value: TClientDataSet);
begin
  FDeltaDh := Value;
end;

procedure TPmkFile.SetResH(const Value: TClientDataSet);
begin
  FResH := Value;
end;

end.
