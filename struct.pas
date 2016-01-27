unit struct;
interface
uses IniFiles, Classes, SysUtils;

const
  NOUSER        = 0;
  USER          = 1;
  VOICE         = 5;
  HOP           = 25;
  OPERATOR      = 50;
  OP            = 50;
  ADMIN         = 100;
//{$DEFINE DEBUG}

type TSettings = class
  public
    mhost: string;
    mport: integer;
    mservpass: string;
    servpass: string;
    nick: string;
    user: string;
    realname: string;
    altnick: string;
    chanlog: boolean;
    querylog: boolean;
    outlog: boolean;
    timestamplog: boolean;
    splitlog: integer;
    logstyle: integer;
    ctcp_ping: boolean;
    ctcp_time: boolean;
    totrayonstart: boolean;
    altservers: boolean;
    umode_b: boolean;
    umode_i: boolean;
    umode_x: boolean;
    qmsg: string;
    kmsg: string;
    nsnick: string;
    nspass: string;
    nsidnotice: string;
    rejoinonkick: boolean;
    rejoinonconnect: boolean;
    extrasecure: boolean;
    check4updates: boolean;
    minimizetotray: boolean;
    kickonban: boolean;
    say4chanadmin: boolean;
    talkantiflood: boolean;
    talktimeout: integer;
    autooponident: boolean;
    autooponjoin: boolean;
    confirmexit: boolean;
    confirmreboot: boolean;
    addtalknick: boolean;
  end;

type TGlobal = class
  public
    nick: string;
    dir: string;
    server_name: string;
    connect_time: integer;
    network: string;
  end;

type pChanAccess = ^TChanAccess;
    TChanAccess = record
    next: pChanAccess;
    chan: string;
    access: shortint;
    end;

type TAccessEntry = class
  public
    next: TAccessEntry;
    nick: string;
    address: string;
    access: shortint;
    chanacs: pChanAccess;
    constructor Create(const anick,adr: string; acc: shortint); reintroduce;
    procedure addCA(const chan: string; acc: shortint);
    destructor Destroy; override;
  end;

type TAccessList = class
  private
    root: TAccessEntry;
    cafile: string;
  public
    constructor Create(const cafl: string); reintroduce;
    procedure add(const nick,adr: string; acc: shortint);
    procedure del(const nick: string);
    function access(const nick,adr,achan: string): shortint;
    procedure clear;
    destructor Destroy; override;
    {$IFDEF DEBUG}
    property aroot:TAccessEntry read root;
    {$ENDIF}
    property chanaccessconf:string read cafile;
  end;

type pChanUser = ^TChanUser;
    TChanUser = record
    next: pChanUser;
    nick: string;
    end;

type TChannel = class
  private
    root: pChanUser;
    all: word;
    cname: string;
  public
    next: TChannel;
    names_complete: boolean;
    lasttalk: integer;
    constructor Create(const aname: string);
    function ison(const nick: string):boolean;
    procedure adduser(const nick: string);
    procedure deluser(const nick: string);
    procedure clear;
    procedure getusers(Strings: TStrings);
    destructor Destroy; override;
    property usercount:word read all;
    property name:string read cname;
    {$IFDEF DEBUG}
    property uroot:pChanUser read root;
    {$ENDIF}
  end;

type TChannelManager = class
  private
    root: TChannel;
  public
    constructor Create;
    procedure add(const name: string);
    procedure del(const name: string);
    function getchan(const name: string):TChannel;
    procedure clear;
    procedure chguser(const old,new: string);
    procedure deluser(const nick: string);
    function userchans(const nick: string): TStringList;
    property chan[const name: string]: TChannel read getchan; default;
    {$IFDEF DEBUG}
    property chanroot:TChannel read root;
    {$ENDIF}
    destructor Destroy; override;
  end;

type TProIni = class(TiniFile)
  private
    function pcode(s: string): string;
    function pdecode(s: string): string;
  public
    procedure DeleteKey(const Section, Ident: String); override;
    procedure EraseSection(const Section: String); override;
    procedure ReadSection(const Section: String; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: String; Strings: TStrings); override;
    function ReadInteger(const Section, Ident: String; Default: Longint): Longint; override;
    function ReadBool (const Section, Ident: String; Default: Boolean): Boolean ; override;
    function ReadString(const Section, Ident, Default: String): String; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure WriteInteger(const Section, Ident: String; Value: Longint); override;
    procedure WriteBool(const Section, Ident: String; Value: Boolean); override;
  end;

type pAddressEntry = ^TAddressEntry;
    TAddressEntry = record
    next: pAddressEntry;
    nick: string;
    address: string;
    end;

