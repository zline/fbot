unit main;
interface
uses Classes, SysUtils, func, struct, time, timers, seims;

//{$DEFINE DEBUG}

procedure main_001(const msg: string);
procedure main_chancom(const nick,adr,chan,allmsg: string; const word: TStringList);
procedure main_querycom(const nick,adr,allmsg: string; const word: TStringList);
procedure main_command(const nick,adr,from,allmsg: string; const word: TStringList);
procedure main_notice(const nick,adr,target,amsg: string);
procedure main_join(const nick,adr,chan: string);
procedure main_part(const nick,adr,chan: string);
procedure main_nick(const nick,adr,newnick: string);
procedure main_quit(const nick,adr,qmsg: string);
procedure main_kick(const nick,adr,chan,knick,kickmsg: string);
procedure main_601(const amsg: string);
procedure main_005(const amsg: string);
procedure main_353(const chan: string; const names: TStringList);
procedure main_366(const amsg: string);
procedure main_433(const amsg: string);
procedure main_352(const amsg: string);
procedure main_mode(const nick,adr,chan,modes: string);

implementation
uses mgr;

procedure main_001;
var sl: TStringList;
    s: string;
    i: word;
begin
  global.connect_time:=ctime;
  sl:=split(msg,' ');
  s:=sl[0];
  delete(s,1,1);
  global.server_name:=s;
  global.nick:=sl[2];
  setcaption('fbot ['+global.nick+' подключен к '+global.server_name+']');
  sl.Clear;
  sock.identserver.Close;
  if settings.umode_b then send('MODE '+global.nick+' +B');
  if settings.umode_i then send('MODE '+global.nick+' +i');
  if settings.umode_x then send('MODE '+global.nick+' +x');
  if FileExists(global.dir+'conf\perform.conf') then
    begin
      try sl.LoadFromFile(global.dir+'conf\perform.conf'); except end;
      if sl.Count > 0 then
      for i:=0 to sl.Count-1 do
        begin
          s:=sl[i];
          while s[1] = '/' do delete(s,1,1);
          send(s)
        end
    end;
  if settings.rejoinonconnect then
    begin
      sl.Clear;
      if FileExists(global.dir+'main\joinonconnect.local') then
        begin
          try sl.LoadFromFile(global.dir+'main\joinonconnect.local'); except end;
          if sl.Count > 0 then
          for i:=0 to sl.Count-1 do send('JOIN '+sl[i])
        end
    end;
  sl.Free
end; // procedure main_001;

procedure main_chancom;
var command,s1,s2,subcom,tmp,u: string;
    i: integer;
    ch: TChannel;
    list: TStringList;
