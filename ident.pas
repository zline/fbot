unit ident;
interface
uses Classes, ScktComp, func;

type TIdentd = class(TServerSocket)
  private
    value: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetIdent(const idvalue: string);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GetRequest(Sender: TObject; Sock: TCustomWinSocket);
  end;

implementation

{ TIdentd }
constructor TIdentd.Create;
begin
  inherited Create(AOwner);
  value:='';
  port:=113;
  OnClientError:=ClientError;
  OnClientRead:=GetRequest;
end; // constructor TIdentd.Create;

procedure TIdentd.SetIdent;
begin
  value:=idvalue;
end; // procedure TIdentd.SetIdent;

procedure TIdentd.ClientError;
begin
  ErrorCode:=0;
end; // procedure TIdentd.ClientError;

procedure TIdentd.GetRequest;
var s: string;
begin
  s:=Sock.ReceiveText;
  rmchar(s,#13);
  rmchar(s,#10);
  Sock.SendText(s+' : USERID : WIN32 : '+value);
end; // procedure TIdentd.GetRequest;
{ / TIdentd }

end.
