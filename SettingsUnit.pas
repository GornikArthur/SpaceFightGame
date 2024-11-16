Unit SettingsUnit;

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
    Bass,
    Vcl.StdCtrls,
    MenuUnit,
    ParamsUnit;

Type
    TSettingsForm = Class(TForm)
        MusicLabel: TLabel;
        EffectsLabel: TLabel;
        NavigateLabel: TLabel;
        ExitLabel: TLabel;
        ESCLabel: TLabel;
        EVol: TLabel;
        MVol: TLabel;
        Procedure FormActivate(Sender: TObject);
        Procedure FormPaint(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

    Volume = Record
        LineImg, MiksherImg: TBitmap;
        LineX, LineY: Integer;
        MiksherX, MiksherY: Integer;
        Val: TLabel;
    End;

Var
    SettingsForm: TSettingsForm;
    VolumeArr: Array Of Volume;
    Current: Integer;
    ChooseElem, MoveImg, ExitImg: TPicture;

Implementation

{$R *.dfm}

Const
    IMG_PATHS = '.\images\';
    VOLUME_LINE_PATH = IMG_PATHS + 'volume_line.bmp';
    VOLUME_MIKSHER_PATH = IMG_PATHS + 'volume_set.bmp';
    CHOOSE_PATH = IMG_PATHS + 'Chose.bmp';
    MOVE_IMG_PATH = IMG_PATHS + 'game_move.bmp';
    ESC_PATH = IMG_PATHS + 'esc.bmp';

Var
    EffectsChanel: HSTREAM;

Procedure TSettingsForm.FormActivate(Sender: TObject);
Var
    ScCenterW, ScCenterH: Integer;
    FilePath: String;
Begin

    Self.Color := ClBlack;

    SetLength(VolumeArr, 2);
    VolumeArr[0].LineImg := TBitmap.Create;
    VolumeArr[0].LineImg.LoadFromFile(VOLUME_LINE_PATH);
    VolumeArr[0].LineImg.Height := 880;
    VolumeArr[0].LineImg.Width := 30;

    VolumeArr[0].MiksherImg := TBitmap.Create;
    VolumeArr[0].MiksherImg.LoadFromFile(VOLUME_MIKSHER_PATH);
    VolumeArr[0].MiksherImg.Height := 80;
    VolumeArr[0].MiksherImg.Width := 100;

    VolumeArr[1].LineImg := TBitmap.Create;
    VolumeArr[1].LineImg.LoadFromFile(VOLUME_LINE_PATH);
    VolumeArr[1].LineImg.Height := 880;
    VolumeArr[1].LineImg.Width := 30;

    VolumeArr[1].MiksherImg := TBitmap.Create;
    VolumeArr[1].MiksherImg.LoadFromFile(VOLUME_MIKSHER_PATH);
    VolumeArr[1].MiksherImg.Height := 80;
    VolumeArr[1].MiksherImg.Width := 100;

    ScCenterW := Screen.Width Div 2;
    ScCenterH := Screen.Height Div 2;

    VolumeArr[0].LineX := ScCenterW - 300;
    VolumeArr[0].MiksherX := VolumeArr[0].LineX - (VolumeArr[0].MiksherImg.Width - VolumeArr[0].LineImg.Width) Div 2;
    VolumeArr[0].LineY := ScCenterH - VolumeArr[0].LineImg.Height Div 2;
    VolumeArr[0].MiksherY := VolumeArr[0].LineY + (10 - MusicVol) * VolumeArr[0].MiksherImg.Height;

    VolumeArr[1].LineX := ScCenterW + 300;
    VolumeArr[1].MiksherX := VolumeArr[1].LineX - (VolumeArr[1].MiksherImg.Width - VolumeArr[1].LineImg.Width) Div 2;
    VolumeArr[1].LineY := VolumeArr[0].LineY;
    VolumeArr[1].MiksherY := VolumeArr[0].LineY + (10 - EffectsVol) * VolumeArr[0].MiksherImg.Height;

    VolumeArr[0].Val := MVol;
    VolumeArr[0].Val.Left := VolumeArr[0].MiksherX + VolumeArr[0].MiksherImg.Width Div 3;
    VolumeArr[0].Val.Top := VolumeArr[0].MiksherY + VolumeArr[0].MiksherImg.Height Div 4;
    VolumeArr[0].Val.Caption := IntToStr(MusicVol);

    VolumeArr[1].Val := EVol;
    VolumeArr[1].Val.Left := VolumeArr[1].MiksherX + VolumeArr[1].MiksherImg.Width Div 3;
    VolumeArr[1].Val.Top := VolumeArr[1].MiksherY + VolumeArr[1].MiksherImg.Height Div 4;
    VolumeArr[1].Val.Caption := IntToStr(EffectsVol);

    MusicLabel.Left := VolumeArr[0].LineX - MusicLabel.Width Div 2;
    MusicLabel.Top := VolumeArr[0].LineY - 30 - MusicLabel.Height;

    EffectsLabel.Left := VolumeArr[1].LineX - EffectsLabel.Width Div 2 + 20;
    EffectsLabel.Top := MusicLabel.Top;

    ChooseElem.Img := TBitmap.Create;
    ChooseElem.Img.LoadFromFile(CHOOSE_PATH);
    ChooseElem.Img.Height := 30;
    ChooseElem.Img.Width := 30;
    ChooseElem.X := VolumeArr[Current].LineX;
    ChooseElem.Y := VolumeArr[0].LineY + VolumeArr[0].LineImg.Height + 10;

    MoveImg.Img := TBitmap.Create;
    MoveImg.Img.LoadFromFile(MOVE_IMG_PATH);
    MoveImg.Img.Height := 144;
    MoveImg.Img.Width := 218;
    MoveImg.X := (LeftBord - MoveImg.Img.Width) Div 2;
    MoveImg.Y := Screen.Height Div 2 - MoveImg.Img.Height;

    NavigateLabel.Top := MoveImg.Y - NavigateLabel.Height - 10;
    NavigateLabel.Left := (LeftBord - NavigateLabel.Width) Div 2;

    ExitImg.Img := TBitmap.Create;
    ExitImg.Img.LoadFromFile(ESC_PATH);
    ExitImg.Img.Height := 57;
    ExitImg.Img.Width := 114;
    ExitImg.X := (LeftBord - ExitImg.Img.Width) Div 2;
    ExitImg.Y := Screen.Height Div 2 + MoveImg.Img.Height;

    ESCLabel.Top := ExitImg.Y + 11;
    ESCLabel.Left := (LeftBord - ESCLabel.Width) Div 2;

    ExitLabel.Top := ExitImg.Y - ExitLabel.Height - 10;
    ExitLabel.Left := (LeftBord - ExitLabel.Width) Div 2;

    FilePath := '.\sounds\zap2.mp3';
    EffectsChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE);
    BASS_ChannelSetAttribute(EffectsChanel, BASS_ATTRIB_VOL, EffectsVol * 10 / 100);
