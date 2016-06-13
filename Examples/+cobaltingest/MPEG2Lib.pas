////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// MPEG2Lib.pas - MPEG2 video decoder unit
// ---------------------------------------
// Changed:   2005-01-09
// Maintain:  Michael Vinther: http://logicnet.dk/lib   |   mv@logicnet·dk
//
// Based on the DVD2AVI project    http://arbor.ee.ntu.edu.tw/~jackei/dvd2avi/
// and MSSG MPEG2Decode            http://www.mpeg.org/MPEG/MSSG/
//
// Last change:
//   TVideoFileInfo.VideoPTS and TVideoFrameInfo.FrameRate added
//   TMPEG2Decoder class added
//   Stream mode
//   AspectRatio in TVideoFrameInfo
//   Optional de-interlacing
//
unit MPEG2Lib;

interface

uses SysUtils, Windows, Monitor, FileUtils;

const
  MPEG2LibDLLName = 'mpeg2lib.dll';

  // Constants for SetMPEG2PixelFormat
  VideoFormatRGB24       = 1; // RGB interleaved, default
  VideoFormatGray8       = 2; // Y plane
  VideoFormatYUV24Planar = 3; // YUV planes

type
  TVideoFrameInfo = record
                      Width, Height : Integer;
                      FrameRate     : Double; // Frames/second
                      AspectRatio   : Double; // Width/height or 0 if unknown
                    end;

  TVideoFileInfo = record
                     Size     : Int64;
                     Position : Int64;
                     Frame    : DWord;
                     VideoPTS : DWord; // Timestamp in 1/90000 seconds
                                       // Not updated during playback, only by MPEG2Seek
                   end;

  TStreamGetCallback   = function(Offset: Int64; Buffer: Pointer; Count: DWord; Owner: TObject): DWord; stdcall;

  TOpenMPEG2File       = function(FileName: PChar; Offset: Int64=0; Size: Int64=-1): LongBool; stdcall;
  TOpenMPEG2Disk       = function(Disk: Byte; Offset: Int64=0; Size: Int64=-1): LongBool; stdcall;
  TOpenMPEG2Stream     = function(StreamGetCallback: TStreamGetCallback; SequentialStream: LongBool; Size: Int64=High(Int64)-2*Int64(High(DWord)); Owner: TObject=nil): LongBool; stdcall;
  TCloseMPEG2File      = procedure; stdcall;
  TGetMPEG2Frame       = function: PByteArray; stdcall;
  TSkipMPEG2Frames     = procedure(FrameCount: Integer); stdcall;
  TGetMPEG2FrameInfo   = procedure(var FrameInfo: TVideoFrameInfo); stdcall;
  TGetMPEG2FileInfo    = procedure(var FileInfo: TVideoFileInfo); stdcall;
  TMPEG2Seek           = procedure(Position: Int64); stdcall;
  TSetMPEG2PixelFormat = procedure(PixelFormat: Integer); stdcall;
  TSetRGBScaleFlag     = procedure(DoScaling: LongBool); stdcall;
  TWriteDataToFile     = function(FileName: PChar; Size: Int64=High(Int64)): Int64; stdcall;

