unit PmkFiles;

interface

uses
  SysUtils, Classes, DB, DbClient, Variants, 
  GeoFiles, GeoXML, GeoClasses, GeoSysUtils, GeoConsts;


type
  TPmkXmlFile = class(TCustomGeoFile)
  private
  protected
    procedure WriteDataSet(Node: IGeoXMLNode; DataSet: TDataSet; ExcludedFields: array of string);
    procedure ReadDataSet(Node: IGeoXMLNode; DataSet: TDataSet; IncludedFields: array of string; IncludedValues: array of OleVariant);
    procedure WriteActiveCycle(CycleNode: IGeoXMLNode);
    procedure ReadActiveCycle(CycleNode: IGeoXMLNode; CycleNo: Integer);
    procedure InternalNewFile; override;
    procedure InternalOpenFile(FileName: string); override;
    procedure InternalSaveFileAs(FileName: string); override;
    procedure InternalCloseFile; override;
    procedure WriteHeader(HeaderNode: IGeoXMLNode; Header: TGeoFileHeader);
    function ReadHeader(HeaderNode: IGeoXMLNode): TGeoFileHeader; 
    procedure WriteSettings(SettingsNode: IGeoXMLNode; DisplayFormat: string);
    function ReadSettings(SettingsNode: IGeoXMLNode): string;

  public
    Cycles: TClientDataSet;
    DhObservations: TClientDataSet;
    DeltaDh: TClientDataSet;
    DeltaH: TClientDataSet;
    FixedH: TClientDataSet;
    ResH: TClientDataSet;
    DisplayFormat: string;
  published
  end;


implementation

var
  // PmkFileHeader1
  // Jest czytany bez problemu przez PmkFileHeader2

  // PmkFileHeader2
  // W tej wersji pliku doszed³ wêze³ Settings oraz atrybut DisplayFormat
  PmkFileHeader2: TGeoFileHeader = (
    AppName: 'Pmk';
    AppDescription: 'Program do obliczeñ przemieszczeñ pionowych';
    AppVersion: '1.0.3';
    FileVersion: 2);

{ TPmkXmlFile }

procedure TPmkXmlFile.InternalCloseFile;
begin
  inherited;

end;

procedure TPmkXmlFile.InternalNewFile;
begin
  inherited;

end;

procedure TPmkXmlFile.WriteActiveCycle(CycleNode: IGeoXMLNode);
var Node: IGeoXMLNode;
begin              
  //CycleNode.AttrAsVariant['CycleNo']:= Cycles['CycleNo'];
  CycleNode.AttrAsVariant['Name']:= Cycles['Name'];
  CycleNode.AttrAsVariant['Description']:= Cycles['Description'];
  CycleNode.AttrAsVariant['BaseCycle']:= Cycles['BaseCycle'];
  CycleNode.AttrAsVariant['Calc']:= Cycles['Calc'];
  CycleNode.AttrAsVariant['Date']:= Cycles['Date'];

  Node:= CycleNode.AddChild('MvmntH');
  Node.AttrAsVariant['EstimatedVariance']:= Cycles['EstimatedVariance'];
  Node.AttrAsVariant['StandartError']:= Cycles['StandartError'];
  Node.AttrAsVariant['StandartErrorErr']:= Cycles['StandartErrorErr'];
  Node.AttrAsVariant['FreeEstimation']:= Cycles['FreeEstimation'];
  Node.AttrAsVariant['EstimationType']:= Cycles['EstimationType'];
  Node.AttrAsVariant['FixedPoints']:= Cycles['FixedPoints'];

  Node:= CycleNode.AddChild('DhObs');
  WriteDataSet(Node, DhObservations, ['CycleNo']);

  Node:= CycleNode.AddChild('DeltaDh');
  WriteDataSet(Node, DeltaDh, ['CycleNo']);

  Node:= CycleNode.AddChild('DeltaH');
  WriteDataSet(Node, DeltaH, ['CycleNo']);

  Node:= CycleNode.AddChild('ResH');
  WriteDataSet(Node, ResH, ['CycleNo']);
end;

