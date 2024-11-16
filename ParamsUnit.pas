Unit ParamsUnit;

Interface

Uses
    Vcl.Graphics;

Type
    THitBox = Record
        Left, Top, Width, Height: Integer;
    End;

    TArrBk = Array [0 .. 1] Of TBitmap;

    TMoveBk = Record
        Left, Top1, Top2: Integer;
        Pict: TArrBk;
    End;

    TArrHitBox = Array Of THitBox;

    TBitmapArr = Array Of TBitmap;

    TSelect = Record
        Picture: TBitmap;
        Left, Top: Integer;
        Change: Integer;
        Pos, MinPos: Integer;
    End;

    TPicture = Record
        Img: TBitmap;
        X, Y: Integer;
    End;

Implementation

End.