type TAddresslist = class
  private
    root: pAddressEntry;
  public
    constructor Create;
    procedure add(const nick,adr: string);
    procedure del(const nick: string);
    function getadr(const nick: string): string;
    procedure clear;
    destructor Destroy; override;
    {$IFDEF DEBUG}
    property aroot:pAddressEntry read root;
    {$ENDIF}
  end;

type TSegFile = class
  private
    fname: string;
  public
    constructor Create(const filename: string);
    procedure ReadSection(const Section: string; list: TStrings);
    procedure DelString(const Section: string; const s: string);
    procedure AddString(const Section: string; const s: string);
    procedure DelSection(const Section: string);
    procedure ReadSections(Strings: TStrings);
    function SectionExists(const Section: string): boolean;
    property filename: string read fname;
  end;

type TGlobalLists = class
  public
    badwords: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

type TAlias = class
  public
    next: TAlias;
    aliases: TStringList;
    constructor Create(const command: string); reintroduce;
    destructor Destroy; override;
  end;

type TAliasManager = class
  private
    root: TAlias;
  public
    constructor Create;
    function validcommand(const comnd: string): boolean;
    procedure Add(list: TStringList);
    function getcommand(cmd_prot: string): string;
    destructor Destroy; override;
  end;

type TDSegFile = class
  private
    fname: string;
  public
    constructor Create(const filename: string);
    procedure ReadSections(Strings: TStrings);
    procedure ReadSubSections(const Section: string; Strings: TStrings; dosplit: boolean = true);
    procedure ReadSubSection(const Section: string; const SubSection: string; Strings: TStrings; dosplit: boolean = true);
    procedure ModifySubSection(const Section,OldName,NewName: string);
    procedure DelSection(const Section: string);
    procedure DelSubSection(const Section,SubSection: string);
    procedure WriteString(const Section,SubSection,s: string);
    procedure DelString(const Section,SubSection,s: string);
    property filename: string read fname;
  end;

{ ============================================================== }
implementation

constructor TAccessEntry.Create;
begin
  inherited Create;
  nick:=anick;
  address:=adr;
  access:=acc;
  next:=nil;
  chanacs:=nil;
end; // constructor TAccessEntry.Create;

procedure TAccessEntry.addCA;
var ca: pChanAccess;
begin
  if chan = '' then exit;
  new(ca);
  ca^.chan:=chan;
  ca^.access:=acc;
  ca^.next:=chanacs;
  chanacs:=ca;
end; // procedure TAccessEntry.addCA;

destructor TAccessEntry.Destroy;
var cc,tmp: pChanAccess;
begin
  cc:=chanacs;
  while cc <> nil do
    begin
      tmp:=cc;
      cc:=cc^.next;
      dispose(tmp);
    end;
  inherited Destroy;
end; // destructor TAccessEntry.Destroy;

constructor TAccessList.Create;
begin
  inherited Create;
  root:=nil;
  cafile:=cafl;
end; // constructor TAccessList.Create;

procedure TAccessList.add;
var addon: TAccessEntry;
    caconf: TProIni;
    list: TStringList;
    i: integer;
begin
  del(nick);
  addon:=TAccessEntry.Create(nick,adr,acc);
  caconf:=TProIni.Create(cafile);
  list:=TStringList.Create;
  caconf.ReadSection(nick,list);
  if list.Count > 0 then
    for i:=0 to list.Count - 1 do
      addon.addCA(list[i],caconf.ReadInteger(nick,list[i],1));
  list.Free;
  caconf.Free;
  addon.next:=root;
  root:=addon;
end; // procedure TAccessList.add;

procedure TAccessList.del;
var cur,tmp: TAccessEntry;
    s: string;
begin
  if root = nil then exit;
  s:=AnsiLowerCase(nick);
  if AnsiLowerCase(root.nick) = s then
    begin
      tmp:=root.next;
      root.Free;
      root:=tmp;
      exit;
    end;
  cur:=root;
  while cur.next <> nil do
    begin
      if AnsiLowerCase(cur.next.nick) = s then
        begin
          tmp:=cur.next;
          cur.next:=cur.next.next;
          tmp.Free;
          exit;
        end;
      cur:=cur.next;
    end;
end; // procedure TAccessList.del;

function TAccessList.access;
var cur: TAccessEntry;
    s: string;
    cacur: pChanAccess;
