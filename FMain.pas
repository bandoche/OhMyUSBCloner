unit FMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, U_Usb, RXShell, Menus, ShlObj, uDir, PNGImage;


type
  TTFMain = class(TForm)
    lstConsole: TListBox;
    rxtMain: TRxTrayIcon;
    pmuMain: TPopupMenu;
    pmuAbout: TMenuItem;
    N1: TMenuItem;
    pmuExit: TMenuItem;
    Button1: TButton;
    FileList: TListBox;
    EditStartDir: TEdit;
    EditFileMask: TEdit;
    ListBox1: TListBox;
    LabelCount: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmuExitClick(Sender: TObject);
    procedure pmuAboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
     FUsb : TUsbClass;
    function GetFileVersion(const FileName: TFileName; var Major, Minor, Release, Build: word): boolean;
    procedure WriteLog(strMessage: String);
    procedure UsbIN(ASender : TObject; const ADevType,ADriverName,
                     AFriendlyName, ATargetPath : string);
    procedure UsbOUT(ASender : TObject; const ADevType,ADriverName,
                     AFriendlyName, ATargetPath : string);

  public
    { Public declarations }
  TargetDirectory: String;
  TargetDirectoryBase: String;
  flagExit: Boolean;

  end;


  procedure WriteLogFile(strMessage:String; strPathBase:String);

const
  FORCE_TARGET_DIR = 'C:\';


var
  TFMain: TTFMain;

implementation

{$R *.dfm}


procedure TTFMain.WriteLog(strMessage: String);
begin
//  lstConsole.Items.Add('[' + FormatDateTime('YYYY-MM-DD HH:NN:SS', Now) + '] ' + strMessage);
  WriteLogFile(strMessage, TargetDirectoryBase);
end;


procedure TTFMain.FormCreate(Sender: TObject);
var
  RealPath: Array[0..MAX_PATH] of Char;
  Success:Bool;
  PIDl: PItemIDList;
  hRes: HRESULT;
begin
  try
    FUsb:= TUsbClass.Create;
    FUsb.OnUsbInsertion := UsbIN;
    FUsb.OnUsbRemoval := UsbOUT;

    flagExit := False;

    hRes := SHGetSpecialFolderLocation(Self.Handle, CSIDL_PERSONAL, PIDL);

    if hRes = NO_ERROR then
    begin
      Success := SHGetPathFromIDList(PIDl, RealPath);
      if Success then
        TargetDirectoryBase := String(RealPath)
      else
        TargetDirectoryBase := FORCE_TARGET_DIR;
    end
    else
    begin
      TargetDirectoryBase := FORCE_TARGET_DIR;
    end;

    if Copy(TargetDirectoryBase, Length(TargetDirectoryBase), 1) <> '\' then
      TargetDirectoryBase := TargetDirectoryBase + '\';

    TargetDirectoryBase := TargetDirectoryBase + 'OhMyUSBCloner\';


    WriteLog('기본 저장 경로 : ' + TargetDirectoryBase);
  except
    On E: Exception do
      WriteLog('Exception : TTFMain.FormCreate<'+E.Message+'>');
  end;
end;



procedure TTFMain.UsbIN(ASender : TObject; const ADevType, ADriverName, AFriendlyName, ATargetPath : string);
var
  ODir: TDir;
  iResult : Boolean;