//==============================================================================================================================
// MPEG2 decoder class
//==============================================================================================================================
  TMPEGPixelFormat = (vpfNone,vpfRGB24,vpfGray8,vpfYUV24Planar);

  TMPEG2Decoder = class(TMonitorObject)
    private
      DLLHandle : THandle;
      LocalDLLPath : string;
      FStreamSize : Int64;
      VideoPTS, FramePTSDelta : DWord;
      FRGBScaling : Boolean;
      FPixelFormat : TMPEGPixelFormat;
      FFrameInfo : TVideoFrameInfo;
      function GetPosition: Int64;
      procedure SetPosition(Position: Int64);
      procedure SetPixFormat(Format: TMPEGPixelFormat);
      procedure SetScaleFlag(DoScaling: Boolean);
      procedure Update;
    protected
      OpenMPEG2File : TOpenMPEG2File;
      OpenMPEG2Disk : TOpenMPEG2Disk;
      OpenMPEG2Stream : TOpenMPEG2Stream;
      CloseMPEG2File : TCloseMPEG2File;
      GetMPEG2FrameInfo : TGetMPEG2FrameInfo;
      GetMPEG2FileInfo : TGetMPEG2FileInfo;
      GetMPEG2Frame : TGetMPEG2Frame;
      SkipMPEG2Frames : TSkipMPEG2Frames;
      MPEG2Seek : TMPEG2Seek;
      SetMPEG2PixelFormat : TSetMPEG2PixelFormat;
      SetRGBScaleFlag : TSetRGBScaleFlag;
      WriteDataToFile : TWriteDataToFile;
    public
      constructor Create(const LibraryPath: string='');
      destructor Destroy; override;
      // Frame resolution
      property FrameWidth: Integer read FFrameInfo.Width;
      property FrameHeight: Integer read FFrameInfo.Height;
      // Frame aspect ratio, width/height
      property AspectRatio: Double read FFrameInfo.AspectRatio;
      // Video frame rate, frames per second
      property FrameRate: Double read FFrameInfo.FrameRate;
      // Requested pixel formay
      property PixelFormat: TMPEGPixelFormat read FPixelFormat write SetPixFormat;
      // Video timestamp in 1/90000 seconds. Note that this timestamp can only be trusted
      // just after assigning a value to Position - it might be inaccurate after calls to
      // DecodeFrame or SkipFrames
      property Timestamp: DWord read VideoPTS;
      property FrameTimeDelta: DWord read FramePTSDelta;
      // Do gamma scaling
      property RGBScaling : Boolean read FRGBScaling write SetScaleFlag;
      // Stream size in bytes
      property StreamSize: Int64 read FStreamSize;
      // Stream position in bytes
      property Position: Int64 read GetPosition write SetPosition;
      // Open MPEG2 video file
      procedure OpenFile(const FileName: string; Offset: Int64=0; Size: Int64=-1);
      // Open MPEG2 video disk
      procedure OpenDisk(Disk: Byte; Offset: Int64=0; Size: Int64=-1);
      // Open MPEG2 video stream. Set SequentialStream=True if only sequential reading is allowed
      procedure OpenStream(StreamGetCallback: TStreamGetCallback; SequentialStream: Boolean; Size: Int64=High(Int64)-2*Int64(High(DWord)); Owner: TObject=nil);
      // Close video
      procedure Close;
      // Decode frame and return pointer to bitmap. If DeInterlacingStrength>0, the frame is de-interlaced. Try e.g. 240
      function DecodeFrame(DeInterlacingStrength: Integer=0): PByteArray;
      // Skip frames - more accurate seeking than setting Position, but slower
      procedure SkipFrames(FrameCount: Integer=1);
      // Extract video from Position and make new file. Return number of bytes written.
      function WriteToFile(const FileName: string; MaxSize: Int64=High(Int64)): Int64;
    end;

  EMPEG2Error = class(Exception);

//==============================================================================================================================
// Global MPEG2 decoder - direct access to DLL library
//==============================================================================================================================
function LoadMPEG2Library(const LibraryPath: string=''): Boolean;

var
  OpenMPEG2File : TOpenMPEG2File;
  OpenMPEG2Disk : TOpenMPEG2Disk;
  OpenMPEG2Stream : TOpenMPEG2Stream;
  CloseMPEG2File : TCloseMPEG2File;
  GetMPEG2FrameInfo : TGetMPEG2FrameInfo;
  GetMPEG2FileInfo : TGetMPEG2FileInfo;
  GetMPEG2Frame : TGetMPEG2Frame;
  SkipMPEG2Frames : TSkipMPEG2Frames;
  MPEG2Seek : TMPEG2Seek;
  SetMPEG2PixelFormat : TSetMPEG2PixelFormat;
  SetRGBScaleFlag : TSetRGBScaleFlag;
  WriteDataToFile : TWriteDataToFile;

implementation

var
  DLLHandle : THandle = 0;
  InstanceCount : Integer = 0;

