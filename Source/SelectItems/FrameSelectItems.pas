unit FrameSelectItems;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, AppEvnts;
  
type
  TSelectItems = class(TFrame)
    PnlLeft: TPanel;
    PnlRight: TPanel;
    PnlCenter: TPanel;
    edAll: TListBox;
    edSelected: TListBox;
    BtnAddAll: TSpeedButton;
    BtnDeleteAll: TSpeedButton;
    BtnAdd: TSpeedButton;
    BtnDelete: TSpeedButton;
    BtnFilter: TSpeedButton;       
    BtnAddEx: TSpeedButton;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnAddExClick(Sender: TObject);
    procedure BtnAddAllClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnDeleteAllClick(Sender: TObject);
    procedure edAllClick(Sender: TObject);
    procedure edSelectedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure AddMatchedStrings(Pattern: string);
    function GetAllItems: TStrings;
    function GetSelectedItems: TStrings;
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
  protected
  public  
    property AllItems: TStrings read GetAllItems;
    property SelectedItems: TStrings read GetSelectedItems;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    procedure UpdateButtons;
    procedure SetSelectedItems(Items: TStrings);
  published
  end;

implementation

{$R *.dfm}

function StringMatches(Value, Pattern : string) : Boolean;
var
  NextPos, Star1, Star2: Integer;
  NextPattern : string;
begin
  Star1 := Pos('*', Pattern);
  if Star1 = 0 then
    Result := (Value = Pattern)
  else begin
    Result := (Copy(Value,1,Star1-1) = Copy(Pattern,1,Star1-1));
    if Result then begin
      if Star1 > 1 then Value := Copy(Value,Star1,Length(Value));
      Pattern := Copy(Pattern,Star1+1,Length(Pattern));

      NextPattern := Pattern;
      Star2 := Pos('*', NextPattern);
      if Star2 > 0 then NextPattern := Copy(NextPattern,1,Star2-1);

      NextPos := pos(NextPattern,Value);
      if (NextPos = 0) and not (NextPattern = '') then
        Result := False
      else begin
        Value := Copy(Value,NextPos,Length(Value));
        if Pattern = '' then
          Result := True
        else
          Result := Result and StringMatches(Value,Pattern);
      end;
    end;
  end;
end;

procedure TSelectItems.AddMatchedStrings(Pattern: string);
var i: Integer;
begin
  for i:= edAll.Count-1 downto 0 do
    if StringMatches(edAll.Items[i], Pattern) then begin
      edSelected.Items.Add(edAll.Items[i]);
      edAll.Items.Delete(i);
      if not MultiSelect then
        exit;
    end;
end;

procedure TSelectItems.BeginUpdate;
begin
  edAll.Items.BeginUpdate;
  edSelected.Items.BeginUpdate;
end;

procedure TSelectItems.EndUpdate;
begin
  edAll.Items.EndUpdate;
  edSelected.Items.EndUpdate;
  UpdateButtons;
end;

function TSelectItems.GetAllItems: TStrings;
begin
  Result:= EdAll.Items;
end;

function TSelectItems.GetSelectedItems: TStrings;
begin
  Result:= EdSelected.Items;
end;

procedure TSelectItems.SetSelectedItems(Items: TStrings);
var i, Indx: Integer;
begin
  BtnDeleteAllClick(Self);
  for i:= 0 to Items.Count-1 do begin
    Indx:= AllItems.IndexOf(Items[i]);
    if Indx > -1 then begin
      AllItems.Delete(Indx);
      SelectedItems.Add(Items[i])
    end;
  end;
end;

function TSelectItems.GetMultiSelect: Boolean;
begin
  Result:= EdSelected.MultiSelect;
end;

procedure TSelectItems.SetMultiSelect(const Value: Boolean);
begin
  EdSelected.MultiSelect:= Value;
  EdAll.MultiSelect:= Value;
  UpdateButtons;
end;

procedure TSelectItems.UpdateButtons;
begin
  if MultiSelect then begin
    BtnAdd.Enabled:= EdAll.SelCount > 0;
    BtnAddEx.Enabled:= EdAll.Count > 0;
    BtnAddAll.Enabled:= BtnAddEx.Enabled;

    BtnDelete.Enabled:=  edSelected.SelCount > 0;
    BtnDeleteAll.Enabled:= edSelected.Count > 0;
  end
  else begin
    BtnAdd.Enabled:= (EdAll.ItemIndex > -1) and (edSelected.Count < 1);
    BtnAddEx.Enabled:= (EdAll.Count > 0) and (edSelected.Count < 1);
    BtnAddAll.Enabled:= (EdAll.Count = 1) and (edSelected.Count < 1);;

    BtnDelete.Enabled:=  edSelected.ItemIndex>-1;
    BtnDeleteAll.Enabled:= edSelected.Count > 0;
  end;
end;

procedure TSelectItems.BtnAddClick(Sender: TObject);
begin
  BeginUpdate;
  try
    edAll.MoveSelection(edSelected);
  finally
    EndUpdate;
  end;
end;

procedure TSelectItems.BtnAddExClick(Sender: TObject);
var i: Integer;
    s: string;
    sl: TStringList;
begin
  if InputQuery('Kryteria', 'Wska¿ kryteria (np. 12*,201,202)', s) then begin
    BeginUpdate;
    try
      sl:= TStringList.Create;
      try
        sl.CommaText:= s;
        for i:= 0 to sl.Count-1 do begin
          s:= Trim(sl[i]);
          AddMatchedStrings(s);
        end;
      finally
        sl.Free;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TSelectItems.BtnAddAllClick(Sender: TObject);
begin
  BeginUpdate;
  try
    edSelected.Items.AddStrings(edAll.Items);
    edAll.Clear;
  finally
    EndUpdate;
  end;
end;

procedure TSelectItems.BtnDeleteClick(Sender: TObject);
begin
  BeginUpdate;
  try
    EdSelected.MoveSelection(edAll);
  finally
    EndUpdate;
  end;
end;

procedure TSelectItems.BtnDeleteAllClick(Sender: TObject);
begin
  BeginUpdate;
  try
    edAll.Items.AddStrings(edSelected.Items);
    edSelected.Clear;
  finally
    EndUpdate;
  end;
end;

procedure TSelectItems.edAllClick(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TSelectItems.edSelectedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateButtons;
end;

end.
