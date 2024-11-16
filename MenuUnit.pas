Unit MenuUnit;

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
    Vcl.Buttons,
    BASS,
    PlayUnit,
    Contnrs,
    ShipUnit,
    System.DateUtils,
    StopUnit,
    ParamsUnit;

Type
    TMenuForm = Class(TForm)
        NameLabel: TLabel;
        PlayLabel: TLabel;
        SettingsLabel: TLabel;
        ExitLabel: TLabel;
        LoadLabel: TLabel;
        OpenDialog: TOpenDialog;
        RecordLabel: TLabel;
        RecordNumLabel: TLabel;
        DeveloperLabel: TLabel;
        NavigateLabel: TLabel;
        ChooseLabel: TLabel;
        Procedure FormCreate(Sender: TObject);
        Procedure FormPaint(Sender: TObject);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Procedure Load(Sender: TObject);
        Procedure GetPath(Var Path: String);
    Private
        { Private declarations }
    Public
        MenuChanel: HSTREAM;
    End;

Var
    MenuForm: TMenuForm;
    EffectsVol, MusicVol: Integer;
    Data: TSaveData;
    Cursor1, Cursor2: HCursor;
    LeftBord: Integer;

Implementation

Uses
    SettingsUnit;

Type
    TMenuItem = Record
        Left, Top: Integer;
        Text: String;
        Pos: Integer;
    End;

    TMenuArr = Array [0 .. 4] Of TMenuItem;

    TSelect = Record
        Picture: TBitmap;
        Left, Top: Integer;
        Change: Integer;
        Pos: Integer;
    End;

Var
    BKBitmap: TBitmap;
    MenuMoveImg, EnterImg: TPicture;
    Select: TSelect;
    MenuElements: TMenuArr;
    FilePath: String;
    {$R *.dfm}

Const
    IMG_PATHS = '.\images\';
    BK_PATH = IMG_PATHS + 'Menu_BK.bmp';
    SELECT_PATH = IMG_PATHS + 'select.bmp';
    MENU_MOVE_PATH = IMG_PATHS + 'menu_move.bmp';
    ENTER_PATH = IMG_PATHS + 'enter_button.bmp';

Procedure TMenuForm.FormCreate(Sender: TObject);
Var
    ScCenterW: Integer;
Begin
    LeftBord := 420;

    Cursor1 := CopyIcon(Screen.Cursors[CrDefault]);
    Cursor2 := LoadCursorFromFile('c:\blank.cur');
    SetSystemCursor(Cursor2, OCR_NORMAL);

    BKBitmap := TBitmap.Create;
    BKBitmap.LoadFromFile(BK_PATH);
    BKBitmap.Height := Screen.Height;
    BKBitmap.Width := Screen.Width;

    MenuMoveImg.Img := TBitmap.Create;
    MenuMoveImg.Img.LoadFromFile(MENU_MOVE_PATH);
    MenuMoveImg.Img.Height := 144;
    MenuMoveImg.Img.Width := 70;
    MenuMoveImg.X := (LeftBord - MenuMoveImg.Img.Width) Div 2;
    MenuMoveImg.Y := Screen.Height Div 2 - MenuMoveImg.Img.Height;

    NavigateLabel.Top := MenuMoveImg.Y - NavigateLabel.Height - 2;
    NavigateLabel.Left := (MenuMoveImg.X + NavigateLabel.Width) Div 8;

    EnterImg.Img := TBitmap.Create;
    EnterImg.Img.LoadFromFile(ENTER_PATH);
    EnterImg.Img.Height := 144;
    EnterImg.Img.Width := 151;
    EnterImg.X := (LeftBord - EnterImg.Img.Width) Div 2 - 25;
    EnterImg.Y := Screen.Height Div 2 + EnterImg.Img.Height;

    ChooseLabel.Top := EnterImg.Y - ChooseLabel.Height - 2;
    ChooseLabel.Left := (EnterImg.X + ChooseLabel.Width) Div 4;

    ScCenterW := Screen.Width Div 2;

    NameLabel.Left := ScCenterW - NameLabel.Width Div 2;
    NameLabel.Top := NameLabel.Height * 2;

    PlayLabel.Left := ScCenterW - PlayLabel.Width Div 2;
    PlayLabel.Top := NameLabel.Top + NameLabel.Height + 40;

    LoadLabel.Left := ScCenterW - LoadLabel.Width Div 2;
    LoadLabel.Top := PlayLabel.Top + LoadLabel.Height + 40;

    SettingsLabel.Left := ScCenterW - SettingsLabel.Width Div 2;
    SettingsLabel.Top := LoadLabel.Top + PlayLabel.Height + 40;

    ExitLabel.Left := ScCenterW - ExitLabel.Width Div 2;
    ExitLabel.Top := SettingsLabel.Top + SettingsLabel.Height + 40;

    RecordLabel.Left := ScCenterW - (RecordLabel.Width + RecordNumLabel.Width) Div 2;
    RecordLabel.Top := ExitLabel.Top + RecordLabel.Height + 80;

    RecordNumLabel.Left := RecordLabel.Left + RecordLabel.Width + 2;
    RecordNumLabel.Top := RecordLabel.Top;

    DeveloperLabel.Left := ScCenterW - DeveloperLabel.Width Div 2 + 20;
    DeveloperLabel.Top := Screen.Height - DeveloperLabel.Height - 2;

    Select.Picture := TBitmap.Create;
    Select.Picture.LoadFromFile(SELECT_PATH);
    Select.Picture.TransparentColor := ClBlack;
    Select.Picture.Transparent := True;
    Select.Left := ScCenterW - Select.Picture.Width Div 2;
    Select.Top := PlayLabel.Top - 16;
    Select.Change := ExitLabel.Top - SettingsLabel.Top;
    Select.Pos := 0;

    ShowCursor(False);

    BASS_Free;

    IF Not(BASS_Init(-1, 44100, 0, 0, Nil)) Then
        ShowMessage('Err');

    FilePath := '.\sounds\menu.mp3';
    MenuChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE Or BASS_SAMPLE_LOOP);

    BASS_ChannelSetAttribute(MenuChanel, BASS_ATTRIB_VOL, 10 / 100);

    BASS_ChannelPlay(MenuChanel, False);

    MusicVol := 1;
    EffectsVol := 1;

    Data.Ship.Points := 0;

