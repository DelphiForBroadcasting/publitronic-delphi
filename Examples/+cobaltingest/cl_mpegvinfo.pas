unit cl_mpegvinfo;

interface

uses Classes, SysUtils, Windows, Dialogs;

type TMPEGVideoInfoError = (FH_NoError, FH_FileNotFound, FH_InvalidMPEGFile);

     TMPEGVersion = (V_Unknown, V_MPEG1, V_MPEG2, V_MPEG1_VCD, V_MPEG2_SVCD);

     TMPEGStreamType = (ST_Unknown, ST_Elementary, ST_Multiplexed);

     TGOPHeaderEx = packed record
      binary:string[32];
      drop_frame_flag:byte;
      hour:byte;
      minute:byte;
      second:byte;
      frame:byte;
      closed_gop:byte;
      broken_gop:byte;
      fullframe:cardinal;
     end;

     TSequenceHeader = packed record
       Prefix: array[0..2] of Byte; // Pack start code prefix: $00 $00 $01
       ID    : Byte;                // ID of Pack or Sequence Header
     end;

     TMPEGVideoFile = class(TObject)
     private
       FBitrate       : Integer;
       FFileName      : string;
       FLastError     : TMPEGVideoInfoError;
       FLength        : Extended;
       FLengthBR      : Extended;
       FLengthSCR     : Extended;
       FOk            : Boolean;
       FSize          : Longint;
       FStreamType    : TMPEGStreamType;
       FVersion       : TMPEGVersion;
       FWidth         : cardinal;
       FHeight        : cardinal;
       FFrameRate    : Extended;
       FFrameCount    : cardinal;
       FAspect_Ratio  : extended;
     function FindNextHeader(FileIn: TFileStream; const ID: Integer):Longint;
       function FindPreviousHeader(FileIn: TFileStream; const ID: Integer):Longint;
//     function GetGOPTimecode(FileIn: TFileStream; const Position: Integer): Extended;
       function GetMPEGVersion: TMPEGVersion;
       function GetSystemClockReference(FileIn: TFileStream; const Position: Integer; var SCREx: Word): Comp;
       function PackHeaderOK(SeqHdr: TSequenceHeader; const ID: Integer): Boolean;
       procedure GetBitrate(FileIn: TFileStream);
       procedure GetInfoFromFile;
       procedure GetLength(FileIn: TFileStream);
       function isFileMPEG(FileIn: TFileStream):boolean;
       procedure SequenceHeader(FileIn: TFileStream);
       {Properties}
       function GetLastError: TMPEGVideoInfoError;
     public
       constructor Create(const Name: string);
       destructor Destroy; override;
       procedure GetInfo;
       function ForceChackMpeg:boolean;
       {Properties}
       property Bitrate      : Integer read FBitrate;
       property FileName      : string read FFileName;
       property LastError     : TMPEGVideoInfoError read GetLastError;
       property Length        : Extended read FLength;
       property LengthBR     : Extended read FLengthBR;
       property LengthSCR     : Extended read FLengthSCR;
       property StreamType    : TMPEGStreamType read FStreamType;
       property Version       : TMPEGVersion read FVersion;
       property Width         : cardinal read FWidth;
       property Height        : cardinal read FHeight;
       property FrameRate     : Extended read FFrameRate;
       property FrameCount    : cardinal read FFrameCount;
       property Aspect_Ratio  : extended read FAspect_Ratio;
       property Size          : Longint read FSize;

     end;

implementation

const IDSequenceHeader  = $B3;
      IDGOPHeader       = $B8;
      IDPackHeader      = $BA;
      IDSystemHeader    = $BB;
      IDProgramEnd      = $B9;
      IDSequenceEnd     = $B7;
      IDErrorEnd        = $FF;


const
      sequence_header    = $B3010000;
      mpg_header         = $BA010000;
      picture_start_code = $00010000;
      gop                = $b8010000;

      Mpegv_frame_rate:array [0..15] of extended=(0,24000 / 1001,24,25,30000 / 1001,30,50,60000 div 1001,60,0,0,0,0,0,0,0 );
      Mpegv_aspect_ratio:array [0..15] of extended=(0,1,0.6735,0.7031,0.7615,0.8055,0.8437,0.8935,0.9375,0.9815,1.0255,1.0695,1.1250,1.1575,1.2015,0);


