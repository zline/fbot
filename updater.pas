unit updater;
interface
uses ScktComp, Classes, func;

type TGotInfoEvent = procedure(info: string) of object;

const crlf = #13#10;

type TUpdater = class(TClientSocket)
  private
    FOnGetInfo: TGotInfoEvent;
    Success: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SockRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure connected(Sender: TObject; Socket: TCustomWinSocket);
    procedure disconnected(Sender: TObject; Socket: TCustomWinSocket);
    procedure sockerror(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    property OnGetInfo: TGotInfoEvent read FOnGetInfo write FOnGetInfo;
  end;

implementation
uses mgr;

constructor TUpdater.Create;
begin
  inherited Create(AOwner);
  Host:='fbot.alsite.ru';
  Port:=80;
  Success:=false;
  OnConnect:=connected;
  OnRead:=SockRead;
  OnError:=SockError;
  OnDisconnect:=disconnected;
  ClientType:=ctNonBlocking;
  Open;
end; // constructor TUpdater.Create;

procedure TUpdater.disconnected;
begin
  if not(Success) then
    if Assigned(FOnGetInfo) then FOnGetInfo('');
end; // procedure TUpdater.disconnected;

procedure TUpdater.sockerror;
begin
  if not(Success) then
    if Assigned(FOnGetInfo) then FOnGetInfo('');
  ErrorCode:=0;
  active:=false;
end; // procedure TUpdater.sockerror;

procedure TUpdater.connected;
begin
  socket.SendText('GET /downloads/currentversion.txt HTTP/1.1'+crlf);
  socket.SendText('Host: fbot.alsite.ru'+crlf);
  socket.SendText('Accept-charset: cp1251'+crlf);
  socket.SendText('User-agent: fbot '+version+crlf);
  socket.SendText(crlf);
end; // procedure TUpdater.connected;

procedure TUPdater.SockRead;
var str,res: string;
    i: integer;
    s: TStringList;
begin
  str:=Socket.ReceiveText;
  rmchar(str,#13);
  s:=split(str,#10);
  for i:=0 to s.Count-1 do
    if copy(s[i],1,11) = '::version::' then
      begin
        res:=s[i];
        s.Free;
        delete(res,1,11);
        Success:=true;
        if Assigned(FOnGetInfo) then FOnGetInfo(res);
        active:=false;
        exit;
      end;
  s.Free;
end; // procedure TUPdater.SockRead;

end.
