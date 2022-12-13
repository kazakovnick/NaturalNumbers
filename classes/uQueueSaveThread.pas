unit uQueueSaveThread;

{
  Поток сохранения данных
}

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Generics.Collections,
  uTypes, uLogFile;

type
  //TODO: имеет смысл убрать запись в поток генерации
  TQueueSaveThread = class(TThread)
  private
    FCSQueue: TCriticalSection;
    FNumQueue: TNumQueue;
  public
    constructor Create(pCSQueue: TCriticalSection; pNumQueue: TNumQueue); overload;
    procedure Execute; override;
  end;

implementation

{ TQueueSaveThread }

constructor TQueueSaveThread.Create(pCSQueue: TCriticalSection; pNumQueue: TNumQueue);
begin
  inherited Create(False);

  FreeOnTerminate := False;
  FCSQueue := pCSQueue;
  FNumQueue := pNumQueue;

  TLogFile.DeleteFullFile;
end;

procedure TQueueSaveThread.Execute;
var
  vNumRec: TNumRec;
begin
  inherited;

  while (not Terminated) do
  begin
    if FNumQueue.Count = 0 then
    begin
      Self.Sleep(100);
      Continue;
    end;

    FCSQueue.Enter;
    try
      vNumRec := FNumQueue.Dequeue;
      TLogFile.AddFromFile(vNumRec.Number, vNumRec.IndexThread);
    finally
      FCSQueue.Leave;
    end;
  end;
end;

end.

