Unit PlayUnit;

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
    Contnrs,
    HPUnit,
    EnemyUnit,
    Bass,
    System.DateUtils,
    Vcl.StdCtrls,
    Vcl.ExtCtrls,
    ParamsUnit;

Type
    TPlayForm = Class(TForm)
        CounterLabel: TLabel;
        MoveLabel: TLabel;
        ShootLabel: TLabel;
        Procedure RestartGame();
        Procedure FormActivate(Sender: TObject);
        Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
        Procedure Update(Sender: TObject);
        Procedure Movement();
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure BKPaint(Sender: TObject);
        Procedure Draw(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
        GameChanel: HSTREAM;
    End;

    PEnemyList = ^ListElem;

    ListElem = Record
        Data: TEnemy;
        Next: PEnemyList;
    End;

Const
    IMG_PATHS = '.\images\';
    BK_PATH = IMG_PATHS + 'BK.bmp';
    SHOOT_PATH = IMG_PATHS + 'shoot_button.bmp';
    MOVE_IMG_PATH = IMG_PATHS + 'game_move.bmp';
    ENEMY_Count = 11;

Var
    PlayForm: TPlayForm;
    BKBitmap: TBitmap;
    ScCentreW, ScCentreH, ScLeft, ScRight, ScUp, ScDown: Integer;
    Height: Integer;
    CloseGame: Boolean;

    EnemyList: PEnemyList;
    BkMove: TMoveBk;
    EnemySpeed, EnemyBulletSpeed, EnemyBulletReloadTime: Integer;

    StartTime, GameStartTime, DifficultyTime: TDateTime;

    LastEnemyY, Difficulty: Integer;

    Explosion: TBitmapArr;
    ExplosionBitmap: TBitmap;
    RestartTime: Integer;
    Work: Boolean;
    GamePoints, SleepTime: Integer;

Implementation

Uses
    BulletUnit,
    MenuUnit,
    StopUnit,
    ShipUnit;

Type
    HMUSIC = DWORD;

Var
    MainShip: TShip;
    MoveImg, ShootImg: TPicture;

    {$R *.dfm}

Procedure AddEnemies();
Var
    CurrentEnemy: PEnemyList;
    I: Integer;
Begin
    LastEnemyY := 0;

    Difficulty := 10;

    EnemySpeed := 6;
    EnemyBulletSpeed := -13;
    EnemyBulletReloadTime := 1200;

    CurrentEnemy := Nil;

    New(CurrentEnemy);
    EnemyList := CurrentEnemy;
    For I := 0 To ENEMY_Count - 1 Do
    Begin
        CurrentEnemy^.Data := TEnemy.Create(LastEnemyY, Difficulty, 0, EffectsVol);
        CurrentEnemy^.Data.MoveEnemy := True;
        New(CurrentEnemy^.Next);
        CurrentEnemy := CurrentEnemy^.Next;
    End;
    CurrentEnemy^.Data := TEnemy.Create(LastEnemyY, Difficulty, 1, EffectsVol);
    CurrentEnemy^.Data.MoveEnemy := True;
    CurrentEnemy^.Next := Nil;

    LastEnemyY := CurrentEnemy^.Data.Y;
End;

Procedure TPlayForm.FormActivate(Sender: TObject);
Var
    I: Integer;
    FilePath: String;
    ShipAddr: ^TShip;
    CurrentEnemy: PEnemyList;
Begin
    MoveImg.Img := TBitmap.Create;
    MoveImg.Img.LoadFromFile(MOVE_IMG_PATH);
    MoveImg.Img.Height := 144;
    MoveImg.Img.Width := 218;
    MoveImg.X := (LeftBord - MoveImg.Img.Width) Div 2;
    MoveImg.Y := Screen.Height Div 2 - MoveImg.Img.Height;

    MoveLabel.Top := MoveImg.Y - MoveLabel.Height - 2;
    MoveLabel.Left := (MoveImg.X + MoveLabel.Width) Div 2 - 35;

    ShootImg.Img := TBitmap.Create;
    ShootImg.Img.LoadFromFile(SHOOT_PATH);
    ShootImg.Img.Height := 100;
    ShootImg.Img.Width := 386;
    ShootImg.X := (LeftBord - ShootImg.Img.Width) Div 2;
    ShootImg.Y := Screen.Height Div 2 + ShootImg.Img.Height;

    ShootLabel.Top := ShootImg.Y - ShootLabel.Height - 2;
    ShootLabel.Left := (ShootImg.X + ShootLabel.Width) Div 2 + 30;

    Self.Color := ClBlack;
    CloseGame := False;

    Canvas.Brush.Color := ClBlack;
    Canvas.Brush.Style := BsSolid;
    Canvas.Pen.Color := ClBlack;
    Canvas.Pen.Width := 2;

    Canvas.Font.Name := 'Moscow Metro';
    Canvas.Font.Size := 50;
    Canvas.Font.Color := ClWhite;

    FilePath := '.\sounds\game.mp3';
    GameChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE Or BASS_SAMPLE_LOOP);
    BASS_ChannelSetAttribute(GameChanel, BASS_ATTRIB_VOL, MusicVol * 10 / 100);
    BASS_ChannelPlay(GameChanel, False);

    StartTime := Now;
    GameStartTime := StartTime;

    ClientHeight := Height;

    ScCentreW := Screen.Width Div 2;
    ScCentreH := Screen.Height Div 2;

    ScUp := 0;
    ScDown := Screen.Height - 7;

    For I := 0 To 1 Do
    Begin
        BKBitmap := TBitmap.Create;
        BKBitmap.LoadFromFile(BK_PATH);
        BKBitmap.Height := Screen.Height;
        BKBitmap.Width := Screen.Width Div 1080 * BKBitmap.Width;

        BkMove.Pict[I] := BKBitmap;
    End;

    BkMove.Top1 := 0;
    BkMove.Top2 := -ScDown;

    BkMove.Left := ScCentreW - BKBitmap.Width Div 2;

    ScLeft := BkMove.Left;
    ScRight := (Screen.Width + BKBitmap.Width) Div 2;

    DifficultyTime := StartTime;

    MainShip := TShip.Create(EffectsVol);

    AddEnemies();

    If (Data.Ship.Hp > 0) Then
    Begin
        MainShip.X := Data.Ship.X;
        MainShip.Y := Data.Ship.Y;
        MainShip.Bullet.X := Data.Ship.BulletX;
        MainShip.Bullet.Y := Data.Ship.BulletY;
        MainShip.Bullet.MoveBullet := Data.Ship.MoveBullet;
        MainShip.Bullet.FinishMove := Data.Ship.FinishMove;
        MainShip.HP.CurHp := Data.Ship.Hp;
        MainShip.Points := Data.Ship.Points;
        MainShip.Bullet.LastShotTime := Now + StopData.Ship.LastShotTime;
        MainShip.HP.LoadHit();

        DifficultyTime := DifficultyTime + StopData.DifficultyTime;
        Difficulty := StopData.Difficulty;

        CurrentEnemy := EnemyList;
        For I := 0 To ENEMY_Count Do
        Begin
            CurrentEnemy^.Data.X := Data.EnemyList[I].X;
            CurrentEnemy^.Data.Y := Data.EnemyList[I].Y;
            CurrentEnemy^.Data.Bullet.X := Data.EnemyList[I].BulletX;
            CurrentEnemy^.Data.Bullet.Y := Data.EnemyList[I].BulletY;
            CurrentEnemy^.Data.Bullet.MoveBullet := Data.EnemyList[I].MoveBullet;
            CurrentEnemy^.Data.Bullet.FinishMove := Data.EnemyList[I].FinishMove;
            CurrentEnemy^.Data.EnType := Data.EnemyList[I].EnType;
            CurrentEnemy^.Data.MoveEnemy := Data.EnemyList[I].MoveEnemy;

            CurrentEnemy := CurrentEnemy^.Next;
        End;

    End;

    CounterLabel.Left := ScRight + 10;
    CounterLabel.Top := 10;

    SetLength(Explosion, 21);
    For I := 1 To 20 Do
    Begin

        ExplosionBitmap := TBitmap.Create;
        ExplosionBitmap.LoadFromFile(IMG_PATHS + 'Explosion_2\bmp_files\ex' + IntToStr(I) + '.bmp');
        ExplosionBitmap.Height := 80;
        ExplosionBitmap.Width := 80;
        ExplosionBitmap.TransparentColor := ClBlack;
        ExplosionBitmap.Transparent := True;

        Explosion[I - 1] := ExplosionBitmap;
    End;

    Data.Ship.Hp := 0;

    SleepTime := 0;
    Work := True;
    RestartTime := 3;
