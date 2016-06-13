unit uBase64; 
{ 
  Unit source cut from Andreas Horstmeier's TCP/IP component suite. 
} 

interface 
uses 
  sysutils, 
  windows, 
  classes; 
type 
  ta_8u=packed array [0..65530] of byte; 
  t_encoding=(uuencode,base64,mime); 
  function encode_base64(data: TStream):string;
  function decode_base64(source:TStringList):TMemoryStream; 
  function encode_line(mode:t_encoding; const buf; size:Integer):String; 
  function decode_line(mode:t_encoding; const inp:String):String; 
  function poscn(c:char; const s:String; n: Integer):Integer; 
const 
bin2b64:String='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  b642bin:String='~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
  bin2uue:String='`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  uue2bin:String=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
  linesize = 45; 
implementation 
function poscn(c:char; const s:String; n: Integer):Integer; 
var 
  i: Integer; 
begin 
  if n=0 then  n:=1; 
  if n>0 then 
  begin 
    for i:=1 to length(s) do 
    begin 
      if s[i]<>c then 
      begin 
        dec(n); 
        Result:=i; 
        if n=0 then 
        begin 
          EXIT; 
        end; 
      end; 
    end; 
  end 
  else 
  begin 
    for i:=length(s) downto 1 do 
    begin 
      if s[i]<>c then 
      begin 
        inc(n); 
        Result:=i; 
        if n=0 then 
        begin 
          EXIT; 
        end; 
      end; 
    end; 
  end; 
  poscn:=0; 
end; 
function decode_line(mode:t_encoding; const inp:String):String; 
var 
  count,pos1,pos2: Integer; 
  offset: shortint; 
  s: String; 
  sOut: String; 
begin 
  s:=inp; 
  setlength(sOut,length(s)*3 div 4 +3); 
  fillchar(sOut[1],length(s)*3 div 4 +3,#0); 
  if (mode=uuencode) and not (s[1] in [' '..'M','`']) then 
    count:=0 
  else 
  begin 
    count:=0; 
    pos1:=0; 
    case mode of 
      uuencode: 
      begin 
        count:=(ord(s[1]) - $20) and $3f; 
        for pos1:=2 to length(s)-1 do 
          s[pos1]:=char(ord(uue2bin[ord(s[pos1])-$20+1])-$20); 
        pos1:=2; 
      end;// uuencode 
      base64,mime: 
      begin 
        count:=poscn('=',s,-1)*3 div 4; 
        for pos1:=1 to length(s) do 
          s[pos1]:=char(ord(b642bin[ord(s[pos1])-$20+1])-$20); 
        pos1:=1; 
      end;// base64, mime 
    end;// case 
    pos2:=1; 
    offset:=2; 
    while pos2<=count do 
    begin 
      if (pos1>length(s)) or ((mode<>uuencode) and (s[pos1]='\'))  then 
      begin 
        if offset<>2 then 
          inc(pos2); 
        count:=pos2-1; 
      end 
      else 
        if ((mode<>uuencode) and (s[pos1]='^')) then 
          inc(pos1) 
        else 
          if offset>0 then 
          begin 
            sOut[pos2]:=char(ord(sOut[pos2]) or (ord(s[pos1]) shl 
offset)); 
            inc(pos1); 
            offset:=offset-6; 
          end 
          else 
            if offset<0 then 
            begin 
              offset:=abs(offset); 
              sOut[pos2]:=char(ord(sOut[pos2]) or (ord(s[pos1]) shr 
offset)); 
              inc(pos2); 
              offset:=8-offset; 
          end 
          else 
          begin 
            sOut[pos2]:=char(ord(sOut[pos2]) or ord(s[pos1])); 
            inc(pos1); 
            inc(pos2); 
            offset:=2; 
          end;// if ((mode<>uuencode) and (s[pos1]='^')) 
    end;// while pos2<=count 
  end;// if (mode=uuencode) and not (s[1] in [' '..'M','`']) 
  decode_line:=copy(sOut,1,count); 
end;// function decode_line 
function encode_line(mode:t_encoding; const buf; size:Integer):String; 
var 
  buff: ta_8u absolute buf; 
  offset: shortint; 
  pos1,pos2: byte; 
  i: byte; 
  sOut: String; 
begin 
  setlength(sOut,size*4 div 3 + 4); 
  fillchar(sOut[1],size*4 div 3 +2,#0); 
  if mode=uuencode then 
  begin 
    sOut[1]:=char(((size-1) and $3f)+$21); 
    size:=((size+2) div 3)*3; 
  end;// if 
  offset:=2; 
  pos1:=0; 
  pos2:=0; 
  case mode of 
    uuencode:     pos2:=2; 
    base64, mime: pos2:=1; 
  end;// case 
  sOut[pos2]:=#0; 
  while pos1<size do 
  begin 
    if offset > 0 then 
    begin 
      sOut[pos2]:=char(ord(sOut[pos2]) or ((buff[pos1] and ($3f shl 
offset)) shr offset)); 
      offset:=offset-6; 
      inc(pos2); 
      sOut[pos2]:=#0; 
    end 
    else 
      if offset < 0 then 
      begin 
        offset:=abs(offset); 
        sOut[pos2]:=char(ord(sOut[pos2]) or ((buff[pos1] and ($3f shr 
offset)) shl offset)); 
        offset:=8-offset; 
        inc(pos1); 
      end 
      else 
      begin 
        sOut[pos2]:=char(ord(sOut[pos2]) or ((buff[pos1] and $3f))); 
        inc(pos2); 
        inc(pos1); 
        sOut[pos2]:=#0; 
        offset:=2; 
      end; 
  end; 
  case mode of 
    uuencode: 
    begin 
      if offset=2 then dec(pos2); 
      for i:=2 to pos2 do 
        sOut[i]:=bin2uue[ord(sOut[i])+1]; 
    end;// uuencode 
    base64, mime: 
    begin 
      if offset=2 then dec(pos2); 
      for i:=1 to pos2 do 
        sOut[i]:=bin2b64[ord(sOut[i])+1]; 
      while (pos2 and 3)<>0  do 
      begin 
        inc(pos2); 
        sOut[pos2]:='='; 
      end; 
    end;// base64, mime 
  end;// case 
  encode_line:=copy(sOut,1,pos2); 
end;// function encode_line



function encode_base64(data: TStream):string;
var 
  buf: pointer; 
  size: Integer; 
begin 
  buf:=NIL; 
  try 
    //Result:=TStringList.Create;
    getmem(buf,linesize); 
    data.seek(0,0); 
    size:=linesize; 
    while size>0 do 
    begin 
      size:=data.read(buf^,linesize); 
      if size>0 then 
        result:=result+encode_line(base64,buf^,size);
    end;// while 
  finally 
    if buf<>NIL then 
      freemem(buf,linesize); 
  end;// try 
end;// function encode_base64 
function decode_base64(source:TStringList):TMemoryStream; 
var 
  i: Integer; 
  s: String; 
begin 
  Result:=TMemoryStream.Create; 
  for i:=0 to source.count-1 do 
  begin 
    s:=decode_line(base64,source[i]); 
    Result.write(s[1],length(s)); 
  end;// for 
end;// function decode_base64 
end. 