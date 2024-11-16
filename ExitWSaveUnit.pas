Unit ExitWSaveUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    ParamsUnit;

Type
    TExitWSaveForm = Class(TForm)
        ExitLabel: TLabel;
        YesLabel: TLabel;
        NoLabel: TLabel;
        ChooseLabel: TLabel;
        Procedure FormActivate(Sender: TObject);
        Procedure FormPaint(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    ExitWSaveForm: TExitWSaveForm;
    StopSelect: TSelect;
    SaveGame: Boolean;
    EnterImg: TPicture;

Implementation

Uses
    StopUnit;

Const
    IMG_PATHS = '.\images\';
    SELECT_PATH = IMG_PATHS + 'select_small.bmp';

    {$R *.dfm}

Procedure TExitWSaveForm.FormActivate(Sender: TObject);
Var
    ScCenterW, ScCenterH: Integer;
    LeftBord: Integer;
Begin

    LeftBord := 420;

    ScCenterW := Screen.Width Div 2;
    ScCenterH := Screen.Height Div 2;

    ExitLabel.Caption := 'Are you sure you want' + #13#10 + 'to exit without saving?';

    ExitLabel.Left := ScCenterW - ExitLabel.Width Div 2;
    ExitLabel.Top := ScCenterH - ExitLabel.Height;

    YesLabel.Left := ScCenterW - YesLabel.Width Div 2 - 300;
    YesLabel.Top := ScCenterH + YesLabel.Height;

    NoLabel.Left := ScCenterW - NoLabel.Width Div 2 + 300;
    NoLabel.Top := YesLabel.Top;

    StopSelect.Picture := TBitmap.Create;
    StopSelect.Picture.LoadFromFile(SELECT_PATH);
    StopSelect.Picture.TransparentColor := ClBlack;
    StopSelect.Picture.Transparent := True;
    StopSelect.Left := NoLabel.Left - (StopSelect.Picture.Width - NoLabel.Width) Div 2;
    StopSelect.Top := NoLabel.Top - (StopSelect.Picture.Height - NoLabel.Height) Div 2;
    StopSelect.Change := NoLabel.Left + NoLabel.Width Div 2 - YesLabel.Left - YesLabel.Width Div 2;
    StopSelect.Pos := 2;
    StopSelect.MinPos := 1;

    EnterImg.Img := TBitmap.Create;
    EnterImg.Img.LoadFromFile(ENTER_PATH);
    EnterImg.Img.Height := 144;
    EnterImg.Img.Width := 151;
    EnterImg.X := (LeftBord - EnterImg.Img.Width) Div 2 - 25;
    EnterImg.Y := Screen.Height Div 2;

    ChooseLabel.Top := EnterImg.Y - ChooseLabel.Height - 2;
    ChooseLabel.Left := (EnterImg.X + ChooseLabel.Width) Div 4;

    SaveGame := False;

    Invalidate;
End;

Procedure TExitWSaveForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin

    If Key = 13 Then
    Begin
        Case StopSelect.Pos Of
            1:
                Close;
            2:
                Begin
                    SaveGame := True;
                    Close;
                End;
        End;
    End
    Else
    Begin

        If (Key = VK_F4) And (SsAlt In Shift) Then
            Key := 0
        Else
        Begin
            If Key = Vk_LEFT Then
            Begin
                Dec(StopSelect.Pos);
                Dec(StopSelect.Left, StopSelect.Change)
            End
            Else
                If Key = Vk_Right Then
                Begin
                    Inc(StopSelect.Pos);
                    Inc(StopSelect.Left, StopSelect.Change);
                End;

            If StopSelect.Left < (StopSelect.Picture.Width - YesLabel.Width) Div 2 Then
            Begin
                StopSelect.Pos := 2;
                StopSelect.Left := NoLabel.Left - (StopSelect.Picture.Width - NoLabel.Width) Div 2;
            End
            Else
                If StopSelect.Left > NoLabel.Left Then
                Begin
                    StopSelect.Pos := StopSelect.MinPos;
                    StopSelect.Left := YesLabel.Left - (StopSelect.Picture.Width - YesLabel.Width) Div 2;
                End;
        End;
    End;

    Invalidate;
End;

Procedure TExitWSaveForm.FormPaint(Sender: TObject);
Begin
    Self.Color := ClBlack;
    Canvas.Draw(StopSelect.Left, StopSelect.Top, StopSelect.Picture);
    Canvas.Draw(EnterImg.X, EnterImg.Y, EnterImg.Img);
End;

End.
