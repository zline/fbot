unit seen;
interface
uses Classes, SysUtils, func, struct, time;

procedure seenout(const from,nick,text: string);
procedure seen_join(const nick,adr,chan: string);
procedure seen_part(const nick,adr,chan: string);
procedure seen_quit(const nick,adr,qmsg: string);
procedure seen_kick(const nick,adr,chan,knick,kickmsg: string);
procedure seen_nick(const nick,adr,newnick: string);
procedure seen_chantext(const nick,adr,chan: string);
procedure seen_names(const chan: string; const names: TStringList);
procedure seen_command(const nick,aadr,from,allmsg: string; const word: TStringList);
procedure seen_chancom(const nick,adr,chan,allmsg: string; const word: TStringList);
procedure seen_querycom(const nick,adr,allmsg: string; const word: TStringList);

implementation
uses mgr;

procedure seenout;
begin
  if pos('#',from) <> 0 then
    if not(funcenabled(from,FSEEN)) then
      begin
        notice(nick,text);
        exit;
      end;
  msg(from,text);
end; // procedure seenout;

procedure seen_join;
var ini: TProIni;
    act,jchan: string;
    jtime: integer;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  act:=ini.ReadString(nick,'action','');
  jchan:=ini.ReadString(nick,'jchan','');
  jtime:=ini.ReadInteger(nick,'jtime',0);
  ini.EraseSection(nick);
  ini.WriteString(nick,'action','join');
  ini.WriteString(nick,'chan',chan);
  ini.WriteString(nick,'adr',adr);
  ini.WriteInteger(nick,'time',ctime);
  if (act = 'quit')or(act = '') then
    begin
      ini.WriteString(nick,'jchan',chan);
      ini.WriteInteger(nick,'jtime',ctime);
      ini.WriteInteger(nick,'delta',-1)
    end;
  if (ison(chan,nick))and(jtime <> 0) then
    begin
      ini.WriteString(nick,'jchan',jchan);
      ini.WriteInteger(nick,'jtime',jtime);
      ini.WriteInteger(nick,'delta',-1)
    end
  else
    begin
      ini.WriteString(nick,'jchan',chan);
      ini.WriteInteger(nick,'jtime',ctime);
      ini.WriteInteger(nick,'delta',-1)
    end;
  ini.Free
end; // procedure seen_join;

procedure seen_part;
var ini: TProIni;
    jchan: string;
    jtime: integer;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  jchan:=ini.ReadString(nick,'jchan','');
  jtime:=ini.ReadInteger(nick,'jtime',0);
  ini.EraseSection(nick);
  ini.WriteString(nick,'action','part');
  ini.WriteString(nick,'chan',chan);
  ini.WriteString(nick,'adr',adr);
  ini.WriteInteger(nick,'time',ctime);
  if chan = jchan then
    begin
      ini.WriteInteger(nick,'delta',ctime-jtime);
      ini.DeleteKey(nick,'jchan');
      ini.DeleteKey(nick,'jtime')
    end
  else
    if (jchan <> '')and(jtime <> 0) then
      begin
        ini.WriteString(nick,'jchan',chan);
        ini.WriteInteger(nick,'jtime',ctime);
        ini.WriteInteger(nick,'delta',-1)
      end;
  ini.Free
end; // procedure seen_part;

procedure seen_quit;
var ini: TProIni;
    jchan: string;
    jtime: integer;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  jchan:=ini.ReadString(nick,'jchan','');
  jtime:=ini.ReadInteger(nick,'jtime',0);
  ini.EraseSection(nick);
  ini.WriteString(nick,'action','quit');
  ini.WriteString(nick,'qmsg',qmsg);
  ini.WriteString(nick,'adr',adr);
  ini.WriteInteger(nick,'time',ctime);
  if (jchan <> '')and(jtime <> 0) then
    begin
      ini.WriteInteger(nick,'delta',ctime-jtime);
      ini.WriteString(nick,'jchan',jchan);
      ini.DeleteKey(nick,'jtime')
    end
  else
    begin
      ini.WriteInteger(nick,'delta',-1);
      ini.WriteString(nick,'jchan',jchan);
      ini.DeleteKey(nick,'jtime')
    end;
  ini.Free
end; // procedure seen_quit;

procedure seen_kick;
var ini: TProIni;
    jchan: string;
    jtime: integer;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  jchan:=ini.ReadString(knick,'jchan','');
  jtime:=ini.ReadInteger(knick,'jtime',0);
  ini.EraseSection(knick);
  ini.WriteString(knick,'action','kick');
  ini.WriteString(knick,'chan',chan);
  ini.WriteString(knick,'adr',adr);
  ini.WriteInteger(knick,'time',ctime);
  ini.WriteString(knick,'kmsg',kickmsg);
  if chan = jchan then
    begin
      ini.WriteInteger(nick,'delta',ctime-jtime);
      ini.DeleteKey(nick,'jchan');
      ini.DeleteKey(nick,'jtime')
    end
  else
    if (jchan <> '')and(jtime <> 0) then
      begin
        ini.WriteString(nick,'jchan',chan);
        ini.WriteInteger(nick,'jtime',ctime);
        ini.WriteInteger(nick,'delta',-1)
      end;
  ini.Free
