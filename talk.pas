unit talk;
interface
uses Classes, SysUtils, func, struct, time;

function antiflood: boolean;
function talktimeout: integer;
procedure talk_join(const nick,adr,chan: string);
procedure talk_chancom(const nick,adr,chan,allmsg: string; const word: TStringList);
procedure talk_querycom(const nick,adr,allmsg: string; const word: TStringList);
procedure talk_chantext(const nick,adr,chan,text: string);
procedure talk_querytext(const nick,adr,text: string);

implementation
uses mgr;

function antiflood;
var tconf: TProIni;
begin
  tconf:=TProIni.Create(global.dir+'conf\talk.conf');
  result:=tconf.ReadBool('anti-flood','enable',false);
  tconf.Free;
end; // function antiflood;

function talktimeout;
var tconf: TProIni;
begin
  tconf:=TProIni.Create(global.dir+'conf\talk.conf');
  result:=tconf.ReadInteger('anti-flood','timeout',2);
  tconf.Free;
end; // function talktimeout;

procedure talk_join;
var globlist, chanlist: TStringList;
    base: TSegFile;
    ind: integer;
begin
  if (not(funcenabled(chan,FHELLO)))or(nick = global.nick) then exit;
  base:=TSegFile.Create(global.dir+'main\ujoin.txt');
  if base.SectionExists(nick) then
    begin
      base.Free;
      exit;
    end;
  base.Free;
  Randomize;
  globlist:=TStringList.Create;
  chanlist:=TStringList.Create;
  base:=TSegFile.Create(global.dir+'talk\hello.txt');
  if funcenabled(chan,FGTB) then
    base.ReadSection('global',globlist)
  else
    globlist.Clear;
  base.ReadSection(chan,chanlist);
  if globlist.Count + chanlist.Count > 0 then
    begin
      ind:=random(globlist.Count + chanlist.Count);
      if ind < globlist.Count then
        notice(nick,globlist[ind]+', '+nick+'!')
      else
        begin
          ind:=ind-globlist.Count;
          notice(nick,chanlist[ind]+', '+nick+'!')
        end
    end;
  base.Free;
  globlist.Free;
  chanlist.Free
end; // procedure talk_join;

procedure talk_chancom;
const value: array[boolean] of string = ('���������', '��������');
var f: integer;
    ini: TProIni;
begin
  if access(nick,adr,chan) < ADMIN then exit;
  if cmd(word[1]) = '!phrasereaction' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !phrasereaction');
          exit;
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FPHRASES,true);
          msg(chan,'������� ������� �� ����� �������� �� '+chan);
          exit
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FPHRASES,false);
          msg(chan,'������� ������� �� ����� ��������� �� '+chan);
          exit
        end;
      msg(chan,'������������ ������ �������. ��. !help !phrasereaction');
      exit;
    end;
  if cmd(word[1]) = '!useglobalbase' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !useglobalbase');
          exit;
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FGTB,true);
          msg(chan,'������������� ���������� ��� ����������� ������� �������������� �� '+chan);
          exit;
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FGTB,false);
          msg(chan,'������������� ���������� ��� ����������� ������� ��������� �� '+chan);
          exit;
        end;
      msg(chan,'������������ ������ �������. ��. !help !useglobalbase');
      exit;
    end;
  if cmd(word[1]) = '!hello' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !hello');
          exit
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FHELLO,true);
          msg(chan,'������� ����������� �������� �� '+chan);
          exit
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FHELLO,false);
          msg(chan,'������� ����������� ��������� �� '+chan);
          exit
        end;
      msg(chan,'������������ ������ �������. ��. !help !hello');
      exit;
    end;
  if cmd(word[1]) = '!talk' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !talk');
          exit
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FTALK,true);
          msg(chan,'������� ��������� �������� �� '+chan);
          exit
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FTALK,false);
          msg(chan,'������� ��������� ��������� �� '+chan);
          exit
        end;
      msg(chan,'������������ ������ �������. ��. !help !talk');
      exit;
    end;
  if cmd(word[1]) = '!dialogue' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !dialogue');
          exit
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FDIALOGUE,true);
          msg(chan,'������� ������ �������� �� '+chan);
          exit
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FDIALOGUE,false);
          msg(chan,'������� ������ ��������� �� '+chan);
          exit
        end;
      msg(chan,'������������ ������ �������. ��. !help !dialogue');
      exit;
    end;
  if cmd(word[1]) = '!talksetup' then
    begin
      msg(chan,'��������� ����������� ������� ��� ������ '+chan+':');
      msg(chan,'������� ���������: '+value[funcenabled(chan,FTALK)]);
      msg(chan,'������� �������: '+value[funcenabled(chan,FDIALOGUE)]);
      msg(chan,'������� �����������/��������: '+value[funcenabled(chan,FHELLO)]);
      exit;
    end;
  if access(nick,adr) < ADMIN then exit;
  if cmd(word[1]) = '!talkfreq' then
    begin
      if word.Count < 3 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !talkfreq');
          exit;
        end;
      try f:=strtoint(word[2]);
      except
        msg(chan,'������������ ������ �������. ��. !help !talkfreq');
        exit;
      end;
      if f < 1 then
        begin
          msg(chan,'������� ��������� ������ ���� �� ������ 1!');
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\talk.conf');
      ini.WriteInteger('talk_freq','freq',f);
      msg(chan,'������� ��������� �������� �� '+inttostr(f));
      ini.Free;
      exit;
    end;