begin
  result:=NOUSER;
  s:=AnsiLowerCase(nick);
  cur:=root;
  while cur <> nil do
    begin
      if (cur.address = adr)and(AnsiLowerCase(cur.nick) = s) then
        begin
          result:=cur.access;
          if (achan <> '*')and(achan <> '') then
            begin
              if achan[1] = '#' then
                s:=AnsiLowerCase(achan)
              else
                s:='#'+AnsiLowerCase(achan);
              cacur:=cur.chanacs;
              while cacur <> nil do
                begin
                  if AnsiLowerCase(cacur^.chan) = s then
                    begin
                      if cacur^.access > result then result:=cacur^.access;
                      break;
                    end;
                  cacur:=cacur^.next;
                end;
            end;
          exit;
        end;
      cur:=cur.next
    end;
end; // function TAccessList.access;

procedure TAccessList.clear;
var cur,tmp: TAccessEntry;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur;
      cur:=cur.next;
      tmp.Free;
    end;
  root:=nil;
end; // procedure TAccessList.clear;

destructor TAccessList.Destroy;
begin
  clear;
  inherited Destroy;
end; // destructor TAccessList.Destroy;

constructor TChannel.Create;
begin
  inherited Create;
  cname:=aname;
  all:=0;
  names_complete:=false;
  root:=nil;
  next:=nil;
  lasttalk:=0;
end; // constructor TChannel.Create;

function TChannel.ison;
var cu: pChanUser;
    s: string;
begin
  result:=false;
  s:=Ansilowercase(nick);
  cu:=root;
  while cu <> nil do
    begin
      if Ansilowercase(cu^.nick) = s then
        begin
          result:=true;
          exit
        end;
      cu:=cu^.next
    end
end; // function TChannel.ison;

procedure TChannel.adduser;
var addon: pChanUser;
    tmp: string;
begin
  tmp:=nick;
  if (tmp[1]='@')or(tmp[1]='%')or(tmp[1]='+') then delete(tmp,1,1);
  inc(all);
  new(addon);
  addon^.nick:=tmp;
  if root = nil then
    addon^.next:=nil
  else
    addon^.next:=root;
  root:=addon
end; // procedure TChannel.adduser;

procedure TChannel.deluser;
var u,tmp: pChanUser;
begin
  if root = nil then exit;
  if root^.nick = nick then
    begin
      tmp:=root^.next;
      dispose(root);
      dec(all);
      root:=tmp;
      exit
    end;
  u:=root;
  while u^.next <> nil do
    begin
      if u^.next^.nick = nick then
        begin
          tmp:=u^.next;
          u^.next:=u^.next^.next;
          dispose(tmp);
          dec(all);
          exit
        end;
      u:=u^.next
    end
end; // procedure TChannel.deluser;

procedure TChannel.clear;
var u,tmp: pChanUser;
begin
  u:=root;
  while u <> nil do
    begin
      tmp:=u;
      u:=u^.next;
      dispose(tmp)
    end;
  root:=nil
end; // procedure TChannel.clear;

procedure TChannel.getusers;
var cu: pChanUser;
begin
  Strings.Clear;
  Strings.BeginUpdate;
  cu:=root;
  while cu <> nil do
    begin
      Strings.Add(cu^.nick);
      cu:=cu^.next;
    end;
  Strings.EndUpdate;
end; // function TChannel.user;

destructor TChannel.Destroy;
begin
  clear;
  inherited Destroy
end; // destructor TChannel.Destroy;

constructor TChannelManager.Create;
begin
  inherited Create;
  root:=nil
end; // constructor TChannelManager.Create;

procedure TChannelManager.add;
var addon: TChannel;
begin
  addon:=TChannel.Create(name);
  if root = nil then
    addon.next:=nil
  else
    addon.next:=root;
  root:=addon
end; // procedure TChannelManager.add;

procedure TChannelManager.del;
var u,tmp: TChannel;
begin
  if root = nil then exit;
  if root.name = name then
    begin
      tmp:=root.next;
      root.Destroy;
      root:=tmp;
      exit
    end;
  u:=root;
  while u.next <> nil do
    begin
      if u.next.name = name then
        begin
          tmp:=u.next;
          u.next:=u.next.next;
          tmp.Destroy;
          exit
        end;
      u:=u.next
    end
end; // procedure TChannelManager.del;

function TChannelManager.getchan;
var cur: TChannel;
    s: string;
begin
  s:=AnsiLowercase(name);
  result:=nil;
  if s = '' then exit;
  if s[1] <> '#' then
    s:='#'+s;
  cur:=root;
  while cur <> nil do
    begin
      if AnsiLowercase(cur.name) = s then
        begin
          result:=cur;
          exit
        end;
      cur:=cur.next
    end
end; // function TChannelManager.getchan;

procedure TChannelManager.clear;
var u,tmp: TChannel;
begin
  u:=root;
  while u <> nil do
    begin
      tmp:=u;
      u:=u.next;
      tmp.Destroy
    end;
  root:=nil