function LoadMPEG2Library(const LibraryPath: string): Boolean;
begin
  if DLLHandle=0 then
  begin
    Result:=False;
    InterlockedIncrement(InstanceCount);
    Assert(InstanceCount=1,'LoadMPEG2Library cannot be used when a TMPEG2Decoder exists');
    DLLHandle:=LoadLibrary(PChar(ForceBackslash(LibraryPath)+MPEG2LibDLLName));
    if DLLHandle=0 then
    begin
      InterlockedDecrement(InstanceCount);
      Exit;
    end;
    OpenMPEG2File:=GetProcAddress(DLLHandle,'?OpenMPEG2File@@YGHPAD_J1@Z'); if not Assigned(OpenMPEG2File) then Exit;
    OpenMPEG2Disk:=GetProcAddress(DLLHandle,'?OpenMPEG2Disk@@YGHE_J0@Z'); if not Assigned(OpenMPEG2Disk) then Exit;
    OpenMPEG2Stream:=GetProcAddress(DLLHandle,'?OpenMPEG2Stream@@YGHP6GK_JPADKK@ZH0K@Z'); if not Assigned(OpenMPEG2Stream) then Exit;
    GetMPEG2FrameInfo:=GetProcAddress(DLLHandle,'?GetMPEG2FrameInfo@@YGXPAUTVideoFrameInfo@@@Z'); if not Assigned(GetMPEG2FrameInfo) then Exit;
    GetMPEG2FileInfo:=GetProcAddress(DLLHandle,'?GetMPEG2FileInfo@@YGXPAUTVideoFileInfo@@@Z'); if not Assigned(GetMPEG2FileInfo) then Exit;
    CloseMPEG2File:=GetProcAddress(DLLHandle,'?CloseMPEG2File@@YGXXZ'); if not Assigned(CloseMPEG2File) then Exit;
    GetMPEG2Frame:=GetProcAddress(DLLHandle,'?GetMPEG2Frame@@YGPAEXZ'); if not Assigned(GetMPEG2Frame) then Exit;
    MPEG2Seek:=GetProcAddress(DLLHandle,'?MPEG2Seek@@YGX_J@Z'); if not Assigned(MPEG2Seek) then Exit;
    SkipMPEG2Frames:=GetProcAddress(DLLHandle,'?SkipMPEG2Frames@@YGXH@Z'); if not Assigned(SkipMPEG2Frames) then Exit;
    SetMPEG2PixelFormat:=GetProcAddress(DLLHandle,'?SetMPEG2PixelFormat@@YGXH@Z'); if not Assigned(SetMPEG2PixelFormat) then Exit;
    SetRGBScaleFlag:=GetProcAddress(DLLHandle,'?SetRGBScaleFlag@@YGXH@Z'); if not Assigned(SetRGBScaleFlag) then Exit;
    WriteDataToFile:=GetProcAddress(DLLHandle,'?WriteDataToFile@@YG_JPAD_J@Z'); if not Assigned(WriteDataToFile) then Exit;
  end;
  Result:=True;
end;

//==============================================================================================================================
// TMPEG2Decoder
//==============================================================================================================================

constructor TMPEG2Decoder.Create(const LibraryPath: string='');
var
  TempPath : string;