type TPackHeaderEx = packed record
       Prefix  : array[0..3] of Byte;    // Pack start header
       ID      : Byte;                   //
     end;

     TPackHeaderMPEG1 = packed record
       Prefix  : array[0..2] of Byte;   // Pack start code prefix: $00 $00 $01
       ID      : Byte;                  // ID of Pack or Sequence Header
       SCR     : array[0..4] of Byte;   // System Clock Reference
       BitRate : array[0..2] of Byte;   // Multiplex-Bitrate
     end;

     TPackHeaderMPEG2 = packed record
       Prefix  : array[0..2] of Byte;   // Pack start code prefix: $00 $00 $01
       ID      : Byte;                  // ID of Pack or Sequence Header
       SCR     : array[0..5] of Byte;   // System Clock Reference
       BitRate : array[0..2] of Byte;   // Multiplex-Bitrate
       reserved: Byte;                  // reserved
     end;

     TSequenceHeaderEx = packed record
       Prefix  : array[0..2] of Byte;   // Pack start code prefix: $00 $00 $01
       ID      : Byte;                  // ID of Pack or Sequence Header
       Size    : array[0..2] of Byte;   // Width, Height
       ARFR    : Byte;                  // Aspect Ratio / Frame Rate
       BitRate : array[0..2] of Byte;   // Bit Rate / Marker / VBV
       VBV     : Byte;                  // VBV / CPF / IM
       IM      : array[0..127] of Byte; // IM / Non-IM
     end;

     TGOPHeader = packed record
       Prefix  : array[0..2] of Byte;   // Pack start code prefix: $00 $00 $01
       ID      : Byte;                  // ID of Pack or Sequence Header
       TimeCode: array[0..3] of Byte;   // Timecode $ Flags
     end;

{ Hilfsfunktionen ------------------------------------------------------------ }

{ TMPEGVideoFile ------------------------------------------------------------- }

{ TMPEGVideoFile - private }

{ GetLastError -----------------------------------------------------------------  }



function SwapWord(twobytes: Word): Word; assembler;                    { Same as System.Swap }
asm
  XCHG AL,AH
end;

function DecToBin(Value: Longint; Digits: Integer): string;
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



function TMPEGVideoFile.ForceChackMpeg:boolean;
var FileIn: TFileStream;
begin
    try
      try
        FileIn := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
        result:=isFileMPEG(FileIn);
        if not result then FLastError := FH_InvalidMPEGFile;
      except
      FLastError := FH_InvalidMPEGFile;
      end;
    finally
      FileIn.Free;
    end;
end;

function TMPEGVideoFile.isFileMPEG(FileIn: TFileStream):boolean;
var
Buffer   : array[0..3] of Byte;
start_header:cardinal;
end_header:cardinal;
SeqHdr   : TSequenceHeader;
begin
result:=false;
FillChar(SeqHdr, SizeOf(SeqHdr), 0);
FillChar(Buffer, SizeOf(Buffer), 0);
FileIn.Seek(0, soFromBeginning);
FileIn.Read(Buffer,sizeof(Buffer));
SeqHdr.Prefix[0] := Buffer[0];
SeqHdr.Prefix[1] := Buffer[1];
SeqHdr.Prefix[2] := Buffer[2];
SeqHdr.ID        := Buffer[3];
if PackHeaderOk(SeqHdr,IDPackHeader) then result:=true;
FillChar(SeqHdr, SizeOf(SeqHdr), 0);
FillChar(Buffer, SizeOf(Buffer), 0);
FileIn.Seek(-4, soFromEnd);
FileIn.Read(Buffer,sizeof(Buffer));
SeqHdr.Prefix[0] := Buffer[0];
SeqHdr.Prefix[1] := Buffer[1];
SeqHdr.Prefix[2] := Buffer[2];
SeqHdr.ID        := Buffer[3];
if (PackHeaderOk(SeqHdr,IDProgramEnd) or PackHeaderOk(SeqHdr,IDSequenceEnd) or PackHeaderOk(SeqHdr,IDErrorEnd)) then
result:=true and result;


{if ((end_header=program_end) or (end_header=sequence_end) or (end_header=error_end)) and (start_header=mpg_header) then
begin
result:=true;
end; }
end;