end; // procedure talk_chancom;

procedure talk_querycom;
const value: array[boolean] of string = ('���������', '��������');
var f: integer;
    ini: TProIni;
begin
  if cmd(word[1]) = '!hello' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !hello');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),FHELLO,true);
          msg(nick,'������� HELLO �������� �� '+validchan(word[2]));
          exit
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),FHELLO,false);
          msg(nick,'������� HELLO ��������� �� '+validchan(word[2]));
          exit
        end;
      msg(nick,'������������ ������ �������. ��. !help !hello');
      exit;
    end;
  if cmd(word[1]) = '!phrasereaction' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !phrasereaction');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),FPHRASES,true);
          msg(nick,'������� ������� �� ����� �������� �� '+validchan(word[2]));
          exit
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),FPHRASES,false);
          msg(nick,'������� ������� �� ����� ��������� �� '+validchan(word[2]));
          exit
        end;
      msg(nick,'������������ ������ �������. ��. !help !phrasereaction');
      exit;
    end;
  if cmd(word[1]) = '!useglobalbase' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !useglobalbase');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),FGTB,true);
          msg(nick,'������������� ���������� ��� ����������� ������� �������������� �� '+validchan(word[2]));
          exit
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),FGTB,false);
          msg(nick,'������������� ���������� ��� ����������� ������� ��������� �� '+validchan(word[2]));
          exit
        end;
      msg(nick,'������������ ������ �������. ��. !help !useglobalbase');
      exit;
    end;
  if cmd(word[1]) = '!talk' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !talk');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),FTALK,true);
          msg(nick,'������� TALK �������� �� '+validchan(word[2]));
          exit
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),FTALK,false);
          msg(nick,'������� TALK ��������� �� '+validchan(word[2]));
          exit
        end;
      msg(nick,'������������ ������ �������. ��. !help !talk');
      exit;
    end;
  if cmd(word[1]) = '!dialogue' then
    begin
      if word.Count < 4 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !dialogue');
          exit
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      if lowercase(word[3]) = 'on' then
        begin
          chgfuncstate(validchan(word[2]),FDIALOGUE,true);
          msg(nick,'������� ������ �������� �� '+validchan(word[2]));
          exit
        end;
      if lowercase(word[3]) = 'off' then
        begin
          chgfuncstate(validchan(word[2]),FDIALOGUE,false);
          msg(nick,'������� ������ ��������� �� '+validchan(word[2]));
          exit
        end;
      msg(nick,'������������ ������ �������. ��. !help !dialogue');
      exit;
    end;
  if cmd(word[1]) = '!talkfreq' then
    begin
      if access(nick,adr) < ADMIN then exit;
      if word.Count < 3 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !talkfreq');
          exit;
        end;
      try f:=strtoint(word[2]);
      except
        msg(nick,'������������ ������ �������. ��. !help !talkfreq');
        exit;
      end;
      if f < 1 then
        begin
          msg(nick,'������� ��������� ������ ���� �� ������ 1!');
          exit;
        end;
      ini:=TProIni.Create(global.dir+'conf\talk.conf');
      ini.WriteInteger('talk_freq','freq',f);
      msg(nick,'������� ��������� �������� �� '+inttostr(f));
      ini.Free;
      exit;
    end;
  if cmd(word[1]) = '!talksetup' then
    begin
      if word.Count < 3 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !talksetup');
          exit;
        end;
      if access(nick,adr,word[2]) < ADMIN then exit;
      msg(nick,'��������� ����������� ������� ��� ������ '+validchan(word[2])+':');
      msg(nick,'������� ���������: '+value[funcenabled(validchan(word[2]),FTALK)]);
      msg(nick,'������� �������: '+value[funcenabled(validchan(word[2]),FDIALOGUE)]);
      msg(nick,'������� �����������/��������: '+value[funcenabled(validchan(word[2]),FHELLO)]);
      exit;
    end;
end; // procedure talk_querycom;

