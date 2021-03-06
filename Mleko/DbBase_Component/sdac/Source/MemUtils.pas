
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright � 1998-2007 Core Lab. All right reserved.
//  Mem Data
//  Created:            06.11.03
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit MemUtils;
{$ENDIF}
interface
uses
  Classes, SysUtils, {$IFDEF VER6P}Variants, {$ENDIF}
{$IFDEF HAVE_COMPRESS_INTERNAL}
  ZLib, ZLibConst,
{$ENDIF}
{$IFDEF LINUX}
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF CLR}
  System.Xml,
  System.Runtime.InteropServices;
{$ELSE}
  CLRClasses;
{$ENDIF}

{$IFNDEF VER6P}
const
  varShortInt = $0010; { vt_i1          }
  varWord     = $0012; { vt_ui2         }
  varLongWord = $0013; { vt_ui4         }
  varInt64    = $0014; { vt_i8          }

type
  TVarType = Word;
{$ENDIF}

{$IFDEF CLR}
const
  wsAttribute: System.Xml.WriteState = System.Xml.WriteState.Attribute;
  wsClosed: System.Xml.WriteState = System.Xml.WriteState.Closed;
  wsContent: System.Xml.WriteState = System.Xml.WriteState.Content;
  wsElement: System.Xml.WriteState = System.Xml.WriteState.Element;
  wsStart: System.Xml.WriteState = System.Xml.WriteState.Start;

  fmtNone: System.Xml.Formatting = System.Xml.Formatting.None;
  fmtIndented: System.Xml.Formatting = System.Xml.Formatting.Indented;

  ntNone: System.Xml.XmlNodeType = System.Xml.XmlNodeType.None;
  ntElement: System.Xml.XmlNodeType = System.Xml.XmlNodeType.Element;
  ntAttribute: System.Xml.XmlNodeType = System.Xml.XmlNodeType.Attribute;
  ntEndElement: System.Xml.XmlNodeType = System.Xml.XmlNodeType.EndElement;
  ntComment: System.Xml.XmlNodeType = System.Xml.XmlNodeType.Comment;
  ntDeclaration: System.Xml.XmlNodeType = System.Xml.XmlNodeType.XmlDeclaration;
  ntDocumentType: System.Xml.XmlNodeType = System.Xml.XmlNodeType.DocumentType;
  ntText: System.Xml.XmlNodeType = System.Xml.XmlNodeType.Text;
{$ENDIF}

type
{$IFNDEF CLR}
  TValueArr = PChar;
{$ELSE}
  TValueArr = TBytes;

  PChar = string;
  PWideChar = string;

  POleVariant = IntPtr;

const
  { TStream seek origins compatibility aliases }
  soFromBeginning = soBeginning;
  soFromCurrent = soCurrent;
  soFromEnd = soEnd;
{$ENDIF}

{$IFNDEF VER7P}
const
  MSecsPerSec   = 1000;
{$ENDIF}