begin
{
  showmessage('USB Inserted - Device Type = ' + ADevType + #13#10 +
               'Driver Name = ' + ADriverName + #13+#10 +
               'Friendly Name = ' + AFriendlyName + #13 + #10 +
               'Target Path = ' + ATargetPath);
}
//  if Copy(TargetDirectoryBase, Length(TargetDirectoryBase), 1) <> '\' then
//    TargetDirectoryBase := TargetDirectoryBase + '\';


  try
    try
      ODir := TDir.Create;


      TargetDirectory := TargetDirectoryBase + FormatDateTime('yyyymmddhhnnss', Now) + '\';


      //디렉토리 없으면 디렉토리 생성해 준다.
      if Not DirectoryExists(TargetDirectory) Then
      begin
        ForceDirectories(TargetDirectory);
      end;

      WriteLog('USB Inserted - Device Type = ' + ADevType + ' / ' +
                   'Driver Name = ' + ADriverName +  ' / ' +
                   'Friendly Name = ' + AFriendlyName +  ' / ' +
                   'Target Path = ' + ATargetPath);
      WriteLog('Copy file(s) from ''' + ATargetPath + ':\'' to ''' + TargetDirectory + '''');

      iResult := ODir.Copy(String(ATargetPath + ':\*.*' + #00), TargetDirectory + #00);
      WriteLog('Result = ' + BoolToStr(iResult, True));
    finally
      FreeAndNil(ODir);
    end;
  except
    On E: Exception do
      WriteLog('Exception : TTFMain.UsbIN<'+E.Message+'>');
  end;
end;


procedure TTFMain.UsbOUT(ASender : TObject; const ADevType,ADriverName,
                         AFriendlyName, ATargetPath : string);
begin
{
   showmessage('USB Removed - Device Type = ' + ADevType + #13#10 +
               'Driver Name = ' + ADriverName + #13+#10 +
               'Friendly Name = ' + AFriendlyName + #13 + #10 +
               'Target Path = ' + ATargetPath);
}
  try
    WriteLog('USB Removedz - Device Type = ' + ADevType + ' / ' +
                   'Driver Name = ' + ADriverName +  ' / ' +
                   'Friendly Name = ' + AFriendlyName +  ' / ' +
                   'Target Path = ' + ATargetPath);

  except
    On E: Exception do
      WriteLog('Exception : TTFMain.UsbOUT<'+E.Message+'>');
  end;


end;



procedure TTFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    FreeAndNil(FUsb);
  except
    On E: Exception do
      WriteLog('Exception : TTFMain.FormClose<'+E.Message+'>');
  end;
end;

procedure TTFMain.pmuExitClick(Sender: TObject);
begin
  try
    WriteLog('pmuExitClick Event');
    flagExit := True;
    Close;
  except
    On E: Exception do
      WriteLog('Exception : TTFMain.pmuExitClick<'+E.Message+'>');
  end;
end;



procedure TTFMain.pmuAboutClick(Sender: TObject);
var
  Major, Minor, Release, Build: word;
  strMessage:String;
begin
  try
    if GetFileVersion(Application.ExeName,Major, Minor, Release, Build) then
    begin
      strMessage := 'OhMyUSBCloner ' + IntTostr(Major) + '.' + IntToStr(Minor) + '.' + IntToStr(Release) + '.' + IntToStr(Build);
    end
    else
    begin
      strMessage := 'OhMyUSBCloner';
    end;

    strMessage := strMessage + #10 + #13 + 'e-mail : bandoche@hanmail.net';
    strMessage := strMessage + #10 + #13 + 'website : blog.bandoche.com';
    MessageBox(Handle,  PChar(strMessage), 'OhMyUSBCloner',MB_ICONINFORMATION + MB_OK);

  except
    On E: Exception do
      WriteLog('Exception : TTFMain.pmuExitClick<'+E.Message+'>');
  end;
end;

procedure TTFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := flagExit;
  if not flagExit then
  begin
    Hide;
  end;
end;

procedure WriteLogFile(strMessage:String; strPathBase:String);
var
  OFileStream : TFileStream;
  DirPath     : String;

  StrMon: String;
  StrDay: String;
  StrTime: String;
  StrPath: String;
  StrVal: String;
begin
  try
    try
      //해당 월 구하기
      StrMon  := FormatDateTime('yyyymm', Now);
      StrDay  := FormatDateTime('yyyymmdd', Now);
      StrTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
      StrPath := strPathBase + '\' + FormatDateTime('YYYYMMDD', Now) +'.log';

      if Copy(strPathBase, Length(strPathBase), 1) <> '\' then
        strPathBase := strPathBase + '\';

      //넘어온 문자열 형식에 맞춰서 넘겨주기
      StrVal  := '['+StrTime+'] ' + strMessage;

      //디렉토리 없으면 디렉토리 생성해 준다.
      if Not DirectoryExists(strPathBase) Then
      begin
        ForceDirectories(strPathBase);
      end;

      if FileExists(StrPath) Then
        OFileStream := TFileStream.Create(StrPath, fmOpenWrite)
      else
        OFileStream := TFileStream.Create(StrPath, fmCreate);

        OFileStream.Seek(OFileStream.Size, soBeginning);
        OFileStream.WriteBuffer(PChar(StrVal)^, Length(StrVal));
        OFileStream.WriteBuffer(PChar(#13#10)^, Length(#13#10));


    finally
        OFileStream.Free;
    end;
  except
    On E: Exception do
;
  end;
end;


{
	설명      : 파일 버전 가져오는 함수
	작성자		: 정상준(bandoche@tapi.co.kr)
	작성일		: 2010-04-29
}
function TTFMain.GetFileVersion(const FileName: TFileName;
   var Major, Minor, Release, Build: word): boolean;
// Returns True on success and False on failure.
var
  size, len: longword;
  handle: THandle;
  buffer: pchar;
  pinfo: ^VS_FIXEDFILEINFO;
begin
  Result := False;
  try
    size := GetFileVersionInfoSize(Pointer(FileName), handle);
    if size > 0 then begin 
      GetMem(buffer, size); 
      if GetFileVersionInfo(Pointer(FileName), 0, size, buffer) 
      then 
        if VerQueryValue(buffer, '\', pointer(pinfo), len) then begin 
          Major   := HiWord(pinfo.dwFileVersionMS);
          Minor   := LoWord(pinfo.dwFileVersionMS); 
          Release := HiWord(pinfo.dwFileVersionLS); 
          Build   := LoWord(pinfo.dwFileVersionLS); 
          Result  := True; 
        end; 
      FreeMem(buffer);
    end;
  except
    On E:Exception do
      WriteLog('Exception : TTFMain.GetFileVersion<'+E.Message+'>');
  end;
end;

// Recursive procedure to build a list of files
procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound :=
    FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;
end;

// Example: how to use FindFiles
//procedure TForm1.ButtonFindClick(Sender: TObject);
//var
//  FilesList: TStringList;
//begin
//  FilesList := TStringList.Create;
//  try
//    FindFiles(FilesList, EditStartDir.Text, EditFileMask.Text);
//    ListBox1.Items.Assign(FilesList);
//    LabelCount.Caption := 'Files found: ' + IntToStr(FilesList.Count);
//  finally
//    FilesList.Free;
//  end;
//end;

procedure TTFMain.Button1Click(Sender: TObject);
var
  FilesList: TStringList;
begin
  FilesList := TStringList.Create;
  try
    FindFiles(FilesList, EditStartDir.Text, EditFileMask.Text);
    ListBox1.Items.Assign(FilesList);
    LabelCount.Caption := 'Files found: ' + IntToStr(FilesList.Count);
  finally
    FilesList.Free;
  end;
end;

end.
