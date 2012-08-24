unit U_USB;
interface 
uses Windows, Messages, SysUtils, Classes, Registry, Masks; 

type 
  { Event Types } 
  TOnUsbChangeEvent = procedure(AObject : TObject;
                                const ADevType,ADriverName, 
                                      AFriendlyName, ATargetPath : string) of object;

  { USB Class } 
  TUsbClass = class(TObject)
  private 
    FHandle : HWND; 
    FOnUsbRemoval, 
    FOnUsbInsertion : TOnUsbChangeEvent;
    procedure GetUsbInfo(const ADeviceString : string; 
                         out ADevType,ADriverDesc, 
                            AFriendlyName : string); 
    procedure WinMethod(var AMessage : TMessage); 
    procedure RegisterUsbHandler; 
    procedure WMDeviceChange(var AMessage : TMessage); 
  public 
    constructor Create; 
    destructor Destroy; override; 
    property OnUsbInsertion : TOnUsbChangeEvent read FOnUsbInsertion
                                           write FOnUsbInsertion; 
    property OnUsbRemoval : TOnUsbChangeEvent read FOnUsbRemoval 
                                         write FOnUsbRemoval; 
  end; 
  function Get_Drive(unitmask: Cardinal): string;


// ----------------------------------------------------------------------------- 
implementation 

type 
  // Win API Definitions 

    PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;
    DEV_BROADCAST_HDR = packed record 
      dbch_size: DWORD; 
      dbch_devicetype: DWORD; 
      dbch_reserved: DWORD; 
    end;

  PDevBroadcastDeviceInterface  = ^DEV_BROADCAST_DEVICEINTERFACE;
  DEV_BROADCAST_DEVICEINTERFACE = record 
    dbcc_size : DWORD; 
    dbcc_devicetype : DWORD;
    dbcc_reserved : DWORD; 
    dbcc_classguid : TGUID; 
    dbcc_name : char; 
  end; 

  // http://msdn.microsoft.com/en-us/library/aa363249(v=VS.85).aspx
  PDEV_BROADCAST_VOLUME = ^DEV_BROADCAST_VOLUME;
  DEV_BROADCAST_VOLUME = record
  dbcv_size : DWORD;
  dbcv_devicetype : DWORD;
  dbcv_reserved : DWORD;
  dbcv_unitmask : DWORD;
  dbcv_flags : WORD;
  end;


const 
  // Miscellaneous 
  GUID_DEVINTF_USB_DEVICE : TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
//  USB_INTERFACE                = $00000005; // Device interface class

// http://msdn.microsoft.com/en-us/library/aa363246(VS.85).aspx
  DBT_DEVTYP_DEVICEINTERFACE   = $00000005; // Device interface class
  DBT_DEVTYP_HANDLE            = $00000006;
  DBT_DEVTYP_OEM               = $00000000;
  DBT_DEVTYP_PORT              = $00000003;
  DBT_DEVTYP_VOLUME            = $00000002;


  USB_INSERTION                = $8000;     // System detected a new device
  USB_REMOVAL                  = $8004;     // Device is gone

  DBTF_Media               = $0001;

  // Registry Keys 
  USBKEY  = 'SYSTEM\CurrentControlSet\Enum\USB\%s\%s'; 
  USBSTORKEY = 'SYSTEM\CurrentControlSet\Enum\USBSTOR'; 
  SUBKEY1  = USBSTORKEY + '\%s'; 
  SUBKEY2  = SUBKEY1 + '\%s'; 


constructor TUsbClass.Create; 
begin 
  inherited Create; 
  FHandle := AllocateHWnd(WinMethod); 
  RegisterUsbHandler; 
end; 


destructor TUsbClass.Destroy; 
begin 
  DeallocateHWnd(FHandle); 
  inherited Destroy; 
end; 


procedure TUsbClass.GetUsbInfo(const ADeviceString : string; 
                               out ADevType,ADriverDesc, 
                                   AFriendlyName : string); 
var sWork,sKey1,sKey2 : string; 
    oKeys,oSubKeys : TStringList; 
    oReg : TRegistry; 
    i,ii : integer; 
    bFound : boolean; 