{ CLR compatibility routines }
{$IFDEF CLR}
  function CompareMem(P1, P2: IntPtr; Length: integer): boolean;
{$ENDIF}
  function CompareGuid(const g1, g2: TGuid): boolean;
  function TimeStampToDateTime(const ATimeStamp: TTimeStamp): TDateTime;

  function VarEqual(const Value1, Value2: variant): boolean;
  procedure OleVarClear(pValue: POleVariant);
  function GetOleVariant(pValue: POleVariant): OleVariant;
  procedure SetOleVariant(pValue: POleVariant; const Value: OleVariant);

  procedure CopyBuffer(Source, Dest: IntPtr; Count: cardinal);
  procedure CopyBufferAnsi(const Source: string; Dest: IntPtr; Count{Bytes (#0 included)}: cardinal);
  procedure CopyBufferUni(const Source: WideString; Dest: IntPtr; Count{Bytes (#0 included)}: cardinal);

  procedure FillChar(X: IntPtr; Count: integer; Value: byte);
  procedure FillStr(var S: string; Count: integer; Value: char);
  procedure ArrayCopy(sourceArray: TBytes; sourceIndex: integer; destinationArray: TBytes; destinationIndex: integer; length: integer);
  function AllocGCHandle(Obj: {$IFDEF CLR}TObject{$ELSE}pointer{$ENDIF}; Pinned: boolean = False): IntPtr;
  function GetGCHandleTarget(Handle: IntPtr): TObject;
  function GetAddrOfPinnedObject(Handle: IntPtr): IntPtr;
  procedure FreeGCHandle(Handle: IntPtr);

  function AllocString(var S: string; Length: integer): IntPtr;
  procedure FreeString(P: IntPtr);
  function AllocOrdinal(var Obj: IntPtr): IntPtr; overload;
  function AllocOrdinal(var Obj: shortint): IntPtr; overload;
  function AllocOrdinal(var Obj: byte): IntPtr; overload;
  function AllocOrdinal(var Obj: word): IntPtr; overload;
  function AllocOrdinal(var Obj: integer): IntPtr; overload;
  function AllocOrdinal(var Obj: cardinal): IntPtr; overload;
  function OrdinalToPtr(var Obj: double): IntPtr; overload;
  function OrdinalToPtr(var Obj: byte): IntPtr; overload;
  function OrdinalToPtr(var Obj: smallint): IntPtr; overload;
  function OrdinalToPtr(var Obj: integer): IntPtr; overload;
  function OrdinalToPtr(var Obj: int64): IntPtr; overload;
  function OrdinalToPtr(var Obj: cardinal): IntPtr; overload;
  function OrdinalToPtr(var Obj: word): IntPtr; overload;
  function OrdinalToPtr(var Obj: IntPtr): IntPtr; overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: shortint); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: byte); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: smallint); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: word); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: integer); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: int64); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: cardinal); overload;
  procedure PtrToOrdinal(P: IntPtr; var Obj: IntPtr); overload;
  procedure FreeOrdinal(P: IntPtr);
{ PChar and PWideChar routines }
{$IFDEF CLR}
  procedure StrCopy(Dest: IntPtr; const Source: IntPtr);
  function StrComp(const Str1: IntPtr; const Str2: IntPtr): integer;
  procedure StrLCopy(Dest: IntPtr; const Source: IntPtr; MaxLen{Chars}: Cardinal); 
  function StrLen(const Str: IntPtr): Cardinal;

  function AnsiUpperCase(const S: string): string;
  function AnsiCompareText(const S1, S2: string): integer;
  function AnsiCompareStr(const S1, S2: string): integer;
  function AnsiSameText(const S1, S2: string): Boolean;
{$ELSE}
  function AnsiStrCompS(S1, S2: PChar): Integer; // SORT_STRINGSORT
  function AnsiStrICompS(S1, S2: PChar): Integer; // SORT_STRINGSORT
{$ENDIF}
  function AnsiCompareTextS(const S1, S2: string): integer; // SORT_STRINGSORT
  function AnsiCompareStrS(const S1, S2: string): integer; // SORT_STRINGSORT
  function Utf8ToWs(const Dest: TValueArr; DestIdx: Cardinal; MaxDestBytes{w/wo #0}: Cardinal;
    const Source: TValueArr; SourceIdx, SourceBytes: Cardinal;
    const AddNull: boolean): Cardinal{bytes w/wo #0};

  function StrCopyW(Dest: IntPtr; const Source: IntPtr): IntPtr;
  procedure StrLCopyW(Dest: IntPtr; const Source: IntPtr; MaxLen{WideChars}: Cardinal);
  function StrLenW(const Str: IntPtr): Cardinal;
  procedure StrTrim(const Str: IntPtr; Len: integer = -1);
  procedure StrTrimW(const Str: IntPtr; Len: integer = -1);
  function AnsiStrLCompWS(const S1, S2: WideString; MaxLen: Cardinal): Integer; // SORT_STRINGSORT
  function AnsiStrLICompWS(const S1, S2: WideString; MaxLen: Cardinal): Integer; // SORT_STRINGSORT
  function AnsiStrCompWS(const S1, S2: WideString): Integer; // SORT_STRINGSORT
  function AnsiStrICompWS(const S1, S2: WideString): Integer; // SORT_STRINGSORT

  function IsClass(Obj: TObject; AClass: TClass): boolean;

{$IFDEF MSWINDOWS}
{$IFNDEF VER7P}
  function VarArrayAsPSafeArray(const A: Variant): PVarArray;
{$ENDIF}
{$IFNDEF VER6P}
  procedure VarResultCheck(AResult: HRESULT);

// These equate to Window's constants but are renamed to less OS dependent
const
  VAR_OK            = HRESULT($00000000); // = Windows.S_OK
  VAR_PARAMNOTFOUND = HRESULT($80020004); // = Windows.DISP_E_PARAMNOTFOUND
  VAR_TYPEMISMATCH  = HRESULT($80020005); // = Windows.DISP_E_TYPEMISMATCH
  VAR_BADVARTYPE    = HRESULT($80020008); // = Windows.DISP_E_BADVARTYPE
  VAR_EXCEPTION     = HRESULT($80020009); // = Windows.DISP_E_EXCEPTION
  VAR_OVERFLOW      = HRESULT($8002000A); // = Windows.DISP_E_OVERFLOW
  VAR_BADINDEX      = HRESULT($8002000B); // = Windows.DISP_E_BADINDEX
  VAR_ARRAYISLOCKED = HRESULT($8002000D); // = Windows.DISP_E_ARRAYISLOCKED
  VAR_NOTIMPL       = HRESULT($80004001); // = Windows.E_NOTIMPL
  VAR_OUTOFMEMORY   = HRESULT($8007000E); // = Windows.E_OUTOFMEMORY
  VAR_INVALIDARG    = HRESULT($80070057); // = Windows.E_INVALIDARG
  VAR_UNEXPECTED    = HRESULT($8000FFFF); // = Windows.E_UNEXPECTED

{$ENDIF}
{$ENDIF}

type
{$IFDEF CLR}
  TDAList = class(TObject)
    FList: array of TObject;
    FCount: Integer;
    FCapacity: Integer;
  protected
    function Get(Index: Integer): TObject;
    procedure Grow; virtual;
    procedure Put(Index: Integer; Item: TObject);
    procedure SetCapacity(NewCapacity: Integer);

  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TObject): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    function IndexOf(Item: TObject): Integer;
    function Last: TObject;
    function Remove(Item: TObject): Integer;
    procedure Sort(Compare: TListSortCompare);

    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount;
    property Items[Index: Integer]: TObject read Get write Put; default;

  end;
{$ELSE}
  TDAList = TList;
{$ENDIF}

{$IFNDEF CLR}
function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word; out AValue: TDateTime): Boolean;
function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
{$ENDIF}

{$IFNDEF VER6P}
  function BoolToStr(const Value: boolean; UseBoolStrs: Boolean = False): string;
  function TryStrToBool(const S: string; out Value: Boolean): Boolean;
  function StrToBool(const S: string): Boolean;
  procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
    AHour, AMinute, ASecond, AMilliSecond: Word);
  function WideUpperCase(const S: WideString): WideString;
  function VarToWideStr(const V: Variant): WideString;
{$ENDIF}

{$IFDEF VER6}
function StrToBool(const S: string): Boolean;
function TryStrToBool(const S: string; out Value: Boolean): Boolean;
{$ENDIF}

  function Reverse4(Value: cardinal): cardinal;
{$IFNDEF CLR}
  procedure Reverse8(pValue: IntPtr);
{$ENDIF}

{$IFDEF VER8}
type
  UTF8String = AnsiString deprecated;

function UTF8Encode(const WS: WideString): UTF8String; deprecated;
function UTF8Decode(const S: UTF8String): WideString; deprecated;
{$ENDIF}

{$IFDEF HAVE_COMPRESS}
const
  MIN_COMPRESS_LENGTH = 50; // Don't compress small bl.

  procedure CheckZLib;
  procedure DoCompress(dest: IntPtr; destLen: IntPtr; const source: IntPtr; sourceLen: longint);
  procedure DoUncompress(dest: IntPtr; destlen: IntPtr; source: IntPtr; sourceLne: longint);

type
  TCompressProc = function(dest: IntPtr; destLen: IntPtr; const source: IntPtr; sourceLen: longint): longint; {$IFDEF LINUX}cdecl;{$ENDIF}
  TUncompressProc = function(dest: IntPtr; destlen: IntPtr; source: IntPtr; sourceLne: longint): longint; {$IFDEF LINUX}cdecl;{$ENDIF}

var
  CompressProc: TCompressProc;
  UncompressProc: TUncompressProc;

{$ENDIF}

{$IFDEF MSWINDOWS}
var
  IsWin9x: boolean;
{$ENDIF}

implementation

{$IFDEF CLR}
uses
  ActiveX, System.Text,
  RTLConsts;
{$ELSE}
uses
{$IFDEF VER6}
  SysConst, 
{$IFDEF MSWINDOWS}
  VarUtils,
{$ENDIF}
{$ENDIF}
  DAConsts;
{$ENDIF}

