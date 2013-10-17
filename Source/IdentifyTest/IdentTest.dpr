program IdentTest;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FmMain},
  GeoGenerators in '..\..\..\..\Units\GeoUnits\GeoGenerators.pas',
  GeoMovements in '..\..\..\..\Units\GeoUnits\GeoMovements.pas',
  FrmIdentifyResults in '..\pmk\FrmIdentifyResults.pas' {FmIdentifyResults},
  TestForm in 'TestForm.pas' {FmTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFmMain, FmMain);
  Application.Run;
end.
