unit FrmPrintPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseForm, ExtCtrls, GmThumbnails, ActnList, StdActns,
  ImgList, GmPreview, StdCtrls, ComCtrls, ToolWin, Db, Printers;

type
  TFmPrintPreview = class(TBaseForm)
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton2: TToolButton;
    edScale: TComboBox;
    GmPreview: TGmPreview;
    ImageList: TImageList;
    ActionList: TActionList;
    ActPrintDlg: TPrintDlg;
    ActPageFit: TAction;
    ActWidthFit: TAction;
    ActZoomIn: TAction;
    ActZoomOut: TAction;
    GmThumbnails: TGmThumbnails;
    Panel4: TPanel;
    ActPrint: TAction;
    ToolButton9: TToolButton;
    ActPageSetup: TAction;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure edScaleSelect(Sender: TObject);
    procedure edScaleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActPrintExecute(Sender: TObject);
    procedure ActPageSetupExecute(Sender: TObject);
  private
    FTitle: string;
    FDataSet: TDataSet;
    FRowScale: Double;
    FCharWidth: Double;
    FRowSpace: Double;
    FTop: Double;
    function FieldWidth(Field: TField): Double;
    function GetRowScale(Fields: TFields): Double;
    procedure UpdateScale;
    procedure LoadDataSet(DataSet: TDataSet; Title: string);
  protected
    procedure GmDataSetHeaderOut(Top, Left: Double; Fields: TFields);
    procedure GmFloatOut(Top, Left, Width, Value: Double; Format: string);
    procedure GmIntegerOut(Top, Left, Width: Double; Value: Integer);
    procedure GmNumericOut(Top, Left, Width: Double; Value: string);
    procedure GmRecordOut(Top, Left: Double; Fields: TFields);
    procedure GmTextOut(Top, Left, Width: Double; Text: string);
    function NewLine(var Top: Double): Boolean;
  public
    class procedure PreviewDataSet(DataSet: TDataSet; Title: string);
    class procedure PrintDataSet(DataSet: TDataSet; Title: string);
    procedure GmDataSetOut(DataSet: TDataSet);
  end;

var
  FmPrintPreview: TFmPrintPreview;

implementation

{$R *.dfm}

uses
  CommDlg;

const
  NumericFieldTypes: set of TFieldType =
    [ftSmallint, ftInteger, ftWord,  ftFloat, ftCurrency,
    ftAutoInc, ftLargeint, ftDate, ftTime, ftDateTime];

  DefaultFontName = 'Tahoma';
  DefaultFontSize = 10;

class procedure TFmPrintPreview.PreviewDataSet(DataSet: TDataSet; Title: string);
begin
  with Create(Application) do
  try
    LoadDataSet(DataSet, Title);
    ShowModal;
  finally
    Free;
  end;
end;

class procedure TFmPrintPreview.PrintDataSet(DataSet: TDataSet; Title: string);
begin
  with Create(Application) do
  try
    LoadDataSet(DataSet, Title);
    GmPreview.Print;
  finally
    Free;
  end;
end;

//******************************************************************************
                     
procedure TFmPrintPreview.LoadDataSet(DataSet: TDataSet; Title: string);
begin
  FDataSet:= DataSet;
  GmPreview.Canvas.DefaultMeasurement:= GmMillimeters;
  GmPreview.Title:= Title;
  GmPreview.Footer.CaptionLeft:= 'Pmk - program do obliczeñ przemieszczeñ pionowych';
  GmPreview.Footer.CaptionRight:= Title+', str. {PAGE}/{NUMPAGES}';
  FTitle:= Title;
  FTop:= GmPreview.Margins.Top.AsMillimeters;
  GmPreview.Canvas.Font.Size:= DefaultFontSize + 2;
  GmPreview.Canvas.Font.Style:= [fsBold];
  GmTextOut(FTop, GmPreview.Margins.Left.AsMillimeters, 9e999, AnsiUpperCase(FTitle));
  NewLine(FTop);
  NewLine(FTop);
  GmDataSetOut(DataSet);
end;

function TFmPrintPreview.FieldWidth(Field: TField): Double;
begin
  Result:= FCharWidth * Field.DisplayWidth * FRowScale;
end;

function TFmPrintPreview.GetRowScale(Fields: TFields): Double;
var i: Integer;
    PrintWidth: Double;
begin
  Result:= 0;
  FCharWidth:= GmPreview.Canvas.TextWidth('O').AsMillimeters;
  for i:= 0 to Fields.Count-1 do
    if Fields[i].Visible then
      Result:= Result + FCharWidth*Fields[i].DisplayWidth;
  with GmPreview do
    PrintWidth:= PageWidth.AsMillimeters - (Margins.Left.AsMillimeters + Margins.Right.AsMillimeters);
  if Result < PrintWidth then
    Result:= 1
  else
    Result:= PrintWidth / Result;
end;