end; // procedure seen_kick;

procedure seen_nick;
var ini: TProIni;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  ini.EraseSection(nick);
  ini.WriteString(nick,'action','nick');
  ini.WriteString(nick,'adr',adr);
  ini.WriteInteger(nick,'time',ctime);
  ini.WriteString(nick,'newnick',newnick);
  ini.DeleteKey(newnick,'delta');
  ini.DeleteKey(newnick,'jtime');
  ini.DeleteKey(newnick,'jchan');
  ini.Free
end; // procedure seen_nick;

procedure seen_chantext;
var ini: TProIni;
    jchan: string;
    jtime: integer;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  jchan:=ini.ReadString(nick,'jchan','');
  jtime:=ini.ReadInteger(nick,'jtime',0);
  ini.EraseSection(nick);
  ini.WriteString(nick,'action','text');
  ini.WriteString(nick,'adr',adr);
  ini.WriteString(nick,'chan',chan);
  ini.WriteInteger(nick,'time',ctime);
  if ison(chan,nick) then
    begin
      if (jchan <> '')and(jtime <> 0) then
        begin
          ini.WriteString(nick,'jchan',chan);
          ini.WriteInteger(nick,'jtime',ctime);
          ini.WriteInteger(nick,'delta',-1)
        end;
    end
  else
    begin
      ini.DeleteKey(nick,'delta');
      ini.DeleteKey(nick,'jtime');
      ini.DeleteKey(nick,'jchan');
    end;
  ini.Free
end; // procedure seen_chantext;

procedure seen_names;
var ini: TProIni;
    i: integer;
    s: string;
begin
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  if names.Count > 0 then
    for i:=0 to names.Count - 1 do
      begin
        s:=names[i];
        if s = '' then continue;
        if (s[1] = '@')or(s[1] = '%')or(s[1] = '+') then delete(s,1,1);
        ini.EraseSection(s);
        ini.WriteString(s,'action','wason');
        ini.WriteString(s,'chan',chan);
        ini.WriteInteger(s,'time',ctime);
      end;
  ini.Free
end; // procedure seen_names;

procedure seen_command;
var ini: TProIni;
    act,chan,adr,amsg: string;
    time,delta,i: integer;
    list,res: TStringList;