End;

Procedure TSettingsForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    FilePath: String;
Begin
    If (Key = VK_ESCAPE) Then
    Begin
        BASS_ChannelPlay(MenuForm.MenuChanel, False);
        Close;
    End
    Else
        If (Key = VK_F4) And (SsAlt In Shift) Then
            Key := 0
        Else
            If (Key = Vk_Up) And (VolumeArr[Current].MiksherY > VolumeArr[Current].LineY) Then
            Begin
                Dec(VolumeArr[Current].MiksherY, VolumeArr[Current].MiksherImg.Height);
                VolumeArr[Current].Val.Top := VolumeArr[Current].Val.Top - VolumeArr[Current].MiksherImg.Height;

                If Current = 1 Then
                    BASS_ChannelPlay(EffectsChanel, False);

            End
            Else
                If (Key = Vk_Down) And (VolumeArr[Current].MiksherY < VolumeArr[Current].LineY + VolumeArr[Current].LineImg.Height -
                    VolumeArr[Current].MiksherImg.Height) Then
                Begin
                    Inc(VolumeArr[Current].MiksherY, VolumeArr[Current].MiksherImg.Height);
                    VolumeArr[Current].Val.Top := VolumeArr[Current].Val.Top + VolumeArr[Current].MiksherImg.Height;

                    If Current = 1 Then
                        BASS_ChannelPlay(EffectsChanel, False);
                End
                Else
                    If (Key = Vk_Right) Then
                    Begin
                        Inc(Current);
                        If Current > 1 Then
                            Current := 0;
                    End
                    Else
                        If (Key = Vk_Left) Then
                        Begin
                            Dec(Current);
                            If Current < 0 Then
                                Current := 1;
                        End;

    ChooseElem.X := VolumeArr[Current].LineX;

    If (Current = 1) And ((Key = Vk_Right) Or (Key = Vk_Left)) Then
    Begin
        BASS_ChannelPlay(MenuForm.MenuChanel, False);
        BASS_ChannelStop(MenuForm.MenuChanel);
    End
    Else
        If (Current = 0) And ((Key = Vk_Right) Or (Key = Vk_Left)) Then
        Begin
            BASS_ChannelPlay(MenuForm.MenuChanel, False);
        End;

    EffectsVol := 10 - (VolumeArr[1].MiksherY - VolumeArr[1].LineY) Div VolumeArr[1].MiksherImg.Height;
    MusicVol := 10 - (VolumeArr[0].MiksherY - VolumeArr[0].LineY) Div VolumeArr[0].MiksherImg.Height;
    BASS_ChannelSetAttribute(MenuForm.MenuChanel, BASS_ATTRIB_VOL, MusicVol / 10);
    BASS_ChannelSetAttribute(EffectsChanel, BASS_ATTRIB_VOL, EffectsVol / 10);

    If Current = 0 Then
        VolumeArr[Current].Val.Caption := IntToStr(MusicVol)
    Else
        VolumeArr[Current].Val.Caption := IntToStr(EffectsVol);

    VolumeArr[Current].Val.Left := VolumeArr[Current].MiksherX + VolumeArr[Current].MiksherImg.Width Div 3;

    Invalidate;
End;

Procedure TSettingsForm.FormPaint(Sender: TObject);
Var
    I: Integer;
Begin
    For I := 0 To 1 Do
    Begin
        Canvas.Draw(VolumeArr[I].LineX, VolumeArr[I].LineY, VolumeArr[I].LineImg);
        Canvas.Draw(VolumeArr[I].MiksherX, VolumeArr[I].MiksherY, VolumeArr[I].MiksherImg);
    End;
    Canvas.Draw(ChooseElem.X, ChooseElem.Y, ChooseElem.Img);
    Canvas.Draw(MoveImg.X, MoveImg.Y, MoveImg.Img);
    Canvas.Draw(ExitImg.X, ExitImg.Y, ExitImg.Img);

End;

End.
