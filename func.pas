unit func;
interface
uses Classes, Struct, SysUtils, time, DateUtils, IniFiles, Windows;

const
  BOT         = 0;
  FSEEN       = 1;
  FDIALOGUE   = 2;
  FHELLO      = 3;
  FTALK       = 4;
//  FSECUREMAIL = 5;
  FBADWORDS   = 6;
  FPHRASES    = 7;
  FGTB        = 8; // global talk base (!useglobalbase)
//{$DEFINE DEBUG}

procedure rmchar(var s: string; c: char);
function split(s: string; c: char):TStringList;
function msgsplit(s: string; c: char):TStringList;
function irc_data(s: string):string;
function word1(s: string):string;
function word2(s: string):string;
function word3(s: string):string;
function word4(s: string):string;
function word5(s: string):string;
procedure getnickadr(s: string; var nick,adr: string);
function userchans(const nick: string):TStringList;
procedure writelog(const text: string);
procedure logmsg(target,text: string; tmstmp: boolean = true);
procedure replace(var s:string; const what,src: string);
function afterN(s: string; n: word):string;
function funcenabled(const chan: string; ftype: byte):boolean;
procedure chgfuncstate(const chan: string; ftype: byte; state: boolean);
procedure play(const nick,pfile: string; with_numlines: boolean = false);
function lines(const filename: string): integer;
function fread(const filename: string): string;
function duration(time: cardinal): string;
function iswm(pattern, str: string): boolean;
function access(const nick,adr: string; chan: string = '*'): shortint;
function address(const nick: string): string;
function ison(const chan,nick: string): boolean;
{$IFDEF DEBUG}
procedure writedebug(const dmsg: string);
procedure structdump;
{$ENDIF}
function accesstostring(const access: integer; islocal: boolean = false): string;
function getuserbyua(s: string): string;
function delstringfromfile(const fname,str: string): boolean;
function validaccess(const access: integer): boolean;
function validuser(const nick: string): boolean;
function uptime: cardinal;
function validchan(const chan: string): string;

implementation
uses mgr;

procedure rmchar;
begin
  while pos(c,s) <> 0 do delete(s,pos(c,s),1)
end; // procedure rmchar;

function split;
var i: integer;
    sl: TStringList;
begin
  sl:=TStringList.Create;
  i:=pos(c,s);
  while i<>0 do begin
    sl.Add(copy(s,1,i-1));
    delete(s,1,i);
    i:=pos(c,s)
  end;
  sl.Add(s);
  result:=sl
end; // function split;

function msgsplit;
var i: integer;
    sl: TStringList;
begin
  sl:=TStringList.Create;
  sl.Add('NULL');
  i:=pos(c,s);
  while i<>0 do begin
    sl.Add(copy(s,1,i-1));
    delete(s,1,i);
    i:=pos(c,s)
  end;
  sl.Add(s);
  result:=sl
end; // function split;

function irc_data;
begin
  if s[1] = ':' then delete(s,1,1);
  delete(s,1,pos(':',s));
  result:=s
end; // function irc_data;

function word1;
begin
  if s[1] = ':' then delete(s,1,1);
  result:=copy(s,1,pos(' ',s)-1)
end; // function word1;

function word2;
begin
  delete(s,1,pos(' ',s));
  if pos(' ',s) = 0 then
    result:=s
  else
    result:=copy(s,1,pos(' ',s)-1)
end; // function word2;

function word3;
begin
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  if pos(' ',s) = 0 then
    result:=s
  else
    result:=copy(s,1,pos(' ',s)-1)
end; // function word3;

function word4;
begin
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  result:=copy(s,1,pos(' ',s)-1)
end; // function word4;

function word5;
begin
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  delete(s,1,pos(' ',s));
  result:=copy(s,1,pos(' ',s)-1)
end; // function word5;

procedure getnickadr;
begin
  nick:=copy(s,1,pos('!',s)-1);
  delete(s,1,pos('!',s));
  adr:=s
end; // procedure getnickadr;

function userchans;
begin
  result:=channel.userchans(nick);
end; // function userchans;

