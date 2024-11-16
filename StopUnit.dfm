object StopForm: TStopForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'StopForm'
  ClientHeight = 578
  ClientWidth = 1043
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  TextHeight = 15
  object ResumeLabel: TLabel
    Left = 184
    Top = 277
    Width = 282
    Height = 59
    Caption = 'Resume'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object ExitLabel: TLabel
    Left = 248
    Top = 407
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
  object SaveLabel: TLabel
    Left = 114
    Top = 342
    Width = 427
    Height = 59
    Caption = 'Save Game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object GameOverLabel: TLabel
    Left = 8
    Top = 14
    Width = 641
    Height = 88
    Caption = 'Game Over'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -88
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object TotalScoreLabel: TLabel
    Left = 96
    Top = 108
    Width = 475
    Height = 59
    Caption = 'Total Score:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object ScoreLabel: TLabel
    Left = 304
    Top = 165
    Width = 41
    Height = 59
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object NavigateLabel: TLabel
    Left = 611
    Top = 223
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
  object EnterLabel: TLabel
    Left = 619
    Top = 273
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
  object SaveDialog: TSaveDialog
    Left = 952
    Top = 344
  end
end
