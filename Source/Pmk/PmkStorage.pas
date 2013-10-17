unit PmkStorage;

interface

uses
  IniFiles, SysUtils, Classes, TypInfo, Variants, RtlConsts,
  Windows, Forms, Dialogs;

type
  EGeoIniFileError = class(Exception);

  TGeoIniFile = class(TMemIniFile)
  private
    function GetInstanceName(Instance: TComponent): string;
    function GetSectionName(Instance: TComponent): string;
    function GetIdentName(Instance: TComponent; PropName: string): string;
    procedure InternalReadProperty(const Section, Ident: string;
      Instance: TObject; PropInfo: PPropInfo; RaiseErrors: Boolean);
    procedure InternalWriteProperty(const Section, Ident: string;
      Instance: TObject; PropInfo: PPropInfo; RaiseErrors: Boolean);
  protected
    function InternalGetPropInfo(Instance: TComponent; PropName: string): PPropInfo;
  public
    function ReadVariant(const Section, Ident: string; Default: Variant): Variant; virtual;
    procedure WriteVariant(const Section, Ident: string; Value: Variant); virtual;
    procedure ReadProperty(Instance: TComponent; PropName: string); virtual;
    procedure WriteProperty(Instance: TComponent; PropName: string); virtual;
    procedure ReadStrings(const Section, Ident: string; Value: TStrings); virtual;
    procedure WriteStrings(const Section, Ident: string; Value: TStrings); virtual;
    procedure WriteFormPostion(Form: TForm);
    procedure ReadFormPostion(Form: TForm);
  end;

function GeoIniFile: TGeoIniFile;

implementation

var IniFile: TGeoIniFile;

const
  emIniFileNotSet = 'GeoIniFile: FileName not set';
  emPropertyNotFound = 'Property not found: %s';


procedure RaiseError(Msg: string; Args: array of const); overload;
begin
  raise EGeoIniFileError.CreateFmt(Msg, Args);
end;

procedure RaiseError(Msg: string); overload;
begin
  raise EGeoIniFileError.Create(Msg);
end;

function GeoIniFile: TGeoIniFile;
begin
  if IniFile = nil then
    raise Exception.Create(emIniFileNotSet);
  Result:= IniFile;
end;

procedure CloseIniFile;
begin
  if IniFile <> nil then begin
    IniFile.UpdateFile;
    FreeAndNil(IniFile);
  end;
end;

procedure UpdateIniFile;
begin
  if IniFile <> nil then
    IniFile.UpdateFile;
end;

procedure SetIniFileName(FileName: string);
begin
  CloseIniFile;
  IniFile:= TGeoIniFile.Create(FileName);
end;

function DefaultIniFileName: string;
begin
  Result:= ChangeFileExt(ParamStr(0), '.ini');
end;


{ TGeoIniFile }   

function TGeoIniFile.GetInstanceName(Instance: TComponent): string;
begin
  Result:= Instance.Name;
  if Result = '' then
    Result:= Instance.ClassName;
end;

function TGeoIniFile.InternalGetPropInfo(Instance: TComponent;
  PropName: string): PPropInfo;
begin
  Result := GetPropInfo(Instance, PropName);
  if Result = nil then
    RaiseError(emPropertyNotFound, [Instance.Name+'.'+PropName]);
end;

function TGeoIniFile.GetSectionName(Instance: TComponent): string;
begin
  while (Instance.Owner <> nil) and not (Instance is TCustomForm) do
    Instance:= Instance.Owner;
  Result:= GetInstanceName(Instance);
end;

function TGeoIniFile.GetIdentName(Instance: TComponent; PropName: string): string;
begin
  Result:= PropName;
  while (Instance.Owner <> nil) and not (Instance is TCustomForm) do begin
    Result:= Format('%s.%s', [GetInstanceName(Instance), Result]); // nie zapisuj ostatniego ownera
    Instance:= Instance.Owner;
  end;
end;

