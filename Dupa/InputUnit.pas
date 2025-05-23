unit InputUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TInputForm = class(TForm)
    Edit1: TLabeledEdit;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private �錾 }
    FIsCancel: Boolean;
    function GetText: string;
  public
    { Public �錾 }
    procedure Init(const ACaption, APrompt, ADefault: string);
    property InputText: string read GetText;
    property IsCancel: Boolean read FIsCancel;
  end;

var
  InputForm: TInputForm;

implementation

{$R *.dfm}

procedure TInputForm.FormShow(Sender: TObject);
var
  s: string;
  p: Integer;

begin
  s := Edit1.Text;
  p := s.LastIndexOf('.');
  if (p <> - 1) and (p <> 0) then
  begin
    Edit1.SelStart := p;
    Edit1.SelLength := 0;
  end else
  begin
    Edit1.SelStart := Length(Edit1.Text);
    Edit1.SelLength := 0;
  end;
end;

function TInputForm.GetText: string;
begin
  Result := Edit1.Text;
end;

procedure TInputForm.Init(const ACaption, APrompt, ADefault: string);
begin
  InputForm.Caption := ACaption;
  Edit1.EditLabel.Caption := APrompt;
  Edit1.Text := ADefault;
  FIsCancel := False;
end;

procedure TInputForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        FIsCancel := True;
        Close;
      end;
    VK_RETURN: Close;
  end;
end;

end.
