unit u_addservform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type pAddedServer = ^TAddedServer;
  TAddedServer = record
    name: string;
    adr: string;
    port: integer;
    pass: string;
    isset: boolean;
  end;

type
  TAddServForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Edit4: TEdit;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  public
    res: pAddedServer;
    constructor Create(AOwner: TComponent; ares: pAddedServer); reintroduce;
  end;

implementation

{$R *.dfm}

procedure TAddServForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in ['0'..'9',#8]) then key:=#0;
end;

constructor TAddServForm.Create;
begin
  inherited Create(AOwner);
  res:=ares;
  try res^.isset:=false; except end;
end; // constructor TAddServForm.Create;

procedure TAddServForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TAddServForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TAddServForm.Button1Click(Sender: TObject);
begin
  if edit4.Text = '' then
    begin
      messagedlg('Ошибка! Не введено название сервера.',mtError,[mbOk],0);
      exit;
    end;
  if edit1.Text = '' then
    begin
      messagedlg('Ошибка! Не введен адрес сервера.',mtError,[mbOk],0);
      exit;
    end;
  if res <> nil then
    begin
      res^.name:=Edit4.Text;
      res^.adr:=Edit1.Text;
      if Edit2.Text = '' then res^.port:=0
      else res^.port:=strtoint(Edit2.Text);
      res^.pass:=Edit3.Text;
      res^.isset:=true;
    end;
  close;
end;

end.