end; // procedure TChannelManager.clear;

procedure TChannelManager.chguser;
var cu: TChannel;
begin
  cu:=root;
  while cu <> nil do
    begin
      if cu.ison(old) then
        begin
          cu.deluser(old);
          cu.adduser(new)
        end;
      cu:=cu.next
    end
end; // procedure TChannelManager.chguser;

procedure TChannelManager.deluser;
var cu: TChannel;
begin
  cu:=root;
  while cu <> nil do
    begin
      cu.deluser(nick);
      cu:=cu.next
    end
end; // procedure TChannelManager.deluser;

function TChannelManager.userchans;
var cur: TChannel;
    res: TStringList;
begin
  cur:=root;
  res:=TStringList.Create;
  result:=res;
  res.BeginUpdate;
  while cur <> nil do
    begin
      if cur.ison(nick) then res.Add(cur.name);
      cur:=cur.next;
    end;
  res.EndUpdate;
end; // function TChannelManager.userchans;

destructor TChannelManager.Destroy;
begin
  clear;
  inherited Destroy
end; // destructor TChannelManager.Destroy;

function TProIni.pcode;
var i: integer;
begin
  i:=1;
  while i <= length(s) do
    begin
      case s[i] of
        '%': begin insert('%',s,i); inc(i); end;
        '[': begin delete(s,i,1); insert('%l',s,i); inc(i); end;
        ']': begin delete(s,i,1); insert('%r',s,i); inc(i); end;
        '=': begin delete(s,i,1); insert('%e',s,i); inc(i); end
      end;
      inc(i)
    end;
  result:=s
end; // function TProIni.pcode;

function TProIni.pdecode;
var i: integer;
begin
  i:=1;
  while i <= length(s)-1 do
    begin
      if s[i] = '%' then
        case s[i+1] of
          '%': delete(s,i,1);
          'l': begin delete(s,i,2); insert('[',s,i); end;
          'r': begin delete(s,i,2); insert(']',s,i); end;
          'e': begin delete(s,i,2); insert('=',s,i); end
        end;
      inc(i)
    end;
  result:=s
end; // function TProIni.pdecode;

procedure TProIni.DeleteKey;
var s: string;
begin
  if (Section = '')or(Ident = '') then exit;
  s:=ExtractFileDir(FileName);
  if not(DirectoryExists(s)) then ForceDirectories(s);
  inherited DeleteKey(pcode(Section),pcode(Ident))
end; // procedure TProIni.DeleteKey;

procedure TProIni.EraseSection;
var s: string;
begin
  if Section = '' then exit;
  s:=ExtractFileDir(FileName);
  if not(DirectoryExists(s)) then ForceDirectories(s);
  inherited EraseSection(pcode(Section))
end; // procedure TProIni.EraseSection;

procedure TProIni.ReadSection;
var i: integer;
begin
  if Section = '' then exit;
  inherited ReadSection(pcode(Section),Strings);
  if Strings.Count > 0 then
    for i:=0 to Strings.Count - 1 do
      Strings[i]:=pdecode(Strings[i])
end; // procedure TProIni.ReadSection;

procedure TProIni.ReadSections;
var i: integer;
begin
  inherited ReadSections(Strings);
  if Strings.Count > 0 then
    for i:=0 to Strings.Count - 1 do
      Strings[i]:=pdecode(Strings[i])
end; // procedure TProIni.ReadSections;

procedure TProIni.ReadSectionValues;
var i: integer;
    keylist: TStringList;
begin
  Strings.Clear;
  if Section = '' then exit;
  keylist:=TStringList.Create;
  ReadSection(Section,keylist);
  if keylist.Count > 0 then
    for i:=0 to keylist.Count - 1 do
      Strings.Add(ReadString(Section,keylist[i],''));
  keylist.Free
end; // procedure TProIni.ReadSectionValues;

function TProIni.ReadInteger;
begin
  if (Section = '')or(Ident = '') then
    begin
      result:=default;
      exit
    end;
  result:=inherited ReadInteger(Section,Ident,Default)
end; // function TProIni.ReadInteger;

function TProIni.ReadBool;
begin
  if (Section = '')or(Ident = '') then
    begin
      result:=default;
      exit
    end;
  result:=inherited ReadBool(Section,Ident,Default)
end; // function TProIni.ReadBool;

function TProIni.ReadString;
begin
  if (Section = '')or(Ident = '') then
    begin
      result:=Default;
      exit
    end;
  result:= inherited ReadString(pcode(Section),pcode(Ident),Default)
end; // function TProIni.ReadString;

