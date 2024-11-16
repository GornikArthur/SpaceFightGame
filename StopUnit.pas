Unit StopUnit;

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
    Contnrs,
    System.DateUtils,
    ShipUnit,
    EnemyUnit,
    ExitWSaveUnit,
    ParamsUnit;

Type
    TStopForm = Class(TForm)
        ResumeLabel: TLabel;
        ExitLabel: TLabel;
        SaveLabel: TLabel;
        GameOverLabel: TLabel;
        TotalScoreLabel: TLabel;
        ScoreLabel: TLabel;
        SaveDialog: TSaveDialog;
        NavigateLabel: TLabel;
        EnterLabel: TLabel;
        Procedure FormCreate(Sender: TObject);
        Procedure FormPaint(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Save(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

    TShipData = Record
        X, Y: Integer;
        BulletX, BulletY: Integer;
        MoveBullet, FinishMove: Boolean;
        Hp: Integer;
        Points: Integer;
        LastShotTime: TDateTime;
    End;

    TEnemyData = Record
        X, Y: Integer;
        BulletX, BulletY: Integer;
        MoveBullet, FinishMove: Boolean;
        EnType: Integer;
        MoveEnemy: Boolean;
    End;

    TEnemyDataList = Array [0 .. 11] Of TEnemyData;

    TSaveData = Record
        Ship: TShipData;
        EnemyList: TEnemyDataList;
        DifficultyTime: TDateTime;
        Difficulty: Integer;
    End;

Var
    StopForm: TStopForm;
    StopSelect: TSelect;
    StopData: TSaveData;
    Saved: Boolean;

Const
    IMG_PATHS = '.\images\';
    SELECT_PATH = IMG_PATHS + 'select.bmp';
    MENU_MOVE_PATH = IMG_PATHS + 'menu_move.bmp';
    ENTER_PATH = IMG_PATHS + 'enter_button.bmp';

Implementation

Uses
    PlayUnit,
    MenuUnit;

Var
    MenuMoveImg, EnterImg: TPicture;

    {$R *.dfm}

Procedure TStopForm.FormCreate(Sender: TObject);
Var
    ScCenterW, ScCenterH: Integer;
Begin
    ScCenterW := Screen.Width Div 2;
    ScCenterH := Screen.Height Div 2;

    ResumeLabel.Left := ScCenterW - ResumeLabel.Width Div 2;
    ResumeLabel.Top := ScCenterH + 150 - ResumeLabel.Width Div 2;

    SaveLabel.Left := ScCenterW - SaveLabel.Width Div 2;
    SaveLabel.Top := ResumeLabel.Top + SaveLabel.Height + 40;

    ExitLabel.Left := ScCenterW - ExitLabel.Width Div 2;
    ExitLabel.Top := SaveLabel.Top + ExitLabel.Height + 40;

    ScoreLabel.Caption := IntToStr(GamePoints);
    ScoreLabel.Left := ScCenterW - ScoreLabel.Width Div 2;
    ScoreLabel.Top := ResumeLabel.Top - ScoreLabel.Height - 80;

    TotalScoreLabel.Left := ScCenterW - TotalScoreLabel.Width Div 2;
    TotalScoreLabel.Top := ScoreLabel.Top - TotalScoreLabel.Height - 10;

    GameOverLabel.Left := ScCenterW - GameOverLabel.Width Div 2;
    GameOverLabel.Top := TotalScoreLabel.Top - GameOverLabel.Height - 30;

    StopSelect.Picture := TBitmap.Create;
    StopSelect.Picture.LoadFromFile(SELECT_PATH);
    StopSelect.Picture.TransparentColor := ClBlack;
    StopSelect.Picture.Transparent := True;
    StopSelect.Left := ScCenterW - StopSelect.Picture.Width Div 2;
    StopSelect.Top := ResumeLabel.Top - 16;
    StopSelect.Change := ExitLabel.Top - SaveLabel.Top;
    StopSelect.Pos := 0;

    MenuMoveImg.Img := TBitmap.Create;
    MenuMoveImg.Img.LoadFromFile(MENU_MOVE_PATH);
    MenuMoveImg.Img.Height := 144;
    MenuMoveImg.Img.Width := 70;
    MenuMoveImg.X := (LeftBord - MenuMoveImg.Img.Width) Div 2;
    MenuMoveImg.Y := Screen.Height Div 2 - MenuMoveImg.Img.Height;

    NavigateLabel.Top := MenuMoveImg.Y - NavigateLabel.Height - 10;
    NavigateLabel.Left := MenuMoveImg.X - NavigateLabel.Width Div 3 - 15;

    EnterImg.Img := TBitmap.Create;
    EnterImg.Img.LoadFromFile(ENTER_PATH);
    EnterImg.Img.Height := 144;
    EnterImg.Img.Width := 151;
    EnterImg.X := (LeftBord - EnterImg.Img.Width) Div 2 - 25;
    EnterImg.Y := Screen.Height Div 2 + EnterImg.Img.Height;

    EnterLabel.Top := EnterImg.Y - EnterLabel.Height - 10;
    EnterLabel.Left := MenuMoveImg.X - EnterLabel.Width Div 3;
End;

Procedure TStopForm.Save(Sender: TObject);
Var
    Path: String;
    TypedFile: File Of TSaveData;
    I: Integer;
    CurrentEnemy: PEnemyList;
Begin
    ShowCursor(True);
    If SaveDialog.Execute Then
    Begin
        Path := SaveDialog.FileName;
        If ExtractFileExt(Path) = '' Then
            Path := Path + '.astr';
        Try
            AssignFile(TypedFile, Path);
            Rewrite(TypedFile);

            If StopData.Ship.Hp > 0 Then
            Begin
                StopData.DifficultyTime := Now - DifficultyTime;
                StopData.Difficulty := Difficulty;

                CurrentEnemy := EnemyList;
                For I := 0 To ENEMY_Count Do
                Begin
                    StopData.EnemyList[I].X := CurrentEnemy^.Data.X;
                    StopData.EnemyList[I].Y := CurrentEnemy^.Data.Y;
                    StopData.EnemyList[I].BulletX := CurrentEnemy^.Data.Bullet.X;
                    StopData.EnemyList[I].BulletY := CurrentEnemy^.Data.Bullet.Y;
                    StopData.EnemyList[I].MoveBullet := CurrentEnemy^.Data.Bullet.MoveBullet;
                    StopData.EnemyList[I].FinishMove := CurrentEnemy^.Data.Bullet.FinishMove;
                    StopData.EnemyList[I].EnType := CurrentEnemy^.Data.EnType;
                    StopData.EnemyList[I].MoveEnemy := CurrentEnemy^.Data.MoveEnemy;

                    CurrentEnemy := CurrentEnemy^.Next;
                End;
            End;

            Write(TypedFile, StopData);

            Saved := True;
            MessageBox(Handle, PChar('The result is saved to a file.'), PChar('Information'), MB_OK + MB_ICONINFORMATION);
        Except
            On E: Exception Do
                MessageBox(Handle, PChar('Error while writing to file.'), PChar('Error'), MB_OK + MB_ICONWARNING);
        End;
        ShowCursor(False);
        CloseFile(TypedFile);
    End
    Else
    Begin
        MessageBox(Handle, PChar('Export to file canceled.'), PChar('Cancel'), MB_OK + MB_ICONWARNING);
        ShowCursor(False);
    End;
End;

Procedure TStopForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Skey: Word;
Begin
    Skey := Key;

    If Key = 13 Then
    Begin
        Case StopSelect.Pos Of
            0:
                Close;
            1:
                Save(Self);
            2:
                Begin

                    MenuForm.RecordNumLabel.Caption := IntToStr(StopData.Ship.Points);
                    MenuForm.RecordLabel.Left := Screen.Width Div 2 - (MenuForm.RecordLabel.Width + MenuForm.RecordNumLabel.Width) Div 2;
                    MenuForm.RecordNumLabel.Left := MenuForm.RecordLabel.Left + MenuForm.RecordLabel.Width + 2;
                    CloseGame := True;

                    If Not(Saved) Then
                    Begin
                        ExitWSaveForm := TExitWSaveForm.Create(Self);
                        ExitWSaveForm.ShowModal;
                        ExitWSaveForm.Free;

                        If SaveGame Then
                            Save(Sender);
                    End;

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
            If Key = Vk_Up Then
            Begin
                Dec(StopSelect.Pos);
                Dec(StopSelect.Top, StopSelect.Change)
            End
            Else
                If Key = Vk_Down Then
                Begin
                    Inc(StopSelect.Pos);
                    Inc(StopSelect.Top, StopSelect.Change);
                End;

            If StopSelect.Top < ResumeLabel.Top - 16 Then
            Begin
                StopSelect.Pos := 2;
                StopSelect.Top := ExitLabel.Top - 16
            End
            Else
                If StopSelect.Top > ExitLabel.Top Then
                Begin
                    StopSelect.Pos := StopSelect.MinPos;
                    StopSelect.Top := ResumeLabel.Top - 16;
                End;
        End;
    End;
    Invalidate;
End;

Procedure TStopForm.FormPaint(Sender: TObject);
Var
    I: Integer;
Begin
    Self.Color := ClBlack;
    Canvas.Draw(StopSelect.Left, StopSelect.Top, StopSelect.Picture);
    Canvas.Draw(MenuMoveImg.X, MenuMoveImg.Y, MenuMoveImg.Img);
    Canvas.Draw(EnterImg.X, EnterImg.Y, EnterImg.Img);
End;

End.