function TMPEGVideoFile.GetLastError: TMPEGVideoInfoError;
begin
  Result := FLastError;
  FLastError := FH_NoError;
end;

{ PackHeaderOK -----------------------------------------------------------------

  True, wenn Pack Start Code Prefix in Ordnung ist ($00 $00 $01).              }

function TMPEGVideoFile.PackHeaderOK(SeqHdr: TSequenceHeader;
                                     const ID: Integer): Boolean;
begin
  Result := (SeqHdr.Prefix[0] = 0) and
            (SeqHdr.Prefix[1] = 0) and
            (SeqHdr.Prefix[2] = 1);
  if ID > -1 then
  begin
    Result := Result and (SeqHdr.ID = ID);
  end;
end;

{ FindNextHeader ---------------------------------------------------------------

  liefert die Position des Headers vom gew?nschten Typ als Offset von der
  aktuellen Position.                                                          }

function TMPEGVideoFile.FindNextHeader(FileIn: TFileStream;
                                       const ID: Integer):Longint;
var Buffer   : array[0..8191] of Byte;
    BytesRead: Integer;
    i        : Integer;
    Offset   : Longint;
    Ok       : Boolean;
    SeqHdr   : TSequenceHeader;
begin
  Result := -1;
  Offset := 0;
  repeat
    FillChar(Buffer, SizeOf(Buffer), 0);
    BytesRead := FileIn.Read(Buffer, SizeOf(Buffer));
    i := 0;
    {Header in Buffer suchen}
    repeat
      SeqHdr.Prefix[0] := Buffer[i];
      SeqHdr.Prefix[1] := Buffer[i + 1];
      SeqHdr.Prefix[2] := Buffer[i + 2];
      SeqHdr.ID        := Buffer[i + 3];
      Ok := PackHeaderOk(SeqHdr, ID);
      Inc(i);
    until Ok or (i = SizeOf(Buffer) - 3);
    FileIn.Seek(-3, soFromCurrent);
    Offset := Offset + i;
  until Ok or (BytesRead < SizeOf(Buffer));
  if Ok then
  begin
    Result := Offset - 1;
  end;
end;

{ FindPreviousHeader -----------------------------------------------------------

  liefert die Position des vorigen Headers vom gew?nschten Typ als Offset von
  der aktuellen Position.                                                      }

function TMPEGVideoFile.FindPreviousHeader(FileIn: TFileStream;
                                           const ID: Integer):Longint;
var Buffer   : array[0..8191] of Byte;
    BytesRead: Integer;
    i, j     : Integer;
    Offset   : Longint;
    Ok       : Boolean;
    SeqHdr   : TSequenceHeader;
begin
  Result := -1;
  Offset := 0;
  repeat
    FillChar(Buffer, SizeOf(Buffer), 0);
    FileIn.Seek(-SizeOf(Buffer), soFromCurrent);
    BytesRead := FileIn.Read(Buffer, SizeOf(Buffer));
    i := 8191; j := 0;
    {Header in Buffer suchen}
    repeat
      SeqHdr.Prefix[0] := Buffer[i - 3];
      SeqHdr.Prefix[1] := Buffer[i - 2];
      SeqHdr.Prefix[2] := Buffer[i - 1];
      SeqHdr.ID        := Buffer[i];
      Ok := PackHeaderOk(SeqHdr, ID);
      Dec(i); Inc(j);
    until Ok or (i = 3);
    FileIn.Seek((-2 * SizeOf(Buffer)) + 2, soFromCurrent);
    Offset := Offset + j;
  until Ok or (BytesRead < SizeOf(Buffer));
  if Ok then
  begin
    Result := Offset + 3;
  end;
end;

{ GetSystemClockReference ------------------------------------------------------

  liefert die System Clock Reference des an Position stehenden Pack Headers.   }

function TMPEGVideoFile.GetSystemClockReference(FileIn: TFileStream;
                                                const Position: Integer;
                                                var SCREx: Word): Comp;
var Buffer      : array[0..139] of Byte;
    SCRArray    : array[0..7] of Byte;
    SCRExArray  : array[0..1] of Byte;
    PackHdrMPEG1: ^TPackHeaderMPEG1;
    PackHdrMPEG2: ^TPackHeaderMPEG2;
