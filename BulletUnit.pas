Unit BulletUnit;

Interface

Uses
    Vcl.Graphics,
    System.SysUtils,
    System.DateUtils,
    BASS;

Type
    TBullet = Class
        Procedure Move(X, Y: Integer);
        Procedure ResetPosition(X, Y: Integer);
    Public
        Img: TBitmap;
        X, Y: Integer;
        SpeedX, SpeedY: Integer;
        MoveBullet, FinishMove: Boolean;
        LastShotTime, ReloadTime: TDateTime;
        BulletType: Integer;
        IsEnemyBullet: Boolean;

        SizeX, SizeY: Integer;
        BulletChanel: HSTREAM;

        Constructor Create(X, Y, SpeedX, SpeedY, ReloadTime, BulletType, Volume: Integer; IsEnemyBullet: Boolean);
    End;

Implementation

Uses
    EnemyUnit,
    ShipUnit;

Const
    IMG_PATHS = '.\images\';
    BULLET1_PATH = IMG_PATHS + 'bullet.bmp';
    BULLET2_PATH = IMG_PATHS + 'bullet2_n.bmp';

Constructor TBullet.Create(X, Y, SpeedX, SpeedY, ReloadTime, BulletType, Volume: Integer; IsEnemyBullet: Boolean);
Var
    FilePath: String;
Begin
    FilePath := '.\sounds\zap2.mp3';
    BulletChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE);
    BASS_ChannelSetAttribute(BulletChanel, BASS_ATTRIB_VOL, Volume * 10 / 100);

    Self.IsEnemyBullet := IsEnemyBullet;

    Img := TBitmap.Create;
    If BulletType = 0 Then
    Begin
        SizeX := 5;
        SizeY := 20;
        Img.LoadFromFile(BULLET1_PATH);
    End
    Else
    Begin
        SizeX := 20;
        SizeY := 20;
        Img.LoadFromFile(BULLET2_PATH);
    End;
    Img.Height := SizeY;
    Img.Width := SizeX;
    Img.Transparent := True;

    Self.SpeedX := SpeedX;
    Self.SpeedY := SpeedY;

    Self.X := X + (100 - SizeX) Div 2;
    Self.Y := Y + (100 - SizeY) Div 2;

    Self.MoveBullet := False;
    Self.FinishMove := False;

    Self.ReloadTime := ReloadTime;
End;

Procedure TBullet.Move(X, Y: Integer);
Begin
    If Self.MoveBullet Or Self.FinishMove Then
    Begin
        Self.Y := Self.Y - Self.SpeedY;
        Self.X := Self.X - Self.SpeedX;
    End
    Else
    Begin
        Self.ResetPosition(X, Y);
        If IsEnemyBullet And (Y >= 0) Then
            BASS_ChannelPlay(Self.BulletChanel, False);
    End;

    If (MilliSecondsBetween(Now, Self.LastShotTime) >= Self.ReloadTime) Then
        Self.ResetPosition(X, Y);
End;

Procedure TBullet.ResetPosition(X, Y: Integer);
Begin
    Self.X := X + (80 - SizeX) Div 2;
    Self.Y := Y + (80 - SizeY) Div 2;
    Self.MoveBullet := False;
    Self.FinishMove := False;
    Self.LastShotTime := Now;
End;

End.
