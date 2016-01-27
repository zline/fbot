unit u_chanaccessform;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, struct, u_inputrequest;

const
    NOUSER        = 0;
    USER          = 1;
    VOICE         = 5;
    HOP           = 25;
    OPERATOR      = 50;
    ADMIN         = 100;

type
  TChanAccessForm = class(TForm)
    Label1: TLabel;
    cbChan: TComboBox;
    btNewChan: TButton;
    btDelChan: TButton;
    Label2: TLabel;
    cbAcc: TComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure cbChanChange(Sender: TObject);
    procedure cbAccChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btNewChanClick(Sender: TObject);
    procedure btDelChanClick(Sender: TObject);
  private
    cafile: string;
    nick: string;
  public
    constructor Create(const accessfile,anick: string); reintroduce;
  end;

function AccToIndex(access: shortint): shortint;
function IndexToAcc(index: shortint): shortint;

implementation
{$R *.dfm}

function AccToIndex;
begin
  result:=0;
  case access of
    VOICE: result:=3;
    HOP: result:=2;
    OPERATOR: result:=1;
    ADMIN: result:=0;
  end;
end; // function AccToIndex;

function IndexToAcc;
begin
  result:=ADMIN;
  case index of
    0: result:=ADMIN;
    1: result:=OPERATOR;
    2: result:=HOP;
    3: result:=VOICE;
  end;
end; // function IndexToAcc;

constructor TChanAccessForm.Create;
begin
  inherited Create(nil);
  cafile:=accessfile;
  nick:=anick;
  caption:=nick+' :: редактирование локального доступа';
end; // constructor TChanAccessForm.Create;

procedure TChanAccessForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TChanAccessForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TChanAccessForm.FormActivate(Sender: TObject);
var ini: TProIni;
begin
  ini:=TProIni.Create(cafile);
  ini.ReadSection(nick,cbChan.Items);
  if cbChan.Items.Count > 0 then
    begin
      cbChan.ItemIndex:=0;
      cbAcc.ItemIndex:=AccToIndex(ini.ReadInteger(nick,cbChan.Items[0],100));
    end;
  ini.Free;
end;

procedure TChanAccessForm.cbChanChange(Sender: TObject);
var ini: TProIni;
begin
  if cbChan.ItemIndex = -1 then exit;
  ini:=TProIni.Create(cafile);
  cbAcc.ItemIndex:=AccToIndex(ini.ReadInteger(nick,cbChan.Items[cbChan.itemindex],100));
  ini.Free;
end;

procedure TChanAccessForm.cbAccChange(Sender: TObject);
var ini: TProIni;
begin
  if cbChan.ItemIndex = -1 then exit;
  ini:=TProIni.Create(cafile);
  ini.WriteInteger(nick,cbChan.Items[cbChan.itemindex],IndexToAcc(cbAcc.ItemIndex));
  ini.Free;
end;

procedure TChanAccessForm.Button1Click(Sender: TObject);
begin
  cbAccChange(self);
  Close;
end;

procedure TChanAccessForm.btNewChanClick(Sender: TObject);
var s: string;
    ini: TProIni;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  if s[1] <> '#' then s:='#'+s;
  ini:=TProIni.Create(cafile);
  ini.WriteInteger(nick,s,ADMIN);
  ini.Free;
  cbChan.Items.Add(s);
  cbChan.ItemIndex:=cbChan.Items.Count - 1;
  cbAcc.ItemIndex:=0;
end;

procedure TChanAccessForm.btDelChanClick(Sender: TObject);
var ini: TProIni;
begin
  if cbChan.ItemIndex = -1 then exit;
  ini:=TProIni.Create(cafile);
  ini.DeleteKey(nick,cbChan.Items[cbChan.itemindex]);
  cbChan.Items.Delete(cbChan.itemindex);
  if cbChan.Items.Count > 0 then
    begin
      cbChan.ItemIndex:=0;
      cbAcc.ItemIndex:=AccToIndex(ini.ReadInteger(nick,cbChan.Items[0],100));
    end;
  ini.Free;
end;

end.
