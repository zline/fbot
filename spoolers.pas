unit spoolers;
interface
uses Classes, ExtCtrls;

type TSpoolersManager = class;

TSpooler = class
  private
    name: string;
    spooler: TStringList;
    timer: TTimer;
    smanager: TSpoolersManager;
  public
    next: TSpooler;
    last: TSpooler;
    constructor Create(const aname: string; manager: TSpoolersManager); reintroduce;
    procedure step(Sender: TObject);
    procedure add2queue(const text: string);
    destructor Destroy; override;
  end;

TSpoolersManager = class(TObject)
  private
    root: TSpooler;
  public
    constructor Create;
    procedure AddMsg(const nick,text: string);
    procedure DelSpooler(const sname: string);
    destructor Destroy; override;
  end;

{ ---------------------- implementation -------------------------- }
implementation
uses mgr;

 { TSpooler }
constructor TSpooler.Create;
begin
  inherited Create;
  next:=nil;
  last:=nil;
  name:=aname;
  smanager:=manager;
  spooler:=TStringList.Create;
  timer:=TTimer.Create(nil);
  timer.Interval:=333;
  timer.Enabled:=false;
  timer.OnTimer:=step;
end; // constructor TSpoller.Create;

procedure TSpooler.step;
begin
  if spooler.Count = 0 then smanager.DelSpooler(name);
  msg(name,spooler[0]);
  spooler.Delete(0);
  if spooler.Count = 0 then smanager.DelSpooler(name);
end; // procedure TSpooler.step;

procedure TSpooler.add2queue;
begin
  spooler.Add(text);
  if not(timer.Enabled) then timer.Enabled:=true;
end; // procedure TSpooler.add2queue;

destructor TSpooler.Destroy;
begin
  spooler.Free;
  timer.Free;
  inherited Destroy;
end; // destructor TSpooler.Destroy;
 { / TSpooler }

 { TSpoolersManager }
constructor TSpoolersManager.Create;
begin
  inherited Create;
  root:=nil;
end; // constructor TSpoolersManager.Create;

procedure TSpoolersManager.AddMsg;
var cur: TSpooler;
begin
  cur:=root;
  while cur <> nil do
    begin
      if cur.name = nick then
        begin
          cur.add2queue(text);
          exit;
        end;
      cur:=cur.next;
    end;
  cur:=TSpooler.Create(nick,self);
  cur.next:=root;
  if root <> nil then
    root.last:=cur;
  root:=cur;
  cur.add2queue(text);
end; // procedure TSpoolersManager.AddMsg;

procedure TSpoolersManager.DelSpooler;
var cur: TSpooler;
begin
  cur:=root;
  if cur = nil then exit;
  if cur.Name = sname then
    begin
      root:=cur.next;
      if root <> nil then
        root.last:=nil;
      cur.Free;
      exit;
    end;
  while cur <> nil do
    begin
      if cur.Name = sname then
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
end; // procedure TSpoolersManager.DelSpooler;

destructor TSpoolersManager.Destroy;
var cur, tmp: TSpooler;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur.next;
      cur.Free;
      cur:=tmp;
    end;
  inherited Destroy;
end; // destructor TSpoolersManager.Destroy;

 { / TSpoolersManager }
end.
