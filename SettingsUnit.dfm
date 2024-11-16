object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SettingsForm'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  TextHeight = 15
  object MusicLabel: TLabel
    Left = 112
    Top = 61
    Width = 216
    Height = 59
    Caption = 'Music'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object EffectsLabel: TLabel
    Left = 96
    Top = 173
    Width = 277
    Height = 59
    Caption = 'Effects'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object NavigateLabel: TLabel
    Left = 116
    Top = 375
    Width = 263
    Height = 44
    Caption = 'Navigate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object ExitLabel: TLabel
    Left = 464
    Top = 317
    Width = 114
    Height = 44
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object ESCLabel: TLabel
    Left = 464
    Top = 388
    Width = 57
    Height = 29
    Caption = 'ESC'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -29
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object EVol: TLabel
    Left = 296
    Top = 317
    Width = 90
    Height = 29
    Caption = 'EVol'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -29
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object MVol: TLabel
    Left = 96
    Top = 293
    Width = 109
    Height = 29
    Caption = 'MVol'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -29
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
end
