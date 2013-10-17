unit FrmBaseForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseUnit, PmkResStr, PmkStorage;

type
  TBaseForm = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    function ImageFileName: string; virtual;
  public
    { Public declarations }  
    function PrintEnabled: Boolean; virtual;
    function PrintPreviewEnabled: Boolean; virtual;
    procedure Print; virtual;
    procedure PrintPreview; virtual; 
    procedure ExportToExcel; virtual;
    procedure SaveFormImageDlg;
  end;

var
  BaseForm: TBaseForm;

procedure SaveFormImage(Form: TForm; FileName: string);

implementation

{$R *.dfm}

procedure SaveFormImage(Form: TForm; FileName: string);
var Bmp: TBitmap;
    DesktopCanvas: TCanvas;
    DestRect, SrcRect: TRect;
begin
  Application.ProcessMessages;
  Bmp:=TBitmap.Create;
  DesktopCanvas:=TCanvas.Create;
  Application.ProcessMessages;
  try;
    DesktopCanvas.Handle:= GetWindowDC(GetDesktopWindow);
    try
      GetWindowRect(Form.Handle, SrcRect);
      with SrcRect do begin
        Bmp.Width:= Right-Left;
        Bmp.Height:= Bottom-Top;
      end;
      DestRect:= Rect(0, 0, Bmp.Width, Bmp.Height);
      Bmp.Canvas.CopyRect(DestRect, DesktopCanvas, SrcRect);
      Bmp.SaveToFile(FileName);
    finally
      ReleaseDC(GetDesktopWindow, DesktopCanvas.Handle);
    end;
  finally
    DesktopCanvas.Free;
    Bmp.Free;
  end;
end;

procedure TBaseForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN: begin
      Keybd_Event( VK_TAB, 0, 0, 0 );
      Key:= 0;
    end;
    VK_PRINT: SaveFormImageDlg; // Nie dzia³a
    VK_SCROLL: SaveFormImageDlg;
  end;
end;

procedure TBaseForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //
end;

procedure TBaseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TBaseForm.Print;
begin
  RaiseError(emNotSupported);
end;

procedure TBaseForm.PrintPreview;
begin
  RaiseError(emNotSupported);
end;   

procedure TBaseForm.ExportToExcel;
begin
  RaiseError(emNotSupported);
end;

function TBaseForm.PrintEnabled: Boolean;
begin
  Result:= False;
end;

function TBaseForm.PrintPreviewEnabled: Boolean;
begin
  Result:= PrintEnabled;
end;

procedure TBaseForm.FormDestroy(Sender: TObject);
begin
  GeoIniFile.WriteFormPostion(Self);
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin
  GeoIniFile.ReadFormPostion(Self);
end;

procedure TBaseForm.SaveFormImageDlg;
begin
  with TSaveDialog.Create(nil) do
  try
    Filter:= 'Bitmaps|*.bmp';
    FileName:= ImageFileName;
    if Execute then begin
      Screen.Cursor:= crNone;
      SaveFormImage(Self, FileName);
      Screen.Cursor:= crDefault;
    end;
  finally
    Free;
  end;
end;

function TBaseForm.ImageFileName: string;
begin
  Result:= Self.Name+'.bmp';
end;

end.
