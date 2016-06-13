//           www.freehand.com.ua
//           2011-08-08

unit freehand;

{
Данный модуль в своем большинстве взят из проекта Андрея Рубина немного окультурен
}



interface

uses
  Classes,Windows, SysUtils,DateUtils,Controls,Messages,shellapi,dialogs;





const
  Crc32Polynomial : DWord = $EDB88320;
var
  CRC32Table: array [Byte] of DWord;
  function TailPos(const S, SubStr: AnsiString; fromPos: integer): integer;
  function IsFileInUse(FileName: TFileName): Boolean;
  function UnixToDateTime(USec: Longint): TDateTime;
  function DateTimeToUnix(ConvDate: TDateTime): Longint;
  Function StrToBool(bool:string):boolean;
  Function ParseCookies(cookies,name:string):string;
  Function ParseParams(params,prm:string):string;
  Procedure RunCaptured(const _exeName, _cmdLine: string;resultout:TStringList);
  function DigitToHex(Digit: Integer): Char;
  function URLDecode(const S: string): string;
  function URLEncode(const S: string): string;
  Function ReversInt(int:cardinal):cardinal;
  function DECtoHEX(DEC: LONGINT): Ansistring;
  function StrToHEX(text: Ansistring): Ansistring;
  function decToHex1(value: dword): ansistring;
  function HexToDec(Str : Ansistring): integer;
  function HexToStr(Str : Ansistring): Ansistring;
  function GetFileDateTime(FileName: string): TDateTime;
  function ChackFileName(const FileName: string): boolean;
  Function GetWavTitle(filename:string):string;
  function GetFileSize(namefile: string): Integer;
  Function Chack(querty:string):string;
  Function ReplaceSub(str, sub1, sub2: string):string;
  Function SecondToTime(Seconds: integer): TTime;
  Function MSecondToTime(MSeconds: integer): TTime;
  Function TimeToSecond(time:TTime): cardinal;
  Function IsTime(time:string): boolean;
  Function StringToDate(date:string): TDateTime;
  function DateToInt(x: string;mask:string) : integer;
  procedure MakeRounded(Control: TWinControl;p5,p6:integer);
  procedure FormToTrayPos(Control: TWinControl);
  function RunProgram(const FileName, Params: string; WindowState: Word): Boolean;
  Function FrameToTime(count,oneframe: integer): TTime;
  Function DateTimetoHFS(dt:TDatetime):cardinal;
  function DecodeBase64(const CinLine: string): string;
  function EncodeBase64(const inStr: string): string;
  function bintodec(bin: string): Longint;
  function DecToBin(d: Longint): string;
  function DecToBin1(Value: Longint; Digits: Integer): string;
  function SwapLong(Value: Cardinal): Cardinal; overload;
  function TimeToFrame(time:TTime; framepersec:cardinal) : cardinal;
implementation

function TailPos(const S, SubStr: AnsiString; fromPos: integer): integer;
asm
        PUSH EDI
        PUSH ESI
        PUSH EBX
        PUSH EAX
        OR EAX,EAX
        JE @@2
        OR EDX,EDX
        JE @@2
        DEC ECX
        JS @@2

        MOV EBX,[EAX-4]
        SUB EBX,ECX
        JLE @@2
        SUB EBX,[EDX-4]
        JL @@2
        INC EBX

        ADD EAX,ECX
        MOV ECX,EBX
        MOV EBX,[EDX-4]
        DEC EBX
        MOV EDI,EAX
@@1: MOV ESI,EDX
        LODSB
        REPNE SCASB
        JNE @@2
        MOV EAX,ECX
        PUSH EDI
        MOV ECX,EBX
        REPE CMPSB
        POP EDI
        MOV ECX,EAX
        JNE @@1
        LEA EAX,[EDI-1]
        POP EDX
        SUB EAX,EDX
        INC EAX
        JMP @@3
@@2: POP EAX
        XOR EAX,EAX
@@3: POP EBX
        POP ESI
        POP EDI
end;



function SwapLong(Value: Cardinal): Cardinal; overload;
asm
              BSWAP EAX
end;

