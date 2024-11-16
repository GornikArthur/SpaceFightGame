object PlayForm: TPlayForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'PlayForm'
  ClientHeight = 230
  ClientWidth = 331
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnPaint = Update
  TextHeight = 15
  object CounterLabel: TLabel
    Left = 8
    Top = 8
    Width = 26
    Height = 37
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -37
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object MoveLabel: TLabel
    Left = 20
    Top = 71
    Width = 164
    Height = 44
    Caption = 'Move'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object ShootLabel: TLabel
    Left = 21
    Top = 121
    Width = 163
    Height = 44
    Caption = 'Shoot'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
end
