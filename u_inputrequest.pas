unit u_inputrequest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type pInputResult = ^TInputResult;
  TInputResult = record
    data: string;
    isset: boolean;
  end;

type
  TInputRequest = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  public
    res: pInputResult;
    constructor Create(const request: string; aresult: pInputResult); reintroduce;
  end;

function inputrequest(const request: string): string;

implementation
{$R *.dfm}

constructor TInputRequest.Create;
begin
  inherited Create(nil);
  Caption:=request;
  res:=aresult;
  res^.isset:=false;
end; // constructor TInputRequest.Create;

procedure TInputRequest.Button1Click(Sender: TObject);
begin
  if edit1.Text = '' then
    begin
      edit1.SetFocus;
      exit;
    end;
  res^.data:=edit1.Text;
  res^.isset:=true;
  close;
end;

procedure TInputRequest.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TInputRequest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

function inputrequest;
var aform: TInputRequest;
    res: pInputResult;
begin
  new(res);
  aform:=TInputRequest.Create(request,res);
  aform.ShowModal;
  if res^.isset then result:=res^.data
  else result:='';
  dispose(res);
end; // function inputrequest;

procedure TInputRequest.FormActivate(Sender: TObject);
begin
  edit1.SetFocus;
end;

procedure TInputRequest.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      key:=#0;
      Button1Click(Sender);
    end;
end;

end.