procedure TProini.WriteBool;
var s: string;
begin
  if (Section = '')or(Ident = '') then exit;
  s:=ExtractFileDir(FileName);
  if not(DirectoryExists(s)) then ForceDirectories(s);
  inherited WriteBool(Section,Ident,Value)
end; // procedure TProini.WriteBool;

procedure TProini.WriteInteger;
var s: string;
begin
  if (Section = '')or(Ident = '') then exit;
  s:=ExtractFileDir(FileName);
  if not(DirectoryExists(s)) then ForceDirectories(s);
  inherited WriteInteger(Section,Ident,Value)
end; // procedure TProini.WriteInteger;

procedure TProini.WriteString;
var s: string;
begin
  if (Section = '')or(Ident = '') then exit;
  s:=ExtractFileDir(FileName);
  if not(DirectoryExists(s)) then ForceDirectories(s);
  inherited WriteString(pcode(Section),pcode(Ident),Value)
end; // procedure TProini.WriteString;

constructor Taddresslist.Create;
begin
  inherited Create;
  root:=nil
end; // constructor Taddresslist.Create;

procedure Taddresslist.add;
var addon: pAddressEntry;
begin
  del(nick);
  new(addon);
  addon^.nick:=nick;
  addon^.address:=adr;
  if root = nil then
    addon^.next:=nil
  else
    addon^.next:=root;
  root:=addon
end; // procedure Taddresslist.add;

procedure Taddresslist.del;
var cur,tmp: pAddressEntry;
    s: string;
begin
  s:=AnsiLowerCase(nick);
  if root = nil then exit;
  if AnsiLowerCase(root^.nick) = s then
    begin
      tmp:=root^.next;
      dispose(root);
      root:=tmp;
      exit
    end;
  cur:=root;
  while cur^.next <> nil do
    begin
      if AnsiLowerCase(cur^.next^.nick) = s then
        begin
          tmp:=cur^.next;
          cur^.next:=cur^.next^.next;
          dispose(tmp);
          exit
        end;
      cur:=cur^.next
    end
end; // procedure Taddresslist.del;

function Taddresslist.getadr;
var cur: pAddressEntry;
    s: string;
begin
  result:='';
  s:=AnsiLowerCase(nick);
  cur:=root;
  while cur <> nil do
    begin
      if AnsiLowerCase(cur^.nick) = s then
        begin
          result:=cur^.address;
          exit
        end;
      cur:=cur^.next
    end
end; // function Taddresslist.getadr

procedure Taddresslist.clear;
var cur,tmp: pAddressEntry;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur;
      cur:=cur^.next;
      dispose(tmp)
    end;
  root:=nil
end; // procedure Taddresslist.clear;

destructor Taddresslist.Destroy;
begin
  clear;
  inherited Destroy
end; // destructor Taddresslist.Destroy;

constructor TSegFile.Create;
begin
  inherited Create;
  fname:=filename
end; // constructor TSegFile.Create;

procedure TSegFile.ReadSection;
var F: TextFile;
    canread: boolean;
    s,sec: string;
begin
  sec:='['+AnsiLowerCase(Section)+']';
  canread:=false;
  list.BeginUpdate;
  list.Clear;
  AssignFile(F,fname);
  try reset(F);
  except
    list.EndUpdate;
    exit
  end;
  while not(eof(F)) do
    begin
      readln(F,s);
      if s = '' then continue;
      if (s[1] = '[')and(s[length(s)] = ']') then
        begin
          if AnsiLowerCase(s) = sec then canread:=true
          else
            if canread then break
        end
      else
        if canread then list.Add(s)
    end;
  list.EndUpdate;
  CloseFile(F);
end; // procedure TSegFile.ReadSection;

procedure TSegFile.DelString;
var src,tmp: TextFile;
    str,ls,sec: string;
    secfind: boolean;
begin
  sec:='['+AnsiLowerCase(Section)+']';
  secfind:=false;
  Randomize;
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then
          begin
            writeln(tmp);
            continue;
          end;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              secfind:=true
            else
              secfind:=false;
            writeln(tmp,ls);
          end
        else
          if not((secfind)and(ls = s)) then
            writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
  end;
end; // procedure TSegFile.DelString;

procedure TSegFile.AddString;
var src,tmp: TextFile;
    str,ls,sec: string;
    writed: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  writed:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    rewrite(tmp);
    if FileExists(fname) then
      begin
        reset(src);
        while not(eof(src)) do
          begin
            readln(src,ls);
            if ls='' then
              begin
                writeln(tmp);
                continue;
              end;
            writeln(tmp,ls);
            if (not(writed))and(AnsiLowerCase(ls) = sec) then
              begin
                writeln(tmp,s);
                writed:=true;
              end;
          end;
        CloseFile(src);
      end;
    if not(writed) then
      begin
        writeln(tmp,'['+Section+']');
        writeln(tmp,s);
      end;
    CloseFile(tmp);
    try Erase(src); except end;
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
  end;
