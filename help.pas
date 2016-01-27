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
          spooler.AddMsg(nick,'=== Команды fbot''a ('+version+') ===');
          spooler.Addmsg(nick,#31'общие'#31': !help, !ident, !version, !date, !time, !uptime, !seen, !send, !read, !register');
          if access(nick,adr) >= USER then
            begin
              spooler.Addmsg(nick,'Команды '#31'пользователя'#31': !send, !read, !unident');
              spooler.Addmsg(nick,'Команды '#31'войса канала'#31': !voice, !devoice');
              spooler.Addmsg(nick,'Команды '#31'полуоператора канала'#31': !hop, !dehop');
              spooler.Addmsg(nick,'Команды '#31'оператора канала'#31': !names, !topic, !invite, !op, !deop, !mass, !kick, !ban,');
              spooler.Addmsg(nick,'!chanaccess, !unban');
              spooler.Addmsg(nick,'Команды '#31'администратора канала'#31': !bot, !seenchan, !talk, !hello, !dialogue, !talksetup,');
              spooler.Addmsg(nick,'!act, !say, !chanaccess, !phrasereaction, !useglobalbase, !badwords');
              if access(nick,adr) >= OPERATOR then
                spooler.Addmsg(nick,'Команды '#31'Global Operator''a'#31': доступ оператора к любому каналу + !acclist');
              if access(nick,adr) = ADMIN then
                begin
                  spooler.Addmsg(nick,'Команды '#31'Root Administrator''a'#31': доступ администратора к любому каналу + !id, !join,');
                  spooler.Addmsg(nick,'!part, !rejoin, !perform, !ijoin, !ujoin, !talkfreq, !com, !quit, !mact, !amsg, !adduser,');
                  spooler.Addmsg(nick,'!deluser, !nick, !rename, !reboot');
                end;
              spooler.Addmsg(nick,'*  Старшие уровни доступа могут пользоваться любыми командами младших');
              spooler.Addmsg(nick,'** Для получения справки о уровнях доступа наберите !help access');
            end;
          spooler.Addmsg(nick,'Для помощи по каждой команде наберите !help '#31'команда'#31);
          spooler.Addmsg(nick,'=====================================');
          exit;
        end;
      subcom:=LowerCase(word[2]);
      if subcom = '!help' then
        begin
          msg(nick,'!help - выводит справку по командам бота');
          msg(nick,'Команда на канале, в привате: !help ['#31'команда'#31']');
          msg(nick,''''#31'команда'#31''' - команда, помощь по который Вы хотите получить.'+
            ' Если опущена, выводится список всех команд.');
          exit
        end;
      if subcom = '!ident' then
        begin
          msg(nick,'!ident - идентифицирует Вас к боту');
          msg(nick,'Команда в привате: !ident '#31'пароль'#31);
          msg(nick,'* логин - Ваш ник');
          exit
        end;
      if subcom = '!version' then
        begin
          msg(nick,'!version - выводит версию бота');
          msg(nick,'Команда на канале, в привате: !version');
          exit
        end;
      if subcom = '!date' then
        begin
          msg(nick,'!date - выводит текущую дату');
          msg(nick,'Команда на канале, в привате: !date');
          exit
        end;
      if subcom = '!time' then
        begin
          msg(nick,'!time - выводит текущее время');
          msg(nick,'Команда на канале, в привате: !time');
          exit
        end;
      if subcom = '!uptime' then
        begin
          msg(nick,'!uptime - выводит информацию о времени работы системы и времени, проведенном ботом в сети');
          msg(nick,'Команда на канале, в привате: !uptime');
          exit
        end;
      if subcom = '!seen' then
        begin
          msg(nick,'!seen - поиск пользователя в сети');
          msg(nick,'Команда действует на канале и в привате.');
          msg(nick,'!seen без параметров - вывод информации о размере базы');
          msg(nick,'!seen '#31'маска'#31' (напр. !seen us*r) - поиск пользователя по маске');
          msg(nick,'!seen '#31'пользователь'#31' - поиск указанного пользователя');
          exit
        end;
      if subcom = '!send' then
        begin
          msg(nick,'!send - отправка сообщения пользователю');
          msg(nick,'Команда действует только в привате.');
          msg(nick,'Формат: !send '#31'ник'#31' '#31'сообщение'#31);
          msg(nick,'* почта, отправленная незарегистрированному пользователю, может быть прочитана кем угодно. Если вы еще не зарегистрировались, настоятельно рекомендуется это сделать (см. !help !register)');
          msg(nick,'** чтобы исключить возможность отправки почты от вашего имени другими пользователями, зарегистрируйтесь (см. !help !register)');
          exit;
        end;
      if subcom = '!read' then
        begin
          msg(nick,'!read - чтение сообщений');
          msg(nick,'Команда действует только в привате.');
          msg(nick,'Формат: !read');
          exit;
        end;
      if subcom = '!register' then
        begin
          msg(nick,'!register - регистрация');
          msg(nick,'Команда действует только в привате.');
          msg(nick,'!register '#31'пароль'#31' - регистрация текущего ника под указанным паролем');
          msg(nick,'После регистрации пользователь получает полный доступ к почтовой службе и возможность получать доступы к каналам (см. !help access)');
          msg(nick,'Для того, чтобы получить доступ пользователя используйте команду !ident '#31'пароль'#31);
          exit;
        end;
      if access(nick,adr) >= USER then
        begin
          if subcom = '!names' then
            begin
              msg(nick,'!names - вывод списка пользователей указанного канала');
              msg(nick,'Команда в привате: !names '#31'канал'#31);
              msg(nick,'* бот должен находится на указанном канале');
              exit
            end;
          if subcom = '!bot' then
            begin
              msg(nick,'!bot - включение/выключение бота поканально');
              msg(nick,'Команда на канале: !bot off - выключение бота');
              msg(nick,'Команда в привате: !bot '#31'канал'#31' on/off - включение/выключение бота на заданном '#31'канал'#31'е');
              exit
            end;
          if subcom = '!seenchan' then
            begin
              msg(nick,'!seenchan - включение/выключение фунцкии SEEN поканально');
              msg(nick,'Команда на канале: !seenchan on/off - включение/выключение функции соответственно.');
              msg(nick,'Команда в привате: !seenchan '#31'канал'#31' on/off - включение/выключение функции на заданном '#31'канал'#31'е');
              exit
            end;
          if subcom = '!unident' then
            begin
              msg(nick,'!unident - закрытие доступа к боту.');
              msg(nick,'Используется в привате без параметров. Команда нужна лишь в исключительных случаях');
              msg(nick,'(например когда в сети не работает /watch и Вы отключили режим extra_secure)');
              msg(nick,'(более подробно о системе безопасности бота - см. документацию)');
              msg(nick,'Для последующего открытия доступа используйте !ident');
              exit
            end;
          if subcom = '!talk' then
            begin
              msg(nick,'!talk - включение/отключение разговора бота на канале');
              msg(nick,'Бот отвечает в среднем на каждую n-ю фразу (n - устанавливается командой !talkfreq).');
              msg(nick,'Команда на канале: !talk on/off');
              msg(nick,'Команда в привате: !talk '#31'канал'#31' on/off');
              exit;
            end;
          if subcom = '!dialogue' then
            begin
              msg(nick,'!dialogue - включение/отключение ответов бота на обращение к нему');
              msg(nick,'Бот отвечает, если в чьей-либо фразе присутствует его ник или один из');
              msg(nick,'его альтернативных ников (см talk.conf, секция [dialogue_altnicks])');
              msg(nick,'Команда на канале: !dialogue on/off');
              msg(nick,'Команда в привате: !dialogue '#31'канал'#31' on/off');
              exit;
            end;
          if subcom = '!hello' then
            begin
              msg(nick,'!hello - включение/отключение режима приветствий и прощания с пользователями');
              msg(nick,'Бот приветствует вновьвошедших нотисом, и отвечает на прощания');
              msg(nick,'Команда на канале: !hello on/off');
              msg(nick,'Команда в привате: !hello '#31'канал'#31' on/off');
              exit;
            end;
          if subcom = '!badwords' then
            begin
              msg(nick,'!badwords - управление функцией антимата');
              msg(nick,'Включение/выключение:');
              msg(nick,'Команда на канале: !badwords on/off');
              msg(nick,'Команда в привате: !badwords '#31'канал'#31' on/off');
              if access(nick,adr) >= OPERATOR then
                 msg(nick,'Просмотр списка блокируемых слов: !badwords list');
              if access(nick,adr) = ADMIN then
                begin
                  msg(nick,'Добавление слова: !badwords add '#31'блокируемая_фраза'#31);
                  msg(nick,'Удаление слова: !badwords del '#31'блокируемая_фраза'#31);
                  msg(nick,'Изменения действия бота: !badwords action kick|kickban|kick-kickban');
                end;
              exit;
            end;
          if subcom = '!phrasereaction' then
            begin
              msg(nick,'!phrasereaction - включение/отключение режима реакций на фразы');
              msg(nick,'Бот реагирует на определенные фразы, выдавая определенные ответы');
              msg(nick,'Команда на канале: !phrasereaction on/off');
              msg(nick,'Команда в привате: !phrasereaction '#31'канал'#31' on/off');
              exit;
            end;
          if subcom = '!useglobalbase' then
            begin
              msg(nick,'!useglobalbase - разрешение/запрещение использования глобальных фраз разговорных функций на канале');
              msg(nick,'По умолчанию на канале бот использует фразы из глобальной базы (опция on), что может быть отключено (off). Настройка распространяется на все разговорные функции.');
              msg(nick,'Команда на канале: !useglobalbase on/off');
              msg(nick,'Команда в привате: !useglobalbase '#31'канал'#31' on/off');
              exit;
            end;
          if subcom = '!talksetup' then
            begin
              msg(nick,'!talksetup - отображает настройки разговорных функций для заданного канала');
              msg(nick,'Команда на канале: !talksetup');
              msg(nick,'Команда в привате: !talksetup '#31'канал'#31);
              exit;
            end;
          if subcom = '!act' then
            begin
              msg(nick,'!act - совершение действия на канале от 3-го лица (/me)');
              msg(nick,'Команда в привате: !act '#31'канал'#31' '#31'сообщение'#31);
              msg(nick,'* Может быть использована админстратором канала только если это разрешено в опциях бота');
              exit;
            end;
          if subcom = '!say' then
            begin
              msg(nick,'!say - отправить сообщение на указанный канал');
              msg(nick,'Команда в привате: !say '#31'канал'#31' '#31'сообщение'#31);
              msg(nick,'* Может быть использована админстратором канала только если это разрешено в опциях бота');
              exit;
            end;
          if subcom = '!topic' then
            begin
              msg(nick,'!topic - смена топика канала');
              msg(nick,'Команда на канале: !topic '#31'топик'#31);
              msg(nick,'Команда в привате: !topic '#31'канал'#31' '#31'топик'#31);
              exit;
            end;
          if subcom = '!invite' then
            begin
              msg(nick,'!invite - приглашение пользователя на канал');
              msg(nick,'Команда на канале: !invite '#31'ник'#31);
              msg(nick,'Команда в привате: !invite '#31'канал'#31' '#31'ник'#31);
              exit;
            end;
          if subcom = '!op' then
            begin
              msg(nick,'!op - дать оп пользователю');
              msg(nick,'Команда на канале: !op '#31'ник'#31);
              msg(nick,'Команда в привате: !op '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, оп дается Вам');
              exit;
            end;
          if subcom = '!deop' then
            begin
              msg(nick,'!deop - забрать оп у пользователя');
              msg(nick,'Команда на канале: !deop '#31'ник'#31);
              msg(nick,'Команда в привате: !deop '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, оп забирается у Вас');
              exit;
            end;
          if subcom = '!hop' then
            begin
              msg(nick,'!hop - дать хоп пользователю');
              msg(nick,'Команда на канале: !hop '#31'ник'#31);
              msg(nick,'Команда в привате: !hop '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, хоп дается Вам');
              exit;
            end;
          if subcom = '!dehop' then
            begin
              msg(nick,'!dehop - забрать хоп у пользователя');
              msg(nick,'Команда на канале: !dehop '#31'ник'#31);
              msg(nick,'Команда в привате: !dehop '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, хоп забирается у Вас');
              exit;
            end;
          if subcom = '!voice' then
            begin
              msg(nick,'!voice - дать войс пользователю');
              msg(nick,'Команда на канале: !voice '#31'ник'#31);
              msg(nick,'Команда в привате: !voice '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, войс дается Вам');
              exit;
            end;
          if subcom = '!devoice' then
            begin
              msg(nick,'!devoice - забрать войс у пользователя');
              msg(nick,'Команда на канале: !devoice '#31'ник'#31);
              msg(nick,'Команда в привате: !devoice '#31'канал'#31' '#31'ник'#31);
              msg(nick,'*Примечание: если параметр ник опущен, войс забирается у Вас');
              exit;
            end;
          if subcom = '!mass' then
            begin
              msg(nick,'!mass - действие, применяемое ко всем(*) пользователям канала');
              msg(nick,'Команда на канале: !mass '#31'опция'#31);
              msg(nick,'Параметр опция имеет следующие значения:');
              msg(nick,#31'op'#31' - дать всем оп');
              msg(nick,#31'deop'#31' - забрать у всех оп');
              msg(nick,#31'hop'#31' - дать всем хоп');
              msg(nick,#31'dehop'#31' - забрать у всех хоп');
              msg(nick,#31'voice'#31' - дать всем войс');
              msg(nick,#31'devoice'#31' - забрать у всех войс');
              msg(nick,#31'kick'#31' - кикнуть всех');
              msg(nick,'*Примечание: опции deop, dehop, devoice, kick не действуют на администраторов, операторов бота и самого бота.');
              exit;
            end;
          if subcom = '!kick' then
            begin
              msg(nick,'!kick - кикнуть пользователя с канала');
              msg(nick,'Команда в привате: !kick '#31'канал'#31' '#31'ник'#31' ['#31'причина'#31']');
              msg(nick,'Команда на канале: !kick '#31'ник'#31' ['#31'причина'#31']');
              msg(nick,'*Примечание: параметр '#31'причина'#31' необязателен');
              msg(nick,'* не действует на администраторов, операторов бота и самого бота');
              exit;
            end;
          if subcom = '!ban' then
            begin
              msg(nick,'!ban - забанить пользователя на канале');
              msg(nick,'Команда в привате: !ban '#31'канал'#31' '#31'ник/маска'#31);
              msg(nick,'Команда на канале: !ban '#31'ник/маска'#31);
              msg(nick,'*Примечание: если указана маска, бот ставит бан по ней, если указан ник - бот ставит бан на ник, и, если есть, на его адрес');
              msg(nick,'* если включена настройка Авто-кика, забаненный пользователь будет кикнут');
              exit;
            end;
          if subcom = '!unban' then
            begin
              msg(nick,'!unban - снять с себя бан / все баны на канале');
              msg(nick,'Команда в привате: !unban '#31'канал'#31' [all]');
              msg(nick,'* если указан необязательный параметр all , снимаются все баны канала');
              exit;
            end;
          if subcom = 'access' then
            begin
              spooler.AddMsg(nick,'В текущей версии бота имеется три глобальных уровня доступа: User, Global Operator, Root Administrator.');
              spooler.AddMsg(nick,'User - присваивается пользователю после регистрации (см !help !register), User - базовый доступ, дающий доступ к почтовой системе и возможность получения локальных доступов');
              spooler.AddMsg(nick,'Global Operator - выдается Root Administrator''ами, имеет доступ оператора (см ниже) ко всем каналам, а также доступ к команде !acclist');
              spooler.AddMsg(nick,'Root Administrator - прописывается только через программу, имеет полный доступ к боту');
              spooler.AddMsg(nick,'Управление глобальными доступами осуществляется с помощью команд !adduser !deluser !acclist');
              spooler.AddMsg(nick,'Кроме того, существует возможность выдачи локального доступа (в рамках канала); для получения локального доступа нужно быть как минимум User''ом. Существуют следующие виды локальных доступов:');
              spooler.AddMsg(nick,'Channel Voice - имеет доступ к командам !voice !devoice на каналах, где он прописан, выдается администраторами канала или Root Administrator''ами');
              spooler.AddMsg(nick,'Channel HalfOperator - имеет доступ к командам !voice !devoice !hop !dehop на каналах, где он прописан, выдается администраторами канала или Root Administrator''ами');
              spooler.AddMsg(nick,'Channel Operator - оператор, имеет доступ к командам оператора (!op, !kick, !mass, !topic и т.д.) на каналах, где он прописан, выдается администраторами канала или Root Administrator''ами');
              spooler.AddMsg(nick,'Channel Administrator - выдается только Root Administrator''ами, имеет доступ оператора к каналу + доступ к !act, !say + возможность настройки функций бота в рамках канала (hello, talk, seen и т. д.)');
              spooler.AddMsg(nick,'Управление локальными доступами осуществляется с помощью команды !chanaccess');
              exit;
            end;
          if subcom = '!chanaccess' then
            begin
              spooler.AddMsg(nick,'!chanaccess - управление локальными доступами');
              spooler.AddMsg(nick,'Команда в привате: !chanaccess '#31'канал'#31' admin|oper|hop|voice add|del|list ['#31'ник'#31']');
              spooler.AddMsg(nick,'Опции admin|oper|hop|voice - соответствуют администратору, оператору, полуоператору, войсу канала');
              spooler.AddMsg(nick,'add - добавить доступ, del - удалить, list - просмотреть доступы');
              spooler.AddMsg(nick,'команда !chanaccess без параметров - просмотр ваших локальных доступов');
              spooler.AddMsg(nick,'Примеры: !chanaccess #chan admin add nick - добавление администратора nick на канал #chan');
              spooler.AddMsg(nick,'!chanaccess #chan oper list - просмотр списка операторов канала #chan');
              spooler.AddMsg(nick,'* изменять доступы администраторов канала могут только Root Administrator''ы, остальные доступы меняются администраторами каналов, просматривать списки доступа могут операторы канала.');
              spooler.AddMsg(nick,'Для получения справки о уровнях доступа наберите !help access');
              exit;
            end;
        end;
      if access(nick,adr) >= OPERATOR then
        begin
          if subcom = '!acclist' then
            begin
              msg(nick,'!acclist - просмотр листа доступов к боту');
              msg(nick,'Команда в привате, без параметров');
              exit;
            end;
        end;
      if access(nick,adr) = ADMIN then
        begin
          if subcom = '!id' then
            begin
              msg(nick,'!id - бот идентифицируется к сервису ников');
              msg(nick,'Команда в привате: !id');
              exit
            end;
          if subcom = '!join' then
            begin
              msg(nick,'!join - вход на канал(ы)');
              msg(nick,'Команда на канале, в привате: !join '#31'канал1'#31'['#31',канал2,...'#31'] ['#31'пароль_от_канала'#31']');
              exit
            end;
          if subcom = '!part' then
            begin
              msg(nick,'!part - выход с канала(ов)');
              msg(nick,'Команда на канале: !part ['#31'канал1,канал2...'#31']');
              msg(nick,'Команда в привате: !part '#31'канал1'#31'['#31',канал2...'#31']');
              msg(nick,'* при использовании на канале без параметров - выход с канала');
              exit
            end;
          if subcom = '!rejoin' then
            begin
              msg(nick,'!rejoin - перезаход на указанный канал');
              msg(nick,'Команда на канале: !rejoin ['#31'канал'#31']');
              msg(nick,'Команда в привате: !rejoin '#31'канал'#31);
              msg(nick,'* при использовании на канале без параметров - перезаход на канал');
              exit
            end;
          if subcom = '!perform' then
            begin
              msg(nick,'!perform - управление листом автовыполнения');
              msg(nick,'(список irc-команд, посылаемых серверу сразу после подключения)');
              msg(nick,'Действует в привате.');
              msg(nick,'!perform list - получение списка');
              msg(nick,'!perform add '#31'команда'#31' - добавление команды в список');
              msg(nick,'!perform del '#31'№'#31' - удаление команды по ее номеру');
              exit
            end;
          if subcom = '!ijoin' then
            begin
              msg(nick,'!ijoin - управление списком приветствий бота');
              msg(nick,'Действует в привате.');
              msg(nick,'!ijoin list - получение списка');
              msg(nick,'!ijoin add '#31'приветствие'#31' - добавление приветствия в список');
              msg(nick,'!ijoin del '#31'№'#31' - удаление приветствия по его номеру');
              exit
            end;
          if subcom = '!ujoin' then
            begin
              msg(nick,'!ujoin - управление списками персональных приветствий');
              msg(nick,'Действует в привате.');
              msg(nick,'!ujoin без параметров - получение списка персонально приветствуемых пользователей');
              msg(nick,'!ujoin '#31'пользователь'#31' list - получение списка приветствий заданного пользователя');
              msg(nick,'!ujoin '#31'пользователь'#31' add '#31'приветствие'#31' - добавление приветствия для пользователя');
              msg(nick,'!ujoin '#31'пользователь'#31' del '#31'приветствие'#31' - удаление приветствия для пользователя');
              exit
            end;
          if subcom = '!talkfreq' then
            begin
              msg(nick,'!talkfreq - устанавливает частоту разговора бота на каналах (см !help !talk)');
              msg(nick,'Команда на канале, в привате: !talkfreq '#31'частота'#31);
              msg(nick,'Частота должна быть целым числом больше 0');
              exit;
            end;
          if subcom = '!com' then
            begin
              msg(nick,'!com - отправка команды irc серверу');
              msg(nick,'Команда в привате: !com '#31'команда'#31);
              msg(nick,'*Примечание: команда должна быть без префикса / , например: !com JOIN #foo');
              exit;
            end;
          if subcom = '!quit' then
            begin
              msg(nick,'!quit - выход из irc, закрытие программы');
              msg(nick,'Команда в привате, на канале, без параметров');
              exit;
            end;
          if subcom = '!reboot' then
            begin
              msg(nick,'!reboot - перезагрузка бота');
              msg(nick,'Команда в привате, на канале, без параметров');
              exit;
            end;
          if subcom = '!mact' then
            begin
              msg(nick,'!mact - отправка сообщения от 3-го лица (/me) на все каналы');
              msg(nick,'Команда в привате: !mact '#31'сообщение'#31);
              exit;
            end;
          if subcom = '!amsg' then
            begin
              msg(nick,'!amsg - отправка сообщения на все каналы');
              msg(nick,'Команда в привате: !amsg '#31'сообщение'#31);
              exit;
            end;
          if subcom = '!adduser' then
            begin
              msg(nick,'!adduser - добавление нового пользователя в лист доступа');
              msg(nick,'Команда в привате: !adduser '#31'уровень'#31' '#31'ник'#31' '#31'пароль'#31);
              msg(nick,'Возможные уровни: '#31'operator'#31', '#31'user'#31);
              exit;
            end;
          if subcom = '!deluser' then
            begin
              msg(nick,'!deluser - удаление пользователя из листа доступа');
              msg(nick,'Команда в привате: !deluser '#31'ник'#31);
              exit;
            end;
          if subcom = '!nick' then
            begin
              msg(nick,'!nick - смена ника бота');
              msg(nick,'Команда на канале и в привате: !nick '#31'ник'#31);
              msg(nick,'*Примечание: изменения ника не сохраняются в конфигурации');
              exit;
            end;
          if subcom = '!rename' then
            begin
              msg(nick,'!rename - переименование бота и изменение пароля с сохранением изменений');
              msg(nick,'Команда в привате: !rename '#31'ник'#31' ['#31'пароль'#31']');
              msg(nick,'*Примечание: '#31'пароль'#31' - пароль на nickserv''e, необязательный параметр, если он не задан, меняется только ник');
              msg(nick,'* изменения сохраняются в конфигурации');
              exit;
            end;
        end;
      msg(nick,'Неизвестная команда: '+word[2]);
      exit
    end;
end; // procedure help_command;

end.