{$Message 'Drukowaæ informacje o cyklu pomiarowym i datê'}

function TFmPrintPreview.NewLine(var Top: Double): Boolean;
var MaxResult, LineHeigh: Double;
begin
  LineHeigh:= GmPreview.Canvas.textHeight('Zg').AsMillimeters * FRowSpace;
  Top:= Top + LineHeigh;
  MaxResult:= GmPreview.PageHeight.AsMillimeters
    - GmPreview.Margins.Bottom.AsMillimeters
    - GmPreview.Footer.Height.AsMillimeters
    - LineHeigh ;
  Result:= Top > MaxResult;
  if Result then begin
    Top:= GmPreview.Margins.Top.AsMillimeters;
    GmPreview.NewPage;
    GmThumbnails.Update;   
  end;
end;

procedure TFmPrintPreview.GmTextOut(Top, Left, Width: Double; Text: string);
begin
  with GmPreview.Canvas do begin
    if TextWidth(Text).AsMillimeters > Width then begin
      while TextWidth(Text+'...').AsMillimeters > Width do
        Delete(Text, Length(Text), 1);
      Text:= Text+'...';
    end;
    TextOut(Left, Top, Text);
  end;
end;

procedure TFmPrintPreview.GmNumericOut(Top, Left, Width: Double; Value: string);
var CharCount: Integer;
begin
  with GmPreview.Canvas do
    if TextWidth(Value).AsMillimeters > Width then begin
      CharCount:= Trunc(Width / FCharWidth);
      TextOut(Left, Top, StringOfChar('#', CharCount));
    end
    else
      TextOut(Left, Top, Value);
end;

procedure TFmPrintPreview.GmFloatOut(Top, Left, Width, Value: Double; Format: string);
begin
  GmNumericOut(Top, Left, Width, FormatFloat(Format, Value));
end;

procedure TFmPrintPreview.GmIntegerOut(Top, Left, Width: Double;  Value: Integer);
begin
  GmNumericOut(Top, Left, Width, IntToStr(Value));
end;

procedure TFmPrintPreview.GmDataSetHeaderOut(Top, Left: Double; Fields: TFields);
var i: Integer;
begin          
  GmPreview.Canvas.Font.Style:= [fsBold];
  for i:= 0 to Fields.Count-1 do
    if Fields[i].Visible then begin
      GmTextOut(Top, Left, FieldWidth(Fields[i]), Fields[i].DisplayLabel);
      Left:= Left + FieldWidth(Fields[i]);
    end;
end;

procedure TFmPrintPreview.GmRecordOut(Top, Left: Double; Fields: TFields);
var i: Integer;
begin     
  GmPreview.Canvas.Font.Style:= [];
  for i:= 0 to Fields.Count-1 do
    if Fields[i].Visible then begin
      if Fields[i].DataType in NumericFieldTypes then
        GmNumericOut(Top, Left, FieldWidth(Fields[i]), Fields[i].DisplayText)
      else
        GmTextOut(Top, Left, FieldWidth(Fields[i]), Fields[i].DisplayText);
      Left:= Left + FieldWidth(Fields[i]);
    end;
end;

procedure TFmPrintPreview.GmDataSetOut(DataSet: TDataSet);
var iLeft: Double;
    Bmrk: TBookmark;
begin
  GmPreview.MessagesEnabled := False;
  GmPreview.Canvas.Font.Size:= DefaultFontSize;
  //GmPreview.Margins.UsePrinterMargins;
  FRowScale:= GetRowScale(DataSet.Fields);
  iLeft:= GmPreview.Margins.Left.AsMillimeters;

  GmDataSetHeaderOut(FTop, iLeft, DataSet.Fields);
  Bmrk:= DataSet.GetBookmark;
  DataSet.DisableControls;
  Screen.Cursor:= crHourGlass;
  try
    DataSet.First;
    while not DataSet.Eof do begin
      if NewLine(FTop) then begin
        GmDataSetHeaderOut(FTop, iLeft, DataSet.Fields);
        NewLine(FTop);
      end;
      GmRecordOut(FTop, iLeft, DataSet.Fields);
      DataSet.Next;
    end;
    if DataSet.BookmarkValid(Bmrk) then
      DataSet.GotoBookmark(Bmrk);
  finally
    DataSet.EnableControls;
    Screen.Cursor:= crDefault;
    GmPreview.MessagesEnabled := True;
    GmPreview.UpdatePreview;
  end;
  GmPreview.FirstPage;
end;

procedure TFmPrintPreview.UpdateScale;
var s: string;
    p, z: Integer;
begin
  inherited;
  s:= EdScale.Text;
  p:= Pos('%', s);
  if p > 0 then
    Delete(s, p, 1);
  s:= Trim(s);
  z:= Round(StrToFloat(s));
  GmPreview.Zoom:= z;
  EdScale.Text:= IntToStr(z)+' %';
end;

