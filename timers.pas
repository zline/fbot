unit timers;
interface
uses Classes, SysUtils, ExtCtrls;

 { Timer's params classes }
type TCustomTimerParams = class
  public
    name: string;
    interval: cardinal;
    repeats: integer;
  end;

type TNickTimerParams = class(TCustomTimerParams)
  public
    nick: string;
  end;
 { / Timer's params classes }

 { TimeManager's structure }
type TTimerManager = class;

TCustomTimer = class(TTimer)
  protected
    repeated: integer;
    tmanager: TTimerManager;
  public
    next: TCustomTimer;
    last: TCustomTimer;
    repeats: integer;
    constructor Create(TimerManager: TTimerManager); reintroduce; virtual;
    procedure exec(Sender: TObject); virtual; abstract;
  end;

TTimerManager = class(TObject)
  private
    root: TCustomTimer;
  public
    constructor Create;
    procedure AddTimer(ttype: integer; params: TCustomTimerParams);
    procedure DelTimer(const tname: string);
    function TimerExists(const tname: string): boolean;
    destructor Destroy; override;
  end;
 { / TimeManager's structure }

 { Timers kinds }
const
  tt_UNKNOWN    = 0; // Unknown Type
  tt_NICK       = 1; // TNickTimer

type TNickTimer = class(TCustomTimer)
  private
    nick: string;
  public
    constructor Create(TimerManager: TTimerManager; params: TNickTimerParams); reintroduce;
    procedure exec(Sender: TObject); override;
  end;
 { / Timers kinds }

 { special exception }
type ETimerManageError = class(Exception);

{ ---------------------- implementation -------------------------- }
implementation
uses mgr;

 { TCustomTimer }
constructor TCustomTimer.Create;
begin
  inherited Create(nil);
  Enabled:=false;
  repeats:=0;
  repeated:=0;
  next:=nil;
  last:=nil;
  onTimer:=exec;
  tmanager:=TimerManager;
end; // constructor TCustomTimer.Create;
 { / TCustomTimer }

 { TNickTimer }
constructor TNickTimer.Create;
begin
  inherited Create(TimerManager);
  if params.name = '' then
    begin
      raise ETimerManageError.Create('TNickTimer.Create: name field is''t set!');
      exit;
    end;
  name:=params.name;
  if params.nick = '' then
    begin
      raise ETimerManageError.Create('TNickTimer.Create: nick field is''t set!');
      exit;
    end;
  nick:=params.nick;
  if params.interval <= 0 then
    begin
      raise ETimerManageError.Create('TNickTimer.Create: invalid interval!');
      exit;
    end;
  interval:=params.interval;
  Enabled:=true;
end; // constructor TNickTimer.Create;

procedure TNickTimer.exec;
begin
  send('NICK '+nick);
end; // procedure TNickTimer.exec;
 { / TNickTimer }

 { TTimerManager }
constructor TTimerManager.Create;
begin
  inherited Create;
  root:=nil;
end; // constructor TTimerManager.Create;

destructor TTimerManager.Destroy;
var cur, tmp: TCustomTimer;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur.next;
      cur.Free;
      cur:=tmp;
    end;
  inherited Destroy;
end; // destructor TTimerManager.Destroy;

procedure TTimerManager.AddTimer;
var cur, newtimer: TCustomTimer;
begin
  cur:=root;
  while cur <> nil do
    begin
      if cur.Name = params.name then
        begin
          raise ETimerManageError.Create('TTimerManager.AddTimer: timer '''+params.name+''' already exists');
          exit;
        end;
      cur:=cur.next;
    end;
  case ttype of
    tt_NICK:
      begin
        if not(params is TNickTimerParams) then
          begin
            raise ETimerManageError.Create('TTimerManager.AddTimer: timer type and params type are not equal');
            exit;
          end;
        newtimer:=TNickTimer.Create(self,TNickTimerParams(params));
        if root <> nil then
          root.last:=newtimer;
        newtimer.next:=root;
        root:=newtimer;
      end;
    else raise ETimerManageError.Create('TTimerManager.AddTimer: unknown timer type');
  end;
end;

procedure TTimerManager.DelTimer;
var cur: TCustomTimer;
begin
  cur:=root;
  if cur = nil then exit;
  if cur.Name = tname then
    begin
      root:=cur.next;
      if root <> nil then
        root.last:=nil;
      cur.Free;
      exit;
    end;
  while cur <> nil do
    begin
      if cur.Name = tname then
        begin
          if cur.last <> nil then
            cur.last.next:=cur.next;
          if cur.next <> nil then
            cur.next.last:=cur.last;
          cur.Free;
          exit;
        end;
      cur:=cur.next;
    end;
end; // procedure TTimerManager.DelTimer;

function TTimerManager.TimerExists;
var cur: TCustomTimer;
begin
  result:=false;
  cur:=root;
  while cur <> nil do
    begin
      if cur.Name = tname then
        begin
          result:=true;
          exit;
        end;
      cur:=cur.next;
    end;
end; // function TTimerManager.TimerExists;
 { / TTimerManager }

end.
