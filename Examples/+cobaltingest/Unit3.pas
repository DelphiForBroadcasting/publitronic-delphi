unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,freehand, Menus;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    d1: TMenuItem;
    Addmounnthmm1: TMenuItem;
    Addyearyyyy1: TMenuItem;
    DateTimeoptions1: TMenuItem;
    Addhourhh1: TMenuItem;
    Addminutemm1: TMenuItem;
    Addsecss1: TMenuItem;
    Addmseczzz1: TMenuItem;
    Otheroptions1: TMenuItem;
    N1: TMenuItem;
    Addfilenamefn1: TMenuItem;
    Addrandomnumericr1001: TMenuItem;
    Adddateyyyymmdd1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Addyearyyyy1Click(Sender: TObject);
    procedure Addmounnthmm1Click(Sender: TObject);
    procedure d1Click(Sender: TObject);
    procedure Addhourhh1Click(Sender: TObject);
    procedure Addminutemm1Click(Sender: TObject);
    procedure Addsecss1Click(Sender: TObject);
    procedure Addmseczzz1Click(Sender: TObject);
    procedure Adddateyyyymmdd1Click(Sender: TObject);
    procedure Addfilenamefn1Click(Sender: TObject);
    procedure Addrandomnumericr1001Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

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

procedure TForm3.Adddateyyyymmdd1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$yyyy-$MM-$dd';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$yyyy-$MM-$dd';
end;

procedure TForm3.Addfilenamefn1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$fn';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$fn';
end;

procedure TForm3.Addhourhh1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$HH';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$HH';
end;

procedure TForm3.Addminutemm1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$mm';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$mm';
end;

procedure TForm3.Addmounnthmm1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$MM';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$MM';
end;

procedure TForm3.Addmseczzz1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$zzz';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$zzz';
end;

procedure TForm3.Addrandomnumericr1001Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$r[100]';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$r[100]';
end;

procedure TForm3.Addsecss1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$ss';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$ss';
end;

procedure TForm3.Addyearyyyy1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassName='TMemo' then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$yyyy';
if popupmenu1.PopupComponent.ClassName='TEdit' then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$yyyy';
end;

procedure TForm3.Button1Click(Sender: TObject);
var
i,j:integer;
xmlstring:TStringList;
temp,value,content_uni:string;
begin
xmlstring:=TStringList.Create;
xmlstring.Add('<XML>');
for I := 0 to panel1.ControlCount-1 do
begin
if panel1.Controls[i].ClassType=TMemo then
if (panel1.Controls[i] as TMemo).Tag=-1 then
begin
temp:=(panel1.Controls[i] as TMemo).Text;
value:='';
for j := 1 to length(temp) do
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
xmlstring.Add('<FIELD name="'+(panel1.Controls[i] as TMemo).Hint+'" >'+value+'</FIELD>')
end else begin
temp:=(panel1.Controls[i] as TMemo).Text;
value:='';
for j := 1 to length(temp) do
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
xmlstring.Add('<FIELD id="'+inttostr((panel1.Controls[i] as TMemo).Tag)+'" name="'+(panel1.Controls[i] as TMemo).Hint+'" >'+value+'</FIELD>');
end;
if panel1.Controls[i].ClassType=TCombobox then
if (panel1.Controls[i] as TCombobox).Tag=-1 then
xmlstring.Add('<FIELD name="'+(panel1.Controls[i] as TCombobox).Hint+'" >'+(panel1.Controls[i] as TCombobox).items.Strings[(panel1.Controls[i] as TCombobox).ItemIndex]+'</FIELD>') else
xmlstring.Add('<FIELD id="'+inttostr((panel1.Controls[i] as TCombobox).Tag)+'" name="'+(panel1.Controls[i] as TCombobox).Hint+'" >'+(panel1.Controls[i] as TCombobox).items.Strings[(panel1.Controls[i] as TCombobox).ItemIndex]+'</FIELD>');


if ((panel1.Controls[i].ClassType=TEdit) and (pos('te_',(panel1.Controls[i] as TEdit).Name)>0)) then
if (panel1.Controls[i] as TEdit).Tag=-1 then
BEGIN
temp:=(panel1.Controls[i] as TEdit).Text;
value:='';
for j := 1 to length(temp) do
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
xmlstring.Add('<FIELD name="'+(panel1.Controls[i] as TEdit).Hint+'" >'+value+'</FIELD>')
end else
begin
temp:=(panel1.Controls[i] as TEdit).Text;
value:='';
for j := 1 to length(temp) do
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
xmlstring.Add('<FIELD id="'+inttostr((panel1.Controls[i] as TEdit).Tag)+'" name="'+(panel1.Controls[i] as TEdit).Hint+'" >'+value+'</FIELD>');
end;

if ((panel1.Controls[i].ClassType=TEdit) and (pos('un_',(panel1.Controls[i] as TEdit).Name)>0)) then
if (panel1.Controls[i] as TEdit).Tag=-1 then
begin
temp:=(panel1.Controls[i] as TEdit).Text;
content_uni:='';
value:='';
for j := 1 to length(temp) do
begin
content_uni:=content_uni+'u'+inttostr(ord(temp[j]));
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
end;
xmlstring.Add('<FIELD  content_uni="'+content_uni+'" name="'+(panel1.Controls[i] as TEdit).Hint+'" >'+value+'</FIELD>')
end else begin
temp:=(panel1.Controls[i] as TEdit).Text;
content_uni:='';
value:='';
for j := 1 to length(temp) do
begin
content_uni:=content_uni+'u'+inttostr(ord(temp[j]));
if ord(temp[j])>129 then value:=value+strtohex(temp[j]) else  value:=value+temp[j];
end;
xmlstring.Add('<FIELD id="'+inttostr((panel1.Controls[i] as TEdit).Tag)+'"  content_uni="'+content_uni+'" name="'+(panel1.Controls[i] as TEdit).Hint+'" >'+value+'</FIELD>');
end;



end;
xmlstring.Add('</XML>');
config.asset_string:=form3.Caption;
config.custom_metadata:=freehand.EncodeBase64(xmlstring.Text);
config.asset_id:=form3.Tag;
//config.search:=
close;
end;


procedure TForm3.Button2Click(Sender: TObject);
begin
close;
end;

procedure TForm3.d1Click(Sender: TObject);
begin
if popupmenu1.PopupComponent.ClassType=TMemo then
(popupmenu1.PopupComponent as TMemo).Text:=(popupmenu1.PopupComponent as TMemo).Text+'$dd';
if popupmenu1.PopupComponent.ClassType=TEdit then
(popupmenu1.PopupComponent as TEdit).Text:=(popupmenu1.PopupComponent as TEdit).Text+'$dd';
end;

end.
