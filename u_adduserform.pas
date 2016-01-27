unit u_adduserform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  NOUSER   = 0;
  USER     = 1;
  OPERATOR = 50;
  ADMIN    = 100;

type pAddedUser = ^TAddedUser;
  TAddedUser = record
    nick: string;
    pass: string;
    access: integer;
    isset: boolean;
  end;

type
  TAddUserForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  public
    res: pAddedUser;
    constructor Create(AOwner: TComponent; ares: pAddedUser); reintroduce;
  end;

implementation
{$R *.dfm}

procedure TAddUserForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TAddUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TAddUserForm.Button1Click(Sender: TObject);
begin
  if Edit1.Text = '' then
    begin
      messagedlg('Ошибка! Введите ник пользователя.',mtError,[mbOk],0);
      exit;
    end;
  if Edit2.Text = '' then
    begin
      messagedlg('Ошибка! Введите пароль пользователя.',mtError,[mbOk],0);
      exit;
    end;
  if res <> nil then
    begin
      res^.nick:=Edit1.Text;
      res^.pass:=Edit2.Text;
      case ComboBox1.ItemIndex of
        0: res^.access:=ADMIN;
        1: res^.access:=OPERATOR;
        2: res^.access:=USER;
      end;
      res^.isset:=true;
    end;
  close;
end;

constructor TAddUserForm.Create;
begin
  inherited Create(AOwner);
  res:=ares;
  try res^.isset:=false; except end;
end; // constructor TAddUserForm.Create;

end.