begin
  command:=word[1];
  if access(nick,adr,chan) < VOICE then exit; // Команды войсов
  if cmd(command) = '!voice' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' +v '+nick)
      else
        send('MODE '+chan+' +v '+word[2]);
      exit;
    end;
  if cmd(command) = '!devoice' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' -v '+nick)
      else
        send('MODE '+chan+' -v '+word[2]);
     exit;
    end;
  if access(nick,adr,chan) < HOP then exit; // Команды хопов
  if cmd(command) = '!hop' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' +h '+nick)
      else
        send('MODE '+chan+' +h '+word[2]);
      exit;
    end;
  if cmd(command) = '!dehop' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' -h '+nick)
      else
        send('MODE '+chan+' -h '+word[2]);
      exit;
    end;
  if access(nick,adr,chan) < OPERATOR then exit; // Команды операторов
  if cmd(command) = '!topic' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'Неполный формат команды. см. !help !topic');
          exit;
        end;
      send('TOPIC '+chan+' :'+AfterN(allmsg,2));
      exit;
    end;
  if cmd(command) = '!invite' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'Неполный формат команды. см. !help !invite');
          exit;
        end;
      send('INVITE '+word[2]+' '+chan);
      msg(chan,word[2]+' приглашен на канал.');
      exit;
    end;
  if cmd(command) = '!op' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' +o '+nick)
      else
        send('MODE '+chan+' +o '+word[2]);
      exit;
    end;
  if cmd(command) = '!deop' then
    begin
      if word.Count = 2 then
        send('MODE '+chan+' -o '+nick)
      else
        send('MODE '+chan+' -o '+word[2]);
      exit;
    end;
  if cmd(command) = '!mass' then
    begin
      s1:='';
      s2:='';
      ch:=channel[chan];
      if ch = nil then exit;
      if word.Count = 2 then
        begin
          msg(chan,'Неправильный формат команды. см. !help !mass');
          exit;
        end;
      subcom:=lowercase(word[2]);
      if subcom = 'kick' then
        begin
          list:=TStringList.Create;
          channel[chan].getusers(list);
          if word.Count > 3 then s2:=' '+AfterN(allmsg,3);
          for i:=list.Count - 2 downto 0 do
            begin
              s1:=list[i];
              if (s1 <> global.nick)and(access(s1,address(s1)) < ADMIN) then
                send('KICK '+chan+' '+s1+s2);
            end;
          list.Free;
          exit;
        end;
      if subcom = 'op' then begin s1:='+ooo'; s2:='+o'; end;
      if subcom = 'deop' then begin s1:='-ooo'; s2:='-o'; end;
      if subcom = 'hop' then begin s1:='+hhh'; s2:='+h'; end;
      if subcom = 'dehop' then begin s1:='-hhh'; s2:='-h'; end;
      if subcom = 'voice' then begin s1:='+vvv'; s2:='+v'; end;
      if subcom = 'devoice' then begin s1:='-vvv'; s2:='-v'; end;
      if s1 = '' then
        begin
          msg(chan,'Неизвестная опция - '+word[2]+'. cм. !help !mass');
          exit;
        end;
      list:=TStringList.Create;
      channel[chan].getusers(list);
      if list.Count > 2 then
        for i:=0 to (list.Count div 3) - 1 do
          begin
            tmp:='MODE '+chan+' '+s1;
            u:=list[i*3];
            if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
              tmp:=tmp+' '+u;
            u:=list[i*3+1];
            if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
              tmp:=tmp+' '+u;
            u:=list[i*3+2];
            if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
              tmp:=tmp+' '+u;
            send(tmp);
          end;
      if list.Count mod 3 = 2 then
        begin
          u:=list[list.Count-1];
          if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
            send('MODE '+chan+' '+s2+' '+u);
          u:=list[list.Count-2];
          if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
            send('MODE '+chan+' '+s2+' '+u);
        end;
      if list.Count mod 3 = 1 then
        begin
          u:=list[list.Count-1];
          if (s1[1] <> '-')or((u <> global.nick)and(access(u,address(u)) < ADMIN)) then
            send('MODE '+chan+' '+s2+' '+u);
        end;
      list.Free;
      exit;
    end;
  if cmd(command) = '!kick' then
    begin
      if word.Count < 3 then
        begin
          msg(chan,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if AnsiLowerCase(word[2]) = AnsiLowerCase(global.nick) then
        begin
          msg(chan,'кикнуть себя? ;)');
          exit;
        end;
      if access(word[2],address(word[2]),chan) = ADMIN then
        begin
          msg(chan,'кикнуть администратора? хха!');
          exit;
        end;
      kick(word[2],chan,AfterN(allmsg,3));
      exit;
    end;
  if cmd(command) = '!ban' then
    begin
      if word.Count < 3 then
        begin
          msg(chan,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if pos('@',word[2]) <> 0 then
        send('MODE '+chan+' +b '+word[2])
      else
        begin
          if access(word[2],address(word[2]),chan) >=OPERATOR then exit;
          if address(word[2]) <> '' then
            send('MODE '+chan+' +b *!'+address(word[2]));
          send('MODE '+chan+' +b '+word[2]+'!*@*');
        end;
      exit;
    end;
  if access(nick,adr,chan) < ADMIN then exit; // Команды канальных администраторов
  if cmd(command) = '!bot' then
    begin
      if word.Count = 2 then exit;
      if lowercase(word[2]) <> 'off' then exit;
      chgfuncstate(chan,BOT,false);
      msg(chan,'Бот отключен на '+chan);
      exit
    end;
  if access(nick,adr) < ADMIN then exit; // Команды Root Administrator'a
  if cmd(command) = '!join' then
    begin
      if word.Count = 2 then exit;
      if word[2] = '' then exit;
      send('JOIN '+validchan(afterN(allmsg,2)));
      msg(chan,'Пытаюсь зайти на '+validchan(afterN(allmsg,2)));
      exit
    end;
  if cmd(command) = '!part' then
    begin
      if word.Count = 2 then
        begin
          send('PART '+chan);
          exit
        end;
      if word[2] = '' then
        begin
          send('PART '+chan);
          exit
        end;
      msg(chan,'Выхожу с '+validchan(word[2]));
      send('PART '+validchan(word[2]));
      exit
    end;
  if cmd(command) = '!rejoin' then
    begin
      if word.Count = 2 then
        begin
          send('PART '+chan);
          send('JOIN '+chan);
          exit
        end;
      if word[2] = '' then
        begin
          send('PART '+chan);
          send('JOIN '+chan);
          exit
        end;
      msg(chan,'Пытаюсь перезайти на '+validchan(word[2]));
      send('PART '+validchan(word[2]));
      send('JOIN '+validchan(word[2]));
      exit
    end;
end; // procedure main_chancom;

procedure main_querycom;
var ini: TProIni;
    pass,command,s,s2: string;
    i,i2: integer;
    list: TStringList;
    F: TextFile;
    seg: TSegFile;
    key: boolean;
    bsp: TBanSeimParams;
begin
  command:=word[1];
  if cmd(command) = '!ident' then // USER commands
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\users.conf');
      pass:=ini.ReadString(nick,'password','');
      if pass = '' then
        begin
          msg(nick,'Аккаунта на ваш ник не существует!');
          ini.Free;
          exit;
        end;
      if pass <> word[2] then
        begin
          msg(nick,'Пароль неверный!');
          ini.Free;
          exit;
        end;
      i:=ini.ReadInteger(nick,'access',1);
      if not(validaccess(i)) then i:=1;
      accesslist.add(nick,adr,i);
      msg(nick,'Доступ '+accesstostring(i)+'''a восстановлен!');
      send('WATCH +'+nick);
      if settings.autooponident then
        begin
          list:=userchans(nick);
          if list.Count > 0 then
            for i:=0 to list.Count - 1 do
              begin
                i2:=access(nick,adr,list[i]);
                if (i2 = ADMIN)or(i2 = OP)or(i2 = HOP)or(i2 = VOICE) then
                  case i2 of
                    ADMIN,OP: send('MODE '+list[i]+' +o '+nick);
                    HOP: send('MODE '+list[i]+' +h '+nick);
                    VOICE: send('MODE '+list[i]+' +v '+nick);
                  end;
              end;
          list.Free;
        end;
      ini.Free;
      exit;
    end;
  if cmd(command) = '!send' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if (word[3] = '')or(word[2] = '') then
        begin
          msg(nick,'Неверный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if (validuser(nick))and(access(nick,adr) < USER) then
        begin
          msg(nick,'Вы должны проидентифицироваться');
          exit;
        end;
      s2:=word[2];
      replace(s2,'|','!');
      try
        Assign(F,global.dir+'mail\'+s2);
        if not(DirectoryExists(global.dir+'mail'))
          then ForceDirectories(global.dir+'mail');
        if FileExists(global.dir+'mail\'+s2) then
          append(F)
        else
          rewrite(F);
        if access(nick,adr) >= USER then
          writeln(F,'От '+nick+' ('+adr+') [*registered] ['+datetimetostr(now)+'] :')
        else
          writeln(F,'От '+nick+' ('+adr+') [*UNregistered] ['+datetimetostr(now)+'] :');
        writeln(F,Aftern(allmsg,3));
        writeln(F,'-------------------------------------------------');
        CloseFile(F);
      except
        msg(nick,'Ошибка отправки сообщения. Обратитесь к администратору');
        exit;
      end;
      replace(s2,'!','|');
      list:=userchans(s2);
      if list.Count > 0 then
        begin
          if access(s2,address(s2)) >= USER then
            msg(nick,'У вас есть новая почта. Для чтения введите !read')
          else
            begin
              if validuser(s2) then
                msg(nick,'У вас есть новая почта. Проидентифицируйтесь (!ident) и используйте !read для чтения')
              else
                msg(nick,'У вас есть новая почта. Для чтения зарегистрируйтесь (!register), и проидентифицируйтесь (!ident), затем используйте !read');
            end;
        end;
      list.Free;
      msg(nick,'Сообщение отправлено успешно.');
      if not(validuser(s2)) then
        msg(nick,'Внимание! Пользователь '+s2+' не зарегистрирован. Успешность доставки не гарантирую =)');
      exit;
    end;
  if cmd(command) = '!read' then
    begin
      if not(validuser(nick)) then
        begin
          msg(nick,'Зарегистрируйтесь! (см !help !register)');
          exit;
        end;
      if access(nick,adr) < USER then
        begin
          msg(nick,'Вы должны проидентифицироваться (!ident)');
          exit;
        end;
      s2:=nick;
      replace(s2,'|','!');
      if FileExists(global.dir+'mail\'+s2) then
        begin
          play(nick,global.dir+'mail\'+s2);
          DeleteFile(global.dir+'mail\'+s2);
        end
      else
        msg(nick,'Новых сообщений нет.');
      exit;
    end;
  if cmd(command) = '!chanaccess' then
    begin
      if access(nick,adr) < USER then exit;
      if word.Count = 2 then
        begin
          spooler.AddMsg(nick,'Ваши локальные доступы:');
          ini:=TProIni.Create(accesslist.chanaccessconf);
          list:=TStringList.Create;
          ini.ReadSection(nick,list);
          if list.Count > 0 then
            for i:=0 to list.Count - 1 do
              spooler.AddMsg(nick,list[i]+' - '+accesstostring(ini.ReadInteger(nick,list[i],1),true));
          spooler.AddMsg(nick,'Конец списка');
          list.Free;
          ini.Free;
          exit;
        end;
      if word.Count < 5 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      s:=lowercase(word[4]);
      if s = 'list' then
        begin
          if access(nick,adr,word[2]) < VOICE then exit;
          s:=lowercase(word[3]);
          if (s <> 'admin')and(s <> 'oper')and(s <> 'hop')and(s <> 'voice') then
            begin
              msg(nick,'Неизвестный уровень доступа: '+word[3]);
              exit;
            end;
          if s = 'admin' then spooler.AddMsg(nick,'Начало списка администраторов канала '+validchan(word[2])+' :');
          if s = 'oper' then spooler.AddMsg(nick,'Начало списка операторов канала '+validchan(word[2])+' :');
          if s = 'hop' then spooler.AddMsg(nick,'Начало списка полуоператоров канала '+validchan(word[2])+' :');
          if s = 'voice' then spooler.AddMsg(nick,'Начало списка войсов канала '+validchan(word[2])+' :');
          list:=TStringList.Create;
          ini:=TProIni.Create(accesslist.chanaccessconf);
          ini.ReadSections(list);
          if list.Count > 0 then
            for i:=0 to list.Count - 1 do
              begin
                i2:=ini.ReadInteger(list[i],validchan(word[2]),0);
                if (s = 'admin')and(i2 = ADMIN) then
                  spooler.AddMsg(nick,list[i]);
                if (s = 'oper')and(i2 = OPERATOR) then
                  spooler.AddMsg(nick,list[i]);
                if (s = 'hop')and(i2 = HOP) then
                  spooler.AddMsg(nick,list[i]);
                if (s = 'voice')and(i2 = VOICE) then
                  spooler.AddMsg(nick,list[i]);
              end;
          ini.Free;
          list.Free;
          spooler.AddMsg(nick,'Конец списка');
          exit;
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if s = 'add' then
        begin
          if word.Count < 6 then
            begin
              msg(nick,'Неполный формат команды. см. !help '+cmd(command));
              exit;
            end;
          if not(validuser(word[5])) then
            begin
              msg(nick,'Пользователь '+word[5]+' не зарегистрирован.');
              exit;
            end;
          key:=false;
          s:=lowercase(word[3]);
          ini:=TProIni.Create(accesslist.chanaccessconf);
          if s = 'admin' then
            begin
              if access(nick,adr) < ADMIN then
                begin
                  msg(nick,'Только Root Administrator может добавлять администраторов каналов');
                  ini.Free;
                  exit;
                end;
              ini.WriteInteger(word[5],validchan(word[2]),ADMIN);
              msg(nick,'Администратор '+word[5]+' на канал '+validchan(word[2])+' добавлен.');
              key:=true;
            end;
          if s = 'oper' then
            begin
              ini.WriteInteger(word[5],validchan(word[2]),OPERATOR);
              msg(nick,'Оператор '+word[5]+' на канал '+validchan(word[2])+' добавлен.');
              key:=true;
            end;
          if s = 'hop' then
            begin
              ini.WriteInteger(word[5],validchan(word[2]),HOP);
              msg(nick,'Полуоператор '+word[5]+' на канал '+validchan(word[2])+' добавлен.');
              key:=true;
            end;
          if s = 'voice' then
            begin
              ini.WriteInteger(word[5],validchan(word[2]),VOICE);
              msg(nick,'Войс '+word[5]+' на канал '+validchan(word[2])+' добавлен.');
              key:=true;
            end;
          ini.Free;
          if not(key) then
            msg(nick,'Неизвестный уровень доступа: '+word[3]);
          exit;
        end;
      if s = 'del' then
        begin
          if word.Count < 6 then
            begin
              msg(nick,'Неполный формат команды. см. !help '+cmd(command));
              exit;
            end;
          ini:=TProIni.Create(accesslist.chanaccessconf);
          if ini.ReadInteger(word[5],validchan(word[2]),0) = 0 then
            begin
              msg(nick,'Пользователь '+word[5]+' не имеет доступа к каналу '+validchan(word[2]));
              ini.Free;
              exit;
            end;
          s:=lowercase(word[3]);
          if (s = 'admin')and(access(nick,adr) < ADMIN) then
            begin
              msg(nick,'Только Root Administrator может удалять администраторов каналов');
              ini.Free;
              exit;
            end;
          if (s <> 'admin')and(s <> 'oper')and(s <> 'hop')and(s <> 'voice') then
            begin
              msg(nick,'Неизвестный уровень доступа: '+word[3]);
              ini.Free;
              exit;
            end;
          ini.DeleteKey(word[5],validchan(word[2]));
          msg(nick,'Доступ пользователя '+word[5]+' к каналу '+validchan(word[2])+' закрыт');
          ini.Free;
          exit;
        end;
      msg(nick,'Неизвестная опция: '+word[4]);
      exit;
    end;
  if cmd(command) = '!register' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if validuser(nick) then
        begin
          msg(nick,'Пользователь с вашин ником уже зарегистрирован');
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\users.conf');
      ini.WriteString(nick,'password',word[2]);
      ini.WriteInteger(nick,'access',USER);
      msg(nick,'Вы успешно зарегистрированы');
      exit;
    end;
  if cmd(command) = '!names' then
    begin
      if word.Count < 3 then exit;
      if access(nick,adr,word[2]) < VOICE then exit;
      if channel[word[2]] = nil then
        begin
          msg(nick,'Я не нахожусь на канале '+validchan(word[2]));
          exit
        end;
      spooler.AddMsg(nick,'Список пользователей канала '+validchan(word[2])+':');
      list:=TStringList.Create;
      channel[word[2]].getusers(list);
      for i:=0 to list.Count - 1 do
        spooler.AddMsg(nick,list[i]);
      spooler.AddMsg(nick,'Конец списка пользователей.');
      list.Free;
      exit;
    end;
  if cmd(command) = '!unident' then
    begin
      if access(nick,adr) < USER then exit;
      accesslist.del(nick);
      msg(nick,'Ваш доступ успешно закрыт.');
      exit
    end;
  if cmd(command) = '!topic' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неполный формат команды. см. !help !topic');
          exit;
        end;
      if access(nick,adr,word[2]) < OPERATOR then exit;
      send('TOPIC '+validchan(word[2])+' :'+AfterN(allmsg,3));
      msg(nick,'Пытаюсь сменить топик на '+validchan(word[2])+' ..');
      exit;
    end;
  if cmd(command) = '!invite' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неполный формат команды. см. !help !invite');
          exit;
        end;
      if access(nick,adr,word[2]) < OPERATOR then exit;
      send('INVITE '+word[3]+' '+validchan(word[2]));
      msg(nick,'Пытаюсь пригласить '+word[3]+' на '+validchan(word[2])+' ..');
      exit;
    end;
  if cmd(command) = '!op' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < OPERATOR then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' +o '+nick)
     else
       send('MODE '+validchan(word[2])+' +o '+word[3]);
     exit;
   end;
  if cmd(command) = '!deop' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < OPERATOR then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' -o '+nick)
     else
       send('MODE '+validchan(word[2])+' -o '+word[3]);
     exit;
   end;
  if cmd(command) = '!hop' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < HOP then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' +h '+nick)
     else
       send('MODE '+validchan(word[2])+' +h '+word[3]);
     exit;
   end;
  if cmd(command) = '!dehop' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < HOP then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' -h '+nick)
     else
       send('MODE '+validchan(word[2])+' -h '+word[3]);
     exit;
   end;
  if cmd(command) = '!voice' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < VOICE then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' +v '+nick)
     else
       send('MODE '+validchan(word[2])+' +v '+word[3]);
     exit;
   end;
  if cmd(command) = '!devoice' then
   begin
     if word.Count < 3 then
       begin
         msg(nick,'Неполный формат команды. см. !help '+cmd(command));
         exit;
       end;
     if access(nick,adr,word[2]) < VOICE then exit;
     if word.Count = 3 then
       send('MODE '+validchan(word[2])+' -v '+nick)
     else
       send('MODE '+validchan(word[2])+' -v '+word[3]);
     exit;
   end;
  if cmd(command) = '!kick' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if access(nick,adr,word[2]) < OPERATOR then exit;
      if AnsiLowerCase(word[3]) = AnsiLowerCase(global.nick) then
        begin
          msg(nick,'кикнуть себя? ;)');
          exit;
        end;
      if access(word[3],address(word[3])) = ADMIN then
        begin
          msg(nick,'кикнуть администратора? хха!');
          exit;
        end;
      kick(word[3],validchan(word[2]),AfterN(allmsg,4));
      exit;
    end;
  if cmd(command) = '!ban' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if access(nick,adr,word[2]) < OPERATOR then exit;
      if pos('@',word[3]) <> 0 then
        send('MODE '+validchan(word[2])+' +b '+word[3])
      else
        begin
          if address(word[3]) <> '' then
            send('MODE '+validchan(word[2])+' +b *!'+address(word[3]));
          send('MODE '+validchan(word[2])+' +b '+word[3]+'!*@*');
        end;
      exit;
    end;
  if cmd(command) = '!unban' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if access(nick,adr,word[2]) < OPERATOR then exit;
      if channel[validchan(word[2])] = nil then
        begin
          msg(nick,'Я не нахожусь на канале '+validchan(word[2]));
          exit;
        end;
      bsp:=TBanSeimParams.Create;
      bsp.amask:=nick+'!'+adr;
      bsp.achan:=validchan(word[2]);
      bsp.unban_all:=false;
      if word.Count > 3 then
        if lowercase(word[3]) = 'all' then
          bsp.unban_all:=true;
      seim.AddSeim(ST_UNBAN,bsp);
      send('MODE '+validchan(word[2])+' b');
      bsp.Free;
      msg(nick,'Считываю баны канала '+word[2]+', подождите..');
      exit;
    end;
  if cmd(command) = '!acclist' then
    begin
      if access(nick,adr) < OPERATOR then exit;
      ini:=TProIni.Create(global.dir+'conf\users.conf');
      list:=TStringList.Create;
      ini.ReadSections(list);
      msg(nick,'-- Начало листа доступа --');
      if list.Count > 0 then
        for i:=0 to list.Count - 1 do
          case ini.ReadInteger(list[i],'access',0) of
            ADMIN: msg(nick,list[i]+' - Администратор');
            OPERATOR: msg(nick,list[i]+' - Оператор');
          end;
      msg(nick,'-- Конец листа доступа  --');
      ini.Free;
      list.Free;
      exit;
    end;
  if cmd(command) = '!say' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неправильный формат команды. см. !help !say');
          exit;
        end;
      if ((settings.say4chanadmin)and(access(nick,adr,word[2]) < ADMIN))or
      ((not(settings.say4chanadmin))and(access(nick,adr) < ADMIN)) then exit;
      msg(word[2],AfterN(allmsg,3));
      msg(nick,'Отправлено '+word[2]+': '+AfterN(allmsg,3));
      exit
    end;
  if cmd(command) = '!act' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неправильный формат команды. см. !help !act');
          exit;
        end;
      if ((settings.say4chanadmin)and(access(nick,adr,word[2]) < ADMIN))or
      ((not(settings.say4chanadmin))and(access(nick,adr) < ADMIN)) then exit;
      msg(word[2],#1'ACTION '+AfterN(allmsg,3)+#1);
      msg(nick,'Сказано от 3-го лица для '+word[2]+': '+AfterN(allmsg,3));
      exit
    end;
  if cmd(command) = '!bot' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'Неправильный формат команды. Справка - !help !bot');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),BOT,true);
          msg(nick,'Бот включен на '+validchan(word[2]))
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),BOT,false);
          msg(nick,'Бот отключен на '+validchan(word[2]))
        end;
      exit
    end;
  if access(nick,adr) < ADMIN then exit; // ADMIN commands
  if cmd(command) = '!join' then
    begin
      if word.Count = 2 then exit;
      if word[2] = '' then exit;
      send('JOIN '+validchan(afterN(allmsg,2)));
      msg(nick,'Пытаюсь зайти на '+validchan(afterN(allmsg,2)));
      exit
    end;
  if cmd(command) = '!part' then
    begin
      if word.Count = 2 then exit;
      if word[2] = '' then exit;
      send('PART '+validchan(word[2]));
      msg(nick,'Выхожу с '+validchan(word[2]));
      exit
    end;
  if cmd(command) = '!rejoin' then
    begin
      if word.Count = 2 then exit;
      if word[2] = '' then exit;
      send('PART '+validchan(word[2]));
      send('JOIN '+validchan(word[2]));
      msg(nick,'Пытаюсь перезайти на '+validchan(word[2]));
      exit
    end;
  if cmd(command) = '!id' then
    begin
      if settings.nsnick = '' then
        begin
          msg(nick,'Идентификация невозможна: указано недостаточно параметров в fbot.conf');
          exit
        end
      else
        begin
          msg(settings.nsnick,'IDENTIFY '+settings.nspass);
          msg(nick,'Я проидентифицировался!')
        end;
      exit
    end;
  if cmd(command) = '!perform' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неправильный формат команды. Справка - !help !perform');
          exit
        end;
      if lowercase(word[2]) = 'list' then
        begin
          msg(nick,'Лист автовыполнения:');
          play(nick,'conf\perform.conf',true);
          msg(nick,'Конец листа автовыполнения.');
          exit
        end;
      if lowercase(word[2]) = 'add' then
        begin
          s:=AfterN(allmsg,3);
          if s = '' then exit;
          list:=TStringList.Create;
          try list.LoadFromFile(global.dir+'conf\perform.conf');
          except end;
          list.Add(s);
          try list.SaveToFile(global.dir+'conf\perform.conf');
          except
            msg(nick,'Ошибка записи в файл perform.conf!');
            list.Free;
            exit
          end;
          msg(nick,'"'+s+'" добавлено в лист автовыполнения');
          list.Free;
          exit
        end;
      if lowercase(word[2]) = 'del' then
        begin
          if word.Count < 4 then exit;
          try
            i:=strtoint(word[3]);
            list:=TStringList.Create;
            list.LoadFromFile(global.dir+'conf\perform.conf');
            s:=list[i-1];
            list.Delete(i-1);
            list.SaveToFile(global.dir+'conf\perform.conf');
          except
            msg(nick,'Ошибка удаления пункта '+word[3]+'!');
            exit
          end;
          msg(nick,'"'+s+'" удалено из листа автовыполнения');
          exit
        end;
      msg(nick,'Неизвестная опция: '+word[2]+' . Информация о команде: !help !perform');
      exit
    end;
  if cmd(command) = '!ijoin' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неправильный формат команды. Справка - !help !ijoin');
          exit
        end;
      if lowercase(word[2]) = 'list' then
        begin
          msg(nick,'Лист приветствий бота:');
          play(nick,'main\ijoin.txt',true);
          msg(nick,'Конец листа приветствий бота.');
          exit
        end;
      if lowercase(word[2]) = 'add' then
        begin
          s:=AfterN(allmsg,3);
          if s = '' then exit;
          list:=TStringList.Create;
          try list.LoadFromFile(global.dir+'main\ijoin.txt');
          except end;
          list.Add(s);
          try list.SaveToFile(global.dir+'main\ijoin.txt');
          except
            msg(nick,'Ошибка записи в файл ijoin.txt!');
            list.Free;
            exit
          end;
          msg(nick,'"'+s+'" добавлено в лист приветствий бота');
          list.Free;
          exit
        end;
      if lowercase(word[2]) = 'del' then
        begin
          if word.Count < 4 then exit;
          try
            i:=strtoint(word[3]);
            list:=TStringList.Create;
            list.LoadFromFile(global.dir+'main\ijoin.txt');
            s:=list[i-1];
            list.Delete(i-1);
            list.SaveToFile(global.dir+'main\ijoin.txt');
          except
            msg(nick,'Ошибка удаления пункта '+word[3]+'!');
            exit
          end;
          msg(nick,'"'+s+'" удалено из листа приветствий бота');
          exit
        end;
      msg(nick,'Неизвестная опция: '+word[2]+' . Информация о команде: !help !ijoin');
      exit
    end;
  if cmd(command) = '!ujoin' then
    begin
        seg:=TSegFile.Create(global.dir+'main\ujoin.txt');
        list:=TStringList.Create;
        if word.Count < 4 then
          begin
            seg.ReadSections(list);
            msg(nick,'Список пользователей, приветствуемых персонально:');
            if list.Count > 0 then
              for i:=0 to list.Count - 1 do
                msg(nick,list[i]);
            msg(nick,'Конец списка.');
            list.Free;
            seg.Free;
            exit;
          end;
        if lowercase(word[3]) = 'list' then
          begin
            if seg.SectionExists(word[2]) = false then
              begin
                msg(nick,'Пользователь '+word[2]+' не приветствуется персонально.');
                list.Free;
                seg.Free;
                exit
              end;
            msg(nick,'Фразы, которыми приветствуется '+word[2]+':');
            seg.ReadSection(word[2],list);
            if list.Count > 0 then
              for i:=0 to list.Count - 1 do
                msg(nick,list[i]);
            msg(nick,'Конец списка.');
            list.Free;
            seg.Free;
            exit
          end;
        if lowercase(word[3]) = 'add' then
          begin
            if AfterN(allmsg,4) = '' then
              begin
                list.Free;
                seg.Free;
                exit
              end;
            seg.AddString(word[2],AfterN(allmsg,4));
            msg(nick,'Добавлено "'+AfterN(allmsg,4)+'" в приветствия для '+word[2]);
            list.Free;
            seg.Free;
            exit
          end;
        if lowercase(word[3]) = 'del' then
          begin
            if seg.SectionExists(word[2]) = false then
              begin
                msg(nick,'Пользователь '+word[2]+' не приветствуется персонально.');
                list.Free;
                seg.Free;
                exit
              end;
            if AfterN(allmsg,4) = '' then
              begin
                list.Free;
                seg.Free;
                exit
              end;
            seg.ReadSection(word[2],list);
            if list.IndexOf(AfterN(allmsg,4)) = -1 then
              begin
                msg(nick,'Фраза "'+AfterN(allmsg,4)+'" в приветствиях '+word[2]+
                ' не найдена.');
                list.Free;
                seg.Free;
                exit
              end;
            seg.DelString(word[2],AfterN(allmsg,4));
            msg(nick,'Фраза "'+AfterN(allmsg,4)+'" удалена из приветствий для '+word[2]);
            list.Free;
            seg.Free;
            exit
          end;
        msg(nick,'Неизвестная опция: '+word[3]+' . Информация о команде: !help !ujoin');
        list.Free;
        seg.Free;
        exit
    end;
  {$IFDEF DEBUG}
  if cmd(command) = '!dump' then
    begin
      structdump;
      msg(nick,'Структуры сброшены в файл debug.log');
      exit
    end;
  {$ENDIF}
  if cmd(command) = '!adduser' then
    begin
      if word.Count < 5 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if (word[3] = '')or(word[4] = '') then
        begin
          msg(nick,'Неверный формат команды. см. !help '+cmd(command));
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\users.conf');
      if ini.ReadInteger(word[3],'access',0) <> 0 then
        begin
          msg(nick,'Пользователь '+word[3]+' уже есть.');
          ini.Free;
          exit;
        end;
      i:=0;
      s:=lowercase(word[2]);
      if s = 'admin' then
        begin
          msg(nick,'Добавление администратора возможно только через программу');
          ini.Free;
          exit;
        end;
      if s = 'operator' then i:=OPERATOR;
      if s = 'user' then i:=USER;
      if i = 0 then
        begin
          msg(nick,'Неизвестный доступ - '+word[2]+'. см. !help '+cmd(command));
          ini.Free;
          exit;
        end;
      ini.WriteInteger(word[3],'access',i);
      ini.WriteString(word[3],'password',word[4]);
      ini.Free;
      msg(nick,'Добавлен '+word[2]+' '+word[3]+' с паролем '+word[4]);
      exit;
    end;
  if cmd(command) = '!deluser' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\users.conf');
      if ini.ReadInteger(word[2],'access',-1) = -1 then
        begin
          msg(nick,'Пользователя '+word[2]+' нет в листе доступа.');
          ini.Free;
          exit;
        end;
      if ini.ReadInteger(word[2],'access',-1) = ADMIN then
        begin
          msg(nick,'Root administrator может быть удален только через программу');
          ini.Free;
          exit;
        end;
      ini.EraseSection(word[2]);
      ini.Free;
      ini:=TProIni.Create(accesslist.chanaccessconf);
      ini.EraseSection(word[2]);
      ini.Free;
      msg(nick,'Пользователь '+word[2]+' удален из листа доступа.');
      exit;
    end;
  if cmd(command) = '!rename' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      if word[2] = '' then
        begin
          msg(nick,'Неполный формат команды. см. !help '+cmd(command));
          exit;
        end;
      settings.nick:=word[2];
      ini:=TProIni.Create(global.dir+'conf\fbot.conf');
      ini.WriteString('bot','nick',word[2]);
      msg(nick,'Переименован в '+word[2]);
      send('NICK '+word[2]);
      if word.Count > 3 then
        if word[3] <> '' then
          begin
            ini.WriteString('irc','ns_pass',word[3]);
            msg(nick,'Пароль на nickserv''е изменен на '+word[3]);
          end;
      ini.Free;
      exit;
    end;
end; // procedure main_querycom;

procedure main_command;
var command: string;
    ini: TProIni;
    c,ti: integer;
    list: TStringList;
begin
  command:=word[1];
  if cmd(command) = '!version' then
    begin
      msg(from,#2'fbot'#2' version '+version+' by AL');
      exit
    end;
  if cmd(command) = '!time' then
    begin
      msg(from,'По моим часам сейчас '+FormatDateTime('h:nn',now));
      exit
    end;
  if cmd(command) = '!date' then
    begin
      msg(from,'Согласно моему календарю сегодня '+FormatDateTime('d.mm.yyyy',now));
      exit
    end;
  if cmd(command) = '!uptime' then
    begin
      ini:=TProIni.Create(global.dir+'main\uptime.dat');
      c:=ini.ReadInteger('network',global.network,0);
      if c = 0 then
        msg(from,'Я нахожусь в сети '+duration(ctime-global.connect_time))
      else
        begin
          if (ctime-global.connect_time) > c then
            msg(from,'Я нахожусь в сети '+duration(ctime-global.connect_time)+
            ' Рекорд - '+duration(ctime-global.connect_time))
          else
            msg(from,'Я нахожусь в сети '+duration(ctime-global.connect_time)+
            ' Рекорд - '+duration(c))
        end;
      c:=ini.ReadInteger('system','uptime',0);
      ti:=uptime;
      if ti > c then
        msg(from,'Система работает '+duration(ti)+' Рекорд - '+
        duration(ti))
      else
        msg(from,'Система работает '+duration(ti)+' Рекорд - '+
        duration(c));
      ini.Free;
      exit
    end;
  if access(nick,adr) = ADMIN then
    begin
      if cmd(command) = '!com' then
        begin
          if word.Count < 3 then
            begin
              msg(nick,'Неправильный формат команды. см. !help !com');
              exit;
            end;
          send(AfterN(allmsg,2));
          msg(from,'Отправлено серверу: '+AfterN(allmsg,2));
          exit
        end;
      if cmd(command) = '!mact' then
        begin
          if word.Count < 3 then
            begin
              msg(nick,'Неправильный формат команды. см. !help !mact');
              exit;
            end;
          list:=userchans(global.nick);
          if list.Count > 0 then
            for ti:=0 to list.Count - 1 do
              msg(list[ti],#1'ACTION '+AfterN(allmsg,2)+#1);
          msg(from,'Отправлено на все каналы от 3-го лица: '+AfterN(allmsg,2));
          list.Free;
          exit;
        end;
      if cmd(command) = '!amsg' then
        begin
          if word.Count < 3 then
            begin
              msg(nick,'Неправильный формат команды. см. !help !amsg');
              exit;
            end;
          list:=userchans(global.nick);
          if list.Count > 0 then
            for ti:=0 to list.Count - 1 do
              msg(list[ti],AfterN(allmsg,2));
          msg(from,'Отправлено на все каналы: '+AfterN(allmsg,2));
          list.Free;
          exit;
        end;
      if cmd(command) = '!quit' then
        begin
          msg(from,'выхожу..');
          closerrr:=TCloser.Create('exit');
          exit;
        end;
      if cmd(command) = '!reboot' then
        begin
          msg(from,'перезагружаюсь..');
          closerrr:=TCloser.Create('reboot');
          exit;
        end;
      if cmd(command) = '!nick' then
        begin
          if word.Count < 3 then
            begin
              msg(nick,'Неправильный формат команды. см. !help !nick');
              exit;
            end;
          if word[2] = '' then
            begin
              msg(nick,'Неправильный формат команды. см. !help !nick');
              exit;
            end;
          send('NICK '+word[2]);
          exit;
        end;
    end;
end; // procedure main_command;

procedure main_notice;
begin
  if pos('#',target) = 0 then
    begin                                      // private notice
      if (settings.nsnick <> '')and(nick = settings.nsnick)and
        (pos(settings.nsidnotice,amsg) <> 0) then // nickserv identify notice!
        msg(nick,'IDENTIFY '+settings.nspass)
    end
end; // procedure main_notice;

procedure main_join;
var segf: TSegFile;
    list: TStringList;
    s: string;
    i2: integer;
begin
  Randomize;
  if nick = global.nick then
    begin                            // I'm join!
      channel.add(chan);
      send('WHO '+chan);
      if not(funcenabled(chan,BOT)) then exit;
      if FileExists(global.dir+'main\ijoin.txt') then
        msg(chan,fread(global.dir+'main\ijoin.txt'))
    end
  else
    begin
      if channel[chan] <> nil then channel[chan].adduser(nick);
      addresslist.add(nick,adr);
      if not(funcenabled(chan,BOT)) then exit;
      if settings.autooponjoin then
        begin
          i2:=access(nick,adr,chan);
          if (i2 = ADMIN)or(i2 = OP)or(i2 = HOP)or(i2 = VOICE) then
            case i2 of
              ADMIN,OP: send('MODE '+chan+' +o '+nick);
              HOP: send('MODE '+chan+' +h '+nick);
              VOICE: send('MODE '+chan+' +v '+nick);
            end;
        end;
      segf:=TSegFile.Create(global.dir+'main\ujoin.txt');
      if segf.SectionExists(nick) then
        begin
          list:=TStringList.Create;
          segf.ReadSection(nick,list);
          if list.Count <> 0 then
            msg(chan,list[random(list.Count)]);
          list.Free;
        end;
      segf.Free;
      s:=nick;
      replace(s,'|','!');
      if FileExists(global.dir+'mail\'+s) then
        begin
          if access(nick,adr) >= USER then
            msg(nick,'У вас есть новая почта. Для чтения введите !read')
          else
            begin
              if validuser(nick) then
                msg(nick,'У вас есть новая почта. Проидентифицируйтесь (!ident) и используйте !read для чтения')
              else
                msg(nick,'У вас есть новая почта. Для чтения зарегистрируйтесь (!register), и проидентифицируйтесь (!ident), затем используйте !read');
            end;
        end;
    end
end; // procedure main_join;

procedure main_part;
var list: TStringList;
begin
  if nick = global.nick then channel.del(chan) // I'm part!
  else
    begin
      if channel[chan] <> nil then channel[chan].deluser(nick);
      list:=userchans(nick);
      if list.Count = 0 then
        begin
          addresslist.del(nick);
          if (access(nick,adr) = ADMIN)and(settings.extrasecure) then
            accesslist.del(nick)
        end;
      list.Free
    end
end; // procedure main_part;

procedure main_nick;
var s: string;
begin
  if nick = global.nick then                // I'm change nick!
    begin
      global.nick:=newnick;
      if newnick = settings.nick then
        timer.DelTimer('SET_NICK');
      setcaption('fbot ['+global.nick+' подключен к '+global.server_name+']');
    end;
  channel.chguser(nick,newnick);
  addresslist.del(nick);
  addresslist.add(newnick,adr);
  if access(nick,adr) = ADMIN then
    begin
      accesslist.del(nick);
      accesslist.add(newnick,adr,ADMIN)
    end;
  s:=newnick;
  replace(s,'|','!');
  if FileExists(global.dir+'mail\'+s) then
    begin
      if access(newnick,adr) >= USER then
        msg(nick,'У вас есть новая почта. Для чтения введите !read')
      else
        begin
          if validuser(newnick) then
            msg(newnick,'У вас есть новая почта. Проидентифицируйтесь (!ident) и используйте !read для чтения')
          else
            msg(newnick,'У вас есть новая почта. Для чтения зарегистрируйтесь (!register), и проидентифицируйтесь (!ident), затем используйте !read');
        end;
    end;
end; // procedure main_nick;

procedure main_quit;
begin
  channel.deluser(nick);
  addresslist.del(nick);
  if access(nick,adr) = ADMIN then
    accesslist.del(nick)
end; // procedure main_quit;

procedure main_kick;
var list: TStringList;
begin
  if knick = global.nick then channel.del(chan) // I'm part!
  else
    begin
      if channel[chan] <> nil then channel[chan].deluser(nick);
      list:=userchans(knick);
      if list.Count = 0 then
        begin
          addresslist.del(knick);
          if (access(knick,address(knick)) = ADMIN)and(settings.extrasecure) then
            accesslist.del(knick)
        end;
      list.Free
    end
end; // procedure main_kick;

procedure main_601;
var data: TStringList;
begin
  data:=split(amsg,' ');
  accesslist.del(data[3]);
  send('WATCH -'+data[3]);
  data.Free
end; // procedure main_601;

procedure main_005;
var data: TStringList;
    i: word;
    tmp: string;
begin
  data:=split(amsg,' ');
  for i:=0 to data.Count-1 do
    if pos('NETWORK=',data[i]) <> 0 then
      begin
        tmp:=data[i];
        break
      end;
  if tmp <> '' then
    begin
      delete(tmp,1,8);
      global.network:=tmp
    end;
  data.Free
end; // procedure main_005;

procedure main_353;
var i: word;
begin
  if names.Count > 0 then
    for i:=0 to names.Count-1 do
      if names[i] <> '' then channel[chan].adduser(names[i])
end; // procedure main_353;

procedure main_366;
var chan: string;
begin
  chan:=word4(amsg);
  if channel[chan] <> nil then channel[chan].names_complete:=true
end; // procedure main_366;

procedure main_433;
var ntp: TNickTimerParams;
begin
  if global.nick <> '' then exit;       // already connected!
  if word4(amsg) = settings.nick then   // 1st attempt
    begin
      writelog('['+DateTimeToStr(Now)+'] основной ник '+settings.nick+' занят. '+
        'Использую альтернативный: '+settings.altnick);
      send('NICK '+settings.altnick);
      if not(timer.TimerExists('SET_NICK')) then
        begin
          ntp:=TNickTimerParams.Create;
          ntp.nick:=settings.nick;
          ntp.name:='SET_NICK';
          ntp.interval:=7000;
          timer.AddTimer(tt_NICK,ntp);
          ntp.Free;
        end;
      exit;
    end;
  if word4(amsg) = settings.altnick then
    writelog('['+DateTimeToStr(Now)+'] альтернативный ник '+settings.altnick+
      ' занят. Жду отсоединения.')
end; // procedure main_433;

procedure main_352;
var list: TStringList;
    ini: TProIni;
begin
  try
    list:=split(amsg,' ');
    addresslist.add(list[7],list[4]+'@'+list[5]);
    if global.network = '' then
      ini:=TProIni.Create(global.dir+'seen\base')
    else
      ini:=TProIni.Create(global.dir+'seen\'+global.network+'.base');
    if (ini.ReadString(list[7],'action','') = 'wason')and(ini.ReadString(list[7],'adr','') = '') then
      ini.WriteString(list[7],'adr',list[4]+'@'+list[5]);
    ini.Free;
    list.Free
  except end
end; // procedure main_352;

procedure main_mode;
var i: integer;
    s,tmp: string;
    list: TStringList;
begin
  if (word1(modes) = '+b')and(settings.kickonban) then
    begin
      s:=modes;
      delete(s,1,pos(' ',s));
      if s = '*!*@*' then exit;
      list:=TStringList.Create;
      channel[chan].getusers(list);
      for i:=0 to list.Count - 1 do
        begin
          tmp:=list[i];
          if (iswm(s,tmp+'!'+address(tmp)))and(access(tmp,address(tmp)) <> ADMIN)
          and(AnsiLowerCase(tmp) <> AnsiLowerCase(global.nick)) then
            kick(tmp,chan,'Banned');
        end;
      list.Free;
    end;
end; // procedure main_mode;

end.
