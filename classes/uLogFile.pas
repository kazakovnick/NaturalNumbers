unit uLogFile;

{
  Класс работы с файлами
}

interface

uses
  System.SysUtils, Vcl.Forms;

type
  // TODO: имеет смысл сделать буфер соединений, а не открывать/закрывать файлы каждый раз
  TLogFile = class
  public
    class procedure AddFromFile(pNumber, pIndexThread: integer);
    class function GetFullFileName: string;
    class function GetThreadFileName(pIndexThread: integer): string;
    class procedure DeleteFullFile;
    class procedure DeleteFileByIndexThread(pIndexThread: integer);
  end;

implementation

uses
  System.Classes;

{ TLogFile }

class procedure TLogFile.AddFromFile(pNumber, pIndexThread: integer);

  procedure DefDoAdd(pFileName, pMsg: string);
  var
    vFileStream: TFileStream;
    vStrStream: TStringStream;
  begin
    if FileExists(pFileName) then
      vFileStream := TFileStream.Create(pFileName, fmOpenReadWrite, fmShareDenyWrite)
    else
      vFileStream := TFileStream.Create(pFileName, fmCreate, fmShareDenyWrite);
    try
      vFileStream.Position := vFileStream.Size;
      vStrStream := TStringStream.Create(pMsg);
      try
        vStrStream.Seek(0, soFromBeginning);
        vStrStream.SaveToStream(vFileStream);
      finally
        vStrStream.Free;
      end;
    finally
      FreeAndNil(vFileStream);
    end;
  end;

begin
  DefDoAdd(GetFullFileName, IntToStr(pNumber) + ' ');
  DefDoAdd(GetThreadFileName(pIndexThread), IntToStr(pNumber) + ' ');
end;

class procedure TLogFile.DeleteFileByIndexThread(pIndexThread: integer);
begin
  if FileExists(GetThreadFileName(pIndexThread)) then
    DeleteFile(GetThreadFileName(pIndexThread));
end;

class procedure TLogFile.DeleteFullFile;
begin
  if FileExists(GetFullFileName) then
    DeleteFile(GetFullFileName);
end;

class function TLogFile.GetFullFileName: string;
begin
  Result := ExtractFileDir(Application.ExeName) + '\full.txt';
end;

class function TLogFile.GetThreadFileName(pIndexThread: integer): string;
begin
  Result := ExtractFileDir(Application.ExeName) + Format('\Thread%d.txt', [pIndexThread]);
end;

end.