end; // procedure TSegFile.AddString;

procedure TSegFile.DelSection;
var src,tmp: TextFile;
    str,ls,sec: string;
    candel: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  candel:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then
          begin
            if not(candel) then writeln(tmp);
            continue;
          end;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              candel:=true
            else
              candel:=false;
          end;
        if not(candel) then
          writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
  end;
end; // procedure TSegFile.DelSection;

procedure TSegFile.ReadSections;
var f: TextFile;
    s: string;
begin
  Strings.BeginUpdate;
  Strings.Clear;
  AssignFile(f,fname);
  try
    reset(f);
    while not(eof(f)) do
      begin
        readln(f,s);
        if s <> '' then
          if (s[1] = '[')and(s[length(s)] = ']') then Strings.Add(copy(s,2,length(s)-2));
      end;
  except end;
  Strings.EndUpdate;
  try CloseFile(f);
  except end;
end; // procedure TSegFile.ReadSections;

function TSegFile.SectionExists;
var f: TextFile;
    s: string;
begin
  result:=false;
  AssignFile(f,fname);
  try
    reset(f);
    while not(eof(f)) do
      begin
        readln(f,s);
        if AnsiLowerCase(s) = '['+AnsiLowerCase(Section)+']' then result:=true;
      end;
  finally
    try closefile(f);
    except end;
  end;
end; // function TSegFile.SectionExists;

constructor TGlobalLists.Create;
begin
  inherited Create;
  badwords:=TStringList.Create;
end; // constructor TGlobalLists.Create;

destructor TGlobalLists.Destroy;
begin
  badwords.Free;
  inherited Destroy;
end; // destructor TGlobalLists.Destroy;

constructor TAlias.Create;
begin
  inherited Create;
  aliases:=TStringList.Create;
  aliases.Add(command);
  next:=nil;
end; // constructor TAlias.Create;

destructor TAlias.Destroy;
begin
  aliases.Free;
  inherited Destroy;
end; // destructor TAlias.Destroy;

constructor TAliasManager.Create;
var addon: TAlias;
begin
  inherited Create;
  addon:=TAlias.Create('!hop');
  root:=addon;
  addon:=TAlias.Create('!dehop');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!names');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!topic');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!invite');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!op');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!deop');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!mass');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!phrasereaction');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!useglobalbase');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!kick');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!ban');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!unban');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!chanaccess');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!bot');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!seenchan');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!talk');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!hello');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!dialogue');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!talksetup');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!act');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!say');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!acclist');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!id');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!join');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!part');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!rejoin');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!perform');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!ijoin');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!ujoin');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!talkfreq');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!com');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!quit');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!mact');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!amsg');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!adduser');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!deluser');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!nick');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!rename');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!reboot');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!help');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!ident');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!version');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!date');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!time');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!uptime');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!seen');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!send');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!read');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!register');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!unident');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!voice');
  addon.next:=root;
  root:=addon;
  addon:=TAlias.Create('!devoice');
  addon.next:=root;
  root:=addon;
end; // constructor TAliasManager.Create;

destructor TAliasManager.Destroy;
var cur,tmp: TAlias;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur;
      cur:=cur.next;
      tmp.Destroy;
    end;
  inherited Destroy;
end; // destructor TAliasManager.Destroy;

function TAliasManager.validcommand;
var cur: TAlias;
begin
  result:=false;
  cur:=root;
  while cur <> nil do
    begin
      if LowerCase(cur.aliases[0]) = LowerCase(comnd) then
        begin
          result:=true;
          exit;
        end;
      cur:=cur.next;
    end;
end; // function TAliasManager.validcommand;

procedure TAliasManager.Add;
var cur: TAlias;
    i: integer;
begin
  cur:=root;
  while cur <> nil do
    begin
      if cur.aliases[0] = list[0] then
        begin
          if list.Count = 1 then exit;
          for i:=1 to list.Count - 1 do
            cur.aliases.Add(list[i]);
          exit;
        end;
      cur:=cur.next;
    end;
end; // procedure TAliasManager.Add;

function TAliasManager.getcommand;
var cur: TAlias;
    i: integer;
