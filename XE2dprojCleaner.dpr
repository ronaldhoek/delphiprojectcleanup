program XE2dprojCleaner;

uses
  Vcl.Forms,
  MainU in 'MainU.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
