Unit HPUnit;

Interface

Uses
    Vcl.Graphics;

Type
    THPBitArr = Array [0 .. 2] Of TBitmap;

Type
    THP = Class
    Public
        Left, Top: Integer;
        HPBitArr: THPBitArr;
        CurHp: Integer;

    Const
        Size = 30;

        Constructor Create();
        Procedure Hit();
        Procedure LoadHit();
    End;

Const
    IMG_PATHS = '.\images\';
    HP_FULL = IMG_PATHS + 'hp_full.bmp';
    HP_EMPTY = IMG_PATHS + 'hp_empty.bmp';

Implementation

Uses
    PlayUnit;

Constructor THP.Create();
Var
    I: Integer;
Begin
    For I := 0 To 2 Do
    Begin
        HPBitArr[I] := TBitmap.Create;
        HPBitArr[I].LoadFromFile(HP_FULL);
        HPBitArr[I].Height := Size;
        HPBitArr[I].Width := Size;
        HPBitArr[I].Transparent := True;
    End;

    CurHp := 3;
    Left := ScLeft - 120;
    Top := 10;
End;

Procedure THP.Hit();
Begin
    If CurHp > 0 Then
    Begin
        Dec(Self.CurHp);
        HPBitArr[Self.CurHp].LoadFromFile(HP_EMPTY);
    End
End;

Procedure THP.LoadHit();
Var
    LoadHp: Integer;
Begin
    LoadHp := 0;
    While (LoadHp < CurHp) Do
    Begin
        HPBitArr[LoadHp].LoadFromFile(HP_FULL);
        Inc(LoadHp);
    End;

    While (LoadHp < 3) Do
    Begin
        HPBitArr[LoadHp].LoadFromFile(HP_EMPTY);
        Inc(LoadHp);
    End
End;

End.
