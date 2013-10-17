unit FrmBaseCreatorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, StdCtrls,
  Forms, ComCtrls, Controls, ExtCtrls, Dialogs, FrmBaseForm;

type
  TBaseCreatorForm = class(TBaseForm)
    PnlButtons: TPanel;
    Bevel: TBevel;
    BtnBack: TButton;
    BtnNext: TButton;
    BtnCancel: TButton;
    PageControl: TPageControl;
    Panel1: TPanel;
    Bevel1: TBevel;
    LblPageTitle: TLabel;
    LblPageInfo: TLabel;
    Image: TImage;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnBackClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure PnlButtonsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  protected
    procedure OnGetNextPageIndex(BtnNext: boolean; var NewPageIndex: integer); virtual;
    procedure OnLastPage; virtual;
    procedure AfterShowPage; virtual;
    function IsLastPage: boolean;
    procedure SetNextPage;
    procedure SetPriorPage;
    procedure DisableButtons;
    procedure EnableButtons;
    procedure BeginProcessing;
    procedure EndProcessing;
    function ImageFileName: String; override;
  public
    { Public declarations }

  end;

var
  BaseCreatorForm: TBaseCreatorForm;

implementation

{$R *.dfm}

procedure TBaseCreatorForm.SetNextPage;
var NewTabIndex: integer;
begin
  with PageControl do
    if ActivePageIndex < PageCount - 1 then begin
      NewTabIndex:= ActivePageIndex + 1;
      // Wszystkie zak³adki, które maj¹  Tag <> 0 s¹ pomijane
      with PageControl do
        while (NewTabIndex < PageCount-1) and (Pages[NewTabIndex].Tag <> 0) do
          Inc(NewTabIndex);
      OnGetNextPageIndex(true, NewTabIndex);
      ActivePageIndex:= NewTabIndex;
      if IsLastPage then begin
        BtnNext.Caption:= 'Zamknij';
        BtnNext.OnClick:= BtnCancel.OnClick;
        BtnCancel.Visible:= false;
        BtnBack.Visible:= false;
        OnLastPage;
      end;
    end;
  AfterShowPage;
end;

procedure TBaseCreatorForm.SetPriorPage;
var NewTabIndex: integer;
begin
  with PageControl do
    if ActivePageIndex > 0 then begin
      NewTabIndex:= ActivePageIndex - 1;
      OnGetNextPageIndex(false, NewTabIndex);
      ActivePageIndex:= NewTabIndex;
    end;
  AfterShowPage;
end;

procedure TBaseCreatorForm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TBaseCreatorForm.FormCreate(Sender: TObject);
var i: integer;
begin
  with PageControl do begin
    for i:= 0 to PageCount-1 do begin
      Pages[i].TabVisible:= false;
    end;
    ActivePageIndex:= 0;
    BtnBack.Enabled:= false;
  end;
end;

procedure TBaseCreatorForm.BtnBackClick(Sender: TObject);
begin
  SetPriorPage
end;

procedure TBaseCreatorForm.BtnNextClick(Sender: TObject);
begin
  SetNextPage;
end;

procedure TBaseCreatorForm.OnLastPage;
begin

end;

function TBaseCreatorForm.IsLastPage: boolean;
begin
  with PageControl do
    result:= ActivePageIndex = PageCount - 1;
end;

procedure TBaseCreatorForm.OnGetNextPageIndex(BtnNext: boolean; var NewPageIndex: integer);
begin

end;

procedure TBaseCreatorForm.AfterShowPage;
begin
  BtnBack.Enabled:= PageControl.ActivePageIndex <> 0;
end;

procedure TBaseCreatorForm.DisableButtons;
begin
  BtnCancel.Enabled:= False;
  BtnBack.Enabled:= False;
  BtnNext.Enabled:= False;
  Application.ProcessMessages;
end;

procedure TBaseCreatorForm.EnableButtons;
begin
  BtnCancel.Enabled:= True;
  BtnBack.Enabled:= True;
  BtnNext.Enabled:= True; 
  Application.ProcessMessages;
end;

procedure TBaseCreatorForm.BeginProcessing;
begin
  DisableButtons;
  Screen.Cursor:= crHourGlass;
end;

procedure TBaseCreatorForm.EndProcessing;
begin
  EnableButtons;
  Screen.Cursor:= crDefault;
end;

procedure TBaseCreatorForm.PnlButtonsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if [ssShift, ssAlt, ssRight] = Shift then
    SaveFormImageDlg;
end;

function TBaseCreatorForm.ImageFileName: String;
begin
  Result:= Self.Name+'.'+PageControl.ActivePage.Name+'.bmp';
end;

end.
