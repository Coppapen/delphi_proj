object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #12304#35373#23450#12305' '#12461#12540#12391#12510#12454#12473
  ClientHeight = 306
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    Left = 15
    Top = 12
    Width = 161
    Height = 15
    Caption = 'Shift + Ctrl '#12461#12540#12392#12398#32068#12415#21512#12431#12379
  end
  object LabeledEdit3: TLabeledEdit
    Left = 15
    Top = 108
    Width = 121
    Height = 23
    EditLabel.Width = 56
    EditLabel.Height = 15
    EditLabel.Caption = #19978#12408#31227#21205' :'
    TabOrder = 0
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit5: TLabeledEdit
    Left = 15
    Top = 161
    Width = 121
    Height = 23
    EditLabel.Width = 56
    EditLabel.Height = 15
    EditLabel.Caption = #19979#12408#31227#21205' :'
    TabOrder = 1
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit4: TLabeledEdit
    Left = 159
    Top = 108
    Width = 121
    Height = 23
    EditLabel.Width = 56
    EditLabel.Height = 15
    EditLabel.Caption = #21491#12408#31227#21205' :'
    TabOrder = 2
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit6: TLabeledEdit
    Left = 159
    Top = 161
    Width = 121
    Height = 23
    EditLabel.Width = 56
    EditLabel.Height = 15
    EditLabel.Caption = #24038#12408#31227#21205' :'
    TabOrder = 3
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object Button1: TButton
    Left = 15
    Top = 265
    Width = 121
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 159
    Top = 265
    Width = 121
    Height = 25
    Caption = 'OK'
    TabOrder = 5
  end
  object LabeledEdit1: TLabeledEdit
    Left = 15
    Top = 55
    Width = 121
    Height = 23
    EditLabel.Width = 53
    EditLabel.Height = 15
    EditLabel.Caption = #21491#12463#12522#12483#12463' :'
    TabOrder = 6
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit2: TLabeledEdit
    Left = 159
    Top = 55
    Width = 121
    Height = 23
    EditLabel.Width = 53
    EditLabel.Height = 15
    EditLabel.Caption = #24038#12463#12522#12483#12463' :'
    TabOrder = 7
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit7: TLabeledEdit
    Left = 15
    Top = 219
    Width = 121
    Height = 23
    EditLabel.Width = 97
    EditLabel.Height = 15
    EditLabel.Caption = #12459#12540#12477#12523#12398#31227#21205#37327' :'
    TabOrder = 8
    Text = ''
    OnKeyPress = LabeledEdit1KeyPress
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    Visible = True
    OnDblClick = TrayIcon1DblClick
    Left = 248
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 64
    object N1: TMenuItem
      Caption = #32066#20102
      OnClick = N1Click
    end
  end
end
