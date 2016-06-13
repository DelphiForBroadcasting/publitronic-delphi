unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,freehand,filectrl,
  StdCtrls, ComCtrls, ExtCtrls, pngimage, IniFiles,
  Dialogs, activex,ComObj, Buttons,uSourceCodeConverter, LbButton, LbSpeedButton;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Image4: TImage;
    Image11: TImage;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel3: TPanel;
    Shape7: TShape;
    Label14: TLabel;
    Panel7: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel17: TPanel;
    Panel19: TPanel;
    Panel16: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Image5: TImage;
    Label4: TLabel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel39: TPanel;
    Shape2: TShape;
    Panel40: TPanel;
    Shape3: TShape;
    Panel41: TPanel;
    Shape4: TShape;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Panel42: TPanel;
    Shape5: TShape;
    Panel43: TPanel;
    ScrollBox3: TScrollBox;
    Panel45: TPanel;
    Shape1: TShape;
    Label2: TLabel;
    Shape6: TShape;
    Panel44: TPanel;
    Shape8: TShape;
    Label1: TLabel;
    Shape9: TShape;
    Panel46: TPanel;
    Shape10: TShape;
    Label3: TLabel;
    RichEdit: TRichEdit;
    Label5: TLabel;
    Panel47: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel50: TPanel;
    Shape13: TShape;
    Panel48: TPanel;
    Label6: TLabel;
    Panel49: TPanel;
    Shape11: TShape;
    Image6: TImage;
    Shape12: TShape;
    Edit3: TEdit;
    Panel53: TPanel;
    Label7: TLabel;
    Panel54: TPanel;
    Shape14: TShape;
    Image9: TImage;
    Shape15: TShape;
    Edit1: TEdit;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    Shape16: TShape;
    Panel58: TPanel;
    Label8: TLabel;
    Panel59: TPanel;
    Shape17: TShape;
    Image10: TImage;
    Shape18: TShape;
    Edit2: TEdit;
    Panel60: TPanel;
    Label9: TLabel;
    Panel61: TPanel;
    Shape19: TShape;
    Image13: TImage;
    Shape20: TShape;
    Edit4: TEdit;
    Panel62: TPanel;
    Shape21: TShape;
    Label10: TLabel;
    Panel63: TPanel;
    Panel64: TPanel;
    Shape22: TShape;
    CheckBox1: TCheckBox;
    Panel65: TPanel;
    Label11: TLabel;
    Panel66: TPanel;
    Shape23: TShape;
    Image14: TImage;
    Shape24: TShape;
    Edit5: TEdit;
    Panel8: TPanel;
    Shape25: TShape;
    Panel18: TPanel;
    Panel67: TPanel;
    Shape26: TShape;
    Label12: TLabel;
    Panel68: TPanel;
    Shape27: TShape;
    Label13: TLabel;
    Shape28: TShape;
    Image24: TImage;
    Label15: TLabel;
    Label16: TLabel;
    Panel71: TPanel;
    Panel72: TPanel;
    Panel73: TPanel;
    Shape30: TShape;
    Panel74: TPanel;
    Label17: TLabel;
    Panel75: TPanel;
    Shape31: TShape;
    Image19: TImage;
    Shape32: TShape;
    Edit6: TEdit;
    Panel80: TPanel;
    Label19: TLabel;
    Panel81: TPanel;
    Shape36: TShape;
    Shape37: TShape;
    Edit8: TEdit;
    Panel69: TPanel;
    Panel70: TPanel;
    Shape29: TShape;
    CheckBox2: TCheckBox;
    Panel76: TPanel;
    Label18: TLabel;
    Panel77: TPanel;
    Shape33: TShape;
    Image20: TImage;
    Shape34: TShape;
    Edit7: TEdit;
    Image3: TImage;
    Image12: TImage;
    Image18: TImage;
    Image16: TImage;
    Image17: TImage;
    Image15: TImage;
    Image8: TImage;
    Image7: TImage;
    Panel82: TPanel;
    Shape38: TShape;
    Label20: TLabel;
    Image21: TImage;
    Panel83: TPanel;
    Label21: TLabel;
    Panel84: TPanel;
    Shape39: TShape;
    Image22: TImage;
    Shape40: TShape;
    Edit9: TEdit;
    Panel85: TPanel;
    Label22: TLabel;
    Panel86: TPanel;
    Shape41: TShape;
    Image23: TImage;
    Shape42: TShape;
    Edit10: TEdit;
    Panel78: TPanel;
    Label23: TLabel;
    Panel79: TPanel;
    Shape35: TShape;
    Image25: TImage;
    Shape43: TShape;
    Edit11: TEdit;
    procedure Shape8MouseEnter(Sender: TObject);
    procedure Shape8MouseLeave(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Shape8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5Click(Sender: TObject);
    procedure Shape5MouseEnter(Sender: TObject);
    procedure Shape5MouseLeave(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Shape10MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit3Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Image14MouseEnter(Sender: TObject);
    procedure Image14MouseLeave(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Panel13Click(Sender: TObject);
    procedure Panel13MouseEnter(Sender: TObject);
    procedure Panel13MouseLeave(Sender: TObject);
    procedure Panel12Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image13MouseEnter(Sender: TObject);
    procedure Image13MouseLeave(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Shape26MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape27MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label20Click(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
  private
            procedure WMMOUSEWHEEL(var Msg: TMessage); message WM_MOUSEWHEEL;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1, Unit3;

{$R *.dfm}

procedure TForm2.WMMOUSEWHEEL(var Msg: TMessage);
var
 zDelta: Integer;
begin
 inherited;
if WindowFromPoint(Mouse.CursorPos) <> ScrollBox1.Handle then Exit;
if Msg.WParam < 0 then zDelta := -10 else zDelta := 10;
with ScrollBox1 do
begin
if ((VertScrollBar.Position = 0) and
 (zDelta > 0)) or ((VertScrollBar.Position = VertScrollBar.Range - ClientHeight) and
 (zDelta < 0)) then Exit;
 ScrollBy(0, zDelta);
 VertScrollBar.Position := VertScrollBar.Position - zDelta;
end;
end;

procedure TForm2.Edit1Change(Sender: TObject);
var
i:integer;
temp:integer;
temp1:string;
begin
temp:=0;
image9.Tag:=0;
image9.Picture.Assign(image7.Picture);
if edit1.Text='' then exit;
try
if (strtoint(edit1.Text)>0) and (strtoint(edit1.Text)<=65535) then
begin
image9.Tag:=1;
image9.Picture.Assign(image8.Picture);
end;
except
image9.Tag:=0;
image9.Picture.Assign(image7.Picture);
end;
end;

procedure TForm2.Edit2Change(Sender: TObject);
var
i:integer;
temp:integer;
temp1:string;
begin
temp:=0;
image10.Tag:=0;
image10.Picture.Assign(image7.Picture);
if edit2.Text='' then exit;
try
if (strtoint(edit2.Text)>=1000) and (strtoint(edit2.Text)<=86400000) then
begin
image10.Tag:=1;
image10.Picture.Assign(image8.Picture);
end;
except
image10.Tag:=0;
image10.Picture.Assign(image7.Picture);
end;
end;

procedure TForm2.Edit3Change(Sender: TObject);
var
i:integer;
temp:integer;
temp1:string;
begin
temp:=0;
temp1:=edit3.Text;
image6.Tag:=0;
image6.Picture.Assign(image7.Picture);
for I := 1 to length(temp1) do
begin
if not (temp1[i] in['0'..'9']) and (temp1[i]<>'.') then
begin
image6.Tag:=0;
image6.Picture.Assign(image7.Picture);
exit;
end;
if (temp1[i]='.') and (temp1[i-1]<>'.') and (temp1[i-1]<>'') and (temp1[i+1]<>'.') and (temp1[i+1]<>'')  then
inc(temp);
end;
if temp=3 then
begin
image6.Picture.Assign(image8.Picture);
image6.Tag:=1;
end;
end;

procedure TForm2.Edit5Change(Sender: TObject);
begin

if sysutils.DirectoryExists(edit5.Text) then
begin
image14.Picture.Assign(image17.Picture);
image14.Tag:=1;
end else begin
image14.Picture.Assign(image15.Picture);
image14.tag:=0;
end;
end;

procedure TForm2.Edit7Change(Sender: TObject);
var
i:integer;
temp:integer;
temp1:string;
begin
temp:=0;
image20.Tag:=0;
image20.Picture.Assign(image7.Picture);
if edit7.Text='' then exit;
try
if (strtoint(edit7.Text)>0) and (strtoint(edit7.Text)<=65535) then
begin
image20.Tag:=1;
image20.Picture.Assign(image8.Picture);
end;
except
image20.Tag:=0;
image20.Picture.Assign(image7.Picture);
end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
panel40.Parent:=panel38;
panel40.BringToFront;
end;

procedure TForm2.Image13Click(Sender: TObject);
begin
panel8.Visible:= not panel8.Visible;
end;

procedure TForm2.Image13MouseEnter(Sender: TObject);
begin
image13.Picture.Assign(image3.Picture)
end;

procedure TForm2.Image13MouseLeave(Sender: TObject);
begin
image13.Picture.Assign(image12.Picture)
end;

procedure TForm2.Image14Click(Sender: TObject);
var
i:integer;
 chosenDirectory: string;
begin
if image14.Tag=1 then
begin
  edit5.Text:='';
  exit;
end;

if SelectDirectory('Select folder to save error logs', '', chosenDirectory) then
if directoryexists(chosenDirectory) then
begin
edit5.Text:=chosenDirectory;
end;


end;

procedure TForm2.Image14MouseEnter(Sender: TObject);
begin
if edit5.Text='' then  image14.Picture.Assign(image16.Picture) else image14.Picture.Assign(image18.Picture);

end;

procedure TForm2.Image14MouseLeave(Sender: TObject);
begin
if edit5.Text='' then  image14.Picture.Assign(image15.Picture) else image14.Picture.Assign(image17.Picture);

end;

procedure TForm2.Label10Click(Sender: TObject);
begin
if image6.Tag<>1 then
begin
  showmessage('Enter correct AssetManager ip addres!');
  exit;
end;
if image9.Tag<>1 then
begin
  showmessage('Enter correct AssetManager port!');
  exit;
end;
try
form1.IdHTTP1.Get('http://'+edit3.Text+':'+edit1.text);
if form1.IdHTTP1.Response.RawHeaders.Values['Server']='PubliTronic Cobalt DXMLRPC SERVER' then
showmessage(form1.IdHTTP1.Response.RawHeaders.Values['Server']+#13#10+'[OK]') else showmessage(form1.IdHTTP1.Response.RawHeaders.Values['Server']+#13#10+'[ERROR]');
except
showmessage('http://'+edit3.Text+':'+edit1.text+' not response!');
end;
end;

procedure TForm2.Label1MouseEnter(Sender: TObject);
var
i:integer;
begin
for i:=0 to ((sender as TLabel).Parent as TPanel).ControlCount-1 do
if pos('Shape',((sender as TLabel).Parent as TPanel).Controls[i].Name)>0 then
begin
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Brush.Color:=$00858585;
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Pen.Color:=$00858585;
end;


end;

procedure TForm2.Label1MouseLeave(Sender: TObject);
var
i:integer;
begin
for i:=0 to ((sender as TLabel).Parent as TPanel).ControlCount-1 do
if pos('Shape',((sender as TLabel).Parent as TPanel).Controls[i].Name)>0 then
begin
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Brush.Color:=$00808080;
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Pen.Color:=$00808080;
end;
end;

procedure TForm2.Label20Click(Sender: TObject);
begin
config.SMTPConfig.subject:='Cobalt auto injest test mail!';
form1.SendEvent('<html><b>Cobalt auto injest test mail!</b></html>');
end;

procedure TForm2.Label5Click(Sender: TObject);
var
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
temp:string;
xmlformat:string;
t_label:TLabel;
t_Edit:TEdit;
t_COMBOBOX:TCOMBOBOX;
t_memo:Tmemo;
t_panel:Tpanel;
t_checkbox:TCheckBox;
begin
xmlformat:='';


if (pos('<?xml',richedit.Text)>0) then xmlformat:='<?xml' else
if (pos('<XML>',richedit.Text)>0) then  xmlformat:='<XML>';
xmlcontent:=TStringlist.Create();



xmlcontent.Text:= copy(richedit.Text,pos(xmlformat,richedit.Text),length(richedit.Text)-pos(xmlformat,richedit.Text)+1);
xmlcontent.Text:=freehand.ReplaceSub(xmlcontent.Text,'x=','xxx=');
xmlcontent.Text:=freehand.ReplaceSub(xmlcontent.Text,'y=','yyy=');
if xmlcontent.Text<>'' then
begin
if (pos('<?xml',xmlcontent.Text)=1) or (pos('<XML>',xmlcontent.Text)=1) then
begin
try
CoInitialize(nil);
XML := CreateOleObject('Microsoft.XMLDOM');
XML.Async := false;
XML.loadXML(xmlcontent.Text);
if XML.parseError.errorCode = 0 then
begin
mainNode := XML.documentElement;

try
form3.Panel1.Free;
except;
;
end;
t_panel:=Tpanel.Create(form3);
t_panel.Name:='Panel1';
t_panel.Caption:='';
t_panel.BevelOuter:=bvNone;
t_panel.Align:=alclient;
t_panel.Parent:=form3;


try
form3.width:=mainNode.childNodes.item[0].getAttribute('width');
except
form3.width:=150;
end;
try
form3.Height:=41+mainNode.childNodes.item[0].getAttribute('height');
except
form3.Height:=100;
end;

form3.Caption:=richedit.Lines.Strings[0];
form3.tag:=richedit.tag;

for i:=0 to mainNode.childNodes.item[0].childNodes.length-1 do
begin
randomize;

//LBAEL
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'LABEL') then
begin
try
t_Label:=TLabel.Create(nil);
t_Label.Name:='tl_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_Label.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_Label.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_Label.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_Label.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
t_Label.Caption:=mainNode.childNodes.item[0].childNodes.item[i].text;
t_Label.Parent:=form3.panel1;
except
;
end;
end;
//TEXTFIELD
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'TEXTFIELD') then
begin
try
t_edit:=Tedit.Create(nil);
t_edit.Name:='te_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_edit.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_edit.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_edit.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_edit.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
//t_edit.MaxLength:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('max'));
t_edit.text:=mainNode.childNodes.item[0].childNodes.item[i].text;
t_edit.Hint:=mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name');
try
t_edit.Tag:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('id'));
except
t_edit.Tag:=-1;
end;
t_edit.Parent:=form3.panel1;
t_edit.PopupMenu:=form3.PopupMenu1;
except
;
end;
end;

//UNITEXT
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'UNITEXT') then
begin
try
t_edit:=Tedit.Create(nil);
t_edit.Name:='un_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_edit.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_edit.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_edit.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_edit.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
//t_edit.MaxLength:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('max'));
t_edit.text:=mainNode.childNodes.item[0].childNodes.item[i].text;
t_edit.Hint:=mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name');
try
t_edit.Tag:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('id'));
except
t_edit.Tag:=-1;
end;
t_edit.Parent:=form3.panel1;
t_edit.PopupMenu:=form3.PopupMenu1;
except
;
end;
end;


//COMBOBOX
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'COMBOBOX') then
begin
try
t_COMBOBOX:=TCOMBOBOX.Create(nil);
t_COMBOBOX.Name:='TCOMBOBOX_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_COMBOBOX.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_COMBOBOX.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_COMBOBOX.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_COMBOBOX.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
t_COMBOBOX.Parent:=form3.panel1;
t_COMBOBOX.ItemIndex:=-1;
t_COMBOBOX.Text:='';
t_COMBOBOX.Hint:=mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name');
try
t_COMBOBOX.Tag:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('id'));
except
t_COMBOBOX.Tag:=-1;
end;
temp:=freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].text,'#13',#13);
temp:= freehand.ReplaceSub(temp,'#13',#13);
t_COMBOBOX.items.Text:=temp

except
;
end;
end;

//CHECKBOX
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'CHECKBOX') then
begin
try
t_CHECKBOX:=TCHECKBOX.Create(nil);
t_CHECKBOX.Name:='TCHECKBOX_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_CHECKBOX.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_CHECKBOX.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_CHECKBOX.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_CHECKBOX.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
t_CHECKBOX.Parent:=form3.panel1;
t_CHECKBOX.Hint:=mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name');
try
t_CHECKBOX.Tag:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('id'));
except
t_CHECKBOX.Tag:=-1;
end;
t_CHECKBOX.Caption:=mainNode.childNodes.item[0].childNodes.item[i].text;
except
;
end;
end;

