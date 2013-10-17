unit FrmSelectMovement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmBaseCreatorForm, StdCtrls, ComCtrls, ExtCtrls, BaseUnit;

type
  TFmSelectMovement = class(TBaseCreatorForm)
    TsSelectMovement: TTabSheet;
    rbAbsoluteDh: TRadioButton;
    rbAbsoluteH: TRadioButton;
    rbRelativeDh: TRadioButton;
    rbRelativeH: TRadioButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnNextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmSelectMovement: TFmSelectMovement;

procedure ShowCalcMovementsCreator;

implementation

uses FrmCalcAbsDhMvmnt, FrmCalcAbsHMvmnt,
  FrmCalcRelDhMvmnt, FrmCalcRelHMvmnt;

{$R *.dfm}

procedure ShowCalcMovementsCreator;
begin
  with TFmSelectMovement.Create(Application) do
  try
    if ShowModal <> mrOK then
      Exit;
  finally
    Free;
  end;
end;

procedure TFmSelectMovement.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action:= caFree;  
end;

procedure TFmSelectMovement.BtnNextClick(Sender: TObject);
begin
  Hide;
  if rbAbsoluteDh.Checked then begin
    ShowFormModal(TFmCalcAbsDhMvmnt, Top, Left);
  end else
  if rbRelativeDh.Checked then begin
    ShowFormModal(TFmCalcRelDhMvmnt, Top, Left);
  end else
  if rbAbsoluteH.Checked then begin
    ShowFormModal(TFmCalcAbsHMvmnt, Top, Left);
  end else
  if rbRelativeH.Checked then
    ShowFormModal(TFmCalcRelHMvmnt, Top, Left);
  Close;
end;

end.
