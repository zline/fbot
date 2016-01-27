unit help;

interface
uses Classes, SysUtils, struct, func;

procedure help_command(const nick,adr,allmsg: string; const word: TStringList);

implementation
uses mgr;

procedure help_command;
var command, subcom: string;
begin
  command:=word[1];
  if cmd(command) = '!help' then
    begin
      if word.Count = 2 then
        begin
          spooler.AddMsg(nick,'=== ������� fbot''a ('+version+') ===');
          spooler.Addmsg(nick,#31'�����'#31': !help, !ident, !version, !date, !time, !uptime, !seen, !send, !read, !register');
          if access(nick,adr) >= USER then
            begin
              spooler.Addmsg(nick,'������� '#31'������������'#31': !send, !read, !unident');
              spooler.Addmsg(nick,'������� '#31'����� ������'#31': !voice, !devoice');
              spooler.Addmsg(nick,'������� '#31'������������� ������'#31': !hop, !dehop');
              spooler.Addmsg(nick,'������� '#31'��������� ������'#31': !names, !topic, !invite, !op, !deop, !mass, !kick, !ban,');
              spooler.Addmsg(nick,'!chanaccess, !unban');
              spooler.Addmsg(nick,'������� '#31'�������������� ������'#31': !bot, !seenchan, !talk, !hello, !dialogue, !talksetup,');
              spooler.Addmsg(nick,'!act, !say, !chanaccess, !phrasereaction, !useglobalbase, !badwords');
              if access(nick,adr) >= OPERATOR then
                spooler.Addmsg(nick,'������� '#31'Global Operator''a'#31': ������ ��������� � ������ ������ + !acclist');
              if access(nick,adr) = ADMIN then
                begin
                  spooler.Addmsg(nick,'������� '#31'Root Administrator''a'#31': ������ �������������� � ������ ������ + !id, !join,');
                  spooler.Addmsg(nick,'!part, !rejoin, !perform, !ijoin, !ujoin, !talkfreq, !com, !quit, !mact, !amsg, !adduser,');
                  spooler.Addmsg(nick,'!deluser, !nick, !rename, !reboot');
                end;
              spooler.Addmsg(nick,'*  ������� ������ ������� ����� ������������ ������ ��������� �������');
              spooler.Addmsg(nick,'** ��� ��������� ������� � ������� ������� �������� !help access');
            end;
          spooler.Addmsg(nick,'��� ������ �� ������ ������� �������� !help '#31'�������'#31);
          spooler.Addmsg(nick,'=====================================');
          exit;
        end;
      subcom:=LowerCase(word[2]);
      if subcom = '!help' then
        begin
          msg(nick,'!help - ������� ������� �� �������� ����');
          msg(nick,'������� �� ������, � �������: !help ['#31'�������'#31']');
          msg(nick,''''#31'�������'#31''' - �������, ������ �� ������� �� ������ ��������.'+
            ' ���� �������, ��������� ������ ���� ������.');
          exit
        end;
      if subcom = '!ident' then
        begin
          msg(nick,'!ident - �������������� ��� � ����');
          msg(nick,'������� � �������: !ident '#31'������'#31);
          msg(nick,'* ����� - ��� ���');
          exit
        end;
      if subcom = '!version' then
        begin
          msg(nick,'!version - ������� ������ ����');
          msg(nick,'������� �� ������, � �������: !version');
          exit
        end;
      if subcom = '!date' then
        begin
          msg(nick,'!date - ������� ������� ����');
          msg(nick,'������� �� ������, � �������: !date');
          exit
        end;
      if subcom = '!time' then
        begin
          msg(nick,'!time - ������� ������� �����');
          msg(nick,'������� �� ������, � �������: !time');
          exit
        end;
      if subcom = '!uptime' then
        begin
          msg(nick,'!uptime - ������� ���������� � ������� ������ ������� � �������, ����������� ����� � ����');
          msg(nick,'������� �� ������, � �������: !uptime');
          exit
        end;
      if subcom = '!seen' then
        begin
          msg(nick,'!seen - ����� ������������ � ����');
          msg(nick,'������� ��������� �� ������ � � �������.');
          msg(nick,'!seen ��� ���������� - ����� ���������� � ������� ����');
          msg(nick,'!seen '#31'�����'#31' (����. !seen us*r) - ����� ������������ �� �����');
          msg(nick,'!seen '#31'������������'#31' - ����� ���������� ������������');
          exit
        end;
      if subcom = '!send' then
        begin
          msg(nick,'!send - �������� ��������� ������������');
          msg(nick,'������� ��������� ������ � �������.');
          msg(nick,'������: !send '#31'���'#31' '#31'���������'#31);
          msg(nick,'* �����, ������������ ��������������������� ������������, ����� ���� ��������� ��� ������. ���� �� ��� �� ������������������, ������������ ������������� ��� ������� (��. !help !register)');
          msg(nick,'** ����� ��������� ����������� �������� ����� �� ������ ����� ������� ��������������, ����������������� (��. !help !register)');
          exit;
        end;
      if subcom = '!read' then
        begin
          msg(nick,'!read - ������ ���������');
          msg(nick,'������� ��������� ������ � �������.');
          msg(nick,'������: !read');
          exit;
        end;
      if subcom = '!register' then
        begin
          msg(nick,'!register - �����������');
          msg(nick,'������� ��������� ������ � �������.');
          msg(nick,'!register '#31'������'#31' - ����������� �������� ���� ��� ��������� �������');
          msg(nick,'����� ����������� ������������ �������� ������ ������ � �������� ������ � ����������� �������� ������� � ������� (��. !help access)');
          msg(nick,'��� ����, ����� �������� ������ ������������ ����������� ������� !ident '#31'������'#31);
          exit;
        end;
      if access(nick,adr) >= USER then
        begin
          if subcom = '!names' then
            begin
              msg(nick,'!names - ����� ������ ������������� ���������� ������');
              msg(nick,'������� � �������: !names '#31'�����'#31);
              msg(nick,'* ��� ������ ��������� �� ��������� ������');
              exit
            end;
          if subcom = '!bot' then
            begin
              msg(nick,'!bot - ���������/���������� ���� ����������');
              msg(nick,'������� �� ������: !bot off - ���������� ����');
              msg(nick,'������� � �������: !bot '#31'�����'#31' on/off - ���������/���������� ���� �� �������� '#31'�����'#31'�');
              exit
            end;
          if subcom = '!seenchan' then
            begin
              msg(nick,'!seenchan - ���������/���������� ������� SEEN ����������');
              msg(nick,'������� �� ������: !seenchan on/off - ���������/���������� ������� ��������������.');
              msg(nick,'������� � �������: !seenchan '#31'�����'#31' on/off - ���������/���������� ������� �� �������� '#31'�����'#31'�');
              exit
            end;
          if subcom = '!unident' then
            begin
              msg(nick,'!unident - �������� ������� � ����.');
              msg(nick,'������������ � ������� ��� ����������. ������� ����� ���� � �������������� �������');
              msg(nick,'(�������� ����� � ���� �� �������� /watch � �� ��������� ����� extra_secure)');
              msg(nick,'(����� �������� � ������� ������������ ���� - ��. ������������)');
              msg(nick,'��� ������������ �������� ������� ����������� !ident');
              exit
            end;
          if subcom = '!talk' then
            begin
              msg(nick,'!talk - ���������/���������� ��������� ���� �� ������');
              msg(nick,'��� �������� � ������� �� ������ n-� ����� (n - ��������������� �������� !talkfreq).');
              msg(nick,'������� �� ������: !talk on/off');
              msg(nick,'������� � �������: !talk '#31'�����'#31' on/off');
              exit;
            end;
          if subcom = '!dialogue' then
            begin
              msg(nick,'!dialogue - ���������/���������� ������� ���� �� ��������� � ����');
              msg(nick,'��� ��������, ���� � ����-���� ����� ������������ ��� ��� ��� ���� ��');
              msg(nick,'��� �������������� ����� (�� talk.conf, ������ [dialogue_altnicks])');
              msg(nick,'������� �� ������: !dialogue on/off');
              msg(nick,'������� � �������: !dialogue '#31'�����'#31' on/off');
              exit;
            end;
          if subcom = '!hello' then
            begin
              msg(nick,'!hello - ���������/���������� ������ ����������� � �������� � ��������������');
              msg(nick,'��� ������������ ������������� �������, � �������� �� ��������');
              msg(nick,'������� �� ������: !hello on/off');
              msg(nick,'������� � �������: !hello '#31'�����'#31' on/off');
              exit;
            end;
          if subcom = '!badwords' then
            begin
              msg(nick,'!badwords - ���������� �������� ��������');
              msg(nick,'���������/����������:');
              msg(nick,'������� �� ������: !badwords on/off');
              msg(nick,'������� � �������: !badwords '#31'�����'#31' on/off');
              if access(nick,adr) >= OPERATOR then
                 msg(nick,'�������� ������ ����������� ����: !badwords list');
              if access(nick,adr) = ADMIN then
                begin
                  msg(nick,'���������� �����: !badwords add '#31'�����������_�����'#31);
                  msg(nick,'�������� �����: !badwords del '#31'�����������_�����'#31);
                  msg(nick,'��������� �������� ����: !badwords action kick|kickban|kick-kickban');
                end;
              exit;
            end;
          if subcom = '!phrasereaction' then
            begin
              msg(nick,'!phrasereaction - ���������/���������� ������ ������� �� �����');
              msg(nick,'��� ��������� �� ������������ �����, ������� ������������ ������');
              msg(nick,'������� �� ������: !phrasereaction on/off');
              msg(nick,'������� � �������: !phrasereaction '#31'�����'#31' on/off');
              exit;
            end;
          if subcom = '!useglobalbase' then
            begin
              msg(nick,'!useglobalbase - ����������/���������� ������������� ���������� ���� ����������� ������� �� ������');
              msg(nick,'�� ��������� �� ������ ��� ���������� ����� �� ���������� ���� (����� on), ��� ����� ���� ��������� (off). ��������� ���������������� �� ��� ����������� �������.');
              msg(nick,'������� �� ������: !useglobalbase on/off');
              msg(nick,'������� � �������: !useglobalbase '#31'�����'#31' on/off');
              exit;
            end;
          if subcom = '!talksetup' then
            begin
              msg(nick,'!talksetup - ���������� ��������� ����������� ������� ��� ��������� ������');
              msg(nick,'������� �� ������: !talksetup');
              msg(nick,'������� � �������: !talksetup '#31'�����'#31);
              exit;
            end;
          if subcom = '!act' then
            begin
              msg(nick,'!act - ���������� �������� �� ������ �� 3-�� ���� (/me)');
              msg(nick,'������� � �������: !act '#31'�����'#31' '#31'���������'#31);
              msg(nick,'* ����� ���� ������������ �������������� ������ ������ ���� ��� ��������� � ������ ����');
              exit;
            end;
          if subcom = '!say' then
            begin
              msg(nick,'!say - ��������� ��������� �� ��������� �����');
              msg(nick,'������� � �������: !say '#31'�����'#31' '#31'���������'#31);
              msg(nick,'* ����� ���� ������������ �������������� ������ ������ ���� ��� ��������� � ������ ����');
              exit;
            end;
          if subcom = '!topic' then
            begin
              msg(nick,'!topic - ����� ������ ������');
              msg(nick,'������� �� ������: !topic '#31'�����'#31);
              msg(nick,'������� � �������: !topic '#31'�����'#31' '#31'�����'#31);
              exit;
            end;
          if subcom = '!invite' then
            begin
              msg(nick,'!invite - ����������� ������������ �� �����');
              msg(nick,'������� �� ������: !invite '#31'���'#31);
              msg(nick,'������� � �������: !invite '#31'�����'#31' '#31'���'#31);
              exit;
            end;
          if subcom = '!op' then
            begin
              msg(nick,'!op - ���� �� ������������');
              msg(nick,'������� �� ������: !op '#31'���'#31);
              msg(nick,'������� � �������: !op '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, �� ������ ���');
              exit;
            end;
          if subcom = '!deop' then
            begin
              msg(nick,'!deop - ������� �� � ������������');
              msg(nick,'������� �� ������: !deop '#31'���'#31);
              msg(nick,'������� � �������: !deop '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, �� ���������� � ���');
              exit;
            end;
          if subcom = '!hop' then
            begin
              msg(nick,'!hop - ���� ��� ������������');
              msg(nick,'������� �� ������: !hop '#31'���'#31);
              msg(nick,'������� � �������: !hop '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, ��� ������ ���');
              exit;
            end;
          if subcom = '!dehop' then
            begin
              msg(nick,'!dehop - ������� ��� � ������������');
              msg(nick,'������� �� ������: !dehop '#31'���'#31);
              msg(nick,'������� � �������: !dehop '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, ��� ���������� � ���');
              exit;
            end;
          if subcom = '!voice' then
            begin
              msg(nick,'!voice - ���� ���� ������������');
              msg(nick,'������� �� ������: !voice '#31'���'#31);
              msg(nick,'������� � �������: !voice '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, ���� ������ ���');
              exit;
            end;
          if subcom = '!devoice' then
            begin
              msg(nick,'!devoice - ������� ���� � ������������');
              msg(nick,'������� �� ������: !devoice '#31'���'#31);
              msg(nick,'������� � �������: !devoice '#31'�����'#31' '#31'���'#31);
              msg(nick,'*����������: ���� �������� ��� ������, ���� ���������� � ���');
              exit;
            end;
          if subcom = '!mass' then
            begin
              msg(nick,'!mass - ��������, ����������� �� ����(*) ������������� ������');
              msg(nick,'������� �� ������: !mass '#31'�����'#31);
              msg(nick,'�������� ����� ����� ��������� ��������:');
              msg(nick,#31'op'#31' - ���� ���� ��');
              msg(nick,#31'deop'#31' - ������� � ���� ��');
              msg(nick,#31'hop'#31' - ���� ���� ���');
              msg(nick,#31'dehop'#31' - ������� � ���� ���');
              msg(nick,#31'voice'#31' - ���� ���� ����');
              msg(nick,#31'devoice'#31' - ������� � ���� ����');
              msg(nick,#31'kick'#31' - ������� ����');
              msg(nick,'*����������: ����� deop, dehop, devoice, kick �� ��������� �� ���������������, ���������� ���� � ������ ����.');
              exit;
            end;
          if subcom = '!kick' then
            begin
              msg(nick,'!kick - ������� ������������ � ������');
              msg(nick,'������� � �������: !kick '#31'�����'#31' '#31'���'#31' ['#31'�������'#31']');
              msg(nick,'������� �� ������: !kick '#31'���'#31' ['#31'�������'#31']');
              msg(nick,'*����������: �������� '#31'�������'#31' ������������');
              msg(nick,'* �� ��������� �� ���������������, ���������� ���� � ������ ����');
              exit;
            end;
          if subcom = '!ban' then
            begin
              msg(nick,'!ban - �������� ������������ �� ������');
              msg(nick,'������� � �������: !ban '#31'�����'#31' '#31'���/�����'#31);
              msg(nick,'������� �� ������: !ban '#31'���/�����'#31);
              msg(nick,'*����������: ���� ������� �����, ��� ������ ��� �� ���, ���� ������ ��� - ��� ������ ��� �� ���, �, ���� ����, �� ��� �����');
              msg(nick,'* ���� �������� ��������� ����-����, ���������� ������������ ����� ������');
              exit;
            end;
          if subcom = '!unban' then
            begin
              msg(nick,'!unban - ����� � ���� ��� / ��� ���� �� ������');
              msg(nick,'������� � �������: !unban '#31'�����'#31' [all]');
              msg(nick,'* ���� ������ �������������� �������� all , ��������� ��� ���� ������');
              exit;
            end;
          if subcom = 'access' then
            begin
              spooler.AddMsg(nick,'� ������� ������ ���� ������� ��� ���������� ������ �������: User, Global Operator, Root Administrator.');
              spooler.AddMsg(nick,'User - ������������� ������������ ����� ����������� (�� !help !register), User - ������� ������, ������ ������ � �������� ������� � ����������� ��������� ��������� ��������');
              spooler.AddMsg(nick,'Global Operator - �������� Root Administrator''���, ����� ������ ��������� (�� ����) �� ���� �������, � ����� ������ � ������� !acclist');
              spooler.AddMsg(nick,'Root Administrator - ������������� ������ ����� ���������, ����� ������ ������ � ����');
              spooler.AddMsg(nick,'���������� ����������� ��������� �������������� � ������� ������ !adduser !deluser !acclist');
              spooler.AddMsg(nick,'����� ����, ���������� ����������� ������ ���������� ������� (� ������ ������); ��� ��������� ���������� ������� ����� ���� ��� ������� User''��. ���������� ��������� ���� ��������� ��������:');
              spooler.AddMsg(nick,'Channel Voice - ����� ������ � �������� !voice !devoice �� �������, ��� �� ��������, �������� ���������������� ������ ��� Root Administrator''���');
              spooler.AddMsg(nick,'Channel HalfOperator - ����� ������ � �������� !voice !devoice !hop !dehop �� �������, ��� �� ��������, �������� ���������������� ������ ��� Root Administrator''���');
              spooler.AddMsg(nick,'Channel Operator - ��������, ����� ������ � �������� ��������� (!op, !kick, !mass, !topic � �.�.) �� �������, ��� �� ��������, �������� ���������������� ������ ��� Root Administrator''���');
              spooler.AddMsg(nick,'Channel Administrator - �������� ������ Root Administrator''���, ����� ������ ��������� � ������ + ������ � !act, !say + ����������� ��������� ������� ���� � ������ ������ (hello, talk, seen � �. �.)');
              spooler.AddMsg(nick,'���������� ���������� ��������� �������������� � ������� ������� !chanaccess');
              exit;
            end;
          if subcom = '!chanaccess' then
            begin
              spooler.AddMsg(nick,'!chanaccess - ���������� ���������� ���������');
              spooler.AddMsg(nick,'������� � �������: !chanaccess '#31'�����'#31' admin|oper|hop|voice add|del|list ['#31'���'#31']');
              spooler.AddMsg(nick,'����� admin|oper|hop|voice - ������������� ��������������, ���������, �������������, ����� ������');
              spooler.AddMsg(nick,'add - �������� ������, del - �������, list - ����������� �������');
              spooler.AddMsg(nick,'������� !chanaccess ��� ���������� - �������� ����� ��������� ��������');
              spooler.AddMsg(nick,'�������: !chanaccess #chan admin add nick - ���������� �������������� nick �� ����� #chan');
              spooler.AddMsg(nick,'!chanaccess #chan oper list - �������� ������ ���������� ������ #chan');
              spooler.AddMsg(nick,'* �������� ������� ��������������� ������ ����� ������ Root Administrator''�, ��������� ������� �������� ���������������� �������, ������������� ������ ������� ����� ��������� ������.');
              spooler.AddMsg(nick,'��� ��������� ������� � ������� ������� �������� !help access');
              exit;
            end;
        end;
      if access(nick,adr) >= OPERATOR then
        begin
          if subcom = '!acclist' then
            begin
              msg(nick,'!acclist - �������� ����� �������� � ����');
              msg(nick,'������� � �������, ��� ����������');
              exit;
            end;
        end;
      if access(nick,adr) = ADMIN then
        begin
          if subcom = '!id' then
            begin
              msg(nick,'!id - ��� ���������������� � ������� �����');
              msg(nick,'������� � �������: !id');
              exit
            end;
          if subcom = '!join' then
            begin
              msg(nick,'!join - ���� �� �����(�)');
              msg(nick,'������� �� ������, � �������: !join '#31'�����1'#31'['#31',�����2,...'#31'] ['#31'������_��_������'#31']');
              exit
            end;
          if subcom = '!part' then
            begin
              msg(nick,'!part - ����� � ������(��)');
              msg(nick,'������� �� ������: !part ['#31'�����1,�����2...'#31']');
              msg(nick,'������� � �������: !part '#31'�����1'#31'['#31',�����2...'#31']');
              msg(nick,'* ��� ������������� �� ������ ��� ���������� - ����� � ������');
              exit
            end;
          if subcom = '!rejoin' then
            begin
              msg(nick,'!rejoin - ��������� �� ��������� �����');
              msg(nick,'������� �� ������: !rejoin ['#31'�����'#31']');
              msg(nick,'������� � �������: !rejoin '#31'�����'#31);
              msg(nick,'* ��� ������������� �� ������ ��� ���������� - ��������� �� �����');
              exit
            end;
          if subcom = '!perform' then
            begin
              msg(nick,'!perform - ���������� ������ ��������������');
              msg(nick,'(������ irc-������, ���������� ������� ����� ����� �����������)');
              msg(nick,'��������� � �������.');
              msg(nick,'!perform list - ��������� ������');
              msg(nick,'!perform add '#31'�������'#31' - ���������� ������� � ������');
              msg(nick,'!perform del '#31'�'#31' - �������� ������� �� �� ������');
              exit
            end;
          if subcom = '!ijoin' then
            begin
              msg(nick,'!ijoin - ���������� ������� ����������� ����');
              msg(nick,'��������� � �������.');
              msg(nick,'!ijoin list - ��������� ������');
              msg(nick,'!ijoin add '#31'�����������'#31' - ���������� ����������� � ������');
              msg(nick,'!ijoin del '#31'�'#31' - �������� ����������� �� ��� ������');
              exit
            end;
          if subcom = '!ujoin' then
            begin
              msg(nick,'!ujoin - ���������� �������� ������������ �����������');
              msg(nick,'��������� � �������.');
              msg(nick,'!ujoin ��� ���������� - ��������� ������ ����������� �������������� �������������');
              msg(nick,'!ujoin '#31'������������'#31' list - ��������� ������ ����������� ��������� ������������');
              msg(nick,'!ujoin '#31'������������'#31' add '#31'�����������'#31' - ���������� ����������� ��� ������������');
              msg(nick,'!ujoin '#31'������������'#31' del '#31'�����������'#31' - �������� ����������� ��� ������������');
              exit
            end;
          if subcom = '!talkfreq' then
            begin
              msg(nick,'!talkfreq - ������������� ������� ��������� ���� �� ������� (�� !help !talk)');
              msg(nick,'������� �� ������, � �������: !talkfreq '#31'�������'#31);
              msg(nick,'������� ������ ���� ����� ������ ������ 0');
              exit;
            end;
          if subcom = '!com' then
            begin
              msg(nick,'!com - �������� ������� irc �������');
              msg(nick,'������� � �������: !com '#31'�������'#31);
              msg(nick,'*����������: ������� ������ ���� ��� �������� / , ��������: !com JOIN #foo');
              exit;
            end;
          if subcom = '!quit' then
            begin
              msg(nick,'!quit - ����� �� irc, �������� ���������');
              msg(nick,'������� � �������, �� ������, ��� ����������');
              exit;
            end;
          if subcom = '!reboot' then
            begin
              msg(nick,'!reboot - ������������ ����');
              msg(nick,'������� � �������, �� ������, ��� ����������');
              exit;
            end;
          if subcom = '!mact' then
            begin
              msg(nick,'!mact - �������� ��������� �� 3-�� ���� (/me) �� ��� ������');
              msg(nick,'������� � �������: !mact '#31'���������'#31);
              exit;
            end;
          if subcom = '!amsg' then
            begin
              msg(nick,'!amsg - �������� ��������� �� ��� ������');
              msg(nick,'������� � �������: !amsg '#31'���������'#31);
              exit;
            end;
          if subcom = '!adduser' then
            begin
              msg(nick,'!adduser - ���������� ������ ������������ � ���� �������');
              msg(nick,'������� � �������: !adduser '#31'�������'#31' '#31'���'#31' '#31'������'#31);
              msg(nick,'��������� ������: '#31'operator'#31', '#31'user'#31);
              exit;
            end;
          if subcom = '!deluser' then
            begin
              msg(nick,'!deluser - �������� ������������ �� ����� �������');
              msg(nick,'������� � �������: !deluser '#31'���'#31);
              exit;
            end;
          if subcom = '!nick' then
            begin
              msg(nick,'!nick - ����� ���� ����');
              msg(nick,'������� �� ������ � � �������: !nick '#31'���'#31);
              msg(nick,'*����������: ��������� ���� �� ����������� � ������������');
              exit;
            end;
          if subcom = '!rename' then
            begin
              msg(nick,'!rename - �������������� ���� � ��������� ������ � ����������� ���������');
              msg(nick,'������� � �������: !rename '#31'���'#31' ['#31'������'#31']');
              msg(nick,'*����������: '#31'������'#31' - ������ �� nickserv''e, �������������� ��������, ���� �� �� �����, �������� ������ ���');
              msg(nick,'* ��������� ����������� � ������������');
              exit;
            end;
        end;
      msg(nick,'����������� �������: '+word[2]);
      exit
    end;
end; // procedure help_command;

end.