End;

Procedure ClearData();
Var
    CurrentEnemy, TempEnemy: PEnemyList;
Begin
    CurrentEnemy := EnemyList;
    While CurrentEnemy <> Nil Do
    Begin
        TempEnemy := CurrentEnemy;
        CurrentEnemy := CurrentEnemy^.Next;
        TempEnemy.Data.Bullet.Free;
        TempEnemy.Data.Free;
        Dispose(TempEnemy);
    End;
    EnemyList := Nil;

    MainShip.Free;
    MainShip.Bullet.Free;
End;

Procedure TPlayForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Var
    I: Integer;
    FilePath: String;
Begin
    If Not(CloseGame) Then
    Begin
        Work := False;
        GamePoints := MainShip.Points;
        StopForm := TStopForm.Create(Self);
        StopForm.ResumeLabel.Caption := '';
        StopForm.ResumeLabel.Top := StopForm.SaveLabel.Top;
        Inc(StopSelect.Pos);
        StopSelect.MinPos := StopSelect.Pos;
        StopSelect.Top := StopForm.SaveLabel.Top - 16;

        StopData.Ship.Hp := MainShip.HP.CurHp;
        StopData.Ship.Points := MainShip.Points;

        StopForm.ShowModal;
        StopForm.Free;
    End;

    CounterLabel.Caption := '0';

    ClearData();