begin
  inherited Create;

  InterlockedIncrement(InstanceCount);
  try
    if InstanceCount=1 then DLLHandle:=LoadLibrary(PChar(ForceBackslash(LibraryPath)+MPEG2LibDLLName))
    else
    begin
      SetLength(TempPath,1024);
      SetLength(TempPath,GetTempPath(Length(TempPath)+1,@TempPath[1]));
      SetLength(LocalDLLPath,MAX_PATH);
      GetTempFileName(PChar(TempPath),MPEG2LibDLLName,0,@LocalDLLPath[1]);
      SetLength(LocalDLLPath,StrLen(PChar(@LocalDLLPath[1])));
      if LibraryPath='' then CopyFile(PChar(ProgramPath+MPEG2LibDLLName),PChar(LocalDLLPath),False)
      else CopyFile(PChar(ForceBackslash(LibraryPath)+MPEG2LibDLLName),PChar(LocalDLLPath),False);
      DLLHandle:=LoadLibrary(PChar(LocalDLLPath));
    end;
    if DLLHandle=0 then RaiseLastWin32Error;
  except
    if DLLHandle=0 then InterlockedDecrement(InstanceCount);
    raise;
  end;

  OpenMPEG2File:=GetProcAddress(DLLHandle,'?OpenMPEG2File@@YGHPAD_J1@Z'); if not Assigned(OpenMPEG2File) then RaiseLastWin32Error;;
  OpenMPEG2Disk:=GetProcAddress(DLLHandle,'?OpenMPEG2Disk@@YGHE_J0@Z'); if not Assigned(OpenMPEG2Disk) then RaiseLastWin32Error;;
  OpenMPEG2Stream:=GetProcAddress(DLLHandle,'?OpenMPEG2Stream@@YGHP6GK_JPADKK@ZH0K@Z'); if not Assigned(OpenMPEG2Stream) then RaiseLastWin32Error;;
  GetMPEG2FrameInfo:=GetProcAddress(DLLHandle,'?GetMPEG2FrameInfo@@YGXPAUTVideoFrameInfo@@@Z'); if not Assigned(GetMPEG2FrameInfo) then RaiseLastWin32Error;;
  GetMPEG2FileInfo:=GetProcAddress(DLLHandle,'?GetMPEG2FileInfo@@YGXPAUTVideoFileInfo@@@Z'); if not Assigned(GetMPEG2FileInfo) then RaiseLastWin32Error;;
  CloseMPEG2File:=GetProcAddress(DLLHandle,'?CloseMPEG2File@@YGXXZ'); if not Assigned(CloseMPEG2File) then RaiseLastWin32Error;;
  GetMPEG2Frame:=GetProcAddress(DLLHandle,'?GetMPEG2Frame@@YGPAEXZ'); if not Assigned(GetMPEG2Frame) then RaiseLastWin32Error;;
  MPEG2Seek:=GetProcAddress(DLLHandle,'?MPEG2Seek@@YGX_J@Z'); if not Assigned(MPEG2Seek) then RaiseLastWin32Error;;
  SkipMPEG2Frames:=GetProcAddress(DLLHandle,'?SkipMPEG2Frames@@YGXH@Z'); if not Assigned(SkipMPEG2Frames) then RaiseLastWin32Error;;
  SetMPEG2PixelFormat:=GetProcAddress(DLLHandle,'?SetMPEG2PixelFormat@@YGXH@Z'); if not Assigned(SetMPEG2PixelFormat) then RaiseLastWin32Error;;
  SetRGBScaleFlag:=GetProcAddress(DLLHandle,'?SetRGBScaleFlag@@YGXH@Z'); if not Assigned(SetRGBScaleFlag) then RaiseLastWin32Error;;
  WriteDataToFile:=GetProcAddress(DLLHandle,'?WriteDataToFile@@YG_JPAD_J@Z'); if not Assigned(WriteDataToFile) then RaiseLastWin32Error;;

  FPixelFormat:=vpfRGB24;
end;

destructor TMPEG2Decoder.Destroy;
begin
  inherited;
  if DLLHandle<>0 then
  begin
    FreeLibrary(DLLHandle);
    InterlockedDecrement(InstanceCount);
  end;
  if LocalDLLPath<>'' then DeleteFile(PChar(LocalDLLPath));
end;

procedure TMPEG2Decoder.SetPosition(Position: Int64);
var
  FileInfo : TVideoFileInfo;
begin
  MPEG2Seek(Position);
  GetMPEG2FileInfo(FileInfo);
  VideoPTS:=FileInfo.VideoPTS;
end;

function TMPEG2Decoder.GetPosition: Int64;
var
  FileInfo : TVideoFileInfo;
begin
  GetMPEG2FileInfo(FileInfo);
  Result:=FileInfo.Position;
end;

procedure TMPEG2Decoder.SetPixFormat(Format: TMPEGPixelFormat);
begin
  SetMPEG2PixelFormat(Integer(Format));
  FPixelFormat:=Format;
end;

