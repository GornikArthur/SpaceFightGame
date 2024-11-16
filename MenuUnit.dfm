object MenuForm: TMenuForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'MenuForm'
  ClientHeight = 520
  ClientWidth = 794
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
  object NameLabel: TLabel
    Left = -1
    Top = 3
    Width = 638
    Height = 88
    Caption = 'Space Fight'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -88
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object PlayLabel: TLabel
    Left = 0
    Top = 97
    Width = 177
    Height = 59
    Caption = 'Play'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object SettingsLabel: TLabel
    Left = 0
    Top = 150
    Width = 306
    Height = 59
    Caption = 'Settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object ExitLabel: TLabel
    Left = 0
    Top = 287
    Width = 152
    Height = 59
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LoadLabel: TLabel
    Left = 0
    Top = 215
    Width = 427
    Height = 59
    Caption = 'Load Game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -59
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
  end
  object RecordLabel: TLabel
    Left = 0
    Top = 383
    Width = 201
    Height = 44
    Caption = 'Record:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object RecordNumLabel: TLabel
    Left = 199
    Top = 383
    Width = 31
    Height = 44
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object DeveloperLabel: TLabel
    Left = 0
    Top = 433
    Width = 768
    Height = 44
    Caption = 'Developed by Gornik Artur'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -44
    Font.Name = 'Moscow Metro'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object NavigateLabel: TLabel
    Left = 176
    Top = 287
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
  object ChooseLabel: TLabel
    Left = 464
    Top = 287
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
  object OpenDialog: TOpenDialog
    Left = 824
    Top = 408
  end
end
