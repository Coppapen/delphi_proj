program dupa;

{$R dupa.res}
{$R 'dupaResource.res' 'dupaResource.rc'}

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  ListViewFrameUnit in 'ListViewFrameUnit.pas' {ListViewFrame: TFrame},
  SortSelectUnit in 'SortSelectUnit.pas' {SortSelectForm},
  ExplorerUtils in 'ExplorerUtils.pas',
  InputUnit in 'InputUnit.pas' {InputForm},
  OverwriteConfirm in 'OverwriteConfirm.pas' {ConfirmForm},
  Vcl.Themes,
  Vcl.Styles,
  FileMonitor in 'FileMonitor.pas',
  BookmarkManager in 'BookmarkManager.pas',
  ApplicationSettings in 'ApplicationSettings.pas',
  FileTransfer in 'FileTransfer.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSortSelectForm, SortSelectForm);
  Application.CreateForm(TInputForm, InputForm);
  Application.Run;
end.
