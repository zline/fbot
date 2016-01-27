unit u_segfileedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, struct, u_inputrequest, ShellApi;

type
  TSegFileEdit = class(TForm)
    cbSegm: TComboBox;
    btNewSec: TButton;
    btDelSec: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lbData: TListBox;
    btDelString: TButton;
    btAddString: TButton;
    btExit: TButton;
    btHandEdit: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbSegmChange(Sender: TObject);
    procedure btNewSecClick(Sender: TObject);
    procedure btDelSecClick(Sender: TObject);
    procedure btAddStringClick(Sender: TObject);
    procedure btDelStringClick(Sender: TObject);
    procedure btHandEditClick(Sender: TObject);
  public
    segfile: TSegFile;
    constructor Create(AOwner: TComponent; const filename: string); reintroduce;
    destructor Destroy; override;
  end;

implementation
{$R *.dfm}

constructor TSegFileEdit.Create;
begin
  inherited Create(AOwner);
  segfile:=TSegFile.Create(filename);
  caption:='Редактирование: '+filename;
end; // constructor TSegFileEdit.Create;

destructor TSegFileEdit.Destroy;
begin
  segfile.Free;
  inherited Destroy;
end; // destructor TSegFileEdit.Destroy;

procedure TSegFileEdit.FormActivate(Sender: TObject);
begin
  segfile.ReadSections(cbSegm.Items);
  if cbSegm.Items.Count > 0 then
    begin
      cbSegm.ItemIndex:=0;
      segfile.ReadSection(cbSegm.Items[0],lbData.Items);
    end;
end;

procedure TSegFileEdit.btExitClick(Sender: TObject);
begin
  close;
end;

procedure TSegFileEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TSegFileEdit.cbSegmChange(Sender: TObject);
begin
  segfile.ReadSection(cbSegm.Items[cbSegm.ItemIndex],lbData.Items);
end;

procedure TSegFileEdit.btNewSecClick(Sender: TObject);
var s: string;
begin
  s:=inputrequest('Введите название раздела');
  if s <> '' then
    begin
      cbSegm.Items.Add(s);
      cbSegm.ItemIndex:=cbSegm.Items.Count - 1;
      segfile.ReadSection(s,lbData.Items);
    end;
end;

procedure TSegFileEdit.btDelSecClick(Sender: TObject);
begin
  if cbSegm.ItemIndex = -1 then exit;
  segfile.DelSection(cbSegm.Items[cbSegm.ItemIndex]);
  cbSegm.Items.Delete(cbSegm.ItemIndex);
  if cbSegm.Items.Count > 0 then
    begin
      cbSegm.ItemIndex:=0;
      segfile.ReadSection(cbSegm.Items[0],lbData.Items);
    end
  else
    begin
      cbSegm.Items.Clear;
      lbData.Clear;
    end;
end;

procedure TSegFileEdit.btAddStringClick(Sender: TObject);
var s: string;
begin
  if cbSegm.ItemIndex = -1 then
    begin
      messagedlg('Выберите раздел!',mtError,[mbOk],0);
      exit;
    end;
  s:=inputrequest('Введите строку');
  if s = '' then exit;
  segfile.AddString(cbSegm.Items[cbSegm.ItemIndex],s);
  lbData.Items.Insert(0,s);
end;

procedure TSegFileEdit.btDelStringClick(Sender: TObject);
var i: integer;
begin
  if lbData.Items.Count = 0 then exit;
  if cbSegm.ItemIndex = -1 then
    begin
      messagedlg('Выберите раздел!',mtError,[mbOk],0);
      exit;
    end;
  for i:=lbData.Items.Count - 1 downto 0 do
    if lbData.Selected[i] then
      begin
        segfile.DelString(cbSegm.Items[cbSegm.ItemIndex],lbData.Items[i]);
        lbData.Items.Delete(i);
      end;
end;

procedure TSegFileEdit.btHandEditClick(Sender: TObject);
begin
  btHandEdit.Enabled:=false;
  ShellExecute(0,nil,PChar(segfile.filename),nil,PChar(ExtractFileDir(segfile.filename)),SW_SHOW);
  close;
end;

end.