End;

Procedure TMenuForm.GetPath(Var Path: String);
Begin
    ShowCursor(True);
    If OpenDialog.Execute Then
    Begin
        Path := OpenDialog.FileName;
    End
    Else
    Begin
        MessageBox(Handle, PChar('Opening the file canceled.'), PChar('Cancel'), MB_OK + MB_ICONWARNING);
        ShowCursor(False);
    End;
End;

Procedure TMenuForm.Load(Sender: TObject);
Var
    Path: String;
    TypedFile: File Of TSaveData;
Begin
    Path := '';
    GetPath(Path);

    If Path <> '' Then
    Begin
        Try
            If (ExtractFileExt(Path) = '.astr') Then
            Begin
                If Length(Path) > 0 Then
                Begin
                    AssignFile(TypedFile, Path);

                    Reset(TypedFile);
                    Read(TypedFile, Data);

                    If (Data.Ship.Points < 0) Then
                        MessageBox(Handle, PChar('Error while reading file.'), PChar('Error'), MB_OK + MB_ICONWARNING)
                    Else
                        MessageBox(Handle, PChar('Successfull read from file.'), PChar('Read'), MB_OK + MB_ICONINFORMATION);

                    If Data.Ship.Hp = 0 Then
                    Begin
                        RecordNumLabel.Caption := IntToStr(Data.Ship.Points);
                        RecordLabel.Left := Screen.Width Div 2 - (RecordLabel.Width + RecordNumLabel.Width) Div 2;
                        RecordNumLabel.Left := RecordLabel.Left + RecordLabel.Width + 2;
                    End;
                    CloseFile(TypedFile);
                End;
            End
            Else
                MessageBox(Handle, PChar('Incorrect file type.'), PChar('Error'), MB_OK + MB_ICONWARNING);

        Except
            MessageBox(Handle, PChar('Error while reading file.'), PChar('Error'), MB_OK + MB_ICONWARNING);
        End;
        ShowCursor(False);
    End;
End;

Procedure TMenuForm.FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Var
    Skey: Word;
    PlayForm: TPlayForm;
    SettingsForm: TSettingsForm;
Begin
    Skey := Key;

    If Key = 13 Then
    Begin
        Case Select.Pos Of
            0:
                Begin
                    BASS_ChannelStop(MenuChanel);

                    PlayForm := TPlayForm.Create(Self);
                    PlayForm.ShowModal;
                    PlayForm.Free;

                    BASS_Free;

                    IF Not(BASS_Init(-1, 44100, 0, 0, Nil)) Then
                        ShowMessage('Err');

                    FilePath := '.\sounds\menu.mp3';
                    MenuForm.MenuChanel := BASS_StreamCreateFile(False, PChar(FilePath), 0, 0, BASS_UNICODE Or BASS_SAMPLE_LOOP);

                    BASS_ChannelSetAttribute(MenuForm.MenuChanel, BASS_ATTRIB_VOL, MusicVol * 10 / 100);

                    BASS_ChannelPlay(MenuForm.MenuChanel, False);

                End;
            1:
                Begin
                    Load(Self);
                End;
            2:
                Begin
                    SettingsForm := TSettingsForm.Create(Self);
                    SettingsForm.ShowModal;
                    SettingsForm.Free;
                End;
            3:
                Application.Terminate;
        End;

    End
    Else
        If (Key = VK_F4) And (SsAlt In Shift) Then
            Key := 0
        Else
        Begin

            If Key = Vk_Up Then
            Begin
                Dec(Select.Pos);
                Dec(Select.Top, Select.Change)
            End
            Else
                If Key = Vk_Down Then
                Begin
                    Inc(Select.Pos);
                    Inc(Select.Top, Select.Change);
                End;

            If Select.Top < PlayLabel.Top - 16 Then
            Begin
                Select.Pos := 3;
                Select.Top := ExitLabel.Top - 16
            End
            Else
                If Select.Top > ExitLabel.Top Then
                Begin
                    Select.Pos := 0;
                    Select.Top := PlayLabel.Top - 16;
                End;
        End;
    Invalidate;
End;

Procedure TMenuForm.FormPaint(Sender: TObject);
Var
    I: Integer;
Begin
    Canvas.Draw(0, 0, BKBitmap);
    Canvas.Draw(Select.Left, Select.Top, Select.Picture);

    Canvas.Draw(MenuMoveImg.X, MenuMoveImg.Y, MenuMoveImg.Img);
    Canvas.Draw(EnterImg.X, EnterImg.Y, EnterImg.Img);
End;

End.
