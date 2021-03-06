{----------------------------------------------------------------------------
|
| Library: Envision
|
| Module: EnGmb
|
| Description: Wrapper routines to use GBM library
|
| History: Feb 28, 1999. Michel Brazeau, first version
|
|---------------------------------------------------------------------------}
unit EnGbm;

{$I Envision.Inc}

interface

uses
    Windows,  { for TMaxLogPalette }
    Classes,  { for TStream }
    SysUtils, { for Exception }
    EnMisc,   { for TEnvisionProgressEvent, TImageFormat }
    EnDiGrph; { for TDibGraphic }

{ load a TDibGraphic from a stream using the GBM library. SampleFileName
  must include the extension to indicate the file type. Only pcx and
  tga files can be loaded with GBM. }
{$WARNINGS OFF}
procedure LoadGraphicWithGbm( const Stream         : TStream;
                              const Graphic        : TDibGraphic;
                              const SampleFileName : AnsiString;
                              const Options        : PAnsiChar;
                              const ProgressEvent  : TEnvisionProgressEvent );
{$WARNINGS ON}

procedure SaveGraphicWithGbm( const Stream         : TStream;
                              const Graphic        : TDibGraphic;
                              const SampleFileName : AnsiString;
                              const ProgressEvent  : TEnvisionProgressEvent );

type

EGbmError = class(Exception);

{--------------------------------------------------------------------------}

implementation

uses
    EnCLib,   { for gbm_read_reader ... }
    EnTransf, { for TNegativeTransform }
    EnMsg;    { for XXXXStr }

{--------------------------------------------------------------------------}

procedure GbmToLogPalette( const GbmPalette : TGbmPalette;
                           const ColorCount : Integer;
                           var   Palette    : TMaxLogPalette );
var
    Index               : Integer;

begin
    FillChar(Palette, SizeOf(Palette), 0);

    Palette.palNumEntries := ColorCount;
    Palette.palVersion    := $0300;

    for Index := 0 to (ColorCount-1) do
    begin
        { blue and red values are reversed }
        Palette.palPalEntry[Index].peRed :=
                             GbmPalette[Index].R;
        Palette.palPalEntry[Index].peGreen :=
                             GbmPalette[Index].G;
        Palette.palPalEntry[Index].peBlue :=
                             GbmPalette[Index].B;

    end;
end;

{--------------------------------------------------------------------------}

procedure LogToGbmPalette( const Palette    : TMaxLogPalette;
                           var   GbmPalette : TGbmPalette
                          );
var
    Index               : Integer;

begin
    FillChar(GbmPalette, SizeOf(GbmPalette), 0);

    for Index := 0 to (Palette.palNumEntries-1) do
    begin
        { blue and red values are reversed }
        GbmPalette[Index].B := Palette.palPalEntry[Index].peBlue;
        GbmPalette[Index].G := Palette.palPalEntry[Index].peGreen;
        GbmPalette[Index].R := Palette.palPalEntry[Index].peRed;
    end;
end;

{--------------------------------------------------------------------------}

procedure GbmProgress( Progress     : ShortInt;
                       CallBackData : LongInt ); cdecl;
var
    Graphic : TDibGraphic;
begin
    {$WARNINGS OFF}
    Graphic := TDibGraphic(CallBackData);
    {$WARNINGS ON}

    DoProgress( Graphic, Graphic.OnReadWriteProgress, Progress, 0, 100, -1 );
end;

{--------------------------------------------------------------------------}
{$WARNINGS OFF}
procedure LoadGraphicWithGbm( const Stream         : TStream;
                              const Graphic        : TDibGraphic;
                              const SampleFileName : AnsiString;
                              const Options        : PAnsiChar;
                              const ProgressEvent  : TEnvisionProgressEvent );
var
    Gbm         : TGbm;
    FileType    : Integer;
    Palette     : TMaxLogPalette;
    pPalette    : PMaxLogPalette;
    ImageFormat : TImageFormat;
    GbmPalette  : TGbmPalette;
    LastPercent : ShortInt;

    Negative          : Boolean;
    NegativeTransform : TNegativeTransform;

