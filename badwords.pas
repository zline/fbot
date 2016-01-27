unit badwords;
interface
uses Classes, SysUtils, struct, func;

procedure badw_chancom(const nick,adr,chan,allmsg: string; const word: TStringList);
procedure badw_querycom(const nick,adr,allmsg: string; const word: TStringList);
procedure badw_chantext(const nick,adr,chan,text: string);

implementation
uses mgr;

procedure badw_chancom;
begin
  if access(nick,adr,chan) <> ADMIN then exit;
  if cmd(word[1]) = '!badwords' then
    begin
      if word.Count = 2 then
        begin
          msg(chan,'������������ ������ �������. ��. !help !badwords');
          exit;
        end;
      if lowercase(word[2]) = 'on' then
        begin
          chgfuncstate(chan,FBADWORDS,true);
          msg(chan,'������� ������� �������� �� '+chan);
          exit;
        end;
      if lowercase(word[2]) = 'off' then
        begin
          chgfuncstate(chan,FBADWORDS,false);
          msg(chan,'������� ������� ��������� �� '+chan);
          exit;
        end;
      msg(chan,'������������ ������ �������. ��. !help !badwords');
      exit;
    end;
end; // procedure badw_chancom;

procedure badw_querycom;
var bf: TextFile;
    s: string;
    ini: TProIni;
    i: integer;
begin
  if cmd(word[1]) = '!badwords' then
    begin
      if word.Count = 2 then
        begin
          msg(nick,'������������ ������ �������. ��. !help !badwords');
          exit;
        end;
      if lowercase(word[2]) = 'add' then
        begin
          if access(nick,adr) <> ADMIN then exit;
          if word.Count < 4 then
            begin
              msg(nick,'������������ ������ �������. ��. !help !badwords');
              exit;
            end;
          try
            if not(DirectoryExists(global.dir+'main'))
              then ForceDirectories(global.dir+'main');
            AssignFile(bf,global.dir+'main\badwords.txt');
            if FileExists(global.dir+'main\badwords.txt') then
              append(bf)
            else
              rewrite(bf);
            s:=AfterN(allmsg,3);
            writeln(bf,s);
            CloseFile(bf);
            lists.badwords.Add(s);
            msg(nick,'� ������ ����������� ���� ���������: '+s);
          except
            msg(nick,'������ ���������� ������������ �����.');
          end;
          exit;
        end;
      if lowercase(word[2]) = 'del' then
        begin
          if access(nick,adr) <> ADMIN then exit;
          if word.Count < 4 then
            begin
              msg(nick,'������������ ������ �������. ��. !help !badwords');
              exit;
            end;
          s:=AfterN(allmsg,3);
          if delstringfromfile(global.dir+'main\badwords.txt',s) then
            begin
              i:=lists.badwords.IndexOf(s);
              if i <> -1 then lists.badwords.Delete(i);
              msg(nick,'����������� ����� ������� �������');
            end
          else
            msg(nick,'������ �������� ������������ �����.');
          exit;
        end;
      if lowercase(word[2]) = 'list' then
        begin
          if access(nick,adr) < OPERATOR then exit;
          spooler.AddMsg(nick,'������ ����������� ����:');
          try
            if lists.badwords.Count > 0 then
              for i:=0 to lists.badwords.Count - 1 do
                spooler.AddMsg(nick,lists.badwords[i]);
          finally
            spooler.AddMsg(nick,'����� ������.');
          end;
          exit;
        end;
      if lowercase(word[2]) = 'action' then
        begin
          if access(nick,adr) <> ADMIN then exit;
          if word.Count < 4 then
            begin
              msg(nick,'������������ ������ �������. ��. !help !badwords');
              exit;
            end;
          s:=lowercase(word[3]);
          if (s <> 'kick')and(s <> 'kickban')and(s <> 'kick-kickban') then
            begin
              msg(nick,'�� ��������� ������ ��� ��������. ��. !help !badwords');
              exit;
            end;
          ini:=TProIni.Create(global.dir+'conf\badwords.conf');
          ini.WriteString('action','action',s);
          ini.Free;
          msg(nick,'�������� ��������.');
          exit;
        end;
      if lowercase(word[3]) = 'on' then
        begin
          if access(nick,adr,word[2]) < ADMIN then exit;
          chgfuncstate(validchan(word[2]),FBADWORDS,true);
          msg(nick,'������� ������� �������� �� '+validchan(word[2]));
          exit;
        end;
      if lowercase(word[3]) = 'off' then
        begin
          if access(nick,adr,word[2]) < ADMIN then exit;
          chgfuncstate(validchan(word[2]),FBADWORDS,false);
          msg(nick,'������� ������� ��������� �� '+validchan(word[2]));
          exit;
        end;
      msg(nick,'������������ ������ �������. ��. !help !badwords');
      exit;
    end;
end; // procedure badw_querycom;

procedure badw_chantext;
var i: integer;
    ini: TProIni;
    found: boolean;
    s: string;
begin
  if not(funcenabled(chan,FBADWORDS)) then exit;
  found:=false;
  if lists.badwords.Count > 0 then
    for i:=0 to lists.badwords.Count - 1 do
      if pos(ansilowercase(lists.badwords[i]),' '+ansilowercase(text)+' ') <> 0 then
        found:=true;
  if not(found) then exit;
  ini:=TProIni.Create(global.dir+'conf\badwords.conf');
  s:=ini.ReadString('action','action','kick');
  ini.Free;
  if lowercase(s) = 'kick' then
    kick(nick,chan,'��� �� ������!');
  if lowercase(s) = 'kickban' then
    begin
      ban(nick,chan);
      kick(nick,chan,'��� �� ������!');
    end;
  if lowercase(s) = 'kick-kickban' then
    begin
      ini:=TProIni.Create(global.dir+'main\badwords-warnings.dat');
      if ini.ReadBool(chan,nick,false) then
        begin
          ini.DeleteKey(chan,nick);
          ban(nick,chan);
          kick(nick,chan,'��� �� ������!');
        end
      else
        begin
          ini.WriteBool(chan,nick,true);
          kick(nick,chan,'��������������: ��� �� ������!');
        end;
      ini.Free;
    end;
end; // procedure badw_chantext;

end.
