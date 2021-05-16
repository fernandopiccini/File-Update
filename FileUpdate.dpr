program FileUpdate;

uses
  Forms,
  UfrmFileUpdate in 'UfrmFileUpdate.pas' {frmFileUpdate};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Alteração de Data de Arquivo - Piccini - 2013';
  Application.CreateForm(TfrmFileUpdate, frmFileUpdate);
  Application.Run;
end.