begin
  if cmd(word[1]) <> '!seen' then exit;
  if global.network = '' then
    ini:=TProIni.Create(global.dir+'seen\base')
  else
    ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
  if word.Count < 3 then
    begin
      list:=TStringList.Create;
      ini.ReadSections(list);
      seenout(from,nick,nick+', сейчас в базе '+inttostr(list.Count)+' пользователей.');
      list.Free;
      ini.Free;
      exit
    end;
  if word[2] = '' then
    begin
      list:=TStringList.Create;
      ini.ReadSections(list);
      seenout(from,nick,nick+', сейчас в базе '+inttostr(list.Count)+' пользователей.');
      list.Free;
      ini.Free;
      exit
    end;
  if pos('*',word[2]) <> 0 then
    begin
      list:=TStringList.Create;
      res:=TStringList.Create;
      ini.ReadSections(list);
      if list.Count > 0 then
        for i:=0 to list.Count - 1 do
          if iswm(word[2],list[i]) then res.Add(list[i]);
      if res.Count = 0 then
        begin
          seenout(from,nick,nick+', по маске '+word[2]+' пользователей не найдено.');
          res.Free;
          list.Free;
          ini.Free;
          exit
        end;
      if res.Count > 5 then
        seenout(from,nick,nick+', по маске '+word[2]+' найдено '+inttostr(res.Count)+' пользователей. ƒл€ конкретизации уточни запрос.')
      else
        begin
          amsg:='';
          for i:=0 to res.Count - 1 do
            amsg:=amsg+', '+res[i];
          delete(amsg,1,2);
          seenout(from,nick,nick+', по маске '+word[2]+' найдены пользователи: '+amsg);
        end;
      res.Free;
      list.Free;
      ini.Free;
      exit
    end;
  if Ansilowercase(word[2]) = Ansilowercase(global.nick) then
    begin
      seenout(from,nick,nick+', мен€ потер€л? ;)');
      ini.Free;
      exit
    end;
  if Ansilowercase(word[2]) = Ansilowercase(nick) then
    begin
      seenout(from,nick,nick+', очень смешно..');
      ini.Free;
      exit
    end;
  if pos('#',from) <> 0 then
    if ison(from,word[2]) then
      begin
        seenout(from,nick,nick+', '+word[2]+' находитс€ здесь и сейчас ;)');
        ini.Free;
        exit
      end;
  list:=userchans(word[2]);
  if list.Count > 0 then
    begin
      amsg:='';
      for i:=0 to list.Count - 1 do
        amsg:=amsg+', '+list[i];
      delete(amsg,1,2);
      seenout(from,nick,nick+', '+word[2]+' сейчас в сети на каналах: '+amsg);
      ini.Free;
      list.Free;
      exit
    end;
  list.Free;
  act:=ini.ReadString(word[2],'action','');
  if act = '' then seenout(from,nick,nick+', эм.. € не нашел '+word[2]+' в своей базе..');
  if act = 'join' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'chan','');
      adr:=ini.ReadString(word[2],'adr','');
      seenout(from,nick,nick+', '+word[2]+' ('+adr+') зашел(ла) на канал '+chan+' '+duration(ctime - time)+' тому назад.')
    end;
  if act = 'part' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'chan','');
      adr:=ini.ReadString(word[2],'adr','');
      delta:=ini.ReadInteger(word[2],'delta',-1);
      if delta <> -1 then
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') ушел(ла) с канала '+chan+' '+duration(ctime - time)+' тому назад, '+
        'после того, как провел(а) там '+duration(delta))
      else
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') ушел(ла) с канала '+chan+' '+duration(ctime - time)+' тому назад.')
    end;
  if act = 'quit' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'jchan','');
      adr:=ini.ReadString(word[2],'adr','');
      delta:=ini.ReadInteger(word[2],'delta',-1);
      amsg:=ini.ReadString(word[2],'qmsg','');
      if (delta <> -1)and(chan <> '') then
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') сбежал(а) из IRC с канала '+
        chan+' с сообщением: "'+amsg+'" '+duration(ctime - time)+' тому назад, после того, как провел(а) там '+duration(delta))
      else
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') сбежал(а) из IRC с сообщением: "'+
        amsg+'" '+duration(ctime - time)+' тому назад.');
    end;
  if act = 'kick' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'chan','');
      adr:=ini.ReadString(word[2],'adr','');
      delta:=ini.ReadInteger(word[2],'delta',-1);
      if delta <> -1 then
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') был(а) кикнут(а) с канала '+
        chan+' '+duration(ctime - time)+' тому назад, после того как провел(а) там '+duration(delta))
      else
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') был(а) кикнут(а) с канала '+
        chan+' '+duration(ctime - time)+' тому назад.');
    end;
  if act = 'nick' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      adr:=ini.ReadString(word[2],'adr','');
      amsg:=ini.ReadString(word[2],'newnick','');
      seenout(from,nick,nick+', '+word[2]+' ('+adr+') помен€л(а) ник на '+amsg+' '+duration(ctime - time)+' тому назад.');
    end;
  if act = 'text' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'chan','');
      adr:=ini.ReadString(word[2],'adr','');
      seenout(from,nick,nick+', '+word[2]+' ('+adr+') разговаривал(а) на канале '+chan+' '+duration(ctime - time)+' тому назад.');
    end;
  if act = 'wason' then
    begin
      time:=ini.ReadInteger(word[2],'time',ctime);
      chan:=ini.ReadString(word[2],'chan','');
      adr:=ini.ReadString(word[2],'adr','');
      if adr = '' then
        seenout(from,nick,nick+', '+word[2]+' был(а) на канале '+chan+' '+duration(ctime - time)+' тому назад.')
      else
        seenout(from,nick,nick+', '+word[2]+' ('+adr+') был(а) на канале '+chan+' '+duration(ctime - time)+' тому назад.')
    end;
  ini.Free
end; // procedure seen_command;

procedure seen_chancom;
begin
  if access(nick,adr,chan) < ADMIN then exit;
  if cmd(word[1]) <> '!seenchan' then exit;
  if word.Count = 2 then
    begin
      msg(chan,'Ќеправильный формат команды. см. !help !seenchan');
      exit
    end;
  if lowercase(word[2]) = 'on' then
    begin
      chgfuncstate(chan,FSEEN,true);
      msg(chan,'‘ункци€ SEEN включена на '+chan);
      exit
    end;
  if lowercase(word[2]) = 'off' then
    begin
      chgfuncstate(chan,FSEEN,false);
      msg(chan,'‘ункци€ SEEN отключена на '+chan);
      exit
    end;
  msg(chan,'Ќеправильный формат команды. см. !help !seenchan')
end; // procedure seen_chancom;

procedure seen_querycom;
begin
  if cmd(word[1]) <> '!seenchan' then exit;
  if word.Count < 4 then
    begin
      msg(nick,'Ќеправильный формат команды. см. !help !seenchan');
      exit
    end;
  if access(nick,adr,word[2]) < ADMIN then exit;
  if lowercase(word[3]) = 'on' then
    begin
      chgfuncstate(validchan(word[2]),FSEEN,true);
      msg(nick,'‘ункци€ SEEN включена на '+validchan(word[2]));
      exit
    end;
  if lowercase(word[3]) = 'off' then
    begin
      chgfuncstate(validchan(word[2]),FSEEN,false);
      msg(nick,'‘ункци€ SEEN отключена на '+validchan(word[2]));
      exit
    end;
  msg(nick,'Ќеправильный формат команды. см. !help !seenchan')
end; // procedure seen_querycom;

end.