begin
  result:='';
  cur:=root;
  cmd_prot:=AnsiLowerCase(cmd_prot);
  while cur <> nil do
    begin
      for i:=0 to cur.aliases.Count - 1 do
        if cur.aliases[i] = cmd_prot then
          begin
            result:=cur.aliases[0];
            exit;
          end;
      cur:=cur.next;
    end;
end; // function TAliasManager.getcommand;

constructor TDSegFile.Create;
begin
  inherited Create;
  fname:=filename;
end; // constructor TDSegFile.Create;

procedure TDSegFile.ReadSections;
var f: TextFile;
    s: string;
    i: integer;
begin
  Strings.BeginUpdate;
  Strings.Clear;
  AssignFile(f,fname);
  try
    reset(f);
    while not(eof(f)) do
      begin
        readln(f,s);
        if s <> '' then
          if (s[1] = '[')and(s[length(s)] = ']') then Strings.Add(copy(s,2,length(s)-2));
      end;
  except end;
  if Strings.Count > 0 then
    for i:=0 to Strings.Count - 1 do
      if Strings[i] = '' then Strings.Delete(i);
  Strings.EndUpdate;
  try CloseFile(f);
  except end;
end; // procedure TDSegFile.ReadSections;

procedure TDSegFile.ReadSubSections;
var F: TextFile;
    s,sec: string;
    i: integer;
    canread: boolean;
begin
  sec:='['+AnsiLowerCase(Section)+']';
  canread:=false;
  Strings.BeginUpdate;
  Strings.Clear;
  AssignFile(F,fname);
  try reset(F);
  except
    Strings.EndUpdate;
    exit;
  end;
  while not(eof(F)) do
    begin
      readln(F,s);
      if s = '' then continue;
      if (s[1] = '[')and(s[length(s)] = ']') then
        begin
          if AnsiLowerCase(s) = sec then
            canread:=true
          else
            canread:=false;
        end;
      if not(canread) then continue;
      if (s[1] = '{')and(s[length(s)] = '}') then
        begin
          s:=copy(s,2,length(s)-2);
          if dosplit then
            begin
              i:=pos(';',s);
              while i<>0 do
                begin
                  Strings.Add(copy(s,1,i-1));
                  delete(s,1,i);
                  i:=pos(';',s)
                end;
              Strings.Add(s);
            end
          else
            Strings.Add(s);
        end;
    end;
  if Strings.Count > 0 then
    for i:=0 to Strings.Count - 1 do
      if Strings[i] = '' then Strings.Delete(i);
  Strings.EndUpdate;
  CloseFile(F);
end; // procedure TDSegFile.ReadSubSections;

procedure TDSegFile.ReadSubSection;
var F: TextFile;
    s,sec,subsec: string;
    i: integer;
    canread,subcanread: boolean;
begin
  canread:=false;
  subcanread:=false;
  sec:='['+AnsiLowerCase(Section)+']';
  subsec:=AnsiLowerCase(SubSection);
  Strings.BeginUpdate;
  Strings.Clear;
  AssignFile(F,fname);
  try reset(F);
  except
    Strings.EndUpdate;
    exit;
  end;
  while not(eof(F)) do
    begin
      readln(F,s);
      if s = '' then continue;
      if (s[1] = '[')and(s[length(s)] = ']') then
        begin
          if AnsiLowerCase(s) = sec then
            begin
              canread:=true;
              if subsec = '' then subcanread:=true;
            end
          else
            canread:=false;
          continue;
        end;
      if not(canread) then continue;
      if (s[1] = '{')and(s[length(s)] = '}') then
        begin
          s:=AnsiLowerCase(copy(s,2,length(s)-2));
          subcanread:=false;
          if dosplit then
            begin
              i:=pos(';',s);
              while i<>0 do
                begin
                  if copy(s,1,i-1) = subsec then
                    subcanread:=true;
                  delete(s,1,i);
                  i:=pos(';',s)
                end;
              if s = subsec then
                subcanread:=true;
            end
          else
            if s = subsec then
              subcanread:=true;
        end
      else
        begin
          if (canread)and(subcanread) then
            Strings.Add(s);
        end;
    end;
  Strings.EndUpdate;
  CloseFile(F);
end; // procedure TDSegFile.ReadSubSection;

procedure TDSegFile.ModifySubSection;
var src,tmp: TextFile;
    str,ls,sec,subsec: string;
    secfind: boolean;
begin
  if newname = '' then
    begin
      DelSubSection(Section,OldName);
      exit;
    end;
  sec:='['+AnsiLowerCase(Section)+']';
  subsec:='{'+AnsiLowerCase(OldName)+'}';
  secfind:=false;
  Randomize;
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then continue;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              secfind:=true
            else
              secfind:=false;
            writeln(tmp,ls);
            continue;
          end;
        if not(secfind) then
          begin
            writeln(tmp,ls);
            continue;
          end;
        if AnsiLowerCase(ls) = subsec then
          writeln(tmp,'{'+NewName+'}')
        else
          writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      Erase(tmp);
    except end;
  end;
