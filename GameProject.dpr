program GameProject;

uses
  Vcl.Forms,
  MenuUnit in 'MenuUnit.pas' {MenuForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  StopUnit in 'StopUnit.pas' {StopForm},
  ParamsUnit in 'ParamsUnit.pas',
  ExitWSaveUnit in 'ExitWSaveUnit.pas' {ExitWSaveForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMenuForm, MenuForm);
  Application.Run;
end.
