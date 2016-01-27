unit u_dsegfileedit;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, struct, StdCtrls, ExtCtrls, ShellApi, u_inputrequest, u_addbadword;

type
  TDSegFileEdit = class(TForm)
    GroupBox1: TGroupBox;
    btNewSec: TButton;
    btDelSec: TButton;
    cbSection: TComboBox;
    btHandEdit: TButton;
    btExit: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cbSubSec: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    btAddSubSec: TButton;
    btDelSubSec: TButton;
    btDelReact: TButton;
    btAddReact: TButton;
    Bevel2: TBevel;
    lbReact: TListBox;
    lbSubSec: TListBox;
    btNewGroup: TButton;
    btDelGroup: TButton;
    procedure btExitClick(Sender: TObject);
    procedure btHandEditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure btNewSecClick(Sender: TObject);
    procedure btDelSecClick(Sender: TObject);
    procedure cbSectionChange(Sender: TObject);
    procedure cbSubSecChange(Sender: TObject);
    procedure btAddSubSecClick(Sender: TObject);
    procedure btDelSubSecClick(Sender: TObject);
    procedure btNewGroupClick(Sender: TObject);
    procedure btDelGroupClick(Sender: TObject);
    procedure btAddReactClick(Sender: TObject);
    procedure btDelReactClick(Sender: TObject);
    procedure lbReactKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    dsegfile: TDSegFile;
    constructor Create(AOwner: TComponent; const filename: string); reintroduce;
    destructor Destroy; override;
    function SecName: string;
    function SubSecName: string;
  end;

procedure psplit(s: string; list: TStrings);

implementation
{$R *.dfm}

procedure psplit;
var i: integer;
begin
  list.Clear;
  list.BeginUpdate;
  if s[1] = ';' then
    delete(s,1,1);
  if s[length(s)] = ';' then
    delete(s,length(s),1);
  while pos(';;',s) <> 0 do
    delete(s,pos(';;',s),1);
  i:=pos(';',s);
  while i<>0 do begin
    list.Add(copy(s,1,i-1));
    delete(s,1,i);
    i:=pos(';',s)
  end;
  list.Add(s);
  list.EndUpdate;
end; // procedure split;

constructor TDSegFileEdit.Create;
begin
  inherited Create(AOwner);
  dsegfile:=TDSegFile.Create(filename);
  caption:='Редактирование: '+filename;
end; // constructor TDSegFileEdit.Create;

destructor TDSegFileEdit.Destroy;
begin
  dsegfile.Free;
  inherited Destroy;
end; // destructor TDSegFileEdit.Destroy;

function TDSegFileEdit.SecName;
begin
  if cbSection.ItemIndex = 0 then
    result:='global'
  else
    result:=cbSection.Items[cbSection.ItemIndex];
end; // function TDSegFileEdit.SecName;

function TDSegFileEdit.SubSecName;
begin
  if cbSubSec.ItemIndex = 0 then
    result:=''
  else
    result:=cbSubSec.Items[cbSubSec.ItemIndex];
end; // function TDSegFileEdit.SubSecName;

procedure TDSegFileEdit.btExitClick(Sender: TObject);
begin
  close;
end;

procedure TDSegFileEdit.btHandEditClick(Sender: TObject);
begin
  btHandEdit.Enabled:=false;
  ShellExecute(0,nil,PChar(dsegfile.filename),nil,PChar(ExtractFileDir(dsegfile.filename)),SW_SHOW);
  close;
end;

procedure TDSegFileEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TDSegFileEdit.FormActivate(Sender: TObject);
var i: integer;
begin
  dsegfile.ReadSections(cbSection.Items);
  cbSection.Items.Insert(0,'Глобальные фразы (для всех каналов)');
  for i:=0 to cbSection.Items.Count - 1 do
    if lowercase(cbSection.Items[i]) = 'global' then
      cbSection.Items.Delete(i);
  cbSection.ItemIndex:=0;
  btDelSec.Enabled:=false;
  dsegfile.ReadSubSections('global',cbSubSec.Items,false);
  cbSubSec.Items.Insert(0,'{Фразы диалога}');
  cbSubSec.ItemIndex:=0;
  btDelGroup.Enabled:=false;
  btAddSubSec.Enabled:=false;
  btDelSubSec.Enabled:=false;
  dsegfile.ReadSubSection('global','',lbReact.Items,false);