end; // procedure TDSegFile.ModifySubSection;

procedure TDSegFile.DelSection;
var src,tmp: TextFile;
    str,ls,sec: string;
    candel: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  candel:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then continue;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              candel:=true
            else
              candel:=false;
          end;
        if not(candel) then
          writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      Erase(tmp);
    except end;
  end;
end; // procedure TDSegFile.DelSection;

procedure TDSegFile.DelSubSection;
var src,tmp: TextFile;
    str,ls,sec,subsec: string;
    candel,subcandel: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  subsec:='{'+AnsiLowerCase(SubSection)+'}';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  candel:=false;
  subcandel:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then continue;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              begin
                candel:=true;
                if subsec = '{}' then subcandel:=true;
              end
            else
              candel:=false;
            writeln(tmp,ls);
            continue;
          end;
        if (ls[1] = '{')and(ls[length(ls)] = '}') then
          begin
            if AnsiLowerCase(ls) = subsec then
              subcandel:=true
            else
              subcandel:=false;
          end;
        if not((subcandel)and(candel)) then
          writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      Erase(tmp);
    except end;
  end;
end; // procedure TDSegFile.DelSubSection;

procedure TDSegFile.WriteString;
var src,tmp: TextFile;
    str,ls,sec,subsec: string;
    candel,writen: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  subsec:='{'+AnsiLowerCase(SubSection)+'}';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  candel:=false;
  writen:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then continue;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              begin
                candel:=true;
                if subsection = '' then
                  begin
                    writeln(tmp,ls);
                    writeln(tmp,s);
                    writen:=true;
                    continue;
                  end;
              end
            else
              begin
                if (candel = true)and(not(writen)) then
                  begin
                    writeln(tmp,'{'+SubSection+'}');
                    writeln(tmp,s);
                    writen:=true;
                  end;
                candel:=false;
              end;
          end;
        if (ls[1] = '{')and(ls[length(ls)] = '}') then
          if (candel)and(not(writen)) then
            if AnsiLowerCase(ls) = subsec then
              begin
                writeln(tmp,ls);
                writeln(tmp,s);
                writen:=true;
                continue;
              end;
        writeln(tmp,ls);
      end;
    if not(writen) then
      begin
        if not(candel) then writeln(tmp,'['+Section+']');
        if SubSection <> '' then writeln(tmp,'{'+SubSection+'}');
        writeln(tmp,s);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      Erase(tmp);
    except end;
  end;
end; // procedure TDSegFile.WriteString;

procedure TDSegFile.DelString;
var src,tmp: TextFile;
    str,ls,sec,subsec: string;
    candel,subcandel: boolean;
begin
  Randomize;
  sec:='['+AnsiLowerCase(Section)+']';
  subsec:='{'+AnsiLowerCase(SubSection)+'}';
  AssignFile(src,fname);
  str:='';
  while str = '' do
    begin
      str:=fname+'.'+inttostr(random(10000))+'.tmp';
      if FileExists(str) then str:='';
    end;
  AssignFile(tmp,str);
  candel:=false;
  subcandel:=false;
  try
    if not(DirectoryExists(ExtractFileDir(fname))) then
      ForceDirectories(ExtractFileDir(fname));
    reset(src);
    rewrite(tmp);
    while not(eof(src)) do
      begin
        readln(src,ls);
        if ls='' then continue;
        if (ls[1] = '[')and(ls[length(ls)] = ']') then
          begin
            if AnsiLowerCase(ls) = sec then
              begin
                candel:=true;
                if subsec = '{}' then subcandel:=true;
              end
            else
              candel:=false;
            writeln(tmp,ls);
            continue;
          end;
        if (ls[1] = '{')and(ls[length(ls)] = '}') then
          begin
            if AnsiLowerCase(ls) = subsec then
              subcandel:=true
            else
              subcandel:=false;
            writeln(tmp,ls);
            continue;
          end;
        if not((subcandel)and(candel)) then
          writeln(tmp,ls)
        else
          if ls <> s then
            writeln(tmp,ls);
      end;
    CloseFile(src);
    CloseFile(tmp);
    Erase(src);
    Rename(tmp,fname);
  except
    try
      CloseFile(src);
    except end;
    try
      CloseFile(tmp);
    except end;
    try
      Erase(tmp);
    except end;
  end;
end; // procedure TDSegFile.DelString;

end.