procedure TPmkXmlFile.ReadActiveCycle(CycleNode: IGeoXMLNode; CycleNo: Integer);
var Node: IGeoXMLNode;
begin
  if CycleNode = nil then
    Exit;
  Cycles.Append;
    Cycles['CycleNo']:= CycleNo; // CycleNode.AttrAsVariant['CycleNo'];
    Cycles['Name']:= CycleNode.AttrAsVariant['Name'];
    Cycles['Description']:= CycleNode.AttrAsVariant['Description'];
    Cycles['BaseCycle']:= CycleNode.AttrAsVariant['BaseCycle'];
    Cycles['Calc']:= CycleNode.AttrAsVariant['Calc'];
    Cycles['Date']:= CycleNode.AttrAsVariant['Date'];
    Node:= CycleNode.FindChildNode('MvmntH');
    if Node <> nil then begin
      Node.AttrAsVariant['EstimatedVariance']:= Cycles['EstimatedVariance'];
      Node.AttrAsVariant['StandartError']:= Cycles['StandartError'];
      Node.AttrAsVariant['StandartErrorErr']:= Cycles['StandartErrorErr'];
      Node.AttrAsVariant['FreeEstimation']:= Cycles['FreeEstimation'];
      Node.AttrAsVariant['EstimationType']:= Cycles['EstimationType'];
      Node.AttrAsVariant['FixedPoints']:= Cycles['FixedPoints'];
    end;
  Cycles.Post;

  Node:= CycleNode.FindChildNode('DhObs');
  ReadDataSet(Node, DhObservations, ['CycleNo'], [CycleNo]);

  Node:= CycleNode.FindChildNode('DeltaDh');
  ReadDataSet(Node, DeltaDh, ['CycleNo'], [CycleNo]);

  Node:= CycleNode.FindChildNode('DeltaH');
  ReadDataSet(Node, DeltaH, ['CycleNo'], [CycleNo]);

  Node:= CycleNode.FindChildNode('ResH');
  ReadDataSet(Node, ResH, ['CycleNo'], [CycleNo]);
end;

procedure TPmkXmlFile.InternalOpenFile(FileName: string);
var XMLDoc: IGeoXMLDocument;
    GeoCalcNode, Node: IGeoXMLNode;
    CycleNo: Integer;
    Header: TGeoFileHeader;
begin
  XMLDoc:= CreateXMLDocument(FileName);
  
  Node:= XMLDoc.DocumentNode.FindChildNode('FileHeader');
  //if (Node = nil) or (Node.AttrAsInteger['FileVersion'] > PmkFileHeader2.FileVersion) then
  //  RaiseError(emInvalidFileFormat);

  GeoCalcNode:= XMLDoc.DocumentNode.FindChildNode('GeoCalc');
  if GeoCalcNode <> nil then begin

    Node:= GeoCalcNode.FindChildNode('Header');
    if Node <> nil then begin
      Header:= ReadHeader(Node);
      CheckFileHeader(Header, PmkFileHeader2);
    end
    else
      RaiseError(emInvalidFileFormat); 

    Node:= GeoCalcNode.FindChildNode('Settings');
    if Node <> nil then
      DisplayFormat:= ReadSettings(Node)
    else
      DisplayFormat:= '0.0000';

    Node:= GeoCalcNode.FindChildNode('FixedPoints');
    ReadDataSet(Node, FixedH, [], []);

    CycleNo:= 1;
    Node:= GeoCalcNode.FindChildNode('Cycles');
    if Node <> nil then
      Node:= Node.FirstChild;
    while Node <> nil do begin
      ReadActiveCycle(Node, CycleNo);
      Node:= Node.NextSibling;
      Inc(CycleNo);
    end;
  end
  else
    RaiseError(emInvalidFileFormat);
end;

procedure TPmkXmlFile.InternalSaveFileAs(FileName: string);
var XMLDoc: IGeoXMLDocument;
    GeoCalcNode, Node: IGeoXMLNode;

begin
  XMLDoc:= CreateXMLDocument;

  Node:= XMLDoc.DocumentNode.AddChild('FileHeader');
  Node.AttrAsInteger['FileVersion']:= PmkFileHeader2.FileVersion;
  Node.AttrAsDateTime['CreateTime']:= Now;

  GeoCalcNode:= XMLDoc.DocumentNode.AddChild('GeoCalc');

  Node:= GeoCalcNode.AddChild('Header');
  WriteHeader(Node, PmkFileHeader2);       

  Node:= GeoCalcNode.AddChild('Settings');
  WriteSettings(Node, DisplayFormat);

  Node:= GeoCalcNode.AddChild('FixedPoints');
  WriteDataSet(Node, FixedH, []);

  Node:= GeoCalcNode.AddChild('Cycles');
  Cycles.First;
  while not Cycles.Eof do begin
    WriteActiveCycle(Node.AddChild('Cycle'));
    Cycles.Next;
  end;
  XMLDoc.Save(FileName);