begin 
  ADevType := ''; 
  ADriverDesc := ''; 
  AFriendlyName := ''; 

  if ADeviceString <> '' then begin 
    bFound := false; 
    oReg := TRegistry.Create; 
    oReg.RootKey := HKEY_LOCAL_MACHINE; 

    // Extract the portions of the string we need for registry. eg. 
    // \\?\USB#Vid_4146&Pid_d2b5#0005050400044#{a5dcbf10- ..... -54334fb951ed} 
    // We need sKey1='Vid_4146&Pid_d2b5' and sKey2='0005050400044' 
    sWork := copy(ADeviceString,pos('#',ADeviceString) + 1,1026); 
    sKey1 := copy(sWork,1,pos('#',sWork) - 1); 
    sWork := copy(sWork,pos('#',sWork) + 1,1026); 
    sKey2 := copy(sWork,1,pos('#',sWork) - 1); 

    // Get the Device type description from \USB key 
    if oReg.OpenKeyReadOnly(Format(USBKEY,[skey1,sKey2])) then begin 
      ADevType := oReg.ReadString('DeviceDesc');
      oReg.CloseKey;
      oKeys := TStringList.Create;
      oSubKeys := TStringList.Create;

      // Get list of keys in \USBSTOR and enumerate each key 
      // for a key that matches our sKey2='0005050400044' 
      // NOTE : The entry we are looking for normally has '&0' 
      // appended to it eg. '0005050400044&0' 
      if oReg.OpenKeyReadOnly(USBSTORKEY) then begin 
        oReg.GetKeyNames(oKeys); 
        oReg.CloseKey; 

        // Iterate through list to find our sKey2 
        for i := 0 to oKeys.Count - 1 do begin 
          if oReg.OpenKeyReadOnly(Format(SUBKEY1,[oKeys[i]])) then begin 
            oReg.GetKeyNames(oSubKeys); 
            oReg.CloseKey; 

            for ii := 0 to oSubKeys.Count - 1 do begin 
              if MatchesMask(oSubKeys[ii],sKey2 + '*') then begin 
                // Got a match?, get the actual desc and friendly name 
                if oReg.OpenKeyReadOnly(Format(SUBKEY2,[oKeys[i], 
                                        oSubKeys[ii]])) then begin 
                  ADriverDesc := oReg.ReadString('DeviceDesc'); 
                  AFriendlyName := oReg.ReadString('FriendlyName'); 
                  oReg.CloseKey; 
                end; 

                bFound := true; 
              end; 
            end; 
          end; 

          if bFound then break; 
        end; 
      end; 

      FreeAndNil(oKeys); 
      FreeAndNil(oSubKeys); 
    end; 

    FreeAndNil(oReg); 
  end; 
end; 


procedure TUsbClass.WMDeviceChange(var AMessage : TMessage); 
var iDevType : integer; 
    sDevString,sDevType, 
    sDriverName,sFriendlyName, sTargetPath : string;
    pData : PDevBroadcastDeviceInterface;
begin 
  if (AMessage.wParam = USB_INSERTION) or 
     (AMessage.wParam = USB_REMOVAL) then begin
    pData := PDevBroadcastDeviceInterface(AMessage.LParam);
    iDevType := pData^.dbcc_devicetype;

    // Is it a USB Interface Device ?
    if iDevType = DBT_DEVTYP_DEVICEINTERFACE then begin
      sDevString := PChar(@pData^.dbcc_name);
      GetUsbInfo(sDevString,sDevType,sDriverName,sFriendlyName);

      // Trigger Events if assigned
      if (AMessage.wParam = USB_INSERTION) and
        Assigned(FOnUsbInsertion) then
      begin
//        FOnUsbInsertion(self,sDevType,sDriverName,sFriendlyName, sTargetPath);
      end;

      if (AMessage.wParam = USB_REMOVAL) and
        Assigned(FOnUsbRemoval) then
      begin
//        FOnUsbRemoval(self,sDevType,sDriverName,sFriendlyName, sTargetPath);
      end;
    end
    // Is it a Storage Volume?
    else if iDevType = DBT_DEVTYP_VOLUME then
    begin
      sDevString := PChar(@pData^.dbcc_name);
      GetUsbInfo(sDevString,sDevType,sDriverName,sFriendlyName);
      sTargetPath := Get_Drive(PDEV_BROADCAST_VOLUME(AMessage.LParam)^.dbcv_unitmask);
      // Trigger Events if assigned
      if (AMessage.wParam = USB_INSERTION) and
        Assigned(FOnUsbInsertion) then
      begin
        FOnUsbInsertion(self,sDevType,sDriverName,sFriendlyName, sTargetPath);
      end;

      if (AMessage.wParam = USB_REMOVAL) and
        Assigned(FOnUsbRemoval) then
      begin
        FOnUsbRemoval(self,sDevType,sDriverName,sFriendlyName, sTargetPath);
      end;

    end;


  end;
end;



procedure TUsbClass.WinMethod(var AMessage : TMessage);
begin
  if (AMessage.Msg = WM_DEVICECHANGE) then 
    WMDeviceChange(AMessage) 
  else 
    AMessage.Result := DefWindowProc(FHandle,AMessage.Msg, 
                                     AMessage.wParam,AMessage.lParam); 
end; 


procedure TUsbClass.RegisterUsbHandler; 
var rDbi : DEV_BROADCAST_DEVICEINTERFACE; 
    iSize : integer; 
begin 
  iSize := SizeOf(DEV_BROADCAST_DEVICEINTERFACE); 
  ZeroMemory(@rDbi,iSize); 
  rDbi.dbcc_size := iSize; 
  rDbi.dbcc_devicetype := DBT_DEVTYP_DEVICEINTERFACE;
  rDbi.dbcc_reserved := 0; 
  rDbi.dbcc_classguid  := GUID_DEVINTF_USB_DEVICE; 
  rDbi.dbcc_name := #0; 
  RegisterDeviceNotification(FHandle,@rDbi,DEVICE_NOTIFY_WINDOW_HANDLE); 
end; 



function Get_Drive(unitmask: Cardinal): string;
var
  i: Integer;
begin
  for i:= 0 to 25 do
  begin
    if (unitmask and 1)= 1 then
    begin
      Result:= Chr($61+ i);

      Exit;
    end;

    unitmask:= unitmask shr 1;
  end;

  Result:= '';
end;
end.