function DecToBin1(Value: Longint; Digits: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := Digits downto 0 do
    if Value and (1 shl i) <> 0 then
      Result := Result + '1'
  else
    Result := Result + '0';
end;

function DecToBin(d: Longint): string;
var
  x, p: Integer;
  bin: string;
begin
  bin := '';
  for x := 1 to 8 * SizeOf(d) do
  begin
    if Odd(d) then bin := '1' + bin
    else
      bin := '0' + bin;
    d := d shr 1;
  end;
  Delete(bin, 1, 8 * ((Pos('1', bin) - 1) div 8));
  Result := bin;
end;

function bintodec(bin: string): Longint;
var
j,g: longint;
error: boolean;
dec: cardinal;
begin
dec := 0;
error := false;
g:=length(bin);
for j := 1 to length(bin) do
begin
if (bin[j] <> '0') and (bin[j] <> '1') then
error := true;
if bin[j] = '1' then
dec := dec + (1 shl (length(bin) - j));
end;
if error then
result := 0
else
result := dec;
end;

function EncodeBase64(const inStr: string): string;

  function Encode_Byte(b: Byte): ansichar;
  const
    Base64Code: string[64] =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  begin
    Result := Base64Code[(b and $3F)+1];
  end;

var
  i: Integer;
begin
  i := 1;
  Result := '';
  while i <=Length(InStr) do
  begin
    Result := Result + Encode_Byte(Byte(inStr[i]) shr 2);
    Result := Result + Encode_Byte((Byte(inStr[i]) shl 4) or (Byte(inStr[i+1]) shr 4));
    if i+1 <=Length(inStr) then
      Result := Result + Encode_Byte((Byte(inStr[i+1]) shl 2) or (Byte(inStr[i+2]) shr 6))
    else
      Result := Result + '=';
    if i+2 <=Length(inStr) then
      Result := Result + Encode_Byte(Byte(inStr[i+2]))
    else
      Result := Result + '=';
    Inc(i, 3);
  end;
end;

function DecodeBase64(const CinLine: string): string;
const
  RESULT_ERROR = -2;
var
  inLineIndex: Integer;
  c: Char;
  x: SmallInt;
  c4: Word;
  StoredC4: array[0..3] of SmallInt;
  InLineLength: Integer;
begin
  Result := '';
  inLineIndex := 1;
  c4 := 0;
  InLineLength := Length(CinLine);

  while inLineIndex <=InLineLength do
  begin
    while (inLineIndex <=InLineLength) and (c4 < 4) do
    begin
      c := CinLine[inLineIndex];
      case c of
        '+'     : x := 62;
        '/'     : x := 63;
        '0'..'9': x := Ord(c) - (Ord('0')-52);
        '='     : x := -1;
        'A'..'Z': x := Ord(c) - Ord('A');
        'a'..'z': x := Ord(c) - (Ord('a')-26);
      else
        x := RESULT_ERROR;
      end;
      if x <> RESULT_ERROR then
      begin
        StoredC4[c4] := x;
        Inc(c4);
      end;
      Inc(inLineIndex);
    end;

    if c4 = 4 then
    begin
      c4 := 0;
      Result := Result + ansiChar((StoredC4[0] shl 2) or (StoredC4[1] shr 4));
      if StoredC4[2] = -1 then Exit;
      Result := Result + ansiChar((StoredC4[1] shl 4) or (StoredC4[2] shr 2));
      if StoredC4[3] = -1 then Exit;
      Result := Result + ansiChar((StoredC4[2] shl 6) or (StoredC4[3]));
    end;
  end;
end;


function DigitToHex(Digit: Integer): Char;
begin
  case Digit of
    0..9: Result := Chr(Digit + Ord('0'));
    10..15: Result := Chr(Digit - 10 + Ord('A'));
  else
    Result := '0';
  end;
end; // DigitToHex

function URLEncode(const S: string): string;
  var
    i, idx, len: Integer;
begin
  len := 0;
  for i := 1 to Length(S) do
    if ((S[i] >= '0') and (S[i] <= '9')) or
    ((S[i] >= 'A') and (S[i] <= 'Z')) or
    ((S[i] >= 'a') and (S[i] <= 'z')) or (S[i] = ' ') or
    (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.') then
      len := len + 1
    else
      len := len + 3;
  SetLength(Result, len);
  idx := 1;
  for i := 1 to Length(S) do
    if S[i] = ' ' then
    begin
      Result[idx] := '+';
      idx := idx + 1;
    end
    else if ((S[i] >= '0') and (S[i] <= '9')) or
    ((S[i] >= 'A') and (S[i] <= 'Z')) or
    ((S[i] >= 'a') and (S[i] <= 'z')) or
    (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.') then
    begin
      Result[idx] := S[i];
      idx := idx + 1;
    end
    else
    begin
      Result[idx] := '%';
      Result[idx + 1] := DigitToHex(Ord(S[i]) div 16);
      Result[idx + 2] := DigitToHex(Ord(S[i]) mod 16);
      idx := idx + 3;
    end;
end; // URLEncode

function URLDecode(const S: string): string;
  var
    i, idx, len, n_coded: Integer;
  function WebHexToInt(HexChar: Char): Integer;
  begin
    if HexChar < '0' then
      Result := Ord(HexChar) + 256 - Ord('0')
    else if HexChar <= Chr(Ord('A') - 1) then
      Result := Ord(HexChar) - Ord('0')
    else if HexChar <= Chr(Ord('a') - 1) then
      Result := Ord(HexChar) - Ord('A') + 10
    else
      Result := Ord(HexChar) - Ord('a') + 10;
  end;
begin
  len := 0;
  n_coded := 0;
  for i := 1 to Length(S) do
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
      if n_coded >= 3 then
        n_coded := 0;
    end
    else
    begin
      len := len + 1;
      if S[i] = '%' then
        n_coded := 1;
    end;
  SetLength(Result, len);
  idx := 0;
  n_coded := 0;
  for i := 1 to Length(S) do
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
      if n_coded >= 3 then
      begin
        Result[idx] := Chr((WebHexToInt(S[i - 1]) * 16 +
          WebHexToInt(S[i])) mod 256);
        n_coded := 0;
      end;
    end
    else
    begin
      idx := idx + 1;
      if S[i] = '%' then
        n_coded := 1;
      if S[i] = '+' then
        Result[idx] := ' '
      else
        Result[idx] := S[i];
    end;
end; // URLDecode

Function StrToBool(bool:string):boolean;
begin
if ansilowercase(bool)='true' then result:=true else result:=false;
end;

//1=1&2=2&3=3
Function ParseParams(params,prm:string):string;
var
i:integer;
begin
params:='&'+params;
prm:='&'+prm+'=';
result:='';
if pos(prm,params)>0 then
for I := pos(prm,params)+length(prm) to length(params) do
begin
if params[i]='&' then break;
result:=result+params[i];
end;
end;

Function ParseCookies(cookies,name:string):string;
var
i:integer;
begin
cookies:='; '+cookies;
name:='; '+name+'=';
result:='';
if pos(name,cookies)>0 then
for I := pos(name,cookies)+length(name) to length(cookies) do
begin
if (cookies[i]=';') and  (cookies[i+1]=' ') then break;
result:=result+cookies[i];
end;
end;

Procedure RunCaptured(const _exeName, _cmdLine: string;resultout:TStringList);
var
  start: TStartupInfo;
  procInfo: TProcessInformation;
  tmpName: string;
  tmp: Windows.THandle;
  tmpSec: TSecurityAttributes;
  return: Cardinal;
begin
  try
    { Setze ein Temporares File }
    { Set a temporary file }
    tmpName := 'win.tmp';
    FillChar(tmpSec, SizeOf(tmpSec), #0);
    tmpSec.nLength := SizeOf(tmpSec);
    tmpSec.bInheritHandle := True;
    tmp := Windows.CreateFile(PChar(tmpName),
           Generic_Write, File_Share_Write,
           @tmpSec, Create_Always, File_Attribute_Normal, 0);
    try
      FillChar(start, SizeOf(start), #0);
      start.cb          := SizeOf(start);
      start.hStdOutput  := tmp;
      start.dwFlags     := StartF_UseStdHandles or StartF_UseShowWindow;
      start.wShowWindow := SW_Hide;
      { Starte das Programm }
      { Start the program }
      if CreateProcess(nil, PChar(_exeName + ' ' + _cmdLine), nil, nil, True,
                       0, nil, PChar('c:\'), start, procInfo) then
      begin
        SetPriorityClass(procInfo.hProcess, Idle_Priority_Class);
        WaitForSingleObject(procInfo.hProcess, Infinite);
        GetExitCodeProcess(procInfo.hProcess, return);
        CloseHandle(procInfo.hThread);
        CloseHandle(procInfo.hProcess);
        Windows.CloseHandle(tmp);
        resultout.LoadFromFile(tmpName);
        Windows.DeleteFile(PChar(tmpName));
      end
      else
    except
      Windows.CloseHandle(tmp);
      Windows.DeleteFile(PChar(tmpName));
      raise;
    end;
  finally
  end;
end;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
 // Sets UnixStartDate to TDateTime of 01/01/1970
const
UnixStartDate: TDateTime = 25569.0;
begin
   //example: DateTimeToUnix(now);
   Result := Round((ConvDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime;
 // Sets UnixStartDate to TDateTime of 01/01/1970
const
UnixStartDate: TDateTime = 25569.0;
begin
   //Example: UnixToDateTime(1003187418);
   Result := (Usec / 86400) + UnixStartDate;
end;


Function DateTimetoHFS(dt:TDatetime):cardinal;
var
i:cardinal;
dayinyear:cardinal;
begin
//01-01-1904 00:00:00
dayinyear:=0;
for I := 1904 to DateUtils.YearOf(dt)-1 do
begin
dayinyear:=dayinyear+DateUtils.DaysInAYear(i);
end;
result:=((((dayinyear)*24)*60)*60)+SecondOfTheYear(dt);
end;

Function ReversInt(int:cardinal):cardinal;
Var num: Integer;
temp:string;
Begin
temp:='';
while( int > 0 ) do
begin
temp:=temp+inttostr(int mod 10) ;
int:=int div 10;
end;
if temp<>'' then
begin
try
result:=strtoint(temp);
except
result:=0;
end;
end;
End;


function DecToHex(DEC: LONGINT): Ansistring;
const
  HEXDigts: string[16] = '0123456789ABCDEF';
var
  HEX: ansistring;
  I, J: LONGINT;
begin
  if DEC = 0 then
    HEX := '0'
  else
  begin
    HEX := '';
    I := 0;
    while (1 shl ((I + 1) * 4)) <= DEC do
      I := I + 1;
    { 16^N = 2^(N * 4) }
    { (1 SHL ((I + 1) * 4)) = 16^(I + 1) }
    for J := 0 to I do
    begin
      HEX := HEX + HEXDigts[(DEC shr ((I - J) * 4)) + 1];
      { (DEC SHR ((I - J) * 4)) = DEC DIV 16^(I - J) }
      DEC := DEC and ((1 shl ((I - J) * 4)) - 1);
      { DEC AND ((1 SHL ((I - J) * 4)) - 1) = DEC MOD 16^(I - J) }
    end;
  end;
  result := HEX;
end;

function StrToHEX(text: Ansistring): Ansistring;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(text) do
  begin
    Result := Result + InttoHex(ord(text[i]), 2);
  end;
end;


function decToHex1(value: dword): ansistring;
const
hexdigit = '0123456789ABCDEF';
begin
while value <> 0 do
begin
   result := hexdigit[succ(value and $F)];
   value := value shr 4;
end;
if result = '' then result := '0';
end;


function HexToDec(Str : Ansistring): integer;
var
  i: integer;
begin
Result := 0;
Result := strtoint('$'+str);
end;


function HexToStr(Str : Ansistring): Ansistring;
var
  i: integer;
begin
  Result := '';
  for I := 1 to Length(str) do
    if odd(i) then
    begin
      Result := Result + Ansichar(strtoint('$'+str[i]+str[i+1]));
    end;
end;

function GetFileDateTime(FileName: string): TDateTime;
var
  intFileAge: LongInt;
begin
  intFileAge := FileAge(FileName);
  if intFileAge = -1 then
    Result := 0
  else
    Result := FileDateToDateTime(intFileAge)
end;



function ChackFileName(const FileName: string): boolean;
const
  CHARS: array[1..10] of char =
  ('\', '/', ':', '*', '.', '?', '"', '<', '>', '|');
var
 I: integer;
begin
for I := 1 to 10 do
if pos(CHARS[I], FileName) <> 0 then //Найден запрещённый символ
begin
Result := false;
Exit;
end;
Result := true;
end;


function RunProgram(const FileName, Params: string; WindowState: Word): Boolean;
var
SUInfo: TStartupInfo;
ProcInfo: TProcessInformation;
CmdLine: string;
begin
CmdLine := '"' + FileName + '"' + Params;
FillChar(SUInfo, SizeOf(SUInfo), #0);
with SUInfo do
begin
cb := SizeOf(SUInfo);
dwFlags := STARTF_USESHOWWINDOW;
wShowWindow := WindowState;
end;
Result := CreateProcess(nil, PChar(CmdLine), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,PChar(ExtractFilePath(FileName)),SUInfo, ProcInfo);
end;


//freehand.MakeRounded(Form8,20,20);
procedure MakeRounded(Control: TWinControl;p5,p6:integer);
 var
   R: TRect;
   Rgn: HRGN;
 begin
   with Control do
   begin
     R := ClientRect;
     rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, p5, p6);
     Perform(EM_GETRECT, 0, lParam(@r));
     InflateRect(r, - 5, - 5);
     Perform(EM_SETRECTNP, 0, lParam(@r));
     SetWindowRgn(Handle, rgn, True);
     Invalidate;
   end;
 end;

 // FormToTrayPos(form8);
 procedure FormToTrayPos(Control: TWinControl);
 var
   R: TRect;
 begin
   with Control do
   begin
     SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
     Top:=r.Bottom-Height-1;
     Left:=r.Right-Width-5;
   end;
 end;


Function StringToDate(date:string): TDateTime;
var
y,m,d:word;
i:integer;
begin
if length(date)<>10 then exit;
if (pos('-',date)=5) or (pos('/',date)=5) or (pos('\',date)=5) or (pos('.',date)=5) or (pos(',',date)=5) then
begin
y:=strtoint(copy(date,1,4));
m:=strtoint(copy(date,6,2));
d:=strtoint(copy(date,9,2));
result:=EncodeDate(y, m, d);
end else
if (pos('-',date)=3) or (pos('/',date)=3) or (pos('\',date)=3) or (pos('.',date)=3) or (pos(',',date)=3) then
begin
d:=strtoint(copy(date,1,2));
m:=strtoint(copy(date,4,2));
y:=strtoint(copy(date,7,4));
result:=EncodeDate(y, m, d);
end else   result:=EncodeDate(1, 1, 1);
end;

Function IsTime(time:string): boolean;
begin
result:=false;
try
strtotime(time);
result:=true;
except
result:=false;
end;
end;

Function GetWavTitle(filename:string):string;
var
fwav: TFileStream;
i,n,len:integer;
wavinam: array [1..255] of AnsiChar;
wavinfo: array [1..38] of AnsiChar;
begin
result:='';
fillchar(wavinfo,sizeof(wavinfo),0);
fillchar(wavinam,sizeof(wavinam),0);
fwav := TFileStream.Create(filename, fmOpenRead);
try
fwav.position := fwav.size -255;
fwav.Read(wavinam, 255);
for i := 0 to 255 do
if (wavinam[i]='I')  and  (wavinam[i+1]='N') and (wavinam[i+2]='A') and (wavinam[i+3]='M') then
begin
len:=255-i;
fwav.position := fwav.size -len-1;
fwav.Read(wavinfo, SizeOf(wavinfo));
break;
end;
finally
fwav.free;
end;
for i:=1 to 30 do
begin
if wavinfo[i+8]=#00 then break else result:=result+wavinfo[i+8]
end;
end;

function GetFileSize(namefile: string): Integer;
var
InfoFile: TSearchRec;
AttrFile: Integer;
ErrorReturn: Integer;
begin
AttrFile := $0000003F;
ErrorReturn := FindFirst(namefile, AttrFile, InfoFile);
if ErrorReturn <> 0 then Result := -1 else Result := InfoFile.Size;
FindClose(InfoFile);
end;

function IsFileInUse(FileName: TFileName): Boolean;
var
HFileRes: HFILE;
begin
Result := False;
if not FileExists(FileName) then Exit;
HFileRes := CreateFile(PChar(FileName),GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
Result := (HFileRes = INVALID_HANDLE_VALUE);
if Result=false then  CloseHandle(HFileRes);
end;

Function ReplaceSub(str, sub1, sub2: string):string;
var
aPos: Integer;
rslt: string;
begin
aPos := Pos(sub1, str);
rslt := '';
while (aPos <> 0) do
begin
rslt := rslt + Copy(str, 1, aPos - 1) + sub2;
Delete(str, 1, aPos + Length(sub1) - 1);
aPos := Pos(sub1, str);
end;
result := rslt + str;
end;

Function Chack(querty:string):string;
begin
querty:=ReplaceSub(querty,'\','\\');
querty:=ReplaceSub(querty,'"','\"');
querty:=ReplaceSub(querty,'''','\''');
result:=querty;
end;

Function SecondToTime(Seconds: integer): TTime;
var
ms, ss, mm, hh, dd: Cardinal;
const
SecPerDay = 86400;
SecPerHour = 3600;
SecPerMinute = 60;
begin
try
Seconds:=abs(Seconds);
hh := (Seconds mod SecPerDay) div SecPerHour;
mm := ((Seconds mod SecPerDay) mod SecPerHour) div SecPerMinute;
ss := ((Seconds mod SecPerDay) mod SecPerHour) mod SecPerMinute;
ms := 0;
Result :=EncodeTime(hh, mm, ss, ms);
except
Result:=strtotime('00:00:00');
end;
end;


function TimeToFrame(time:TTime; framepersec:cardinal) : cardinal;
var
 h, m, s, ms : word;
FramePerHour,FramePerMinute:cardinal;
begin
FramePerHour:= 3600 * framepersec;
FramePerMinute:= 60 * framepersec;
result:=0;
decodetime(time,h,m,s,ms);
result:=(framepersec*s)+(m*FramePerMinute)+(h*FramePerHour);
end;

function TimeToSecond(time:TTime) : cardinal;
var
 h, m, s ,ms: word;
const
SecPerHour = 3600;
SecPerMinute = 60;
begin
result:=0;
decodetime(time,h,m,s,ms);
result:=s+(m*SecPerMinute)+(h*SecPerHour);
end;


Function FrameToTime(count,oneframe: integer): TTime;
var
ff, ss, mm, hh, dd: Cardinal;
const
SecPerDay = 2160000;
SecPerHour = 90000;
SecPerMinute = 1500;
begin
try
count:=abs(count);
hh := (count mod SecPerDay) div SecPerHour;
mm := ((count mod SecPerDay) mod SecPerHour) div SecPerMinute;
ss := (((count mod SecPerDay) mod SecPerHour) mod SecPerMinute) div oneframe;
ff := (((count mod SecPerDay) mod SecPerHour) mod SecPerMinute)  mod oneframe;

//result:=inttostr(hh)+':'+inttostr(mm)+':'+inttostr(ss)+'.'+inttostr(ff);
Result :=EncodeTime(hh, mm, ss, ff);
except
Result:=strtotime('00:00:00');
end;
end;

Function MSecondToTime(MSeconds: integer): TTime;
var
ms, ss, mm, hh, dd: Cardinal;
const
MSecPerDay = 86400000;
MSecPerHour = 3600000;
MSecPerMinute = 60000;
MSecPerSec = 1000;
begin
try
MSeconds:=abs(MSeconds);
hh := ((MSeconds mod MSecPerDay) div MSecPerHour);
mm := (((MSeconds mod MSecPerDay) mod MSecPerHour) div MSecPerMinute);
ss := (((MSeconds mod MSecPerDay) mod MSecPerHour) mod MSecPerMinute) div MSecPerSec;
ms := (((MSeconds mod MSecPerDay) mod MSecPerHour) mod MSecPerMinute) mod MSecPerSec;
Result :=EncodeTime(hh, mm, ss, ms);
except
Result:=strtotime('00:00:00.000');
end;
end;


function DateToInt(x: string;mask:string) : integer;
var
 y, m, d : word;
 i:integer;
begin
result:=0;
if length(x)<>10 then exit;
if mask='yyyy-mm-dd' then
begin
y:=strtoint(copy(x,1,4));
m:=strtoint(copy(x,6,2));
d:=strtoint(copy(x,9,2));
end else
if mask='dd-mm-yyyy' then
begin
d:=strtoint(copy(x,1,2));
m:=strtoint(copy(x,4,2));
y:=strtoint(copy(x,7,4));
end;
for I := 1 to m-1 do
result:=result+DaysInAMonth(y,i);
result:=result+d+y;
end;



//initialization
//begin

//end;

end.