procedure TMPEG2Decoder.SetScaleFlag(DoScaling: Boolean);
begin
  SetRGBScaleFlag(DoScaling);
  FRGBScaling:=DoScaling;
end;

procedure TMPEG2Decoder.Update;
var
  FileInfo : TVideoFileInfo;
begin
  GetMPEG2FrameInfo(FFrameInfo);
  if FFrameInfo.Width*FFrameInfo.Height<=0 then
    raise EMPEG2Error.Create('Error decoding video');
  FramePTSDelta:=Round(90000/FrameRate);

  GetMPEG2FileInfo(FileInfo);
  FStreamSize:=FileInfo.Size;
  VideoPTS:=FileInfo.VideoPTS;
end;

// Open MPEG2 video file
procedure TMPEG2Decoder.OpenFile(const FileName: string; Offset,Size: Int64);
begin
  FStreamSize:=0;
  if not OpenMPEG2File(PChar(FileName),Offset,Size) then
    raise EMPEG2Error.Create('Unable to open video file: '+FileName);
  Update;
end;

// Open MPEG2 video disk
procedure TMPEG2Decoder.OpenDisk(Disk: Byte; Offset,Size: Int64);
begin
  FStreamSize:=0;
  if not OpenMPEG2Disk(Disk,Offset,Size) then
    raise EMPEG2Error.Create('Unable to open video disk');
  Update;
end;

// Open MPEG2 video stream
procedure TMPEG2Decoder.OpenStream(StreamGetCallback: TStreamGetCallback; SequentialStream: Boolean; Size: Int64;Owner: TObject);
begin
  FStreamSize:=0;
  if not OpenMPEG2Stream(StreamGetCallback,SequentialStream,Size,Owner) then
    raise EMPEG2Error.Create('Unable to open video stream');
  Update;
end;

// Close video
procedure TMPEG2Decoder.Close;
begin
  FStreamSize:=0;
  CloseMPEG2File;
end;

// Decode frame and return pointer to bitmap
function TMPEG2Decoder.DecodeFrame(DeInterlacingStrength: Integer): PByteArray;

  procedure DeInterlace;
  var
    X, Y, Pix8, M, BytesPerLine, Threshold : Integer;
  begin
    if PixelFormat=vpfRGB24 then BytesPerLine:=FrameWidth*3
    else BytesPerLine:=FrameWidth;
    Threshold:=255-DeInterlacingStrength;
    Y:=0; // Set to 0 or 1
    while Y<FrameHeight do
    begin
      Pix8:=Integer(Result)+Y*BytesPerLine;
      if Y=0 then // First line
        Move(Pointer(Integer(Pix8)+BytesPerLine)^,Pointer(Pix8)^,BytesPerLine)
      else if Y=FrameHeight-1 then // Last line
        Move(Pointer(Integer(Pix8)-BytesPerLine)^,Pointer(Pix8)^,BytesPerLine)
      else
        for X:=1 to BytesPerLine do
        begin
          M:=(Integer(PByte(Pix8-BytesPerLine)^)+Integer(PByte(Pix8+BytesPerLine)^)+1) div 2;
          if Abs(M-PByte(Pix8)^)>Threshold then PByte(Pix8)^:=M;
          Inc(Pix8);
        end;
      Inc(Y,2);
    end;
  end;

begin
  Result:=GetMPEG2Frame;
  Inc(VideoPTS,FramePTSDelta);
  if Assigned(Result) and (DeInterlacingStrength>0) then DeInterlace;
end;

// Skip frames - more accurate seeking than setting Position, but slower
procedure TMPEG2Decoder.SkipFrames(FrameCount: Integer);
begin
  SkipMPEG2Frames(FrameCount);
  Inc(VideoPTS,DWord(FrameCount)*FramePTSDelta);
end;

// Extract video data and make new file
function TMPEG2Decoder.WriteToFile(const FileName: string; MaxSize: Int64): Int64;
begin
  Result:=WriteDataToFile(PChar(FileName),MaxSize);
end;

//==============================================================================================================================
initialization
finalization
  if DLLHandle<>0 then FreeLibrary(DLLHandle); // Free global instance
end.

