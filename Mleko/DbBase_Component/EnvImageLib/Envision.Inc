{----------------------------------------------------------------------------
|
| Library: Envision
|
| Module: Envision.Inc
|
| Description: Include for to define global compilation constants
|
| History: Dec 03, 1998. Michel Brazeau, first version
|
|---------------------------------------------------------------------------}

{$B-}  { Complete boolean evaluation off. DO NOT CHANGE }
{$H+}  { Long strings. DO NOT CHANGE }
{$X+}  { Extended syntax. DO NOT CHANGE }

{$ifdef __EnvisionDebug}
    {$R+,Q+,O-,I+}
{$else}
    {$R-,Q-,O+,I-}
{$endif}

{$ifdef Ver90}
    {$define __Delphi2}
    {$define __Delphi2AndAbove}
{$endif}

{$ifdef Ver100}
    {$define __Delphi3}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
{$endif}

{$ifdef Ver120}
    {$define __Delphi4}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
{$endif}

{$ifdef Ver130}
    {$define __Delphi5}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
{$endif}

{$ifdef Ver140}
    {$define __Delphi6}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
    {$define __Delphi6AndAbove}
{$endif}

{$ifdef Ver150}
    {$define __Delphi7}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
    {$define __Delphi6AndAbove}
    {$define __Delphi7AndAbove}
{$endif}

{$ifdef Ver170}
    {$define __Delphi2005}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
    {$define __Delphi6AndAbove}
    {$define __Delphi7AndAbove}
    {$define __Delphi2005AndAbove}
{$endif}

{$ifdef Ver180}
    {$define __Delphi2006}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
    {$define __Delphi6AndAbove}
    {$define __Delphi7AndAbove}
    {$define __Delphi2005AndAbove}
    {$define __Delphi2006AndAbove}
{$endif}

{$ifdef Ver190}
    {$define __Delphi2007}
    {$define __Delphi2AndAbove}
    {$define __Delphi3AndAbove}
    {$define __Delphi4AndAbove}
    {$define __Delphi5AndAbove}
    {$define __Delphi6AndAbove}
    {$define __Delphi7AndAbove}
    {$define __Delphi2005AndAbove}
    {$define __Delphi2006AndAbove}
    {$define __Delphi2007AndAbove}
{$endif}


{$ifdef Ver93}
    {$define __CBuilder1}
    {$define __CBuilder1AndAbove}
{$endif}

{$ifdef Ver110}
    {$define __CBuilder3}
    {$define __CBuilder1AndAbove}
    {$define __CBuilder3AndAbove}
{$endif}

{$ifdef Ver125}
    {$define __CBuilder4}
    {$define __CBuilder1AndAbove}
    {$define __CBuilder3AndAbove}
    {$define __CBuilder4AndAbove}
{$endif}

{$ifdef Ver135}
    {$define __CBuilder5}
    {$define __CBuilder1AndAbove}
    {$define __CBuilder3AndAbove}
    {$define __CBuilder4AndAbove}
    {$define __CBuilder5AndAbove}
{$endif}

{ conditional constants to register graphic file formats with
  TPicture. To disable, put a period (.) before the dollar ($)
  If a format is not defined, TPicture.LoadFromFile will not
  recognize the file extension. 
}


{ MB May 1, 1999. Do not replace TBitmap, TIcon, and TMetafile by default,
  as this interferes with at design time with forms containing these
  graphics.

  MB Sep 26, 1999. The VCL classes are no longer unregistered, so it is safe
  to have both VCL and Envision classes registered; for example both TBitmap
  and TBitmapGraphic may be registered, and a form may contain both types
  of graphics at design-time.

  Note that the TImageList component does not integrate with graphic classes
  other than TBitmap and TIcon.

  MB Feb 20, 2002. It seems that TSpeedButton and TBitBtn will not load bitmaps
  if TBitmapGraphic is registered at design time. This has been verified in
  Delphi 6.
}
{.$define __RegisterEnvisionBmp}
{.$define __RegisterEnvisionIco}
{.$define __RegisterEnvisionWmf}

{$define __RegisterEnvisionTif}
{$define __RegisterEnvisionPng}
{$define __RegisterEnvisionJpg}
{$define __RegisterEnvisionTga}
{$define __RegisterEnvisionPcx}
{$define __RegisterEnvisionDcx}
{$define __RegisterEnvisionEps}
{$define __RegisterEnvisionPpm}
{$define __RegisterEnvisionPdf}

