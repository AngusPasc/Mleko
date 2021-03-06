unit MlekoUtils;

interface

uses
  Windows, Classes, SysUtils, Data, CFLMLKCustom, CFLMLKSelect,
  DBAccess, MSAccess, GridsEh, DBGridEh, DBGridXLS;

const
  idSearchAllPos = 0;
  idSearchFirstPos = 1;

Type

  TSimpleDataType = (sdtInteger, sdtFloat, sdtString);
  TIntBoolFunc = function(Index: Integer): Boolean of object;
  TObjBoolFunc = function(Obj: TObject): Boolean of object;

  TDynIntegerArray = array of Integer;
  PDynIntegerArray = ^TDynIntegerArray;


type
  TTimeTracer = class
  private
    FTime: Int64;
    pCreationTime, pExitTime, pKernelTime, pUserTime: Int64;
    FProcessHandle: THandle;
    FIsSuccess: Boolean;
    FFreq, FStartCount, FStopCount: int64;
    FLastTime: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property IsSuccess: Boolean read FIsSuccess;
    property LastTime: TDateTime read FLastTime;
  end;

function EncodeSecretValue(Value, Secret: Integer): Integer;

function DecodeSecretValue(Code: Integer; var Secret: Integer): Integer;

function Ctrl_Is_Down(): Boolean;

function Shift_Is_Down(): Boolean;

function Alt_Is_Down(): Boolean;

function GetEntityTable(KeyField, TextField: String): String;

function SelectMLKItemsByDialog(MLKForm: TCFLMLKCustomForm; Items: TStrings;
         OwnerName, ParamName, ParamCode: string;
         MultiSelect: BOOL = True; KeyValues: TStrings = nil;
         SQLFilter: string = ''): Integer;
function GetDelimText(Source: TStrings; Delim: String; Quote: Char = #0): string;
function GetDelimTextOfIntArray(const Source: TDynIntegerArray; Delim: String): string;
procedure IntArrayToStrings(const Source: TDynIntegerArray; Dest: TStrings); overload;
procedure IntArrayToStrings( const Source: PIntegerArray;
                             const Count: Integer; Dest: TStrings;
                             const DoClear: Boolean = True); overload;
procedure StackToDynArray(const Source: array of Integer; var Dest: TDynIntegerArray);
procedure StringObjectsToDynArray(const Source: TStrings; var Dest: TDynIntegerArray);
function GetContainsPosIndex( Source: TStrings; S: string;
                              LookForPos: Integer = idSearchAllPos;
                              MaxCount: Integer = 0;
                              LookForward: Boolean = True): Integer;
function GetStartPosIndex( Source: TStrings; S: string; MaxCount: Integer = 0;
                           LookForward: Boolean = True; Start: Integer = -1): Integer;
function IndexOfColumnByTag(DBGridEh: TDBGridEh; TagValue: Integer): Integer;
function SortMSQueryInEhGrid( var OldCol, OldDir: Integer;
          Col, OrderLine: Integer; Column: TColumnEh; Source: TStrings;
          MSQuery: TMSQuery; MainField: String; OrderFields: String = '';
          DoOpen: Boolean = True; UseOrderBy: Boolean = True): String;
procedure SaveDBGridToXLSFile(DBGridEh: TCustomDBGridEh; const FileName: String; IsSaveAll: Boolean);
function DetectDataType(s: string): TVarType;
function DetectDataTypeOfItems(Items: TStrings): TVarType;
function DetectDataTypeVar(s: string; V: Variant): TVarType;
function IsNan(const Value: Double): Boolean;
function GetNan(): Double;

implementation
uses StrUtils, DB;

var
  Missing: array[0..1] of Integer = (Integer($FFFFFFFF), Integer($FFFFFFFF));
  FNan: Double absolute Missing;

constructor TTimeTracer.Create;
begin
  inherited Create;
  FProcessHandle := GetCurrentProcess;
  QueryPerformanceFrequency(FFreq);
  FIsSuccess := FFreq <> 0;
end;

destructor TTimeTracer.Destroy;
begin
  inherited Destroy;
end;

procedure TTimeTracer.Start;
begin
//  FIsSuccess:=GetProcessTimes(FProcessHandle, TFileTime(pCreationTime), TFileTime(pExitTime), TFileTime(pKernelTime), TFileTime(pUserTime));
  QueryPerformanceCounter(FStartCount);
end;

procedure TTimeTracer.Stop;
begin
//  FIsSuccess:=FIsSuccess and GetProcessTimes(FProcessHandle, TFileTime(pCreationTime), TFileTime(pExitTime), TFileTime(pKernelTime), TFileTime(pUserTime));
  QueryPerformanceCounter(FStopCount);
  if FIsSuccess then
    FLastTime := (FStopCount - FStartCount) / FFreq
  else
    FLastTime := -1;
end;

function EncodeSecretValue(Value, Secret: Integer): Integer;
asm
        test    EAX, EAX  // if (Code<0) then
        js      @Quit       // go to @Quit
        mov     AH, DL   // Result:= Secret * 256 + Value;

@Quit:
end;

function DecodeSecretValue(Code: Integer; var Secret: Integer): Integer;
asm
        mov     DWORD PTR[EDX], 0         // Secret = 0
        test    EAX, EAX                  // if (Code<0) then
        js      @Quit                       // go to @Quit
        movzx   ECX, AH                 // ECX = AH (32 bit <- 8 bit)
        mov     DWORD PTR[EDX], ECX    // Secret:= Code div 256;
        AND     EAX, $FF                // Result = Code mod 256;

@Quit:
end;

function Ctrl_Is_Down(): Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

function Shift_Is_Down(): Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_SHIFT] and 128) <> 0);
end;

