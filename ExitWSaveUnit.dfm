object ExitWSaveForm: TExitWSaveForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'ExitWSaveForm'
  ClientHeight = 255
  ClientWidth = 379
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
  object ExitLabel: TLabel
    Left = 120
    Top = 25
    Width = 152
    Height = 59
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object YesLabel: TLabel
    Left = 24
    Top = 113
    Width = 115
    Height = 59
    Caption = 'Yes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object NoLabel: TLabel
    Left = 248
    Top = 105
    Width = 90
    Height = 59
    Caption = 'No'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object ChooseLabel: TLabel
    Left = 82
    Top = 187
    Width = 190
    Height = 44
    Caption = 'Choose'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
end
