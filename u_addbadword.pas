unit u_addbadword;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const addMAT    = 0;
      addPhrase = 1;

type pAbwResult = ^TAbwResult;
  TAbwResult = record
    data: string;
    isset: boolean;
  end;

type
  TAddBadword = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  public
    res: pAbwResult;
    constructor Create(aresult: pAbwResult; abwTYPE: integer); reintroduce;
  end;

function phraserequest(abwTYPE: integer): string;

implementation
{$R *.dfm}

constructor TAddBadword.Create;
begin
  inherited Create(nil);
  res:=aresult;
  res^.isset:=false;
  case abwTYPE of
    addMAT: Caption:='¬ведите блокируемое слово:';
    addPhrase: Caption:='¬ведите фразу:';
  end;
end; // constructor TAddBadword.Create;

procedure TAddBadword.Button1Click(Sender: TObject);
begin
  if edit1.Text = '' then
    begin
      edit1.SetFocus;
      exit;
    end;
  case ComboBox1.ItemIndex of
    0: res^.data:=edit1.Text;
    1: res^.data:=' '+edit1.Text+' ';
    2: res^.data:=edit1.Text+' ';
    3: res^.data:=' '+edit1.Text;
  end;
  res^.isset:=true;
  close;
end;

procedure TAddBadword.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TAddBadword.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

function phraserequest;
var aform: TAddBadword;
    res: pAbwResult;
begin
  new(res);
  aform:=TAddBadword.Create(res,abwTYPE);
  aform.ShowModal;
  if res^.isset then result:=res^.data
  else result:='';
  dispose(res);
end; // function badwordrequest;

procedure TAddBadword.FormActivate(Sender: TObject);
begin
  edit1.SetFocus;
end;

procedure TAddBadword.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      key:=#0;
      Button1Click(Sender);
    end;
end;

end.