procedure writelog;
var F: TextFile;
begin
  try
    if not(DirectoryExists(global.dir+'logs')) then ForceDirectories(global.dir+'logs');
    AssignFile(F,global.dir+'logs\fbot.log');
    if not(FileExists(global.dir+'logs\fbot.log')) then
      begin
        rewrite(F);
        CloseFile(F)
      end;
    Append(F);
    writeln(F,text);
    CloseFile(F)
  except end
end; // procedure writelog;

procedure logmsg;
var logdir,logfile,s: string;
    LF: TextFile;
begin
  try
  if global.network = '' then logdir:=global.dir+'logs\unknown_network\'
  else logdir:=global.dir+'logs\'+global.network+'\';
  if not(DirectoryExists(logdir)) then ForceDirectories(logdir);
  replace(target,'\','_');
  replace(target,'/','_');
  replace(target,':','_');
  replace(target,'*','_');
  replace(target,'?','_');
  replace(target,'"','_');
  replace(target,'<','_');
  replace(target,'>','_');
  replace(target,'|','_');
  case settings.splitlog of
    0: logfile:=logdir+target+'.log';
    1: logfile:=logdir+target+'.'+FormatDateTime('yyyymm',now)+'.log';
    2:  begin
          s:=inttostr(DayOf(now)-(DayOf(now)-1) mod 7);
          if (s = '1')or(s = '8') then s:='0'+s;
          logfile:=logdir+target+'.'+FormatDateTime('yyyymm',now)+s+'.log'
        end
  end;
  if (settings.timestamplog)and(text <> '')and(tmstmp) then
    begin
      case settings.logstyle of
        0: text:=FormatDateTime('[hh:mm] ',now)+text;
        1: text:=FormatDateTime('[hh:mm:ss] ',now)+text;
      end
    end;
  AssignFile(LF,logfile);
  if FileExists(logfile) then
    begin
      Append(LF);
      writeln(LF,text)
    end
  else
    begin
      rewrite(LF);
      if settings.logstyle = 1 then
        begin
           writeln(LF,'*** fbot log, created '+DateTimeToStr(now));
           writeln(LF,'')
        end;
      if (settings.logstyle = 0)and(pos('#',target) = 0) then
        begin
          writeln(LF,'');
          writeln(LF,'Session Start: '+mirctime);
          writeln(LF,'Session Ident: '+target)
        end;
      writeln(LF,text)
    end;
  CloseFile(LF);
  except end
end; // procedure logmsg;

procedure replace;
var i: word;
begin
  i:=pos(what,s);
  while i <> 0 do
    begin
      delete(s,i,length(what));
      insert(src,s,i);
      i:=pos(what,s)
    end
end; // procedure replace;

function afterN;
var i: word;
begin
  if n < 2 then
    begin
      result:=s;
      exit
    end;
  try
    for i:=1 to n-1 do
      if pos(' ',s) <> 0 then
        delete(s,1,pos(' ',s))
      else
        begin
          s:='';
          break;
        end;
  except s:='' end;
  result:=s;
end; // function afterN;

function funcenabled;
var ind: TProIni;
begin
  result:=false;
  case ftype of
    BOT: begin
           ind:=TProIni.Create(global.dir+'conf\global.conf');
           result:=not(ind.ReadBool('disabled_on',chan,false));
           ind.free
         end;
    FSEEN: begin
             ind:=TProIni.Create(global.dir+'conf\seen.conf');
             result:=not(ind.ReadBool('disabled_on',chan,false));
             ind.Free
           end;
    FTALK: begin
             ind:=TProIni.Create(global.dir+'conf\talk.conf');
             result:=ind.ReadBool('talk',chan,false);
             ind.Free
           end;
    FHELLO: begin
              ind:=TProIni.Create(global.dir+'conf\talk.conf');
              result:=ind.ReadBool('hello',chan,false);
              ind.Free
            end;
    FDIALOGUE: begin
                 ind:=TProIni.Create(global.dir+'conf\talk.conf');
                 result:=not(ind.ReadBool('dialogue_disabled_on',chan,false));
                 ind.Free
               end;
    FBADWORDS: begin
                 ind:=TProIni.Create(global.dir+'conf\badwords.conf');
                 result:=ind.ReadBool('enabled_on',chan,false);
                 ind.Free;
               end;
    FPHRASES: begin
                ind:=TProIni.Create(global.dir+'conf\talk.conf');
                result:=ind.ReadBool('phrasereaction',chan,false);
                ind.Free;
              end;
    FGTB: begin
            ind:=TProIni.Create(global.dir+'conf\talk.conf');
            result:=not(ind.ReadBool('not_useglobalbase',chan,false));
            ind.Free;
          end;
  end;
end; // function func_enabled;

procedure chgfuncstate;
var ind: TProIni;
begin
  case ftype of
    BOT: begin
           ind:=TProIni.Create(global.dir+'conf\global.conf');
           if state = true then
             ind.DeleteKey('disabled_on',chan)
           else
             ind.WriteBool('disabled_on',chan,true);
           ind.free
         end;
    FSEEN: begin
             ind:=TProIni.Create(global.dir+'conf\seen.conf');
             if state = true then
               ind.DeleteKey('disabled_on',chan)
             else
               ind.WriteBool('disabled_on',chan,true);
             ind.free
           end;
    FTALK: begin
             ind:=TProIni.Create(global.dir+'conf\talk.conf');
             if state = true then
               ind.WriteBool('talk',chan,true)
             else
               ind.DeleteKey('talk',chan);
             ind.free
           end;
    FHELLO: begin
              ind:=TProIni.Create(global.dir+'conf\talk.conf');
              if state = true then
                ind.WriteBool('hello',chan,true)
              else
                ind.DeleteKey('hello',chan);
              ind.free
            end;
    FDIALOGUE: begin
                 ind:=TProIni.Create(global.dir+'conf\talk.conf');
                 if state = true then
                   ind.DeleteKey('dialogue_disabled_on',chan)
                 else
                   ind.WriteBool('dialogue_disabled_on',chan,true);
                 ind.free
               end;
    FBADWORDS: begin
                 ind:=TProIni.Create(global.dir+'conf\badwords.conf');
                 if state = true then
                   ind.WriteBool('enabled_on',chan,true)
                 else
                   ind.DeleteKey('enabled_on',chan);
                 ind.free;
               end;
    FPHRASES: begin
              ind:=TProIni.Create(global.dir+'conf\talk.conf');
              if state = true then
                ind.WriteBool('phrasereaction',chan,true)
              else
                ind.DeleteKey('phrasereaction',chan);
              ind.free;
            end;
    FGTB: begin
            ind:=TProIni.Create(global.dir+'conf\talk.conf');
            if state = true then
              ind.DeleteKey('not_useglobalbase',chan)
            else
              ind.WriteBool('not_useglobalbase',chan,true);
            ind.free;
          end;
  end;
end; // procedure chgfuncstate;

procedure play;
var X: TextFile;
    fpath,line: string;
    i: integer;
begin
  if pos(':\',pfile) = 0 then
    fpath:=global.dir+pfile
  else
    fpath:=pfile;
  if not(FileExists(fpath)) then exit;
  AssignFile(X,fpath);
  i:=1;
  try
    reset(X);
    while not(eof(X)) do
      if with_numlines then
        begin
          readln(X,line);
          msg(nick,inttostr(i)+': '+line);
          inc(i)
        end
      else
        begin
          readln(X,line);
          msg(nick,line)
        end;
    CloseFile(X)
  except end
end; // procedure play;

function lines;
var F: TextFile;
    c: integer;
begin
  c:=0;
  if not(FileExists(filename)) then
    begin
      result:=0;
      exit
    end;
  try
    AssignFile(F,filename);
    reset(F);
    while not eof(F) do
      begin
        readln(F);
        inc(c)
      end;
    CloseFile(F);
  except
    result:=0;
    exit
  end;
  result:=c
end; // function lines;

function fread;
var l,ind: integer;
    F: TextFile;
begin
  Randomize;
  l:=lines(filename);
  result:='';
  if l = 0 then exit;
  ind:=random(l)+1;
  try
    AssignFile(F,filename);
    reset(F);
    l:=1;
    while not eof(F) do
      begin
        if l = ind then
          readln(F,result)
        else
          readln(F);
        inc(l)
      end;
    CloseFile(F);
  except exit end
end; // function fread;

function duration;
var i: integer;
begin
  if time = 0 then
    begin
      result:='0сек.';
      exit
    end;
  i:=time mod 60;
  time:=time div 60;
  if i <> 0 then result:=inttostr(i)+'сек.';
  if time > 0 then
    begin
      i:=time mod 60;
      time:=time div 60;
      if i <> 0 then result:=inttostr(i)+'мин. '+result;
    end
  else exit;
  if time > 0 then
    begin
      i:=time mod 24;
      time:=time div 24;
      if i <> 0 then result:=inttostr(i)+'ч. '+result;
    end
  else exit;
  if time > 0 then
    begin
      i:=time mod 7;
      time:=time div 7;
      if i <> 0 then result:=inttostr(i)+'д. '+result;
    end
  else exit;
  if time > 0 then
    result:=inttostr(time)+'нед. '+result
end; // function duration;

function iswm;
var i,gp,tmp: integer;
    s: string;
begin
  if (pattern = '')or(str = '') then
    begin
      result:=false;
      exit
    end;
  pattern:=AnsiLowerCase(pattern);
  str:=AnsiLowerCase(str);
  tmp:=pos('**',pattern);
  while tmp <> 0 do
    begin
      delete(pattern,tmp,1);
      tmp:=pos('**',pattern)    // delete all *...*
    end;
  if pattern = '*' then         // pattern = '*'
    begin
      result:=true;
      exit
    end;
  if pos('*',pattern) = 0 then  // pattern without '*'
    begin
      if pattern = str then result:=true
      else result:=false;
      exit
    end;
  result:=false;
  if pattern[1] <> '*' then     // if 1st symbol not '*'
    begin
      s:=copy(pattern,1,pos('*',pattern)-1);
      tmp:=length(s);
      if copy(str,1,tmp) <> s then exit
      else
        begin
          delete(pattern,1,tmp+1);
          delete(str,1,tmp)
        end
    end
  else delete(pattern,1,1);
                                // main part of work
  i:=pos('*',pattern);          // split pattern on parts by '*'
  while i<>0 do
    begin
      gp:=pos(copy(pattern,1,i-1),str); // copy(s,1,i-1) - pattern's part
      if gp = 0 then exit;      // gp - pattern's part position in str
      delete(str,1,gp+i-2);
      delete(pattern,1,i);
      i:=pos('*',pattern)
    end;
  if pattern <> '' then             // finalization
    begin
      if copy(str,length(str)-length(pattern)+1,length(pattern)) = pattern then result:=true;
    end
  else
    result:=true
end; // function iswm;

function access;
begin
  result:=accesslist.access(nick,adr,chan)
end; // function access;

function address;
begin
  result:=addresslist.getadr(nick)
end; // function address;

function ison;
var ch: TChannel;
begin
  result:=false;
  if (nick = '')or(chan = '') then exit;
  ch:=channel[chan];
  if ch = nil then exit;
  result:=ch.ison(nick)
end; // function ison;

{$IFDEF DEBUG}
procedure writedebug;
var debug: TextFile;
begin
  if not(DirectoryExists(global.dir+'logs')) then
    ForceDirectories(global.dir+'logs');
  AssignFile(debug,global.dir+'logs\debug.log');
  if not(FileExists(global.dir+'logs\debug.log')) then
    rewrite(debug)
  else
    append(debug);
  writeln(debug,'['+datetimetostr(now)+'] '+dmsg);
  CloseFile(debug)
end; // procedure writedebug;

procedure structdump;
var ch: TChannel;
    cu: pChanUser;
    ac: TAccessEntry;
    ad: pAddressEntry;
    cacs: PChanAccess;
    debug: TextFile;
begin
  if not(DirectoryExists(global.dir+'logs')) then
    ForceDirectories(global.dir+'logs');
  AssignFile(debug,global.dir+'logs\debug.log');
  if not(FileExists(global.dir+'logs\debug.log')) then
    rewrite(debug)
  else
    append(debug);
  writeln(debug,'------------------------------------------------------');
  writeln(debug,'   >>> ['+datetimetostr(now)+'] >>> Memory dump:');
  writeln(debug);
  writeln(debug,'  Channel Manager:');
  ch:=channel.chanroot;
  while ch <> nil do
    begin
      writeln(debug,'    ['+ch.name+']');
      cu:=ch.uroot;
      while cu <> nil do
        begin
          writeln(debug,'      '+cu^.nick);
          cu:=cu^.next;
        end;
      ch:=ch.next;
    end;
  writeln(debug);
  writeln(debug,'  Access List:');
  ac:=accesslist.aroot;
  while ac <> nil do
    begin
      writeln(debug,'    '+ac.nick+' ('+ac.address+') : '+inttostr(ac.access));
      cacs:=ac.chanacs;
      while cacs <> nil do
        begin
          writeln(debug,'     - '+cacs^.chan+' : '+inttostr(cacs^.access));
          cacs:=cacs^.next;
        end;
      ac:=ac.next;
    end;
  writeln(debug);
  writeln(debug,'  Address List:');
  ad:=addresslist.aroot;
  while ad <> nil do
    begin
      writeln(debug,'    '+ad^.nick+' ('+ad^.address+')');
      ad:=ad^.next;
    end;
  writeln(debug);
  writeln(debug,'  Global:');
  writeln(debug,'    nick: '+global.nick);
  writeln(debug,'    dir: '+global.dir);
  writeln(debug,'    server_name: '+global.server_name);
  writeln(debug,'    network: '+global.network);
  writeln(debug,'------------------------------------------------------');
  CloseFile(debug);
end; // procedure structdump;
{$ENDIF}

function accesstostring;
begin
  if islocal then
    case access of
      NOUSER: result:='No such user';
      USER: result:='User';
      VOICE: result:='Channel Voice';
      HOP: result:='Channel Half-operator';
      OP: result:='Channel Operator';
      ADMIN: result:='Channel Administrator';
      else result:='Unknown access';
    end
  else
    case access of
      NOUSER: result:='No such user';
      USER: result:='User';
      OPERATOR: result:='Global Operator';
      ADMIN: result:='Root Administrator';
      else result:='Unknown access';
    end
end; // function accesstostring;

function getuserbyua;
var i: integer;
begin
  delete(s,1,1);
  for i:=length(s) downto 1 do
    if s[i] = '(' then
      begin
        delete(s,i-1,length(s)-i+2);
        break;
      end;
  result:=s;
end; // function getuserbyua;

function delstringfromfile;
var f,tmp: TextFile;
    tmpname,s: string;
begin
  Randomize;
  result:=false;
  if not(FileExists(fname)) then exit;
  AssignFile(f,fname);
  tmpname:='';
  while tmpname = '' do
    begin
      tmpname:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(tmpname) then tmpname:='';
    end;
  AssignFile(tmp,tmpname);
  try
    reset(f);
    rewrite(tmp);
    while not(eof(f)) do
      begin
        readln(f,s);
        if s = str then
          result:=true
        else
          writeln(tmp,s);
      end;
    CloseFile(f);
    CloseFile(tmp);
    Erase(f);
    Rename(tmp,fname);
  except
    result:=false;
    try
      CloseFile(f);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      SysUtils.DeleteFile(tmpname);
    except end;
  end;
end; // function delstringfromfile;

function validaccess;
begin
  case access of
    USER: result:=true;
    OPERATOR: result:=true;
    ADMIN: result:=true;
    else result:=false;
  end;
end; // function validaccess;

function validuser;
var ini: TProIni;
begin
  ini:=TProIni.Create(global.dir+'conf\users.conf');
  result:=(ini.ReadInteger(nick,'access',0) <> 0);
  ini.Free;
end; // function validuser;

function uptime: cardinal;
var ver: TOSVersionInfo;
    count,freq: int64;
begin
  ver.dwOSVersionInfoSize:=sizeof(TOSVersionInfo);
  GetVersionEx(ver);
  if ver.dwPlatformId = VER_PLATFORM_WIN32_NT then
    begin
      QueryPerformanceCounter(count);
      QueryPerformanceFrequency(freq);
      Result:=Round(count/freq);
    end
 else
   Result:=gettickcount div 1000;
end; // function uptime: cardinal;

function validchan;
begin
  result:=chan;
  if result[1] <> '#' then result:='#'+result;
end; // function validchan;

end.