//TEXTAREA
if SameText(mainNode.childNodes.item[0].childNodes.item[i].nodename,'TEXTAREA') then
begin
try
t_memo:=Tmemo.Create(nil);
t_memo.Name:='tm_'+inttostr(random(99))+'_'+freehand.ReplaceSub(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name'),' ','_');
t_memo.Top:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('yyy'));
t_memo.left:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('xxx'));
t_memo.Width:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('width'));
t_memo.Height:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('height'));
//t_memo.MaxLength:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('max'));
t_memo.Text:=mainNode.childNodes.item[0].childNodes.item[i].text;
t_memo.Hint:=mainNode.childNodes.item[0].childNodes.item[i].getAttribute('name');
try
t_memo.Tag:=strtoint(mainNode.childNodes.item[0].childNodes.item[i].getAttribute('id'));
except
t_memo.Tag:=-1;
end;
t_memo.Parent:=form3.panel1;
t_memo.PopupMenu:=form3.PopupMenu1;
except
;
end;
end;



//showmessage(mainNode.childNodes.item[0].childNodes.item[i].text);


end;
form3.ShowModal;
end;
// CoUnInitialize;
except
;
end;
end;
end;




end;

procedure TForm2.Label5MouseEnter(Sender: TObject);
var
i:integer;
begin
for i:=0 to ((sender as TLabel).Parent as TPanel).ControlCount-1 do
if pos('Shape',((sender as TLabel).Parent as TPanel).Controls[i].Name)>0 then
begin
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Brush.Color:=$00858585;
end;
end;

