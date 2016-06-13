unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, IBDatabase, StdCtrls, IBCustomDataSet, IBQuery,ComObj,ActiveX,
  OverbyteIcsWndControl, OverbyteIcsFtpCli, ExtCtrls,freehand,SZCodeBaseX,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,IdMultiPartFormData,IdGlobalProtocols, IdCoder,uSourceCodeConverter,
  IdCoder3to4, IdCoderMIME,cl_mpegvinfo, ComCtrls, Menus,MPEG2Lib,Math, pngimage,jpeg,uBase64,
  IdMessage, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,IdThread;


type
TSMTP_N_Thread = class(TIdThread)
  public
   Host     : string;
   Port     : integer;
   Login    : string;
   Password : string;
   EMailTo  : string;
   EMailFrom: string;
   OrganFrom: string;
   EMailSubject: string;
   Letter   : string;
   lFiles   : TStringList;
   destructor Destroy; override;
   procedure Run; override;
  end;

type
TInjestThread = class(TThread)
private
command:integer;
protected
procedure Execute; override;
public
constructor Create(CreateSuspennded: Boolean; const c: integer);
end;

type
TScanDirThread = class(TThread)
private

protected
procedure Execute; override;
public
constructor Create(CreateSuspennded: Boolean);
end;



TYPE
TSendEventto = record
  width,height:string;
  filename:string;
  size:string;
  duration:string;
  imagebase64:string;
end;

TYPE
TSMTPConfig = packed record
  smtphost:string[25];
  smtpport:integer;
  smtpuser:string[25];
  smtppassword:string[25];
  email:string[50];
  from:string[50];
  subject:string[50];
end;

Type
THeaderAddFile = record
id:string;
SAVE_STAMP:string;
MODIFIED:string;
remove_date:string;
updated_date:string;
creation_date:string;
file_extension:string;
id_master_asset_element:string;
id_category:string;
asset_string:string[50];
custom_metadata:string;
type_metadata:string;
search:string;
status_int:string;
status_string:string;
external_ref:string;
asset_host_ip:string;
asset_host_port:string;
filesize:string;
thumnail:string;
end;


Type
TParse_id_savestamp = packed record
id:string[10];
save_stamp:string[20];
end;

type
TParse_systemtime = packed record
  date:string[12];
  time:string[12];
  datetime:string[20];
end;

Type
Tconfig = record
custom_metadata:string;
asset_string:string[50];
asset_id:integer;
search:string[255];
external_ref:string[255];
cobalt_host:string[15];
cobalt_port:integer;
source_path:string[255];
monitoring_wait:integer;
file_extension:string[5];
view_subfolders:boolean;
delta_temp_path:string[255];
delete_source:boolean;
SMTPConfig :TSMTPConfig;
end;

Type
TTRANSFERMETADATA = packed record
  protocol:byte;
  user:string[25];
  pasword:string[25];
  host:string[25];
  port:cardinal;
  path:string[100];
end;

type
  TForm1 = class(TForm)
    FtpClient1: TFtpClient;
    Panel3: TPanel;
    Shape7: TShape;
    Label14: TLabel;
    Panel7: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Image4: TImage;
    Image11: TImage;
    Image12: TImage;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel18: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel26: TPanel;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Timer1: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel27: TPanel;
    Image5: TImage;
    Label4: TLabel;
    Panel28: TPanel;
    Image17: TImage;
    Panel29: TPanel;
    Image18: TImage;
    Label1: TLabel;
    Panel30: TPanel;
    Image19: TImage;
    Label2: TLabel;
    Panel31: TPanel;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Panel32: TPanel;
    ListBox1: TListBox;
    Shape1: TShape;
    Panel33: TPanel;
    Panel37: TPanel;
    Shape2: TShape;
    Shape3: TShape;
    ProgressBar1: TProgressBar;
    Image23: TImage;
    Label3: TLabel;
    Label5: TLabel;
    Image24: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Timer2: TTimer;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label8: TLabel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    clear1: TMenuItem;
    clear2: TMenuItem;
    clear3: TMenuItem;
    Label9: TLabel;
    PopupMenu4: TPopupMenu;
    a1: TMenuItem;
    procedure ScanDir(StartDir: string; Mask: string; List: TStrings; error_list:TStrings);
    function IsFileInUse(FileName: TFileName): Boolean;
    Function GetTRANSFERMETADATA(xmlstring:string;protocol:byte):TTRANSFERMETADATA;
    Function xml_get_asset_type_from_id(id:string):string;
    Function Get_Asset_From_ID(id:string):string;
    procedure Panel13Click(Sender: TObject);
    Function xml_get_all_asset:string;
    Function xml_get_asset_from_id(id:string):string;
    procedure AssetMousedown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function xml_querty_sql(sql:string):string;
    procedure Panel12MouseEnter(Sender: TObject);
    procedure Panel12MouseLeave(Sender: TObject);
    Procedure AssetMousEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure LoadConfig;
    function xml_add_asset_element_new:string;
    function parse_id_savestamp(xmlcontent:string):TParse_id_savestamp;
    function xml_GetSystemTime:string;
    function parse_systemtime(xmlcontent:string):TParse_systemtime;
    function xml_MODIFIED_asset_element_new:string;
    Function ReadMpeg2Info(filename:string; remove_date:string):string;
    Function xml_getcollection:string;
    Function xml_CobaltDataBase_Store:string;
    Function xml_CobaltDataBase_Store_filesize:string;
    Function xml_CobaltDataBase_Store_xfer(xfer:string):string;
    Procedure copyfile(source,dest: string);
    Function xml_sqlquerty(querty:string):string;
    procedure Timer1Timer(Sender: TObject);
    Function ChackFileInDB(filename:string):boolean;
    procedure Image18MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image19MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    Function AddFileToDB(filename:string):boolean;
    Function GetStatusStringFromAssetID(asser_id:string):string;
    Function ResizeBitmap(image:TBitmap):TBitmap;
    procedure clear1Click(Sender: TObject);
    procedure clear2Click(Sender: TObject);
    procedure clear3Click(Sender: TObject);
    Function GetBitmapFromMpeg(filename:string; framenumber:cardinal):string;
    procedure Panel18Click(Sender: TObject);
    procedure Panel12Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    Function SendEvent(messages:string):boolean;
    procedure IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure disconnect;
    procedure Connected;
    procedure ThreadTerminated(ASender: TObject);
    procedure Label14DblClick(Sender: TObject);
    Function GetBitmapFromFFMpeg(filename:ansistring; framenumber:cardinal):string;
    procedure a1Click(Sender: TObject);
  private
    { Private declarations }
    TaskScanDir, TaskInjest:cardinal;
  public
      Stream:TMemoryStream;
      MPEG2Decoder : TMPEG2Decoder;
      terminateprogram:boolean;
  end;

var
  Form1: TForm1;
  config:Tconfig;
  HeaderAddFile:THeaderAddFile;
  InjestThread:TInjestThread;
  ScanDirThread:TScanDirThread;
  SendEventto:TSendEventto;


implementation

uses Unit2, Unit3,Unit4, Unit5,   avformat, avcodec, avutil, swscale,TasksEx;

{$R *.dfm}
var
  //FFMPEG
  packet: TAVPacket;
  bytesRemaining: integer = 0;
  rawMpegData: SysUtils.PByteArray;
  fFirstTime: boolean = true;