procedure TGeoIniFile.InternalReadProperty(const Section, Ident: string;
  Instance: TObject; PropInfo: PPropInfo; RaiseErrors: Boolean);


  function RangedValue(const AMin, AMax: Int64; const Value: Int64): Int64;
  begin
    Result := Value;
    if Result < AMin then
      Result := AMin;
    if Result > AMax then
      Result := AMax;
  end;

var
  TypeData: PTypeData;
  NumValue: Int64;
  StrValue: string;
  VarValue: Variant;
  FloatValue: Double;
  //ObjValue: TObject;
begin
  if PropInfo = nil then
    RaiseError(SUnknownProperty, [PropInfo.Name])
  else begin
    TypeData := GetTypeData(PropInfo^.PropType^);
    case PropInfo.PropType^^.Kind of
      tkInteger, tkChar, tkWChar: begin
        NumValue:= GetOrdProp(Instance, PropInfo);
        NumValue:= ReadInteger(Section, Ident, NumValue);
        if TypeData^.MinValue < TypeData^.MaxValue then
          NumValue:= RangedValue(TypeData^.MinValue, TypeData^.MaxValue, NumValue)
        else // Unsigned type
          NumValue:= RangedValue(LongWord(TypeData^.MinValue), LongWord(TypeData^.MaxValue), NumValue);
        SetOrdProp(Instance, PropInfo, NumValue);
      end;
      tkEnumeration: begin
        StrValue:= GetEnumProp(Instance, PropInfo);
        StrValue:= ReadString(Section, Ident, StrValue);
        SetEnumProp(Instance, PropInfo, StrValue);
      end;
      tkSet: begin
        StrValue:= GetEnumProp(Instance, PropInfo);
        StrValue:= ReadString(Section, Ident, StrValue);
        SetSetProp(Instance, PropInfo, StrValue);
      end;
      tkFloat: begin
        FloatValue:= GetFloatProp(Instance, PropInfo);
        FloatValue:= ReadFloat(Section, Ident, FloatValue);
        SetFloatProp(Instance, PropInfo, FloatValue);
      end;
      tkString, tkLString: begin
        StrValue:= GetStrProp(Instance, PropInfo);
        StrValue:= ReadString(Section, Ident, StrValue);
        SetStrProp(Instance, PropInfo, StrValue);
      end;
      tkWString: begin
        StrValue:= GetWideStrProp(Instance, PropInfo);
        StrValue:= ReadString(Section, Ident, StrValue);
        SetStrProp(Instance, PropInfo, StrValue);
      end;
      tkVariant: begin
        VarValue:= GetVariantProp(Instance, PropInfo);
        VarValue:= ReadVariant(Section, Ident, VarValue);
        SetVariantProp(Instance, PropInfo, VarValue);
      end;
      tkInt64: begin
        NumValue:= GetInt64Prop(Instance, PropInfo);
        NumValue:= ReadInteger(Section, Ident, NumValue);
        NumValue:= RangedValue(TypeData^.MinInt64Value, TypeData^.MaxInt64Value, NumValue);
        SetInt64Prop(Instance, PropInfo, NumValue);
      end;      
      {tkClass: begin
        ObjValue:= GetObjectProp(Instance, PropInfo);
        ReadObject(Section, Ident, ObjValue);
        SetObjectProp(Instance, PropInfo, ObjValue);
      end; }
      else
        if RaiseErrors then
          RaiseError(SInvalidPropertyType, [PropInfo.PropType^^.Name]);
    end;
  end;
end;

procedure TGeoIniFile.InternalWriteProperty(const Section, Ident: string;
  Instance: TObject; PropInfo: PPropInfo; RaiseErrors: Boolean);