End;

Procedure TPlayForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    StopForm: TStopForm;
Begin
    If (Key = 27) Then
    Begin
        Work := False;

        GamePoints := MainShip.Points;

        StopData.Ship.X := MainShip.X;
        StopData.Ship.Y := MainShip.Y;
        StopData.Ship.BulletX := MainShip.Bullet.X;
        StopData.Ship.BulletY := MainShip.Bullet.Y;
        StopData.Ship.MoveBullet := MainShip.Bullet.MoveBullet;
        StopData.Ship.FinishMove := MainShip.Bullet.FinishMove;
        StopData.Ship.Hp := MainShip.HP.CurHp;
        StopData.Ship.Points := MainShip.Points;
        StopData.Ship.LastShotTime := Now - MainShip.Bullet.LastShotTime;

        StopForm := TStopForm.Create(Self);
        StopForm.GameOverLabel.Caption := '';
        StopForm.ShowModal;
        StopForm.Free;

        SleepTime := 0;

        If CloseGame Then
            Close;

        Saved := False;
        Work := True;
        StartTime := Now;
        Repaint;
        RestartTime := 3;
    End
    Else
        If (Key = VK_F4) And (SsAlt In Shift) Then
            Key := 0;
End;

Procedure TPlayForm.Movement();
Var
    SpeedX, SpeedY: Integer;
    I, J: Integer;
    CurrentEnemy: PEnemyList;
Begin
    If (SecondsBetween(Now, DifficultyTime) >= 10) And (Difficulty > 2) Then
    Begin
        DifficultyTime := Now;
        Dec(Difficulty);
    End;

    Inc(BkMove.Top1, 1);
    Inc(BkMove.Top2, 1);
    If BkMove.Top1 >= ScDown Then
        BkMove.Top1 := -ScDown
    Else
        If BkMove.Top2 >= ScDown Then
            BkMove.Top2 := -ScDown;

    SpeedX := 0;
    SpeedY := 0;

    //¬верх
    If (MainShip.Y > ScCentreH) And (Getasynckeystate(38) <> 0) Then
        SpeedY := SpeedY - Round(MainShip.SpeedY);

    //¬низ
    If (MainShip.Y < ScDown - MainShip.Size) And (Getasynckeystate(40) <> 0) Then
        SpeedY := SpeedY + Round(MainShip.SpeedY);

    //¬право
    If (MainShip.X < ScRight - MainShip.Size) And (Getasynckeystate(39) <> 0) Then
        SpeedX := SpeedX + Round(MainShip.SpeedX);

    //¬лево
    If (MainShip.X > ScLeft) And (Getasynckeystate(37) <> 0) Then
        SpeedX := SpeedX - Round(MainShip.SpeedX);

    MainShip.Move(SpeedX, SpeedY);

    If Not(MainShip.Bullet.MoveBullet) And Not(MainShip.Bullet.FinishMove) And (Getasynckeystate(32) <> 0) Then
    Begin
        BASS_ChannelPlay(MainShip.Bullet.BulletChanel, False);
        MainShip.Bullet.MoveBullet := True;
    End;

    MainShip.Bullet.Move(MainShip.X, MainShip.Y);

    If (SecondsBetween(Now, GameStartTime) > 2) Then
    Begin
        CurrentEnemy := EnemyList;
        For I := 0 To ENEMY_COUNT Do
        Begin
            If CurrentEnemy^.Data.Hit = 0 Then
            Begin
                If MainShip.Bullet.MoveBullet Then
                    MainShip.CheckBulletCollision(CurrentEnemy^.Data);

                If MainShip.CheckEnemyCollision(CurrentEnemy^.Data) Then
                    Break;

                CurrentEnemy^.Data.Move(MainShip.X, MainShip.Y);
            End
            Else
                CurrentEnemy^.Data.Bullet.Move(CurrentEnemy^.Data.Bullet.X + SpeedX, CurrentEnemy^.Data.Bullet.Y + SpeedY);

            CurrentEnemy := CurrentEnemy^.Next;
        End;

        Inc(LastEnemyY, EnemySpeed);
    End;

    Inc(MainShip.Points);
