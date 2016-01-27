unit mgr;
interface
uses ScktComp, Classes, SysUtils, struct, func, main, ExtCtrls, time, DateUtils,
help, seen, talk, timers, ident, badwords, spoolers, seims, ShellApi;

const crlf = #13#10;
const version = '0.3';
const currelease = '0.3';

//{$DEFINE DEBUG}

type TMsgManager = class(TClientSocket)
  private
    sbuffer: string;
    enablebuffering: boolean;
    identd: TIdentd;
  public
    connect_attempts: integer;
    CTimer: TTimer;
    Inspector: TTimer;
    ConnectChecker: TTimer;
    constructor Create(AOwner: TComponent); override;
    procedure Send(const text: string);
    procedure SockRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure connected(Sender: TObject; Socket: TCustomWinSocket);
    procedure SockOpen;
    procedure disconnected(Sender: TObject; Socket: TCustomWinSocket);
    procedure sockerror(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure TimeToConnect(Sender: TObject);
    procedure SockInspect(Sender: TObject);
    procedure ResetConnect(Sender: TObject);
    procedure OpenBuffer;
    procedure CloseBuffer;
    procedure InitIdentd(const identvalue: string);
    destructor Destroy; override;
    property buffer: string read sbuffer;
    property identserver: TIdentd read identd;
  end;

type TCloser = class(TTimer)
  private
    action: string;
  public
    constructor Create(act: string); reintroduce;
    procedure exec(Sender: TObject);
  end;

procedure send(const text: string);
procedure msg(const target,text: string);
procedure quit(const qmsg: string = '');
procedure kick(const nick,chan: string; const reason: string = '');
procedure notice(const target,text: string);
procedure dispetcher(ws: string);
procedure setcaption(const caption: string);
procedure ban(const nick,chan: string);
function cmd(const acmd: string): string;

////////// Global Variables //////////////////////////////////
var                                                         //
  sock:        TMsgManager;      // Socket for connection   //
  settings:    Tsettings;        // Settings Base           //
  global:      TGlobal;          // Global data             //
  accesslist:  TAccessList;      // Access list             //
  addresslist: TAddressList;     // Address list            //
  channel:     TChannelManager;  // List of channels        //
  timer:       TTimerManager;    // Timers Manager          //
  lists:       TGlobalLists;     // StringList Manager      //
  spooler:     TSpoolersManager; // Timed Message Manager   //
  seim:        TSeimManager;     // Intermediate States     //
  alias:       TAliasManager;    // Command aliases         //
  closerrr:    TCloser;          // fbot's killer =)        //
                                                            //
//////////////////////////////////////////////////////////////

implementation
uses gui;

procedure send;
begin
  {$IFDEF DEBUG}
  writedebug('>>> '+text);
  {$ENDIF}
  Sock.Send(text);
end; // procedure send;

procedure msg;
begin
  if (global.nick = '')or(not(sock.Active)) then exit;
  if settings.outlog then
    case settings.logstyle of
      0: logmsg(target,'<'+global.nick+'> '+text);
      1: logmsg(target,'['+global.nick+']   '+text)
    end;
  send('PRIVMSG '+target+' :'+text);
end; // procedure msg;

procedure quit;
begin
  if (global.nick = '')or(not(sock.Active)) then exit;
  if qmsg <> '' then
    send('QUIT :'+qmsg)
  else
    begin
      if settings.qmsg <> '' then
        send('QUIT :'+settings.qmsg)
      else
        send('QUIT :fbot')
    end
end; // procedure quit;

procedure kick;
begin
  if (global.nick = '')or(not(sock.Active)) then exit;
  if access(nick,address(nick),chan) >= OPERATOR then exit;
  if reason <> '' then
    send('KICK '+chan+' '+nick+' '+reason)
  else
    send('KICK '+chan+' '+nick+' '+settings.kmsg)
end; // procedure kick;

procedure ban;
var s: string;
begin
  if (global.nick = '')or(not(sock.Active)) then exit;
  s:=address(nick);
  if access(nick,s,chan) >= OPERATOR then exit;
  if s = '' then send('MODE '+chan+' +b '+nick+'!*@*')
  else send('MODE '+chan+' +b *!'+s);
end; // procedure ban;

procedure notice;
begin
  if (global.nick = '')or(not(sock.Active)) then exit;
  send('NOTICE '+target+' :'+text)
end; // procedure notice;

function cmd;
begin
  result:=alias.getcommand(acmd);
end; // function cmd;

constructor TCloser.Create;
begin
  inherited Create(nil);
  onTimer:=exec;
  interval:=1000;
  enabled:=true;
  action:=act;
end; // constructor TCloser.Create;

procedure TCloser.exec;
begin
  try Shell_NotifyIcon(NIM_DELETE,@nid) except end;
  if action = 'exit' then
    begin
      settings.confirmexit:=false;
      MainForm.Close;
    end;
  if action = 'reboot' then
    begin
      settings.confirmreboot:=false;
      MainForm.btReloadClick(MainForm);
    end;
  Destroy;
end; // procedure TCloser.exec;

constructor TMsgManager.Create;
begin
  inherited Create(AOwner);
  CTimer:=TTimer.Create(AOwner);
  CTimer.Interval:=3000;
  CTimer.Enabled:=false;
  CTimer.OnTimer:=TimeToConnect;
  Inspector:=TTimer.Create(AOwner);
  Inspector.Interval:=180000;
  Inspector.Enabled:=true;
  Inspector.OnTimer:=SockInspect;
  ConnectChecker:=TTimer.Create(AOwner);
  ConnectChecker.Interval:=30000;
  ConnectChecker.Enabled:=false;
  ConnectChecker.OnTimer:=ResetConnect;
  ClientType:=ctNonBlocking;
  OnConnect:=connected;
  OnRead:=SockRead;
  OnError:=SockError;
  OnDisconnect:=disconnected;
  connect_attempts:=0;
  enablebuffering:=false;
  sbuffer:='';
  identd:=TIdentd.Create(self);
end; // constructor TMsgManager.Create;

procedure TMsgManager.Send;
begin
  if length(text) > 526 then
    begin
      Socket.SendText(text+crlf);
      exit;
    end;
  if enablebuffering then
    begin
      if length(sbuffer)+length(text)+2 > 529 then
        begin
          Socket.SendText(sbuffer);
          sbuffer:='';
        end;
      sbuffer:=sbuffer+text+crlf;
    end
  else
    Socket.SendText(text+crlf);
end; // procedure TMsgManager.Send;

procedure TMsgManager.OpenBuffer;
begin
  sbuffer:='';
  enablebuffering:=true;
end; // procedure TMsgManager.OpenBuffer;

procedure TMsgManager.CloseBuffer;
begin
  Socket.SendText(sbuffer);
  sbuffer:='';
  enablebuffering:=false;
end; // procedure TMsgManager.CloseBuffer;

procedure TMsgManager.connected;
begin
  connect_attempts:=0;
  ConnectChecker.Enabled:=false;
  if settings.servpass <> '' then send('PASS '+settings.servpass);
  send('NICK '+settings.nick);
  send('USER '+settings.user+' fbot fbot :'+settings.realname)
end; // procedure TMsgManager.onconnect;

procedure TMsgManager.TimeToConnect;
begin
  CTimer.Enabled:=false;
  SockOpen;
end; // procedure TMsgManager.TimeToConnect;

procedure TMsgManager.SockInspect;
begin
  if CTimer.Enabled then exit
  else
    begin
      if not(Active) then
        begin
          writelog('['+DateTimeToStr(Now)+'] обнаружена остановка системы. Перезапускаюсь.');
          CTimer.Enabled:=true;
        end
      else
        send('TIME');
    end;
end; // procedure TMsgManager.SockInspect;

procedure TMsgManager.ResetConnect;
begin
  global.connect_time:=0;
  active:=false;
  writelog('['+DateTimeToStr(Now)+'] истекло время ожидания соединения. переподключаюсь.');
  CTimer.Enabled:=true;
end; // procedure TMsgManager.ResetConnect;

procedure TMsgManager.SockOpen;
var alts: TStringList;
    adata: TProIni;
    i: integer;
begin
  if Active then
    begin
      Active:=false;
      exit;
    end;
  if settings.altservers then
    begin
      alts:=TStringList.Create;
      adata:=TProIni.Create(global.dir+'conf\altservers.conf');
      adata.ReadSections(alts);
      i:=(connect_attempts mod (alts.Count+1));
      if i = 0 then
        begin
          sock.Host:=settings.mhost;
          sock.Port:=settings.mport;
          settings.servpass:=settings.mservpass
        end
      else
        begin
          sock.Host:=adata.ReadString(alts[i-1],'host',settings.mhost);
          sock.Port:=adata.ReadInteger(alts[i-1],'port',6667);
          settings.servpass:=adata.ReadString(alts[i-1],'pass','')
        end;
      alts.Destroy;
      adata.Destroy
    end
  else
    begin
      sock.Host:=settings.mhost;
      sock.Port:=settings.mport;
      settings.servpass:=settings.mservpass
    end;
  inc(connect_attempts);
  if connect_attempts < 8 then
  writelog('['+DateTimeToStr(Now)+'] попытка соединения с '+sock.Host+':'+
    inttostr(sock.port));
  CTimer.Enabled:=false;
  Active:=true;
  try identd.Open;
  except end;
  ConnectChecker.Enabled:=true;
end; // procedure TMsgManager.SockOpen;

procedure TMsgManager.disconnected;
var list: TStringList;
    ini: TProIni;
    n: integer;
    i: word;
begin
  ConnectChecker.Enabled:=false;
  if global.connect_time = 0 then exit;
  timer.DelTimer('SET_NICK');
  if (global.connect_time <> 0)and(global.network <> '') then
    begin
      ini:=TProIni.Create(global.dir+'main\uptime.dat');
      n:=ini.ReadInteger('network',global.network,0);
      if (ctime - global.connect_time) > n then
        ini.WriteInteger('network',global.network,ctime - global.connect_time);
      ini.Free
    end;
  writelog('['+DateTimeToStr(Now)+'] соединение разорвано.');
  list:=userchans(global.nick);
  if settings.rejoinonconnect then
    begin
      if not(DirectoryExists(global.dir+'main')) then
        ForceDirectories(global.dir+'main');
      try list.SaveToFile(global.dir+'main\joinonconnect.local');
      except end
    end;
  if list.Count > 0 then
  for i:=0 to list.Count-1 do
    case settings.logstyle of
      0: begin
        logmsg(list[i],'* Disconnected');
        logmsg(list[i],'Session Close: '+mirctime,false);
        logmsg(list[i],'',false)
        end
    end;
  list.Free;
  accesslist.clear;
  channel.clear;
  addresslist.clear;
  global.nick:='';
  global.server_name:='';
  global.connect_time:=0;
  global.network:='';
  if not(CTimer.Enabled) then CTimer.Enabled:=true;
  setcaption('fbot');
  identd.Close;
end; // procedure TMsgManager.disconnected;

procedure TMsgManager.sockerror;
begin
  ConnectChecker.Enabled:=false;
  if connect_attempts < 8 then
  writelog('['+DateTimeToStr(Now)+'] ошибка соединения ('+inttostr(ErrorCode)+')');
  Active:=false;
  if not(CTimer.Enabled) then CTimer.Enabled:=true;
  ErrorCode:=0;
  setcaption('fbot');
  identd.Close;
end; // procedure TMsgManager.sockerror;

procedure TMsgManager.SockRead;
var str: string;
    i: integer;
    s: TStringList;
begin
  str:=Socket.ReceiveText;
  rmchar(str,#13);
  s:=split(str,#10);
  OpenBuffer;
  for i:=0 to s.Count-1 do
    if s[i] <> '' then dispetcher(s[i]);
  CloseBuffer;
  s.Free;
end; // procedure TMsgManager.SockRead;

procedure setcaption;
var i: integer;
    s: string;
begin
  MainForm.Caption:=caption;
  if length(caption) > 64 then
    s:=copy(caption,1,61)+'...'
  else
    s:=caption;
  for i:=0 to 63 do nid.szTip[i]:=#0;
  for i:=1 to length(s) do nid.szTip[i-1]:=s[i];
  MainForm.modifyicon;
end; // procedure setcaption;

procedure dispetcher;
var s,first,index,nick,adr,target,amsg,knick: string;
    privmsg,list: TStringList;
    k: word;
begin
  try
  {$IFDEF DEBUG}
  writedebug(ws);
  {$ENDIF}
  s:=ws;
  if pos(' ',ws)=0 then exit;          // One word!
  first:=copy(ws,1,pos(' ',ws)-1);
  delete(ws,1,pos(' ',ws));
  if pos(' ',ws)=0 then
    begin                                  // Two words!
      if first='PING' then send('PONG '+copy(s,7,length(s)-6));
      exit;
    end;
  index:=copy(ws,1,pos(' ',ws)-1);
  ws:=s;

  if index='PRIVMSG' then
    begin                                  //   PRIVMSG
      delete(ws,1,1);
      nick:=copy(ws,1,pos('!',ws)-1);      // Got NICK of sender
      delete(ws,1,pos('!',ws));
      adr:=copy(ws,1,pos(' ',ws)-1);       // Got Address of sender
      delete(ws,1,pos(' ',ws));
      delete(ws,1,pos(' ',ws));
      target:=copy(ws,1,pos(' ',ws)-1);    // Got msg target
      delete(ws,1,pos(':',ws));
      if (ws[1] = #1)and(ws[2]<>'A') then                   // CTCP
        begin
          try
            if (copy(ws,2,4) = 'PING')and(settings.ctcp_ping = true) then
              send('NOTICE '+nick+' :'+ws);
            if copy(ws,2,7) = 'VERSION' then
              send('NOTICE '+nick+' :'#1'VERSION - fbot v'+version+' -'#1);
            if (copy(ws,2,4) = 'TIME')and(settings.ctcp_time = true) then
              send('NOTICE '+nick+' :'#1'TIME '+mirctime+#1);
          except end;
          exit;
        end;
      if pos('#',target) <> 0 then         // channel message
        begin
          if settings.chanlog then         // log message
            begin
              if copy(ws,1,7) <> #1'ACTION' then
                case settings.logstyle of
                  0: logmsg(target,'<'+nick+'> '+ws);
                  1: logmsg(target,'<'+nick+'>   '+ws)
                end
              else
                begin
                  rmchar(ws,#1);
                  delete(ws,1,6);
                  case settings.logstyle of
                    0: logmsg(target,'* '+nick+ws);
                    1: logmsg(target,' * '+nick+ws)
                  end;
                end
            end;
          seen_chantext(nick,adr,target);
          talk_chantext(nick,adr,target,ws);
          if not(funcenabled(target,BOT)) then exit;
          badw_chantext(nick,adr,target,ws);
          if ws[1] = '!' then              // command!
            begin
              privmsg:=msgsplit(ws,' ');   // Split message on words
              main_chancom(nick,adr,target,ws,privmsg);
              seen_chancom(nick,adr,target,ws,privmsg);
              talk_chancom(nick,adr,target,ws,privmsg);
              badw_chancom(nick,adr,target,ws,privmsg);
              main_command(nick,adr,target,ws,privmsg);
              help_command(nick,adr,ws,privmsg);
              seen_command(nick,adr,target,ws,privmsg);
              privmsg.Free;
            end
        end
      else
        begin                              // private message
          if settings.querylog then        // log message
            begin
              if copy(ws,1,7) <> #1'ACTION' then
                case settings.logstyle of
                  0: logmsg(nick,'<'+nick+'> '+ws);
                  1: logmsg(nick,'<'+nick+'>   '+ws)
                end
              else
                begin
                  rmchar(ws,#1);
                  delete(ws,1,6);
                  case settings.logstyle of
                    0: logmsg(nick,'* '+nick+ws);
                    1: logmsg(nick,' *> '+nick+ws)
                  end
                end
            end;
          talk_querytext(nick,adr,ws);
          if ws[1] = '!' then
            begin
              privmsg:=msgsplit(ws,' ');       // Split message on words
              main_querycom(nick,adr,ws,privmsg);
              seen_querycom(nick,adr,ws,privmsg);
              talk_querycom(nick,adr,ws,privmsg);
              badw_querycom(nick,adr,ws,privmsg);
              main_command(nick,adr,nick,ws,privmsg);
              help_command(nick,adr,ws,privmsg);
              seen_command(nick,adr,nick,ws,privmsg);
              privmsg.Free
            end
        end;
      exit;
    end;
  if index='NOTICE' then
    begin                                  //   MSG NOTICE
      if pos('!',word1(ws)) = 0 then
        begin
          nick:=word1(ws);
          adr:='IRC.SERVER'
        end
      else
        getnickadr(word1(ws),nick,adr);
      target:=word3(ws);
      amsg:=irc_data(ws);
      if (pos('.',nick)=0)and(target = global.nick) then
        begin
          if settings.querylog then
            case settings.logstyle of
              0: logmsg(nick,'-'+nick+'- '+amsg);
              1: logmsg(nick,'='+nick+'=   '+amsg)
            end
        end;
      if (pos('.',nick)=0)and(target <> global.nick) then
        begin
          if settings.chanlog then
            case settings.logstyle of
              0: logmsg(target,'-'+nick+'- '+amsg);
              1: logmsg(target,'='+nick+'=   '+amsg)
            end
        end;
      main_notice(nick,adr,target,amsg);
      exit;
    end;
  seim.getmsg(index,ws);   // Обработка в SEIM
                           // Warning: нотисы и privmsg не обрабатываются!
  if index='MODE' then
    begin                                  //   MSG MODE
      getnickadr(word1(ws),nick,adr);
      target:=word3(ws);
      amsg:=ws;
      delete(amsg,1,pos(' ',amsg));
      delete(amsg,1,pos(' ',amsg));
      delete(amsg,1,pos(' ',amsg));
      if (pos('#',target)<>0)and(settings.chanlog) then
        case settings.logstyle of
          0: logmsg(target,'* '+nick+' sets mode: '+amsg);
          1: logmsg(target,'*** Mode change ['+trim(amsg)+'] on channel '+target+
            ' by '+nick)
        end;                               // log message
      if pos('#',target)<>0 then
        main_mode(nick,adr,target,amsg);
      exit;
    end;
  if index='JOIN' then
    begin                                  //   MSG JOIN
      getnickadr(word1(ws),nick,adr);
      target:=irc_data(ws);
      if settings.chanlog then
        begin
          if nick = global.nick then           // log message
            case settings.logstyle of
              0: begin
                logmsg(target,'Session Start: '+mirctime,false);
                logmsg(target,'Session Ident: '+target,false);
                logmsg(target,'* Now talking in '+target)
                end;
              1: logmsg(target,'*** '+nick+' ('+adr+') has joined channel '+target)
            end
          else
            case settings.logstyle of
              0: logmsg(target,'* '+nick+' has joined '+target);
              1: logmsg(target,'*** '+nick+' ('+adr+') has joined channel '+target)
            end;
        end;
      main_join(nick,adr,target);
      seen_join(nick,adr,target);
      if not(funcenabled(target,BOT)) then exit;
      talk_join(nick,adr,target);
      exit;
    end;
  if index='PART' then
    begin                                  //   MSG PART
      getnickadr(word1(ws),nick,adr);
      target:=word3(ws);
      if settings.chanlog then
        begin
          if nick = global.nick then           // log message
            begin
              logmsg(target,'Session Close: '+mirctime,false);
              logmsg(target,'',false)
            end
          else
            case settings.logstyle of
              0: logmsg(target,'* '+nick+' has left '+target);
              1: logmsg(target,'*** '+nick+' ('+adr+') has left channel '+target)
            end;
        end;
      main_part(nick,adr,target);
      seen_part(nick,adr,target);
      exit;
    end;
  if index='NICK' then
    begin                                  //   MSG NICK
      getnickadr(word1(ws),nick,adr);
      target:=irc_data(ws);
      if settings.chanlog then
        begin
          list:=userchans(nick);             // log message
          if list.Count > 0 then
          for k:=0 to list.Count-1 do
            case settings.logstyle of
              0: logmsg(list[k],'* '+nick+' is now known as '+target);
              1: logmsg(list[k],'*** '+nick+' is now known as '+target)
            end;
          list.Free;
        end;
      main_nick(nick,adr,target);
      seen_nick(nick,adr,target);
      exit;
    end;
  if index='QUIT' then
    begin                                  //   MSG QUIT
      getnickadr(word1(ws),nick,adr);
      amsg:=irc_data(ws);
      if settings.chanlog then
        begin
          list:=userchans(nick);             // log message
          if list.Count > 0 then
          for k:=0 to list.Count-1 do
            case settings.logstyle of
              0: logmsg(list[k],'* '+nick+' has quit IRC ('+amsg+')');
              1: logmsg(list[k],'*** Signoff: '+nick+' ('+adr+') has left IRC ['+
                amsg+']')
            end;
          list.Free
        end;
      main_quit(nick,adr,amsg);
      seen_quit(nick,adr,amsg);
      exit;
    end;
  if index='KICK' then
    begin                                  //   MSG KICK
      getnickadr(word1(ws),nick,adr);
      target:=word3(ws);
      knick:=word4(ws);
      amsg:=irc_data(ws);
      if (knick = global.nick)and(settings.rejoinonkick) then
        send('JOIN '+target);
      if settings.chanlog then
        begin
          if knick = global.nick then           // log message
            case settings.logstyle of
              0: begin
                logmsg(target,'You were kicked by '+nick+' ('+amsg+')');
                logmsg(target,'Session Close: '+mirctime,false);
                logmsg(target,'',false)
                end;
              1: logmsg(target,'*** '+nick+' has kicked '+knick+' from channel '+
               target+' ['+amsg+']')
            end
          else
            case settings.logstyle of
              0: logmsg(target,'* '+knick+' was kicked by '+nick+' ('+amsg+')');
              1: logmsg(target,'*** '+nick+' has kicked '+knick+' from channel '+
                target+' ['+amsg+']')
            end;
        end;
      main_kick(nick,adr,target,knick,amsg);
      seen_kick(nick,adr,target,knick,amsg);
      exit;
    end;
  if index='332' then
    begin                                  //   MSG 332 (TOPIC_DATA)
      target:=word4(ws);
      amsg:=irc_data(ws);
      if settings.chanlog then
        logmsg(target,'* Topic is '''+amsg+''''); // log message
      exit;
    end;
  if index='333' then
    begin                                  //   MSG 333 (TOPIC_INFO)
      list:=split(ws,' ');
      target:=list[3];
      nick:=list[4];
      try amsg:=DateTimeToStr(UnixToDateTime(strtoint(list[5])));
      except end;
      if settings.chanlog then
        logmsg(target,'* Set by '+nick+' on '+amsg); // log message
      list.Free;
      exit;
    end;
  if index='TOPIC' then
    begin                                  //   MSG TOPIC
      getnickadr(word1(ws),nick,adr);
      target:=word3(ws);
      amsg:=irc_data(ws);
      if settings.chanlog then
        case settings.logstyle of
          0: logmsg(target,'* '+nick+' changes topic to '''+amsg+'''');
          1: logmsg(target,'*** '+nick+' has changed the topic on '+target+
            ' to "'+amsg+'"')
        end;                                               // log message
      exit;
    end;
  if index='353' then
    begin                                  //   MSG 353 (NAMES_LIST)
      target:=word5(ws);
      if channel[target] = nil then exit;
      if channel[target].names_complete then exit;
      list:=split(irc_data(ws),' ');
      main_353(target,list);
      seen_names(target,list);
      list.Free;
      exit;
    end;
  if index='366' then
    begin                                  //   MSG 366 (END_OF_NAMES)
      main_366(ws);
      exit;
    end;
  if index='352' then
    begin                                  //   MSG 352 (WHO_LIST)
      main_352(ws);
      exit;
    end;
  if index='433' then                      //   MSG 433
    begin
      main_433(ws);
      exit;
    end;
  if index='001' then
    begin                                  //   MSG 001
      main_001(ws);
      exit;
    end;
  if index='601' then
    begin                                  //   UNNOTIFY
      main_601(ws);
      exit;
    end;
  if index='005' then                      //   MSG 005
    begin
      main_005(ws);
      exit;
    end;
  except
  {$IFDEF DEBUG}
    on E:Exception do
      begin
        writedebug('');
        writedebug('  !!! ERROR !!! [ '+E.Message+' ]');
        writedebug('');
        structdump;
      end;
  {$ENDIF}
  end;
end; // procedure TMsgManager.dispetcher;

procedure TMsgManager.InitIdentd;
begin
  identd.SetIdent(identvalue);
end; // procedure TMsgManager.InitIdentd;

destructor TMsgManager.Destroy;
begin
  CTimer.Free;
  Inspector.Free;
  ConnectChecker.Free;
  identd.Free;
  inherited Destroy;
end; // destructor TMsgManager.Destroy;

end.
