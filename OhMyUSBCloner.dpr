program OhMyUSBCloner;

uses
  Forms,
  FMain in 'FMain.pas' {TFMain},
  U_Usb in 'U_Usb.pas',
  uDir in 'uDir.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'USB 백업 프로그램';
  Application.CreateForm(TTFMain, TFMain);
//  Application.ShowMainForm := False;
  Application.Run;
end.
