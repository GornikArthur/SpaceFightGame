Unit EnemyUnit;

Interface

Uses
    Vcl.Graphics,
    BulletUnit,
    ParamsUnit,
    BASS;

Type
    TEnemy = Class
        Procedure Move(Const MainShipX, MainShipY: Integer);
        Procedure MoveHitBoxArr();
        Procedure ResetPosition();
        Procedure Draw(Canvas: TCanvas);
    Public
        Img: TBitmap;
        X, Y, StartY: Integer;
        Speed: Integer;
        MoveEnemy: Boolean;
        HitBoxArr, BulletHitBoxArr: TArrHitBox;
        Bullet: TBullet;
        EnType: Integer;
        Hit: Integer;

        EChanel: HSTREAM;

    Const
        Size = 80;

        Constructor Create(Var LastEnemyY: Integer; Const Difficulty, EnType, Volume: Integer);
    End;

Implementation

Uses
    PlayUnit;

Const
    IMG_PATHS = '.\images\';
    ENEMY1_PATH = IMG_PATHS + 'enemy_main_80.bmp';
    ENEMY2_PATH = IMG_PATHS + 'enemy_main_80_hars.bmp';

Constructor TEnemy.Create(Var LastEnemyY: Integer; Const Difficulty, EnType, Volume: Integer);
Var
    FilePath: String;
Begin

    FilePath := '.\sounds\bang.mp3';
    EChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE);
    BASS_ChannelSetAttribute(EChanel, BASS_ATTRIB_VOL, Volume * 10 / 300);

    Self.EnType := EnType;

    Speed := EnemySpeed;

    Randomize;
    X := ScLeft + Random(ScRight - ScLeft - Size);
    LastEnemyY := LastEnemyY - Size * Difficulty;
    Y := LastEnemyY;

    Img := TBitmap.Create;
    If EnType = 0 Then
    Begin
        Img.LoadFromFile(ENEMY1_PATH);
        Bullet := TBullet.Create(X + Size Div 2, Y, 0, EnemyBulletSpeed, EnemyBulletReloadTime, 0, Volume, True);
    End
    Else
    Begin
        Img.LoadFromFile(ENEMY2_PATH);
        Bullet := TBullet.Create(X + Size Div 2, Y, 0, EnemyBulletSpeed, EnemyBulletReloadTime, 1, Volume, True);
    End;
    Img.Height := Size;
    Img.Width := Size;
    Img.Transparent := True;

    SetLength(HitBoxArr, 2);
    HitBoxArr[0].Width := Size;
    HitBoxArr[0].Height := 46;

    HitBoxArr[1].Width := 25;
    HitBoxArr[1].Height := 54;

    SetLength(BulletHitBoxArr, 2);
    BulletHitBoxArr[0].Width := Size;
    BulletHitBoxArr[0].Height := Size;

    BulletHitBoxArr[1].Width := 20;
    BulletHitBoxArr[1].Height := Size;

    Self.MoveHitBoxArr();

    MoveEnemy := False;

    Self.Hit := 0;
End;

Procedure TEnemy.MoveHitBoxArr();
Begin
    Self.HitBoxArr[0].Left := Self.X;
    Self.HitBoxArr[0].Top := Self.Y;

    Self.HitBoxArr[1].Left := Self.X + 36;
    Self.HitBoxArr[1].Top := Self.Y + 46;

    Self.BulletHitBoxArr[0].Left := Self.X;
    Self.BulletHitBoxArr[0].Top := Self.Y - ScDown Div 2;

    Self.BulletHitBoxArr[1].Left := Self.X + 36;
    Self.BulletHitBoxArr[1].Top := Self.Y - ScDown Div 2;
End;

Procedure TEnemy.Move(Const MainShipX, MainShipY: Integer);
Begin
    If MoveEnemy Then
    Begin

        Self.Bullet.ReloadTime := EnemyBulletReloadTime;
        Self.Speed := EnemySpeed;

        If (Y >= 0) And (X >= ScLeft) And (X <= ScRight) Then
        Begin
            If Self.EnType = 1 Then
                Self.Bullet.SpeedX := (MainShipX - Self.X) * Self.Bullet.SpeedY Div MainShipY;

            Self.Bullet.MoveBullet := True;
        End
        Else
            Self.Bullet.MoveBullet := False;

        Y := Y + Self.Speed;

        Self.Bullet.Move(Self.X, Self.Y);

        If Y >= ScDown Then
            Self.ResetPosition();

        Self.MoveHitBoxArr();
    End;
End;

Procedure TEnemy.ResetPosition();
Begin
    X := ScLeft + Random(ScRight - ScLeft - Size);
    Y := LastEnemyY - Size * Difficulty;
    LastEnemyY := Y;

    Self.MoveHitBoxArr();
End;

Procedure TEnemy.Draw(Canvas: TCanvas);
Begin
    If (Self.Hit > 0) Then
    Begin
        If (Self.Hit > 21) Then
        Begin
            Img := TBitmap.Create;
            If EnType = 0 Then
                Img.LoadFromFile(ENEMY1_PATH)
            Else
                Img.LoadFromFile(ENEMY2_PATH);
            Img.Height := Size;
            Img.Width := Size;
            Img.Transparent := True;

            Self.Hit := 0;

            Self.ResetPosition();
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
