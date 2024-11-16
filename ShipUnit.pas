Unit ShipUnit;

Interface

Uses
    Contnrs,
    BulletUnit,
    EnemyUnit,
    PlayUnit,
    HPUnit,
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    BASS,
    ParamsUnit;

Type
    TShip = Class
        Procedure Move(SpeedX, SpeedY: Integer);
        Procedure CheckBulletCollision(Enemy: TEnemy);
        Function CheckEnemyCollision(Enemy: TEnemy): Boolean;
        Procedure MoveHitBoxArr();
        Procedure Draw(Canvas: TCanvas);
        Function CheckBulletBorders(Bullet: TBullet; Enemy: TEnemy; CurH: Integer): Boolean;
        Procedure AddHitPoints(Enemy: TEnemy);
    Public
        Img: TBitmap;
        X, Y: Integer;
        SpeedX, SpeedY: Real;
        Bullet: TBullet;
        HitBoxArr: TArrHitBox;
        HP: THP;
        Hit: Integer;
        Points, EnemyDestroyed: Integer;

        SChanel: HSTREAM;

    Const
        Size = 80;

        Constructor Create(Const Volume: Integer);
    End;

Implementation

Const
    IMG_PATHS = '.\images\';
    SHIP_PATH = IMG_PATHS + 'ship_main_80.bmp';

Constructor TShip.Create(Const Volume: Integer);
Var
    FilePath: String;
Begin
    FilePath := '.\sounds\bang.mp3';
    SChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE);
    BASS_ChannelSetAttribute(SChanel, BASS_ATTRIB_VOL, Volume * 10 / 100);

    Img := TBitmap.Create;
    Img.LoadFromFile(SHIP_PATH);
    Img.Height := Size;
    Img.Width := Size;
    Img.Transparent := True;

    SpeedX := 10;
    SpeedY := SpeedX / 1.05;

    X := ScCentreW - Size Div 2;
    Y := ScDown - Size - 50;

    SetLength(HitBoxArr, 2);
    HitBoxArr[0].Width := Size;
    HitBoxArr[0].Height := 53;

    HitBoxArr[1].Width := 17;
    HitBoxArr[1].Height := 46;

    Bullet := TBullet.Create(X, Y, 0, 50, 400, 0, Volume, False);

    HP := THP.Create();

    Self.Hit := 0;
    Points := 0;
End;

Procedure TShip.MoveHitBoxArr();
Begin
    Self.HitBoxArr[0].Left := Self.X;
    Self.HitBoxArr[0].Top := Self.Y + 46;

    Self.HitBoxArr[1].Left := Self.X + 41;
    Self.HitBoxArr[1].Top := Self.Y;
End;

Procedure TShip.Move(SpeedX, SpeedY: Integer);
Begin
    X := X + SpeedX;
    Y := Y + SpeedY;

    Self.MoveHitBoxArr();
End;

Function TShip.CheckBulletBorders(Bullet: TBullet; Enemy: TEnemy; CurH: Integer): Boolean;
Begin
    CheckBulletBorders := (Enemy.HitBoxArr[CurH].Top > -Enemy.Size Div 2) And (Bullet.X >= Enemy.BulletHitBoxArr[CurH].Left) And
        (Bullet.X <= Enemy.BulletHitBoxArr[CurH].Left + Enemy.BulletHitBoxArr[CurH].Width) And
        (Bullet.Y <= Enemy.HitBoxArr[CurH].Top + Enemy.HitBoxArr[CurH].Height) And (Bullet.Y >= Enemy.BulletHitBoxArr[CurH].Top);
End;

Procedure TShip.AddHitPoints(Enemy: TEnemy);
Begin
    If Enemy.EnType = 1 Then
        Inc(Self.Points, 200)
    Else
        Inc(Self.Points, 100);
End;

Procedure TShip.CheckBulletCollision(Enemy: TEnemy);
Var
    I, PosX, PosY: Integer;
Begin
    For I := Low(Enemy.HitBoxArr) To High(Enemy.HitBoxArr) Do
    Begin
        If CheckBulletBorders(Bullet, Enemy, I) Then
        Begin
            Self.Bullet.MoveBullet := False;
            Self.Bullet.FinishMove := True;

            Enemy.Hit := 1;
            Enemy.Bullet.MoveBullet := True;
            Enemy.Bullet.FinishMove := True;

            BASS_ChannelPlay(Enemy.EChanel, False);

            AddHitPoints(Enemy);
        End;
    End;
End;

Function TShip.CheckEnemyCollision(Enemy: TEnemy): Boolean;
Var
    I, J: Integer;
    EnemyHitBox: TArrHitBox;
Begin

    CheckEnemyCollision := False;

    EnemyHitBox := Enemy.HitBoxArr;

    If Self.Hit = 0 Then
    Begin
        For I := Low(Self.HitBoxArr) To High(Self.HitBoxArr) Do
        Begin
            For J := Low(EnemyHitBox) To High(EnemyHitBox) Do
            Begin
                If ((Self.HitBoxArr[I].Left <= EnemyHitBox[J].Left + EnemyHitBox[J].Width) And
                    (Self.HitBoxArr[I].Left + Self.HitBoxArr[I].Width >= EnemyHitBox[J].Left) And
                    (Self.HitBoxArr[I].Top <= EnemyHitBox[J].Top + EnemyHitBox[J].Height) And
                    (Self.HitBoxArr[I].Top + Self.HitBoxArr[I].Height >= EnemyHitBox[J].Top))

                    Or

                    (Self.HitBoxArr[I].Top >= 0) And (Enemy.Bullet.X >= Self.HitBoxArr[I].Left) And
                    (Enemy.Bullet.X <= Self.HitBoxArr[I].Left + Self.HitBoxArr[I].Width) And (Enemy.Bullet.Y >= Self.HitBoxArr[I].Top) And
                    (Enemy.Bullet.Y <= Self.HitBoxArr[I].Top + Self.HitBoxArr[I].Height)

                Then
                Begin
                    Enemy.ResetPosition();
                    Self.Hp.Hit();
                    Self.Hit := 1;

                    BASS_ChannelPlay(SChanel, False);

                    CheckEnemyCollision := True;

                    Exit;
                End;
            End;
        End;
    End;
End;

Procedure TShip.Draw(Canvas: TCanvas);
Begin
    If (Self.Hit > 0) Then
    Begin
        If (Self.Hit > 21) Then
        Begin
            Img := TBitmap.Create;
            Img.LoadFromFile(SHIP_PATH);
            Img.Height := Size;
            Img.Width := Size;
            Img.Transparent := True;

            Self.Hit := 0;
            PlayForm.RestartGame();
        End
        Else
        Begin
            Self.Img := Explosion[Self.Hit - 1];
            Inc(Self.Hit);
        End;

    End;

    Canvas.Draw(Self.X, Self.Y, Self.Img);
End;

End.