begin
  PackHdrMPEG1 := @Buffer;
  PackHdrMPEG2 := @Buffer;
  FillChar(SCRArray, SizeOf(SCRArray), 0);
  FillChar(SCRExArray, SizeOf(SCRArray), 0);
  FileIn.Seek(Position, soFromBeginning);
  FileIn.ReadBuffer(Buffer, SizeOf(Buffer));
  if FVersion in [V_MPEG1, V_MPEG1_VCD] then
  begin
    SCRArray[0] := (PackHdrMPEG1^.SCR[4] shr 1) or
                   (PackHdrMPEG1^.SCR[3] shl 7);
    SCRArray[1] := (PackHdrMPEG1^.SCR[3] shr 1) or
                   (PackHdrMPEG1^.SCR[2] and $2) shl 6;
    SCRArray[2] := (PackHdrMPEG1^.SCR[2] shr 2) or
                   (PackHdrMPEG1^.SCR[1] shl 6);
    SCRArray[3] := (PackHdrMPEG1^.SCR[1] shr 2) or
                   (PackHdrMPEG1^.SCR[0] and $6) shl 5;
    SCRArray[4] := (PackHdrMPEG1^.SCR[0] and 8) shr 3;
  end else
  if FVersion in [V_MPEG2, V_MPEG2_SVCD] then
  begin
    SCRArray[0] := (PackHdrMPEG2^.SCR[4] shr 3) or
                   (PackHdrMPEG2^.SCR[3] shl 5);
    SCRArray[1] := (PackHdrMPEG2^.SCR[3] shr 3) or
                   ((PackHdrMPEG2^.SCR[2] and $3) shl 3) or
                   ((PackHdrMPEG2^.SCR[2] and $8) shl 4);
    SCRArray[2] := (PackHdrMPEG2^.SCR[2] shr 4) or
                   (PackHdrMPEG2^.SCR[1] shl 4);
    SCRArray[3] := (PackHdrMPEG2^.SCR[1] shr 4) or
                   ((PackHdrMPEG2^.SCR[0] and $3) shl 4) or
                   ((PackHdrMPEG2^.SCR[0] and $18) shl 3);
    SCRArray[4] := (PackHdrMPEG2^.SCR[0] and $20) shr 5;
    SCRExArray[0] := (PackHdrMPEG2^.SCR[5] shr 1) or
                     ((PackHdrMPEG2^.SCR[4] and $1) shl 7);
    SCRExArray[1] := (PackHdrMPEG2^.SCR[4] and $2) shr 1;

  end;
  Result := Comp(SCRArray);
  SCREx := Word(SCRExArray);
end;

{ GetGOPTimeCode ---------------------------------------------------------------

  liefert den Timecode in Sekunden der an Position stehenden GOP.              }
(*
function TMPEGVideoFile.GetGOPTimecode(FileIn: TFileStream;
                                       const Position: Integer): Extended;
var Buffer       : array[0..7] of Byte;
    GOPHdr       : ^TGOPHeader;
    Hrs, Min, Sec: Byte;
begin
  GOPHdr := @Buffer;
  FileIn.Seek(Position, soFromBeginning);
  FileIn.ReadBuffer(Buffer, SizeOf(Buffer));
  Hrs := GOPHdr^.TimeCode[0] shr 2;
  Min := ((GOPHdr^.TimeCode[0] and $3) shl 4) or (GOPHdr^.TimeCode[1] shr 4);
  Sec := ((GOPHdr^.TimeCode[1] and $7) shl 3) or (GOPHdr^.TimeCode[2] shr 5);
  Result := Sec + Min * 60 + Hrs * 60 * 60;
end; *)

{ GetMPEGVersion ---------------------------------------------------------------

  bestimmt die Art der MPEG-Datei.                                             }

function TMPEGVideoFile.GetMPEGVersion: TMPEGVersion;
var FileIn : TFileStream;
    Buffer : array[0..139] of Byte;
    SeqHdr : ^TSequenceHeader;
    PackHdr: ^TPackHeaderEx;
    Ok     : Boolean;