function Alt_Is_Down(): Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_MENU] and 128) <> 0);
end;

function GetEntityTable(KeyField, TextField: String): String;
begin
  Result:= '';
  Data.dmDataModule.OpenSQL('select Name from d_entity_type d where d.key_field= :p1 and d.txt_field=:p2', [KeyField, TextField]);
  if (Data.dmDataModule.QFO.RecordCount=1) then
  Result:= Data.dmDataModule.QFO.FieldByName('Name').AsString;
end;

function SelectMLKItemsByDialog(MLKForm: TCFLMLKCustomForm; Items: TStrings;
  OwnerName, ParamName, ParamCode: string;
  MultiSelect: BOOL = True; KeyValues: TStrings = nil;
  SQLFilter: string = ''): Integer;
var
  Keys: TStrings;
  i, c, v: Integer;
  l_res_sql, l_param_code, l_query_filter, l_param_name, l_owner, lv_key_field,
    lv_txt_field, lv_table_name, lv_select_entity_class, l_style: string;
  is_multiselect: boolean;
begin
  Result := -1;
  l_owner := OwnerName;
  l_param_name := UpperCase(ParamName);
  l_param_code := ParamCode;
  l_query_filter := SQLFilter;
  l_style := 'unknown';
  //l_query_filter := dmDataModule.parse_flt_sql(c.SqlFilter, l_owner, l_param_name);
  is_multiselect := MultiSelect;
  if TCFLMLKSelectDlg.OpenHoldSelect(l_Owner, l_param_name, l_param_code,
    is_multiselect, l_query_filter, l_style) then
  begin
    if (KeyValues<>nil) then
       Keys:= KeyValues else
       Keys := TStringList.Create;
    try
      Result := dmDataModule.get_selected_value(OwnerName, ParamName, ParamCode,
        Items, Keys);
      if (KeyValues=nil) then
        for i := 0 to Result - 1 do
        begin
          Val(Keys[i], v, c);
          if (c = 0) then
            Items.Objects[i] := Pointer(v)
          else
            Items[i] := Items[i] + '=' + Keys[i];
        end;
    finally
      if (KeyValues=nil) then Keys.Free;
    end;
  end;
end;

