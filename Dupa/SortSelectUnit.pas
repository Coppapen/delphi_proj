unit SortSelectUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSortSettings = record
    SortIndex: Integer;
    SortOrder: Integer;
    IsFoldersAtTheTop: Boolean;
    IsIgnoreCase: Boolean;
  end;

  TSortSelectForm = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel_Ascend: TPanel;
    Panel_Descend: TPanel;
    Panel_Order: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private êÈåæ }
    FAfterSortIndex: Integer;
    FAfterSortOrder: Integer;
    FCurrentSortIndex: Integer;
    FCurrentSortOrder: Integer;
    FIsCancel: Boolean;
    function KeyToIndex(const Key: Char): Integer;
    procedure SetPanelFocus(const Index: Integer);
    procedure SetSortOrder(const Index: Integer);
    function GetSortSettings: TSortSettings;
  public
    { Public êÈåæ }
    procedure Init(const SortSettings: TSortSettings);
    property IsCancel: Boolean read FIsCancel;
    property SortSettings: TSortSettings read GetSortSettings;
  end;

var
  SortSelectForm: TSortSelectForm;

implementation

{$R *.dfm}

{ TSortSelectForm }

procedure TSortSelectForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN:  Inc(FAfterSortIndex);
    VK_UP:    Dec(FAfterSortIndex);
    VK_LEFT:  FAfterSortOrder := 1;
    VK_RIGHT: FAfterSortOrder := -1;
    VK_SPACE:
      begin
        case FAfterSortIndex of
          5: CheckBox1.Checked := not CheckBox1.Checked;
          6: CheckBox2.Checked := not CheckBox2.Checked
        end;
      end;
    VK_RETURN:
      begin
        if FAfterSortIndex in [1..4] then
          Close;
      end;
    VK_ESCAPE:
      begin
        FIsCancel := True;
        Close;
      end;
  end;
  if (Key = VK_DOWN) or (Key = VK_UP) then
  begin
    if FAfterSortIndex < 1 then
      FAfterSortIndex := 1
    else
    if FAfterSortIndex > 6 then
      FAfterSortIndex := 6;
    SetPanelFocus(FAfterSortIndex);
  end;
  if (Key = VK_LEFT) or (Key = VK_RIGHT) then
    SetSortOrder(FAfterSortOrder);
end;

procedure TSortSelectForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    'f', 'e', 's', 't', 'g', 'c':
    begin
      if Key = 'g' then
        CheckBox1.Checked := not CheckBox1.Checked;
      if Key = 'c' then
        CheckBox2.Checked := not CheckBox2.Checked;
      SetPanelFocus(KeyToIndex(Key));
    end;
  end;
end;

function TSortSelectForm.GetSortSettings: TSortSettings;
begin
  with Result do
  begin
    SortIndex := FAfterSortIndex;
    SortOrder := FAfterSortOrder;
    IsFoldersAtTheTop := CheckBox1.Checked;
    IsIgnoreCase := CheckBox2.Checked;
  end;
end;

procedure TSortSelectForm.Init(const SortSettings: TSortSettings);
var
  i: Integer;

begin
  CheckBox1.Checked := True;
  SetPanelFocus(SortSettings.SortIndex);
  SetSortOrder(SortSettings.SortOrder);
  FAfterSortIndex := SortSettings.SortIndex;
  FAfterSortOrder := SortSettings.SortOrder;
  FCurrentSortIndex := SortSettings.SortIndex;
  FCurrentSortOrder := SortSettings.SortOrder;
  for i := 1 to 4 do
    TLabel(FindComponent('Label' + i.ToString)).Enabled := True;
  TLabel(FindComponent('Label' + SortSettings.SortIndex.ToString)).Enabled := False;
  CheckBox1.Checked := SortSettings.IsFoldersAtTheTop;
  CheckBox2.Checked := SortSettings.IsIgnoreCase;
  FIsCancel := False;
end;

function TSortSelectForm.KeyToIndex(const Key: Char): Integer;
const
  Keys = 'festgc';

begin
  Result := Pos(Key, Keys);
end;

procedure TSortSelectForm.SetPanelFocus(const Index: Integer);
var
  i: Integer;

begin
  for i := 1 to 6 do
  begin
    TPanel(FindComponent('Panel' + i.ToString)).BevelInner := bvNone;
    TPanel(FindComponent('Panel' + i.ToString)).BevelOuter := bvNone;
  end;
  TPanel(FindComponent('Panel' + Index.ToString)).BevelInner := bvLowered;
  TPanel(FindComponent('Panel' + Index.ToString)).BevelOuter := bvRaised;
end;

procedure TSortSelectForm.SetSortOrder(const Index: Integer);
begin
  Panel_Ascend.BevelOuter := bvNone;
  Panel_Descend.BevelOuter := bvNone;
  case Index of
     1: Panel_Ascend.BevelOuter := bvRaised;
    -1: Panel_Descend.BevelOuter := bvRaised;
  end;
end;

end.