begin
  if PropInfo = nil then
    RaiseError(SUnknownProperty, [PropInfo.Name])
  else begin
    case PropInfo^.PropType^^.Kind of
      tkInteger, tkChar, tkWChar:
        WriteInteger(Section, Ident, GetOrdProp(Instance, PropInfo));
      tkEnumeration:
        WriteString(Section, Ident, GetEnumProp(Instance, PropInfo));
      tkSet:
        WriteString(Section, Ident, GetSetProp(Instance, PropInfo));
      tkFloat:
        WriteFloat(Section, Ident, GetFloatProp(Instance, PropInfo));
      tkMethod:
        WriteString(Section, Ident, PropInfo^.PropType^.Name);
      tkString, tkLString:         
        WriteString(Section, Ident, GetStrProp(Instance, PropInfo));
      tkWString:
        WriteString(Section, Ident, GetWideStrProp(Instance, PropInfo));
      tkVariant:
        WriteVariant(Section, Ident, GetVariantProp(Instance, PropInfo));
      tkInt64:
        WriteInteger(Section, Ident, GetInt64Prop(Instance, PropInfo));
      //tkClass:
      //  WriteObject(Section, Ident, GetObjectProp(Instance, PropInfo));
      else    
        if RaiseErrors then
          RaiseError(SInvalidPropertyType, [PropInfo.PropType^^.Name]);
    end;
  end;
end;

procedure TGeoIniFile.ReadProperty(Instance: TComponent; PropName: string);
var
  PropInfo: PPropInfo;
  Section, Ident: string;
begin
  PropInfo := InternalGetPropInfo(Instance, PropName);
  Section:= GetSectionName(Instance);
  Ident:= GetIdentName(Instance, PropName);
  InternalReadProperty(Section, Ident, Instance, PropInfo, True);
end;

procedure TGeoIniFile.WriteProperty(Instance: TComponent; PropName: string);
var PropInfo: PPropInfo;
    Section, Ident: string;
begin
  PropInfo := InternalGetPropInfo(Instance, PropName);
  Section:= GetSectionName(Instance);
  Ident:= GetIdentName(Instance, PropName);
  InternalWriteProperty(Section, Ident, Instance, PropInfo, True);
end;

function TGeoIniFile.ReadVariant(const Section, Ident: string;
  Default: Variant): Variant;
begin
  Result:= ReadString(Section, Ident, VarToStr(Default));
end;

procedure TGeoIniFile.WriteVariant(const Section, Ident: string;
  Value: Variant);
begin
  WriteString(Section, Ident, VarToStr(Value));
end;

procedure TGeoIniFile.ReadStrings(const Section, Ident: string; Value: TStrings);
begin
  Value.CommaText:= ReadString(Section, Ident, '');
end;

procedure TGeoIniFile.WriteStrings(const Section, Ident: string; Value: TStrings);
begin
  WriteString(Section, Ident, Value.CommaText);
end;

procedure TGeoIniFile.ReadFormPostion(Form: TForm);
begin
  ReadProperty(Form, 'Left');
  ReadProperty(Form, 'Top');
  ReadProperty(Form, 'Width');
  ReadProperty(Form, 'Height');
  
  // uwzglêdnij mo¿liw¹ zmianê rozdzielczoœci monitora
  if Form.Height > Screen.Height then
    Form.Height:= Screen.Height;
  if Form.Width > Screen.Width then
    Form.Width:= Screen.Width;
  if Form.Left > Screen.Width then
    Form.Left:= 0;
  if Form.Top > Screen.Height then
    Form.Top:= 0;    
  ReadProperty(Form, 'WindowState');
end;

procedure TGeoIniFile.WriteFormPostion(Form: TForm);
var
  Placement: TWindowPlacement;
  Section: string;
begin
  {WriteProperty(Form, 'Left');
  WriteProperty(Form, 'Top');
  WriteProperty(Form, 'Width');
  WriteProperty(Form, 'Height');  }

  Placement.Length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @Placement);
  Section:= GetSectionName(Form);
  with Placement.rcNormalPosition do begin
    WriteInteger(Section, GetIdentName(Form, 'Left'), Left);
    WriteInteger(Section, GetIdentName(Form, 'Top'), Top);
    WriteInteger(Section, GetIdentName(Form, 'Width'), Right - Left);
    WriteInteger(Section, GetIdentName(Form, 'Height'), Bottom - Top);
  end;
  WriteProperty(Form, 'WindowState');
end;

initialization
  SetIniFileName(DefaultIniFileName);

finalization
  CloseIniFile;

end.