function GetDelimText(Source: TStrings; Delim: String; Quote: Char = #0): string;
var i, h: Integer;
begin
  Result:= ''; h:= Source.Count-1;
  for i := 0 to h do
  begin
    if (Quote=#0) then
       Result:= Result + Source[i] else
       Result:= Result + AnsiQuotedStr(Source[i], Quote);
    if (i<h) then
       Result:= Result + Delim;
  end;
end;

function GetDelimTextOfIntArray(const Source: TDynIntegerArray; Delim: String): string;
var i, h: Integer;
begin
  Result:= ''; h:= High(Source);
  for i := 0 to h do
  begin
    Result:= Result + IntToStr(Source[i]);
    if (i<h) then
       Result:= Result + Delim;
  end;
end;

procedure IntArrayToStrings(const Source: TDynIntegerArray; Dest: TStrings);
var i: Integer;
begin
  Dest.Clear;
  for i := 0 to High(Source) do
  Dest.Add(IntToStr(Source[i]));
end;

procedure IntArrayToStrings( const Source: PIntegerArray;
                             const Count: Integer; Dest: TStrings;
                             const DoClear: Boolean = True);
var i: Integer;
begin
  if DoClear then Dest.Clear;
  if (Source<>nil) then
  for i := 0 to Count-1 do
  Dest.Add(IntToStr(Source[i]));
end;

procedure StackToDynArray(const Source: array of Integer; var Dest: TDynIntegerArray);
var n: Integer;
begin
  n:= Length(Source);
  SetLength(Dest, n);
  if n>0 then
     System.Move(Source[0], Dest[0], SizeOf(Integer)*n);
end;

procedure StringObjectsToDynArray(const Source: TStrings; var Dest: TDynIntegerArray);
var i, n: Integer;
begin
  n:= Source.Count;
  SetLength(Dest, n);
  for i := 0 to n-1 do
  Dest[i]:= Integer(Source.Objects[i]);
end;

function AnsiTextPos(const Substr, S: string): Integer;
begin
  Result:= AnsiPos(AnsiUppercase(Substr), AnsiUppercase(S));
end;

function GetContainsPosIndex( Source: TStrings; S: string;
                              LookForPos: Integer = idSearchAllPos;
                              MaxCount: Integer = 0;
                              LookForward: Boolean = True): Integer;
function IsFound(i: Integer): Boolean;
var p: Integer;
begin
  p:=  AnsiTextPos(S, Source[i]);
  Result:= (p>0) and ((LookForPos=idSearchAllPos) or (LookForPos=p));
end;

begin
  if (MaxCount<=0) or (MaxCount>Source.Count) then
      MaxCount:= Source.Count;
  if LookForward then
  begin
    for Result := 0 to MaxCount - 1 do
      if IsFound(Result) then Exit
  end
  else
  begin
    for Result := Source.Count-1 downto Source.Count-MaxCount do
      if IsFound(Result) then Exit
  end;
  Result := -1;
end;

function GetStartPosIndex( Source: TStrings; S: string; MaxCount: Integer = 0;
                           LookForward: Boolean = True; Start: Integer = -1): Integer;
begin
  if (MaxCount<=0) or (MaxCount>Source.Count) then
      MaxCount:= Source.Count;
  if LookForward then
  begin
    if (Start<0) then Start:= 0;
    //if (Start>=0) then
    for Result := Start to MaxCount - 1 do
      if AnsiStartsText(S, Source[Result]) then Exit
  end
  else
  begin
    if (Start<0) then Start:= Source.Count-1;
    //if (Start>=0) then
    for Result := Start downto Source.Count-MaxCount do
      if AnsiStartsText(S, Source[Result]) then Exit;
  end;
  Result := -1;
end;

function IndexOfColumnByTag(DBGridEh: TDBGridEh; TagValue: Integer): Integer;
begin
  for Result := 0 to DBGridEh.Columns.Count-1 do
      if DBGridEh.Columns[Result].Tag = TagValue then Exit;
  Result:= -1;
end;

function SortMSQueryInEhGrid( var OldCol, OldDir: Integer;
          Col, OrderLine: Integer; Column: TColumnEh; Source: TStrings;
          MSQuery: TMSQuery; MainField: String; OrderFields: String = '';
          DoOpen: Boolean = True;
          UseOrderBy: Boolean = True): String;
const
  idOrderBy = 'ORDER BY';
//const
//  OrderDirs: array[TSortMarkerEh] of String
var
  Dir: Integer; OrderStr: string;
  DoInsert: Boolean;
begin
  //  TSortMarkerEh = (smNoneEh, smDownEh, smUpEh);
  Result:= OrderFields;
  DoInsert:= False;
  if (OrderLine<=0) and (Source<>nil) then
  begin
    OrderLine:= GetStartPosIndex(Source, idOrderBy, 10, False);
    if (OrderLine<=0) then
    begin
      OrderLine:= GetStartPosIndex(Source, '--'+idOrderBy, 10, False);
      if (OrderLine>0) then
      begin
        DoInsert:= True;
        Inc(OrderLine);
      end;
    end;
  end;
  if (OrderLine>0) then
  begin
    if (OldCol<>-2) then
      if (OldCol<>Col) or (OldDir=0)
         then OldDir:= 1
         else OldDir:= -OldDir;
         OldCol:= Col;
   Column.Title.SortMarker:= TSortMarkerEh((3-OldDir) div 2);
   if (OldDir<0) then OrderStr:= ' DESC' else OrderStr:= ' ASC';
   if (OrderFields='') and
      (not SameText(MainField, Column.Field.FieldName)) then
           OrderFields:= Column.Field.FieldName;
   if (OrderFields<>'') then OrderStr:= OrderStr + ', ';
   Result:= MainField + OrderStr + OrderFields;
   if UseOrderBy then Result:= idOrderBy + ' ' + Result;
   if (MSQuery=nil) then Exit;
   MSQuery.Close;
   if DoInsert and (Source<>nil) then
   begin
     MSQuery.SQL.Assign(Source);
     MSQuery.SQL.Insert(OrderLine, Result);
   end
      else
      MSQuery.SQL[OrderLine]:= Result;
   if DoOpen then MSQuery.Open;
  end;
end;

procedure SaveDBGridToXLSFile(DBGridEh: TCustomDBGridEh; const FileName: String; IsSaveAll: Boolean);
var DBGridExport: TCustomDataGridExportAsXLS;
begin
  DBGridExport := TCustomDataGridExportAsXLS.Create;
  try
    DBGridExport.DBGridEh := DBGridEh;
    DBGridExport.ExportToFile(FileName, IsSaveAll);
  finally
    DBGridExport.Free;
  end;
end;

function IsNan(const Value: Double): Boolean;
begin
Result:= CompareMem(@FNan, @Value, SizeOf(Value));
end;

function GetNan(): Double;
begin
Result:= FNan;
end;

function DetectDataType(s: string): TVarType;
var i, c: Integer; f: Double;
begin
  Val(s, i, c);
  if (c=0) then
     Result:= varInteger else
     begin
       f:= StrToFloatDef(s, GetNan());
       if IsNan(f) then
          Result:= varString else
          Result:= varDouble
     end;
end;

function DetectDataTypeOfItems(Items: TStrings): TVarType;
var i, n: Integer; f: Double;
begin
  Result:= varEmpty;
  if (Items.Count>0) then
  begin
    Result:= DetectDataType(Items[0]);
    for i := 1 to Items.Count-1 do
      if (DetectDataType(Items[i])<>Result) then
        begin
          Result:= varError;
          Exit;
        end;
  end;
end;

function DetectDataTypeVar(s: string; V: Variant): TVarType;
var i, c: Integer; f: Double;
begin
  Val(s, i, c);
  if (c=0) then
  begin
    Result:= varInteger;
    V:= i;
  end
     else
     begin
       f:= StrToFloatDef(s, GetNan());
       if IsNan(f) then
       begin
         Result:= varString;
         V:= s;
       end
          else
          begin
            Result:= varDouble;
            V:= f;
          end;
     end;
end;


end.