end;

procedure TDSegFileEdit.btNewSecClick(Sender: TObject);
var s: string;
begin
  s:=inputrequest('Введите название канала');
  if s = '' then exit;
  if s[1] <> '#' then
    s:='#'+s;
  cbSection.ItemIndex:=cbSection.Items.Add(s);
  btDelSec.Enabled:=true;
  dsegfile.ReadSubSections(s,cbSubSec.Items,false);
  cbSubSec.Items.Insert(0,'{Фразы диалога}');
  cbSubSec.ItemIndex:=0;
  btDelGroup.Enabled:=false;
  btAddSubSec.Enabled:=false;
  btDelSubSec.Enabled:=false;
  lbSubSec.Clear;
  dsegfile.ReadSubSection(s,'',lbReact.Items,false);
end;

procedure TDSegFileEdit.btDelSecClick(Sender: TObject);
begin
  if cbSection.ItemIndex = 0 then exit;
  dsegfile.DelSection(cbSection.Items[cbSection.ItemIndex]);
  cbSection.Items.Delete(cbSection.ItemIndex);
  cbSection.ItemIndex:=0;
  btDelSec.Enabled:=false;
  dsegfile.ReadSubSections('global',cbSubSec.Items,false);
  cbSubSec.Items.Insert(0,'{Фразы диалога}');
  cbSubSec.ItemIndex:=0;
  btDelGroup.Enabled:=false;
  btAddSubSec.Enabled:=false;
  btDelSubSec.Enabled:=false;
  lbSubSec.Clear;
  dsegfile.ReadSubSection('global','',lbReact.Items,false);
end;

procedure TDSegFileEdit.cbSectionChange(Sender: TObject);
begin
  if cbSection.ItemIndex = 0 then
    btDelSec.Enabled:=false
  else
    btDelSec.Enabled:=true;
  dsegfile.ReadSubSections(SecName,cbSubSec.Items,false);
  cbSubSec.Items.Insert(0,'{Фразы диалога}');
  cbSubSec.ItemIndex:=0;
  btDelGroup.Enabled:=false;
  btAddSubSec.Enabled:=false;
  btDelSubSec.Enabled:=false;
  lbSubSec.Clear;
  dsegfile.ReadSubSection(SecName,'',lbReact.Items,false);
end;

procedure TDSegFileEdit.cbSubSecChange(Sender: TObject);
begin
  if cbSubSec.ItemIndex = 0 then
    begin
      btAddSubSec.Enabled:=false;
      btDelSubSec.Enabled:=false;
      lbSubSec.Clear;
      btDelGroup.Enabled:=false;
    end
  else
    begin
      btAddSubSec.Enabled:=true;
      btDelSubSec.Enabled:=true;
      psplit(SubSecName,lbSubSec.Items);
      btDelGroup.Enabled:=true;
    end;
  dsegfile.ReadSubSection(SecName,SubSecName,lbReact.Items,false);
end;

procedure TDSegFileEdit.btAddSubSecClick(Sender: TObject);
var s: string;
    i: integer;
begin
  i:=cbSubSec.ItemIndex;
  if i = 0 then exit;
  s:=phraserequest(addPhrase);
  if s = '' then exit;
  lbSubSec.Items.Add(s);
  dsegfile.ModifySubSection(SecName,cbSubSec.Items[i],cbSubSec.Items[i]+';'+s);
  cbSubSec.Items[i]:=cbSubSec.Items[i]+';'+s;
  cbSubSec.ItemIndex:=i;
end;

procedure TDSegFileEdit.btDelSubSecClick(Sender: TObject);
var s,s2: string;
    i,selected: integer;
