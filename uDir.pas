unit uDir;

interface

uses
  SysUtils, ShellApi;

type
  TDir=class
    public
      class function FileOperation(Op: Integer; PathFrom, PathTo: String): Boolean;
      class function Delete(const Path: String): Boolean;
      class function Copy(const PathFrom, PathTo: String): Boolean;
      class function Move(const PathFrom, PathTo: String): Boolean;
      class function Rename(const PathFrom, PathTo: String): Boolean;
  end;


implementation

{ TDir }

// 삭제
// _____________________________________________________________________________
class function TDir.Delete(const Path: String): Boolean;
begin
  Result:=FileOperation(FO_DELETE, Path, '');
end;

// 복사
// _____________________________________________________________________________
class function TDir.Copy(const PathFrom, PathTo: String): Boolean;
begin
  Result:=FileOperation(FO_COPY, PathFrom, PathTo);
end;

// 이동
// _____________________________________________________________________________
class function TDir.Move(const PathFrom, PathTo: String): Boolean;
begin
  Result:=FileOperation(FO_MOVE, PathFrom, PathTo);
end;

// 이름바꾸기
// _____________________________________________________________________________
class function TDir.Rename(const PathFrom, PathTo: String): Boolean;
begin
  Result:=FileOperation(FO_RENAME, PathFrom, PathTo);
end;

// File Operation
// _____________________________________________________________________________
class function TDir.FileOperation(Op: Integer; PathFrom, PathTo: String): Boolean;
var FileOpStruct: TShFileOpStruct;
begin
  FileOpStruct.Wnd:=0;
  FileOpStruct.wFunc:=Op;
  FileOpStruct.pFrom:=PChar(ExcludeTrailingPathDelimiter(PathFrom));
  FileOpStruct.pTo:=PChar(ExcludeTrailingPathDelimiter(PathTo));
  FileOpStruct.fFlags:=FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOERRORUI;
  FileOpStruct.lpszProgressTitle:=nil;

  Result:=ShFileOperation(FileOpStruct)=0;
end;

end. 
