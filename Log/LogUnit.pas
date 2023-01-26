unit LogUnit;

interface

const otladka=0;

type
 TLogEvent = procedure(Sender: TObject; Msg: string) of object;

 TLoggerWrite = procedure(Sender: TObject; const AMsg : string; const AParam : string = '') of object;

 TLogger = class(TObject)
 private
    FLogWriteEvent:   TLoggerWrite;
 protected
    procedure DoOnLoggerWrite(const AMsg : string; const AParam : string = ''); dynamic;
 public
    property OnLogWrite: TLoggerWrite read FLogWriteEvent write FLogWriteEvent;
    procedure Write(const AMsg : string; const AParam : string = ''); // GenericLogEvent
 end;

procedure Log(const AMsg : string; const AParam : string = '');

implementation

uses
  Winapi.Windows  // GetCurrentThreadID
  ,System.SysUtils
//  ,System.Classes
  ,SyncObjs; // TCriticalSection

var LogName : string;
   cs : TCriticalSection = nil;


procedure TLogger.DoOnLoggerWrite(const AMsg : string; const AParam : string = '');
begin
  if Assigned(FLogWriteEvent) then FLogWriteEvent(Self, AMsg, AParam);
end;

procedure TLogger.Write;
var
 F: Text;
 Msg: string;

begin
 try
  cs.Enter;
  Assign(F,LogName);
  if FileExists(LogName) then Append(F) else Rewrite(F);
  Msg := FormatDateTime('dd.mm.yyyy hh:mm:ss',Now)+' '+AMsg+#9+AParam;
  Writeln(F,FormatDateTime('dd.mm.yyyy hh:mm:ss',Now),#9,GetCurrentThreadID,#9,AMsg,#9,AParam);
  Flush(F); //24.08.2018
 finally
  Close(F);
  cs.Leave;
 end;

  DoOnLoggerWrite(Msg);
end;

procedure Log(const AMsg : string; const AParam : string = '');
var
 F:Text;

begin
 try
  cs.Enter;
  Assign(F,LogName);
  if FileExists(LogName) then Append(F) else Rewrite(F);
  Writeln(F,FormatDateTime('dd.mm.yyyy hh:mm:ss',Now),#9,GetCurrentThreadID,#9,AMsg,#9,AParam);
  Flush(F); //24.08.2018
 finally
  Close(F);
  cs.Leave;
 end;

end;

initialization
 cs := TCriticalSection.Create;
 LogName := ChangeFileExt(Trim(ParamStr(0)),'.log');

finalization
 cs.Free;

end.