function StrToHEX(text: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(text) do
  begin
    Result := Result + '$50'+InttoHex(ord(text[i]), 2);
  end;
end;



procedure TForm1.Connected;
begin
listbox1.Items.Add('connect');
end;

procedure TForm1.disconnect;
begin
listbox1.Items.Add('disconnect');
end;


procedure TSMTP_N_Thread.Run;
var
 SMTP  : TIdSMTP;
 Msg   : TIdMessage;
 lFiles: TStringList;
 i     : integer;

begin
 SMTP:=TIdSMTP.Create(NIL);
 // SMTP.AuthenticationType:=atLogin;
  SMTP.Host    :=Host;
  SMTP.Port    :=Port;
  SMTP.UserName:=Login;
  SMTP.Password:=Password;
 try
// Synchronize(form1.Connected);
  SMTP.Connect;
  Msg :=TIdMessage.Create(SMTP);
try
    with Msg do
     begin
      Date      := Now;
      Subject   := EMailSubject;
      From.Text := EMailFrom;
      Recipients.EMailAddresses := EMailTo;
      Organization := OrganFrom;
      ContentType  := 'text/html';
      CharSet      := 'Windows-1251';
      Priority     := mpHighest;
      Body.Add(Letter);
     end;
   {  for i:=0 to lFiles.Count-1 do
      TIdAttachment.Create(Msg.MessageParts ,lFiles[i]);  }
     SMTP.Send(Msg);
finally
  Msg.Free;
end;
 finally
// Synchronize(form1.disconnect);
  SMTP.Disconnect;
  SMTP.Free;
 end;
 Stop;
end;

destructor TSMTP_N_Thread.Destroy;
begin
 FreeAndNil(lFiles);
 inherited Destroy;
end;


procedure TForm1.ThreadTerminated(ASender: TObject);
var
s: string;
begin
s := TIdThread(ASender).TerminatingException;
if Length(s) > 0 then
form5.ListBox1.Items.Insert(0,'An error occurred while sending message. ' + s+' - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now))
else
form5.ListBox1.Items.Insert(0,'Message send! - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
end;


//InjestThread := TInjestThread.Create(false,2);

constructor TInjestThread.Create(CreateSuspennded: Boolean; const c: integer);
begin
inherited Create(CreateSuspennded);
FreeOnTerminate := True;
command :=c;
end;


procedure TInjestThread.Execute;
var
temp_item:string;
i:integer;
messages:TStringList;
msg:TIdMessage;
smtp:TIdSMTP;
begin
form1.timer2.Enabled:=false;
form1.timer1.Enabled:=false;
//showmessage('123');
//exit;
if form1.listbox1.Items.Count<=0 then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if not fileexists(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if IsFileInUse(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if form1.ChackFileInDB(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;

temp_item:=form1.listbox1.Items.Strings[0];
form1.label5.Caption:=form1.listbox1.Items.Strings[0];
SendEventto.filename:='';
SendEventto.duration:='';
SendEventto.imagebase64:='';
SendEventto.width:='';
SendEventto.height:='';
SendEventto.size:='';
if form1.AddFileToDB(temp_item) then
begin


try
messages:=TStringList.Create;
messages.Add('<html>');
messages.Add('<h1>File <b>['+SendEventto.filename+']</b> injest <b>OK</b></h1>');
messages.Add('<br>');
messages.Add('<b>Size: </b>'+SendEventto.size);
messages.Add('<br>');
messages.Add('<b>Duration: </b>'+SendEventto.duration);
messages.Add('<br>');
messages.Add('<b>Width/Height: </b>'+SendEventto.width+'/'+SendEventto.height);
messages.Add('<br>');
messages.Add('<br>');
messages.Add('<img src="data:image/jpeg;base64,'+SendEventto.imagebase64+'"/>');
messages.Add('</html>');
config.SMTPConfig.subject:=SendEventto.filename+' injest OK';
form1.SendEvent(messages.Text);
finally
messages.Free;
end;
form1.listbox2.Items.Add(form1.listbox1.Items.Strings[0]);
form5.ListBox1.Items.Insert(0,'Injest finished ['+form1.listbox1.Items.Strings[0]+'] to Cobalt '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
if config.delete_source then
if deletefile(form1.listbox1.Items.Strings[0]) then form5.ListBox1.Items.Insert(0,'Delete file ['+form1.listbox1.Items.Strings[0]+'] -'+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now)) else
form5.ListBox1.Items.Insert(0,'Failed delete file ['+form1.listbox1.Items.Strings[0]+'] - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
form1.listbox1.Items.Delete(0);
end else begin
form1.listbox3.Items.Add(form1.listbox1.Items.Strings[0]);
form5.ListBox1.Items.Insert(0,'Injest failed ['+form1.listbox1.Items.Strings[0]+'] to Cobalt '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
form1.listbox1.Items.Delete(0);
end;
form1.label5.Caption:='-';
form1.label8.Caption:='status: [-]';
form1.progressbar1.Position:=0;
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
end;




constructor TScanDirThread.Create(CreateSuspennded: Boolean);
begin
inherited Create(CreateSuspennded);
FreeOnTerminate := True;
end;


procedure TScanDirThread.Execute;
begin
form1.timer1.Enabled:=false;
form1.ScanDir(config.source_path, '', form1.listbox1.items,form1.listbox3.items);
form1.timer1.Enabled:=true;
end;


procedure DoSomethingWithTheImage (pCodecCtx: PAVCodecContext; pFrameRGB: PAVFrame;BitmapRGB:TBitmap);
var
  i: integer;
begin
  try
    BitmapRGB.PixelFormat := pf32bit;
    BitmapRGB.Width := pCodecCtx.width;
    BitmapRGB.Height := pCodecCtx.height;

    for i := 0 to BitmapRGB.Height - 1 do
      CopyMemory ( BitmapRGB.ScanLine [i], pointer (integer (pFrameRGB.data [0]) + BitmapRGB.Width * 4 * i), BitmapRGB.Width * 4 );

    bitmapRGB.SaveToFile ( format ( 'D:\example_%d.bmp', [GetTickCount] ) );
  finally
   ;
  end;

end;

function GetNextFrame (pFormatCtx: PAVFormatContext; pCodecCtx: PAVCodecContext;
                       videoStream: integer; pFrame: PAVFrame): boolean;
var
  bytesDecoded, frameFinished: integer;
label
  loop_exit;
begin
  if fFirstTime then
  begin
    fFirstTime := false;
    packet.data := nil;
  end;

  Result := false;
  while true do
  begin

    while bytesRemaining > 0 do
    begin

      bytesDecoded := avcodec_decode_video ( pCodecCtx, pFrame, frameFinished, rawMpegData, bytesRemaining );

      if bytesDecoded < 0 then
      begin
        ShowMessage ( 'Error while decoding frame' );
        exit;
      end;

      dec ( bytesRemaining, bytesDecoded );
      inc ( rawMpegData, bytesDecoded );

      if frameFinished <> 0 then
      begin
        Result := true;
        exit;
      end;
//        }
    end;

    repeat
      if av_read_packet ( pFormatCtx, packet ) < 0 then
        goto loop_exit;
    until packet.stream_index = videoStream;

    bytesRemaining := packet.size;
    rawMpegData := packet.data;

  end;

loop_exit:
  bytesDecoded := avcodec_decode_video ( pCodecCtx, pFrame, frameFinished, rawMpegData, bytesRemaining );
  if packet.data <> nil then
    av_free_packet ( @packet );

  Result := frameFinished <> 0;
end;

Function TForm1.GetBitmapFromFFMpeg(filename:ansistring; framenumber:cardinal):string;
 const
   TrackBlockSize = 10*1024;
   maxWidth = 120;
   maxHeight = 96;
var
  Frame : SysUtils.PByteArray;
  Y : Integer;
  temp:TBitmap;
  thumbRect : TRect;
  j:TJPEGImage;
  temp_s:TMemoryStream;
  count:integer;
  //FFMPEG
  pFormatCtx: PAVFormatContext;
  pCodecCtx: PAVCodecContext;
  pCodec: PAVCodec;
  pFrame: PAVFrame;
  pFrameRGB: PAVFrame;
  pScaleCtx: PSwsContext;
  numBytes: integer;
  buffer: PByte;

  i, videoStream: integer;

begin
if not fileexists(filename) then exit;
try
 count:=0;
  result:='';
  //thumnails.Assign(nil);
  Temp:=TBitmap.Create;

   av_register_all();

  //  AMGetWideString(pfilename, Char(FileName));

  if av_open_input_file ( pFormatCtx,PAnsiChar(filename), nil, 0, nil ) <> 0 then
    raise exception.Create ( 'WTF?! Couldn''t open file!!!' );

  if av_find_stream_info ( pFormatCtx ) < 0 then
    raise exception.Create ( 'WTF?! Couldn''t find stream information!!!' );

  dump_format ( pFormatCtx, 0, PAnsiChar(filename), 0 ); // <<<<<< i dont know how its works
  videoStream := -1;
  for i := 0 to pFormatCtx.nb_streams - 1 do
  begin
    if pFormatCtx.streams [i].codec.codec_type =  AVMEDIA_TYPE_VIDEO then
    begin
      videoStream := i;
      break;
    end;
  end;

  if videoStream = -1 then
    raise exception.Create ( 'WTF?! Didn''t find a video stream!' );

  pCodecCtx := pFormatCtx.streams [videoStream].codec;

  pCodec := avcodec_find_decoder ( pCodecCtx.codec_id );
  if pCodec = nil then
    raise exception.Create ( 'WTF?! Codec not found!' );

  if ( pCodec.capabilities and CODEC_CAP_TRUNCATED ) = CODEC_CAP_TRUNCATED then
    pCodecCtx.flags := pCodecCtx.flags or CODEC_FLAG_TRUNCATED;

  if avcodec_open ( pCodecCtx, pCodec ) < 0 then
    raise exception.Create ( 'WTF?! Could not open codec!' );

  if ( pCodecCtx.time_base.num > 1000 ) and ( pCodecCtx.time_base.den = 1 ) then
    pCodecCtx.time_base.den := 1000;

  pFrame := avcodec_alloc_frame();

  pFrameRGB := avcodec_alloc_frame;
  avpicture_alloc ( PAVPicture (pFrameRGB), PIX_FMT_RGB32, pCodecCtx.width, pCodecCtx.height );
  pScaleCtx := sws_getContext ( pCodecCtx.width, pCodecCtx.height, pCodecCtx.pix_fmt,
                                pCodecCtx.width, pCodecCtx.height, PIX_FMT_RGB32, SWS_BICUBIC, nil, nil, nil  );
  try
  SendEventto.width:=inttostr(pCodecCtx.width);
  except
  SendEventto.width:='';
  end;
  try
  SendEventto.height:=inttostr(pCodecCtx.height);
  except
  SendEventto.height:='';
  end;

  if ((pCodecCtx.width=720) and (pCodecCtx.height=576)) then
  begin
  while GetNextFrame ( pFormatCtx, pCodecCtx, videoStream, pFrame ) do
  begin
    sws_scale ( pScaleCtx, @pFrame.data, @pFrame.linesize,
                0, pCodecCtx.height,
                @pFrameRGB.data, @pFrameRGB.linesize );

    if count>=framenumber then
    begin
    DoSomethingWithTheImage( pCodecCtx, pFrameRGB,Temp);
    break;
    end;
    inc(count);
  end;
  end;



  sws_freeContext ( pScaleCtx );
  avpicture_free ( PAVPicture (pFrameRGB) );
  av_free ( pFrameRGB );
  av_free ( pFrame );
  avcodec_close ( pCodecCtx );
  av_close_input_file ( pFormatCtx );

  if ((pCodecCtx.width=720) and (pCodecCtx.height=576)) then
  begin
  try
  thumbRect.Left := 0;
  thumbRect.Top := 0;
  if temp.Width > temp.Height then
  begin
  thumbRect.Right := maxWidth;
  thumbRect.Bottom := (maxWidth * temp.Height) div temp.Width;
  end
  else
  begin
  thumbRect.Bottom := maxHeight;
  thumbRect.Right := (maxHeight * temp.Width) div temp.Height;
  end;
  temp.Canvas.StretchDraw(thumbRect, temp) ;
//resize image
  temp.Width := thumbRect.Right;
  temp.Height := thumbRect.Bottom;

  try
  try
  j:=TJPEGImage.Create;
  j.Assign(temp);
  temp_s:=TMemoryStream.Create;
  j.SaveToStream(temp_s);
  result:=uBase64.encode_base64(temp_s);
  except
  end;
 // j.SaveToFile('D:\zdima.jpg');
  finally
  j.Free;
  temp_s.Free;
  end;

//display in a TImage control
 // thumnails.Assign(temp);
  except
  ;
  end;
end;
  finally
    temp.Free;
  end;

end;



function StreamGetCallback(Offset: Int64; Buffer: Pointer; Count: DWord; Owner: TObject): DWord; stdcall;
begin
  Result:=Min(Count,Form1.Stream.Size-Offset);
  Move(PByteArray(Form1.Stream.Memory)^[Offset],Buffer^,Result);
end;


Function TForm1.GetBitmapFromMpeg(filename:string; framenumber:cardinal):string;
 const
   TrackBlockSize = 10*1024;
   maxWidth = 120;
   maxHeight = 96;
var
  Frame : SysUtils.PByteArray;
  Y : Integer;
  temp:TBitmap;
  thumbRect : TRect;
  j:TJPEGImage;
  temp_s:TMemoryStream;
begin
if not fileexists(filename) then exit;
try
  result:='';
  //thumnails.Assign(nil);
  Temp:=TBitmap.Create;
  MPEG2Decoder:=TMPEG2Decoder.Create;
  Stream:=TMemoryStream.Create;
  Stream.LoadFromFile(filename);
  MPEG2Decoder.OpenStream(StreamGetCallback,True,Stream.Size,Self);
  MPEG2Decoder.PixelFormat:=vpfRGB24;
  temp.PixelFormat:=pf24bit;
  temp.Width:=MPEG2Decoder.FrameWidth;
  temp.Height:=MPEG2Decoder.FrameHeight;
 // MPEG2Decoder.Position:=Int64(MPEG2Decoder.StreamSize-(TrackBlockSize));
  MPEG2Decoder.Position:=Int64(framenumber*TrackBlockSize);
  Frame:=MPEG2Decoder.DecodeFrame;
  if Assigned(Frame) then
  begin
    for Y:=0 to MPEG2Decoder.FrameHeight-1 do
      Move(Frame^[Y*MPEG2Decoder.FrameWidth*3],temp.ScanLine[MPEG2Decoder.FrameHeight-1-Y]^,MPEG2Decoder.FrameWidth*3);
   // Image1.Repaint;
  end;
  try
  thumbRect.Left := 0;
  thumbRect.Top := 0;
  if temp.Width > temp.Height then
  begin
  thumbRect.Right := maxWidth;
  thumbRect.Bottom := (maxWidth * temp.Height) div temp.Width;
  end
  else
  begin
  thumbRect.Bottom := maxHeight;
  thumbRect.Right := (maxHeight * temp.Width) div temp.Height;
  end;
  temp.Canvas.StretchDraw(thumbRect, temp) ;
//resize image
  temp.Width := thumbRect.Right;
  temp.Height := thumbRect.Bottom;

  try
  try
  j:=TJPEGImage.Create;
  j.Assign(temp);
  temp_s:=TMemoryStream.Create;
  j.SaveToStream(temp_s);
  result:=uBase64.encode_base64(temp_s);
  except
  end;
 // j.SaveToFile('D:\zdima.jpg');
  finally
  j.Free;
  temp_s.Free;
  end;

//display in a TImage control
 // thumnails.Assign(temp);
  except
  ;
  end;
  finally
    MPEG2Decoder.Free;
    Stream.Free;
    temp.Free;
  end;

end;


Function TForm1.SendEvent(messages:string):boolean;
var Msg:TIdMessage;
begin
try
   with TSMTP_n_Thread.Create do
    begin
     Host     :=config.SMTPConfig.smtphost;
     Port     :=config.SMTPConfig.smtpport;
     Login    :=config.SMTPConfig.smtpuser;
     Password :=config.SMTPConfig.smtppassword;
     EMailFrom:=config.SMTPConfig.from;
     EMailSubject:=config.SMTPConfig.subject;
     Letter   :=messages;
     EMailTo  :=config.SMTPConfig.email;
     FreeOnTerminate := True;
     OnTerminate := ThreadTerminated;
     Start;
    end;
except
;
 end;
{result:=false;
//Msg:=TIdMessage.Create(nil);
listbox2.Items.Add('1');
try
listbox2.Items.Add('2');
IdMessage1.Body.Append(messages);
IdMessage1.Recipients.EMailAddresses:=config.SMTPConfig.email;
listbox2.Items.Add('3');
IdMessage1.From.Text:=config.SMTPConfig.from;
IdMessage1.ContentType:='text/html';
IdMessage1.Subject:=config.SMTPConfig.subject;
listbox2.Items.Add('4');
idsmtp1.Connect;
listbox2.Items.Add('5');
idsmtp1.Send(IdMessage1);
listbox2.Items.Add('6');
idsmtp1.Disconnect;
listbox2.Items.Add('7');
finally
//msg.Free;
listbox2.Items.Add('8');
result:=true;
end;  }

end;


Function TForm1.ResizeBitmap(image:TBitmap):TBitmap;
const
maxWidth = 120;
maxHeight = 96;
 var
 thumbnail : TBitmap;
 thumbRect : TRect;
 begin
 thumbnail := TBitmap.Create;
 thumbnail.Assign(image);
 try
 thumbRect.Left := 0;
 thumbRect.Top := 0;
 //proportional resize
 if thumbnail.Width > thumbnail.Height then
 begin
 thumbRect.Right := maxWidth;
 thumbRect.Bottom := (maxWidth * thumbnail.Height) div thumbnail.Width;
 end
 else
 begin
 thumbRect.Bottom := maxHeight;
 thumbRect.Right := (maxHeight * thumbnail.Width) div thumbnail.Height;
 end;
 thumbnail.Canvas.StretchDraw(thumbRect, thumbnail) ;
//resize image
thumbnail.Width := thumbRect.Right;
thumbnail.Height := thumbRect.Bottom;
//display in a TImage control
result.Assign(thumbnail);
finally
thumbnail.Free;
end;
end;





Function TForm1.GetStatusStringFromAssetID(asser_id:string):string;
var
temp:TStringList;
resulthttp:string;
temp_str:string;
begin
temp:=TStringList.Create;
//GET  creation_date------------------------------------------------------
temp.text:=xml_get_asset_from_id(asser_id);
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
temp_str:=copy(resulthttp,pos('status_string',resulthttp),150);
temp_str:=copy(temp_str,pos('FIELD_VALUE',temp_str),150);
temp_str:=copy(temp_str,pos('<string>',temp_str)+8,150);
temp_str:=copy(temp_str,1,pos('</string>',temp_str)-1);
result:=temp_str;
temp.Free

end;

procedure TForm1.a1Click(Sender: TObject);
begin
if TaskInjest<>0 then
begin
AbortWorkerThread(TaskInjest);
TaskInjest:=0;
form1.label5.Caption:='-';
form1.label8.Caption:='status: [-]';
form1.progressbar1.Position:=0;
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
end;
end;

Function TForm1.AddFileToDB(filename:string):boolean;
var
Data:TIdMultiPartFormDataStream;
resulthttp:string;
temp:TStringlist;
SAVE_STAMP:string;
temp_string:string;
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
r_Parse_idsavestamp:TParse_id_savestamp;
r_parse_systemtime:TParse_systemtime;
temp_status:string;
custom_metadata:string;
unicodestring:string;
dest,source,random_S,temp_s:string;
begin
form5.ListBox1.Items.Insert(0,'Start injest ['+listbox1.Items.Strings[0]+'] to Cobalt '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
result:=false;
//HeaderAddFile.thumnail:=GetBitmapFromMpeg(filename,5);
HeaderAddFile.thumnail:=GetBitmapFromFFMpeg(filename,5);
HeaderAddFile.id:='-1';
HeaderAddFile.SAVE_STAMP:='0';
HeaderAddFile.MODIFIED:='1';
HeaderAddFile.remove_date:='0';
HeaderAddFile.updated_date:='0';
HeaderAddFile.creation_date:='0';
HeaderAddFile.file_extension:=config.file_extension;
HeaderAddFile.id_master_asset_element:='0';
HeaderAddFile.id_category:='';//inttostr(config.asset_id);
HeaderAddFile.asset_string:=config.asset_string;
custom_metadata:=config.custom_metadata;
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$yyyy',formatdatetime('YYYY',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$MM',formatdatetime('MM',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$dd',formatdatetime('dd',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$HH',formatdatetime('HH',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$mm',formatdatetime('nn',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$ss',formatdatetime('ss',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$zzz',formatdatetime('zzz',now));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$fn',sysutils.ExtractFileName(filename));
Randomize;
random_S:=inttostr(random(100));
custom_metadata:=freehand.ReplaceSub(custom_metadata,'$r[100]',random_S);


temp_s:='$yyyy';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('YYYY',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$MM';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('MM',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$dd';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('dd',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$HH';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('HH',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$mm';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('mm',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$ss';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('ss',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$zzz';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=formatdatetime('zzz',now);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$fn';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=sysutils.ExtractFileName(filename);
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);

temp_s:='$r[100]';
source:='';
for j := 1 to length(temp_s) do
source:=source+'u'+inttostr(ord(temp_s[j]));
temp_s:=random_s;
dest:='';
for j := 1 to length(temp_s) do
dest:=dest+'u'+inttostr(ord(temp_s[j]));
custom_metadata:=freehand.ReplaceSub(custom_metadata,source,dest);


HeaderAddFile.custom_metadata:=freehand.EncodeBase64(custom_metadata);
temp_string:=ReadMpeg2Info(filename,formatdatetime('yyyy-mm-dd',now+186));

if temp_string='<XML></XML>' then
begin
//delete
exit;
end;

HeaderAddFile.type_metadata:=freehand.EncodeBase64(temp_string);
HeaderAddFile.search:=config.search;
HeaderAddFile.status_int:='2';
HeaderAddFile.status_string:='-';
HeaderAddFile.external_ref:=config.external_ref;
HeaderAddFile.asset_host_ip:='not_used';
HeaderAddFile.asset_host_port:='0';
HeaderAddFile.filesize:=inttostr(GetFileSize(filename));


if IsFileInUse(filename) then
begin
form5.ListBox1.Items.Insert(0,'Error: file ['+listbox1.Items.Strings[0]+'] in use - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
exit;
end;

if not directoryexists('\\'+config.cobalt_host+config.delta_temp_path) then
begin
//delete asset from id
  exit;
end;

temp:=TStringList.Create;
//GET  creation_date------------------------------------------------------
temp.text:=xml_GetSystemTime;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
r_parse_systemtime:=parse_systemtime(resulthttp);
HeaderAddFile.creation_date:=r_parse_systemtime.datetime;
// END ----------------------------------------------------------------------
temp.Clear;
temp_string:=xml_add_asset_element_new;
temp.Text:=temp_string;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
r_Parse_idsavestamp:=parse_id_savestamp(resulthttp);
HeaderAddFile.id:=r_Parse_idsavestamp.id;
HeaderAddFile.SAVE_STAMP:=r_Parse_idsavestamp.save_stamp;
temp.Clear;
temp.Text:=form1.xml_MODIFIED_asset_element_new;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
HeaderAddFile.status_int:='2';
temp.Clear;
temp.Text:=form1.xml_getcollection;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
HeaderAddFile.status_int:='4';
temp.Clear;
temp.Text:=form1.xml_CobaltDataBase_Store;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
temp.Clear;
temp.Text:=form1.xml_CobaltDataBase_Store_filesize;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
temp_string:='a';
for i:=1 to  7-length(HeaderAddFile.id) do  temp_string:=temp_string+'0';
temp_string:=temp_string+HeaderAddFile.id+'.mpg';





copyfile(filename,'\\'+config.cobalt_host+config.delta_temp_path+temp_string);

if GetFileSize(filename)<>GetFileSize('\\'+config.cobalt_host+config.delta_temp_path+temp_string) then
begin
 //delete asset from id;
  exit;
end;

for I := 1 to 30 do
begin
sleep(50);
application.ProcessMessages;
end;

temp.Clear;
label8.Caption:='status: [xfer 100%]';
temp.Text:=xml_CobaltDataBase_Store_xfer('xfer 100%');
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;

for I := 1 to 30 do
begin
sleep(50);
application.ProcessMessages;
end;

HeaderAddFile.status_int:='5';
temp.Clear;
temp.Text:=form1.xml_CobaltDataBase_Store;
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
;
end;
temp_status:='Weit status: '+inttostr((((strtoint(HeaderAddFile.filesize) div 1024) div 1024) * 4))+' / ';
for I := 0 to (((strtoint(HeaderAddFile.filesize) div 1024) div 1024) div 5) do
begin
sleep(5000);
label8.Caption:='status: ['+GetStatusStringFromAssetID(HeaderAddFile.id)+']';
if label8.Caption='status: [finished]' then
begin
result:=true;
break;
end;
label8.Hint:=temp_status+inttostr(i);
application.ProcessMessages;
end;
temp.Free;
end;


Function TForm1.ChackFileInDB(filename:string):boolean;
var
temp:TStringList;
resulthttp:string;
searchfile:string;
begin
result:=false;
resulthttp:='';
if not fileexists(filename) then exit;
try
try
temp:=TStringList.Create;
searchfile:=ExtractFileName(filename);
searchfile:=copy(searchfile,1,pos(ExtractFileExt(searchfile),searchfile)-1);
temp.text:=xml_sqlquerty('select ASSET_STRING,STATUS_STRING,TYPE_METADATA,FILESIZE_1 from ASSET_ELEMENT WHERE TYPE_METADATA LIKE ''%'+searchfile+'%'' and FILESIZE_1='+inttostr(freehand.GetFileSize(filename))+'');
try
resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
except
form5.ListBox1.Items.Insert(0,'PubliTronic Cobalt DXMLRPC SERVER '+'[http://'+config.cobalt_host+':'+inttostr(config.cobalt_port)+'] not response! - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
result:=true;
end;
if pos('ASSET_STRING',resulthttp)>0 then   result:=true;
except
end;
finally
temp.Free;
end;


end;

Function TForm1.xml_sqlquerty(querty:string):string;
begin
//select * from ASSET_ELEMENT WHERE TYPE_METADATA LIKE '%a0006268%'
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.MultiRequest</methodName>'+
'<params>'+
'<param><value><struct>'+
'<member><name>SQL_STRING</name>'+
'<value><string>'+querty+'</string></value></member>'+
'</struct></value></param>'+
'</methodCall>';
end;


procedure TForm1.clear1Click(Sender: TObject);
begin
listbox1.Items.Clear;
end;

procedure TForm1.clear2Click(Sender: TObject);
begin
listbox2.Items.Clear;
end;

procedure TForm1.clear3Click(Sender: TObject);
begin
listbox3.Items.Clear;
end;

Procedure TForm1.copyfile( source,dest: string);
var
  SrcFile, DestFile: file;
  BytesRead, BytesWritten, TotalRead: Integer;
  Buffer: array[1..8192] of byte;
  FSize: Integer;
  procent:integer;
  temp:TStringList;
  resulthttp:string;
begin
  temp:=TStringList.Create;
  procent:=0;
  AssignFile(SrcFile,  source);
  AssignFile(DestFile, dest);
  Reset(SrcFile, 1);
  try
    Rewrite(DestFile, 1);
    try
      try
        TotalRead := 0;
        FSize := FileSize(SrcFile);
        repeat
          BlockRead(SrcFile, Buffer, SizeOf(Buffer), BytesRead);
          if BytesRead > 0 then
          begin
            BlockWrite(DestFile, Buffer, BytesRead, BytesWritten);
            if BytesRead <> BytesWritten then
              raise Exception.Create('Error copying file')
            else
            begin
              TotalRead := TotalRead + BytesRead;
              if procent<>TotalRead div (Fsize div 100) then
              begin
              temp.Clear;
              label8.Caption:='status: [xfer '+inttostr(procent)+'%]';
              temp.Text:=xml_CobaltDataBase_Store_xfer('xfer '+inttostr(procent)+'%');
              try
              resulthttp:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), temp);
              except
              ;
              end;
              end;
              procent:=TotalRead div (Fsize div 100);
              progressbar1.Position := procent;
              progressbar1.Update;
            end;
          end;
          application.ProcessMessages;
        until BytesRead = 0;
      except
        Erase(DestFile);
        raise;
      end;
    finally
      CloseFile(DestFile);
    end;
  finally
    CloseFile(SrcFile);
  end;
  temp.free;

end;


Function TForm1.xml_CobaltDataBase_Store_filesize:string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.Store</methodName>'+
'<params>'+
'<param><value><string>asset_element</string></value></param>'+
'<param><value><struct>'+
'<member><name>ID</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value></member>'+
'<member><name>SAVE_STAMP</name>'+
'<value><string>0</string></value></member>'+
'<member><name>MODIFIED</name>'+
'<value><boolean>'+HeaderAddFile.MODIFIED+'</boolean></value></member>'+
'<member><name>NEW</name>'+
'<value><boolean>0</boolean></value></member>'+
'</struct></value></param>'+
'<param><value><array><data>'+
'<value><int>1</int></value>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string>filesize_1</string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.filesize+'</string></value></member>'+
'<member><name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value></member>'+
'</struct></value>'+
'</data></array></value></param>'+
'</params>'+
'</methodCall>';
end;


Function TForm1.xml_CobaltDataBase_Store:string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.Store</methodName>'+
'<params>'+
'<param><value><string>asset_element</string></value></param>'+
'<param><value><struct>'+
'<member><name>ID</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value></member>'+
'<member><name>SAVE_STAMP</name>'+
'<value><string>0</string></value></member>'+
'<member><name>MODIFIED</name>'+
'<value><boolean>'+HeaderAddFile.MODIFIED+'</boolean></value></member>'+
'<member><name>NEW</name>'+
'<value><boolean>0</boolean></value></member>'+
'</struct></value></param>'+
'<param><value><array><data>'+
'<value><int>1</int></value>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string>status_int</string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><int>'+HeaderAddFile.status_int+'</int></value></member>'+
'<member><name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value></member>'+
'</struct></value>'+
'</data></array></value></param>'+
'</params>'+
'</methodCall>';

end;

Function TForm1.xml_CobaltDataBase_Store_xfer(xfer:string):string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.Store</methodName>'+
'<params>'+
'<param><value><string>asset_element</string></value></param>'+
'<param><value><struct>'+
'<member><name>ID</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value></member>'+
'<member><name>SAVE_STAMP</name>'+
'<value><string>0</string></value></member>'+
'<member><name>MODIFIED</name>'+
'<value><boolean>'+HeaderAddFile.MODIFIED+'</boolean></value></member>'+
'<member><name>NEW</name>'+
'<value><boolean>0</boolean></value></member>'+
'</struct></value></param>'+
'<param><value><array><data>'+
'<value><int>1</int></value>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string>status_string</string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><string>'+xfer+'</string></value></member>'+
'<member><name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value></member>'+
'</struct></value>'+
'</data></array></value></param>'+
'</params>'+
'</methodCall>';
end;


Function TForm1.xml_getcollection:string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.GetCollection</methodName>'+
'<params>'+
'<param><value><struct>'+
'<member><name>OBJECT_TYPE</name>'+
'<value><string>asset_element</string></value></member>'+
'<member><name>LOGICAL_OPERATOR</name>'+
'<value><string>AND</string></value></member>'+
'<member><name>CRITERIA_TYPE</name>'+
'<value><string>EQUALS</string></value></member>'+
'<member><name>FIELD</name>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string>id</string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value></member>'+
'</struct></value></member>'+
'</struct></value></param>'+
'<param><value><struct>'+
'<member><name>OBJECT_TYPE</name>'+
'<value><string>asset_element</string></value></member>'+
'<member><name>LOGICAL_OPERATOR</name>'+
'<value><string>AND</string></value></member>'+
'<member><name>CRITERIA_TYPE</name>'+
'<value><string>EQUALS</string></value></member>'+
'<member><name>FIELD</name>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string>status_int</string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><int>'+HeaderAddFile.status_int+'</int></value></member>'+
'</struct></value></member>'+
'</struct></value></param>'+
'</params>'+
'</methodCall>';
end;


Function TForm1.ReadMpeg2Info(filename:string; remove_date:string):string;
var
sizeinmb:extended;
MPEGVideoFile:TMPEGVideoFile;
hour,min,sec,msec:word;
frame:word;
duration:string;
begin


{showmessage(inttostr(MPEGVideoFile.Bitrate));
showmessage(inttostr(round(MPEGVideoFile.Length)));
showmessage(inttostr(round(MPEGVideoFile.FrameRate)));
showmessage(inttostr(MPEGVideoFile.Width));
showmessage(inttostr(MPEGVideoFile.Height));
showmessage(inttostr(MPEGVideoFile.FrameCount));    }
result:='<XML></XML>';
try
MPEGVideoFile:=TMPEGVideoFile.Create(filename);
MPEGVideoFile.GetInfo;
if MPEGVideoFile.LastError=FH_NoError then
begin
if SendEventto.width='' then
SendEventto.width:=inttostr(MPEGVideoFile.Width);
if SendEventto.height='' then
SendEventto.height:=inttostr(MPEGVideoFile.Height);


sizeinmb:=((MPEGVideoFile.Size / 1024) / 1024);
decodetime(MSecondToTime(round(MPEGVideoFile.Length*1000)),hour,min,sec,msec);
duration:='';
if hour<9 then duration:=duration+'0'+inttostr(hour)+':'  else duration:=duration+inttostr(hour)+':';
if min<9 then duration:=duration+'0'+inttostr(min)+':'  else duration:=duration+inttostr(min)+':';
if sec<9 then duration:=duration+'0'+inttostr(sec)+':'  else duration:=duration+inttostr(sec)+':';
frame:=((msec*25) div 1000);
if frame<9 then duration:=duration+'0'+inttostr(frame)  else duration:=duration+inttostr(frame);
result:='<XML>'+
'<FIELD name="filename">'+ExtractFileName(filename)+'</FIELD>'+
'<FIELD name="use duration">'+ duration+' </FIELD>'+
'<FIELD name="tc in">00:00:00:00 </FIELD>'+
'<FIELD name="tc out">'+ duration+' </FIELD>'+
'<FIELD name="clip duration">'+ duration+'</FIELD>'+
'<FIELD name="ingest date">'+formatdatetime('yyyy-mm-dd hh:mm:ss',now)+'</FIELD>'+
'<FIELD name="origin">'+sysutils.ExtractFilePath(filename)+'</FIELD>'+
'<FIELD name="remove date">'+remove_date+'</FIELD>'+
'<FIELD name="info">filesize = '+ReplaceSub(floattostrf(sizeinmb, ffgeneral, 6,4),',','.')+' MB^|width = '+SendEventto.width+'^|height = '+SendEventto.height+'^|</FIELD>'+
'<FIELD name="_thumb">'+HeaderAddFile.thumnail+'</FIELD>'+
'</XML>';
SendEventto.filename:=ExtractFileName(filename);
SendEventto.duration:=duration;
SendEventto.imagebase64:=HeaderAddFile.thumnail;
SendEventto.size:=ReplaceSub(floattostrf(sizeinmb, ffgeneral, 6,4),',','.')+' MB';
end;
finally
MPEGVideoFile.Free
end;
end;

function TForm1.parse_systemtime(xmlcontent:string):TParse_systemtime;
var
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
temp:string;
begin

  if xmlcontent<>'' then
  begin
  if (pos('<?xml',xmlcontent)=1) or (pos('<XML>',xmlcontent)=1) then
  begin
  try
  CoInitialize(nil);
  XML := CreateOleObject('Microsoft.XMLDOM');
  XML.Async := false;
  XML.loadXML(xmlcontent);
  if XML.parseError.errorCode = 0 then
  begin
  mainNode := XML.documentElement;
  childNodes:=mainNode.childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes;
  for i:=0 to childNodes.length-1 do
  begin
  if SameText(childNodes.item[i].childNodes.item[0].text,'date') then  result.date:=childNodes.item[i].childNodes.item[1].text;
  if SameText(childNodes.item[i].childNodes.item[0].text,'time') then  result.time:=childNodes.item[i].childNodes.item[1].text;
  if SameText(childNodes.item[i].childNodes.item[0].text,'datetime') then  result.datetime:=childNodes.item[i].childNodes.item[1].text;
  end;
  end;
  CoUnInitialize;
  except
  ;
  end;
  end;
  end;
end;

function TForm1.parse_id_savestamp(xmlcontent:string):TParse_id_savestamp;
var
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
temp:string;
begin

  if xmlcontent<>'' then
  begin
  if (pos('<?xml',xmlcontent)=1) or (pos('<XML>',xmlcontent)=1) then
  begin
  try
  CoInitialize(nil);
  XML := CreateOleObject('Microsoft.XMLDOM');
  XML.Async := false;
  XML.loadXML(xmlcontent);
  if XML.parseError.errorCode = 0 then
  begin
  mainNode := XML.documentElement;
  childNodes:=mainNode.childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes;
  for i:=0 to childNodes.length-1 do
  begin
  if SameText(childNodes.item[i].childNodes.item[0].text,'ID') then  result.id:=childNodes.item[i].childNodes.item[1].text;
  if SameText(childNodes.item[i].childNodes.item[0].text,'SAVE_STAMP') then  result.save_stamp:=childNodes.item[i].childNodes.item[1].text;
  end;
  end;
  CoUnInitialize;
  except
  ;
  end;
  end;
  end;
end;


function TForm1.xml_GetSystemTime:string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltSystem.GetSystemTime</methodName>'+
'<params>'+
'</params>'+
'</methodCall>';
end;





function TForm1.xml_MODIFIED_asset_element_new:string;
begin
result:='<?xml version="1.0"?><methodCall><methodName>CobaltDataBase.Store</methodName><params><param><value><string>Asset_Element</string></value></param><param><value>'+
'<struct>'+
'<member>'+
'<name>ID</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value>'+
'</member>'+
'<member>'+
'<name>SAVE_STAMP</name>'+
'<value><string>'+HeaderAddFile.SAVE_STAMP+'</string></value>'+
'</member>'+
'<member>'+
'<name>MODIFIED</name>'+
'<value><boolean>'+HeaderAddFile.MODIFIED+'</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'</param><param><value>'+
'<array>'+
'<data>'+
'<value><int>19</int></value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>id_category</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.id_category+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>asset_string</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.asset_string+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>remove_date</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.remove_date+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>updated_date</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.updated_date+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>creation_date</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.creation_date+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>file_extension</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.file_extension+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>id_master_asset_element</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.id_master_asset_element+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>custom_metadata</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><base64>'+HeaderAddFile.custom_metadata+'</base64></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>type_metadata</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><base64>'+HeaderAddFile.type_metadata+'</base64></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>search</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.search+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>status_int</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><int>'+HeaderAddFile.status_int+'</int></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>status_string</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.status_string+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>asset_host_ip</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.asset_host_ip+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+

'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>asset_host_port</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><int>'+HeaderAddFile.asset_host_port+'</int></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>external_ref</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.external_ref+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>res_int_1</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><int>0</int></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>res_int_2</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><int>0</int></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>res_string_1</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string></string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>res_string_2</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string></string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
 '</data>'+
'</array>'+
'</value>'+
'</param></params></methodCall>';
end;

function TForm1.xml_add_asset_element_new:string;
begin
result:='<?xml version="1.0"?><methodCall><methodName>CobaltDataBase.Store</methodName><params><param><value><string>Asset_Element</string></value></param><param><value>'+
'<struct>'+
'<member>'+
'<name>ID</name>'+
'<value><string>'+HeaderAddFile.id+'</string></value>'+
'</member>'+
'<member>'+
'<name>SAVE_STAMP</name>'+
'<value><string>'+HeaderAddFile.SAVE_STAMP+'</string></value>'+
'</member>'+
'<member>'+
'<name>MODIFIED</name>'+
'<value><boolean>'+HeaderAddFile.MODIFIED+'</boolean></value>'+
'</member>'+
'<member>'+
'<name>NEW</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'</param><param><value>'+
'<array>'+
'<data>'+
'<value><int>7</int></value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>id_category</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.id_category+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>asset_string</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.asset_string+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>custom_metadata</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><base64>'+HeaderAddFile.custom_metadata+'</base64></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>search</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.search+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>status_int</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><int>'+HeaderAddFile.status_int+'</int></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>status_string</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
'<value><string>'+HeaderAddFile.status_string+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'<value>'+
'<struct>'+
'<member>'+
'<name>FIELD_NAME</name>'+
'<value><string>external_ref</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_VALUE</name>'+
' <value><string>'+HeaderAddFile.external_ref+'</string></value>'+
'</member>'+
'<member>'+
'<name>FIELD_CHANGED</name>'+
'<value><boolean>1</boolean></value>'+
'</member>'+
'</struct>'+
'</value>'+
'</data>'+
'</array>'+
'</value>'+
'</param></params></methodCall>';
end;


procedure TForm1.Label14DblClick(Sender: TObject);
begin
form5.show;
end;

Procedure TForm1.LoadConfig;
var
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
i,j:integer;
temp:string;
atribute:string;
begin

  xmlcontent:=TStringList.Create;
  xmlcontent.LoadFromFile('config.xml');
  if xmlcontent.Text<>'' then
  begin
  if (pos('<?xml',xmlcontent.Text)=1) or (pos('<XML>',xmlcontent.Text)=1) then
  begin
  try
  CoInitialize(nil);
  XML := CreateOleObject('Microsoft.XMLDOM');
  XML.Async := false;
 // xmlcontent.LoadFromFile('D:\animation.xml');
  XML.loadXML(xmlcontent.Text);
  if XML.parseError.errorCode = 0 then
  begin
  mainNode := XML.documentElement;

  for i:=0 to mainNode.childNodes.length-1 do
  begin
  atribute:=mainNode.childNodes.item[i].getAttribute('name');
  if SameText(atribute,'custom_metadata') then config.custom_metadata:=freehand.DecodeBase64(mainNode.childNodes.item[i].text);
  if SameText(atribute,'asset_string') then config.asset_string:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'asset_id') then
  begin
  try
  config.asset_id:=strtoint(mainNode.childNodes.item[i].text);
  except
  config.asset_id:=-1;
  end;
  end;
  if SameText(atribute,'delta_temp_path') then config.delta_temp_path:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'search') then config.search:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'external_ref') then config.external_ref:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'cobalt_host') then config.cobalt_host:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'cobalt_port') then
  begin
  try
  config.cobalt_port:=strtoint(mainNode.childNodes.item[i].text);
  except
  config.cobalt_port:=5020;
  end;
  end;
  if SameText(atribute,'source_path') then config.source_path:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'file_extension') then config.file_extension:=mainNode.childNodes.item[i].text;
  if SameText(atribute,'delete_source') then
  begin
  if mainNode.childNodes.item[i].text='true' then config.delete_source:=true else config.delete_source:=false;
  end;
  if SameText(atribute,'view_subfolders') then
  begin
  if mainNode.childNodes.item[i].text='true' then config.view_subfolders:=true else config.view_subfolders:=false;
  end;
  if SameText(atribute,'monitoring_wait') then
  begin
  try
  config.monitoring_wait:=strtoint(mainNode.childNodes.item[i].text);
  except
  config.monitoring_wait:=360000;
  end;
  end;

  if SameText(atribute,'MailEvents') then
  begin
  for j := 0 to mainNode.childNodes.item[i].childNodes.length-1 do
  begin
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'SMTP') then config.SMTPConfig.smtphost:=mainNode.childNodes.item[i].childNodes.item[j].text;
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'PORT') then
  begin
  try
  config.SMTPConfig.smtpport:=strtoint(mainNode.childNodes.item[i].childNodes.item[j].text);
  except
  config.SMTPConfig.smtpport:=25;
  end;
  end;
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'FromEmail') then config.SMTPConfig.from:=mainNode.childNodes.item[i].childNodes.item[j].text;
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'ToEmail') then config.SMTPConfig.email:=mainNode.childNodes.item[i].childNodes.item[j].text;
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'User') then config.SMTPConfig.smtpuser:=mainNode.childNodes.item[i].childNodes.item[j].text;
  if SameText(mainNode.childNodes.item[i].childNodes.item[j].nodeName,'Password') then config.SMTPConfig.smtppassword:=mainNode.childNodes.item[i].childNodes.item[j].text;
  end;
  end;
  end;
  end;
 // CoUnInitialize;
  except
  ;
  end;
  end;
  end;
  xmlcontent.Free;


config.SMTPConfig.subject:='test cobalt injest';
form2.edit8.Text:=config.SMTPConfig.smtphost;
form2.edit7.Text:=inttostr(config.SMTPConfig.smtpport);
form2.edit11.Text:=config.SMTPConfig.from;
form2.edit6.Text:=config.SMTPConfig.email;
form2.edit9.Text:=config.SMTPConfig.smtpuser;
form2.edit10.Text:=config.SMTPConfig.smtppassword;


form2.edit5.Text:=config.source_path;
form2.edit4.Text:=config.file_extension;
form2.edit2.Text:=inttostr(config.monitoring_wait);
form2.checkbox1.Checked:=config.view_subfolders;
form2.CheckBox2.Checked:=config.delete_source;
form2.edit1.Text:=inttostr(config.cobalt_port);
form2.edit3.Text:=config.cobalt_host;
timer1.Interval:=config.monitoring_wait;

if (DirectoryExists(config.source_path) and ((ansilowercase(config.file_extension)=ansilowercase('mpg')) or (ansilowercase(config.file_extension)=ansilowercase('mov')))) then
begin
form5.ListBox1.Items.Insert(0,'Start monitoring watch folder '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
timer1.Enabled:=true;
end;
end;


Procedure TForm1.AssetMousEnter(Sender: TObject);
begin
form2.ScrollBox1.SetFocus;
end;


procedure TForm1.AssetMousedown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
id:integer;
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
xmlstring:ansistring;
asset_string:string;
temp:string;
begin
form2.Panel47.Visible:=true;
id:=((sender as TControl).Parent as TPanel).Tag;
xmlstring:=((sender as TControl).Parent as TPanel).Hint;
asset_string:=((sender as TControl).Parent as TPanel).caption;
form2.RichEdit.Text:='';
form2.RichEdit.Hint:='';
form2.RichEdit.Tag:=-1;
form2.RichEdit.Hint:=freehand.DecodeBase64(xmlstring);
form2.RichEdit.Tag:=id;
xmlcontent := TStringList.Create;
xmlcontent.Clear;
xmlcontent.Text:='{$REGION}'+CRLF+freehand.DecodeBase64(xmlstring)+CRLF+'{$ENDREGION}';
try
SourceCodeToRichText(asset_string, xmlcontent, form2.RichEdit);
finally
xmlcontent.Free;
end;
form2.Panel47.Visible:=false;
end;

Function TForm1.xml_querty_sql(sql:string):string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.MultiRequest</methodName>'+
'<params>'+
'<param><value><struct>'+
'<member><name>SQL_STRING</name>'+
'<value><string>'+sql+'</string></value></member>'+
'</struct></value></param>'+
'</params>'+
'</methodCall>';
end;

Function TForm1.xml_get_asset_from_id(id:string):string;
begin
result:='<?xml version="1.0"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.Retrieve</methodName>'+
'<params>'+
'<param><value><string>Asset_Element</string></value></param>'+
'<param><value>'+
'<struct>'+
'<member>'+
'<name>ID</name>'+
'<value><string>'+id+'</string></value>'+
'</member>'+
'<member>'+
'<name>SAVE_STAMP</name>'+
'<value><string>0</string></value>'+
'</member>'+
'</struct>'+
'</value>'+
'</param></params>'+
'</methodCall>';
end;

Function TForm1.xml_get_all_asset:string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.GetCollection</methodName>'+
'<params>'+
'<param><value><struct>'+
'<member><name>OBJECT_TYPE</name>'+
'<value><string>asset_element_type</string></value></member>'+
'<member><name>LOGICAL_OPERATOR</name>'+
'<value><string>OR</string></value></member>'+
'<member><name>CRITERIA_TYPE</name>'+
'<value><string>GET_ALL</string></value></member>'+
'<member><name>FIELD</name>'+
'<value><struct>'+
'<member><name>FIELD_NAME</name>'+
'<value><string></string></value></member>'+
'<member><name>FIELD_VALUE</name>'+
'<value><string></string></value></member>'+
'</struct></value></member>'+
'</struct></value></param>'+
'<param><value><struct>'+
'<member><name>OBJECT_TYPE</name>'+
'<value><string>asset_element_type</string></value></member>'+
'<member><name>LOGICAL_OPERATOR</name>'+
'<value><string>OR</string></value></member>'+
'<member><name>CRITERIA_TYPE</name>'+
'<value><string>ORDER_BY</string></value></member>'+
'<member><name>ORDER_BY_FIELD</name>'+
'<value><string>asset_string</string></value></member>'+
'<member><name>ORDER_BY_ORDER</name>'+
'<value><string>ASCENDING</string></value></member>'+
'</struct></value></param>'+
'</params>'+
'</methodCall>';
end;

Function TForm1.xml_get_asset_type_from_id(id:string):string;
begin
result:='<?xml version="1.0" encoding="UTF-8"?>'+
'<methodCall>'+
'<methodName>CobaltDataBase.Retrieve</methodName>'+
'<params>'+
'<param><value><string>asset_element_type</string></value></param>'+
'<param><value><struct>'+
'<member><name>ID</name>'+
'<value><string>'+id+'</string></value></member>'+
'<member><name>SAVE_STAMP</name>'+
'<value><string>0</string></value></member>'+
'</struct></value></param>'+
'</params>'+
'</methodCall>';
end;

Function TForm1.Get_Asset_From_ID(id:string):string;
var
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
temp:string;
t_panel:TPanel;
t_panel1:TPanel;
t_shape:Tshape;
t_image:TImage;
t_label1:TLabel;
t_label2:TLabel;
t_label3:TLabel;
ASSET_STRING,ASSET_BASE_TYPE,VERSION_STRING,definition_metadata:string;
begin
ASSET_STRING:='';
ASSET_BASE_TYPE:='';
VERSION_STRING:='';

xmlcontent:=TStringList.Create;
xmlcontent.Text:=xml_get_asset_type_from_id(id);
try
result:=idhttp1.Post('http://'+config.cobalt_host+':'+inttostr(config.cobalt_port), xmlcontent);


xmlcontent.text:=result;
if xmlcontent.Text<>'' then
begin
if (pos('<?xml',xmlcontent.Text)=1) or (pos('<XML>',xmlcontent.Text)=1) then
begin
try
CoInitialize(nil);
XML := CreateOleObject('Microsoft.XMLDOM');
XML.Async := false;
 // xmlcontent.LoadFromFile('D:\animation.xml');
XML.loadXML(xmlcontent.Text);
if XML.parseError.errorCode = 0 then
begin
mainNode := XML.documentElement;
childNodes:=mainNode.childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[1].childNodes.item[0].childNodes.item[0].childNodes;
for i:=0 to childNodes.length-1 do
begin
temp:=childNodes.item[i].text;
//if pos('ID',temp)>0 then listbox1.Items.Add('ID='+copy(temp,pos('FIELD_VALUE',temp)+12,(pos('FIELD_CHANGED',temp)-1-(pos('FIELD_VALUE',temp)+12))));
if pos('asset_string',temp)>0 then  ASSET_STRING:=copy(temp,pos('FIELD_VALUE',temp)+12,(pos('FIELD_CHANGED',temp)-1-(pos('FIELD_VALUE',temp)+12)));
if pos('asset_base_type',temp)>0 then ASSET_BASE_TYPE:=copy(temp,pos('FIELD_VALUE',temp)+12,(pos('FIELD_CHANGED',temp)-1-(pos('FIELD_VALUE',temp)+12)));
if pos('version_string',temp)>0 then VERSION_STRING:=copy(temp,pos('FIELD_VALUE',temp)+12,(pos('FIELD_CHANGED',temp)-1-(pos('FIELD_VALUE',temp)+12)));
if pos('definition_metadata',temp)>0 then definition_metadata:=copy(temp,pos('FIELD_VALUE',temp)+12,(pos('FIELD_CHANGED',temp)-1-(pos('FIELD_VALUE',temp)+12)));

end;
end;
// CoUnInitialize;
except
;
end;
end;
end;

except
;
end;

t_panel1:=TPanel.Create(form2.scrollbox1);
t_panel1.Name:='TPLine_'+id;
t_panel1.Top:=0;
t_panel1.Caption:='';
t_panel1.Color:=clblack;
t_panel1.BevelOuter:=bvNone;
t_panel1.Tag:=strtoint(id);
t_panel1.Hint:='';
t_panel1.Enabled:=true;
t_panel1.Align:=altop;
t_panel1.Width:=100;
t_panel1.Height:=1;
t_panel1.Parent:=form2.scrollbox1;

t_panel:=TPanel.Create(form2.scrollbox1);
t_panel.Name:='TPanel_'+id;
t_panel.Top:=0;
t_panel.Caption:=ASSET_STRING;
t_panel.Tag:=strtoint(id);
t_panel.Hint:=definition_metadata;
t_panel.Enabled:=true;
t_panel.BevelOuter:=bvNone;
t_panel.Align:=altop;
t_panel.Width:=100;
t_panel.Height:=40;
t_panel.Parent:=form2.scrollbox1;
t_panel.Cursor:=crHandPoint;




t_shape:=Tshape.Create(t_panel);
t_shape.Name:='TShape_'+id;
t_shape.Align:=alclient;
t_shape.Brush.Color:=$00808080;
t_shape.Pen.Color:=$00808080;
t_shape.Parent:=t_panel;
t_shape.Cursor:=crHandPoint;
t_shape.OnMouseDown:=AssetMousedown;
t_shape.OnMouseEnter:=AssetMousEnter;

t_image:=TImage.Create(t_panel);
t_image.Name:='Timage_'+id;
t_image.Top:=3;
t_image.Left:=2;
if (ASSET_BASE_TYPE='AVI') or (pos('MPEG',ASSET_BASE_TYPE)>0) or (ASSET_BASE_TYPE='DV') then
t_image.Picture.Assign(image10.Picture) else
if (pos('WAV',ASSET_BASE_TYPE)>0) then
t_image.Picture.Assign(image16.Picture) else
if (pos('TGA',ASSET_BASE_TYPE)>0) then
t_image.Picture.Assign(image8.Picture) else
if (pos('TEXT',ASSET_BASE_TYPE)>0) then
t_image.Picture.Assign(image13.Picture) else
t_image.Picture.Assign(image6.Picture);
t_image.Width:=32;
t_image.Height:=32;
t_image.Parent:=t_panel;
t_image.Cursor:=crHandPoint;
t_image.OnMouseDown:=AssetMousedown;
t_image.OnMouseEnter:=AssetMousEnter;

t_label1:=Tlabel.Create(t_panel);
t_label1.Top:=5;
t_label1.Left:=40;
t_label1.Font.name:='Arial';
t_label1.Color:=$00808080;
t_label1.Font.Size:=10;
t_label1.Font.Color:=clblack;
t_label1.Caption:=ASSET_STRING;
t_label1.Parent:=t_panel;
t_label1.Cursor:=crHandPoint;
t_label1.OnMouseDown:=AssetMousedown;
t_label1.OnMouseEnter:=AssetMousEnter;

t_label2:=Tlabel.Create(t_panel);
t_label2.Top:=20;
t_label2.Left:=40;
t_label2.Font.name:='Arial';
t_label2.Color:=$00808080;
t_label2.Font.Size:=8;
t_label2.Font.Color:=$00303030;
t_label2.Caption:=ASSET_BASE_TYPE+' [v.'+VERSION_STRING+']';
t_label2.Parent:=t_panel;
t_label2.Cursor:=crHandPoint;
t_label2.OnMouseDown:=AssetMousedown;
t_label2.OnMouseEnter:=AssetMousEnter;

//t_PaintBox.OnMouseDown:= PaintBoxMouseDown;
//t_PaintBox.OnMouseMove:=PaintBoxMouseMove;
//t_PaintBox.OnMouseUp:=PaintBoxMouseUp;
//t_PaintBox.OnPaint:=PaintBoxPaint;
//t_PaintBox.OnClick:=PaintBoxClick;

xmlcontent.Free;
end;

Function TForm1.GetTRANSFERMETADATA(xmlstring:string;protocol:byte):TTRANSFERMETADATA;
var
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
i:integer;
temp:string;
begin
  fillchar(result,sizeof(result),#0);
  result.protocol:=protocol;
  xmlcontent:=TStringList.Create;
  xmlcontent.Text:=xmlstring;
  if xmlcontent.Text<>'' then
  begin
  if (pos('<?xml',xmlcontent.Text)=1) or (pos('<XML>',xmlcontent.Text)=1) then
  begin
  try
  CoInitialize(nil);
  XML := CreateOleObject('Microsoft.XMLDOM');
  XML.Async := false;
 // xmlcontent.LoadFromFile('D:\animation.xml');
  XML.loadXML(xmlcontent.Text);
  if XML.parseError.errorCode = 0 then
  begin
  mainNode := XML.documentElement;
  for i:=0 to mainNode.childNodes.length-1 do
  begin
  temp:=mainNode.childNodes.item[i].getAttribute('name');
  if temp='username' then result.user:=mainNode.childNodes.item[i].text;
  if temp='password' then result.pasword:=mainNode.childNodes.item[i].text;
  if temp='ip' then result.host:=mainNode.childNodes.item[i].text;
  if temp='port' then result.port:=strtoint(mainNode.childNodes.item[i].text);
  if temp='path' then  result.path:=mainNode.childNodes.item[i].text;
  end;
  end;
 // CoUnInitialize;
  except
  ;
  end;
  end;
  end;
  xmlcontent.Free;
end;


procedure TForm1.IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
form5.ListBox1.Items.Insert(0,'SMTP Status: '+AStatusText+' - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));

end;

procedure TForm1.Image18MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
image18.Picture.Assign(image21.Picture);
image19.Picture.Assign(image22.Picture);
image5.Picture.Assign(image22.Picture);
label2.Font.Size:=8;
label1.Font.Size:=10;
label4.Font.Size:=8;
Panel33.BringToFront;
end;

procedure TForm1.Image19MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
image19.Picture.Assign(image21.Picture);
image18.Picture.Assign(image22.Picture);
image5.Picture.Assign(image22.Picture);
label2.Font.Size:=10;
label1.Font.Size:=8;
label4.Font.Size:=8;
Panel32.BringToFront;
end;

procedure TForm1.Image5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
image5.Picture.Assign(image21.Picture);
image18.Picture.Assign(image22.Picture);
image19.Picture.Assign(image22.Picture);
label2.Font.Size:=8;
label1.Font.Size:=8;
label4.Font.Size:=10;
Panel37.BringToFront;
end;

function TForm1.IsFileInUse(FileName: TFileName): Boolean;
 var
   HFileRes: HFILE;
 begin
   Result := False;
   if not FileExists(FileName) then Exit;
   HFileRes := CreateFile(PChar(FileName),
                          GENERIC_READ or GENERIC_WRITE,
                          0,
                          nil,
                          OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,
                          0);
   Result := (HFileRes = INVALID_HANDLE_VALUE);
   if not Result then
     CloseHandle(HFileRes);
 end;


procedure TForm1.Panel12Click(Sender: TObject);
begin
close;
end;

procedure TForm1.Panel12MouseEnter(Sender: TObject);
begin
(sender as TPanel).Color:=$00151515;
end;

procedure TForm1.Panel12MouseLeave(Sender: TObject);
begin
(sender as TPanel).Color:=$00101010;
end;

procedure TForm1.Panel13Click(Sender: TObject);
begin
form2.show;
end;

procedure TForm1.Panel18Click(Sender: TObject);
begin
About.showmodal;
end;

procedure TForm1.ScanDir(StartDir: string; Mask: string; List: TStrings; error_list:TStrings);
var
SearchRec: TSearchRec;
i:integer;
findinworks  :boolean;
MPEGVideoFile:TMPEGVideoFile;
begin
if Mask = '' then Mask := '*.*';
if StartDir[Length(StartDir)] <> '\' then  StartDir := StartDir + '\';
if FindFirst(StartDir + Mask, faAnyFile, SearchRec) = 0 then  begin
repeat
Application.ProcessMessages;
if (SearchRec.Attr and faDirectory) <> faDirectory then
begin
if ansilowercase(sysutils.ExtractFileExt(SearchRec.Name))=ansilowercase('.'+config.file_extension)  then
if not freehand.IsFileInUse(StartDir + SearchRec.Name) then
begin
findinworks:=false ;
for I := 0 to List.Count - 1 do
if ansilowercase(list.Strings[i])=ansilowercase(StartDir + SearchRec.Name) then findinworks:=true;
for I := 0 to error_list.Count - 1 do
if ansilowercase(error_list.Strings[i])=ansilowercase(StartDir + SearchRec.Name) then findinworks:=true;
if not findinworks then
begin
MPEGVideoFile:=TMPEGVideoFile.Create(StartDir + SearchRec.Name);
if MPEGVideoFile.ForceChackMPEG then
if not ChackFileInDB(StartDir + SearchRec.Name) then
begin
List.Add(StartDir + SearchRec.Name);
form5.ListBox1.Items.Insert(0,'Add file to active job ['+StartDir + SearchRec.Name+'] - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
end;
end;
end;
end
else
if (SearchRec.Name <> '..') and (SearchRec.Name <> '.')then begin
//List.Add(StartDir + SearchRec.Name + '\');
ScanDir(StartDir + SearchRec.Name + '\', Mask, List,error_list);  end;
until FindNext(SearchRec) <> 0;
FindClose(SearchRec);
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
ScanDirThread := TScanDirThread.Create(false);
exit;
  TaskScanDir := EnterWorkerThread;
  try
  form1.timer1.Enabled:=false;
  form1.ScanDir(config.source_path, '', form1.listbox1.items,form1.listbox3.items);
  form1.timer1.Enabled:=true;
  finally
    TaskScanDir := 0;
    LeaveWorkerThread;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
temp_item:string;
i:integer;
messages:TStringList;
msg:TIdMessage;
smtp:TIdSMTP;
begin
InjestThread := TInjestThread.Create(false,2);
exit;
TaskInjest := EnterWorkerThread;
try
form1.timer2.Enabled:=false;
form1.timer1.Enabled:=false;
//showmessage('123');
//exit;
if form1.listbox1.Items.Count<=0 then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if not fileexists(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if IsFileInUse(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;
if form1.ChackFileInDB(form1.listbox1.Items.Strings[0]) then
begin
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;
exit;
end;

temp_item:=form1.listbox1.Items.Strings[0];
form1.label5.Caption:=form1.listbox1.Items.Strings[0];
SendEventto.filename:='';
SendEventto.duration:='';
SendEventto.imagebase64:='';
SendEventto.width:='';
SendEventto.height:='';
SendEventto.size:='';
if form1.AddFileToDB(temp_item) then
begin
try
messages:=TStringList.Create;
messages.Add('<html>');
messages.Add('<h1>File <b>['+SendEventto.filename+']</b> injest <b>OK</b></h1>');
messages.Add('<br>');
messages.Add('<b>Size: </b>'+SendEventto.size);
messages.Add('<br>');
messages.Add('<b>Duration: </b>'+SendEventto.duration);
messages.Add('<br>');
messages.Add('<b>Width/Height: </b>'+SendEventto.width+'/'+SendEventto.height);
messages.Add('<br>');
messages.Add('<br>');
messages.Add('<img src="data:image/jpeg;base64,'+SendEventto.imagebase64+'"/>');
messages.Add('</html>');
config.SMTPConfig.subject:=SendEventto.filename+' injest OK';
form1.SendEvent(messages.Text);
finally
messages.Free;
end;
form1.listbox2.Items.Add(form1.listbox1.Items.Strings[0]);
form5.ListBox1.Items.Insert(0,'Injest finished ['+form1.listbox1.Items.Strings[0]+'] to Cobalt '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
if config.delete_source then
if deletefile(form1.listbox1.Items.Strings[0]) then form5.ListBox1.Items.Insert(0,'Delete file ['+form1.listbox1.Items.Strings[0]+'] -'+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now)) else
form5.ListBox1.Items.Insert(0,'Failed delete file ['+form1.listbox1.Items.Strings[0]+'] - '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
form1.listbox1.Items.Delete(0);
end else begin
form1.listbox3.Items.Add(form1.listbox1.Items.Strings[0]);
form5.ListBox1.Items.Insert(0,'Injest failed ['+form1.listbox1.Items.Strings[0]+'] to Cobalt '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
form1.listbox1.Items.Delete(0);
end;
form1.label5.Caption:='-';
form1.label8.Caption:='status: [-]';
form1.progressbar1.Position:=0;
form1.timer2.Enabled:=true;
form1.timer1.Enabled:=true;

finally
TaskInjest := 0;
LeaveWorkerThread;
end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
terminateprogram:=true;
if TaskScanDir<>0 then AbortWorkerThread(TaskScanDir);
if TaskInjest<>0 then AbortWorkerThread(TaskInjest);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
terminateprogram:=false;
TaskScanDir:=0;
TaskInjest:=0;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
form5.ListBox1.Items.Insert(0,'Start program '+formatdatetime('yyyy-mm-dd hh:mm:ss.zzz',now));
LoadConfig;
image19.Picture.Assign(image21.Picture);
image18.Picture.Assign(image22.Picture);
image5.Picture.Assign(image22.Picture);
label2.Font.Size:=10;
label1.Font.Size:=8;
label4.Font.Size:=8;
Panel37.Parent:=panel36;
Panel32.Parent:=panel36;
Panel33.Parent:=panel36;
Panel32.BringToFront;
end;

end.
