unit uThreadGenNum;

{
  Поток генерации данных
}

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Generics.Collections,
  uGenNum, uTypes, uLogFile;

type
  TGenNumberThread = class (TThread)
  private
    FIndexThread: integer;
    FCSAddInQueue: TCriticalSection;
    FNumQueue: TNumQueue;
    FGenNum: TGenNum;
  protected
    procedure AddQueue(pNumber, pIndexThread: integer);
  public
    constructor Create(
      pCSAddInQueue: TCriticalSection;
      pNumQueue: TNumQueue;
      pGenNum: TGenNum;
      pIndexThread: integer); overload;

    procedure Execute; override;
  end;

implementation

{ TBaseThread }

procedure TGenNumberThread.AddQueue(pNumber, pIndexThread: integer);
begin
  FNumQueue.Enqueue(SetNum(pNumber, pIndexThread));
end;

constructor TGenNumberThread.Create(
  pCSAddInQueue: TCriticalSection;
  pNumQueue: TNumQueue;
  pGenNum: TGenNum;
  pIndexThread: integer);
begin
  inherited Create(False);

  FreeOnTerminate := False;
  FCSAddInQueue := pCSAddInQueue;
  FNumQueue := pNumQueue;
  FIndexThread := pIndexThread;
  FGenNum := pGenNum;

  TLogFile.DeleteFileByIndexThread(pIndexThread);
end;

procedure TGenNumberThread.Execute;
var
  vNumber: integer;
begin
  inherited;

  while not Terminated do
  begin
    FCSAddInQueue.Enter;
    try
      if not FGenNum.GetNext(vNumber) then
        Exit;

      AddQueue(vNumber, FIndexThread);
    finally
      FCSAddInQueue.Leave;
    end;
  end;
end;

end.