begin
  FileIn := nil;
  Result := V_Unknown;
  try
    try
      FileIn := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
      FSize := FileIn.Size;
      FileIn.ReadBuffer(Buffer, SizeOf(Buffer));

      SeqHdr := @Buffer;
      PackHdr := @Buffer;
      {Pack Start Code Prefix?}
      Ok := PackHeaderOk(SeqHdr^, -1);

      {StreamType}
      case SeqHdr^.ID of
        IDSequenceHeader: FStreamType := ST_Elementary;
        IDPackHeader    : FStreamType := ST_Multiplexed;
      end;

      {MPEG-Version}
      if Ok and (FStreamType = ST_Elementary) then
      begin
        // not implemented yet
      end else
      if Ok and (FStreamType = ST_Multiplexed) then
      begin
        if (PackHdr^.ID and $F0) = $20 then Result := V_MPEG1;
        if (PackHdr^.ID and $C0) = $40 then Result := V_MPEG2;
        
        {Packet size: 2048 oder 2324 Byte?}
        FileIn.Seek(2324, soFromBeginning);
        FileIn.ReadBuffer(Buffer, SizeOf(Buffer));
        if PackHeaderOk(SeqHdr^, IDPackHeader) then
        begin
          Result := Succ(Succ(Result));
        end;
      end;
    except
      {Fehler beim Lesen}
      FLastError := FH_FileNotFound;
    end;
  finally
    FileIn.Free;
  end;
end;

{ GetBitrate -------------------------------------------------------------------

  ermittelt die Gesamt-Bitrate der Datei.                                      }

procedure TMPEGVideoFile.GetBitrate(FileIn: TFileStream);
var Buffer      : array[0..139] of Byte;
    BitrateArray: array[0..3] of Byte;
    PackHdrMPEG1: ^TPackHeaderMPEG1;
    PackHdrMPEG2: ^TPackHeaderMPEG2;
begin
  {Bitrate}
  FillChar(BitrateArray, SizeOf(BitrateArray), 0);
  FileIn.Seek(0, soFromBeginning);
  FileIn.ReadBuffer(Buffer, SizeOf(Buffer));
  if FStreamType = ST_Elementary then
  begin
    // not implemented yet
  end else
  if FStreamType = ST_Multiplexed then
  begin
    if FVersion in [V_MPEG1, V_MPEG1_VCD] then
    begin
      PackHdrMPEG1 := @Buffer;
      BitrateArray[0] := (PackHdrMPEG1^.Bitrate[2] shr 1) or
                         (PackHdrMPEG1^.Bitrate[1] shl 7);
      BitrateArray[1] := (PackHdrMPEG1^.Bitrate[1] shr 1) or
                         (PackHdrMPEG1^.Bitrate[0] shl 7);
      BitrateArray[3] := (PackHdrMPEG1^.Bitrate[0] and $3F) shr 1;
    end else
    if FVersion in [V_MPEG2, V_MPEG2_SVCD] then
    begin
      PackHdrMPEG2 := @Buffer;
      BitrateArray[0] := (PackHdrMPEG2^.Bitrate[2] shr 2) or
                         (PackHdrMPEG2^.Bitrate[1] shl 6);
      BitrateArray[1] := (PackHdrMPEG2^.Bitrate[1] shr 2) or
                         (PackHdrMPEG2^.Bitrate[0] shl 6);
      BitrateArray[3] := (PackHdrMPEG2^.Bitrate[0] and $FC) shr 2;
    end;
  end;
  FBitrate := Integer(BitrateArray) * 400;
end;

{ GetLength --------------------------------------------------------------------

  bestimmt die L?nge der MPEG-Datei in Sekunden.
  SCR: System Clock Reference (90kHz), System Clock Reference Extension (27MHz)}

procedure TMPEGVideoFile.GetLength(FileIn: TFileStream);
var TimeBR        : Extended;
    TimeSCR       : Extended;
//  TimeGOP       : Extended;
//  GOP1, GOP2    : Extended;
    SCR1, SCR2    : Comp;
    SCR1Ex, SCR2Ex: Word;
    Position      : Integer;