end;

procedure SetFieldValue(Field: TField; Node:  IGeoXMLNode);
begin
  case Field.DataType of
    ftString, ftWideString, ftFixedChar, ftMemo, ftFmtMemo:
      Field.AsString:= Node.AttrAsString[Field.FieldName];
    ftBoolean:
      Field.AsBoolean:= Node.AttrAsBoolean[Field.FieldName];
    ftFloat, ftCurrency:
      Field.AsFloat:= Node.AttrAsFloat[Field.FieldName];
    ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint:
      Field.AsInteger:= Node.AttrAsInteger[Field.FieldName];
    ftDate, ftTime, ftDateTime:
      Field.AsDateTime:= Node.AttrAsDateTime[Field.FieldName];
  end;
end;

procedure TPmkXmlFile.ReadDataSet(Node: IGeoXMLNode; DataSet: TDataSet;
  IncludedFields: array of string; IncludedValues: array of OleVariant);
var i: Integer;
    RecNode: IGeoXMLNode;
begin
  if Node <> nil then begin
    RecNode:= Node.FirstChild;
    while RecNode <> nil do begin
      Assert(RecNode.NodeName = 'Record');
      DataSet.Append;
      try
        for i:= 0 to DataSet.Fields.Count-1 do
          if DataSet.Fields[i].FieldKind = fkData then
            SetFieldValue(DataSet.Fields[i], RecNode);
        Assert(Low(IncludedFields) = Low(IncludedValues));
        Assert(High(IncludedFields) = High(IncludedValues));
        // dodatkowe pola
        for i:= Low(IncludedFields) to High(IncludedFields) do
          DataSet[IncludedFields[i]]:= IncludedValues[i];
      finally
        if DataSet.State in dsEditModes then
          DataSet.Post;
      end;
      RecNode:= RecNode.NextSibling;
    end;
  end;
end;

procedure TPmkXmlFile.WriteDataSet(Node: IGeoXMLNode; DataSet: TDataSet;
  ExcludedFields: array of string);

  function ExcludedField(FieldName: string): Boolean;
  var i: Integer;
  begin
    Result:= False;
    for i:= Low(ExcludedFields) to High(ExcludedFields) do
      if SameText(FieldName, ExcludedFields[i]) then begin
        Result:= True;
        Exit;
      end;
  end;

var i: Integer;
    RecNode: IGeoXMLNode;
begin
  DataSet.First;
  while not DataSet.Eof do begin
    RecNode:= Node.AddChild('Record');
    for i:= 0 to DataSet.Fields.Count-1 do
      with DataSet.Fields[i] do
        if (FieldKind = fkData) and not ExcludedField(FieldName) then
          RecNode.AttrAsVariant[FieldName]:= Value;
    DataSet.Next;
  end;
end;

function TPmkXmlFile.ReadHeader(HeaderNode: IGeoXMLNode): TGeoFileHeader;
begin
  with Result, HeaderNode do begin
    AppName:= AttrAsString['AppName'];
    AppDescription:= AttrAsString['AppDescription'];
    AppVersion:= AttrAsString['AppVersion'];
    FileVersion:= AttrAsInteger['FileVersion'];
  end;
end;

procedure TPmkXmlFile.WriteHeader(HeaderNode: IGeoXMLNode; Header: TGeoFileHeader);
begin
  with Header, HeaderNode do begin
    AttrAsString['AppName']:= AppName;
    AttrAsString['AppDescription']:= AppDescription;
    AttrAsString['AppVersion']:= AppVersion;
    AttrAsInteger['FileVersion']:= FileVersion;
  end;
end;

function TPmkXmlFile.ReadSettings(SettingsNode: IGeoXMLNode): string;
begin
  with SettingsNode do begin
    Result:= AttrAsString['DisplayFormat'];
  end;
end;

procedure TPmkXmlFile.WriteSettings(SettingsNode: IGeoXMLNode;
  DisplayFormat: string);
begin
  with SettingsNode do begin
    AttrAsString['DisplayFormat']:= DisplayFormat;
  end;
end;

end.
