object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Dual Pane File Manager  2025  Coppepan'
  ClientHeight = 455
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object Panel_L: TPanel
    Left = 0
    Top = 0
    Width = 305
    Height = 358
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    inline Frame_L: TListViewFrame
      Left = 0
      Top = 0
      Width = 305
      Height = 358
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 305
      ExplicitHeight = 358
      inherited SelectedStatusPanel: TPanel
        Width = 305
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 305
      end
      inherited StatusPanel: TPanel
        Top = 336
        Width = 305
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 336
        ExplicitWidth = 305
        inherited SearchPanel: TPanel
          Width = 303
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 303
          inherited SearchLabel: TLabel
            Height = 18
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited SearchEdit: TEdit
            Width = 254
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 254
          end
        end
      end
      inherited TabSet: TTabSet
        Width = 305
        ExplicitWidth = 305
      end
      inherited AddressEdit: TEdit
        Width = 305
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 305
      end
      inherited FileListView: TListView
        Width = 305
        Height = 270
        ExplicitWidth = 305
        ExplicitHeight = 270
      end
    end
  end
  object Panel_R: TPanel
    Left = 305
    Top = 0
    Width = 319
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    inline Frame_R: TListViewFrame
      Left = 0
      Top = 0
      Width = 319
      Height = 358
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 319
      ExplicitHeight = 358
      inherited SelectedStatusPanel: TPanel
        Width = 319
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 319
      end
      inherited StatusPanel: TPanel
        Top = 336
        Width = 319
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 336
        ExplicitWidth = 319
        inherited SearchPanel: TPanel
          Width = 317
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 317
          inherited SearchLabel: TLabel
            Height = 18
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited SearchEdit: TEdit
            Width = 268
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 268
          end
        end
      end
      inherited TabSet: TTabSet
        Width = 319
        ExplicitWidth = 319
      end
      inherited AddressEdit: TEdit
        Width = 319
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 319
      end
      inherited FileListView: TListView
        Width = 319
        Height = 270
        ExplicitWidth = 319
        ExplicitHeight = 270
      end
    end
  end
  object Panel_B: TPanel
    Left = 0
    Top = 358
    Width = 624
    Height = 97
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    object HistoryMemo: TMemo
      Left = 0
      Top = 0
      Width = 624
      Height = 78
      Align = alClient
      Color = clBackground
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object StatusBar: TStatusBar
      Left = 0
      Top = 78
      Width = 624
      Height = 19
      Panels = <
        item
          Width = 100
        end>
    end
    object ProgressBar: TProgressBar
      Left = 240
      Top = 40
      Width = 150
      Height = 17
      TabOrder = 2
    end
  end
end