procedure talk_chantext;
var ini: TProIni;
    freq,ind: integer;
    base: TSegFile;
    dbase: TDSegFile;
    globlist, chanlist, list: TStringList;
    callme,phdetect,dialog,phrases,talked: boolean;
    globalstring,chanstring,s: string;
begin
  phdetect:=false;
  callme:=false;
  dialog:=funcenabled(chan,FDIALOGUE);
  phrases:=(funcenabled(chan,FPHRASES))and(funcenabled(chan,BOT));
  if dialog then
    begin      // ����������� �������
      ini:=TProIni.Create(global.dir+'conf\talk.conf');
      list:=TStringList.Create;
      ini.ReadSectionValues('dialogue_altnicks',list);
      s:=AnsiLowerCase(text);
      if pos(AnsiLowerCase(global.nick),s) <> 0 then callme:=true;
      if list.Count > 0 then
        for ind:=0 to list.Count - 1 do
          if pos(AnsiLowerCase(list[ind]),s) <> 0 then callme:=true;
      list.Free;
      ini.Free;
    end;
  if (dialog)or(phrases) then
    begin                               // ����������� �������� �����
      globlist:=TStringList.Create;
      chanlist:=TStringList.Create;
      dbase:=TDSegFile.Create(global.dir+'talk\dialogue.txt');
      dbase.ReadSubSections(chan,chanlist);
      globalstring:='';
      chanstring:='';
      s:=' '+s+' ';
      if funcenabled(chan,FGTB) then
        begin // ����������� ����� �� ������ global
          dbase.ReadSubSections('global',globlist);
          if globlist.Count > 0 then
            for ind:=0 to globlist.Count - 1 do
              if pos(globlist[ind],s) <> 0 then
                begin
                  globalstring:=globlist[ind];
                  break;
                end;
        end;
      if chanlist.Count > 0 then // ����������� ����� �� ������ ������
        for ind:=0 to chanlist.Count - 1 do
          if pos(chanlist[ind],s) <> 0 then
            begin
              chanstring:=chanlist[ind];
              break;
            end;
      if (globalstring <> '')or(chanstring <> '') then phdetect:=true;
    end;
  if ((callme)and(phdetect))or((phdetect)and(phrases)) then
    begin      // �������� ������ �� { }
      talked:=false;
      if (globalstring <> '')and(chanstring <> '') then
        begin
          talked:=true;
          if (not(settings.talkantiflood))or(ctime - channel[chan].lasttalk >= settings.talktimeout) then
            begin
              randomize;
              dbase.ReadSubSection('global',globalstring,globlist);
              dbase.ReadSubSection(chan,chanstring,chanlist);
              if globlist.Count + chanlist.Count > 0 then
                begin
                  if settings.addtalknick then
                    s:=nick+', '
                  else
                    s:='';
                  ind:=random(globlist.Count + chanlist.Count);
                  if ind < globlist.Count then
                    msg(chan,s+globlist[ind])
                  else
                    begin
                      ind:=ind-globlist.Count;
                      msg(chan,s+chanlist[ind]);
                    end;
                end;
              channel[chan].lasttalk:=ctime;
            end;
        end;
      if (globalstring <> '')and(not(talked)) then
        begin
          if (not(settings.talkantiflood))or(ctime - channel[chan].lasttalk >= settings.talktimeout) then
            begin
              randomize;
              dbase.ReadSubSection('global',globalstring,globlist);
              if settings.addtalknick then
                s:=nick+', '
              else
                s:='';
              if globlist.Count > 0 then
                msg(chan,s+globlist[random(globlist.Count)]);
              channel[chan].lasttalk:=ctime;
              talked:=true;
            end;
        end;
      if (chanstring <> '')and(not(talked)) then
        begin
          if (not(settings.talkantiflood))or(ctime - channel[chan].lasttalk >= settings.talktimeout) then
            begin
              randomize;
              dbase.ReadSubSection(chan,chanstring,chanlist);
              if settings.addtalknick then
                s:=nick+', '
              else
                s:='';
              if chanlist.Count > 0 then
                msg(chan,s+chanlist[random(chanlist.Count)]);
              channel[chan].lasttalk:=ctime;
            end;
        end;
    end;
  if (not(phdetect))and(callme) then
    if (not(settings.talkantiflood))or(ctime - channel[chan].lasttalk >= settings.talktimeout) then
      begin      // �������� ��������
        randomize;
        if funcenabled(chan,FGTB) then
          dbase.ReadSubSection('global','',globlist)
        else
          globlist.Clear;
        dbase.ReadSubSection(chan,'',chanlist);
        if globlist.Count + chanlist.Count > 0 then
          begin
            if settings.addtalknick then
              s:=nick+', '
            else
              s:='';
            ind:=random(globlist.Count + chanlist.Count);
            if ind < globlist.Count then
              msg(chan,s+globlist[ind])
            else
              begin
                ind:=ind-globlist.Count;
                msg(chan,s+chanlist[ind]);
              end
          end;
        channel[chan].lasttalk:=ctime;
      end;
  if (dialog)or(phrases) then
    begin
      globlist.Free;
      chanlist.Free;
      dbase.Free;
    end;
  if not(funcenabled(chan,BOT)) then exit;
  if funcenabled(chan,FTALK) then
    begin
      ini:=TProIni.Create(global.dir+'conf\talk.conf');
      freq:=ini.ReadInteger('talk_freq','freq',0);
      ini.Free;
      if freq > 0 then
        if random(freq) = 0 then
          begin
            if (not(settings.talkantiflood))or(ctime - channel[chan].lasttalk >= settings.talktimeout) then
              begin
                randomize;
                base:=TSegFile.Create(global.dir+'talk\talk.txt');
                globlist:=TStringList.Create;
                chanlist:=TStringList.Create;
                if funcenabled(chan,FGTB) then
                  base.ReadSection('global',globlist)
                else
                  globlist.Clear;
                base.ReadSection(chan,chanlist);
                if globlist.Count + chanlist.Count > 0 then
                  begin
                    ind:=random(globlist.Count + chanlist.Count);
                    if ind < globlist.Count then
                      msg(chan,globlist[ind])
                    else
                      begin
                        ind:=ind-globlist.Count;
                        msg(chan,chanlist[ind]);
                      end
                  end;
                base.Free;
                globlist.Free;
                chanlist.Free;
                channel[chan].lasttalk:=ctime;
              end;
          end;
    end;
  if funcenabled(chan,FHELLO) then
    begin
      base:=TSegFile.Create(global.dir+'talk\bye.txt');
      list:=TStringList.Create;
      base.ReadSection('sign',list);
      callme:=false;
      if list.Count > 0 then
        for ind:=0 to list.Count - 1 do
          if pos(AnsiLowerCase(list[ind]),AnsiLowerCase(text)) <> 0 then callme:=true;
      list.Free;
      if callme then
        begin
          randomize;
          globlist:=TStringList.Create;
          chanlist:=TStringList.Create;
          if funcenabled(chan,FGTB) then
            base.ReadSection('global',globlist)
          else
            globlist.Clear;
          base.ReadSection(chan,chanlist);
          if globlist.Count + chanlist.Count > 0 then
            begin
              ind:=random(globlist.Count + chanlist.Count);
              if ind < globlist.Count then
                msg(chan,nick+', '+globlist[ind])
              else
                begin
                  ind:=ind-globlist.Count;
                  msg(chan,nick+', '+chanlist[ind]);
                end
            end;
          globlist.Free;
          chanlist.Free;
        end;
      base.Free;
    end;
