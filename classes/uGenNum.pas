unit uGenNum;

{
  Генератор натуральных чисел
}

interface

type
  TOnMaxReached =
    reference to procedure(pMax, pNumber: integer);

  TGenNum = class(TObject)
  private
    FNaturalNumber, FMaxNaturalNumber: integer;
    FOnMaxReached: TOnMaxReached;
    FLimitat: integer;
    FOnNext: TOnMaxReached;
  private
    function GetPrevious: integer;
    procedure SetLimitat(const pValue: integer);
    procedure DoNext(pMax, pNumber: integer);
    procedure DoMaxReached(pMax, pNumber: integer);
  public
    procedure AfterConstruction; override;

    function GetNext(out pNumber: integer): boolean;

    property NaturalNumber: integer read FNaturalNumber write FNaturalNumber;
    property Limitat: integer read FLimitat write SetLimitat;

    property OnMaxReached: TOnMaxReached read FOnMaxReached write FOnMaxReached;
    property OnNext: TOnMaxReached read FOnNext write FOnNext;
  end;

implementation

uses
  Math;

{ TData }

procedure TGenNum.AfterConstruction;
begin
  inherited;

  NaturalNumber := 0;
  FOnMaxReached := nil;
  FOnNext := nil;
end;

procedure TGenNum.SetLimitat(const pValue: integer);
begin
  FLimitat := pValue;

  FMaxNaturalNumber := GetPrevious;
end;

procedure TGenNum.DoMaxReached(pMax, pNumber: integer);
begin
  if Assigned(OnMaxReached) then
    OnMaxReached(pMax, pNumber);
end;

procedure TGenNum.DoNext(pMax, pNumber: integer);
begin
  if Assigned(OnNext) then
    OnNext(pMax, pNumber);
end;

function TGenNum.GetPrevious: integer;
var
  vNumber, i: integer;
  vFlag: boolean;
begin
  Result := Limitat;
  vNumber := Limitat;

  while (vNumber > 0) do
  begin
    Dec(vNumber);
    if vNumber mod 2 = 0 then
      Continue;

    vFlag := True;
    for i := 3 to Round(Sqrt(vNumber)) do
    begin
      if vNumber mod i = 0 then
      begin
        vFlag := False;
        Break;
      end;
    end;

    if vFlag then
    begin
      Result := vNumber;
      if (vNumber <= Limitat) then
        Exit;
    end;
  end;
end;

function TGenNum.GetNext(out pNumber: integer): boolean;
var
  vNumber, i: integer;
  vFlag: boolean;
begin
  Result := False;
  pNumber := NaturalNumber;
  vNumber := NaturalNumber;

  try
    if ((vNumber = 0) and (Limitat > 2)) or (Limitat = 0) then
    begin
      pNumber := 2;
      Exit(True);
    end;

    while (vNumber <= Limitat) do
    begin
      Inc(vNumber);
      if vNumber mod 2 = 0 then
        Continue;

      vFlag := True;
      for i := 3 to Round(Sqrt(vNumber)) do
      begin
        if vNumber mod i = 0 then
        begin
          vFlag := False;
          Break;
        end;
      end;

      if vFlag then
      begin
        pNumber := vNumber;
        if (vNumber <= Limitat) then
          Exit(True);
      end;
    end;
  finally
    NaturalNumber := pNumber;

    if NaturalNumber >= FMaxNaturalNumber then
      DoMaxReached(Limitat, NaturalNumber)
    else
      DoNext(Limitat, NaturalNumber);
  end;
end;

end.

