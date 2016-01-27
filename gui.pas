unit gui;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ShellApi, struct, CheckLst, jpeg, func,
  u_adduserform, u_inputrequest, u_addservform, u_segfileedit, updater, timers,
  spoolers, u_addbadword, u_chanaccessform, seims, u_dsegfileedit;

//{$DEFINE DEBUG}

type
  TMainForm = class(TForm)
    pcConf: TPageControl;
    tsMain: TTabSheet;
    tsLog: TTabSheet;
    tsInfo: TTabSheet;
    btExit: TButton;
    Label1: TLabel;
    edHost: TEdit;
    edPort: TEdit;
    edPass: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edNick: TEdit;
    edUser: TEdit;
    edReal: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbChan: TCheckBox;
    cbQuery: TCheckBox;
    cbOut: TCheckBox;
    tsConnect: TTabSheet;
    tsCTCP: TTabSheet;
    Label7: TLabel;
    edWaitTime: TEdit;
    cbCTCPPing: TCheckBox;
    cbCTCPTime: TCheckBox;
    meInfo: TMemo;
    tsClient: TTabSheet;
    cbTray: TCheckBox;
    cbAltServ: TCheckBox;
    Label8: TLabel;
    cbTmStamp: TCheckBox;
    Label9: TLabel;
    cboxLogSplit: TComboBox;
    Label10: TLabel;
    cboxLogStyle: TComboBox;
    cbB: TCheckBox;
    cbi: TCheckBox;
    cbx: TCheckBox;
    Label11: TLabel;
    tsIRC: TTabSheet;
    Label12: TLabel;
    edQmsg: TEdit;
    edKmsg: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    edNsNick: TEdit;
    edNsPass: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    edNsIdNotice: TEdit;
    Label17: TLabel;
    cbIRCOptions: TCheckListBox;
    Label18: TLabel;
    edAltNick: TEdit;
    imLogo: TImage;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    TreeView: TTreeView;
    tsAdmin: TTabSheet;
    tsUsers: TTabSheet;
    GroupBox1: TGroupBox;
    Label22: TLabel;
    lbUsers: TListBox;
    BtUNew: TButton;
    BtUEdit: TButton;
    BtUDel: TButton;
    tsPerform: TTabSheet;
    mePerform: TMemo;
    Label23: TLabel;
    btPerform: TButton;
    Label24: TLabel;
    Label27: TLabel;
    cbPerfAct: TComboBox;
    tsAltServers: TTabSheet;
    Label29: TLabel;
    lbAltServers: TListBox;
    btAddAltServ: TButton;
    btEditAltServ: TButton;
    btDelAltServ: TButton;
    tsTalkFunc: TTabSheet;
    Label30: TLabel;
    tsHello: TTabSheet;
    Label31: TLabel;
    lbHelloConf: TListBox;
    btAddHelloChan: TButton;
    btDelHelloChan: TButton;
    btConfigHelloBase: TButton;
    btConfigByeBase: TButton;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    tsTalk: TTabSheet;
    lbTalkConf: TListBox;
    btDelTalkChan: TButton;
    btAddTalkChan: TButton;
    Label32: TLabel;
    btConfigTalk: TButton;
    StaticText9: TStaticText;
    tsDialogue: TTabSheet;
    StaticText10: TStaticText;
    Label33: TLabel;
    lbDialogueConf: TListBox;
    btAddDialogChan: TButton;
    btDelDialogChan: TButton;
    btConfigDialogue: TButton;
    Label34: TLabel;
    lbDialogNicks: TListBox;
    btDelDialogNick: TButton;
    btAddDialogNick: TButton;
    Label35: TLabel;
    edTalkFreq: TEdit;
    tsIjoin: TTabSheet;
    Label36: TLabel;
    meIjoin: TMemo;
    btSaveIjoin: TButton;
    tsUjoin: TTabSheet;
    btConfigUjoin: TButton;
    tsMail: TTabSheet;
    cbAntiFlood: TCheckBox;
    Label38: TLabel;
    cbAntiFloodTimeout: TComboBox;
    Label39: TLabel;
    Label40: TLabel;
    cbUpdater: TCheckBox;
    cbMinToTray: TCheckBox;
    tsNull: TTabSheet;
    Label41: TLabel;
    Label42: TLabel;
    btReload: TButton;
    tsFunc: TTabSheet;
    Label43: TLabel;
    tsBadw: TTabSheet;
    tsSeen: TTabSheet;
    lbBadwConf: TListBox;
    Label44: TLabel;
    btAddBadwChan: TButton;
    btDelBadwChan: TButton;
    Label45: TLabel;
    cbBadwKind: TComboBox;
    Label46: TLabel;
    lbBadwComment: TLabel;
    Label47: TLabel;
    lbBadwords: TListBox;
    btAddBadw: TButton;
    btDelBadw: TButton;
    lbSeenConf: TListBox;
    Label48: TLabel;
    btAddSeenChan: TButton;
    btDelSeenChan: TButton;
    Label49: TLabel;
    btUloc: TButton;
    StaticText15: TStaticText;
    btLocUsers: TButton;
    tsLocUsers: TTabSheet;
    btLocUserBack: TButton;
    lbLocUsers: TListBox;
    btNewLocUser: TButton;
    btEditLocUser: TButton;
    btCALocUser: TButton;
    btDelLocUser: TButton;
    Label50: TLabel;
    tsMisc: TTabSheet;
    cbSayToChanAdmins: TCheckBox;
    Label51: TLabel;
    cbAutoopIdent: TCheckBox;
    cbAutoopJoin: TCheckBox;
    Label52: TLabel;
    Label53: TLabel;
    cbConfirmExit: TCheckBox;
    cbConfirmReboot: TCheckBox;
    tsAliases: TTabSheet;
    Label54: TLabel;
    Label55: TLabel;
    cbAlCom: TComboBox;
    Label56: TLabel;
    meAliases: TMemo;
    Label57: TLabel;
    Label58: TLabel;
    btAliases: TButton;
    tsPhRe: TTabSheet;
    lbPhrase: TListBox;
    Label59: TLabel;
    btAddPhraseChan: TButton;
    btDelPhraseChan: TButton;
    btEditPhrases: TButton;
    gbTD: TGroupBox;
    lbTalkDesc: TStaticText;
    lbTalkFunc: TListBox;
    lbAdminFunc: TListBox;
    gbAdminDesc: TGroupBox;
    lbAdmDesc: TStaticText;
    gbDesc: TGroupBox;
    lbFuncDesc: TStaticText;
    lbDispFunc: TListBox;
    cbDNick: TCheckBox;
    Label25: TLabel;
    Label26: TLabel;
    lbUjoin: TListBox;
    procedure btExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btTrayClick(Sender: TObject);
    procedure GetFromTray(var Msg: TMessage); message $613;
    function init:boolean;
    procedure FormCreate(Sender: TObject);
    procedure edPortKeyPress(Sender: TObject; var Key: Char);
    procedure edWaitTimeKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure BtUNewClick(Sender: TObject);
    procedure BtUEditClick(Sender: TObject);
    procedure BtUDelClick(Sender: TObject);
    procedure btPerformClick(Sender: TObject);
    procedure cbPerfActSelect(Sender: TObject);
    procedure btAddAltServClick(Sender: TObject);
    procedure btEditAltServClick(Sender: TObject);
    procedure btDelAltServClick(Sender: TObject);
    procedure btAddHelloChanClick(Sender: TObject);
    procedure btDelHelloChanClick(Sender: TObject);
    procedure tsUsersShow(Sender: TObject);
    procedure tsPerformShow(Sender: TObject);
    procedure tsAltServersShow(Sender: TObject);
    procedure tsHelloShow(Sender: TObject);
    procedure btConfigHelloBaseClick(Sender: TObject);
    procedure btConfigByeBaseClick(Sender: TObject);
    procedure btAddTalkChanClick(Sender: TObject);
    procedure tsTalkShow(Sender: TObject);
    procedure btDelTalkChanClick(Sender: TObject);
    procedure btConfigTalkClick(Sender: TObject);
    procedure tsDialogueShow(Sender: TObject);
    procedure btAddDialogChanClick(Sender: TObject);
    procedure btDelDialogChanClick(Sender: TObject);
    procedure btConfigDialogueClick(Sender: TObject);
    procedure btAddDialogNickClick(Sender: TObject);
    procedure btDelDialogNickClick(Sender: TObject);
    procedure edTalkFreqClick(Sender: TObject);
    procedure tsIjoinShow(Sender: TObject);
    procedure btSaveIjoinClick(Sender: TObject);
    procedure btConfigUjoinClick(Sender: TObject);
    procedure cbAntiFloodClick(Sender: TObject);
    procedure cbAntiFloodTimeoutChange(Sender: TObject);
    procedure tsClientHide(Sender: TObject);
    procedure tsCTCPHide(Sender: TObject);
    procedure tsLogHide(Sender: TObject);
    procedure tsConnectHide(Sender: TObject);
    procedure tsIRCHide(Sender: TObject);
    procedure tsMainHide(Sender: TObject);
    procedure btReloadClick(Sender: TObject);
    procedure btAddBadwChanClick(Sender: TObject);
    procedure btDelBadwChanClick(Sender: TObject);
    procedure tsBadwShow(Sender: TObject);
    procedure cbBadwKindChange(Sender: TObject);
    procedure btAddBadwClick(Sender: TObject);
    procedure btDelBadwClick(Sender: TObject);
    procedure tsSeenShow(Sender: TObject);
    procedure btAddSeenChanClick(Sender: TObject);
    procedure btDelSeenChanClick(Sender: TObject);
    procedure btUlocClick(Sender: TObject);
    procedure btLocUsersClick(Sender: TObject);
    procedure btLocUserBackClick(Sender: TObject);
    procedure btNewLocUserClick(Sender: TObject);
    procedure tsLocUsersShow(Sender: TObject);
    procedure btEditLocUserClick(Sender: TObject);
    procedure btDelLocUserClick(Sender: TObject);
    procedure btCALocUserClick(Sender: TObject);
    procedure cbSayToChanAdminsClick(Sender: TObject);
    procedure cbAutoopIdentClick(Sender: TObject);
    procedure cbAutoopJoinClick(Sender: TObject);
    procedure cbConfirmExitClick(Sender: TObject);
    procedure cbConfirmRebootClick(Sender: TObject);
    procedure btAliasesClick(Sender: TObject);
    procedure tsAliasesShow(Sender: TObject);
    procedure cbAlComChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tsPhReShow(Sender: TObject);
    procedure btAddPhraseChanClick(Sender: TObject);
    procedure btDelPhraseChanClick(Sender: TObject);
    procedure btEditPhrasesClick(Sender: TObject);
    procedure lbTalkFuncClick(Sender: TObject);
    procedure lbTalkFuncDblClick(Sender: TObject);
    procedure lbAdminFuncClick(Sender: TObject);
    procedure lbAdminFuncDblClick(Sender: TObject);
    procedure lbDispFuncClick(Sender: TObject);
    procedure lbDispFuncDblClick(Sender: TObject);
    procedure cbDNickClick(Sender: TObject);
    procedure tsUjoinShow(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
  public
    lastalcom: string;
    procedure Minimize(var Message_: TMessage); message WM_SYSCOMMAND;
    procedure modifyicon;
    procedure checkupdates(info: string);
  end;

var
  MainForm: TMainForm;
  nid: TNotifyIconData;
  botupdater: TUpdater;

implementation
uses mgr;

{$R *.dfm}

function TMainForm.init;
var ilog: TextFile;
    i,k: cardinal;
    conf, tconf: TProIni;
    aliases,list: TStringList;
    s: string;
    addit,found,isok: boolean;
begin
  result:=true;
  nid.cbSize:=sizeof(nid);
  nid.Wnd:=MainForm.Handle;
  nid.uID:=$13;
  nid.uFlags:=NIF_ICON + NIF_MESSAGE + NIF_TIP;
  nid.uCallbackMessage:=$613;
  nid.hIcon:=Application.Icon.Handle;
  nid.szTip:='fbot';
  Label19.Caption:='Версия: '+version;
  if not(DirectoryExists(ExtractFilePath(Application.ExeName)+'logs')) then
    ForceDirectories(ExtractFilePath(Application.ExeName)+'logs');
  AssignFile(ilog,ExtractFilePath(Application.ExeName)+'logs\init.log');
  rewrite(ilog);
  writeln(ilog,'Инициализация бота..');

  try
  writeln(ilog,'Создание внутренних структур..');
  global:=TGlobal.Create;
  global.dir:=ExtractFilePath(Application.ExeName);
  global.connect_time:=0;
  global.network:='';
  sock:=TMsgManager.Create(Application);
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  settings:=TSettings.Create;
  accesslist:=TAccessList.Create(global.dir+'conf\chanaccess.conf');
  addresslist:=TAddresslist.Create;
  channel:=TChannelManager.Create;
  timer:=TTimerManager.Create;
  lists:=TGlobalLists.Create;
  isok:=true;
  try
    lists.badwords.LoadFromFile(global.dir+'main\badwords.txt');
  except end;
  spooler:=TSpoolersManager.Create;
  seim:=TSeimManager.Create;
  writeln(ilog,'Внутренние структуры созданы..');
  writeln(ilog,'Загрузка командных алиасов..');
  alias:=TAliasManager.Create;
  aliases:=TStringList.Create;
  list:=TStringList.Create;
  try
    aliases.LoadFromFile(global.dir+'conf\aliases.conf');
    addit:=false;
    for i:=0 to aliases.Count - 1 do
      begin
        aliases[i]:=AnsiLowerCase(aliases[i]);
        s:=aliases[i];
        if s = '' then continue;
        if (s[1] = '[')and(s[length(s)] = ']') then
          begin
            if not(alias.validcommand(copy(s,2,length(s)-2))) then
              begin
                writeln(ilog,'aliases.conf [warning]: неизвестная команда: '+copy(s,2,length(s)-2));
                continue;
              end;
            if addit then
              alias.Add(list);
            list.Clear;
            list.Add(copy(s,2,length(s)-2));
            addit:=true;
          end
        else
          begin
            if s[1] <> '!' then
              begin
                writeln(ilog,'aliases.conf [warning]: алиас '+s+' должен начинаться с !');
                continue;
              end;
            if alias.validcommand(s) then
              begin
                writeln(ilog,'aliases.conf [warning]: алиас '+s+' совпадает с имеющейся командой');
                continue;
              end;
            if pos(' ',s) <> 0 then
              begin
                writeln(ilog,'aliases.conf [warning]: '''+s+''' - в алиасе не может быть пробелов');
                continue;
              end;
            found:=false;
            if i > 0 then
              begin
                for k:=0 to i-1 do
                  if aliases[k] = s then
                    begin
                      writeln(ilog,'aliases.conf [warning]: совпадение алиасов: '+s);
                      found:=true;
                      break;
                    end;
                if found then continue;
              end;
            list.Add(s);
          end;
      end;
    if addit then
      alias.Add(list);
  except
    try aliases.Free; except end;
    try list.Free; except end;
    writeln(ilog,'Ошибка загрузки алиасов..');
    isok:=false;
  end;
  if isok then
    begin
      writeln(ilog,'Алиасы загружены..');
      aliases.Free;
      list.Free;
    end;
  try
    if FileExists(global.dir+'main\badwords-warnings.dat') then
      DeleteFile(global.dir+'main\badwords-warnings.dat');
  except end;
  if not(FileExists(global.dir+'conf\fbot.conf')) then
    begin
      writeln(ilog,'Файл конфигурации не найден.');
      result:=false;
    end;

  settings.mhost:=conf.ReadString('server','host','');
  settings.mport:=conf.ReadInteger('server','port',0);
  settings.mservpass:=conf.ReadString('server','pass','');
  settings.nick:=conf.ReadString('bot','nick','');
  settings.user:=conf.ReadString('bot','user','');
  settings.realname:=conf.ReadString('bot','realname','');
  settings.altnick:=conf.ReadString('bot','altnick',settings.nick+'_');
  settings.chanlog:=conf.ReadBool('log','chan',false);
  settings.querylog:=conf.ReadBool('log','query',false);
  settings.outlog:=conf.ReadBool('log','out',false);
  settings.ctcp_ping:=conf.ReadBool('CTCP','ping_answer',true);
  settings.ctcp_time:=conf.ReadBool('CTCP','time_answer',true);
  settings.totrayonstart:=conf.ReadBool('client','to_tray_on_start',false);
  i:=conf.ReadInteger('connect','waittime',3000);
  settings.altservers:=conf.ReadBool('connect','altservers',false);
  settings.timestamplog:=conf.ReadBool('log','timestamp',true);
  settings.splitlog:=conf.ReadInteger('log','split',0);
  settings.logstyle:=conf.ReadInteger('log','style',0);
  settings.umode_b:=conf.ReadBool('bot','umode_B',true);
  settings.umode_i:=conf.ReadBool('bot','umode_i',true);
  settings.umode_x:=conf.ReadBool('bot','umode_x',true);
  settings.qmsg:=conf.ReadString('irc','qmsg','');
  settings.kmsg:=conf.ReadString('irc','kmsg','');
  settings.nsnick:=conf.ReadString('irc','ns_nick','');
  settings.nspass:=conf.ReadString('irc','ns_pass','');
  settings.nsidnotice:=conf.ReadString('irc','ns_ident_notice','');
  settings.rejoinonkick:=conf.ReadBool('irc','rejoin_on_kick',true);
  settings.rejoinonconnect:=conf.ReadBool('irc','rejoin_on_connect',true);
  settings.extrasecure:=conf.ReadBool('irc','extra_secure',false);
  settings.kickonban:=conf.ReadBool('irc','kick_on_ban',true);
  settings.check4updates:=conf.ReadBool('client','check4updates',false);
  settings.minimizetotray:=conf.ReadBool('client','minimize_to_tray',true);
  settings.say4chanadmin:=conf.ReadBool('misc','say4chanadmins',true);
  tconf:=TProIni.Create(global.dir+'conf\talk.conf');
  settings.talkantiflood:=tconf.ReadBool('anti-flood','enable',false);
  settings.talktimeout:=tconf.ReadInteger('anti-flood','timeout',2);
  tconf.Free;
  settings.autooponident:=conf.ReadBool('misc','autoop_on_ident',true);
  settings.autooponjoin:=conf.ReadBool('misc','autoop_on_join',true);
  settings.confirmexit:=conf.ReadBool('misc','confirm_exit',false);
  settings.confirmreboot:=conf.ReadBool('misc','confirm_reboot',false);
  settings.addtalknick:=conf.ReadBool('misc','addtalknick',true);

  if FileExists(global.dir+'conf\fbot.conf') then
  begin
    if settings.nick = '' then
      begin
        writeln(ilog,'Ошибка конфигурации: не введен ник бота');
        result:=false;
      end;
    if settings.mhost = '' then
      begin
        writeln(ilog,'Ошибка конфигурации: не введен хост');
        result:=false;
      end;
    if settings.user = '' then
      begin
        writeln(ilog,'Ошибка конфигурации: не введен user бота');
        result:=false;
      end;
    sock.InitIdentd(settings.user);
    if settings.realname = '' then
      begin
        writeln(ilog,'Ошибка конфигурации: не введен realname бота');
        result:=false;
      end;
    if (settings.mport < 1)or(settings.mport > 65536) then
      begin
        settings.mport:=6667;
        writeln(ilog,'Внимание: в конфигурации введен недопустимый порт.')
      end;
    if i > 3600000 then
      begin
        writeln(ilog,'Внимание: время ожидания между попытками '+
          'соединения слишком велико. Используется 3000мс.');
        i:=3000
      end;
    if i < 1000 then
      begin
        writeln(ilog,'Внимание: время ожидания между попытками '+
          'соединения слишком мало. Используется 3000мс.');
         i:=3000
      end;
    sock.CTimer.Interval:=i;
    if (settings.splitlog < 0)or(settings.splitlog > 2) then
      begin
        writeln(ilog,'Внимание: неверно указан способ разбиения логов. Разбиение'+
          ' отключено.');
        settings.splitlog:=0
      end;
    if (settings.logstyle < 0)or(settings.logstyle > 1) then
      begin
        writeln(ilog,'Внимание: неверно указан стиль логов. Выбран стиль mIRC');
        settings.logstyle:=0
      end;
  end;
  if result then writeln(ilog,'Настройки успешно считаны..');

  if not(FileExists(global.dir+'conf\users.conf')) then
    begin
      writeln(ilog,'Ошибка: файл аккаунтов пользователей conf\users.conf не найден.');
      result:=false;
    end;
  if (settings.nspass = '')or(settings.nsidnotice = '') then settings.nsnick:='';
  if settings.altnick = '' then settings.altnick:=settings.nick+'_';

  edHost.Text:=settings.mhost;
  edPass.Text:=settings.mservpass;
  edPort.Text:=inttostr(settings.mport);
  edNick.Text:=settings.nick;
  edUser.Text:=settings.user;
  edReal.Text:=settings.realname;
  edAltNick.Text:=settings.altnick;
  edWaitTime.Text:=inttostr(i);
  if settings.chanlog then cbChan.Checked:=true;
  if settings.querylog then cbQuery.Checked:=true;
  if settings.outlog then cbOut.Checked:=true;
  if settings.ctcp_ping then cbCTCPPing.Checked:=true;
  if settings.ctcp_time then cbCTCPTime.Checked:=true;
  if settings.totrayonstart then cbTray.Checked:=true;
  if settings.altservers then cbAltServ.Checked:=true;
  if settings.timestamplog then cbTmStamp.Checked:=true;
  cboxLogSplit.ItemIndex:=settings.splitlog;
  cboxLogStyle.ItemIndex:=settings.logstyle;
  cbb.Checked:=settings.umode_b;
  cbi.Checked:=settings.umode_i;
  cbx.Checked:=settings.umode_x;
  edQmsg.Text:=settings.qmsg;
  edKmsg.Text:=settings.kmsg;
  edNsNick.Text:=settings.nsnick;
  edNsPass.Text:=settings.nspass;
  edNsIdNotice.Text:=settings.nsidnotice;
  cbIRCOptions.Checked[0]:=settings.rejoinonkick;
  cbIRCOptions.Checked[1]:=settings.rejoinonconnect;
  cbIRCOptions.Checked[2]:=settings.extrasecure;
  cbIRCOptions.Checked[3]:=settings.kickonban;
  cbUpdater.Checked:=settings.check4updates;
  cbMinToTray.Checked:=settings.minimizetotray;
  cbSayToChanAdmins.Checked:=settings.say4chanadmin;
  cbAutoopIdent.Checked:=settings.autooponident;
  cbAutoopJoin.Checked:=settings.autooponjoin;
  cbConfirmExit.Checked:=settings.confirmexit;
  cbConfirmReboot.Checked:=settings.confirmreboot;
  cbDNick.Checked:=settings.addtalknick;
  conf.Free;
  except
    on E:Exception do
      begin
        writeln(ilog,'Ошибка инициализации: '+E.Message);
        result:=false;
      end;
  end;

  if result then writeln(ilog,'Инициализация успешно завершена.');
  CloseFile(ilog);
end; // function TMainForm.init;

procedure TMainForm.btExitClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var ini: TProIni;
    i: cardinal;
begin
  if settings <> nil then
    if settings.confirmexit then
      if MessageDlg('Вы действительно хотите выйти?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
        begin
          action:=caNone;
          exit;
        end;
  pcConf.ActivePageIndex:=18;
  ini:=TProIni.Create(global.dir+'main\uptime.dat');
  i:=ini.ReadInteger('system','uptime',0);
  if uptime > i then
    ini.WriteInteger('system','uptime',uptime);
  ini.Free;
  if sock <> nil then
    begin
      quit;
      sock.Close
    end;
  sock.Free;
  try
    if FileExists(global.dir+'main\joinonconnect.local') then
      DeleteFile(global.dir+'main\joinonconnect.local');
  except end;
  try
    if FileExists(global.dir+'main\badwords-warnings.dat') then
      DeleteFile(global.dir+'main\badwords-warnings.dat');
  except end;
  settings.Free;
  global.Free;
  accesslist.Free;
  addresslist.Free;
  channel.Free;
  timer.Free;
  lists.Free;
  spooler.Free;
  seim.Free;
  alias.Free;
  {$IFDEF DEBUG}
  writedebug('');
  writedebug('=========[ Session closed ]==========');
  writedebug('');
  {$ENDIF}
end;

procedure TMainForm.btTrayClick(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_ADD,@nid);
  ShowWindow(Application.Handle,SW_HIDE);
  ShowWindow(MainForm.Handle,SW_HIDE);
end;

procedure TMainForm.GetFromTray;
begin
  if msg.LParam = WM_LBUTTONUP then
    begin
      ShowWindow(Application.Handle,SW_NORMAL);
      ShowWindow(MainForm.Handle,SW_NORMAL);
      Shell_NotifyIcon(NIM_DELETE,@nid)
    end;
  msg.Result:=0
end;

procedure TMainForm.modifyicon;
begin
  Shell_NotifyIcon(NIM_MODIFY,@nid);
end; // procedure modifyicon;

procedure TMainForm.checkupdates;
begin
  if info = '' then exit;
  if info <> currelease then
    messagedlg('Доступна новая версия бота!'#13#13'Последняя версия: '+info+
    #13'Ваша текущая: '+version+#13#13'Обновление доступно на http://fbot.alsite.ru',
    mtInformation,[mbOk],0);
end; // procedure TMainForm.checkupdates;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not(init) then
    begin
      messagedlg('Подключение не может быть активизировано, так как бот не сконфигурирован.'#13+
      'Подробную информацию Вы можете найти в лог-файле инициализации:'#13+
      global.dir+'logs\init.log'#13+
      'Сконфигурируйте бота и перезагрузите. Если бот сконфигурирован верно, это сообщение не появится.',mtInformation,[mbOk],0);
      Show;
      sock.Inspector.Enabled:=false;
    end
  else
    begin
      Show;
      {$IFDEF DEBUG}
      writedebug('');
      writedebug('=========[ Session started ]==========');
      writedebug('');
      {$ENDIF}
      sock.SockOpen;
      if settings.check4updates then
        begin
          botupdater:=TUpdater.Create(MainForm);
          botupdater.OnGetInfo:=checkupdates;
        end;
    end;
end;

procedure TMainForm.edPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9',#8]) then key:=#0
end;

procedure TMainForm.edWaitTimeKeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9',#8]) then key:=#0
end;

procedure TMainForm.Minimize;
begin
  if (Message_.WParam = SC_MINIMIZE)and(settings.minimizetotray) then btTrayClick(self)
  else inherited;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if settings.totrayonstart then btTrayClick(self)
end;

procedure TMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if TreeView.Selected.Text = 'Конфигурация' then
    begin
      pcConf.ActivePageIndex:=0;
      exit;
    end;
  if TreeView.Selected.Text = 'IRC' then
    begin
      pcConf.ActivePageIndex:=1;
      exit;
    end;
  if TreeView.Selected.Text = 'Подключение' then
    begin
      pcConf.ActivePageIndex:=2;
      exit;
    end;
  if TreeView.Selected.Text = 'Журналы (лог)' then
    begin
      pcConf.ActivePageIndex:=3;
      exit;
    end;
  if TreeView.Selected.Text = 'CTCP' then
    begin
      pcConf.ActivePageIndex:=4;
      exit;
    end;
  if TreeView.Selected.Text = 'Программа' then
    begin
      pcConf.ActivePageIndex:=5;
      exit;
    end;
  if TreeView.Selected.Text = 'Инфо' then
    begin
      pcConf.ActivePageIndex:=6;
      exit;
    end;
  if TreeView.Selected.Text = 'Администрирование' then
    begin
      pcConf.ActivePageIndex:=7;
      exit;
    end;
  if TreeView.Selected.Text = 'Пользователи' then
    begin
      pcConf.ActivePageIndex:=8;
      exit;
    end;
  if TreeView.Selected.Text = 'Автовыполнение' then
    begin
      pcConf.ActivePageIndex:=9;
      exit;
    end;
  if TreeView.Selected.Text = 'Альт. сервера' then
    begin
      pcConf.ActivePageIndex:=10;
      exit;
    end;
  if TreeView.Selected.Text = 'Разговорные функции' then
    begin
      pcConf.ActivePageIndex:=11;
      exit;
    end;
  if TreeView.Selected.Text = 'Приветствия и прощания' then
    begin
      pcConf.ActivePageIndex:=12;
      exit;
    end;
  if TreeView.Selected.Text = 'Разговор' then
    begin
      pcConf.ActivePageIndex:=13;
      exit;
    end;
  if TreeView.Selected.Text = 'Диалог' then
    begin
      pcConf.ActivePageIndex:=14;
      exit;
    end;
  if TreeView.Selected.Text = 'Приветствия бота' then
    begin
      pcConf.ActivePageIndex:=15;
      exit;
    end;
  if TreeView.Selected.Text = 'Персональные приветствия' then
    begin
      pcConf.ActivePageIndex:=16;
      exit;
    end;
  if TreeView.Selected.Text = 'Почтовая служба' then
    begin
      pcConf.ActivePageIndex:=17;
      exit;
    end;
  if TreeView.Selected.Text = 'Функции' then
    begin
      pcConf.ActivePageIndex:=19;
      exit;
    end;
  if TreeView.Selected.Text = 'Антимат' then
    begin
      pcConf.ActivePageIndex:=20;
      exit;
    end;
  if TreeView.Selected.Text = 'seen' then
    begin
      pcConf.ActivePageIndex:=21;
      exit;
    end;
  if TreeView.Selected.Text = 'Разное' then
    begin
      pcConf.ActivePageIndex:=23;
      exit;
    end;
  if TreeView.Selected.Text = 'Алиасы' then
    begin
      pcConf.ActivePageIndex:=24;
      exit;
    end;
  if TreeView.Selected.Text = 'Реакция на фразы' then
    begin
      pcConf.ActivePageIndex:=25;
      exit;
    end;
end;

procedure TMainForm.BtUNewClick(Sender: TObject);
var aform: TAddUserForm;
    data: pAddedUser;
    uconf: TProIni;
begin
  new(data);
  aform:=TAddUserForm.Create(MainForm, data);
  aform.ShowModal;
  if data^.isset then
    begin
      uconf:=TProIni.Create(global.dir+'conf\users.conf');
      uconf.WriteInteger(data^.nick,'access',data^.access);
      uconf.WriteString(data^.nick,'password',data^.pass);
      uconf.Free;
      lbUsers.Items.Add(' '+data^.nick+' ('+accesstostring(data^.access)+')');
    end;
  dispose(data);
end;

procedure TMainForm.BtUEditClick(Sender: TObject);
var aform: TAddUserForm;
    data: pAddedUser;
    uconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbUsers.Items.Count > 0 then
    for i:=0 to lbUsers.Items.Count - 1 do
      if lbUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  new(data);
  uconf:=TProIni.Create(global.dir+'conf\users.conf');
  aform:=TAddUserForm.Create(MainForm, data);
  aform.Caption:='Редактирование аккаунта';
  aform.Edit1.Text:=getuserbyua(lbUsers.Items[selected]);
  aform.Edit1.ReadOnly:=true;
  aform.Edit2.Text:=uconf.ReadString(getuserbyua(lbUsers.Items[selected]),'password','');
  case uconf.ReadInteger(getuserbyua(lbUsers.Items[selected]),'access',-1) of
    ADMIN: aform.ComboBox1.ItemIndex:=0;
    OPERATOR: aform.ComboBox1.ItemIndex:=1;
    USER: aform.ComboBox1.ItemIndex:=2;
    else aform.ComboBox1.ItemIndex:=0;
  end;
  aform.ShowModal;
  if data^.isset then
    begin
      uconf.WriteInteger(data^.nick,'access',data^.access);
      uconf.WriteString(data^.nick,'password',data^.pass);
    end;
  uconf.Free;
  if data^.access = USER then
    lbUsers.Items.Delete(selected);
  dispose(data);
end;

procedure TMainForm.BtUDelClick(Sender: TObject);
var uconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbUsers.Items.Count > 0 then
    for i:=0 to lbUsers.Items.Count - 1 do
      if lbUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  uconf:=TProIni.Create(global.dir+'conf\users.conf');
  uconf.EraseSection(getuserbyua(lbUsers.Items[selected]));
  uconf.Free;
  uconf:=TProIni.Create(accesslist.chanaccessconf);
  uconf.EraseSection(getuserbyua(lbUsers.Items[selected]));
  uconf.Free;
  lbUsers.Items.Delete(selected);
end;

procedure TMainForm.btUlocClick(Sender: TObject);
var i: integer;
    selected: integer;
    caform: TChanAccessForm;
begin
  selected:=-1;
  if lbUsers.Items.Count > 0 then
    for i:=0 to lbUsers.Items.Count - 1 do
      if lbUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  caform:=TChanAccessForm.Create(accesslist.chanaccessconf,getuserbyua(lbUsers.Items[selected]));
  caform.ShowModal;
end;

procedure TMainForm.btPerformClick(Sender: TObject);
begin
  try
    if not(DirectoryExists(global.dir+'conf'))
      then ForceDirectories(global.dir+'conf');
    mePerform.Lines.SaveToFile(global.dir+'conf\perform.conf');
    messagedlg('Изменения успешно сохранены.',mtInformation,[mbOk],0);
  except
    on E:Exception do
      messagedlg('Ошибка сохранения: '+E.Message,mtError,[mbOk],0);
  end;
end;

procedure TMainForm.cbPerfActSelect(Sender: TObject);
var i: byte;
    s,s2: string;
begin
  i:=cbPerfAct.ItemIndex;
  cbPerfAct.ItemIndex:=0;
  case i of
    1:
    begin
      s:=inputrequest('Введите название канала:');
      if s <> '' then mePerform.Lines.Add('JOIN '+validchan(s));
    end;
    2:
    begin
      s:=inputrequest('Введите пароль от ника:');
      if s <> '' then mePerform.Lines.Add('PRIVMSG NickServ :IDENTIFY '+s);
    end;
    3:
    begin
      s:=inputrequest('Введите ник пользователя:');
      s2:=inputrequest('Введите сообщение:');
      if (s <> '')and(s2 <> '') then mePerform.Lines.Add('PRIVMSG '+s+' :'+s2);
    end;
    4:
    begin
      s:=inputrequest('Введите логин:');
      s2:=inputrequest('Введите пароль:');
      if (s <> '')and(s2 <> '') then mePerform.Lines.Add('OPER '+s+' '+s2);
    end;
  end;
end;

procedure TMainForm.btAddAltServClick(Sender: TObject);
var aform: TAddServForm;
    data: pAddedServer;
    sconf: TProIni;
begin
  new(data);
  aform:=TAddServForm.Create(MainForm, data);
  aform.ShowModal;
  if data^.isset then
    begin
      sconf:=TProIni.Create(global.dir+'conf\altservers.conf');
      sconf.WriteString(data^.name,'host',data^.adr);
      if data^.port <> 0 then
        sconf.WriteInteger(data^.name,'port',data^.port);
      if data^.pass <> '' then
        sconf.WriteString(data^.name,'pass',data^.pass);
      sconf.Free;
      lbAltServers.Items.Add(data^.name);
    end;
  dispose(data);
end;

procedure TMainForm.btEditAltServClick(Sender: TObject);
var aform: TAddServForm;
    data: pAddedServer;
    sconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbAltServers.Items.Count > 0 then
    for i:=0 to lbAltServers.Items.Count - 1 do
      if lbAltServers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите сервер!',mtError,[mbOk],0);
      exit
    end;
  new(data);
  sconf:=TProIni.Create(global.dir+'conf\altservers.conf');
  aform:=TAddServForm.Create(MainForm, data);
  aform.Caption:='Редактирование сервера';
  aform.Edit4.Text:=lbAltServers.Items[selected];
  aform.Edit4.ReadOnly:=true;
  aform.Edit1.Text:=sconf.ReadString(lbAltServers.Items[selected],'host','');
  aform.Edit2.Text:=sconf.ReadString(lbAltServers.Items[selected],'port','');
  aform.Edit3.Text:=sconf.ReadString(lbAltServers.Items[selected],'pass','');
  aform.ShowModal;
  if data^.isset then
    begin
      sconf.WriteString(data^.name,'host',data^.adr);
      if data^.port <> 0 then
        sconf.WriteInteger(data^.name,'port',data^.port);
      if data^.pass <> '' then
        sconf.WriteString(data^.name,'pass',data^.pass);
    end;
  sconf.Free;
  dispose(data);
end;

procedure TMainForm.btDelAltServClick(Sender: TObject);
var sconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbAltServers.Items.Count > 0 then
    for i:=0 to lbAltServers.Items.Count - 1 do
      if lbAltServers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите сервер!',mtError,[mbOk],0);
      exit
    end;
  sconf:=TProIni.Create(global.dir+'conf\altservers.conf');
  sconf.EraseSection(lbAltServers.Items[selected]);
  lbAltServers.Items.Delete(selected);
  sconf.Free;
end;

procedure TMainForm.btAddHelloChanClick(Sender: TObject);
var conf: TProIni;
    s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  s:=validchan(s);
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteString('hello',s,'1');
  if lbHelloConf.Items.IndexOf(s) = -1 then lbHelloConf.Items.Add(s);
  conf.Free;
end;

procedure TMainForm.btDelHelloChanClick(Sender: TObject);
var i,selected: integer;
    conf: TProIni;
begin
  selected:=-1;
  if lbHelloConf.Items.Count > 0 then
    for i:=0 to lbHelloConf.Items.Count - 1 do
      if lbHelloConf.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.DeleteKey('hello',lbHelloConf.Items[selected]);
  lbHelloConf.Items.Delete(selected);
  conf.Free;
end;

procedure TMainForm.tsUsersShow(Sender: TObject);
var conf: TProIni;
    list: TStringList;
    i,a: integer;
begin
  tsUsers.Cursor:=crHourGlass;
  for i:=0 to tsUsers.ControlCount - 1 do
    tsUsers.Controls[i].Cursor:=crHourGlass;
  lbUsers.Clear;
  conf:=TProIni.Create(global.dir+'conf\users.conf');
  list:=TStringList.Create;
  conf.ReadSections(list);
  if list.Count > 0 then
    for i:=0 to list.Count - 1 do
      begin
        a:=conf.ReadInteger(list[i],'access',NOUSER);
        if (a = NOUSER)or(a = USER) then continue;
        lbUsers.Items.Add(' '+list[i]+' ('+accesstostring(a)+')');
      end;
  list.Free;
  conf.Free;
  tsUsers.Cursor:=crDefault;
  for i:=0 to tsUsers.ControlCount - 1 do
    tsUsers.Controls[i].Cursor:=crDefault;
end;

procedure TMainForm.tsPerformShow(Sender: TObject);
begin
  try
    mePerform.Lines.LoadFromFile(global.dir+'conf\perform.conf');
  except end;
end;

procedure TMainForm.tsAltServersShow(Sender: TObject);
var conf: TProIni;
    list: TStringList;
    i: integer;
begin
  lbAltServers.Clear;
  conf:=TProIni.Create(global.dir+'conf\altservers.conf');
  list:=TStringList.Create;
  conf.ReadSections(list);
  if list.Count > 0 then
    for i:=0 to list.Count - 1 do
      lbAltServers.Items.Add(list[i]);
  list.Free;
  conf.Free;
end;

procedure TMainForm.tsHelloShow(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.ReadSection('hello',lbHelloConf.Items);
  conf.Free;
end;

procedure TMainForm.btConfigHelloBaseClick(Sender: TObject);
var Edit: TSegFileEdit;
begin
  Edit:=TSegFileEdit.Create(MainForm,global.dir+'talk\hello.txt');
  Edit.ShowModal;
end;

procedure TMainForm.btConfigByeBaseClick(Sender: TObject);
var Edit: TSegFileEdit;
begin
  Edit:=TSegFileEdit.Create(MainForm,global.dir+'talk\bye.txt');
  Edit.ShowModal;
end;

procedure TMainForm.btAddTalkChanClick(Sender: TObject);
var conf: TProIni;
    s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  s:=validchan(s);
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteString('talk',s,'1');
  if lbTalkConf.Items.IndexOf(s) = -1 then lbTalkConf.Items.Add(s);
  conf.Free;
end;

procedure TMainForm.tsTalkShow(Sender: TObject);
var conf: TProIni;
    i: integer;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.ReadSection('talk',lbTalkConf.Items);
  edTalkFreq.Text:=inttostr(conf.ReadInteger('talk_freq','freq',10));
  cbAntiFlood.Checked:=conf.ReadBool('anti-flood','enable',false);
  i:=conf.ReadInteger('anti-flood','timeout',2);
  if (i < 1)or(i > 10) then i:=2;
  cbAntiFloodTimeout.ItemIndex:=i-1;
  conf.Free;
end;

procedure TMainForm.btDelTalkChanClick(Sender: TObject);
var i,selected: integer;
    conf: TProIni;
begin
  selected:=-1;
  if lbTalkConf.Items.Count > 0 then
    for i:=0 to lbTalkConf.Items.Count - 1 do
      if lbTalkConf.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.DeleteKey('talk',lbTalkConf.Items[selected]);
  lbTalkConf.Items.Delete(selected);
  conf.Free;
end;

procedure TMainForm.btConfigTalkClick(Sender: TObject);
var Edit: TSegFileEdit;
begin
  Edit:=TSegFileEdit.Create(MainForm,global.dir+'talk\talk.txt');
  Edit.ShowModal;
end;

procedure TMainForm.tsDialogueShow(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.ReadSection('dialogue_disabled_on',lbDialogueConf.Items);
  conf.ReadSectionValues('dialogue_altnicks',lbDialogNicks.Items);
  conf.Free;
end;

procedure TMainForm.btAddDialogChanClick(Sender: TObject);
var conf: TProIni;
    s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  s:=validchan(s);
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteString('dialogue_disabled_on',s,'1');
  if lbDialogueConf.Items.IndexOf(s) = -1 then lbDialogueConf.Items.Add(s);
  conf.Free;
end;

procedure TMainForm.btDelDialogChanClick(Sender: TObject);
var i,selected: integer;
    conf: TProIni;
begin
  selected:=-1;
  if lbDialogueConf.Items.Count > 0 then
    for i:=0 to lbDialogueConf.Items.Count - 1 do
      if lbDialogueConf.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.DeleteKey('dialogue_disabled_on',lbDialogueConf.Items[selected]);
  lbDialogueConf.Items.Delete(selected);
  conf.Free;
end;

procedure TMainForm.btConfigDialogueClick(Sender: TObject);
var Edit: TDSegFileEdit;
begin
  Edit:=TDSegFileEdit.Create(MainForm,global.dir+'talk\dialogue.txt');
  Edit.ShowModal;
end;

procedure TMainForm.btAddDialogNickClick(Sender: TObject);
var conf: TProIni;
    s: string;
    i: integer;
begin
  s:=inputrequest('Введите альтернативный ник');
  if s = '' then exit;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  if lbDialogNicks.Items.IndexOf(s) = -1 then lbDialogNicks.Items.Add(s);
  conf.EraseSection('dialogue_altnicks');
  for i:=0 to lbDialogNicks.Items.Count - 1 do
    conf.WriteString('dialogue_altnicks',inttostr(i+1),lbDialogNicks.Items[i]);
  conf.Free;
end;

procedure TMainForm.btDelDialogNickClick(Sender: TObject);
var i,selected: integer;
    conf: TProIni;
begin
  selected:=-1;
  if lbDialogNicks.Items.Count > 0 then
    for i:=0 to lbDialogNicks.Items.Count - 1 do
      if lbDialogNicks.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите ник!',mtError,[mbOk],0);
      exit
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.EraseSection('dialogue_altnicks');
  lbDialogNicks.Items.Delete(selected);
  if lbDialogNicks.Items.Count > 0 then
    for i:=0 to lbDialogNicks.Items.Count - 1 do
      conf.WriteString('dialogue_altnicks',inttostr(i+1),lbDialogNicks.Items[i]);
  conf.Free;
end;

procedure TMainForm.edTalkFreqClick(Sender: TObject);
var s: string;
    i: integer;
    conf: TProIni;
begin
  s:=inputrequest('Введите частоту разговора');
  if s = '' then exit;
  try
    i:=strtoint(s);
  except
    messagedlg('Ошибка: недопустимая частота!',mtError,[mbOk],0);
    exit;
  end;
  if i < 1 then
    begin
      messagedlg('Ошибка: недопустимая частота!',mtError,[mbOk],0);
      exit;
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteInteger('talk_freq','freq',i);
  edTalkFreq.Text:=s;
  conf.Free;
end;

procedure TMainForm.tsIjoinShow(Sender: TObject);
begin
  try
    meIjoin.Lines.LoadFromFile(global.dir+'main\ijoin.txt');
  except end;
end;

procedure TMainForm.btSaveIjoinClick(Sender: TObject);
begin
  try
    if not(DirectoryExists(global.dir+'main'))
      then ForceDirectories(global.dir+'main');
    meIjoin.Lines.SaveToFile(global.dir+'main\ijoin.txt');
    messagedlg('Изменения успешно сохранены.',mtInformation,[mbOk],0);
  except
    on E:Exception do
      messagedlg('Ошибка сохранения: '+E.Message,mtError,[mbOk],0);
  end;
end;

procedure TMainForm.btConfigUjoinClick(Sender: TObject);
var Edit: TSegFileEdit;
begin
  Edit:=TSegFileEdit.Create(MainForm,global.dir+'main\ujoin.txt');
  Edit.ShowModal;
end;

procedure TMainForm.cbAntiFloodClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteBool('anti-flood','enable',cbAntiFlood.Checked);
  conf.Free;
  settings.talkantiflood:=cbAntiFlood.Checked;
end;

procedure TMainForm.cbAntiFloodTimeoutChange(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteInteger('anti-flood','timeout',cbAntiFloodTimeout.ItemIndex+1);
  conf.Free;
  settings.talktimeout:=cbAntiFloodTimeout.ItemIndex+1;
end;

procedure TMainForm.tsClientHide(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('client','to_tray_on_start',cbTray.Checked);
  conf.WriteBool('client','check4updates',cbUpdater.Checked);
  conf.WriteBool('client','minimize_to_tray',cbMinToTray.Checked);
  conf.Free;
  settings.totrayonstart:=cbTray.Checked;
  settings.check4updates:=cbUpdater.Checked;
  settings.minimizetotray:=cbMinToTray.Checked;
end;

procedure TMainForm.tsCTCPHide(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('CTCP','ping_answer',cbCTCPPing.Checked);
  conf.WriteBool('CTCP','time_answer',cbCTCPTime.Checked);
  conf.Free;
  settings.ctcp_ping:=cbCTCPPing.Checked;
  settings.ctcp_time:=cbCTCPTime.Checked;
end;

procedure TMainForm.tsLogHide(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('log','chan',cbChan.Checked);
  conf.WriteBool('log','query',cbQuery.Checked);
  conf.WriteBool('log','out',cbOut.Checked);
  conf.WriteBool('log','timestamp',cbTmStamp.Checked);
  conf.WriteInteger('log','split',cboxLogSplit.ItemIndex);
  conf.WriteInteger('log','style',cboxLogStyle.ItemIndex);
  conf.Free;
  settings.chanlog:=cbChan.Checked;
  settings.querylog:=cbQuery.Checked;
  settings.outlog:=cbOut.Checked;
  settings.timestamplog:=cbTmStamp.Checked;
  settings.logstyle:=cboxLogStyle.ItemIndex;
  settings.splitlog:=cboxLogSplit.ItemIndex;
end;

procedure TMainForm.tsConnectHide(Sender: TObject);
var conf: TProIni;
    i: integer;
begin
  try
    i:=strtoint(edWaitTime.Text);
  except
    i:=3000;
  end;
  if (i > 3600000)or(i < 1000) then i:=3000;
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteInteger('connect','waittime',i);
  conf.WriteBool('connect','altservers',cbAltServ.Checked);
  conf.Free;
  edWaitTime.Text:=inttostr(i);
  settings.altservers:=cbAltServ.Checked;
  sock.CTimer.Interval:=i;
end;

procedure TMainForm.tsIRCHide(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteString('irc','qmsg',edQmsg.Text);
  conf.WriteString('irc','kmsg',edkmsg.Text);
  conf.WriteString('irc','ns_nick',edNsNick.Text);
  conf.WriteString('irc','ns_pass',edNsPass.Text);
  conf.WriteString('irc','ns_ident_notice',edNsIdNotice.Text);
  conf.WriteBool('irc','rejoin_on_kick',cbIRCOptions.Checked[0]);
  conf.WriteBool('irc','rejoin_on_connect',cbIRCOptions.Checked[1]);
  conf.WriteBool('irc','extra_secure',cbIRCOptions.Checked[2]);
  conf.WriteBool('irc','kick_on_ban',cbIRCOptions.Checked[3]);
  conf.Free;
  settings.qmsg:=edQmsg.Text;
  settings.kmsg:=edkmsg.Text;
  settings.nsnick:=edNsNick.Text;
  settings.nspass:=edNsPass.Text;
  settings.nsidnotice:=edNsIdNotice.Text;
  settings.rejoinonkick:=cbIRCOptions.Checked[0];
  settings.rejoinonconnect:=cbIRCOptions.Checked[1];
  settings.extrasecure:=cbIRCOptions.Checked[2];
end;

procedure TMainForm.tsMainHide(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  if edHost.Text <> '' then conf.WriteString('server','host',edHost.Text);
  if edPort.Text <> '' then conf.WriteInteger('server','port',strtoint(edPort.Text));
  if edPass.Text <> '' then conf.WriteString('server','pass',edPass.Text);
  if edNick.Text <> '' then conf.WriteString('bot','nick',edNick.Text);
  if edUser.Text <> '' then conf.WriteString('bot','user',edUser.Text);
  if edReal.Text <> '' then conf.WriteString('bot','realname',edReal.Text);
  conf.WriteString('bot','altnick',edAltNick.Text);
  conf.WriteBool('bot','umode_B',cbb.Checked);
  conf.WriteBool('bot','umode_i',cbi.Checked);
  conf.WriteBool('bot','umode_x',cbx.Checked);
  conf.Free;
  settings.umode_b:=cbb.Checked;
  settings.umode_i:=cbi.Checked;
  settings.umode_x:=cbx.Checked;
end;

procedure TMainForm.btReloadClick(Sender: TObject);
begin
  if settings.confirmreboot then
    if MessageDlg('Перезагрузить бота?',mtConfirmation,[mbYes,mbNo],0) = mrNo then exit;
  settings.confirmexit:=false;
  Close;
  WinExec(PChar(application.exename),SW_SHOW);
end;

procedure TMainForm.btAddBadwChanClick(Sender: TObject);
var s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  chgfuncstate(s,FBADWORDS,true);
  if lbBadwConf.Items.IndexOf(s) = -1 then lbBadwConf.Items.Add(s);
end;

procedure TMainForm.btDelBadwChanClick(Sender: TObject);
var i,selected: integer;
begin
  selected:=-1;
  if lbBadwConf.Items.Count > 0 then
    for i:=0 to lbBadwConf.Items.Count - 1 do
      if lbBadwConf.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit
    end;
  chgfuncstate(lbBadwConf.Items[selected],FBADWORDS,false);
  lbBadwConf.Items.Delete(selected);
end;

procedure TMainForm.tsBadwShow(Sender: TObject);
var conf: TProIni;
    s: string;
begin
  conf:=TProIni.Create(global.dir+'conf\badwords.conf');
  conf.ReadSection('enabled_on',lbBadwConf.Items);
  s:=conf.ReadString('action','action','kick');
  if lowercase(s) = 'kick' then
    begin
      cbBadwKind.ItemIndex:=0;
      lbBadwComment.Caption:='кик';
    end;
  if lowercase(s) = 'kickban' then
    begin
      cbBadwKind.ItemIndex:=1;
      lbBadwComment.Caption:='кик с баном';
    end;
  if lowercase(s) = 'kick-kickban' then
    begin
      cbBadwKind.ItemIndex:=2;
      lbBadwComment.Caption:='кик, в случае повторения - кикбан';
    end;
  conf.Free;
  lbBadwords.Items.Assign(lists.badwords);
end;

procedure TMainForm.cbBadwKindChange(Sender: TObject);
var ini: TProIni;
begin
  ini:=TProIni.Create(global.dir+'conf\badwords.conf');
  case cbBadwKind.ItemIndex of
    0: begin
         ini.WriteString('action','action','kick');
         lbBadwComment.Caption:='кик';
       end;
    1: begin
         ini.WriteString('action','action','kickban');
         lbBadwComment.Caption:='кик с баном';
       end;
    2: begin
         ini.WriteString('action','action','kick-kickban');
         lbBadwComment.Caption:='кик, в случае повторения - кикбан';
       end;
  end;
  ini.Free;
end;

procedure TMainForm.btAddBadwClick(Sender: TObject);
var bf: TextFile;
    s: string;
begin
  s:=phraserequest(addMAT);
  if s = '' then exit;
  try
    if not(DirectoryExists(global.dir+'main'))
      then ForceDirectories(global.dir+'main');
    AssignFile(bf,global.dir+'main\badwords.txt');
    if FileExists(global.dir+'main\badwords.txt') then
      append(bf)
    else
      rewrite(bf);
    writeln(bf,s);
    CloseFile(bf);
    lists.badwords.Add(s);
    lbBadwords.Items.Add(s);
  except
    messagedlg('Ошибка добавления блокируемого слова',mtError,[mbOk],0);
  end;
end;

procedure TMainForm.btDelBadwClick(Sender: TObject);
var i,selected: integer;
begin
  selected:=-1;
  if lbBadwords.Items.Count > 0 then
    for i:=0 to lbBadwords.Items.Count - 1 do
      if lbBadwords.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите фразу',mtError,[mbOk],0);
      exit
    end;
  delstringfromfile(global.dir+'main\badwords.txt',lbBadwords.Items[selected]);
  i:=lists.badwords.IndexOf(lbBadwords.Items[selected]);
    if i <> -1 then lists.badwords.Delete(i);
  lbBadwords.Items.Delete(selected);
end;

procedure TMainForm.tsSeenShow(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\seen.conf');
  conf.ReadSection('disabled_on',lbSeenConf.Items);
  conf.Free;
end;

procedure TMainForm.btAddSeenChanClick(Sender: TObject);
var s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  chgfuncstate(s,FSEEN,false);
  if lbSeenConf.Items.IndexOf(s) = -1 then lbSeenConf.Items.Add(s);
end;

procedure TMainForm.btDelSeenChanClick(Sender: TObject);
var i,selected: integer;
begin
  selected:=-1;
  if lbSeenConf.Items.Count > 0 then
    for i:=0 to lbSeenConf.Items.Count - 1 do
      if lbSeenConf.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit;
    end;
  chgfuncstate(lbSeenConf.Items[selected],FSEEN,true);
  lbSeenConf.Items.Delete(selected);
end;

procedure TMainForm.btLocUsersClick(Sender: TObject);
begin
  pcConf.ActivePageIndex:=22;
end;

procedure TMainForm.btLocUserBackClick(Sender: TObject);
begin
  pcConf.ActivePageIndex:=8;
end;

procedure TMainForm.btNewLocUserClick(Sender: TObject);
var aform: TAddUserForm;
    data: pAddedUser;
    uconf: TProIni;
begin
  new(data);
  aform:=TAddUserForm.Create(MainForm, data);
  aform.ComboBox1.ItemIndex:=2;
  aform.ComboBox1.Enabled:=false;
  aform.ShowModal;
  if data^.isset then
    begin
      uconf:=TProIni.Create(global.dir+'conf\users.conf');
      uconf.WriteInteger(data^.nick,'access',USER);
      uconf.WriteString(data^.nick,'password',data^.pass);
      uconf.Free;
      lbLocUsers.Items.Add(data^.nick);
    end;
  dispose(data);
end;

procedure TMainForm.tsLocUsersShow(Sender: TObject);
var conf: TProIni;
    list: TStringList;
    i,a: integer;
begin
  tsLocUsers.Cursor:=crHourGlass;
  for i:=0 to tsLocUsers.ControlCount - 1 do
    tsLocUsers.Controls[i].Cursor:=crHourGlass;
  lbLocUsers.Clear;
  conf:=TProIni.Create(global.dir+'conf\users.conf');
  list:=TStringList.Create;
  conf.ReadSections(list);
  if list.Count > 0 then
    for i:=0 to list.Count - 1 do
      begin
        a:=conf.ReadInteger(list[i],'access',NOUSER);
        if a = USER then
          lbLocUsers.Items.Add(list[i]);
      end;
  list.Free;
  conf.Free;
  tsLocUsers.Cursor:=crDefault;
  for i:=0 to tsLocUsers.ControlCount - 1 do
    tsLocUsers.Controls[i].Cursor:=crDefault;
end;

procedure TMainForm.btEditLocUserClick(Sender: TObject);
var aform: TAddUserForm;
    data: pAddedUser;
    uconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbLocUsers.Items.Count > 0 then
    for i:=0 to lbLocUsers.Items.Count - 1 do
      if lbLocUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  new(data);
  uconf:=TProIni.Create(global.dir+'conf\users.conf');
  aform:=TAddUserForm.Create(MainForm,data);
  aform.Caption:='Редактирование аккаунта';
  aform.Edit1.Text:=lbLocUsers.Items[selected];
  aform.Edit1.ReadOnly:=true;
  aform.Edit2.Text:=uconf.ReadString(lbLocUsers.Items[selected],'password','');
  case uconf.ReadInteger(lbLocUsers.Items[selected],'access',-1) of
    ADMIN: aform.ComboBox1.ItemIndex:=0;
    OPERATOR: aform.ComboBox1.ItemIndex:=1;
    USER: aform.ComboBox1.ItemIndex:=2;
    else aform.ComboBox1.ItemIndex:=0;
  end;
  aform.ShowModal;
  if data^.isset then
    begin
      uconf.WriteInteger(data^.nick,'access',data^.access);
      uconf.WriteString(data^.nick,'password',data^.pass);
      if data^.access <> USER then
        lbLocUsers.Items.Delete(selected);
    end;
  uconf.Free;
  dispose(data);
end;

procedure TMainForm.btDelLocUserClick(Sender: TObject);
var uconf: TProIni;
    i: integer;
    selected: integer;
begin
  selected:=-1;
  if lbLocUsers.Items.Count > 0 then
    for i:=0 to lbLocUsers.Items.Count - 1 do
      if lbLocUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  uconf:=TProIni.Create(global.dir+'conf\users.conf');
  uconf.EraseSection(lbLocUsers.Items[selected]);
  uconf.Free;
  uconf:=TProIni.Create(accesslist.chanaccessconf);
  uconf.EraseSection(lbLocUsers.Items[selected]);
  uconf.Free;
  lbLocUsers.Items.Delete(selected);
end;

procedure TMainForm.btCALocUserClick(Sender: TObject);
var i: integer;
    selected: integer;
    caform: TChanAccessForm;
begin
  selected:=-1;
  if lbLocUsers.Items.Count > 0 then
    for i:=0 to lbLocUsers.Items.Count - 1 do
      if lbLocUsers.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите пользователя!',mtError,[mbOk],0);
      exit
    end;
  caform:=TChanAccessForm.Create(accesslist.chanaccessconf,lbLocUsers.Items[selected]);
  caform.ShowModal;
end;

procedure TMainForm.cbSayToChanAdminsClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','say4chanadmins',cbSayToChanAdmins.Checked);
  conf.Free;
  settings.say4chanadmin:=cbSayToChanAdmins.Checked;
end;

procedure TMainForm.cbAutoopIdentClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','autoop_on_ident',cbAutoopIdent.Checked);
  conf.Free;
  settings.autooponident:=cbAutoopIdent.Checked;
end;

procedure TMainForm.cbAutoopJoinClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','autoop_on_join',cbAutoopJoin.Checked);
  conf.Free;
  settings.autooponjoin:=cbAutoopJoin.Checked;
end;

procedure TMainForm.cbConfirmExitClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','confirm_exit',cbConfirmExit.Checked);
  conf.Free;
  settings.confirmexit:=cbConfirmExit.Checked;
end;

procedure TMainForm.cbConfirmRebootClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','confirm_reboot',cbConfirmReboot.Checked);
  conf.Free;
  settings.confirmreboot:=cbConfirmReboot.Checked;
end;

procedure TMainForm.btAliasesClick(Sender: TObject);
begin
  WinExec(PChar('notepad '+global.dir+'conf\aliases.conf'),SW_NORMAL);
end;

procedure TMainForm.tsAliasesShow(Sender: TObject);
var al: TSegFile;
begin
  al:=TSegFile.Create(global.dir+'conf\aliases.conf');
  al.ReadSection(cbAlCom.Items[cbAlCom.itemindex],meAliases.Lines);
  al.Free;
  lastalcom:=cbAlCom.Items[cbAlCom.itemindex];
end;

procedure TMainForm.cbAlComChange(Sender: TObject);
var al: TSegFile;
    i: integer;
begin
  al:=TSegFile.Create(global.dir+'conf\aliases.conf');
  al.DelSection(lastalcom);
  if meAliases.Lines.Count > 0 then
    for i:=meAliases.Lines.Count - 1 downto 0 do
      al.AddString(lastalcom,meAliases.Lines[i]);
  al.ReadSection(cbAlCom.Items[cbAlCom.itemindex],meAliases.Lines);
  al.Free;
  lastalcom:=cbAlCom.Items[cbAlCom.itemindex];
end;

procedure TMainForm.Button1Click(Sender: TObject);
var Edit: TDSegFileEdit;
begin
  Edit:=TDSegFileEdit.Create(MainForm,global.dir+'talk\dialogue.txt');
  Edit.ShowModal;
end;

procedure TMainForm.tsPhReShow(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.ReadSection('phrasereaction',lbPhrase.Items);
  conf.Free;
end;

procedure TMainForm.btAddPhraseChanClick(Sender: TObject);
var conf: TProIni;
    s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  s:=validchan(s);
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.WriteString('phrasereaction',s,'1');
  if lbPhrase.Items.IndexOf(s) = -1 then lbPhrase.Items.Add(s);
  conf.Free;
end;

procedure TMainForm.btDelPhraseChanClick(Sender: TObject);
var i,selected: integer;
    conf: TProIni;
begin
  selected:=-1;
  if lbPhrase.Items.Count > 0 then
    for i:=0 to lbPhrase.Items.Count - 1 do
      if lbPhrase.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите канал!',mtError,[mbOk],0);
      exit
    end;
  conf:=TProIni.Create(global.dir+'conf\talk.conf');
  conf.DeleteKey('phrasereaction',lbPhrase.Items[selected]);
  lbPhrase.Items.Delete(selected);
  conf.Free;
end;

procedure TMainForm.btEditPhrasesClick(Sender: TObject);
var Edit: TDSegFileEdit;
begin
  Edit:=TDSegFileEdit.Create(MainForm,global.dir+'talk\dialogue.txt');
  Edit.ShowModal;
end;

procedure TMainForm.lbTalkFuncClick(Sender: TObject);
begin
  case lbTalkFunc.ItemIndex of
    0: lbTalkDesc.Caption:='Настройка фраз, которые бот говорит всем пользователям при входе на канал, и которыми он прощается с пользователями';
    1: lbTalkDesc.Caption:='Фразы, которые бот говорит на канал, поддерживая разговор';
    2: lbTalkDesc.Caption:='Фразы, которые бот говорит в ответ на упоминание своего ника или его синонима';
    3: lbTalkDesc.Caption:='Фразы, одну из которых говорит бот, войдя на канал';
    4: lbTalkDesc.Caption:='Персональные приветствия для отдельных пользователей';
    5: lbTalkDesc.Caption:='Реакция в ответ на определенные фразы, сказанные на канале';
  end;
end;

procedure TMainForm.lbTalkFuncDblClick(Sender: TObject);
begin
  case lbTalkFunc.ItemIndex of
    0: pcConf.ActivePageIndex:=12;
    1: pcConf.ActivePageIndex:=13;
    2: pcConf.ActivePageIndex:=14;
    3: pcConf.ActivePageIndex:=15;
    4: pcConf.ActivePageIndex:=16;
    5: pcConf.ActivePageIndex:=25;
  end;
end;

procedure TMainForm.lbAdminFuncClick(Sender: TObject);
begin
  case lbAdminFunc.ItemIndex of
    0: lbAdmDesc.Caption:='Настройка учетных записей пользователей бота';
    1: lbAdmDesc.Caption:='Настройка листа автовыполнения';
    2: lbAdmDesc.Caption:='Настройка альтернативных серверов';
    3: lbAdmDesc.Caption:='Настройка почтовой службы';
  end;
end;

procedure TMainForm.lbAdminFuncDblClick(Sender: TObject);
begin
  case lbAdminFunc.ItemIndex of
    0: pcConf.ActivePageIndex:=8;
    1: pcConf.ActivePageIndex:=9;
    2: pcConf.ActivePageIndex:=10;
    3: pcConf.ActivePageIndex:=17;
  end;
end;

procedure TMainForm.lbDispFuncClick(Sender: TObject);
begin
  case lbDispFunc.ItemIndex of
    0: lbFuncDesc.Caption:='Приветствия и прощания, разговор, диалог, приветствия бота, персональные приветствия, реакция на фразы';
    1: lbFuncDesc.Caption:='Защита каналов от нецензурной лексики или рекламы';
    2: lbFuncDesc.Caption:='Настройка функции seen';
  end;
end;

procedure TMainForm.lbDispFuncDblClick(Sender: TObject);
begin
  case lbDispFunc.ItemIndex of
    0: pcConf.ActivePageIndex:=11;
    1: pcConf.ActivePageIndex:=20;
    2: pcConf.ActivePageIndex:=21;
  end;
end;

procedure TMainForm.cbDNickClick(Sender: TObject);
var conf: TProIni;
begin
  conf:=TProIni.Create(global.dir+'conf\fbot.conf');
  conf.WriteBool('misc','addtalknick',cbDNick.Checked);
  conf.Free;
  settings.addtalknick:=cbDNick.Checked;
end;

procedure TMainForm.tsUjoinShow(Sender: TObject);
var uconf: TSegFile;
begin
  uconf:=TSegFile.Create(global.dir+'main\ujoin.txt');
  uconf.ReadSections(lbUjoin.Items);
  uconf.Free;
end;

procedure TMainForm.TreeViewClick(Sender: TObject);
begin
  TreeViewChange(MainForm,nil);
end;

end.
