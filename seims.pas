// System of Expectation of the Intermediate Messages { придумал название - полдела сделано ;)}
unit seims;
interface
uses Classes, SysUtils;

const ST_UNBAN  = 1;

{ Seim's params classes }
type TCustomSeimParams = TObject;

type TBanSeimParams = class(TCustomSeimParams)
  public
    amask: string;
    achan: string;
    unban_all: boolean;
  end;
{ / Seim's params classes }

type TSeimManager = class;

TCustomSeim = class
  protected
    owner: TSeimManager;
  public
    id: cardinal;
    next: TCustomSeim;
    last: TCustomSeim;
    state: integer;
    constructor Create;
    procedure getmsg(const index,amsg: string); virtual; abstract;
  end;

TSeimManager = class
  private
    root: TCustomSeim;
    nextid: cardinal;
  public
    constructor Create;
    procedure AddSeim(stype: integer; params: TCustomSeimParams);
    procedure DelSeim(sid: cardinal);
    procedure getmsg(const index,amsg: string);
    destructor Destroy; override;
  end;

type TBanSeim = class(TCustomSeim)
  private
    banlist: TStringList;
    mask: string;
    chan: string;
    all: boolean;
  public
    constructor Create(manager: TSeimManager; params: TBanSeimParams; sid: cardinal); reintroduce;
    procedure getmsg(const index,amsg: string); override;
    destructor Destroy; override;
  end;

type ESeimManageError = class(Exception);

implementation
uses mgr,func;

{ TCustomSeim }
constructor TCustomSeim.Create;
begin
  inherited Create;
  state:=0;
end; // constructor TCustomSeim.Create;
{ / TCustomSeim }

{ TBanSeim }
constructor TBanSeim.Create;
begin
  if not(params is TBanSeimParams) then
    begin
      raise ESeimManageError.Create('TBanSeim.Create: invalid params type');
      exit;
    end;
  inherited Create;
  mask:=params.amask;
  chan:=params.achan;
  banlist:=TStringList.Create;
  all:=params.unban_all;
  owner:=manager;
  id:=sid;
end; // constructor TBanSeim.Create;

procedure TBanSeim.getmsg;
var i: integer;
    nick: string;
    found: boolean;
begin
  if index = '367' then
    begin
      if AnsiLowerCase(word4(amsg)) <> validchan(AnsiLowerCase(chan)) then exit;
      banlist.Add(word5(amsg));
      exit;
    end;
  if index = '368' then
    begin
      if AnsiLowerCase(word4(amsg)) <> validchan(AnsiLowerCase(chan)) then exit;
      nick:=copy(mask,1,pos('!',mask)-1);
      if all then
        begin
          if banlist.Count > 0 then
            for i:=0 to banlist.Count - 1 do
              send('MODE '+chan+' -b '+banlist[i]);
          msg(nick,'Все баны канала '+validchan(chan)+' сняты');
        end
      else
        begin
          if banlist.Count = 0 then
            begin
              msg(nick,'На канале '+validchan(chan)+' нет банов');
              owner.DelSeim(id);
              exit;
            end;
          found:=false;
          for i:=0 to banlist.Count - 1 do
            if iswm(banlist[i],mask) then
              begin
                found:=true;
                send('MODE '+chan+' -b '+banlist[i]);
              end;
          if found then
            msg(nick,'Вы были разбанены на '+validchan(chan))
          else
            msg(nick,'Банов, соответствующих вашему адресу не найдено. Попробуйте использовать !unban '+validchan(chan)+' all');
        end;
        owner.DelSeim(id);
      exit;
    end;
end; // procedure TBanSeim.getmsg;

destructor TBanSeim.Destroy;
begin
  banlist.Free;
  inherited Destroy;
end; // destructor TBanSeim.Destroy;
{ / TBanSeim }

{ TSeimManager }
constructor TSeimManager.Create;
begin
  root:=nil;
  nextid:=0;
end; // constructor TSeimManager.Create;

procedure TSeimManager.AddSeim;
var newseim, cur: TCustomSeim;
begin
  case stype of
    ST_UNBAN:
      begin
        if not(params is TBanSeimParams) then
          begin
            raise ESeimManageError.Create('TSeimManager.AddSeim: seim type and params type are not equal');
            exit;
          end;
        newseim:=TBanSeim.Create(self,TBanSeimParams(params),nextid);
        cur:=root;
        while cur <> nil do
          begin
            if cur is TBanSeim then
              if AnsiLowerCase(TBanSeim(cur).chan) = AnsiLowerCase(TBanSeimParams(params).achan) then
                begin
                  TBanSeim(newseim).banlist.Assign(TBanSeim(cur).banlist);
                  break;
                end;
            cur:=cur.next;
          end;
        inc(nextid);
        if root <> nil then
          root.last:=newseim;
        newseim.next:=root;
        root:=newseim;
      end;
    else raise ESeimManageError.Create('TSeimManager.AddSeim: unknown seim type');
  end;
end; // procedure TSeimManager.AddSeim;

procedure TSeimManager.DelSeim;
var cur: TCustomSeim;
begin
  cur:=root;
  if cur = nil then exit;
  if cur.id = sid then
    begin
      root:=cur.next;
      if root <> nil then
        root.last:=nil;
      cur.Free;
      exit;
    end;
  while cur <> nil do
    begin
      if cur.id = sid then
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
end; // procedure TSeimManager.DelSeim;

procedure TSeimManager.getmsg;
var cur: TCustomSeim;
begin
  cur:=root;
  while cur <> nil do
    begin
      cur.getmsg(index,amsg);
      cur:=cur.next;
    end;
end; // procedure TSeimManager.getmsg;

destructor TSeimManager.Destroy;
var cur, tmp: TCustomSeim;
begin
  cur:=root;
  while cur <> nil do
    begin
      tmp:=cur.next;
      if cur is TBanSeim then
        TBanSeim(cur).Free;
      cur:=tmp;
    end;
  inherited Destroy;
end; // destructor TSeimManager.Destroy;
{ / TSeimManager }

end.
