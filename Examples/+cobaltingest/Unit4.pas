unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls,shellapi, TeCanvas, TeeEdiGrad, ScktComp;

type
  TAbout = class(TForm)
    Shape1: TShape;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape2: TShape;
    Label4: TLabel;
    Label5: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function GetFileVersion(const FileName: string): string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation


{$R *.dfm}

function TAbout.GetFileVersion(const FileName: string): string;
type
  PDWORD = ^DWORD;
  PLangAndCodePage = ^TLangAndCodePage;
  TLangAndCodePage = packed record
    wLanguage: WORD;
    wCodePage: WORD;
  end;
  PLangAndCodePageArray = ^TLangAndCodePageArray;
  TLangAndCodePageArray = array[0..0] of TLangAndCodePage;
var
  loc_InfoBufSize: DWORD;
  loc_InfoBuf: PChar;
  loc_VerBufSize: DWORD;
  loc_VerBuf: PChar;
  cbTranslate: DWORD;
  lpTranslate: PDWORD;
  i: DWORD;
begin
  Result := '';
  if (Length(FileName) = 0) or (not Fileexists(FileName)) then
    Exit;
  loc_InfoBufSize := GetFileVersionInfoSize(PChar(FileName), loc_InfoBufSize);
  if loc_InfoBufSize > 0 then
  begin
    loc_VerBuf := nil;
    loc_InfoBuf := AllocMem(loc_InfoBufSize);
    try
      if not GetFileVersionInfo(PChar(FileName), 0, loc_InfoBufSize, loc_InfoBuf)
        then
        exit;
      if not VerQueryValue(loc_InfoBuf, '\\VarFileInfo\\Translation',
        Pointer(lpTranslate), DWORD(cbTranslate)) then
        exit;
      for i := 0 to (cbTranslate div SizeOf(TLangAndCodePage)) - 1 do
      begin
        if VerQueryValue(
          loc_InfoBuf,
          PChar(Format(
          'StringFileInfo\0%x0%x\FileVersion', [
          PLangAndCodePageArray(lpTranslate)[i].wLanguage,
            PLangAndCodePageArray(lpTranslate)[i].wCodePage])),
            Pointer(loc_VerBuf),
          DWORD(loc_VerBufSize)
          ) then
        begin
          Result := loc_VerBuf;
          Break;
        end;
      end;
    finally
      FreeMem(loc_InfoBuf, loc_InfoBufSize);
    end;
  end;
end;

procedure TAbout.Image1Click(Sender: TObject);
begin
close;
end;

procedure TAbout.FormShow(Sender: TObject);
begin
{if AlphaBlend=False then
  begin
    AlphaBlendValue:=200;
    AlphaBlend:=True;
  end;    }
  //label3.Caption:=form1.version;
  if fileexists(application.ExeName) then  label3.Caption:=GetFileVersion(application.ExeName);

end;

procedure TAbout.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, cavb : 0..255;
begin

  if AlphaBlend=False then
  begin
    AlphaBlendValue:=240;
    AlphaBlend:=True;
  end;
  cavb:=AlphaBlendValue;

  for i := cavb downto 0 do
  begin
    AlphaBlendValue := i;
    Application.ProcessMessages;
  end;
  AlphaBlend:=false;
end;

end.
