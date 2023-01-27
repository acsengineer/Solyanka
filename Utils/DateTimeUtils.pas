unit DateTimeUtils;

interface

uses DateUtils, WinApi.Windows, System.SysUtils;

function TruncToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
function RoundToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
function FileTimeToDateTime(FileTime: TFileTime; UTC: boolean=False): TDateTime;
function fCurrentYear( dt1, dt2: TDateTime; var sh: string):boolean; overload;
function fCurrentYear( dt1: TDateTime; var sh:string):boolean; overload;

implementation


function TruncToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
begin
  if 0=TheRoundStep
  then TruncToNearest:=TheDateTime
  else TruncToNearest:=Trunc(TheDateTime/TheRoundStep)*TheRoundStep;
end;


function RoundToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
begin
  if 0=TheRoundStep
  then RoundToNearest:=TheDateTime
  else RoundToNearest:=Round(TheDateTime/TheRoundStep)*TheRoundStep;
end;


function FileTimeToDateTime(FileTime: TFileTime; UTC: boolean=False): TDateTime;
 var
   ModifiedTime: TFileTime;
   SystemTime: TSystemTime;
 begin
   Result := 0;
   if (FileTime.dwLowDateTime = 0) and (FileTime.dwHighDateTime = 0) then
     Exit;
   try
    ModifiedTime := FileTime;                                         //Local
    If (UTC) then FileTimeToLocalFileTime(FileTime, ModifiedTime);    //UTC
    FileTimeToSystemTime(ModifiedTime, SystemTime);
    Result := SystemTimeToDateTime(SystemTime);
   except
    Result := Now;  // Something to return in case of error
  end;
 end;


function fCurrentYear( dt1, dt2: TDateTime; var sh: string):boolean; overload;
var
st1, st2: TSystemTime;
begin
sh := '';
Result:=False;
DateTimeToSystemTime(dt2, st2);
DateTimeToSystemTime(dt1, st1);
if (st2.wYear=st1.wYear) then
  begin
    Result:=true;
    sh := IntToStr(st1.wYear);
  end;
end;


function fCurrentYear( dt1: TDateTime; var sh:string):boolean; overload;
var
dt2 : TDateTime;
begin
dt2:=Now;
Result:= fCurrentYear(dt1,dt2,sh);
end;


end.