begin
  TimeBR := 0;
  TimeSCR := 0;
  {Bestimmung ?ber Dateigr??e und Gesamt-Bitrate}
  if FBitrate > 0 then
  begin
    TimeBR := FSize / FBitrate * 8;
  end;

  {Dauer nach System Clock Reference}
  if FStreamType = ST_Multiplexed then
  begin
    {SCR des ersten Pack Headers}
    SCR1 := GetSystemClockReference(FileIn, 0, SCR1Ex);
    {SCR des letzten Pack Headers}
    FileIn.Seek(0, soFromEnd);
    Position := FindPreviousHeader(FileIn, IDPackHeader);
    SCR2 := GetSystemClockReference(FileIn, FSize - Position, SCR2Ex);
    if FVersion in [V_MPEG1, V_MPEG1_VCD] then
    begin
      TimeSCR := (SCR2 - SCR1) / 90000;
    end else
    if FVersion in [V_MPEG2, V_MPEG2_SVCD] then
    begin
      SCR1 := SCR1 * 300 + SCR1Ex;
      SCR2 := SCR2 * 300 + SCR2Ex;
      TimeSCR := (SCR2 - SCR1) / 27000000;
    end;
  end;

  FLengthBR := TimeBR;
  FLengthSCR := TimeSCR;
  {Wir nehmen als L?nge das Maximum der beiden Werte.}
  if FLengthBR > FLengthSCR then
    FLength := FLengthBR else
    FLength := FLengthSCR;

    FFrameCount:=Round(FLength*FFrameRate);
end;




procedure TMPEGVideoFile.SequenceHeader(FileIn: TFileStream);
var Position      : Integer;
    width,height:word;
    framerate:byte;
    aspect_ratio:byte;
begin
    width:=0;
    height:=0;
    framerate:=0;
    aspect_ratio:=0;
  {Dauer nach System Clock Reference}
  if FStreamType = ST_Multiplexed then
  begin
    FileIn.Seek(0, soFromBeginning);
    Position :=filein.Position;
    Position := FindNextHeader(FileIn, IDSequenceHeader);
    if FVersion in [V_MPEG1, V_MPEG1_VCD] then
    begin
      ;
    end else
    if FVersion in [V_MPEG2, V_MPEG2_SVCD] then
    begin
      FileIn.Position:=Position+4;
      FileIn.Read(width,sizeof(width));
      width:=swapword(width);
      FWidth:=width shr 4;

      FileIn.Position:=Position+5;
      FileIn.Read(height,sizeof(height));
      height:=swapword(height);
      FHeight:=height-((height shr 12) shl 12);

      FileIn.Position:=Position++7;
      FileIn.Read(aspect_ratio,sizeof(aspect_ratio));
      framerate:=aspect_ratio;
      aspect_ratio:=aspect_ratio shr 4;
      FAspect_Ratio:=Mpegv_aspect_ratio[aspect_ratio];

      framerate:=framerate-((framerate shr 4) shl 4);
      FFrameRate :=Mpegv_frame_rate[framerate];
    end;
  end;

end;
{ GetInfoFromFile --------------------------------------------------------------

  sammelt die Informationen ?ber die MPEG-Datei.
                              }

procedure TMPEGVideoFile.GetInfoFromFile;
var FileIn: TFileStream;
begin
  FileIn := nil;
  try
    try
      FileIn := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
      GetBitrate(FileIn);
      SequenceHeader(FileIn);
      GetLength(FileIn);
    except
    end;
  finally
    FileIn.Free;
  end;
end;

{ TMPEGVideoFile - public }

constructor TMPEGVideoFile.Create(const Name: string);
begin
  inherited Create;
  FBitrate     := 0;
  FLength      := 0;
  FSize        := 0;
  FWidth       := 0;
  FHeight      := 0;
  FFrameRate    := 0;
  FFrameCount   := 0;
  FAspect_Ratio := 0.0;
  FStreamType := ST_Unknown;
  FVersion    := V_Unknown;
  if FileExists(Name) then
  begin
    FLastError := FH_NoError;
    FOk        := True;
    FFileName  := Name;
  end else
  begin
    FLastError := FH_FileNotFound;
    FOk        := False;
    FFileName  := '';
  end;
end;

destructor TMPEGVideoFile.Destroy;
begin
  inherited Destroy;
end;

{ GetInfo ----------------------------------------------------------------------

  GetInfo sammelt die Informationen ?ber die MPEG-Video-Datei.                 }

procedure TMPEGVideoFile.GetInfo;
begin
  if FOk then
  begin
    FVersion := GetMPEGVersion;
    if FVersion = V_Unknown then
    begin
      FLastError := FH_InvalidMPEGFile;
    end else
    begin
      GetInfoFromFile;
    end;
  end;
end;

end.