procedure TForm2.Label5MouseLeave(Sender: TObject);
var
i:integer;
begin
for i:=0 to ((sender as TLabel).Parent as TPanel).ControlCount-1 do
if pos('Shape',((sender as TLabel).Parent as TPanel).Controls[i].Name)>0 then
begin
(((sender as TLabel).Parent as TPanel).Controls[i] as TShape).Brush.Color:=$00909090;
end;
end;

procedure TForm2.Panel12Click(Sender: TObject);
begin
edit5.Text:=config.source_path;
edit4.Text:=config.file_extension;
edit2.Text:=inttostr(config.monitoring_wait);
checkbox1.Checked:=config.view_subfolders;
edit1.Text:=inttostr(config.cobalt_port);
edit3.Text:=config.cobalt_host;
close;
end;

 {

Function  LoadAssetManagementOptions:TModuleAssetManagement;
var
IniFile : TIniFile;
begin
try
  fillchar(result,sizeof(result),#0);
  if fileexists(ExtractFilePath(ParamStr(0))+'config.ini') then
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'config.ini')
  else   IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'config.lnk');
  result.regiontitle:=IniFile.ReadString('MAIN','regiontitle','FreeHand');
  result.DataBase.host:=IniFile.ReadString('MYSQL','host','localhost');
  result.DataBase.Port:=IniFile.ReadInteger('MYSQL','port',3306);
  result.DataBase.user:=IniFile.ReadString('MYSQL','user','Anonymous');
  result.DataBase.password:=IniFile.ReadString('MYSQL','password','');
  result.DataBase.bd:=IniFile.ReadString('MYSQL','db','FreeHand');
  result.DataBase.active:=StrToBool(IniFile.ReadString('MYSQL','Reconnect','true'));
  result.http.active:=StrToBool(IniFile.ReadString('HTTP','active','true'));
  result.http.port:=IniFile.ReadInteger('HTTP','port',8888);
  result.http.root:=IniFile.ReadString('HTTP','root',copy(ExtractFilePath(ParamStr(0)),1,length(ExtractFilePath(ParamStr(0)))-length('program\'))+'\www\');
  result.ftp.active:=StrToBool(IniFile.ReadString('FTP','active','true'));
  result.ftp.port:=IniFile.ReadInteger('FTP','port',2121);
  result.ftp.root:=IniFile.ReadString('FTP','root',copy(ExtractFilePath(ParamStr(0)),1,length(ExtractFilePath(ParamStr(0)))-length('program\'))+'\avi\');
  result.ftp.maxclients:=IniFile.ReadInteger('FTP','maxclients',100);  IniFile.Free;
  result.writedb:=StrToBool(IniFile.ReadString('m_AssetManagement','writedb','false'));
  result.tempdir:=IniFile.ReadString('m_AssetManagement','tempdir',ExtractFilePath(ParamStr(0))+'\temp\');
IniFile.Free;
except
;
end;
end;}

procedure TForm2.Panel13Click(Sender: TObject);
var
xmlconfig:TStringlist;
begin
if sysutils.DirectoryExists(edit5.Text) then config.source_path:=edit5.Text;
config.file_extension:=edit4.Text;
config.monitoring_wait:=strtoint(edit2.Text);
config.view_subfolders:=checkbox1.Checked;
config.cobalt_port:=strtoint(edit1.Text);
config.cobalt_host:=edit3.Text;
config.delete_source :=checkbox2.Checked;

config.SMTPConfig.smtphost:=form2.edit8.Text;
try
config.SMTPConfig.smtpport:=strtoint(form2.edit7.Text);
except
config.SMTPConfig.smtpport:=25;
end;
config.SMTPConfig.from:=form2.edit11.Text;
config.SMTPConfig.email:=form2.edit6.Text;
config.SMTPConfig.smtpuser:=form2.edit9.Text;
config.SMTPConfig.smtppassword:=form2.edit10.Text;


xmlconfig:=Tstringlist.Create;
xmlconfig.Add('<XML>');
xmlconfig.Add('<ITEM name="custom_metadata">'+config.custom_metadata+'</ITEM>');
xmlconfig.Add('<ITEM name="asset_string">'+config.asset_string+'</ITEM>');
xmlconfig.Add('<ITEM name="asset_id">'+inttostr(config.asset_id)+'</ITEM>');
xmlconfig.Add('<ITEM name="search">'+config.search+'</ITEM>');
xmlconfig.Add('<ITEM name="external_ref">'+config.external_ref+'</ITEM>');
xmlconfig.Add('<ITEM name="cobalt_host">'+config.cobalt_host+'</ITEM>');
xmlconfig.Add('<ITEM name="cobalt_port">'+inttostr(config.cobalt_port)+'</ITEM>');
xmlconfig.Add('<ITEM name="source_path">'+config.source_path+'</ITEM>');
xmlconfig.Add('<ITEM name="monitoring_wait">'+inttostr(config.monitoring_wait)+'</ITEM>');
xmlconfig.Add('<ITEM name="file_extension">'+config.file_extension+'</ITEM>');
if config.view_subfolders then
xmlconfig.Add('<ITEM name="view_subfolders">true</ITEM>') else  xmlconfig.Add('<ITEM name="view_subfolders">false</ITEM>');
xmlconfig.Add('<ITEM name="delta_temp_path">\delta\objects\temp\</ITEM>');
if config.delete_source then
xmlconfig.Add('<ITEM name="delete_suorce">true</ITEM>') else xmlconfig.Add('<ITEM name="delete_suorce">false</ITEM>');

xmlconfig.Add('<ITEM name="MailEvents">');
xmlconfig.Add('<SMTP>'+config.SMTPConfig.smtphost+'</SMTP>');
xmlconfig.Add('<PORT>'+inttostr(config.SMTPConfig.smtpport)+'</PORT>');
xmlconfig.Add('<FromEmail>'+config.SMTPConfig.from+'</FromEmail>');
xmlconfig.Add('<ToEmail>'+config.SMTPConfig.email+'</ToEmail>');
xmlconfig.Add('<User>'+config.SMTPConfig.smtpuser+'</User>');
xmlconfig.Add('<Password>'+config.SMTPConfig.smtppassword+'</Password>');
xmlconfig.Add('</ITEM>');


xmlconfig.Add('</XML>');
xmlconfig.SaveToFile('config.xml');
xmlconfig.Free;
close;
end;

procedure TForm2.Panel13MouseEnter(Sender: TObject);
begin
(sender as TPanel).Color:=$00151515;
end;

procedure TForm2.Panel13MouseLeave(Sender: TObject);
begin
(sender as TPanel).Color:=$00101010;
end;

procedure TForm2.Shape10MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
panel40.Parent:=panel38;
panel40.BringToFront;
end;

procedure TForm2.Shape26MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edit4.Text:='mov';
panel8.Visible:=false;
end;

procedure TForm2.Shape27MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
edit4.Text:='mpg';
panel8.Visible:=false;
end;

procedure TForm2.Shape5MouseEnter(Sender: TObject);
begin
(sender as TShape).Brush.Color:=$00858585;
end;

procedure TForm2.Shape5MouseLeave(Sender: TObject);
begin
(sender as TShape).Brush.Color:=$00909090;
end;

procedure TForm2.Shape8MouseEnter(Sender: TObject);
begin
(sender as TShape).Brush.Color:=$00858585;
(sender as TShape).Pen.Color:=$00858585;
end;

procedure TForm2.Shape8MouseLeave(Sender: TObject);
begin
(sender as TShape).Brush.Color:=$00808080;
(sender as TShape).Pen.Color:=$00808080;
end;

procedure TForm2.Shape8MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
xmlcontent:TStringList;
XML:  variant;
mainNode: variant;
childNodes: variant;
i,j:integer;
temp:string;
begin
panel39.Parent:=panel38;
panel39.BringToFront;
panel43.Visible:=true;
xmlcontent:=TStringList.Create;
xmlcontent.Text:=Form1.xml_get_all_asset;
try
xmlcontent.Text:=form1.idhttp1.Post('http://'+edit3.Text+':'+edit1.text, xmlcontent);
except
showmessage('Host not find!');
xmlcontent.Free;
panel43.Visible:=false;
exit;
end;


 // xmlcontent:=TStringList.Create;
 // xmlcontent.LoadFromFile('d:\test.xml');
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
  childNodes:=mainNode.childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes.item[0].childNodes;
  for i:=0 to childNodes.length-1 do
  begin
  for j:=0 to childNodes.item[i].childNodes.item[0].childNodes.length-1 do
  begin
  temp:=childNodes.item[i].childNodes.item[0].childNodes.item[j].text;
  if pos('ID',temp)>0 then form1.Get_Asset_From_ID(copy(temp,pos('ID',temp)+3,length(temp)-(pos('ID',temp)+2)));

  end;
  end;
  end;
  CoUnInitialize;
  except
  ;
  end;
  end else
  begin
  showmessage('XML parse faild!');
  xmlcontent.Free;
  panel43.Visible:=false;
  exit;
  end;
  end else
  begin
  showmessage('Responce from server empty!');
  xmlcontent.Free;
  panel43.Visible:=false;
  exit;
  end;
  xmlcontent.Free;
  panel43.Visible:=false;


end;

end.