End;

Procedure TPlayForm.BKPaint(Sender: TObject);
Var
    I: Integer;
Begin
    For I := 0 To 1 Do
    Begin
        Canvas.Draw(BkMove.Left, BkMove.Top1, BkMove.Pict[I]);
        Canvas.Draw(BkMove.Left, BkMove.Top2, BkMove.Pict[I]);
    End;
End;

Procedure TPlayForm.Draw(Sender: TObject);
Var
    I: Integer;
    CurrentEnemy: PEnemyList;
    RText: String;
Begin
    If MainShip.HP.CurHp = 0 Then
        Close;

    BKPaint(Sender);

    If MainShip.Bullet.MoveBullet And Not(MainShip.Bullet.FinishMove) Then
        Canvas.Draw(MainShip.Bullet.X, MainShip.Bullet.Y, MainShip.Bullet.Img);

    MainShip.Draw(Canvas);

    CurrentEnemy := EnemyList;
    For I := 0 To ENEMY_Count Do
    Begin
        If (CurrentEnemy^.Data.Bullet.MoveBullet Or CurrentEnemy^.Data.Bullet.FinishMove) And (CurrentEnemy^.Data.Bullet.X > ScLeft) And
            (CurrentEnemy^.Data.Bullet.X < ScRight) Then
            Canvas.Draw(CurrentEnemy^.Data.Bullet.X, CurrentEnemy^.Data.Bullet.Y, CurrentEnemy^.Data.Bullet.Img);

        CurrentEnemy^.Data.Draw(Canvas);

        CurrentEnemy := CurrentEnemy^.Next;
    End;

    For I := 0 To 2 Do
        Canvas.Draw(MainShip.HP.Left + I * (MainShip.HP.Size + 5), MainShip.HP.Top, MainShip.HP.HPBitArr[I]);

    CounterLabel.Caption := IntToStr(MainShip.Points);

    If (RestartTime > -1) Then
    Begin
        RText := IntToStr(RestartTime);
        Canvas.Ellipse(ScCentreW - 85, ScCentreH - 85, ScCentreW + 70, ScCentreH + 70);
        Canvas.TextOut(ScCentreW - 30, ScCentreH - 45, IntToStr(RestartTime));

        Sleep(SleepTime);

        Dec(RestartTime);
    End
    Else
        If MillisecondsBetween(Now, StartTime) >= 10 Then
        Begin
            StartTime := Now;
            Movement();
        End;

    Canvas.Draw(MoveImg.X, MoveImg.Y, MoveImg.Img);
    Canvas.Draw(ShootImg.X, ShootImg.Y, ShootImg.Img);

    SleepTime := 1000;
End;

Procedure TPlayForm.Update(Sender: TObject);
Begin
    If Work Then
    Begin
        Draw(Sender);
        Invalidate;
    End;
End;

Procedure TPlayForm.RestartGame();
Var
    I: Integer;
    CurrentHP: THP;
    CurrentPoints: Integer;
    CurrentEnemy: PEnemyList;
Begin
    CurrentHP := MainShip.HP;
    CurrentPoints := MainShip.Points;

    MainShip := TShip.Create(EffectsVol);

    MainShip.Points := CurrentPoints;

    MainShip.HP := CurrentHP;

    MainShip.Hit := 0;

    LastEnemyY := 0;

    New(CurrentEnemy);
    EnemyList := CurrentEnemy;
    For I := 0 To ENEMY_Count - 1 Do
    Begin
        CurrentEnemy^.Data := TEnemy.Create(LastEnemyY, Difficulty, 0, EffectsVol);
        CurrentEnemy^.Data.MoveEnemy := True;
        New(CurrentEnemy^.Next);
        CurrentEnemy := CurrentEnemy^.Next;
    End;
    CurrentEnemy^.Data := TEnemy.Create(LastEnemyY, Difficulty, 1, EffectsVol);
    CurrentEnemy^.Data.MoveEnemy := True;

    LastEnemyY := CurrentEnemy^.Data.Y;

    RestartTime := 3;
End;

End.
