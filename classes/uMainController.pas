unit uMainController;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Generics.Collections,
  uThreadGenNum, uGenNum, uTypes, uQueueSaveThread;

type
  TOnAction =
    reference to procedure;

  TMainController = class(TObject)
  private
    FCSQueue: TCriticalSection;
    FCSControls: TCriticalSection;
    FNumQueue: TNumQueue;
    FGenNum: TGenNum;
    FThreadList: TThreadList;
    FOnMaxReached: TOnMaxReached;
    FOnBeforeRun: TOnAction;
    FOnAfterCancel: TOnAction;
    FReachedIndex: integer;
    FLimitat: integer;
    FOnNext: TOnMaxReached;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure Run;
    procedure Cancel;

    property Limitat: integer read FLimitat write FLimitat;

    property OnMaxReached: TOnMaxReached read FOnMaxReached write FOnMaxReached;
    property OnNext: TOnMaxReached read FOnNext write FOnNext;
    property OnBeforeRun: TOnAction read FOnBeforeRun write FOnBeforeRun;
    property OnAfterCancel: TOnAction read FOnAfterCancel write FOnAfterCancel;
  end;

implementation

{ TMainController }

procedure TMainController.AfterConstruction;
begin
  inherited;

  FOnMaxReached := nil;
  FOnBeforeRun := nil;
  FOnAfterCancel := nil;

  FCSQueue := TCriticalSection.Create;
  FCSControls := TCriticalSection.Create;
  FNumQueue := TNumQueue.Create;
  FThreadList := TThreadList.Create;

  FGenNum := TGenNum.Create;
  FGenNum.OnNext :=
    procedure(pMax, pNumber: integer)
    begin
      FCSControls.Enter;
      try
        if Assigned(OnNext) then
          OnNext(pMax, pNumber);
      finally
        FCSControls.Leave;
      end;
    end;
  FGenNum.OnMaxReached :=
    procedure(pMax, pNumber: integer)
    begin
      FCSControls.Enter;
      try
        Inc(FReachedIndex);

        if Assigned(OnMaxReached) and (FReachedIndex = 1) then
          OnMaxReached(pMax, pNumber);
      finally
        FCSControls.Leave;
      end;

      if not Assigned(FThreadList) then
        Exit;

      if FReachedIndex = FThreadList.Count - 2 then
        Self.Cancel;
    end;
end;

procedure TMainController.BeforeDestruction;
begin
  Cancel;

  if Assigned(FCSQueue) then
    FreeAndNil(FCSQueue);

  if Assigned(FCSControls) then
    FreeAndNil(FCSControls);

  if Assigned(FNumQueue) then
    FreeAndNil(FNumQueue);

  if Assigned(FGenNum) then
    FreeAndNil(FGenNum);

  if Assigned(FThreadList) then
    FreeAndNil(FThreadList);

  inherited;
end;

procedure TMainController.Cancel;
begin
  FCSControls.Enter;
  try
    if Assigned(OnAfterCancel) then
      OnAfterCancel;
  finally
    FCSControls.Leave;
  end;
end;

procedure TMainController.Run;
const
  cFirstFile = 1;
  cSecondFile = 2;
begin
  if Assigned(OnBeforeRun) then
    OnBeforeRun;

  FReachedIndex := 0;

  FCSQueue.Enter;
  try
    FGenNum.Limitat := Self.Limitat;
    FGenNum.NaturalNumber := 0;
    FNumQueue.Clear;
  finally
    FCSQueue.Leave;
  end;

  if not Assigned(FThreadList) then
    Exit;

  FThreadList.Clear;

  // Создаем поток сохранения данных
  FThreadList.Add(TQueueSaveThread.Create(FCSQueue, FNumQueue));

  // Создаем потоки генерации данных
  FThreadList.Add(TGenNumberThread.Create(FCSQueue, FNumQueue, FGenNum, cFirstFile));
  FThreadList.Add(TGenNumberThread.Create(FCSQueue, FNumQueue, FGenNum, cSecondFile));
end;

end.