begin
    Negative := False;
    LastPercent := -1;
    DoProgress( Graphic, ProgressEvent, 0, 0, 100, LastPercent );

    if gbm_guess_filetype( PAnsiChar(SampleFileName), @FileType) <> GBM_ERR_OK then
        raise EGbmError.Create( 'gbm_guess_filetype failed.');

    FillChar(Gbm, SizeOf(Gbm), 0);
    if gbm_read_header( PAnsiChar(SampleFileName), Integer(Stream), FileType,
                        @Gbm, Options ) <> GBM_ERR_OK then
        raise EGbmError.Create( 'gbm_read_header failed.');

    case Gbm.Bpp of
        1:  ImageFormat := ifBlackWhite;
        4:  ImageFormat := ifColor16;
        8:  ImageFormat := ifColor256;
        24: ImageFormat := ifTrueColor;
        else
            raise EGbmError.Create(msgInvalidImageFormat);
    end;

    if ImageFormat <> ifTrueColor then
    begin
        FillChar(GbmPalette, SizeOf(GbmPalette), 0);
        if gbm_read_palette( Integer(Stream), FileType,
                             @Gbm, @GbmPalette[0] ) <> GBM_ERR_OK then
            raise EGbmError.Create( 'gbm_read_header failed.');

        { MB Aug 4, 2003. Problem reported by Katerina Sedivy, loading a bmp
          with inverted palette, then saving a tiff, results in inverted tif file }
        Negative := (ImageFormat = ifBlackWhite) and
                    (GbmPalette[1].R = 0) and
                    (GbmPalette[1].G = 0) and
                    (GbmPalette[1].B = 0);

        if Negative then
        begin
            GbmPalette[1].R := 255;
            GbmPalette[1].G := 255;
            GbmPalette[1].B := 255;

            GbmPalette[0].R := 0;
            GbmPalette[0].G := 0;
            GbmPalette[0].B := 0;
        end;


        GbmToLogPalette( GbmPalette, 1 shl (Gbm.Bpp), Palette );

        pPalette := @Palette;
    end
    else
        pPalette := nil;

    Graphic.NewImage( Gbm.W, Gbm.H, ImageFormat, pPalette, 0, 0 );

    if gbm_read_data( Integer(Stream), FileType,
                      @Gbm, Graphic.Bits, GbmProgress, LongInt(Graphic) ) <> GBM_ERR_OK then
            raise EGbmError.Create( 'gbm_read_data failed.');

    if Negative then
    begin
        NegativeTransform := TNegativeTransform.Create;
        try
            NegativeTransform.Apply(Graphic);
        finally
            NegativeTransform.Free;
        end;
    end;


    DoProgress( Graphic, ProgressEvent, 100, 0, 100, LastPercent );

end;

{--------------------------------------------------------------------------}

procedure SaveGraphicWithGbm( const Stream         : TStream;
                              const Graphic        : TDibGraphic;
                              const SampleFileName : AnsiString;
                              const ProgressEvent  : TEnvisionProgressEvent );
var
    Gbm         : TGbm;
    FileType    : Integer;
    GbmPalette  : TGbmPalette;

begin
    if gbm_guess_filetype( PAnsiChar(SampleFileName), @FileType) <> GBM_ERR_OK then
        raise EGbmError.Create( 'gbm_guess_filetype failed.');

    FillChar(Gbm, SizeOf(Gbm), 0);
    Gbm.W := Graphic.Width;
    Gbm.H := Graphic.Height;

    case Graphic.ImageFormat of
        ifBlackWhite          : Gbm.Bpp := 1;
        ifColor16, ifGray16   : Gbm.Bpp := 4;
        ifColor256, ifGray256 : Gbm.Bpp := 8;
        ifTrueColor           : Gbm.Bpp := 24;
        else
            raise EGbmError.Create(msgInvalidImageFormat);
    end;

    if Graphic.ImageFormat <> ifTrueColor then
        LogToGbmPalette( Graphic.Palette, GbmPalette )
    else
        FillChar(GbmPalette, SizeOf(GbmPalette), 0);

    if gbm_write( PAnsiChar(SampleFileName), Integer(Stream), FileType,
                  @Gbm, @GbmPalette, Graphic.Bits, PAnsiChar(''), GbmProgress, LongInt(Graphic) ) <> GBM_ERR_OK then
            raise EGbmError.Create( 'gbm_write failed.');

end;
{$WARNINGS ON}

{--------------------------------------------------------------------------}

initialization

    gbm_init;

finalization

    gbm_deinit;

end.

