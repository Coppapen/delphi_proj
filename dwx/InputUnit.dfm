object InputForm: TInputForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'InputForm'
  ClientHeight = 60
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object Edit1: TLabeledEdit
    Left = 7
    Top = 25
    Width = 420
    Height = 29
    EditLabel.Width = 26
    EditLabel.Height = 15
    EditLabel.Caption = 'Edit1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = ''
    OnKeyDown = Edit1KeyDown
  end
end
