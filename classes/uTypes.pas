unit uTypes;

interface

uses
  System.Generics.Collections, System.Classes;

type
  TNumRec = record
    Number, IndexThread: integer;
  end;
  TNumQueue = TQueue<TNumRec>;

  TThreadList = TObjectList<TThread>;

function SetNum(pNumber, pIndexThread: integer): TNumRec;

implementation

function SetNum(pNumber, pIndexThread: integer): TNumRec;
begin
  Result.Number := pNumber;
  Result.IndexThread := pIndexThread;
end;

end.
