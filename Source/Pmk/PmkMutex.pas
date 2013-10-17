unit PmkMutex;

interface

uses Windows;


implementation

var
  FPmkMutex: THandle;

procedure CreateInstanceMutex;
begin
  // Ten mutex sygnalizuje, �e kopia Pmk jest uruchomiona.
  // Instalator u�ywa go do stwierdzenia czy mo�e kontynuowa� instalacj�.
  FPmkMutex := CreateMutex(nil, False, 'Pmk1977');

  if (FPmkMutex <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then begin
    // ShowMessage('Program pmk jest ju� uruchomiony');
    // ToDo Nale�a�oby w tym miejscu prze��cza� si� do uruchomionej instancj
  end;
end;

procedure DestroyInstanceMutex;
begin
  if FPmkMutex <> 0 then
    CloseHandle(FPmkMutex);
end;

initialization
  CreateInstanceMutex;

finalization
  DestroyInstanceMutex;

end.