//******************************************************************************

procedure TFmPrintPreview.FormCreate(Sender: TObject);
const ConvertOrientation: array[TPrinterOrientation] of TGmOrientation = (gmPortrait, gmLandscape);
begin
  inherited;
  FRowSpace:= 1.3;
  GmPreview.Orientation:= ConvertOrientation[Printer.Orientation];
  with GmPreview.Canvas.Font do begin
    Name:= DefaultFontName;
    Size:= DefaultFontSize;
  end;
  EdScale.Text:= '70';
  UpdateScale;
end;

procedure TFmPrintPreview.edScaleSelect(Sender: TObject);
begin
  inherited;
  UpdateScale;   
end;

procedure TFmPrintPreview.edScaleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = vk_return then begin
    Key:= 0;
    UpdateScale;
  end;
end;

procedure TFmPrintPreview.ActPrintExecute(Sender: TObject);
begin
  inherited;
  GmPreview.Print;
end;    

function CopyData(Handle: THandle): THandle;
var
  Src, Dest: PChar;
  Size: Integer;
begin
  if Handle <> 0 then
  begin
    Size := GlobalSize(Handle);
    Result := GlobalAlloc(GHND, Size);
    if Result <> 0 then
      try
        Src := GlobalLock(Handle);
        Dest := GlobalLock(Result);
        if (Src <> nil) and (Dest <> nil) then Move(Src^, Dest^, Size);
      finally
        GlobalUnlock(Handle);
        GlobalUnlock(Result);
      end
  end
  else Result := 0;
end;

procedure TFmPrintPreview.ActPageSetupExecute(Sender: TObject);
var
  PageSetupDlgRec: TPageSetupDlg;    
  DevHandle: THandle;

  procedure GetPrinter(var DeviceMode, DeviceNames: THandle);
  var
    Device, Driver, Port: array[0..1023] of char;
    DevNames: PDevNames;
    Offset: PChar;
  begin
    Printer.GetPrinter(Device, Driver, Port, DeviceMode);
    if DeviceMode <> 0 then
    begin
      DeviceNames := GlobalAlloc(GHND, SizeOf(TDevNames) +
       StrLen(Device) + StrLen(Driver) + StrLen(Port) + 3);
      DevNames := PDevNames(GlobalLock(DeviceNames));
      try
        Offset := PChar(DevNames) + SizeOf(TDevnames);
        with DevNames^ do
        begin
          wDriverOffset := Longint(Offset) - Longint(DevNames);
          Offset := StrECopy(Offset, Driver) + 1;
          wDeviceOffset := Longint(Offset) - Longint(DevNames);
          Offset := StrECopy(Offset, Device) + 1;
          wOutputOffset := Longint(Offset) - Longint(DevNames);;
          StrCopy(Offset, Port);
        end;
      finally
        GlobalUnlock(DeviceNames);
      end;
    end;
  end;

  procedure SetPrinter(DeviceMode, DeviceNames: THandle);
  var
    DevNames: PDevNames;
  begin
    DevNames := PDevNames(GlobalLock(DeviceNames));
    try
      with DevNames^ do
        Printer.SetPrinter(PChar(DevNames) + wDeviceOffset,
          PChar(DevNames) + wDriverOffset,
          PChar(DevNames) + wOutputOffset, DeviceMode);
    finally
      GlobalUnlock(DeviceNames);
      GlobalFree(DeviceNames);
    end;
  end;

begin               
  with PageSetupDlgRec do
  begin
    lStructSize := SizeOf(PageSetupDlgRec);
    //hDevNames := 0;
    hInstance := SysInit.HInstance;
    GetPrinter(DevHandle, hDevNames);
    hDevMode := CopyData(DevHandle);
    //Flags := PD_ENABLESETUPHOOK or PD_PRINTSETUP;
    Flags := PSD_DEFAULTMINMARGINS or PSD_MARGINS or PSD_INHUNDREDTHSOFMILLIMETERS;
    //lpfnSetupHook := DialogHook;
    hWndOwner := Application.Handle;
    with GmPreview.Margins do begin
      rtMargin.Left := Left.AsUnits;
      rtMargin.Top := Top.AsUnits;
      rtMargin.Right := Right.AsUnits;
      rtMargin.Bottom := Bottom.AsUnits;
    end;
               
    if PageSetupDlg(PageSetupDlgRec) then begin
      SetPrinter(hDevMode, hDevNames); 
      with GmPreview.Margins do begin
        Left.AsUnits := rtMargin.Left;
        Top.AsUnits := rtMargin.Top;
        Right.AsUnits := rtMargin.Right;
        Bottom.AsUnits := rtMargin.Bottom;
      end;
      GmPreview.UpdatePreview;
    end
    else begin
      if hDevMode <> 0 then GlobalFree(hDevMode);
      if hDevNames <> 0 then GlobalFree(hDevNames);
    end;
  end;
end;

end.
