program fbot;

uses
  Forms,
  gui in 'gui.pas' {MainForm},
  struct in 'struct.pas',
  mgr in 'mgr.pas',
  func in 'func.pas',
  main in 'main.pas',
  time in 'time.pas',
  help in 'help.pas',
  seen in 'seen.pas',
  talk in 'talk.pas',
  u_adduserform in 'u_adduserform.pas' {AddUserForm},
  u_inputrequest in 'u_inputrequest.pas' {InputRequest},
  u_addservform in 'u_addservform.pas' {AddServForm},
  u_segfileedit in 'u_segfileedit.pas' {SegFileEdit},
  updater in 'updater.pas',
  timers in 'timers.pas',
  ident in 'ident.pas',
  badwords in 'badwords.pas',
  spoolers in 'spoolers.pas',
  u_addbadword in 'u_addbadword.pas' {AddBadword},
  u_chanaccessform in 'u_chanaccessform.pas' {ChanAccessForm},
  seims in 'seims.pas',
  u_dsegfileedit in 'u_dsegfileedit.pas' {DSegFileEdit};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'fbot';
  Application.CreateForm(TMainForm, MainForm);
  Application.ShowMainForm:=false;
  Application.Run;
end.
