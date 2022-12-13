program TestProj;

uses
  Vcl.Forms,
  System.SyncObjs,
  uMain in 'forms\uMain.pas' {FormMain},
  uThreadGenNum in 'classes\uThreadGenNum.pas',
  uGenNum in 'classes\uGenNum.pas',
  uQueueSaveThread in 'classes\uQueueSaveThread.pas',
  uTypes in 'classes\uTypes.pas',
  uLogFile in 'classes\uLogFile.pas',
  uMainController in 'classes\uMainController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