begin
  if cbSubSec.ItemIndex = 0 then exit;
  selected:=-1;
  if lbSubSec.Items.Count > 0 then
    for i:=0 to lbSubSec.Items.Count - 1 do
      if lbSubSec.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите фразу!',mtError,[mbOk],0);
      exit;
    end;
  s:=lbSubSec.Items[selected];
  i:=cbSubSec.ItemIndex;
  lbSubSec.Items.Delete(selected);
  s2:=cbSubSec.Items[i];
  delete(s2,pos(s,s2),length(s));
  if s2 <> '' then
    begin
      if s2[1] = ';' then
        delete(s2,1,1);
      if s2[length(s2)] = ';' then
        delete(s2,length(s2),1);
      while pos(';;',s2) <> 0 do
        delete(s2,pos(';;',s2),1);
    end;
  dsegfile.ModifySubSection(SecName,cbSubSec.Items[i],s2);
  cbSubSec.Items[i]:=s2;
  cbSubSec.ItemIndex:=i;
  if lbSubSec.Items.Count = 0 then
    begin
      cbSubSec.ItemIndex:=0;
      btDelGroup.Enabled:=false;
      cbSubSec.Items.Delete(i);
      btAddSubSec.Enabled:=false;
      btDelSubSec.Enabled:=false;
      dsegfile.ReadSubSection(SecName,'',lbReact.Items,false);
    end;
end;

procedure TDSegFileEdit.btNewGroupClick(Sender: TObject);
var s: string;
begin
  s:=phraserequest(addPhrase);
  if s = '' then exit;
  cbSubSec.ItemIndex:=cbSubSec.Items.Add(s);
  psplit(SubSecName,lbSubSec.Items);
  lbReact.Clear;
  btAddSubSec.Enabled:=true;
  btDelSubSec.Enabled:=true;
  btDelGroup.Enabled:=true;
end;

procedure TDSegFileEdit.btDelGroupClick(Sender: TObject);
begin
  if cbSubSec.ItemIndex = 0 then exit;
  dsegfile.DelSubSection(SecName,cbSubSec.Items[cbSubSec.ItemIndex]);
  cbSubSec.Items.Delete(cbSubSec.ItemIndex);
  cbSubSec.ItemIndex:=0;
  btDelGroup.Enabled:=false;
  btAddSubSec.Enabled:=false;
  btDelSubSec.Enabled:=false;
  lbSubSec.Clear;
  dsegfile.ReadSubSection(SecName,'',lbReact.Items,false);
end;

procedure TDSegFileEdit.btAddReactClick(Sender: TObject);
var s: string;
begin
  s:=inputrequest('Введите ответ бота');
  if s = '' then exit;
  lbReact.Items.Insert(0,s);
  dsegfile.WriteString(SecName,SubSecName,s);
end;

procedure TDSegFileEdit.btDelReactClick(Sender: TObject);
var i,selected: integer;
begin
  selected:=-1;
  if lbReact.Items.Count > 0 then
    for i:=0 to lbReact.Items.Count - 1 do
      if lbReact.Selected[i] then selected:=i;
  if selected = -1 then
    begin
      messagedlg('Выберите фразу!',mtError,[mbOk],0);
      exit;
    end;
  dsegfile.DelString(SecName,SubSecName,lbReact.Items[selected]);
  lbReact.Items.Delete(selected);
  if selected <= lbReact.Items.Count - 1 then
    lbReact.Selected[selected]:=true
  else
    if lbReact.Items.Count > 0 then
      lbReact.Selected[selected-1]:=true;
end;

procedure TDSegFileEdit.lbReactKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i,selected: integer;
begin
  if key <> VK_DELETE then exit;
  selected:=-1;
  if lbReact.Items.Count > 0 then
    for i:=0 to lbReact.Items.Count - 1 do
      if lbReact.Selected[i] then selected:=i;
  if selected = -1 then exit;
  dsegfile.DelString(SecName,SubSecName,lbReact.Items[selected]);
  lbReact.Items.Delete(selected);
  if selected <= lbReact.Items.Count - 1 then
    lbReact.Selected[selected]:=true
  else
    if lbReact.Items.Count > 0 then
      lbReact.Selected[selected-1]:=true;
end;

end.