{$IFNDEF CLR}
  {$IFDEF MSWINDOWS}
    {$DEFINE SORT_STRINGSORT}
  {$ENDIF}
{$ENDIF}

{$IFDEF CLR}
[DllImport('kernel32.dll')]
procedure CopyMemory(Dest, Source: IntPtr; Count: cardinal); external;

[DllImport('kernel32.dll')]
function lstrcpy(lpString1, lpString2: IntPtr): IntPtr; external;

[DllImport('kernel32.dll')]
function lstrcpyn(lpString1, lpString2: IntPtr; iMaxLength: Integer): IntPtr; external;

[DllImport('kernel32.dll')]
function lstrcmp(lpString1, lpString2: IntPtr): integer; external;

[DllImport('kernel32.dll')]
function lstrlen(lpString: IntPtr): Integer; external;

[DllImport('kernel32.dll')]
procedure FillMemory(Destination: IntPtr; Length: DWORD; Fill: Byte); external;

function CompareMem(P1, P2: IntPtr; Length: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Length - 1 do begin
    if Marshal.ReadByte(P1) <> Marshal.ReadByte(P2) then
      Exit;
    P1 := IntPtr(integer(P1) + 1);
    P2 := IntPtr(integer(P2) + 1);
  end;
  Result := True;
end;
function CompareGuid(const g1, g2: TGuid): boolean;
begin
  Result := g1 = g2;
end;
{$ELSE}
function CompareGuid(const g1, g2: TGuid): boolean;
begin
  Result := CompareMem(@g1, @g2, SizeOf(TGuid));
end;
{$ENDIF}

function TimeStampToDateTime(const ATimeStamp: TTimeStamp): TDateTime;
  procedure ValidateTimeStamp(const ATimeStamp: TTimeStamp);
  begin
    if (ATimeStamp.Time < 0) or (ATimeStamp.Date <= 0) then
      raise EConvertError.Create(Format('''%d.%d'' is not a valid timestamp', [ATimeStamp.Date, ATimeStamp.Time]));
  end;
begin
  ValidateTimeStamp(ATimeStamp);
  Result := ATimeStamp.Date - DateDelta;
{$IFNDEF CLR}
  if Result < 0 then
    Result := Result - (ATimeStamp.Time / MSecsPerDay)
  else
{$ENDIF}
    Result := Result + (ATimeStamp.Time / MSecsPerDay);
end;

// bug in D8 in compare strings as variant type
function VarEqual(const Value1, Value2: variant): boolean;
var
{$IFDEF CLR}
  va_old, va_new: TBytes;
  i: integer;
{$ELSE}
  va_old, va_new: PVarArray;
  va_data_old, va_data_new: IntPtr;
{$ENDIF}
begin
{$IFDEF CLR}
  if (Value1 <> nil) and (Value2 <> nil) and
    (integer(Convert.GetTypeCode(Value1)) = 18) and (integer(Convert.GetTypeCode(Value2)) = 18)
  then
    Result := System.String.CompareOrdinal(string(Value1), string(Value2)) = 0
  else
{$ELSE}
  // prevent comparing as AnsiString
  if (VarType(Value1) = 8) and ((VarType(Value2) = 8) or (VarType(Value2) = 256)) or
    (VarType(Value2) = 8) and ((VarType(Value1) = 8) or (VarType(Value1) = 256))
  then
    Result := WideString(Value1) = WideString(Value2)
  else
{$ENDIF}
  if (VarType(Value1) = varNull) and (VarType(Value2) = varNull) then
    Result := True
  else
  if (VarType(Value1) = varNull) or (VarType(Value2) = varNull) or
    (VarType(Value2) <> VarType(Value2)) then
     Result := False
  else
  if (VarType(Value1) = varArray + varByte) or
    (VarType(Value2) = varArray + varByte) then begin
    {$IFDEF CLR}
      va_old := Value1;
      va_new := Value2;
      if (va_old = nil) and (va_new = nil) then
        Result := True
      else
        if (va_old = nil) or (va_new = nil) or
          (Length(va_old) <> Length(va_new)) then
          Result := False
        else begin
          Result := True;
          for i := Low(va_old) to High(va_old) do
            if va_old[i] <> va_new[i] then begin
              Result := False;
              Break;
            end;
        end;
    {$ELSE}
      va_old := TVarData(Value1).VArray;
      va_new := TVarData(Value2).VArray;
      if (va_old = nil) and (va_new = nil) then
        Result := True
      else
        if (va_old = nil) or (va_new = nil) or
          (va_old.Bounds[0].ElementCount <> va_new.Bounds[0].ElementCount) then
          Result := False
        else begin
          va_data_old := va_old.Data;
          va_data_new := va_new.Data;
          if (va_data_old = nil) and (va_data_new = nil) then
            Result := True
          else
            if (va_data_old = nil) or (va_data_new = nil) then
              Result := False
            else
              Result := CompareMem(va_data_old, va_data_new, va_old.Bounds[0].ElementCount);
        end;
    {$ENDIF}
  end
  else
    Result := Value1 = Value2;
end;

procedure CopyBuffer(Source, Dest: IntPtr; Count: cardinal);
begin
{$IFDEF CLR}
  CopyMemory(Dest, Source, Count);
{$ELSE}
  Move(Source^, Dest^, Count);
{$ENDIF}
end;

procedure CopyBufferAnsi(const Source: string; Dest: IntPtr; Count{Bytes (#0 included)}: cardinal);
{$IFDEF CLR}
var
  buf: TBytes;
  CountInt: integer; // To prevent CLR compiler error
begin
  SetLength(buf, Count);
  CountInt := Convert.ToInt32(Count); // To prevent CLR compiler error
  Encoding.Default.GetBytes(Source, 0, CountInt - 1{#0}, buf, 0);
  buf[CountInt - 1] := 0;
  Marshal.Copy(buf, 0, Dest, CountInt);
end;
{$ELSE}
begin
  CopyBuffer(PChar(Source), Dest, Count);
end;
{$ENDIF}

procedure CopyBufferUni(const Source: WideString; Dest: IntPtr; Count{Bytes (#0#0 included)}: cardinal);
{$IFDEF CLR}
var
  buf: TBytes;
  CountInt: integer; // To prevent CLR compiler error
begin
  SetLength(buf, Count);
  CountInt := Convert.ToInt32(Count); // To prevent CLR compiler error
  Encoding.Unicode.GetBytes(Source, 0, (CountInt - 1{#0}) shr 1, buf, 0);
  buf[CountInt - 1] := 0;
  buf[CountInt - 2] := 0;
  Marshal.Copy(buf, 0, Dest, CountInt);
end;
{$ELSE}
begin
  CopyBuffer(PWideChar(Source), Dest, Count);
end;
{$ENDIF}

procedure FillChar(X: IntPtr; Count: integer; Value: byte);
begin
{$IFDEF CLR}
  FillMemory(X, Count, Value);
{$ELSE}
  System.FillChar(X^, Count, Value);
{$ENDIF}
end;

procedure FillStr(var S: string; Count: integer; Value: char);
begin
{$IFDEF CLR}
  S := System.String.Create(Value, Count);
{$ELSE}
  SetLength(S, Count);
  FillChar(PChar(S), Count, byte(Value));
{$ENDIF}
end;

procedure ArrayCopy(sourceArray: TBytes; sourceIndex: integer; destinationArray: TBytes; destinationIndex: integer; length: integer);
begin
{$IFDEF CLR}
  System.Array.Copy(sourceArray, sourceIndex, destinationArray, destinationIndex, length);
{$ELSE}
  System.Move(sourceArray[sourceIndex], destinationArray[destinationIndex], length);
{$ENDIF}
end;

function AllocGCHandle(Obj: {$IFDEF CLR}TObject{$ELSE}pointer{$ENDIF};
   Pinned: boolean = False): IntPtr;
begin
{$IFDEF CLR}
  if Pinned then
    Result := IntPtr(GCHandle.Alloc(Obj, GCHandleType.Pinned))
  else
    Result := IntPtr(GCHandle.Alloc(Obj, GCHandleType.Normal));
{$ELSE}
  Result := Obj;
{$ENDIF}
end;

function GetGCHandleTarget(Handle: IntPtr): TObject;
begin
{$IFDEF CLR}
  if Handle = nil then
    Result := nil
  else
    Result := GCHandle(Handle).Target;
{$ELSE}
  Result := Handle;
{$ENDIF}
end;

function GetAddrOfPinnedObject(Handle: IntPtr): IntPtr;
begin
{$IFDEF CLR}
  Result := GCHandle(Handle).AddrOfPinnedObject;
{$ELSE}
  Result := Handle;
{$ENDIF}
end;

procedure FreeGCHandle(Handle: IntPtr);
begin
{$IFDEF CLR}
  GCHandle(Handle).Free;
{$ELSE}
{$ENDIF}
end;

function AllocString(var S: string; Length: integer): IntPtr;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(Length + 1);
  {$ELSE}
    SetLength(S, Length);
    Result := PChar(S);
  {$ENDIF}
end;

procedure FreeString(P: IntPtr);
begin
  {$IFDEF CLR}
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

function AllocOrdinal(var Obj: shortint): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(shortint));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function AllocOrdinal(var Obj: byte): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(byte));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function AllocOrdinal(var Obj: word): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(word));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function AllocOrdinal(var Obj: integer): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(integer));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function AllocOrdinal(var Obj: cardinal): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(integer));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function AllocOrdinal(var Obj: IntPtr): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(IntPtr));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: double): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(Int64));
    Marshal.WriteInt64(Result, BitConverter.DoubleToInt64Bits(Obj));
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: byte): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(byte));
    Marshal.WriteByte(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: smallint): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(smallint));
    Marshal.WriteInt16(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: integer): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(integer));
    Marshal.WriteInt32(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: int64): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(int64));
    Marshal.WriteInt64(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: cardinal): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(cardinal));
    Marshal.WriteInt32(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: word): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(word));
    Marshal.WriteInt16(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

function OrdinalToPtr(var Obj: IntPtr): IntPtr; overload;
begin
  {$IFDEF CLR}
    Result := Marshal.AllocHGlobal(sizeof(integer));
    Marshal.WriteIntPtr(Result, Obj);
  {$ELSE}
    Result := @Obj;
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: shortint); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadByte(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: byte); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadByte(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: smallint); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadInt16(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: word); overload;
begin
  {$IFDEF CLR}
    Obj := Word(Marshal.ReadInt32(P));
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: integer); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadInt32(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: int64); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadInt64(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: cardinal); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadInt32(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure PtrToOrdinal(P: IntPtr; var Obj: IntPtr); overload;
begin
  {$IFDEF CLR}
    Obj := Marshal.ReadIntPtr(P);
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

procedure FreeOrdinal(P: IntPtr);
begin
  {$IFDEF CLR}
    Marshal.FreeHGlobal(P);
  {$ELSE}
  {$ENDIF}
end;

{$IFDEF CLR}
procedure StrCopy(Dest: IntPtr; const Source: IntPtr);
begin
  Win32Check(lstrcpy(Dest, Source) <> nil);
end;

procedure StrLCopy(Dest: IntPtr; const Source: IntPtr; MaxLen{Chars}: Cardinal);
begin
  Win32Check(lstrcpyn(Dest, Source, Integer(MaxLen + 1)) <> nil);
end;

function StrComp(const Str1: IntPtr; const Str2: IntPtr): integer;
begin
  Result := lstrcmp(Str1, Str2);
end;

function StrLen(const Str: IntPtr): Cardinal;
begin
  Result := lstrlen(Str);
end;

function StrLenW(const Str: IntPtr): Cardinal;
var
  s: WideString;
begin
  s := Marshal.PtrToStringUni(Str);
  Result := s.Length;
end;

procedure StrTrim(const Str: IntPtr; Len: integer = -1);
var
  i: integer;
  v: byte;
begin
  if Len = - 1 then // Detect length
    Len := StrLen(Str);

  i := Integer(Str) + Len - 1;

  while True do begin
    v := Marshal.ReadByte(IntPtr(i));
    if ((v <> 32 {Byte(' ')}) and (v <> 0{Byte(#0)})) or (i < Integer(Str)) then
      Exit;
    Marshal.WriteByte(IntPtr(i), Byte(#0));
    Dec(i);
  end;
end;

procedure StrTrimW(const Str: IntPtr; Len: integer = -1);
var
  i: integer;
  v: smallint;
begin
  if Len = - 1 then // Detect length
    Len := StrLenW(Str);

  i := Integer(Str) + (Len - 1) shl 1;

  while True do begin
    v := Marshal.ReadInt16(IntPtr(i));
    if ((v <> 32 {SmallInt(' ')}) and (v <> 0{SmallInt(#0)})) or (i < Integer(Str)) then
      Exit;
    Marshal.WriteInt16(IntPtr(i), SmallInt(#0));
    Dec(i);
    Dec(i);
  end;
end;

{$ENDIF}

function StrCopyW(Dest: IntPtr; const Source: IntPtr): IntPtr;
{$IFDEF CLR}
var
  Buf: smallint;
  i: integer;
begin
  i := 0;
  repeat
    Buf := Marshal.ReadInt16(Source, i);
    Marshal.WriteInt16(Dest, i, Buf);
    Inc(i, 2);
  until Buf = 0;
{$ELSE}
asm
        PUSH    EDI
        PUSH    ESI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     ECX,0FFFFFFFFH
        XOR     AX,AX
        REPNE   SCASW
        NOT     ECX
        SHL     ECX, 1  // Size := Len * sizeof(WideChar)
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,ECX
        MOV     EAX,EDI
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EDX
        AND     ECX,3
        REP     MOVSB
        POP     ESI
        POP     EDI
{$ENDIF}
end;

procedure StrLCopyW(Dest: IntPtr; const Source: IntPtr; MaxLen{WideChars}: Cardinal);
{$IFDEF CLR}
var
  Buf: smallint;
  i: cardinal;
begin
  i := 0;
  Buf := 0;
  while i < MaxLen * 2 do begin
    Buf := Marshal.ReadInt16(Source, i);
    Marshal.WriteInt16(Dest, i, Buf);
    if Buf = 0 then
      Break;
    Inc(i, 2);
  end;
  if Buf <> 0 then
    Marshal.WriteInt16(Dest, i, 0);
{$ELSE}
var
  pwc: PWideChar;
begin
  pwc := Source;
  while (pwc^ <> #0) and (pwc < PWideChar(Source) + MaxLen) do begin
    PWideChar(Dest)^ := pwc^;
    Inc(PWideChar(Dest));
    Inc(pwc);
  end;
  PWideChar(Dest)^ := #0;
{$ENDIF}
end;

{$IFNDEF CLR}
function StrLenW(const Str: IntPtr): Cardinal; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AX,AX
        REPNE   SCASW
        MOV     EAX,0FFFFFFFEH
        SUB     EAX,ECX
        MOV     EDI,EDX
end;

procedure StrTrim(const Str: IntPtr; Len: integer = -1);
var
  pc: PChar;
begin
  if Len = - 1 then // Detect length
    Len := StrLen(Str);

  pc := PChar(Str) + Len - 1;

  while ((pc^ = ' ') or (pc^ = #0)) and (pc >= Str) do begin
    pc^ := #0;
    Dec(pc);
  end;
end;

procedure StrTrimW(const Str: IntPtr; Len: integer = -1);
var
  pwc: PWideChar;
begin
  if Len = - 1 then // Detect length
    Len := StrLenW(Str);

  pwc := PWideChar(Str) + Len - 1;

  while ((pwc^ = ' ') or (pwc^ = #0)) and (pwc >= Str) do begin
    PWideChar(pwc)^ := #0;
    Dec(pwc);
  end;
end;
{$ENDIF}

function AnsiStrLCompWS(const S1, S2: WideString; MaxLen: Cardinal): Integer;
begin
{$IFDEF MSWINDOWS}
  Assert(not IsWin9x, 'Unicode support on Win9x');
{$IFDEF CLR}
  Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT, S1, MaxLen, S2, MaxLen) - 2;
{$ELSE}
  Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT, PWideChar(S1), MaxLen,
    PWideChar(S2), MaxLen) - 2;
{$ENDIF}
{$ELSE}
  Result := 0;
  Assert(False);
{$ENDIF}
end;

function AnsiStrLICompWS(const S1, S2: WideString; MaxLen: Cardinal): Integer;
begin
{$IFDEF MSWINDOWS}
  Assert(not IsWin9x, 'Unicode support on Win9x');
{$IFDEF CLR}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT,
    S1, MaxLen, S2, MaxLen) - 2;
{$ELSE}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT,
    PWideChar(S1), MaxLen, PWideChar(S2), MaxLen) - 2;
{$ENDIF}
{$ELSE}
  Result := 0;
  Assert(False);
{$ENDIF}
end;

function AnsiStrCompWS(const S1, S2: WideString): Integer;
begin
{$IFDEF MSWINDOWS}
  Assert(not IsWin9x, 'Unicode support on Win9x');
{$IFDEF CLR}
  Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT, S1, -1, S2, -1) - 2;
{$ELSE}
  Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT, PWideChar(S1), -1,
    PWideChar(S2), -1) - 2;
{$ENDIF}
{$ELSE}
  Result := 0;
  Assert(False);
{$ENDIF}
end;

function AnsiStrICompWS(const S1, S2: WideString): Integer;
begin
{$IFDEF MSWINDOWS}
  Assert(not IsWin9x, 'Unicode support on Win9x');
{$IFDEF CLR}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT, S1, -1,
    S2, -1) - 2;
{$ELSE}
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT, PWideChar(S1),
    -1, PWideChar(S2), -1) - 2;
{$ENDIF}
{$ELSE}
  Result := 0;
  Assert(False);
{$ENDIF}
end;

function IsClass(Obj: TObject; AClass: TClass): boolean;

  function IsClassByName(Obj: TObject; AClass: TClass): boolean;
  var
    ParentClass: TClass;
  begin
    Result := False;
    ParentClass := Obj.ClassType;
    while ParentClass <> nil do begin
      Result := ParentClass.ClassName = AClass.ClassName;
      if not Result then
        ParentClass := ParentClass.ClassParent
      else
        Break;
    end;
  end;

begin
  if IsLibrary then
    Result := IsClassByName(Obj, AClass)
  else
    Result := Obj is AClass;
end;

{$IFDEF CLR}
function AnsiUpperCase(const S: string): string;
begin
  if S <> nil then
    Result := System.String(S).ToUpper
  else
    Result := '';
end;

function AnsiCompareText(const S1, S2: string): integer;
begin
  Result := System.String.Compare(S1, S2, True);
end;

function AnsiCompareStr(const S1, S2: string): integer;
begin
  Result := System.String.Compare(S1, S2, False);
end;

function AnsiSameText(const S1, S2: string): Boolean;
begin
  Result := System.String.Compare(S1, S2, True) = 0;
end;

{$ELSE}

function AnsiStrCompS(S1, S2: PChar): Integer; // SORT_STRINGSORT
begin
{$IFDEF SORT_STRINGSORT}
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT, S1, -1, S2, -1) - 2;
{$ELSE}
  Result := AnsiStrComp(S1, S2);
{$ENDIF}
end;

function AnsiStrICompS(S1, S2: PChar): Integer; // SORT_STRINGSORT
begin
{$IFDEF SORT_STRINGSORT}
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT, S1, -1,
    S2, -1) - 2;
{$ELSE}
  Result := AnsiStrIComp(S1, S2);
{$ENDIF}
end;

{$ENDIF}

function AnsiCompareTextS(const S1, S2: string): integer; // SORT_STRINGSORT
begin
{$IFDEF SORT_STRINGSORT}
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE + SORT_STRINGSORT, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - 2;
{$ELSE}
  Result := AnsiCompareText(S1, S2);
{$ENDIF}
end;

function AnsiCompareStrS(const S1, S2: string): integer; // SORT_STRINGSORT
begin
{$IFDEF SORT_STRINGSORT}
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT, PChar(S1), Length(S1),
    PChar(S2), Length(S2)) - 2;
{$ELSE}
  Result := AnsiCompareStr(S1, S2);
{$ENDIF}
end;

// Convert Utf8 buffer to WideString buffer with or without null terminator.
// Nearly copied from System.Utf8ToUnicode
function Utf8ToWs(const Dest: TValueArr; DestIdx: Cardinal; MaxDestBytes{w/wo #0}: Cardinal;
  const Source: TValueArr; SourceIdx, SourceBytes: Cardinal;
  const AddNull: boolean): Cardinal{bytes w/wo #0};
var
  i: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  Assert(Source <> nil, 'Utf8ToWs: Source is nil');
  Assert(Dest <> nil, 'Utf8ToWs: Destination is nil');
{$IFDEF CLR}
  Assert(Integer(DestIdx + MaxDestBytes) <= Length(Dest), 'Utf8ToWs: DestIdx = ' + IntToStr(DestIdx) + ', MaxDestBytes = ' + IntToStr(MaxDestBytes) + ', Length(Dest) = ' + IntToStr(Length(Dest)));
  Assert(Integer(SourceIdx + SourceBytes) <= Length(Source), 'Utf8ToWs: SourceIdx = ' + IntToStr(SourceIdx) + ', SourceBytes = ' + IntToStr(SourceBytes) + ', Length(Source) = ' + IntToStr(Length(Source)));
{$ENDIF}
  Result := 0;
  i := SourceIdx;
  while i < SourceIdx + SourceBytes do
  begin
    wc := Cardinal(Source[Integer(i)]);
    if wc = 0 then   //zero terminator
      break;
    Inc(i);
    if (wc and $80) <> 0 then
    begin
      Assert(i < SourceIdx + SourceBytes, 'Utf8ToWs: Incomplete multibyte char');
      wc := wc and $3F;
      if (wc and $20) <> 0 then
      begin
        c := Byte(Source[Integer(i)]);
        Inc(i);
        Assert((c and $C0) = $80, 'Utf8ToWs: Malformed trail byte or out of range char');
        Assert(i < SourceIdx + SourceBytes, 'Utf8ToWs: Incomplete multibyte char');
        wc := (wc shl 6) or (c and $3F);
      end;
      c := Byte(Source[Integer(i)]);
      Inc(i);
      Assert((c and $C0) = $80, 'Utf8ToWs: Malformed trail byte');
      wc := (wc shl 6) or (c and $3F);
    end;

    if not (Result + 1 < MaxDestBytes) then
      Break;
  {$IFDEF CLR}
    Dest[Integer(Result + DestIdx)] := Byte(wc);
    Dest[Integer(Result + DestIdx + 1)] := Byte(wc shr 8);
  {$ELSE}
    PWord(Cardinal(Dest) + DestIdx + Result)^ := wc;
  {$ENDIF}
    Inc(Result, SizeOf(WideChar));
  end;

  if AddNull and (MaxDestBytes > 0) then begin
    if Result >= MaxDestBytes then
      Result := MaxDestBytes - SizeOf(WideChar);
  {$IFDEF CLR}
    Dest[Integer(Result + DestIdx)] := 0;
    Dest[Integer(Result + DestIdx + 1)] := 0;
  {$ELSE}
    Marshal.WriteInt16(Dest, Integer(DestIdx + Result), 0);
  {$ENDIF}
    Inc(Result, SizeOf(WideChar));
  end;
end;

{$IFDEF CLR}
{ TDAList }
constructor TDAList.Create;
begin
  inherited Create;

  SetCapacity(10);
end;

destructor TDAList.Destroy;
begin
  Clear;
  
  inherited;
end;

procedure TDAList.Clear;
begin
  FCount := 0;
  SetCapacity(0);
end;

procedure TDAList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    TList.Error({$IFNDEF CLR}@{$ENDIF}SListIndexError, Index);
  Dec(FCount);
  if Index < FCount then
  {$IFDEF CLR}
    System.Array.Copy(FList, Index + 1, FList, Index, FCount - Index);
  {$ELSE}//TODO
    System.Move(FList[Index + 1], FList[Index],
      (FCount - Index) * SizeOf(Pointer));
  {$ENDIF}
end;

function TDAList.IndexOf(Item: TObject): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList[Result] <> Item) do
    Inc(Result);
  if Result = FCount then
    Result := -1;
end;

function TDAList.Last: TObject;
begin
  Result := Get(FCount - 1);
end;

function TDAList.Remove(Item: TObject): Integer;
begin
  Result := IndexOf(Item);
  if Result >= 0 then
    Delete(Result);
end;

procedure QuickSort(var SortList: array of TObject; L, R: Integer;
  SCompare: TListSortCompare);
var
  I, J: Integer;
  P, T: TObject;
begin
  repeat
    I := L;
    J := R;
    P := SortList[(L + R) shr 1];
    repeat
      while SCompare(SortList[I], P) < 0 do
        Inc(I);
      while SCompare(SortList[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList[I];
        SortList[I] := SortList[J];
        SortList[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TDAList.Sort(Compare: TListSortCompare);
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, Compare);
end;

function TDAList.Add(Item: TObject): Integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FList[Result] := Item;
  Inc(FCount);
end;

function TDAList.Get(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then
    TList.Error({$IFNDEF CLR}@{$ENDIF}SListIndexError, Index);
  Result := FList[Index];
end;

procedure TDAList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else
    if FCapacity > 8 then
      Delta := 16
    else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

procedure TDAList.Put(Index: Integer; Item: TObject);
begin
  if (Index < 0) or (Index >= FCount) then
    TList.Error({$IFNDEF CLR}@{$ENDIF}SListIndexError, Index);
  FList[Index] := Item;
end;

procedure TDAList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    TList.Error({$IFNDEF CLR}@{$ENDIF}SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    SetLength(FList, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;
{$ENDIF}

{$IFDEF CLR}
const
  ole32    = 'ole32.dll';
  oleaut32 = 'oleaut32.dll';

// Copied from ActiveX.pas (d7)
const
  STGM_READ             = $00000000;

[DllImport(oleaut32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'VariantClear')]
function VariantClear(Value: POleVariant): HResult; external;

procedure OleVarClear(pValue: POleVariant);
begin
  SetOleVariant(pValue, Unassigned);
end;

function GetOleVariant(pValue: POleVariant): OleVariant;
begin
  Result := OleVariant(Marshal.GetObjectForNativeVariant(pValue));
//  Result := OleVariant(Marshal.PtrToStructure(pValue, TypeOf(OleVariant)));
end;

procedure SetOleVariant(pValue: POleVariant; const Value: OleVariant);
begin
  Marshal.GetNativeVariantForObject(TObject(Value), pValue);
end;

{$ELSE}
procedure OleVarClear(pValue: POleVariant);
begin
  pValue^ := Unassigned;
end;

function GetOleVariant(pValue: POleVariant): OleVariant;
begin
  Result := pValue^;
end;

procedure SetOleVariant(pValue: POleVariant; const Value: OleVariant);
begin
  pValue^ := Value;
end;

{$ENDIF}


{$IFNDEF VER6P}
function BoolToStr(const Value: boolean; UseBoolStrs: Boolean = False): string;
const
  cSimpleBoolStrs: array [boolean] of String = ('0', '-1');
begin
  if UseBoolStrs then
  begin
    if Value then
      Result := 'True'
    else
      Result := 'False';
  end
  else
    Result := cSimpleBoolStrs[Value];
end;

function TryStrToBool(const S: string; out Value: Boolean): Boolean;
begin
  Result := True;
  if SameText(s, 'True') or SameText(s, 'Yes') or SameText(s, '1') then
    Value := True
  else
  if SameText(s, 'False') or SameText(s, 'No') or SameText(s, '0') then
    Value := False
  else
    Result := False;
end;

function StrToBool(const S: string): Boolean;
begin
  if not TryStrToBool(S, Result) then
    raise EConvertError.Create('InvalidBoolean - ' + S);
end;

type
  PWordBool = ^WordBool;

procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay,
  AHour, AMinute, ASecond, AMilliSecond: Word);
begin
  DecodeDate(AValue, AYear, AMonth, ADay);
  DecodeTime(AValue, AHour, AMinute, ASecond, AMilliSecond);
end;

function WideUpperCase(const S: WideString): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PWideChar(S), Len);
  if Len > 0 then CharUpperBuffW(Pointer(Result), Len);
end;

function VarToWideStr(const V: Variant): WideString;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := '';;
end;
{$ENDIF}

{$IFDEF VER6}
procedure ConvertErrorFmt(ResString: PResStringRec; const Args: array of const); local;
begin
  raise EConvertError.CreateResFmt(ResString, Args);
end;

function StrToBool(const S: string): Boolean;
begin
  if not TryStrToBool(S, Result) then
    ConvertErrorFmt(@SInvalidBoolean, [S]);
end;

procedure VerifyBoolStrArray;
begin
  if Length(TrueBoolStrs) = 0 then
  begin
    SetLength(TrueBoolStrs, 1);
    TrueBoolStrs[0] := DefaultTrueBoolStr;
  end;
  if Length(FalseBoolStrs) = 0 then
  begin
    SetLength(FalseBoolStrs, 1);
    FalseBoolStrs[0] := DefaultFalseBoolStr;
  end;
end;

function TryStrToBool(const S: string; out Value: Boolean): Boolean;
  function CompareWith(const aArray: array of string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := Low(aArray) to High(aArray) do
      if AnsiSameText(S, aArray[I]) then
      begin
        Result := True;
        Break;
      end;
  end;
var
  LResult: Extended;
begin
  Result := TryStrToFloat(S, LResult);
  if Result then
    Value := LResult <> 0
  else
  begin
    VerifyBoolStrArray;
    Result := CompareWith(TrueBoolStrs);
    if Result then
      Value := True
    else
    begin
      Result := CompareWith(FalseBoolStrs);
      if Result then
        Value := False;
    end;
  end;
end;
{$ENDIF}

{$IFNDEF CLR}
function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < 24) and (Min < 60) and (Sec < 60) and (MSec < 1000) then
  begin
    Time := (Hour * 3600000 + Min * 60000 + Sec * 1000 + MSec) / MSecsPerDay;
    Result := True;
  end;
end;

function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word; out AValue: TDateTime): Boolean;
var
  LTime: TDateTime;
begin
  Result := TryEncodeDate(AYear, AMonth, ADay, AValue);
  if Result then
  begin
    Result := TryEncodeTime(AHour, AMinute, ASecond, AMilliSecond, LTime);
    if Result then
      if AValue > 0 then
        AValue := AValue + LTime
      else
        AValue := AValue - LTime;
  end;
end;

function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond,
  AMilliSecond: Word): TDateTime;
begin
  if not TryEncodeDateTime(AYear, AMonth, ADay,
                           AHour, AMinute, ASecond, AMilliSecond, Result) then
    raise EConvertError.Create(SDateEncodeError);
end;
{$ENDIF}

function Reverse4(Value: cardinal): cardinal;
begin
   Result := Cardinal((byte(Value) shl 24) or (byte(Value shr 8) shl 16)
           or (byte(Value shr 16) shl 8) or byte(Value shr 24));
end;

{$IFNDEF CLR}
procedure Reverse8(pValue: IntPtr);
var
  FirstByte: PByte;
  LastByte: PByte;
  TmpValue: Byte;
  i: integer;
begin
  FirstByte := PByte(pValue);
  LastByte := FirstByte;
  Inc(LastByte, SizeOf(Int64) - 1);
  for i := 0 to 3 do begin
    TmpValue := LastByte^;
    LastByte^ := FirstByte^;
    FirstByte^ := TmpValue;
    Inc(FirstByte);
    Dec(LastByte);
  end;
end;
{$ENDIF}

{$IFDEF VER8}
function UTF8Encode(const WS: WideString): UTF8String;
begin
  Result := UTF8String(System.Array(nil));
  if Assigned(WS) then
    Result := System.Text.Encoding.UTF8.GetBytes(WS);
end;

function UTF8Decode(const S: UTF8String): WideString;
begin
  Result := WideString(System.String(nil));
  if Assigned(S) then
    Result := System.Text.Encoding.UTF8.GetString(TBytes(S), 0, High(TBytes(S)) + 1);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
{$IFNDEF VER7P}
function GetVarDataArrayInfo(const AVarData: TVarData; out AVarType: TVarType;
  out AVarArray: PVarArray): Boolean;
begin
  // variant that points to another variant?  lets go spelunking
  if AVarData.VType = varByRef or varVariant then
    Result := GetVarDataArrayInfo(PVarData(AVarData.VPointer)^, AVarType, AVarArray)
  else
  begin

    // make sure we are pointing to an array then
    AVarType := AVarData.VType;
    Result := (AVarType and varArray) <> 0;

    // figure out the array data pointer
    if Result then
      if (AVarType and varByRef) <> 0 then
        AVarArray := PVarArray(AVarData.VPointer^)
      else
        AVarArray := AVarData.VArray
    else
      AVarArray := nil;
  end;
end;
{$ENDIF}

{$IFNDEF VER6P}
type
  EVariantInvalidOpError = class(EVariantError);
  EVariantTypeCastError = class(EVariantError);
  EVariantBadVarTypeError = class(EVariantError);
  EVariantOverflowError = class(EVariantError);
  EVariantBadIndexError = class(EVariantError);
  EVariantArrayLockedError = class(EVariantError);
  EVariantNotImplError = class(EVariantError);
  EVariantOutOfMemoryError = class(EVariantError);
  EVariantInvalidArgError = class(EVariantError);
  EVariantUnexpectedError = class(EVariantError);
  
const
  SInvalidVarCast = 'Invalid variant type conversion';
  SVarBadType = 'Invalid variant type';
  SInvalidVarOp = 'Invalid variant operation';
  SVarOverflow = 'Variant overflow';
  SVarArrayBounds = 'Variant or safe array index out of bounds';
  SVarArrayLocked = 'Variant or safe array is locked';
  SVarNotImplemented = 'Operation not supported';
  SOutOfMemory = 'Out of memory';
  SVarInvalid = 'Invalid argument';
  SVarUnexpected = 'Unexpected variant error';
  SInvalidVarOpWithHResultWithPrefix = 'Invalid variant operation (%s%.8x)'#10'%s';
  
procedure VarCastError;
begin
  raise EVariantTypeCastError.Create(SInvalidVarCast);
end;

procedure VarInvalidOp;
begin
  raise EVariantInvalidOpError.Create(SInvalidVarOp);
end;

procedure TranslateResult(AResult: HRESULT);
begin
  case AResult of
    VAR_TYPEMISMATCH:  VarCastError;
    VAR_BADVARTYPE:    raise EVariantBadVarTypeError.Create(SVarBadType);
    VAR_EXCEPTION:     VarInvalidOp;
    VAR_OVERFLOW:      raise EVariantOverflowError.Create(SVarOverflow);
    VAR_BADINDEX:      raise EVariantBadIndexError.Create(SVarArrayBounds);
    VAR_ARRAYISLOCKED: raise EVariantArrayLockedError.Create(SVarArrayLocked);
    VAR_NOTIMPL:       raise EVariantNotImplError.Create(SVarNotImplemented);
    VAR_OUTOFMEMORY:   raise EVariantOutOfMemoryError.Create(SOutOfMemory);
    VAR_INVALIDARG:    raise EVariantInvalidArgError.Create(SVarInvalid);
    VAR_UNEXPECTED:    raise EVariantUnexpectedError.Create(SVarUnexpected);
  else
    raise EVariantError.CreateFmt(SInvalidVarOpWithHResultWithPrefix,
      [HexDisplayPrefix, AResult, SysErrorMessage(AResult)]);
  end;
end;

procedure VarResultCheck(AResult: HRESULT);
begin
  if AResult <> VAR_OK then
    TranslateResult(AResult);
end;
{$ENDIF}

{$IFNDEF VER7P}
function VarArrayAsPSafeArray(const A: Variant): PVarArray;
var
  LVarType: TVarType;
begin
  if not GetVarDataArrayInfo(TVarData(A), LVarType, Result) then
    VarResultCheck(VAR_INVALIDARG);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF HAVE_COMPRESS}
procedure CheckZLib;
begin
  if not Assigned(CompressProc) then
    raise Exception.Create(SCompressorNotLinked);
  if not Assigned(UncompressProc) then
    raise Exception.Create(SUncompressorNotLinked);
end;

procedure DoCompress(dest: IntPtr; destLen: IntPtr; const source: IntPtr; sourceLen: longint);
begin
  Assert(Assigned(CompressProc), SCompressorNotLinked);
  CompressProc(dest, destLen, source, sourceLen)
end;

procedure DoUncompress(dest: IntPtr; destlen: IntPtr; source: IntPtr; sourceLne: longint);
begin
  Assert(Assigned(UncompressProc), SUncompressorNotLinked);
  UncompressProc(dest, destLen, source, sourceLne)
end;

{$IFDEF HAVE_COMPRESS_INTERNAL}
function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create(sError);
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create(sError);
end;

function compress(dest: IntPtr; destLen: IntPtr; const source: IntPtr; sourceLen: longint): longint;
var
  strm: TZStreamRec;
begin
  FillChar(@strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  strm.next_in := source;
  strm.avail_in := sourceLen;
  strm.next_out := dest;
  strm.avail_out := Integer(destLen^);
  CCheck(deflateInit_(strm, Z_DEFAULT_COMPRESSION{Z_BEST_COMPRESSION}, zlib_version, sizeof(strm)));
  try
    Result := CCheck(deflate(strm, Z_FINISH));
    if Result <> Z_STREAM_END then
      raise EZlibError.CreateRes(@sTargetBufferTooSmall);
  finally
    CCheck(deflateEnd(strm));
  end;
  Integer(destLen^) := strm.total_out;
end;

function uncompress(dest: IntPtr; destlen: IntPtr; source: IntPtr; sourceLne: longint): longint;
var
  strm: TZStreamRec;
begin
  FillChar(@strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  strm.next_in := source;
  strm.avail_in := sourcelne;
  strm.next_out := dest;
  strm.avail_out := Integer(destlen^);
  DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
  try
    Result := DCheck(inflate(strm, Z_FINISH));
    if Result <> Z_STREAM_END then
      raise EZlibError.CreateRes(@sTargetBufferTooSmall);
  finally
    DCheck(inflateEnd(strm));
  end;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}
var
  lpVersionInformation: TOSVersionInfo;

initialization
  lpVersionInformation.dwOSVersionInfoSize := sizeof(lpVersionInformation);
{$IFDEF VER6P}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}
{$IFDEF CLR}
  IsWin9x := False;
{$ELSE}
  Win32Check(GetVersionEx(lpVersionInformation));
  IsWin9x := lpVersionInformation.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS;
{$ENDIF}
{$ENDIF}

{$IFDEF HAVE_COMPRESS_INTERNAL}
  CompressProc := compress;
  UncompressProc := uncompress;
{$ENDIF}
end.