end; // procedure talk_chantext;

procedure talk_querytext;
var ini: TProIni;
    list: TStringList;
    callme: boolean;
    dbase: TDSegFile;
    ind: integer;
    s,str: string;
begin
  ini:=TProIni.Create(global.dir+'conf\talk.conf');
  list:=TStringList.Create;
  ini.ReadSectionValues('dialogue_altnicks',list);
  callme:=false;
  if pos(AnsiLowerCase(global.nick),AnsiLowerCase(text)) <> 0 then callme:=true;
  if list.Count > 0 then
    for ind:=0 to list.Count - 1 do
      if pos(AnsiLowerCase(list[ind]),AnsiLowerCase(text)) <> 0 then callme:=true;
  ini.Free; // ����������� ����

  s:=' '+AnsiLowerCase(text)+' ';
  str:='';
  dbase:=TDSegFile.Create(global.dir+'talk\dialogue.txt');
  dbase.ReadSubSections('global',list);
  if list.Count > 0 then
    for ind:=0 to list.Count - 1 do
      if pos(list[ind],s) <> 0 then
        begin
          str:=list[ind];
          break;
        end; // ����������� �������� �����

  if str <> '' then
    begin // ������� �� �����
      randomize;
      if settings.addtalknick then
        s:=nick+', '
      else
        s:='';
      dbase.ReadSubSection('global',str,list);
      if list.Count > 0 then
        msg(nick,s+list[random(list.Count)]);
      list.Free;
      dbase.Free;
      exit;
    end;
  if callme then
    begin // ������
      randomize;
      if settings.addtalknick then
        s:=nick+', '
      else
        s:='';
      dbase.ReadSubSection('global','',list);
      if list.Count > 0 then
        msg(nick,s+list[random(list.Count)]);
    end;
  dbase.Free;
  list.Free;
end;

end.
