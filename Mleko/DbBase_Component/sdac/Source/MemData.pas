
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright � 1998-2007 Core Lab. All right reserved.
//  Mem Data
//  Created:            20.02.98
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit MemData;
{$ENDIF}
interface
uses
  Classes, CRParser, MemUtils, SyncObjs,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF VER6P}
  FMTBcd, Variants,
{$ENDIF}
{$IFDEF CLR}
  System.Runtime.InteropServices, System.Text;
{$ELSE}
  CLRClasses;
{$ENDIF}

const
  btSign = $DD;   // DEBUG
  flUsed = $EE;
  flFree = $DD;

  FlatBufferLimit = 32;

{ internal data types }

{ ! can't modify this consts }

  dtUnknown     = 0;
  dtString      = 1;

  dtInt8        = 2;
  dtInt16       = 3;
  dtSmallint    = dtInt16;
  dtInt32       = 4;

  dtInteger     = dtInt32;
  dtFloat       = 5;
  dtDate        = 6; // Date only
  dtTime        = 7; // Time only
  dtDateTime    = 8; // Date and time
  dtUInt16      = 9;
  dtWord        = dtUInt16;
  dtBoolean     = 10;
  dtInt64       = 11;
  dtLargeint    = dtInt64;
  dtCurrency    = 12;
  dtBlob        = 13;
  dtMemo        = 14;
  dtObject      = 15;
  dtReference   = 16;
  dtArray       = 17;
  dtTable       = 18;

{$IFDEF VER5P}
  dtVariant     = 19;
{$ENDIF}
  dtExtString   = 20;
  dtBytes       = 21;
  dtVarBytes    = 22; /// Cannot be deleted because "Fixed" flag not avaible on component level (MSAccess) GetFieldType(DataType: word): TFieldType
  dtExtVarBytes = 23;

  dtUInt32      = 24;
  dtLongword    = dtUInt32;

  dtWideString  = 25;
  dtExtWideString = 26;

  dtBCD  = 27;
{$IFDEF VER6P}
  dtFMTBCD = 28;
{$ENDIF}
  dtGuid = 29;
  dtWideMemo = 30; //This type corectly supported only in BDS 2006 and higher

{ StringHeap const }

const
  BlockSize = 16384;
  SmallSize = 2000;
  Align = 8;
  RefNull = 101;

{$IFNDEF CLR}
{$IFDEF VER6P}
  SizeOfTBcd = SizeOf(TBcd);
{$ENDIF}
{$ENDIF}

type
  TDataType = word;

  TDANumericType = (ntFloat, ntBCD{$IFDEF VER6P}, ntFmtBCD{$ENDIF});

  //Note that TConnLostCause should be ordered by FailOver priority
  //e.g. there are multyple DataSet.ApplyUpdates during Connection.ApplyUpdates so Connection.ApplyUpdates is more
  //prioritized operation than DataSet.ApplyUpdates and should be reexecuted instead of DataSet.ApplyUpdates in case of
  //failover
  TConnLostCause = (clUnknown,  //Connection lost reason - unknown
    clExecute,                  //Connection Lost detected during SQL execution (Reconnect with exception possible)
    clOpen,                     //Connection Lost detected during query opening (Reconnect/Reexecute possible)
    clRefresh,                  //Connection Lost detected during query opening (Reconnect/Reexecute possible)
    clApply,                    //Connection Lost detected during DataSet.ApplyUpdates (Reconnect/Reexecute possible)
    clServiceQuery,             //Connection Lost detected during service information request (Reconnect/Reexecute possible)
    clTransStart,               //Connection Lost detected during transaction start (Reconnect/Reexecute possible)
                                //In IBDAC one connection could start several transactions during ApplyUpdates that's why
                                //clTransStart has less priority then clConnectionApply
    clConnectionApply,          //Connection Lost detected during Connection.ApplyUpdates (Reconnect/Reexecute possible)
    clConnect                   //Connection Lost detected during connection establishing (Reconnect possible)
    );

{ TBlockManager }

{$IFDEF CLR}
  PBlockHeader = packed record
  private
    Ptr: IntPtr;

    function GetItemCount: word;
    procedure SetItemCount(Value: word);
    function GetUsedItems: word;
    procedure SetUsedItems(Value: word);
    function GetPrev: PBlockHeader;
    procedure SetPrev(Value: PBlockHeader);
    function GetNext: PBlockHeader;
    procedure SetNext(Value: PBlockHeader);

  public
    property ItemCount: word read GetItemCount write SetItemCount;
    property UsedItems: word read GetUsedItems write SetUsedItems;
    property Prev: PBlockHeader read GetPrev write SetPrev;
    property Next: PBlockHeader read GetNext write SetNext;

    class operator Implicit(AValue: IntPtr): PBlockHeader;
    class operator Implicit(AValue: PBlockHeader): IntPtr;
    class operator Implicit(AValue: PBlockHeader): integer;
    class operator Equal(ALeft, ARight: PBlockHeader): boolean;
  end;
{$ELSE}
  PBlockHeader = ^TBlockHeader;
{$ENDIF}
  TBlockHeader = packed record
    ItemCount: word;
    UsedItems: word;
    Prev: PBlockHeader;
    Next: PBlockHeader;
    Test: byte;       // DEBUG
  end;

  TItemStatus = (isUnmodified, isUpdated, isAppended, isDeleted);
  TItemTypes = set of TItemStatus;
  TUpdateRecAction = (urFail, urAbort, urSkip, urRetry, urApplied, urNone, urSuspended);
  TItemFilterState = (fsNotChecked, fsNotOmitted, fsOmitted);

{$IFDEF CLR}
  PItemHeader = packed record
  private
    Ptr: IntPtr;

    function GetBlock: PBlockHeader;
    procedure SetBlock(Value: PBlockHeader);
    function GetPrev: PItemHeader;
    procedure SetPrev(Value: PItemHeader);
    function GetNext: PItemHeader;
    procedure SetNext(Value: PItemHeader);
    function GetRollback: PItemHeader;
    procedure SetRollback(Value: PItemHeader);
    function GetStatus: TItemStatus;
    procedure SetStatus(Value: TItemStatus);
    function GetUpdateResult: TUpdateRecAction;
    procedure SetUpdateResult(Value: TUpdateRecAction);
    function GetOrder: longint;
    procedure SetOrder(Value: longint);
    function GetFlag: byte;
    procedure SetFlag(Value: byte);
    function GetFilterResult: TItemFilterState;
    procedure SetFilterResult(Value: TItemFilterState);
  public
    property Block: PBlockHeader read GetBlock write SetBlock;
    property Prev: PItemHeader read GetPrev write SetPrev;
    property Next: PItemHeader read GetNext write SetNext;
    property Rollback: PItemHeader read GetRollback write SetRollback;
    property Status: TItemStatus read GetStatus write SetStatus;
    property UpdateResult: TUpdateRecAction read GetUpdateResult write SetUpdateResult;
    property Order: longint read GetOrder write SetOrder;
    property Flag: byte read GetFlag write SetFlag;
    property FilterResult: TItemFilterState read GetFilterResult write SetFilterResult;

    class operator Implicit(AValue: IntPtr): PItemHeader;
    class operator Implicit(AValue: PItemHeader): IntPtr;
    class operator Implicit(AValue: PItemHeader): integer;
    class operator Equal(ALeft, ARight: PItemHeader): boolean;
  end;
{$ELSE}
  PItemHeader = ^TItemHeader;
{$ENDIF}
  TItemHeader = packed record
    Block: PBlockHeader;
    Prev: PItemHeader;
    Next: PItemHeader;
    Rollback: PItemHeader;
    Status: TItemStatus;
    UpdateResult: TUpdateRecAction;
    Order: longint;
    Flag: byte;
    FilterResult: TItemFilterState;
    AlignByte: byte; // (SizeOf(TBlockHeader) + SizeOf(TItemHeader)) mod 2 = 0
  end;               // (RecordSize + SizeOf(TItemHeader)) mod 2 = 0

  TBlockManager = class
  private
  {$IFDEF CLR}
    FHeap: THandle;
  {$ENDIF}

  public
    FirstFree: PItemHeader;
    FirstBlock: PBlockHeader;
    RecordSize: longint;
    DefaultItemCount: word;

    constructor Create;
    destructor Destroy; override;

    procedure AllocBlock(var Block: PBlockHeader; ItemCount: word);
    procedure FreeBlock(Block: PBlockHeader);

    procedure AddFreeBlock;
    procedure FreeAllBlock;

    procedure AllocItem(var Item: PItemHeader);
    procedure FreeItem(Item: PItemHeader);
    procedure InitItem(Item: PItemHeader);

    procedure PutRecord(Item: PItemHeader; Rec: IntPtr);
    procedure GetRecord(Item: PItemHeader; Rec: IntPtr);
    function GetRecordPtr(Item: PItemHeader): IntPtr;

    procedure CopyRecord(ItemSrc: PItemHeader; ItemDest: PItemHeader);
  end;

{ TStringHeap }

{$IFDEF CLR}
  PBlock = packed record
  private
    Ptr: IntPtr;

    function GetNext: PBlock;
    procedure SetNext(Value: PBlock);
  public
    property Next: PBlock read GetNext write SetNext;

    class operator Implicit(AValue: IntPtr): PBlock;
    class operator Implicit(AValue: PBlock): IntPtr;
  end;
{$ELSE}
  PBlock = ^TBlock;
{$ENDIF}
  TStrData = array [0..BlockSize - 5 {SizeOf(PBlock) - 1}] of char;
  TBlock = packed record
    Next: PBlock;
    Data: TStrData;
  end;

  TSmallTab = array [1..SmallSize div Align] of IntPtr;

const
  SizeOf_TStrData = BlockSize - 4;
  SizeOf_TBlock = SizeOf_TStrData + 4;
  SizeOf_TSmallTab = SmallSize div Align * 4;

type
  TStringHeap = class
  private
    FSmallTab: TSmallTab;
    FFree: integer;
    FRoot: PBlock;
    FEmpty: boolean;
    FSysGetMem: boolean;
  {$IFDEF WIN32}
    FUseSysMemSize: boolean;
  {$ENDIF}
    FThreadSafety: boolean;
    FThreadSafetyCS: TCriticalSection;
    procedure SetThreadSafety(const Value: boolean);
    function UseSmallTabs(divSize: integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function NewBuf(Size: integer): IntPtr;
    function AllocStr(Str: IntPtr; Trim: boolean = false; Len: integer = -1): IntPtr;
    function AllocWideStr(Str: IntPtr; Trim: boolean = false; Len: integer = -1): IntPtr;
    function ReAllocStr(Str: IntPtr; Trim: boolean = false): IntPtr;
    function ReAllocWideStr(Str: IntPtr; Trim: boolean = false): IntPtr;
    procedure DisposeBuf(Buf: IntPtr);
    procedure AddRef(Buf: IntPtr);
    procedure Clear;
    property Empty: boolean read FEmpty;
    property SysGetMem: boolean read FSysGetMem;
    property ThreadSafety: boolean read FThreadSafety write SetThreadSafety;
  end;

{ TFieldDesc }

  TFieldTypeSet = set of byte;

  TDateFormat = (dfMSecs, dfDateTime, dfTime, dfDate);

  TFieldDescKind = (fdkData, fdkCached, fdkCalculated);

  TObjectType = class;

  TFieldDesc = class
  protected
    FName: string;       // unique name in TData
    FActualName: string; // original name from source
    FDataType: word;
    FSubDataType: word;
    FLength: word;       // precision for number
    FScale: word;
    FFieldNo: word;
    FActualFieldNo: word;
    FSize: word;         // size in rec buffer
    FOffset: longint;    // offset in rec buffer
    FDataOffset: longint;// offset in storage structure
    FRequired: boolean;
    FReadOnly: boolean;
    FIsKey: boolean;
    FFixed: boolean;     // indicates that the string field has a fixed size
    FHidden: boolean;
    FObjectType: TObjectType;
    FParentField: TFieldDesc;
    FHiddenObject: boolean;  // for hide Object field (child field is visible)
    FHandle: IntPtr;    // pointer to field specific data
    FReserved: boolean;  // reserved flag for perfomance optimization
    FFieldDescKind: TFieldDescKind;

    procedure SetObjectType(Value: TObjectType);

  public
    constructor Create; virtual;
    destructor Destroy; override;

    function HasParent: boolean;

    procedure Assign(FieldDesc: TFieldDesc);

    property Name: string read FName write FName;
    property ActualName: string read FActualName write FActualName ;
    property DataType: word read FDataType write FDataType;
    property SubDataType: word read FSubDataType write FSubDataType;
    property Length: word read FLength write FLength;
    property Scale: word read FScale write FScale;
    property FieldNo: word read FFieldNo write FFieldNo;
    property ActualFieldNo: word read FActualFieldNo write FActualFieldNo; // for define
    property Size: word read FSize write FSize;
    property Offset: longint read FOffset write FOffset;
    property DataOffset: longint read FDataOffset write FDataOffset;
    property Required: boolean read FRequired write FRequired;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property IsKey: boolean read FIsKey write FIsKey;
    property Fixed: boolean read FFixed write FFixed;
    property Hidden: boolean read FHidden write FHidden;
    property ObjectType: TObjectType read FObjectType write SetObjectType;
    property ParentField: TFieldDesc read FParentField write FParentField;
    property HiddenObject: boolean read FHiddenObject write FHiddenObject; // IncludeObject
    property Handle: IntPtr read FHandle write FHandle;
    property FieldDescKind: TFieldDescKind read FFieldDescKind write FFieldDescKind;
  end;

  TFieldDescClass = class of TFieldDesc;

  TFieldDescs = class (TDAList)
  private
    function GetItems(Index: integer): TFieldDesc;

  public
    destructor Destroy; override;

    procedure Clear; override;

    function FindField(Name: string): TFieldDesc;
    function FieldByName(Name: string): TFieldDesc;

    property Items[Index: integer]: TFieldDesc read GetItems; default;
  end;

{ TSharedObject }

  TSharedObject = class
  protected
    FRefCount: integer;
    FGCHandle: IntPtr;

    function GetGCHandle: IntPtr;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Free;

    procedure CheckValid;

    procedure AddRef;
    procedure Release;
  {$IFNDEF CLR}
    function GetHashCode: integer;
  {$ENDIF}

    property RefCount: integer read FRefCount;
    property GCHandle: IntPtr read GetGCHandle;
  end;

{ TObjectType }

  TAttribute = class
  private
    FName: string;
    FDataType: word;
    FLength: word;
    FScale: word;
    FSize: word;       // size of got data
    FDataSize: word;   // size of stored data
    FOffset: word;     // stored offset
    FIndicatorOffset: word;  // indicator offset
    FAttributeNo: word;
    FObjectType: TObjectType;
    FOwner: TObjectType;
    FFixed: boolean;

    procedure SetObjectType(Value: TObjectType);

  public
    constructor Create;
    destructor Destroy; override;

    property Name: string read FName write FName;
    property DataType: word read FDataType write FDataType;
    property Fixed: boolean read FFixed write FFixed;
    property Length: word read FLength write FLength;
    property Scale: word read FScale write FScale;
    property Size: word read FSize write FSize;
    property DataSize: word read FDataSize write FDataSize;
    property Offset: word read FOffset write FOffset;
    property IndicatorOffset: word read FIndicatorOffset write FIndicatorOffset;
    property AttributeNo: word read FAttributeNo write FAttributeNo;
    property ObjectType: TObjectType read FObjectType write SetObjectType;
    property Owner: TObjectType read FOwner write FOwner;
  end;

  TObjectType = class (TSharedObject)
  private
    function GetAttributes(Index: integer): TAttribute;
    function GetAttributeCount: integer;

  protected
    FName: string;
    FDataType: word;
    FSize: integer;
    FAttributes: TDAList;

  protected
    procedure ClearAttributes;

  public
    constructor Create;
    destructor Destroy; override;

    function FindAttribute(Name: string): TAttribute;
    function AttributeByName(Name: string): TAttribute;

    property Name: string read FName;
    property DataType: word read FDataType;
    property Size: integer read FSize;
    property AttributeCount: integer read GetAttributeCount;

    property Attributes[Index: integer]: TAttribute read GetAttributes;
  end;

  TDBObject = class (TSharedObject)
  private
    FObjectType: TObjectType;

  protected
    procedure SetObjectType(Value: TObjectType);

    procedure GetAttributeValue(Name: string; Dest: IntPtr; var IsBlank: boolean); virtual;
    procedure SetAttributeValue(Name: string; Source: IntPtr); virtual;

  public
    constructor Create;

    property ObjectType: TObjectType read FObjectType;
  end;

  TCacheItem = class
    Item: PItemHeader;
    Next: TCacheItem;
  end;

{$IFDEF CLR}
  PRecBookmark = packed record
  private
    Ptr: IntPtr;

    function GetRefreshIteration: longint;
    procedure SetRefreshIteration(Value: longint);
    function GetItem: PItemHeader;
    procedure SetItem(Value: PItemHeader);
    function GetOrder: longint;
    procedure SetOrder(Value: longint);

  public
    property RefreshIteration: longint read GetRefreshIteration write SetRefreshIteration;
    property Item: PItemHeader read GetItem write SetItem;
    property Order: longint read GetOrder write SetOrder;

    class operator Implicit(AValue: IntPtr): PRecBookmark;
    class operator Implicit(AValue: PRecBookmark): IntPtr;
    class operator Implicit(AValue: integer): PRecBookmark;
  end;
{$ELSE}
  PRecBookmark = ^TRecBookmark;
{$ENDIF}
  TRecBookmark = record
    RefreshIteration: longint;
    Item: PItemHeader;
    Order: longint
  end;

  TFilterFunc = function(RecBuf: IntPtr): boolean of object;

  TBoolParser = class (TParser)
  protected
    procedure ToRightQuote(LeftQuote: Char); override;
  public
    constructor Create(const Text: string); override;
  end;

  TExpressionType = (ntEqual,ntMore,ntLess,ntMoreEqual,ntLessEqual,ntNoEqual,
    ntAnd,ntOr,ntNot,ntField,ntValue,ntTrue,ntFalse,ntLike);

  TExpressionNode = class
    NextAlloc: TExpressionNode;
    NodeType: TExpressionType;
    LeftOperand: TExpressionNode;
    RightOperand: TExpressionNode;
    NextOperand: TExpressionNode;
    FieldDesc: TFieldDesc; // used only when TExpressionType = ntField
    Value: variant;
  end;

  TBlob = class;

{ TData }

  TUpdateRecKind = (ukUpdate, ukInsert, ukDelete);
  TOnModifyRecord = procedure of object;
  TOnApplyRecord = procedure (UpdateKind: TUpdateRecKind; var Action: TUpdateRecAction; LastItem: boolean) of object;

  TOnGetCachedFields = procedure of object;
  TOnGetCachedBuffer = procedure(Buffer: IntPtr; Source: IntPtr = nil) of object;

  TData = class
  private
    FRecordSize: longint;  // FDataSize + TIndicatorSize
    FCalcRecordSize: longint;
    FCachedUpdates: boolean;
    FOnAppend: TOnModifyRecord;
    FOnDelete: TOnModifyRecord;
    FOnUpdate: TOnModifyRecord;
    FOnApplyRecord: TOnApplyRecord;
    FAutoInitFields: boolean; // initialization fields by InternalInitField
    FTrimFixedChar: boolean;
    FTrimVarChar: boolean;

  { Filter }
    FFilterFunc: TFilterFunc;
    FFilterMDFunc: TFilterFunc;
    FFilterText: string;
    FFilterCaseInsensitive: boolean;
    FFilterNoPartialCompare: boolean;
    FFilterItemTypes: TItemTypes;

    Parser: TBoolParser;
    Code: integer;
    StrLexem: string;
    FilterExpression: TExpressionNode;
    FirstAlloc: TExpressionNode;
    FilterRecBuf: IntPtr;

  /// if False then PutField set Null for string fields with empty value ('')
    FEnableEmptyStrings: boolean;
    FHasComplexFields: boolean;
    FSparseArrays: boolean;

    FOnGetCachedFields: TOnGetCachedFields;
    FOnGetCachedBuffer: TOnGetCachedBuffer;

    procedure FilterError;
    function AllocNode: TExpressionNode;
    function OrExpr: TExpressionNode;
    function AndExpr: TExpressionNode;
    function Condition: TExpressionNode;
    function Argument: TExpressionNode;

    procedure CreateFilterExpression(Text: string);
    procedure FreeFilterExpression;

    function Eval(Node: TExpressionNode): boolean;

    function GetFieldCount: word;
    procedure SetCachedUpdates(Value: boolean);
  protected
    FRecordNoOffset: integer;

    FRecordCount: longint;
    FBOF: boolean;
    FEOF: boolean;
    DataSize: longint; // size of data
    CalcDataSize: longint;

    FFields: TFieldDescs;

    StringHeap: TStringHeap;

  { Open/Close }
    procedure InternalPrepare; virtual;
    procedure InternalUnPrepare; virtual;
    procedure InternalOpen; virtual;
    procedure InternalClose; virtual;

  { Data }
    procedure InitData; virtual;
    procedure FreeData; virtual;

  { Fields }
    procedure InternalInitFields; virtual;
    procedure InitObjectFields(ObjectType: TObjectType; Parent: TFieldDesc);
    function InternalGetObject(FieldNo: word; RecBuf: IntPtr): TSharedObject;
    function GetArrayFieldName(ObjectType: TObjectType; ItemIndex: integer): string; virtual;

    function GetIndicatorSize: word; virtual;

    procedure GetChildFieldInfo(Field: TFieldDesc; var RootField: TFieldDesc; var AttrName: string);
    procedure GetChildField(Field: TFieldDesc; RecBuf: IntPtr; Dest: IntPtr; var IsBlank: boolean);
    procedure PutChildField(Field: TFieldDesc; RecBuf: IntPtr; Source: IntPtr);

    function NeedConvertEOL: boolean; virtual;

  { Records }

  { Navigation }
    function GetEOF: boolean; virtual;
    function GetBOF: boolean; virtual;

    function GetRecordCount: longint; virtual;
    function GetRecordNo: longint; virtual;
    procedure SetRecordNo(Value: longint); virtual;

  { Edit }
    procedure InternalAppend(RecBuf: IntPtr); virtual;
    procedure InternalDelete; virtual;
    procedure InternalUpdate(RecBuf: IntPtr); virtual;

    property IndicatorSize: word read GetIndicatorSize;

  { Filter }
    function Filtered: boolean;
    procedure SetFilterText(Value: string); virtual;

  { CachedUpdates }
    function GetUpdatesPending: boolean; virtual;
    procedure SetFilterItemTypes(Value: TItemTypes); virtual;

  public
    Active: boolean;
    Prepared: boolean;
    NewCacheRecBuf: IntPtr;
    OldCacheRecBuf: IntPtr;

    property FieldCount: word read GetFieldCount;
    property Fields: TFieldDescs read FFields;
    property Bof: boolean read GetBOF; // EOF: for CB case sensivity
    property Eof: boolean read GetEOF;

    constructor Create;
    destructor Destroy; override;

  { Open/Close }
    procedure Open; virtual;
    procedure Close; virtual;

    procedure Prepare; virtual;
    procedure UnPrepare; virtual;

    function IsFullReopen: boolean; virtual;    
    procedure Reopen; virtual;

  { Fields }
    function GetFieldDescType: TFieldDescClass; virtual;  
    procedure InitFields; virtual;
    procedure ClearFields; virtual;
    procedure GetField(FieldNo: word; RecBuf: IntPtr; Dest: IntPtr; var IsBlank: boolean);
    procedure GetFieldData(Field: TFieldDesc; RecBuf: IntPtr; Dest: IntPtr); virtual;
    function GetFieldBuf(RecBuf: IntPtr; FieldDesc: TFieldDesc; var DataType: integer; var IsBlank, NativeBuffer: boolean): IntPtr;
    procedure PutField(FieldNo: word; RecBuf: IntPtr; Source: IntPtr);
    procedure PutFieldData(Field: TFieldDesc; RecBuf: IntPtr; Source: IntPtr); virtual;
    function GetNull(FieldNo: word; RecBuf: IntPtr): boolean; virtual;
    procedure SetNull(FieldNo: word; RecBuf: IntPtr; Value: boolean); virtual;
    function GetNullByBlob(FieldNo: word; RecBuf: IntPtr): boolean;

    procedure GetFieldAsVariant(FieldNo: word; RecBuf: IntPtr; var Value: variant); virtual;
    procedure PutFieldAsVariant(FieldNo: word; RecBuf: IntPtr; const Value: variant); virtual;

    procedure GetDateFromBuf(Buf: IntPtr; Offset: integer; Date: IntPtr; Format: TDateFormat); virtual;
    procedure PutDateToBuf(Buf: IntPtr; Offset: integer; Date: IntPtr; Format: TDateFormat); virtual;

    function FindField(Name: string): TFieldDesc;
    function FieldByName(Name: string): TFieldDesc;

    function IsBlobFieldType(DataType: word): boolean; virtual; // TBlob descendants - dtBlob, dtMemo etc
    function IsComplexFieldType(DataType: word): boolean; virtual; // All supported complex field types (BlobFieldTypes, ExtFieldTypes and TSharedObject descendants (not BLOB))

    function HasFields(FieldTypes: TFieldTypeSet): boolean;
    function HasBlobFields: boolean;
    function CheckHasComplexFields: boolean;

  { Records }
    function AllocRecBuf(var RecBuf: IntPtr): IntPtr;
    procedure FreeRecBuf(RecBuf: IntPtr);

    procedure InitRecord(RecBuf: IntPtr);
    //procedure FreeRecord(RecBuf: pointer);
    procedure GetRecord(RecBuf: IntPtr); virtual; abstract;
    procedure GetNextRecord(RecBuf: IntPtr); virtual; abstract;
    procedure GetPriorRecord(RecBuf: IntPtr); virtual; abstract;
    procedure PutRecord(RecBuf: IntPtr); virtual; abstract;
    procedure AppendRecord(RecBuf: IntPtr); virtual; abstract;
    procedure AppendBlankRecord;
    procedure InsertRecord(RecBuf: IntPtr); virtual; abstract;
    procedure UpdateRecord(RecBuf: IntPtr); virtual; abstract; // Modify
    procedure DeleteRecord; virtual; abstract;

    procedure EditRecord(RecBuf: IntPtr);
    procedure PostRecord(RecBuf: IntPtr);
    procedure CancelRecord(RecBuf: IntPtr); virtual;

    procedure CreateComplexFields(RecBuf: IntPtr; WithBlob: boolean); virtual;
    procedure CreateComplexField(RecBuf: IntPtr; FieldIndex: integer; WithBlob: boolean); virtual;
    procedure FreeComplexFields(RecBuf: IntPtr; WithBlob: boolean); virtual;
    procedure CopyComplexFields(Source: IntPtr; Dest: IntPtr; WithBlob: boolean); virtual;  // copy content ComplexFields
    procedure AddRefComplexFields(RecBuf: IntPtr); virtual;

  { Navigation }
    procedure SetToBegin; virtual;
    procedure SetToEnd; virtual;

  { BookMarks }
    procedure GetBookmark(Bookmark: PRecBookmark); virtual;
    procedure SetToBookmark(Bookmark: PRecBookmark); virtual;
    function BookmarkValid(Bookmark: PRecBookmark): boolean; virtual;
    function CompareBookmarks(Bookmark1, Bookmark2: PRecBookmark): integer; virtual;

  { CachedUpdates }
    function GetUpdateStatus: TItemStatus; virtual;
    function GetUpdateResult: TUpdateRecAction; virtual;

    procedure SetCacheRecBuf(NewBuf: IntPtr; OldBuf: IntPtr); virtual;
    procedure ApplyUpdates; virtual;
    procedure CommitUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure RestoreUpdates; virtual;
    procedure RevertRecord; virtual;

    procedure ApplyRecord(UpdateKind: TUpdateRecKind; var Action: TUpdateRecAction; LastItem: boolean); virtual;

    procedure GetOldRecord(RecBuf: IntPtr); virtual; // get rollback data

  { Filter }
    procedure FilterUpdated; virtual;

  { Blobs }
    function GetObject(FieldNo: word; RecBuf: IntPtr): TSharedObject;
    procedure SetObject(FieldNo: word; RecBuf: IntPtr; Obj: TSharedObject);
    function ReadBlob(FieldNo: word; RecBuf: IntPtr; Position: longint;
      Count: longint; Dest: IntPtr; FromRollback: boolean = false; TrueUnicode: boolean = False): longint;
    procedure WriteBlob(FieldNo: word; RecBuf: IntPtr; Position: longint;
      Count: longint; Source: IntPtr; TrueUnicode: boolean = False);
    procedure TruncateBlob(FieldNo: word; RecBuf: IntPtr; Size: longint;
      TrueUnicode: boolean = False);
    function GetBlobSize(FieldNo: word; RecBuf: IntPtr; FromRollback: boolean = false;
      TrueUnicode: boolean = False): longint;
    procedure SetBlobSize(FieldNo: word; RecBuf: IntPtr; NewSize: longint; FromRollback: boolean = false;
      TrueUnicode: boolean = False);

    property RecordSize: longint read FRecordSize;
    property CalcRecordSize: longint read FCalcRecordSize;
    property RecordCount: longint read GetRecordCount;//FRecordCount;
    property RecordNo: longint read GetRecordNo write SetRecordNo;
    property CachedUpdates: boolean read FCachedUpdates write SetCachedUpdates default False;
    property UpdatesPending: boolean read GetUpdatesPending;
    property FilterFunc: TFilterFunc read FFilterFunc write FFilterFunc;
    property FilterMDFunc: TFilterFunc read FFilterMDFunc write FFilterMDFunc;
    property FilterText: string read FFilterText write SetFilterText;
    property FilterCaseInsensitive: boolean read FFilterCaseInsensitive write FFilterCaseInsensitive;
    property FilterNoPartialCompare: boolean read FFilterNoPartialCompare write FFilterNoPartialCompare;
    property FilterItemTypes: TItemTypes read FFilterItemTypes write SetFilterItemTypes;
    property AutoInitFields: boolean read FAutoInitFields write FAutoInitFields;
    property TrimFixedChar: boolean read FTrimFixedChar write FTrimFixedChar;
    property TrimVarChar: boolean read FTrimVarChar write FTrimVarChar;

  /// if False then PutField set Null for string fields with empty value ('')
    property EnableEmptyStrings: boolean read FEnableEmptyStrings write FEnableEmptyStrings;
    property SparseArrays: boolean read FSparseArrays write FSparseArrays;

    property OnAppend: TOnModifyRecord read FOnAppend write FOnAppend;
    property OnDelete: TOnModifyRecord write FOnDelete;
    property OnUpdate: TOnModifyRecord write FOnUpdate;
    property OnApplyRecord: TOnApplyRecord write FOnApplyRecord;
    property OnGetCachedFields: TOnGetCachedFields write FOnGetCachedFields;
    property OnGetCachedBuffer: TOnGetCachedBuffer write FOnGetCachedBuffer;
    property HasComplexFields: boolean read FHasComplexFields write FHasComplexFields;
  end;

  TReorderOption = (roInsert,roDelete,roFull);

  TSortColumn = class
  public
    FieldDesc: TFieldDesc;
    DescendingOrder: boolean;
    CaseSensitive: boolean;
  end;

  TSortColumns = class (TDAList)
  private
    function GetItems(Index: integer): TSortColumn;

  public
    destructor Destroy; override;

    procedure Clear; override;

    property Items[Index: integer]: TSortColumn read GetItems; default;
  end;

  TRecordNoCache = array of PItemHeader;

  TLocateExOption = (lxCaseInsensitive, lxPartialKey, lxNearest, lxNext, lxUp, lxPartialCompare{,lxCharCompare});
  TLocateExOptions = set of TLocateExOption;

  TMemData = class (TData)
  private
    Cache: TCacheItem;
    LastCacheItem: TCacheItem;
    FRefreshIteration: longint;
    FIndexFieldNames: string;
    FIndexFields: TSortColumns;

    FRecordNoCache: TRecordNoCache;

  { Sorting }
    procedure UpdateIndexFields;
    function CompareRecords(RecBuf1, RecBuf2: IntPtr): integer;
    procedure Exchange(I, J: PItemHeader);
    procedure MoveSortedRecord(Dir: integer);
    procedure QuickSort(L, R, P: PItemHeader);
  protected
    FirstItem: PItemHeader;
    LastItem: PItemHeader;
    CurrentItem: PItemHeader;

    BlockMan: TBlockManager;

  { Items/Data }
    function InsertItem: PItemHeader;
    function AppendItem: PItemHeader;
    procedure DeleteItem(Item: PItemHeader);
    procedure RevertItem(Item: PItemHeader);

    procedure InitData; override;
    procedure FreeData; override;

    procedure ReorderItems(Item: PItemHeader; ReorderOption: TReorderOption);

  { Navigation }
    function GetEOF: boolean; override;
    function GetBOF: boolean; override;

    function GetRecordCount: longint; override;
    function GetRecordNo: longint; override;
    procedure SetRecordNo(Value: longint); override;

  { Fetch }
    function Fetch(FetchBack: boolean = False): boolean; virtual;
    procedure InitFetchedItems(FetchedItem: IntPtr; NoData, FetchBack: boolean);

  { Filter/Sorting }
  {$IFNDEF CLR}
    function InternalAnsiStrComp(const Value1, Value2: IntPtr;
      const Options: TLocateExOptions): integer; virtual;
  {$ENDIF}
    function InternalAnsiCompareText(const Value1, Value2: string;
      const Options: TLocateExOptions): integer; virtual;
    function InternalWStrLComp(const Value1, Value2: WideString;
      const Options: TLocateExOptions): integer; virtual;
    function InternalWStrComp(const Value1, Value2: WideString;
      const Options: TLocateExOptions): integer; virtual;

    function CompareStrValues(const Value: string; const FieldValue: string; const Options: TLocateExOptions): integer; virtual;
    function CompareWideStrValues(const Value: WideString; const FieldValue: WideString; const Options: TLocateExOptions): integer; virtual;
    function CompareBinValues(const Value: IntPtr; const ValueLen: integer; const FieldValue: IntPtr; const FieldValueLen: integer; const Options: TLocateExOptions): integer;

  { Edit }
    procedure AddCacheItem(CacheItem: TCacheItem);

  { CachedUpdates }
    function GetUpdatesPending: boolean; override;
    procedure SetFilterItemTypes(Value: TItemTypes); override;

  public
    constructor Create;
    destructor Destroy; override;

  { Open/Close }
    procedure Open; override;
    procedure Reopen; override;

  { Fields }
    procedure InitFields; override;
    procedure ClearFields; override;

  { Records }
    procedure GetRecord(RecBuf: IntPtr); override;
    procedure GetNextRecord(RecBuf: IntPtr); override;
    procedure GetPriorRecord(RecBuf: IntPtr); override;
    procedure PutRecord(RecBuf: IntPtr); override;
    procedure AppendRecord(RecBuf: IntPtr); override;
    procedure InsertRecord(RecBuf: IntPtr); override;
    procedure UpdateRecord(RecBuf: IntPtr); override;
    procedure DeleteRecord; override;
    procedure AddRecord(RecBuf: IntPtr);
    procedure RemoveRecord;  // remove record from memory


    function OmitRecord(Item: PItemHeader): boolean;
    procedure UpdateCachedBuffer(FItem, LItem: PItemHeader); // FItem and LItem can be nil. In this case FirstItem and LastItem used

  { Navigation }
    procedure SetToBegin; override;
    procedure SetToEnd; override;
    procedure PrepareRecNoCache;

  { BookMarks }
    procedure GetBookmark(Bookmark: PRecBookmark); override;
    procedure SetToBookmark(Bookmark: PRecBookmark); override;
    function BookmarkValid(Bookmark: PRecBookmark): boolean; override;
    function CompareBookmarks(Bookmark1, Bookmark2: PRecBookmark): integer; override;

  { CachedUpdates }
    function GetUpdateStatus: TItemStatus; override;
    function GetUpdateResult: TUpdateRecAction; override;

    procedure SetCacheRecBuf(NewBuf: IntPtr; OldBuf: IntPtr); override;
    procedure ApplyUpdates; override;
    procedure CommitUpdates; override;
    procedure CancelUpdates; override;
    procedure RestoreUpdates; override;
    procedure RevertRecord; override;

    procedure GetOldRecord(RecBuf: IntPtr); override;

  { Filter }
    function CompareFieldValue(ValuePtr: IntPtr; const ValueType: integer; FieldDesc: TFieldDesc; RecBuf: IntPtr; const Options: TLocateExOptions): integer; virtual;
    function CompareFields(RecBuf1: IntPtr; RecBuf2: IntPtr; SortColumn: TSortColumn): integer; overload; virtual;
    function CompareFields(RecBuf1: IntPtr; RecBuf2: IntPtr; FieldDesc: TFieldDesc; Options: TLocateExOptions = []): integer; overload; virtual;
    procedure FilterUpdated; override;
    procedure ClearItemsOmittedStatus;

  { Sorting }
    procedure SetIndexFieldNames(Value: string); virtual;
    procedure SortItems; virtual;

    property IndexFields: TSortColumns read FIndexFields;
  end;

{ TBlob }

{$IFDEF CLR}
  PPieceHeader = packed record
  private
    Ptr: IntPtr;

    function GetBlob: integer;
    procedure SetBlob(Value: integer);
    function GetSize: cardinal;
    procedure SetSize(Value: cardinal);
    function GetUsed: cardinal;
    procedure SetUsed(Value: cardinal);
    function GetPrev: PPieceHeader;
    procedure SetPrev(Value: PPieceHeader);
    function GetNext: PPieceHeader;
    procedure SetNext(Value: PPieceHeader);

  public
    property Blob: integer read GetBlob write SetBlob;
    property Size: cardinal read GetSize write SetSize;
    property Used: cardinal read GetUsed write SetUsed;
    property Prev: PPieceHeader read GetPrev write SetPrev;
    property Next: PPieceHeader read GetNext write SetNext;

    class operator Implicit(AValue: IntPtr): PPieceHeader;
    class operator Implicit(AValue: PPieceHeader): IntPtr;
    class operator Implicit(AValue: PPieceHeader): integer;
    class operator Equal(ALeft, ARight: PPieceHeader): boolean;
  end;
{$ELSE}
  PPieceHeader = ^TPieceHeader;
{$ENDIF}
  TPieceHeader = packed record
    Blob: integer;
    Size: cardinal;
    Used: cardinal;  // offest 8 uses GetUsedPtr
    Prev: PPieceHeader;
    Next: PPieceHeader;
    Test: word;       // DEBUG
  end;

  TBlob = class (TSharedObject)
  protected
    FIsUnicode: boolean;

    FFirstPiece: PPieceHeader;
    FNeedRollback: boolean;
    Rollback: TBlob;

    // Used to detect a need to write LOB parameters before executing statement
    FModified: boolean;

    function GetAsString: string; virtual;
    procedure SetAsString(Value: string); virtual;

    function GetAsWideString: WideString; virtual;
    procedure SetAsWideString(Value: WideString); virtual;

    procedure AddCRUnicode;
    procedure RemoveCRUnicode;
    procedure AddCRString;
    procedure RemoveCRString;

    procedure CheckValid;   // DEBUG
    procedure CheckCached;

    procedure CheckValue; virtual;

    procedure SaveToRollback; virtual;

    function GetDataSize: cardinal; // sum of pieces.used
    function GetSize: cardinal; virtual; // if uncompressed then equal to GetDataSize else uncompressed size
    procedure SetSize(Value: cardinal); virtual;
    procedure SetIsUnicode(Value: boolean); virtual;
    procedure InternalClear;

  { Unicode to Ansi conversion methods }
    function TranslatePosition(Position: integer): integer; // Ansi to Unicode
    function GetSizeAnsi: integer;

  public
    PieceSize: cardinal;
    Test: byte;   // DEBUG

    constructor Create(IsUnicode: boolean = False);
    destructor Destroy; override;

  { Pieces }
    procedure AllocPiece(var Piece: PPieceHeader; Size: cardinal);
    procedure ReallocPiece(var Piece: PPieceHeader; Size: cardinal);
    procedure FreePiece(Piece: PPieceHeader);
    procedure AppendPiece(Piece: PPieceHeader);
    procedure DeletePiece(Piece: PPieceHeader);
    procedure CompressPiece(var Piece: PPieceHeader);

    function FirstPiece: PPieceHeader;

    function Read(Position: cardinal; Count: cardinal; Dest: IntPtr): cardinal; virtual;
    procedure Write(Position: cardinal; Count: cardinal; Source: IntPtr); virtual;
    procedure Clear; virtual;
    procedure Truncate(NewSize: cardinal); virtual;
    procedure Compress;
    procedure Defrag; virtual; // Move all data to first piece
    procedure AddCR;
    procedure RemoveCR;

  { Stream/File }

    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    procedure Assign(Source: TBlob);

  { Rollback }
    procedure EnableRollback;
    procedure Commit; virtual;
    procedure Cancel; virtual;
    function CanRollback: boolean;

    property Size: cardinal read GetSize write SetSize;
    property AsString: string read GetAsString write SetAsString;
    property AsWideString: WideString read GetAsWideString write SetAsWideString;
    property IsUnicode: boolean read FIsUnicode write SetIsUnicode;
    property Modified: boolean read FModified;
  end;

const
{$IFDEF CLR}
  DefaultPieceSize: longint = 64*1024 - 22;
{$ELSE}
  DefaultPieceSize: longint = 64*1024 - sizeof(TPieceHeader);  
{$ENDIF}

type
  TBlobUtils = class
  public
    class procedure SetModified(Blob: TBlob; Value: boolean);
  end;

{$IFDEF HAVE_COMPRESS}

{ TCompressedBlob }

const
  CCompressBlobHeaderGuidSize = 16;
  CCompressBlobHeaderSize = CCompressBlobHeaderGuidSize{guid} + SizeOf(Integer){uncompressed size};
  CCompressBlobHeaderGuid: array [0..CCompressBlobHeaderGuidSize - 1] of byte = ($39, $8C, $9D, $F1, $58, $55, $49, $38, $A6, $52, $87, $CE, $E0, $C6, $DA, $7E);

type
  TCompressBlobMode = (
    cbNone, // uncompressed (default)
    cbClient, // store compressed data on client. Save client memory. Other apps can read and write BLOBs on server
    cbServer, // store compressed data on server. Save server memory. Other apps can NOT read and write BLOBs on server
    cbClientServer // store compressed data on client and server.
  );

  TCompressedBlob = class(TBlob)
  protected
    function GetCompressed: boolean;
    procedure SetCompressed(Value: boolean);
    function UnCompressedSize: cardinal;

    function GetSize: cardinal; override;
    procedure SetSize(Value: cardinal); override;
    function GetCompressedSize: cardinal;
    procedure SaveToRollback; override;

    function CompressFrom(source: IntPtr; const sourceLen: longint): boolean;
    procedure UncompressTo(dest: IntPtr; var destlen: integer);

  public
    function Read(Position: cardinal; Count: cardinal; Dest: IntPtr): cardinal; override;
    procedure Write(Position: cardinal; Count: cardinal; Source: IntPtr); override;
    procedure Truncate(NewSize: cardinal); override;
    property Compressed: boolean read GetCompressed write SetCompressed;
    property CompressedSize: cardinal read GetCompressedSize;
  end;
{$ELSE}
type
  TCompressedBlob = class(TBlob);
{$ENDIF}

{ TVariantObject }

  TVariantObject = class (TSharedObject)
  private
    FValue: Variant;

  public
    property Value: Variant read FValue write FValue;
  end;

  function NextPiece(Piece: PPieceHeader): PPieceHeader;
  function PieceData(Piece: PPieceHeader): IntPtr;
  function PieceUsedPtr(Piece: PPieceHeader): IntPtr;

  procedure DataError(Msg: string);

const
  MaxArrayItem: integer = 100; // Max count of fields from array type

{$IFDEF CRDEBUG}
  ShareObjectCnt: integer = 0;
{$ENDIF}

  varDecimal  = $000E;
  varLongWord = $0013;
{$IFNDEF VER6P}
  varInt64    = $0014;

type
  TVarDataD6 = packed record // TVarData from Delphi 6
    VType: word;
    case Integer of
      0: (Reserved1: Word;
        case Integer of
          0: (Reserved2, Reserved3: Word;
            case Integer of
              varLongWord: (VLongWord: LongWord);
              varDecimal: (VInt64: Int64);
          );
      );
  end;

{$ENDIF}

var
  StartWaitProc: procedure;
  StopWaitProc: procedure;
  ApplicationTitleProc: function: string;
{$IFNDEF VER6P}
  ApplicationHandleException: procedure (Sender: TObject) of object;
{$ENDIF}

procedure StartWait;
procedure StopWait;
function ApplicationTitle: string;

function AddCRString(Source, Dest: IntPtr; Count: integer): integer; overload;
function RemoveCRString(Source, Dest: IntPtr; DestLen, Count: integer): integer; overload;

function AddCRUnicode(Source, Dest: IntPtr; Count: integer): integer; overload;
function RemoveCRUnicode(Source, Dest: IntPtr; DestLen, Count: integer): integer; overload;

implementation
uses
  DAConsts, SysUtils, Math;

const
  lxEqual           = 1;
  lxMore            = lxEqual + 1;
  lxLess            = lxMore + 1;
  lxMoreEqual       = lxLess + 1;
  lxLessEqual       = lxMoreEqual + 1;
  lxNoEqual         = lxLessEqual + 1;
  lxLeftBracket     = lxNoEqual + 1;
  lxRightBracket    = lxLeftBracket + 1;
  lxMinus           = lxRightBracket + 1;
  lxPlus            = lxMinus + 1;
  lxLeftSqBracket   = lxPlus + 1;
  lxRightSqBracket  = lxLeftSqBracket + 1;

  lxAND             = lxRightSqBracket + 1;
  lxFALSE           = lxAND + 1;
  lxIS              = lxFALSE + 1;
  lxLIKE            = lxIS + 1;
  lxNOT             = lxLIKE + 1;
  lxNULL            = lxNOT + 1;
  lxOR              = lxNULL + 1;
  lxTRUE            = lxOR + 1;

var
  BoolSymbolLexems, BoolKeywordLexems: TStringList;
  RefreshIteration: longint;

procedure DataError(Msg: string);
begin
  raise Exception.Create(Msg);
end;

procedure StartWait;
begin
  if Assigned(StartWaitProc) then
    StartWaitProc;
end;

procedure StopWait;
begin
  if Assigned(StopWaitProc) then
    StopWaitProc;
end;

function ApplicationTitle: string;
begin
  if Assigned(ApplicationTitleProc) then
    Result := ApplicationTitleProc
  else
    Result := '';
end;

{$IFDEF CLR}

{ PBlockHeader }

function PBlockHeader.GetItemCount: word;
begin
  Result := Marshal.ReadInt16(Ptr);
end;

procedure PBlockHeader.SetItemCount(Value: word);
begin
  Marshal.WriteInt16(Ptr, Value);
end;

function PBlockHeader.GetUsedItems: word;
begin
  Result := Marshal.ReadInt16(Ptr, sizeof(word));
end;

procedure PBlockHeader.SetUsedItems(Value: word);
begin
  Marshal.WriteInt16(Ptr, sizeof(word), Value);
end;

function PBlockHeader.GetPrev: PBlockHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(word) * 2);
end;

procedure PBlockHeader.SetPrev(Value: PBlockHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(word) * 2, Value.Ptr);
end;

function PBlockHeader.GetNext: PBlockHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(word) * 2 + sizeof(PBlockHeader));
end;

procedure PBlockHeader.SetNext(Value: PBlockHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(word) * 2 + sizeof(PBlockHeader), Value.Ptr);
end;

class operator PBlockHeader.Implicit(AValue: IntPtr): PBlockHeader;
begin
  Result.Ptr := AValue;
end;

class operator PBlockHeader.Implicit(AValue: PBlockHeader): IntPtr;
begin
  Result := AValue.Ptr;
end;

class operator PBlockHeader.Implicit(AValue: PBlockHeader): integer;
begin
  Result := AValue.Ptr.ToInt32;
end;

class operator PBlockHeader.Equal(ALeft, ARight: PBlockHeader): boolean;
begin
  Result := ALeft.Ptr = ARight.Ptr;
end;

{ PItemHeader }

function PItemHeader.GetBlock: PBlockHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr);
end;

procedure PItemHeader.SetBlock(Value: PBlockHeader);
begin
  Marshal.WriteIntPtr(Ptr, Value.Ptr);
end;

function PItemHeader.GetPrev: PItemHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(PBlockHeader));
end;

procedure PItemHeader.SetPrev(Value: PItemHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(PBlockHeader), Value.Ptr);
end;

function PItemHeader.GetNext: PItemHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader));
end;

procedure PItemHeader.SetNext(Value: PItemHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader), Value.Ptr);
end;

function PItemHeader.GetRollback: PItemHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 2);
end;

procedure PItemHeader.SetRollback(Value: PItemHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 2, Value.Ptr);
end;

function PItemHeader.GetStatus: TItemStatus;
begin
  Result := TItemStatus(Marshal.ReadByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3));
end;

procedure PItemHeader.SetStatus(Value: TItemStatus);
begin
  Marshal.WriteByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3, byte(Value));
end;

function PItemHeader.GetUpdateResult: TUpdateRecAction;
begin
  Result := TUpdateRecAction(Marshal.ReadByte(Ptr, sizeof(PBlockHeader) +
    sizeof(PItemHeader) * 3 + sizeof(TItemStatus)));
end;

procedure PItemHeader.SetUpdateResult(Value: TUpdateRecAction);
begin
  Marshal.WriteByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus), byte(Value));
end;

function PItemHeader.GetOrder: longint;
begin
  Result := Marshal.ReadInt32(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction));
end;

procedure PItemHeader.SetOrder(Value: longint);
begin
  Marshal.WriteInt32(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction), Value);
end;

function PItemHeader.GetFlag: byte;
begin
  Result := Marshal.ReadByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction) + sizeof(longint));
end;

procedure PItemHeader.SetFlag(Value: byte);
begin
  Marshal.WriteByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction) + sizeof(longint), Value);
end;

function PItemHeader.GetFilterResult: TItemFilterState;
begin
  Result := TItemFilterState(Marshal.ReadByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction) + sizeof(longint) +
    SizeOf(byte)));
end;

procedure PItemHeader.SetFilterResult(Value: TItemFilterState);
begin
  Marshal.WriteByte(Ptr, sizeof(PBlockHeader) + sizeof(PItemHeader) * 3 +
    sizeof(TItemStatus) + sizeof(TUpdateRecAction) + sizeof(longint) +
    SizeOf(byte), Byte(Value));
end;
  
class operator PItemHeader.Implicit(AValue: IntPtr): PItemHeader;
begin
  Result.Ptr := AValue;
end;

class operator PItemHeader.Implicit(AValue: PItemHeader): IntPtr;
begin
  Result := AValue.Ptr;
end;

class operator PItemHeader.Implicit(AValue: PItemHeader): integer;
begin
  Result := AValue.Ptr.ToInt32;
end;

class operator PItemHeader.Equal(ALeft, ARight: PItemHeader): boolean;
begin
  Result := ALeft.Ptr = ARight.Ptr;
end;

{ PRecBookmark }

function PRecBookmark.GetRefreshIteration: longint;
begin
  Result := Marshal.ReadInt32(Ptr);
end;

procedure PRecBookmark.SetRefreshIteration(Value: longint);
begin
  Marshal.WriteInt32(Ptr, Value);
end;

function PRecBookmark.GetItem: PItemHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(longint));
end;

procedure PRecBookmark.SetItem(Value: PItemHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(longint), Value);
end;

function PRecBookmark.GetOrder: longint;
begin
  Result := Marshal.ReadInt32(Ptr, sizeof(longint) + sizeof(PItemHeader));
end;

procedure PRecBookmark.SetOrder(Value: longint);
begin
  Marshal.WriteInt32(Ptr, sizeof(longint) + sizeof(PItemHeader), Value);
end;

class operator PRecBookmark.Implicit(AValue: IntPtr): PRecBookmark;
begin
  Result.Ptr := AValue;
end;

class operator PRecBookmark.Implicit(AValue: PRecBookmark): IntPtr;
begin
  Result := AValue.Ptr;
end;

class operator PRecBookmark.Implicit(AValue: integer): PRecBookmark;
begin
  Result.Ptr := IntPtr(AValue);
end;

{ PPieceHeader }

function PPieceHeader.GetBlob: integer;
begin
  Result := Marshal.ReadInt32(Ptr);
end;

procedure PPieceHeader.SetBlob(Value: integer);
begin
  Marshal.WriteInt32(Ptr, Value);
end;

function PPieceHeader.GetSize: cardinal;
begin
  Result := Marshal.ReadInt32(Ptr, sizeof(integer));
end;

procedure PPieceHeader.SetSize(Value: cardinal);
begin
  Marshal.WriteInt32(Ptr, sizeof(integer), Value);
end;

function PPieceHeader.GetUsed: cardinal;
begin
  Result := Marshal.ReadInt32(Ptr, sizeof(integer) * 2);
end;

procedure PPieceHeader.SetUsed(Value: cardinal);
begin
  Marshal.WriteInt32(Ptr, sizeof(integer) * 2, Value);
end;

function PPieceHeader.GetPrev: PPieceHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(integer) * 3);
end;

procedure PPieceHeader.SetPrev(Value: PPieceHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(integer) * 3, Value.Ptr);
end;

function PPieceHeader.GetNext: PPieceHeader;
begin
  Result := Marshal.ReadIntPtr(Ptr, sizeof(integer) * 3 + sizeof(PPieceHeader));
end;

procedure PPieceHeader.SetNext(Value: PPieceHeader);
begin
  Marshal.WriteIntPtr(Ptr, sizeof(integer) * 3 + sizeof(PPieceHeader), Value.Ptr);
end;

class operator PPieceHeader.Implicit(AValue: IntPtr): PPieceHeader;
begin
  Result.Ptr := AValue;
end;

class operator PPieceHeader.Implicit(AValue: PPieceHeader): IntPtr;
begin
  Result := AValue.Ptr;
end;

class operator PPieceHeader.Implicit(AValue: PPieceHeader): integer;
begin
  Result := AValue.Ptr.ToInt32;
end;

class operator PPieceHeader.Equal(ALeft, ARight: PPieceHeader): boolean;
begin
  Result := ALeft.Ptr = ARight.Ptr;
end;
{$ENDIF}

{ TFieldDesc }

constructor TFieldDesc.Create;
begin
  inherited;
end;

destructor TFieldDesc.Destroy;
begin
  if FObjectType <> nil then
    FObjectType.Release;

  inherited;
end;

function TFieldDesc.HasParent: boolean;
begin
  Result := FParentField <> nil;
end;

procedure TFieldDesc.Assign(FieldDesc:TFieldDesc);
begin
  Name := FieldDesc.Name;
  ActualName := FieldDesc.ActualName;
  DataType := FieldDesc.DataType;
  Length := FieldDesc.Length;
  Scale := FieldDesc.Scale;
  Size := FieldDesc.Size;
  Offset := FieldDesc.Offset;
  Required := FieldDesc.Required;
  FieldNo := FieldDesc.FieldNo;
end;

procedure TFieldDesc.SetObjectType(Value:TObjectType);
begin
  if Value <> FObjectType then begin
    if FObjectType <> nil then
      FObjectType.Release;

    FObjectType := Value;

    if FObjectType <> nil then
      FObjectType.AddRef;
  end;
end;

{ TFieldDescs }

destructor TFieldDescs.Destroy;
begin
  Clear;

  inherited;
end;

procedure TFieldDescs.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i] <> nil then
      TFieldDesc(Items[i]).Free;

  inherited Clear;
end;

function TFieldDescs.FindField(Name: string):TFieldDesc;
var
  i: integer;
  ComplexField: boolean;
  Found: boolean;
begin
  Result := nil;
  ComplexField := (Pos('.', Name) > 0) or (Pos('[', Name) > 0);
  if not ComplexField then
    for i := 0 to Count - 1 do
      if (Items[i] <> nil) and (not TFieldDesc(Items[i]).HasParent) then begin
        Found := AnsiCompareText(TFieldDesc(Items[i]).Name, Name) = 0;

        if Found then begin
          Result := Items[i];
          Exit;
        end;
      end;
  for i := 0 to Count - 1 do
    if (Items[i] <> nil) then begin
      Found := False;
      if ComplexField then
        Found := AnsiCompareText(TFieldDesc(Items[i]).ActualName, Name) = 0
      else
      if (TFieldDesc(Items[i]).HasParent) then
        Found := AnsiCompareText(TFieldDesc(Items[i]).Name, Name) = 0;

      if Found then begin
        Result := Items[i];
        Exit;
      end;
    end;
end;

function TFieldDescs.FieldByName(Name: string): TFieldDesc;
begin
  Result := FindField(Name);

  if Result = nil then
    raise Exception.Create(Format(SFieldNotFound, [Name]));
end;

function TFieldDescs.GetItems(Index: integer): TFieldDesc;
begin
  Result := TFieldDesc(inherited Items[Index]);
end;

{ TAttribute }

constructor TAttribute.Create;
begin
  inherited;
end;

destructor TAttribute.Destroy;
begin
  if (FObjectType <> nil) and (FOwner.Name <> FObjectType.Name) then
    FObjectType.Release;

  inherited;
end;

procedure TAttribute.SetObjectType(Value:TObjectType);
begin
  if Value <> FObjectType then begin
    if FObjectType <> nil then
      FObjectType.Release;

    FObjectType := Value;

    if (FObjectType <> nil) and (FOwner.Name <> FObjectType.Name) then
      FObjectType.AddRef;
  end;
end;

{ TObjectType }

constructor TObjectType.Create;
begin
  inherited;

  FAttributes := TDAList.Create;
end;

destructor TObjectType.Destroy;
begin
  ClearAttributes;
  FAttributes.Free;

  inherited;
end;

{function TObjectType.AddAttribute:TAttribute;
begin
  Result := TAttribute.Create;
  FAttributes.Add(Result);
end;}

procedure TObjectType.ClearAttributes;
var
  i: integer;
begin
  for i := 0 to FAttributes.Count - 1 do
    TAttribute(FAttributes[i]).Free;
  FAttributes.Clear;
end;

function TObjectType.FindAttribute(Name: string):TAttribute;
var
  St: string;
  iPos,IndexPos: integer;
  i: integer;
  OType:TObjectType;
begin
  Name := AnsiUpperCase(Name);
  OType := Self;

  repeat
    Name := TrimLeft(Name);

    iPos := Pos('.', Name);
    IndexPos := Pos('[', Name);
    if IndexPos = 1 then begin
      i := Pos(']', Name);
      if i = 0 then begin
        Result := nil;
        Exit;
      end;
      if (i + 1 <= Length(Name)) and (Name[i + 1] = '.') then
        Inc(i);

      St := 'ELEMENT';
      Name := Copy(Name, i + 1, Length(Name));
    end
    else
      if (iPos > 0) and ((iPos < IndexPos) or (IndexPos = 0)) then begin
        St := Copy(Name, 1, iPos - 1);
        Name := Copy(Name, iPos + 1, Length(Name));
      end
      else
        if IndexPos > 0 then begin
          St := Copy(Name, 1, IndexPos - 1);
          Name := Copy(Name, IndexPos, Length(Name));
        end
        else
          St := Name;

    Result := nil;
    for i := 0 to OType.AttributeCount - 1 do
      if AnsiUpperCase(TAttribute(OType.Attributes[i]).Name) = St then begin
        Result := OType.Attributes[i];
        break;
      end;

    if (Result = nil) or not(Result.DataType in [dtObject,dtArray,dtTable,dtReference]) and
      (iPos <> 0)
    then begin
      Result := nil;
      Exit;
    end;

    OType := Result.ObjectType;
  until (iPos = 0) and ((IndexPos = 0) or (Name = ''));
end;

function TObjectType.AttributeByName(Name: string):TAttribute;
begin
  Result := FindAttribute(Name);
  if Result = nil then
    raise Exception.Create(Format(SAttributeNotFount, [Name]));
end;

function TObjectType.GetAttributes(Index: integer):TAttribute;
begin
  Result := TAttribute(FAttributes[Index]);
end;

function TObjectType.GetAttributeCount: integer;
begin
  Result := FAttributes.Count;
end;

{ TDBObject }

constructor TDBObject.Create;
begin
  inherited;
end;

procedure TDBObject.SetObjectType(Value:TObjectType);
begin
  if FObjectType <> nil then
    FObjectType.Release;

  FObjectType := Value;

  if FObjectType <> nil then
    FObjectType.AddRef;
end;

procedure TDBObject.GetAttributeValue(Name: string; Dest: IntPtr; var IsBlank: boolean);
begin
  IsBlank := True;
end;

procedure TDBObject.SetAttributeValue(Name: string; Source: IntPtr);
begin
end;

{ TBoolParser }

constructor TBoolParser.Create(const Text: string);
begin
  inherited Create(Text);

  FSymbolLexems := BoolSymbolLexems;
  FKeywordLexems := BoolKeywordLexems;
end;

procedure TBoolParser.ToRightQuote(LeftQuote: Char);
begin
  while (Pos <= TextLength) and (Text[Pos] <> LeftQuote) do begin
    Inc(Pos);
    if (Pos + 1 <= TextLength) and (Text[Pos] = '''') and (Text[Pos + 1] = '''') then
      Inc(Pos, 2);
  end;
end;

{ TData }

{$IFDEF CRDEBUG}
const
  DataCnt: integer = 0;
{$ENDIF}

constructor TData.Create;
begin
  inherited;

  FEOF := True;
  FBOF := True;
  FFields := TFieldDescs.Create;
  FAutoInitFields := True;
  FEnableEmptyStrings := False;

{$IFDEF CRDEBUG} Inc(DataCnt); {$ENDIF}
  StringHeap := TStringHeap.Create;
end;

destructor TData.Destroy;
begin
  Close;

  ClearFields;
  FFields.Free;
  StringHeap.Free;

  inherited;

{$IFDEF CRDEBUG} Dec(DataCnt); {$ENDIF}
end;

{ Data }

procedure TData.InitData;
begin
  FBOF := True;
  FEOF := True;
  FRecordCount := 0;
  FRecordNoOffset := 0;
end;

procedure TData.FreeData;
begin
  InitData;
end;

{ Open / Close }

procedure TData.InternalPrepare;
begin
end;

procedure TData.Prepare;
begin
  InternalPrepare;
  Prepared := True; // lost connection
end;

procedure TData.InternalUnPrepare;
begin
end;

procedure TData.UnPrepare;
begin
  if Prepared then begin
    Prepared := False;
    if FAutoInitFields then
      ClearFields;
    InternalUnPrepare;
  end;
end;

procedure TData.InternalOpen;
begin
end;

procedure TData.Open;
begin
  if not Active then begin
    InitData;
    try
      InternalOpen;
      CreateFilterExpression(FFilterText); // ???
    except
      FreeData;
      FreeFilterExpression;
      raise;
    end;

    Active := True;
  end;
end;

procedure TData.InternalClose;
begin
end;

procedure TData.Close;
begin
  try
    if Active then
      InternalClose;
  finally
    Active := False;
    FreeData;         // FreeData after for multithreads

    if FAutoInitFields and not Prepared then // After FreeData!
      ClearFields;

    FreeFilterExpression;
  end;
end;

function TData.IsFullReopen: boolean;
begin
  Result := True;
end;

procedure TData.Reopen;
begin
  Close;
  Open;
end;

{ Field }

function TData.GetFieldCount: word;
begin
  Result := FFields.Count;
end;

function TData.GetIndicatorSize: word;
begin
  Result := FieldCount;
end;

function TData.GetFieldDescType: TFieldDescClass;
begin
  Result := TFieldDesc;
end;

procedure TData.InternalInitFields;
begin
end;

function TData.GetArrayFieldName(ObjectType: TObjectType; ItemIndex: integer): string;
begin
  Result := '[' + IntToStr(ItemIndex) + ']';
end;

procedure TData.InitObjectFields(ObjectType:TObjectType; Parent: TFieldDesc);
var
  i: integer;
  Field:TFieldDesc;
  Item,CountItem: integer;
begin
  if (ObjectType.DataType in [dtObject,dtTable]) or FSparseArrays then
    CountItem := 1
  else begin
    CountItem := ObjectType.Size;
    if CountItem > MaxArrayItem then  // Restriction of array length
      CountItem := MaxArrayItem;
  end;

  for i := 0 to ObjectType.AttributeCount - 1 do begin
    for Item := 0 to CountItem - 1 do begin
      Field := GetFieldDescType.Create;
      Field.ParentField := Parent;
      if ObjectType.DataType in [dtObject,dtTable] then begin
        Field.Name := ObjectType.Attributes[i].Name;
        if Parent = nil then
          Field.ActualName := Field.Name
        else
          Field.ActualName := Parent.ActualName + '.' + Field.Name;
      end
      else begin
        Field.Name := GetArrayFieldName(ObjectType, Item);
        if Parent = nil then
          Field.ActualName := Field.Name
        else
          Field.ActualName := Parent.ActualName + Field.Name;
      end;

      Field.DataType := ObjectType.Attributes[i].DataType;
      Field.Size := 0;// ObjectType.Attributes[i].Size;
      Field.Fixed := ObjectType.Attributes[i].Fixed;
      Field.Length := ObjectType.Attributes[i].Length;
      Field.FieldNo := FFields.Count + 1;
      Field.ObjectType := ObjectType.Attributes[i].ObjectType;
      if Parent <> nil then
        Field.ReadOnly := Parent.ReadOnly;
      FFields.Add(Field);

      if Field.DataType in [dtObject,dtArray] then
        InitObjectFields(Field.ObjectType, Field);
    end;
  end;
end;

function CompareAlias(Field1, Field2: {$IFDEF CLR}TObject{$ELSE}pointer{$ENDIF}): integer;
begin
  if Field1 = Field2 then
    Result := 0
  else begin
    Result := AnsiCompareText(TFieldDesc(Field1).Name, TFieldDesc(Field2).Name);
    if Result = 0 then begin
      Result := TFieldDesc(Field1).FieldNo - TFieldDesc(Field2).FieldNo;
      TFieldDesc(Field1).FReserved := True;
      TFieldDesc(Field2).FReserved := True;
    end;
  end
end;

procedure TData.InitFields;
var
  i: integer;

  // perfomance optimization for many fields set aliases
  procedure InitAliases;
  var
    AliasNum, AliasLen: integer;
    AFields: TDAList;
    i: integer;
    s: string;

    procedure ReplaceNextOriginalNames(StartName: string; StartInd: integer);
    var
      i, Res: integer;
      AliasNum: integer;
      S: string;
    begin
      AliasNum := 1;
      for i := StartInd to AFields.Count - 1 do begin
        S := TFieldDesc(AFields[i]).Name;
        Res := AnsiCompareTextS(StartName, S);
        if (Res < 0) then
          break;
        if (Res = 0) then begin
          TFieldDesc(AFields[i]).Name := S + '_' + IntToStr(AliasNum);
          Inc(AliasNum);
          ReplaceNextOriginalNames(TFieldDesc(AFields[i]).Name, i + 1);
        end;
      end;
    end;
  begin
    AFields := TDAList.Create;
    try
      AFields.Capacity := FFields.Capacity;
      for i := 0 to FFields.Count - 1 do
        if (FFields[i] <> nil) and (TFieldDesc(FFields[i]).ParentField = nil) then
          AFields.Add(FFields[i]);

      AFields.Sort(CompareAlias);
      AliasNum := 0;
      for i := 0 to AFields.Count - 1 do
        if (TFieldDesc(AFields[i]).FReserved) or (TFieldDesc(AFields[i]).Name = '') then begin
          if (AliasNum > 1) then begin
            s := TFieldDesc(AFields[i-1]).Name;
            AliasLen := 1 {'_'} + Length(IntToStr((AliasNum - 1)));
            SetLength(s, Length(s) - AliasLen);
            if (AnsiCompareText(s, TFieldDesc(AFields[i]).Name) <> 0) then
              AliasNum := 0;
          end;
          if (AliasNum <> 0) or (TFieldDesc(AFields[i]).Name = '') then begin
            TFieldDesc(AFields[i]).Name := TFieldDesc(AFields[i]).Name + '_' + IntToStr(AliasNum);
            ReplaceNextOriginalNames(TFieldDesc(AFields[i]).Name, i + 1);
          end;
          Inc(AliasNum);
        end else
          AliasNum := 0;
    finally
      AFields.Free;
    end;
  end;

var
  Off, AlignOff: integer;
  FieldDesc: TFieldDesc;
begin
  if FAutoInitFields then begin
    ClearFields;
    InternalInitFields;
    if Assigned(FOnGetCachedFields) then
      FOnGetCachedFields();
    InitAliases;
  end;

  DataSize := 0;
  CalcDataSize := 0;
  for i := 0 to FieldCount - 1 do
    if Fields[i].FieldDescKind <> fdkCalculated then begin
      FieldDesc := Fields[i];
      FieldDesc.Offset := DataSize;

      if FieldDesc.DataType = dtWideString then begin
        Off := FieldDesc.Offset;
        AlignOff := Off and 1; // Fields[i].Offset mod 2;
        FieldDesc.Offset := Off + AlignOff; // align WideString field offset
      end
      else
        AlignOff := 0;

      DataSize := DataSize + FieldDesc.Size + AlignOff;
    end;

  FRecordSize := DataSize + IndicatorSize;
  FRecordSize := FRecordSize + (FRecordSize + 1) mod 2; //align

  for i := 0 to FieldCount - 1 do
    if Fields[i].FieldDescKind = fdkCalculated then begin
      FieldDesc := Fields[i];
      FieldDesc.Offset := FRecordSize + CalcDataSize;

      if FieldDesc.DataType = dtWideString then begin
        Off := FieldDesc.Offset;
        AlignOff := Off and 1; // Fields[i].Offset mod 2;
        FieldDesc.Offset := Off + AlignOff; // align WideString field offset
      end
      else
        AlignOff := 0;

      CalcDataSize := CalcDataSize + FieldDesc.Size + AlignOff;
    end;

  FCalcRecordSize := CalcDataSize;
  if FCalcRecordSize > 0 then
    FCalcRecordSize := FCalcRecordSize + (FCalcRecordSize + 1) mod 2; //align
  CheckHasComplexFields;
end;

procedure TData.ClearFields;
begin
  FFields.Clear;
end;

procedure TData.GetDateFromBuf(Buf: IntPtr; Offset: integer; Date: IntPtr; Format: TDateFormat);
var
  DateTime: double;
begin
  DateTime := BitConverter.Int64BitsToDouble(Marshal.ReadInt64(Buf, Offset));
  case Format of
    dfMSecs: begin
      DateTime := TimeStampToMSecs(DateTimeToTimeStamp(DateTime));
      Marshal.WriteInt64(Date, BitConverter.DoubleToInt64Bits(DateTime));
    end;
    dfDateTime:
      Marshal.WriteInt64(Date, BitConverter.DoubleToInt64Bits(DateTime));
    dfDate:
      Marshal.WriteInt32(Date, DateTimeToTimeStamp(DateTime).Date);
    dfTime:
      Marshal.WriteInt32(Date, DateTimeToTimeStamp(DateTime).Time);
  end;
end;

procedure TData.PutDateToBuf(Buf: IntPtr; Offset: integer; Date: IntPtr; Format: TDateFormat);
var
  Ts: TTimeStamp;
  DateTime: TDateTime;
begin
  case Format of
    dfMSecs: begin
    {$IFDEF CLR}
      DateTime := MemUtils.TimeStampToDateTime(MSecsToTimeStamp(Trunc(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(Date)))));
    {$ELSE}
      DateTime := MemUtils.TimeStampToDateTime(MSecsToTimeStamp(TDateTime(Date^)));
    {$ENDIF}
      Marshal.WriteInt64(Buf, Offset, BitConverter.DoubleToInt64Bits(DateTime));
    end;
    dfDateTime:
      Marshal.WriteInt64(Buf, Offset, Marshal.ReadInt64(Date));
    dfDate: begin
      Ts.Date := Marshal.ReadInt32(Date);
      Ts.Time := 0;
      Marshal.WriteInt64(Buf, Offset, BitConverter.DoubleToInt64Bits(MemUtils.TimeStampToDateTime(Ts)));
    end;
    dfTime: begin
      Ts.Date := DateDelta;
      Ts.Time := Marshal.ReadInt32(Date);
      Marshal.WriteInt64(Buf, Offset, BitConverter.DoubleToInt64Bits(MemUtils.TimeStampToDateTime(Ts)));
    end;
  end;
end;

procedure TData.GetChildFieldInfo(Field: TFieldDesc; var RootField: TFieldDesc; var AttrName: string);
begin
  AttrName := '';
  repeat
    if AttrName = '' then
      AttrName := Field.Name
    else
      if Field.DataType = dtArray then
        AttrName := Field.Name + AttrName
      else
        AttrName := Field.Name + '.' + AttrName;
    Field := Field.ParentField;
  until not Field.HasParent;
  RootField := Field;
end;

procedure TData.GetChildField(Field: TFieldDesc; RecBuf: IntPtr; Dest: IntPtr; var IsBlank: boolean);
var
  DBObject: IntPtr;
  AttrName: string;
begin
  GetChildFieldInfo(Field, Field, AttrName);
  DBObject := Marshal.ReadIntPtr(RecBuf, Field.Offset);
  if DBObject <> nil then
    TDBObject(GetGCHandleTarget(DBObject)).GetAttributeValue(AttrName, Dest, IsBlank)
  else
    IsBlank := True;
end;

procedure TData.PutChildField(Field: TFieldDesc; RecBuf: IntPtr; Source: IntPtr);
var
  DBObject: IntPtr;
  AttrName: string;
begin
  GetChildFieldInfo(Field, Field, AttrName);
  DBObject := Marshal.ReadIntPtr(RecBuf, Field.Offset);
  if DBObject <> nil then
    TDBObject(GetGCHandleTarget(DBObject)).SetAttributeValue(AttrName, Source);
end;

const
  CRLF = $0A0D;
  LF   = $0A;
  CRLF_UTF16 = $000A000D;
  LF_UTF16   = $000A;

function AddCRString(Source, Dest: IntPtr; Count: integer): integer;
var
  SourceEnd: IntPtr;
  w: word;
  b: byte;
begin
  Result := Count;
  SourceEnd := IntPtr(Integer(Source) + Count);
  while Integer(Source) < Integer(SourceEnd) do begin
    w := Marshal.ReadInt16(Source);
    if w = CRLF then begin
      Marshal.WriteInt16(Dest, w);
      Source := IntPtr(Integer(Source) + 2);
      Dest := IntPtr(Integer(Dest) + 2);
    end
    else begin
      b := Byte(w);
      if b = 0 then begin
        Dec(Result, Integer(SourceEnd) - Integer(Source));
        break;
      end
      else      
      if b = LF then begin
        Marshal.WriteInt16(Dest, CRLF);
        Source := IntPtr(Integer(Source) + 1);
        Dest := IntPtr(Integer(Dest) + 2);
        Inc(Result);
      end
      else begin
        Marshal.WriteByte(Dest, b);
        Source := IntPtr(Integer(Source) + 1);
        Dest := IntPtr(Integer(Dest) + 1);
      end;
    end;
  end;
  Marshal.WriteByte(Dest, 0);
end;

function RemoveCRString(Source, Dest: IntPtr; DestLen, Count: integer): integer;
var
  SourceEnd: IntPtr;
  DestStart: IntPtr;
  w: word;
begin
  Result := Count;
  SourceEnd := IntPtr(Integer(Source) + Count);
  DestStart := Dest;
  while (Integer(Source) < Integer(SourceEnd)) and (Integer(Dest) - Integer(DestStart) < DestLen) do begin
    w := Marshal.ReadInt16(Source);
    if w = CRLF then begin
      Marshal.WriteByte(Dest, LF);
      Source := IntPtr(Integer(Source) + 2);
      Dec(Result);
      Dest := IntPtr(Integer(Dest) + 1);
    end
    else
    begin
      Marshal.WriteByte(Dest, Byte(w));
      Source := IntPtr(Integer(Source) + 1);
      Dest := IntPtr(Integer(Dest) + 1);
    end;
  end;
  Marshal.WriteByte(Dest, 0);
end;

function AddCRUnicode(Source, Dest: IntPtr; Count: integer): integer;
var
  SourceEnd: IntPtr;
  w: LongWord;
  b: word;
begin
  Result := Count;
  SourceEnd := IntPtr(Integer(Source) + Count * 2);
  while Integer(Source) < Integer(SourceEnd) do begin
    w := Marshal.ReadInt32(Source);
    if w = CRLF_UTF16 then begin
      Marshal.WriteInt32(Dest, w);
      Source := IntPtr(Integer(Source) + 4);
      Dest := IntPtr(Integer(Dest) + 4);
    end
    else begin
      b := Word(w);
      if b = 0 then begin
        Dec(Result, (Integer(SourceEnd) - Integer(Source)) div 2);
        break;
      end
      else      
      if b = LF_UTF16 then begin
        Marshal.WriteInt32(Dest, CRLF_UTF16);
        Source := IntPtr(Integer(Source) + 2);
        Dest := IntPtr(Integer(Dest) + 4);
        Inc(Result);
      end
      else begin
        Marshal.WriteInt16(Dest, b);
        Source := IntPtr(Integer(Source) + 2);
        Dest := IntPtr(Integer(Dest) + 2);
      end;
    end;
  end;
  Marshal.WriteInt16(Dest, 0);
end;

function RemoveCRUnicode(Source, Dest: IntPtr; DestLen, Count: integer): integer;
var
  SourceEnd: IntPtr;
  DestStart: IntPtr;
  w: LongWord;
begin
  Result := Count;
  SourceEnd := IntPtr(Integer(Source) + Count * 2);
  DestStart := Dest;
  while (Integer(Source) < Integer(SourceEnd)) and (Integer(Dest) - Integer(DestStart) < DestLen * 2) do begin
    w := Marshal.ReadInt32(Source);
    if w = CRLF_UTF16 then begin
      Marshal.WriteInt16(Dest, LF_UTF16);
      Source := IntPtr(Integer(Source) + 4);
      Dec(Result);
      Dest := IntPtr(Integer(Dest) + 2);
    end
    else
    begin
      Marshal.WriteInt16(Dest, Word(w));
      Source := IntPtr(Integer(Source) + 2);
      Dest := IntPtr(Integer(Dest) + 2);
    end;
  end;
  Marshal.WriteInt16(Dest, 0);
end;

function TData.NeedConvertEOL: boolean;
begin
  Result := False;
end;

procedure TData.GetFieldData(Field: TFieldDesc; RecBuf: IntPtr; Dest: IntPtr);
var
  Data: IntPtr;
begin
  case Field.DataType of
    dtUInt32:
      Marshal.WriteInt64(Dest, Longword(Marshal.ReadInt32(RecBuf, Field.Offset)));
    dtDateTime:
      GetDateFromBuf(RecBuf, Field.Offset, Dest, dfMSecs);
    dtDate:
      GetDateFromBuf(RecBuf, Field.Offset, Dest, dfDate);
    dtTime:
      GetDateFromBuf(RecBuf, Field.Offset, Dest, dfTime);
  {$IFDEF VER5P}
    dtVariant:
    {$IFDEF CLR}
      Assert(False);
    {$ELSE}
      Variant(Dest^) := TVariantObject(Marshal.ReadIntPtr(RecBuf, Field.Offset)).Value;
    {$ENDIF}
  {$ENDIF}
  {$IFDEF VER6P}
    dtFmtBCD:
      CopyBuffer(IntPtr(Integer(RecBuf) + Field.Offset), Dest, SizeOfTBcd); // To avoid errors if Field.Size > SizeOfTBcd 
  {$ENDIF}
    dtExtString: begin
      Assert(Marshal.ReadIntPtr(RecBuf, Field.Offset) <> nil);
      if NeedConvertEOL then
        AddCRString(Marshal.ReadIntPtr(RecBuf, Field.Offset), Dest, MaxInt div 2)
      else
        StrCopy(Dest, Marshal.ReadIntPtr(RecBuf, Field.Offset));
    end;
    dtExtWideString: begin
      Assert(Marshal.ReadIntPtr(RecBuf, Field.Offset) <> nil);
      if NeedConvertEOL then
        AddCRUnicode(Marshal.ReadIntPtr(RecBuf, Field.Offset), Dest, MaxInt div 4)
      else
        StrCopyW(Dest, Marshal.ReadIntPtr(RecBuf, Field.Offset));
    end;
    dtExtVarBytes: begin
      Data := Marshal.ReadIntPtr(RecBuf, Field.Offset);
      CopyBuffer(Data, Dest, Marshal.ReadInt16(Data) + SizeOf(Word));
    end;
    dtString:
      if NeedConvertEOL then
        AddCRString(IntPtr(Integer(RecBuf) + Field.Offset), Dest, Field.Size)
      else
        StrLCopy(Dest, IntPtr(Integer(RecBuf) + Field.Offset), Field.Size);
    dtWideString: begin
      if NeedConvertEOL then
        AddCRUnicode(IntPtr(Integer(RecBuf) + Field.Offset), Dest, Field.Size)
      else
        StrLCopyW(Dest, IntPtr(Integer(RecBuf) + Field.Offset), Field.Size);
    end;
  {$IFDEF CLR}
    dtBytes:
      CopyBuffer(IntPtr(Integer(RecBuf) + Field.Offset), Dest, Field.Length);
  {$ENDIF}
  else
    CopyBuffer(IntPtr(Integer(RecBuf) + Field.Offset), Dest, Field.Size);
  end;
end;

procedure TData.GetField(FieldNo: word; RecBuf: IntPtr; Dest: IntPtr; var IsBlank: boolean);
var
  Field: TFieldDesc;
  DataType: word;
  t: boolean;
  l: integer;

begin
  Assert((FieldNo <= FieldCount) and (FieldNo > 0));

  IsBlank := GetNull(FieldNo, RecBuf);

  Field := Fields[FieldNo - 1];

  DataType := Field.DataType;
  if (Dest = nil) or IsBlank and (not IsComplexFieldType(DataType)
    or (DataType = dtExtString) or (DataType = dtExtWideString)
    or (DataType = dtExtVarBytes))
  then
    Exit;

  if not Field.HasParent then
    GetFieldData(Field, RecBuf, Dest)
  else
    GetChildField(Field, RecBuf, Dest, IsBlank);

  if not IsBlank and (Field.DataType in [dtString, dtWideString]) then begin// trim fixed char values
    if Field.Fixed then begin
      t := FTrimFixedChar;
      l := Field.Length;
    end
    else begin
      t := FTrimVarChar;
      l := -1;
    end;
    if t then
      if Field.DataType = dtString then
        StrTrim(Dest, l)
      else
        StrTrimW(Dest, l);
  end;
end;

function TData.GetFieldBuf(RecBuf: IntPtr; FieldDesc: TFieldDesc; var DataType: integer; var IsBlank, NativeBuffer: boolean): IntPtr;
var
  FieldBufStatic: IntPtr;
  ValueBuf: IntPtr;
  Len: integer;
begin
  NativeBuffer := True;
  FieldBufStatic := nil;
  ValueBuf := nil;
  try
    if FieldDesc.ParentField = nil then begin
      Result := IntPtr(integer(RecBuf) + FieldDesc.Offset);
      IsBlank := GetNull(FieldDesc.FieldNo, RecBuf);
    end
    else begin
    // support objects
      FieldBufStatic := Marshal.AllocHGlobal(4001);
      Result := FieldBufStatic;
      GetField(FieldDesc.FieldNo, RecBuf, Result, IsBlank);  // GetChildField
    end;

    if not IsBlank then begin
      DataType := FieldDesc.DataType;
      case DataType of
        dtExtString: begin
          Result := Marshal.ReadIntPtr(Result);
          DataType := dtString;
        end;
        dtExtWideString: begin
          Result := Marshal.ReadIntPtr(Result);
          DataType := dtWideString;
        end;
        dtExtVarBytes:
          Result := Marshal.ReadIntPtr(Result);
        dtBCD: begin
          ValueBuf := Marshal.AllocHGlobal(SizeOf(double));
          Marshal.WriteInt64(ValueBuf, BitConverter.DoubleToInt64Bits(Marshal.ReadInt64(Result) / 10000));
          Result := ValueBuf;
        end;
        dtDateTime, dtDate, dtTime: begin
          ValueBuf := Marshal.AllocHGlobal(SizeOf(double));
          GetDateFromBuf(RecBuf, FieldDesc.Offset, ValueBuf, dfDateTime);
          Result := ValueBuf;
        end;
        dtBytes: begin
          ValueBuf := Marshal.AllocHGlobal(FieldDesc.Length + SizeOf(Word));
          Marshal.WriteInt16(ValueBuf, FieldDesc.Length);
          CopyBuffer(Result, IntPtr(Integer(ValueBuf) + SizeOf(Word)), FieldDesc.Length);
          Result := ValueBuf;
        end;
        else
          if IsBlobFieldType(DataType) then begin
            Len := GetBlobSize(FieldDesc.FieldNo, RecBuf);
            ValueBuf := Marshal.AllocHGlobal(Len + 1);
            ReadBlob(FieldDesc.FieldNo, RecBuf, 0, Len, ValueBuf);
            Marshal.WriteByte(ValueBuf, Len, 0);
            DataType := dtString;
            Result := ValueBuf;
          end
      end;
    end;
  finally
    if (FieldBufStatic <> nil) and (ValueBuf <> nil) then
      Marshal.FreeHGlobal(FieldBufStatic);
    NativeBuffer := (FieldBufStatic = nil) and (ValueBuf = nil);
  end;
end;

function SetScale(F: double; Scale: integer): double;
begin
  if Scale > 0 then begin
    Result := StrToFloat(FloatToStrF(F, ffFixed, 18, Scale)); // 0.009
  end
  else
    Result := F;
end;

procedure TData.PutFieldData(Field: TFieldDesc; RecBuf: IntPtr; Source: IntPtr);
var
  Dest, Src: IntPtr;
  D: double;
  Len: integer;

begin
  case Field.DataType of
    dtFloat: begin
      D := BitConverter.Int64BitsToDouble(Marshal.ReadInt64(Source));
      D := SetScale(D, Field.Scale);
      Marshal.WriteInt64(RecBuf, Field.Offset, BitConverter.DoubleToInt64Bits(D));
    end;
    dtDateTime:
      PutDateToBuf(RecBuf, Field.Offset, Source, dfMSecs);
    dtDate:
      PutDateToBuf(RecBuf, Field.Offset, Source, dfDate);
    dtTime:
      PutDateToBuf(RecBuf, Field.Offset, Source, dfTime);
  {$IFDEF VER5P}
    dtVariant:
    {$IFDEF CLR}
      Assert(False);
    {$ELSE}
      TVariantObject(Marshal.ReadIntPtr(RecBuf, Field.Offset)).Value := Variant(Source^);
    {$ENDIF}
  {$ENDIF}
    dtString:
      StrLCopy(IntPtr(Integer(RecBuf) + Field.Offset), Source, Field.Size);
    dtWideString: begin
      Src :=
      {$IFDEF CLR}
        Source;
      {$ELSE}
        {$IFDEF VER10P}
          Source;
        {$ELSE}
          PWideChar(WideString(Source^));
        {$ENDIF}
      {$ENDIF}
      StrLCopyW(IntPtr(Integer(RecBuf) + Field.Offset), Src, Field.Length);
    end;
    dtExtString: begin
      StringHeap.DisposeBuf(Marshal.ReadIntPtr(RecBuf, Field.Offset));
      Marshal.WriteIntPtr(RecBuf, Field.Offset, StringHeap.AllocStr(Source));
    end;
    dtExtWideString: begin
      StringHeap.DisposeBuf(Marshal.ReadIntPtr(RecBuf, Field.Offset));
      if Source = nil then
        Src := nil
      else
        Src :=
      {$IFDEF CLR}
          Source;
      {$ELSE}
        {$IFDEF VER10P}
            Source;
        {$ELSE}
            PWideChar(WideString(Source^));
        {$ENDIF}
      {$ENDIF}
      Marshal.WriteIntPtr(RecBuf, Field.Offset, StringHeap.AllocWideStr(Src));
    end;
    dtExtVarBytes: begin
      StringHeap.DisposeBuf(Marshal.ReadIntPtr(RecBuf, Field.Offset));
      if Source <> nil then begin
        Len := Marshal.ReadInt16(Source) + SizeOf(Word);
        Dest := StringHeap.NewBuf(Len);
        CopyBuffer(Source, Dest, Len);
        Marshal.WriteIntPtr(RecBuf, Field.Offset, Dest);
      end
      else
        Marshal.WriteIntPtr(RecBuf, Field.Offset, nil);
    end;
  {$IFDEF CLR}
    dtBytes:
      CopyBuffer(Source, IntPtr(Integer(RecBuf) + Field.Offset), Field.Length);
  {$ENDIF}
  else
    CopyBuffer(Source, IntPtr(Integer(RecBuf) + Field.Offset), Field.Size);
  end;
end;

procedure TData.PutField(FieldNo: word; RecBuf: IntPtr; Source: IntPtr);
var
  Field: TFieldDesc;
begin
  if Source = nil then begin
    SetNull(FieldNo, RecBuf, True);
    Exit;
  end;

  Field := Fields[FieldNo - 1];

  if not Field.HasParent then begin
    if (not FEnableEmptyStrings) and
      ((Field.DataType in [dtString, dtExtString]) and (Marshal.ReadByte(Source) = 0) or
       (Field.DataType in [dtWideString, dtExtWideString]) and (Marshal.ReadInt16(Source) = 0))
      then
      SetNull(FieldNo, RecBuf, True)
    else
    begin
      PutFieldData(Field, RecBuf, Source);
      SetNull(FieldNo, RecBuf, False);
    end;
  end
  else
    PutChildField(Field, RecBuf, Source);
end;

function TData.GetNull(FieldNo: word; RecBuf: IntPtr): boolean;
var
  Field:TFieldDesc;
begin
  Field := Fields[FieldNo - 1];
  if not Field.HasParent then
    Result := Marshal.ReadByte(RecBuf, DataSize + FieldNo - 1) = 1
  else
    GetChildField(Field, RecBuf, nil, Result);
end;

procedure TData.SetNull(FieldNo: word; RecBuf: IntPtr; Value: boolean);
var
  Flag: byte;
  Field: TFieldDesc;
  Blob: TBlob;
begin
  Field := Fields[FieldNo - 1];
  if not Field.HasParent then begin
    if Value then
      Flag := 1
    else
      Flag := 0;

    Marshal.WriteByte(RecBuf, DataSize + FieldNo - 1, Flag);

    if Value and IsBlobFieldType(Field.DataType) then begin // clear Blob value
      Blob := TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(RecBuf, Field.Offset)));
      if Blob <> nil then
        Blob.Clear;
    end;
  end
  else
    PutChildField(Field, RecBuf, nil);
end;

function TData.GetNullByBlob(FieldNo: word; RecBuf: IntPtr): boolean;
var
  Blob: TBlob;
  Ptr: IntPtr;
begin
  Result := True;
  if IsBlobFieldType(Fields[FieldNo - 1].DataType) then begin
    Ptr := Marshal.AllocHGlobal(sizeof(IntPtr));
    try
      if Fields[FieldNo - 1].HasParent then
        GetChildField(Fields[FieldNo - 1], RecBuf, Ptr, Result)
      else
        GetFieldData(Fields[FieldNo - 1], RecBuf, Ptr);
      Blob := TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(Ptr)));
    finally
      Marshal.FreeHGlobal(Ptr);
    end;

    if (Blob <> nil) and (Blob.Size <> 0) then begin
      Result := False;
      SetNull(FieldNo, RecBuf, False);
    end;
  end;
end;

procedure TData.GetFieldAsVariant(FieldNo: word; RecBuf: IntPtr; var Value: variant);
var
  Field: TFieldDesc;
  FieldData: IntPtr;
  Date: TDateTime;
  Date64: int64;
  PDate: IntPtr;
  Buf: IntPtr;
  Data: TBytes;
  IsBlank, t: boolean;
{  Blob: TBlob;
  l: integer;}
{$IFDEF VER6P}
  bcd: TBcd;
{$ENDIF}
begin
  if GetNull(FieldNo, RecBuf) then begin
    Value := Null;
    Exit;
  end;

  Value := Unassigned; // Delphi bug
  Field := Fields[FieldNo - 1];

  if not Field.HasParent then
    Buf := nil
  else
    Buf := Marshal.AllocHGlobal(4000);

  try
    if not Field.HasParent then
      FieldData := IntPtr(Integer(RecBuf) + Field.Offset)
    else begin
      FieldData := Buf;
      GetChildField(Field, RecBuf, FieldData, IsBlank);
    end;

    case Field.DataType of
      dtString: begin
        if Field.Fixed then
          t := FTrimFixedChar
        else
          t := FTrimVarChar;
        if t then
        // trim fixed char values
          Value := TrimRight(Marshal.PtrToStringAnsi(FieldData))
        else
          Value := Marshal.PtrToStringAnsi(FieldData);
      end;
      dtWideString: begin
        if Field.Fixed then
          t := FTrimFixedChar
        else
          t := FTrimVarChar;
        if t then
        // trim fixed char values
          Value := TrimRight(Marshal.PtrToStringUni(FieldData))
        else
          Value := Marshal.PtrToStringUni(FieldData);
      end;
      dtInt8:
        Value := shortint(Marshal.ReadByte(FieldData));
      dtSmallint:
        Value := Marshal.ReadInt16(FieldData);
      dtInt64: begin
      {$IFDEF VER6P}
        Value := Marshal.ReadInt64(FieldData);
      {$ELSE}
        TVarData(Value).VType := varDecimal;
        TVarDataD6(Value).VInt64 := Int64(FieldData^);
      {$ENDIF}
      end;
      dtUInt32: begin
      {$IFDEF VER6P}
        Value := LongWord(Marshal.ReadInt32(FieldData));
      {$ELSE}
        TVarData(Value).VType := varLongWord;
        TVarDataD6(Value).VLongword := LongWord(FieldData^);
      {$ENDIF}
      end;
      dtInteger:
        Value := Marshal.ReadInt32(FieldData);
      dtWord:
        Value := Word(Marshal.ReadInt16(FieldData));
      dtBoolean:
        Value := WordBool(Marshal.ReadInt16(FieldData));
      dtFloat,dtCurrency:
        Value := BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldData));
      dtDateTime, dtDate, dtTime: begin
        if Field.HasParent then
          Date := MemUtils.TimeStampToDateTime(MSecsToTimeStamp(Trunc(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldData)))))
        else begin
          PDate := OrdinalToPtr(Date64);
          try
            GetDateFromBuf(FieldData, 0, PDate, dfDateTime);
          finally
            PtrToOrdinal(PDate, Date64);
          end;
          Date := BitConverter.Int64BitsToDouble(Date64);
        end;
        Value := Date;
      end;
      dtMemo:
        Value := TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).AsString;
      dtWideMemo:
        Value := TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).AsWideString;
    {$IFDEF VER5P}
      dtVariant:
        Value := TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).Value;
    {$ENDIF}
      dtExtString:
        Value := Marshal.PtrToStringAnsi(Marshal.ReadIntPtr(FieldData));
      dtExtWideString:
        Value := Marshal.PtrToStringUni(Marshal.ReadIntPtr(FieldData));
      dtBytes: begin
        SetLength(Data, Field.Length);
        Marshal.Copy(FieldData, Data, 0, Field.Length);
        Value := Data;
      end;
      dtVarBytes: begin
        SetLength(Data, Marshal.ReadInt16(FieldData));
        Marshal.Copy(IntPtr(Integer(FieldData) + SizeOf(word)), Data, 0, Length(Data));
        Value := Data;
      end;
      dtExtVarBytes: begin
        SetLength(Data, Marshal.ReadInt16(Marshal.ReadIntPtr(FieldData)));
        Marshal.Copy(IntPtr(Integer(Marshal.ReadIntPtr(FieldData)) + SizeOf(word)), Data, 0, Length(Data));
        Value := Data;
      end;
(*      dtBlob: begin
        Blob := GetObject(FieldNo, RecBuf) as TBlob;
        try
          l := Blob.Size;
        {$IFDEF CLR}
          SetLength(Value, l);
          Blob.Defrag;
          asdd
        {$ELSE}
          Value := VarArrayCreate([0, l - 1], varByte);
          Blob.Read(0, l, TVarData(Value).VArray.Data);
        {$ENDIF}
        finally
          Blob.Free;
        end;
      end;  *)
      dtBCD:
      begin
      {$IFDEF CLR}
        Date64 := Marshal.ReadInt64(FieldData);
        Value := Date64 / 10000;
      {$ELSE}
        Value := PCurrency(FieldData)^;
      {$ENDIF}
      end;
    {$IFDEF VER6P}
      dtFmtBCD:
      begin
      {$IFDEF CLR}
        SetLength(Data, SizeOfTBcd);
        Marshal.Copy(FieldData, Data, 0, SizeOfTBcd);
        bcd := TBcd.FromBytes(Data);
      {$ELSE}
        bcd := PBcd(FieldData)^;
      {$ENDIF}
        Value := VarFMTBcdCreate(bcd);
      end;
    {$ENDIF}
      dtGuid:
        Value := Marshal.PtrToStringAnsi(FieldData);
    else
      raise EConvertError.Create(SCannotConvertType + ' ' + IntToStr(Integer(Field.DataType)));
    end;
  finally
    if Buf <> nil then
      Marshal.FreeHGlobal(Buf);
  end;
end;

procedure TData.PutFieldAsVariant(FieldNo: word; RecBuf: IntPtr; const Value: variant);
var
  FieldData: IntPtr;
  i: integer;
{$IFDEF VER6P}
  lw: Longword;
  i32: Int32;
  i64: Int64;
{$ENDIF}
{$IFDEF CLR}
  Data: TBytes;
  bcd: TBcd;
  d: Double;
{$ENDIF}
  Date: int64;
  PDate: IntPtr;
  Temp: IntPtr;
  Ws: WideString;
  l: word;

  s: string;
  p: IntPtr;
begin
  if VarIsNull(Value) or VarIsEmpty(Value) then begin
    SetNull(FieldNo, RecBuf, True);
    Exit;
  end;
  FieldData := IntPtr(Integer(RecBuf) + Fields[FieldNo - 1].Offset);
  case Fields[FieldNo - 1].DataType of
    dtString: begin
    {$IFDEF CLR}
      Data := Encoding.Default.GetBytes(String(Copy(String(Value), 1, Fields[FieldNo - 1].Size)));
      Marshal.Copy(Data, 0, FieldData, Length(Data));
      Marshal.WriteByte(FieldData, Length(Data), 0);
    {$ELSE}
      StrLCopy(FieldData, PChar(VarToStr(Value)), Fields[FieldNo - 1].Size);
    {$ENDIF}
    end;
    dtWideString: begin
      Ws := WideString(Value);
    {$IFDEF CLR}
      i := Fields[FieldNo - 1].Size div 2 - 1;
      if Length(Ws) > i then
        SetLength(Ws, i);
      Data := Encoding.Unicode.GetBytes(Ws);
      Marshal.Copy(Data, 0, FieldData, Length(Data));
      Marshal.WriteInt16(FieldData, Length(Data), 0);
    {$ELSE}
      StrLCopyW(FieldData, PWideChar(ws), Fields[FieldNo - 1].Size div 2 - 1);
    {$ENDIF}
    end;
    dtInt8: begin
      i := Value;
      case Fields[FieldNo - 1].Size of
        2:
          Marshal.WriteInt16(FieldData, i);
        1:
          Marshal.WriteByte(FieldData, byte(i));
        else
          Assert(False);
      end;
    end;
    dtSmallint:
      case VarType(Value) of
        varSmallint,varInteger,varByte{$IFDEF VER6P}, varWord{$ENDIF}:
          Marshal.WriteInt16(FieldData, smallint(Value));
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtInteger:
      case VarType(Value) of
        varString{$IFDEF WIN32},varOleStr{$ENDIF}{$IFDEF CLR}, varChar{$ENDIF}:
          Marshal.WriteInt32(FieldData, StrToInt(Value));
        varSmallint,varInteger,varByte,{$IFDEF VER6P}varWord,{$ENDIF}
        varSingle,varDouble{$IFDEF WIN32},varCurrency{$ENDIF}:
          Marshal.WriteInt32(FieldData, Integer(Value));
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtInt64:
      case VarType(Value) of
      {$IFDEF VER6P}
        varInt64: begin
          i64 := Value;
          Marshal.WriteInt64(FieldData, i64);
        end;
      {$ELSE}
        varDecimal:
          Int64(FieldData^) := TVarDataD6(Value).VInt64;
      {$ENDIF}
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtUInt32:
      case VarType(Value) of
        varLongWord:
          {$IFDEF VER6P}
          begin
            // To prevent range-checking error on large values (for example, 4294967295)
            i64 := Value;
            lw := longword(i64);
            i32 := Int32(lw);
            Marshal.WriteInt32(FieldData, i32);
          end;
          {$ELSE}
            LongWord(FieldData^) := TVarDataD6(Value).VLongWord;
          {$ENDIF}
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtWord:
      case VarType(Value) of
        varSmallint,varInteger,varByte{$IFDEF VER6P},varWord{$ENDIF}: begin
          i := Value;
          Marshal.WriteInt16(FieldData, smallint(i));
        end
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtBoolean:
      case VarType(Value) of
        varBoolean:
          Marshal.WriteInt16(FieldData, smallint(boolean(Value)));
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtFloat, dtCurrency:
      case VarType(Value) of
        varString{$IFDEF WIN32},varOleStr{$ENDIF}{$IFDEF CLR}, varChar{$ENDIF}:
          Marshal.WriteInt64(FieldData,
            BitConverter.DoubleToInt64Bits(SetScale(StrToFloat(Value), Fields[FieldNo - 1].Scale)));
        varSmallint,varInteger,varByte:
          Marshal.WriteInt64(FieldData, BitConverter.DoubleToInt64Bits(Value));
        varSingle,varDouble{$IFDEF WIN32},varCurrency{$ENDIF}:
          Marshal.WriteInt64(FieldData,
            BitConverter.DoubleToInt64Bits(SetScale(Value, Fields[FieldNo - 1].Scale)));
      else
        raise EConvertError.Create(SCannotConvertType);
      end;
    dtDateTime, dtDate, dtTime: begin
      Date := BitConverter.DoubleToInt64Bits(Value);
      PDate := OrdinalToPtr(Date);
      try
        PutDateToBuf(FieldData, 0, PDate, dfDateTime);
      finally
        FreeOrdinal(PDate);
      end;
    end;
    dtMemo,dtBlob: // used by ODAC to refresh String as Memo
      TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).AsString := VarToStr(Value);
    dtWideMemo:
      TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).AsWideString := VarToWideStr(Value);
  {$IFDEF VER5P}
    dtVariant:
      TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(FieldData))).Value := Value;
  {$ENDIF}
    dtExtString: begin
      StringHeap.DisposeBuf(Marshal.ReadIntPtr(FieldData));
      Temp := Marshal.StringToHGlobalAnsi(Value);
      try
        Marshal.WriteIntPtr(FieldData, StringHeap.AllocStr(Temp));
      finally
        Marshal.FreeCoTaskMem(Temp);
      end;
    end;
    dtExtWideString: begin
      StringHeap.DisposeBuf(Marshal.ReadIntPtr(FieldData));
      Temp := Marshal.StringToHGlobalUni(Value);
      try
        Marshal.WriteIntPtr(FieldData, StringHeap.AllocWideStr(Temp));
      finally
        Marshal.FreeCoTaskMem(Temp);
      end;
    end;
    dtBytes: begin
      Assert(VarType(Value) = varArray + varByte, 'Invalid VType');
    {$IFDEF CLR}
      SetLength(Data, VarArrayHighBound(Value, 1) + 1);
      for i := 0 to High(Data) do
        Data[i] := VarArrayGet(Value, i);
      Marshal.Copy(Data, 0, FieldData, Length(Data));
    {$ELSE}
      Assert(TVarData(Value).VArray.Bounds[0].ElementCount = Fields[FieldNo - 1].Length, 'Invalid data size');
      Move(TVarData(Value).VArray.Data^, FieldData^, Fields[FieldNo - 1].Length);
    {$ENDIF}
    end;
    dtVarBytes: begin
      Assert(VarType(Value) = varArray + varByte, 'Invalid VType');
    {$IFDEF CLR}
      SetLength(Data, VarArrayHighBound(Value, 1) + 1);
      for i := 0 to High(Data) do
        Data[i] := VarArrayGet(Value, i);
      Marshal.WriteInt16(FieldData, Length(Data));
      Marshal.Copy(Data, 0, IntPtr(Integer(FieldData) + sizeof(word)), Length(Data));
    {$ELSE}
      Assert(TVarData(Value).VArray.Bounds[0].ElementCount <= Fields[FieldNo - 1].Length, 'Invalid data size');

      Word(FieldData^) := TVarData(Value).VArray.Bounds[0].ElementCount;
      Move(TVarData(Value).VArray.Data^, (PChar(FieldData) + sizeof(word))^, Word(FieldData^));
    {$ENDIF}
    end;
    dtExtVarBytes: begin
      Assert(VarType(Value) = varArray + varByte, 'Invalid VType');
//      Assert(VarArrayHighBound(Value, 1) - VarArrayLowBound(Value, 1) + 1 <= Length, 'Invalid data size');

      StringHeap.DisposeBuf(Marshal.ReadIntPtr(FieldData));
      l := VarArrayHighBound(Value, 1) - VarArrayLowBound(Value, 1) + 1;
      Marshal.WriteIntPtr(FieldData, StringHeap.NewBuf(l + sizeof(Word)));

      Marshal.WriteInt16( Marshal.ReadIntPtr(FieldData), l);
      for i:= VarArrayLowBound(Value, 1) to VarArrayHighBound(Value, 1) do
        Marshal.WriteByte( IntPtr(Integer(Marshal.ReadIntPtr(FieldData)) + sizeof(word) + i - VarArrayLowBound(Value, 1)),  Value[i]);
    end;
    dtBCD:
    {$IFDEF CLR}
    begin
      d := Value;
      d := d * 10000;
      Marshal.WriteInt64(FieldData, Round(d));
    end;
    {$ELSE}
      PCurrency(FieldData)^ := Value;
    {$ENDIF}
  {$IFDEF VER6P}
    dtFmtBCD:
    {$IFDEF CLR}
    begin
      bcd := Value;
      Data := TBcd.ToBytes(bcd);
      Marshal.Copy(Data, 0, FieldData, SizeOfTBcd);
    end;
    {$ELSE}
      PBcd(FieldData)^ := StrToBcd(Value);
    {$ENDIF}
  {$ENDIF}
    dtGuid:
    begin
      s := VarToStr(Value);
      p := Marshal.StringToHGlobalAnsi(s);
      try
        StrLCopy(FieldData, p, Fields[FieldNo - 1].Size);
      finally
        Marshal.FreeCoTaskMem(p);
      end;
    end;
  else
    raise EConvertError.Create(SCannotConvertType);
  end;

  SetNull(FieldNo, RecBuf, False);
end;

function TData.FindField(Name: string):TFieldDesc;
begin
  Result := FFields.FindField(Name);
end;

function TData.FieldByName(Name: string):TFieldDesc;
begin
  Result := FFields.FieldByName(Name);
end;

function TData.IsBlobFieldType(DataType: word): boolean; // TBlob descendants - dtBlob, dtMemo etc
begin
  Result := (DataType = dtBlob) or (DataType = dtMemo) or (DataType = dtWideMemo);
end;

function TData.IsComplexFieldType(DataType: word): boolean; // All supported complex field types (BlobFieldTypes, ExtFieldTypes and TSharedObject descendants (not BLOB))
begin
  case DataType of
    dtExtString, dtExtWideString, dtExtVarBytes{$IFDEF VER5P}, dtVariant{$ENDIF}:
      Result := True;
  else
    Result := IsBlobFieldType(DataType);
  end;
end;

function TData.HasFields(FieldTypes: TFieldTypeSet): boolean;
var
  i: integer;
begin
  i := 0;
  while (i < FieldCount) and not (Fields[i].DataType in FieldTypes) do
    Inc(i);
  Result := i < FieldCount;
end;

function TData.HasBlobFields: boolean;
var
  i: integer;
begin
  i := 0;
  while (i < FieldCount) and not IsBlobFieldType(Fields[i].DataType) do
    Inc(i);
  Result := i < FieldCount;
end;

function TData.CheckHasComplexFields: boolean;
var
  i: integer;
begin
  i := 0;
  while (i < FieldCount) and not IsComplexFieldType(Fields[i].DataType) do
    Inc(i);
  Result := i < FieldCount;
  FHasComplexFields := Result;
end;

{ Records }

function TData.AllocRecBuf(var RecBuf: IntPtr): IntPtr;
begin
  RecBuf := Marshal.AllocHGlobal(RecordSize);
  Result := RecBuf;
end;

procedure TData.FreeRecBuf(RecBuf: IntPtr);
begin
  Marshal.FreeHGlobal(RecBuf);
end;

procedure TData.CreateComplexFields(RecBuf: IntPtr; WithBlob: boolean);
var
  i: integer;
begin
  for i := 0 to FieldCount - 1 do
    CreateComplexField(RecBuf, i, WithBlob);
end;

procedure TData.CreateComplexField(RecBuf: IntPtr; FieldIndex: integer; WithBlob: boolean);
var
  Blob: TSharedObject;
  FieldDesc: TFieldDesc;
begin
  FieldDesc := Fields[FieldIndex];
  if FieldDesc.FieldDescKind <> fdkCalculated then
    case FieldDesc.DataType of
      dtBlob, dtMemo, dtWideMemo:
        if WithBlob then begin
          Blob := TBlob.Create;
          if FieldDesc.DataType = dtWideMemo then
            TBlob(Blob).IsUnicode := True;
          // RollBack is always on for LOB fields. Otherwise modification
          // that cannot be canceled is possible.
          TBlob(Blob).EnableRollback;
          SetObject(FieldIndex + 1, RecBuf, Blob);
        end;
    {$IFDEF VER5P}
      dtVariant:
        begin
          Blob := TVariantObject.Create;
          Marshal.WriteIntPtr(RecBuf, FieldDesc.Offset, Blob.GCHandle);
        end;
    {$ENDIF}
      dtExtString, dtExtWideString, dtExtVarBytes:
        Marshal.WriteIntPtr(RecBuf, FieldDesc.Offset, nil);
    end;
end;


procedure TData.AddRefComplexFields(RecBuf: IntPtr);
var
  i: integer;
  so: TSharedObject;
begin
  for i := 0 to FieldCount - 1 do
    if Fields[i].DataType in [dtExtString, dtExtWideString, dtExtVarBytes] then
      StringHeap.AddRef(Marshal.ReadIntPtr(RecBuf, Fields[i].Offset))
    else
    if IsComplexFieldType(Fields[i].DataType) and not Fields[i].HasParent then begin
      so := TSharedObject(GetGCHandleTarget(Marshal.ReadIntPtr(RecBuf, Fields[i].Offset)));
      Assert(so <> nil, 'Shared object for ' + Fields[i].Name + '=nil');
      so.AddRef;
    end;
end;

procedure TData.FreeComplexFields(RecBuf: IntPtr; WithBlob: boolean);
var
  i: integer;
  Handle: IntPtr;
  so: TSharedObject;
  b: boolean;
  Field: TFieldDesc;
begin
  for i := 0 to FieldCount - 1 do begin
    Field := Fields[i];
    if Field.FieldDescKind <> fdkCalculated then
      case Field.DataType of
        dtBlob, dtMemo, dtWideMemo:
          if WithBlob then begin
            Handle := Marshal.ReadIntPtr(RecBuf, Field.Offset);
            so := TSharedObject(GetGCHandleTarget(Handle));
            // see TSharedObject.Free for details
            b := (so <> nil) and (so.RefCount = 1);
            so.Free;
            if b then
              Marshal.WriteIntPtr(RecBuf, Field.Offset, nil);
          end;
      {$IFDEF VER5P}
        dtVariant: begin
          Handle := Marshal.ReadIntPtr(RecBuf, Field.Offset);
          TVariantObject(GetGCHandleTarget(Handle)).Free;
        end;
      {$ENDIF}
        dtExtString, dtExtWideString, dtExtVarBytes:
          if not StringHeap.Empty then begin
            Handle := Marshal.ReadIntPtr(RecBuf, Field.Offset);
            if (Handle <> nil) and (Marshal.ReadInt16(IntPtr(Integer(Handle) - SizeOf(Word))) = RefNull) then
              Handle := nil;
            StringHeap.DisposeBuf(Marshal.ReadIntPtr(RecBuf, Field.Offset));
            Marshal.WriteIntPtr(RecBuf, Field.Offset, Handle)
          end;
      end;
  end;
end;

procedure TData.CopyComplexFields(Source: IntPtr; Dest: IntPtr; WithBlob: boolean);
var
  i, l: integer;
  SrcPtr: IntPtr;
  DestPtr: IntPtr;
begin
  if WithBlob then
    Assert(False);

  for i := 0 to FieldCount - 1 do
    case Fields[i].DataType of
      dtExtString: begin
        SrcPtr := Marshal.ReadIntPtr(Source, Fields[i].Offset);
        Marshal.WriteIntPtr(Dest, Fields[i].Offset, StringHeap.AllocStr(SrcPtr));
      end;
      dtExtWideString: begin
        SrcPtr := Marshal.ReadIntPtr(Source, Fields[i].Offset);
        Marshal.WriteIntPtr(Dest, Fields[i].Offset, StringHeap.AllocWideStr(SrcPtr));
      end;
      dtExtVarBytes: begin
        SrcPtr := Marshal.ReadIntPtr(Source, Fields[i].Offset);
        DestPtr := IntPtr(Integer(Dest) + Fields[i].Offset);
        if SrcPtr = nil then
          Marshal.WriteIntPtr(DestPtr, nil)
        else begin
          l := Marshal.ReadInt16(IntPtr(SrcPtr)) + SizeOf(Word);
          Marshal.WriteIntPtr(DestPtr, StringHeap.NewBuf(l));
          CopyBuffer(SrcPtr, Marshal.ReadIntPtr(DestPtr), l);
        end
      end;
    {$IFDEF VER5P}
      dtVariant:
        TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(Dest, Fields[i].Offset))).Value :=
          TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(Source, Fields[i].Offset))).Value;
    {$ENDIF}
    end;
end;

procedure TData.InitRecord(RecBuf: IntPtr);
var
  i: integer;
begin
// Complex fields need create later
  if HasComplexFields then  // clear pointer to complex field
    FillChar(RecBuf, RecordSize, 0);

  for i := 1 to FieldCount do
    SetNull(i, RecBuf, True);
end;

procedure TData.AppendBlankRecord;
var
  RecBuf: IntPtr;
begin
  AllocRecBuf(RecBuf);
  try
    InitRecord(RecBuf);
    AppendRecord(RecBuf);
  finally
    FreeRecBuf(RecBuf);
  end;
end;

procedure TData.EditRecord(RecBuf: IntPtr);
var
  TempBuf: IntPtr;
begin
  AllocRecBuf(TempBuf);
  try
    GetRecord(TempBuf);
    CreateComplexFields(TempBuf, False);  // Blobs uses internal cache
    CopyComplexFields(RecBuf, TempBuf, False);
    PutRecord(TempBuf);

    {if IsBlobFields then
      for i:= 0 to FieldCount - 1 do
        if Fields[i].DataType in BlobFieldTypes then
          TBlob(Pointer(PChar(RecBuf) + Fields[i].Offset)^).EnableRollback;}
  finally
    FreeRecBuf(TempBuf);
  end;
end;

procedure TData.PostRecord(RecBuf: IntPtr);
var
  i: integer;
  TempBuf: IntPtr;
  Blob: TBlob;
begin
  AllocRecBuf(TempBuf);
  try
    GetRecord(TempBuf);

    UpdateRecord(RecBuf);

    if HasBlobFields then
      for i := 0 to FieldCount - 1 do
        if IsBlobFieldType(Fields[i].DataType) then begin
          Blob := TBlob(InternalGetObject(Fields[i].FieldNo, RecBuf));
          if Blob <> nil then
            Blob.Commit;
        end;

    FreeComplexFields(TempBuf, False);
  finally
    FreeRecBuf(TempBuf);
  end;
end;

procedure TData.CancelRecord(RecBuf: IntPtr);
var
  i: integer;
  Blob: TBlob;
begin
  if HasBlobFields then
    for i := 0 to FieldCount - 1 do
      if IsBlobFieldType(Fields[i].DataType) then begin
        Blob := TBlob(InternalGetObject(Fields[i].FieldNo, RecBuf));
        if Blob <> nil then
          Blob.Cancel;
      end;

  FreeComplexFields(RecBuf, False);
end;

{ Edit }

procedure TData.InternalAppend(RecBuf: IntPtr);
begin
  if Assigned(FOnAppend) then
    FOnAppend;
end;

procedure TData.InternalDelete;
begin
  if Assigned(FOnDelete) then
    FOnDelete;
end;

procedure TData.InternalUpdate(RecBuf: IntPtr);
begin
  if Assigned(FOnUpdate) then
    FOnUpdate;
end;

procedure TData.ApplyRecord(UpdateKind:TUpdateRecKind; var Action:TUpdateRecAction; LastItem: boolean);
begin
  if Assigned(FOnApplyRecord) then
    FOnApplyRecord(UpdateKind, Action, LastItem);
end;

{ Navigation }

function TData.GetEOF: boolean;
begin
  Result := FEOF;
end;

function TData.GetBOF: boolean;
begin
  Result := FBOF;
end;

procedure TData.SetToBegin;
begin
  FBOF := True;
  FEOF := False;
end;

procedure TData.SetToEnd;
begin
  FEOF := True;
  FBOF := False;
end;

function TData.GetRecordCount: longint;
begin
  Result := -1;
end;

function TData.GetRecordNo: longint;
begin
  Result := -1;
end;

procedure TData.SetRecordNo(Value: longint);
begin
end;

{ BookMarks }

procedure TData.GetBookmark(Bookmark: PRecBookmark);
begin
  Bookmark.Order := RecordNo;
end;

procedure TData.SetToBookmark(Bookmark: PRecBookmark);
begin
  if Bookmark.Order <> -1 then
    SetRecordNo(Bookmark.Order);
end;

function TData.BookmarkValid(Bookmark: PRecBookmark): boolean;
begin
  if IntPtr(Bookmark) <> nil then
    Result := Bookmark.Order <> -1
  else
    Result := False;
end;

function TData.CompareBookmarks(Bookmark1, Bookmark2: PRecBookmark): integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
begin
  Result := RetCodes[IntPtr(Bookmark1) = nil, IntPtr(Bookmark2) = nil];
  if Result = 2 then begin
    if Bookmark1.Order >= Bookmark2.Order then
      if Bookmark1.Order = Bookmark2.Order then
        Result := 0
      else
        Result := 1
    else
      Result := -1
  end;
end;

{ CachedUpdates }

function TData.GetUpdateStatus: TItemStatus;
begin
  Result := isUnmodified;
end;

function TData.GetUpdateResult: TUpdateRecAction;
begin
  Result := urNone;
end;

procedure TData.SetCacheRecBuf(NewBuf: IntPtr; OldBuf: IntPtr);
begin
end;

procedure TData.ApplyUpdates;
begin
end;

procedure TData.CommitUpdates;
begin
end;

procedure TData.CancelUpdates;
begin
end;

procedure TData.RestoreUpdates;
begin
end;

procedure TData.RevertRecord;
begin
end;

function TData.GetUpdatesPending: boolean;
begin
  Result := False;
end;

procedure TData.GetOldRecord(RecBuf: IntPtr);
begin
end;

{ Filter }

function TData.AllocNode: TExpressionNode;
begin
  Result := TExpressionNode.Create;
  Result.NextAlloc := FirstAlloc;
  FirstAlloc := Result;
  Result.LeftOperand := nil;
  Result.RightOperand := nil;
  Result.NextOperand := nil;
end;

procedure TData.FilterError;
begin
  raise Exception.Create(SIllegalFilter);
end;

function TData.OrExpr: TExpressionNode;
var
  Node: TExpressionNode;
begin
  Result := AndExpr;
  while Code = lxOR do begin
    Code := Parser.GetNext(StrLexem);
    Node := AllocNode;
    Node.NodeType := ntOr;
    Node.LeftOperand := Result;
    Node.RightOperand := AndExpr;
    Result := Node;
  end;
end;

function TData.AndExpr: TExpressionNode;
var
  Node: TExpressionNode;
begin
  Result := Condition;
  while Code = lxAND do begin
    Code := Parser.GetNext(StrLexem);
    Node := AllocNode;
    Node.NodeType := ntAnd;
    Node.LeftOperand := Result;
    Node.RightOperand := Condition;
    Result := Node;
  end;
end;

function TData.Condition: TExpressionNode;
var
  OpCode: integer;
begin
  Result := nil;
  if (Code = lcIdent) or (Code = lcNumber) or (Code = lcString) or
    (Code in [lxMinus, lxPlus, lxLeftSqBracket, lxRightSqBracket])
  then begin
    Result := AllocNode;
    Result.LeftOperand := Argument;
    OpCode := Code;
    case Code of
      lxEqual, lxIS:
        Result.NodeType := ntEqual;
      lxMore:
        Result.NodeType := ntMore;
      lxLess:
        Result.NodeType := ntLess;
      lxMoreEqual:
        Result.NodeType := ntMoreEqual;
      lxLessEqual:
        Result.NodeType := ntLessEqual;
      lxNoEqual:
        Result.NodeType := ntNoEqual;
      lxLike:
        Result.NodeType := ntLike;
    else
      FilterError;
    end;
    Code := Parser.GetNext(StrLexem);
    if OpCode = lxIS then begin
      if Code = lxNOT then begin
        Code := Parser.GetNext(StrLexem);
        if Code <> lxNULL then
          FilterError;
        Result.NodeType := ntNoEqual;
      end
      else if Code <> lxNULL then
        FilterError;
    end;
    Result.RightOperand := Argument;
  end
  else
    if Code = lxNOT then begin
      Code := Parser.GetNext(StrLexem);
      Result := AllocNode;
      Result.NodeType := ntNot;
      Result.LeftOperand := Condition;
    end
    else
      if Code = lxTRUE then begin
        Code := Parser.GetNext(StrLexem);
        Result := AllocNode;
        Result.NodeType := ntTrue;
      end
      else
        if Code = lxFALSE then begin
          Code := Parser.GetNext(StrLexem);
          Result := AllocNode;
          Result.NodeType := ntFalse;
        end
        else
          if Code = lxLeftBracket then begin
            Code := Parser.GetNext(StrLexem);
            Result := OrExpr;
            if Code = lxRightBracket then
              Code := Parser.GetNext(StrLexem)
            else
              FilterError;
          end
          else
            FilterError;
end;

{$IFNDEF VER6P}
function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
var
  P, Dest: PChar;
  DropCount: Integer;
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then Exit;
  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := AnsiStrScan(Src, Quote);
  while Src <> nil do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then Break;
    Inc(Src);
    Inc(DropCount);
    Src := AnsiStrScan(Src, Quote);
  end;
  if Src = nil then Src := StrEnd(P);
  if ((Src - P) <= 1) then Exit;
  if DropCount = 1 then
    SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PChar(Result);
    Src := AnsiStrScan(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then Break;
      Move(P^, Dest^, Src - P);
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := AnsiStrScan(Src, Quote);
    end;
    if Src = nil then Src := StrEnd(P);
    Move(P^, Dest^, Src - P - 1);
  end;
end;

function AnsiDequotedStr(const S: string; AQuote: Char): string;
var
  LText: PChar;
begin
  LText := PChar(S);
  Result := AnsiExtractQuotedStr(LText, AQuote);
  if Result = '' then
    Result := S;
end;
{$ENDIF}

function TData.Argument: TExpressionNode;
var
  Field: TFieldDesc;
  FieldName: string;
  ASign: string;

  function ParseFieldName(FirstPart: string): string;
  begin
    Result := FirstPart;
    Code := Parser.GetNext(StrLexem);
    if StrLexem = '.' then
      repeat
        Code := Parser.GetNext(StrLexem);
        if Code = lcIdent then
          Result := Result + '.' + StrLexem
        else
          break;
        Code := Parser.GetNext(StrLexem);
      until StrLexem <> '.';
  end;
begin
  Result := AllocNode;
  case Code of
    lcIdent: begin
      FieldName := ParseFieldName(StrLexem);
      Field := FindField(FieldName);
      if Field = nil then
        raise Exception.Create(Format(SFieldNotFound, [FieldName]));
      Result.NodeType := ntField;
      Result.FieldDesc := Field;
      Result.Value := StrLexem;
      Exit;
    end;
    lxLeftSqBracket: begin
      FieldName := '';
      Parser.OmitBlank := False;
      Code := Parser.GetNext(StrLexem);
      while (Code <> lxRightSqBracket) and (Code <> lcEnd) do begin
        FieldName := FieldName + StrLexem;
        Code := Parser.GetNext(StrLexem);
      end;
      Parser.OmitBlank := True;
      Field := FindField(FieldName);
      if Field = nil then
        raise Exception.Create(Format(SFieldNotFound, [FieldName]));
      Result.NodeType := ntField;
      Result.FieldDesc := Field;
      Result.Value := FieldName;
    end;
    lcString: begin
      Result.NodeType := ntValue;
      Result.Value := AnsiDequotedStr('''' + StrLexem + '''', ''''); // TODO Optimize with StringBuilder
    end;
    lcNumber: begin
      Result.NodeType := ntValue;
      Result.Value := StrToFloat(StrLexem);
    end;
    lxMinus,lxPlus: begin
      Result.NodeType := ntValue;
      ASign := StrLexem;
      Code := Parser.GetNext(StrLexem);
      if Code = lcNumber then
        Result.Value := StrToFloat(ASign + StrLexem)
      else
        FilterError;
    end;
    lxNULL: begin
      Result.NodeType := ntValue;
      Result.Value := Null;
    end;
    lxTRUE: begin
      Result.NodeType := ntValue;
      Result.Value := True;
    end;
    lxFALSE: begin
      Result.NodeType := ntValue;
      Result.Value := False;
    end;
  else
    FilterError;
  end;

  Code := Parser.GetNext(StrLexem);
end;

procedure TData.CreateFilterExpression(Text: string);
begin
  FreeFilterExpression;
  if Trim(Text) <> '' then begin
    Parser := TBoolParser.Create(Text);
    try
      try
        Parser.ToBegin();
        Code := Parser.GetNext(StrLexem);
        FilterExpression := OrExpr();

        if (Code <> lcEnd) then
          FilterError;
      except
        FreeFilterExpression;
        raise;
      end;
    finally
      Parser.Free;
    end;
  end;
end;

procedure TData.FreeFilterExpression;
var
  Node: TExpressionNode;
begin
  while FirstAlloc <> nil do begin
    Node := FirstAlloc;
    FirstAlloc := FirstAlloc.NextAlloc;
    Node.Free;
  end;
  FilterExpression := nil;
end;

function TData.Eval(Node: TExpressionNode): boolean;

  function VarIsString(const V: Variant): boolean;
  begin
    Result := (VarType(V) = varString){$IFDEF WIN32} or (VarType(V) = varOleStr){$ENDIF}{$IFDEF CLR} or (VarType(V) = varChar){$ENDIF};
  end;

var
  V1,V2: variant;
  DateField1: boolean;
  DateField2: boolean;
  FieldDesc: TFieldDesc;

  function MatchesMask(St: string; Mask: string): boolean;
  const
    WildcardAst = '*';
    WildcardPct = '%';
    WildcardOne = '_';
  type
    TMatchesResult = (mrFalse,mrTrue,mrEnd);

    function SubMatchesMask(StIndex, MaskIndex: integer): TMatchesResult;
    begin
      while (MaskIndex <= Length(Mask)) and
        ((StIndex <= Length(St)) or
        ((Mask[MaskIndex] = WildcardAst) or (Mask[MaskIndex] = WildcardPct))) do begin
        if (Mask[MaskIndex] = WildcardAst) or (Mask[MaskIndex] = WildcardPct) then begin
          if MaskIndex = Length(Mask) then begin  //-
            Result := mrTrue;                     // Speed up
            Exit;                                 // with mask '*'
          end                                     //-
          else
            case SubMatchesMask(StIndex, MaskIndex + 1) of
              mrTrue: begin
                Result := mrTrue;
                Exit;
              end;
              mrFalse:
                if StIndex > Length(St) then begin
                  Result := mrEnd;
                  Exit;
                end
                else
                  Inc(StIndex);
              mrEnd: begin
                Result := mrEnd;
                Exit;
              end;
            end;
        end
        else
          if (St[StIndex] = Mask[MaskIndex]) or (Mask[MaskIndex] = WildcardOne)
          then begin
            Inc(StIndex);
            Inc(MaskIndex);
          end
          else begin
            Result := mrFalse;
            Exit;
          end;
      end;

      if StIndex > Length(St) then
        if MaskIndex > Length(Mask) then
          Result := mrTrue
        else
          Result := mrEnd
      else
        Result := mrFalse;
    end;
  begin
    Result := SubMatchesMask(1, 1) = mrTrue;
  end;

{$IFNDEF VER6P}
  function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean;
  begin
    try
      Value := StrToDateTime(s);
      Result := True;
    except
      Result := False;
    end;
  end;
{$ENDIF}

  procedure NormalizeDateField(var V: Variant);
{$IFNDEF CLR}
  var
    d: TDateTime;
{$ENDIF}
  begin
    if VarIsString(V) then
    {$IFDEF CLR}
      V := TDateTime(V);
    {$ELSE}
      if TryStrToDateTime(V, d) then
        V := d
      else
        V := VarToDateTime(V);
    {$ENDIF}
  end;

begin
  Assert(Node <> nil);

  Result := False;

  if Node.NodeType in [ntEqual, ntMore, ntLess, ntMoreEqual, ntLessEqual,
    ntNoEqual, ntLike]
  then begin
    Assert(Node.LeftOperand <> nil);
    Assert(Node.RightOperand <> nil);

    DateField1 := False;
    DateField2 := False;

    case Node.LeftOperand.NodeType of
      ntField: begin
        FieldDesc := Node.LeftOperand.FieldDesc;
        GetFieldAsVariant(FieldDesc.FieldNo, FilterRecBuf, V1);
        DateField1 := FieldDesc.DataType in [dtDateTime, dtDate, dtTime];
      end;
      ntValue:
        V1 := Node.LeftOperand.Value;
    end;

    case Node.RightOperand.NodeType of
      ntField: begin
        FieldDesc := Node.RightOperand.FieldDesc;
        GetFieldAsVariant(FieldDesc.FieldNo, FilterRecBuf, V2);
        DateField2 := FieldDesc.DataType in [dtDateTime, dtDate, dtTime];
      end;
      ntValue:
        V2 := Node.RightOperand.Value;
    end;

    if DateField1 then
      NormalizeDateField(V2); /// CR-D12823
    if DateField2 then
      NormalizeDateField(V1);

    if FilterCaseInsensitive then begin
      if VarIsString(V1) then
        V1 := AnsiUpperCase(VarToStr(V1));
      if VarIsString(V2) then
        V2 := AnsiUpperCase(VarToStr(V2));
    end;

//    if FilterNoPartialCompare then;

  end;

  if (VarIsNull(V1) or VarIsNull(V2)) and (Node.NodeType in [ntMore, ntLess, ntMoreEqual, ntLessEqual]) then begin
    // To prevent exception on compare value with Null
    Result := False;
    Exit;
  end;

  case Node.NodeType of
    ntEqual, ntLike:
      if FilterNoPartialCompare or not VarIsString(V1) then
        Result := V1 = V2
      else
        Result := MatchesMask(VarToStr(V1), VarToStr(V2));
    ntNoEqual:
      if FilterNoPartialCompare or not VarIsString(V1) then
        Result := V1 <> V2
      else
        Result := not MatchesMask(VarToStr(V1), VarToStr(V2));
    ntMore:
      Result := V1 > V2;
    ntLess:
      Result := V1 < V2;
    ntMoreEqual:
      Result := V1 >= V2;
    ntLessEqual:
      Result := V1 <= V2;
    ntAnd:
      Result := Eval(Node.LeftOperand) and Eval(Node.RightOperand);
    ntOr:
      Result := Eval(Node.LeftOperand) or Eval(Node.RightOperand);
    ntNot:
      Result := not Eval(Node.LeftOperand);
    ntTrue:
      Result := True;
    ntFalse:
      Result := False;
  else
    Assert(False);
  end;
end;

procedure TData.FilterUpdated;
begin
end;

function TData.Filtered: boolean;
begin
  Result := Assigned(FFilterFunc) or Assigned(FilterExpression) or
    Assigned(FFilterMDFunc);
end;

{ Blobs }

function TData.InternalGetObject(FieldNo: word; RecBuf: IntPtr): TSharedObject;
var
  IsBlank: boolean;
  Ptr: IntPtr;
begin
  Ptr := Marshal.AllocHGlobal(sizeof(IntPtr));
  try
    GetField(FieldNo, RecBuf, Ptr, IsBlank);
    Result := TSharedObject(GetGCHandleTarget(Marshal.ReadIntPtr(Ptr)));
  finally
    Marshal.FreeHGlobal(Ptr);
  end;
end;

function TData.GetObject(FieldNo: word; RecBuf: IntPtr): TSharedObject;
begin
  if not IsBlobFieldType(Fields[FieldNo - 1].DataType) then
    raise Exception.Create(SNeedBlobType);

  Result := InternalGetObject(FieldNo, RecBuf);

  Assert(Result <> nil, 'Object for field ' + Fields[FieldNo - 1].Name + '(' + IntToStr(FieldNo) + ') = nil');
end;

procedure TData.SetObject(FieldNo: word; RecBuf: IntPtr; Obj: TSharedObject);
begin
  if not IsBlobFieldType(Fields[FieldNo - 1].DataType) then
    raise Exception.Create(SNeedBlobType);

  Marshal.WriteIntPtr(RecBuf, Fields[FieldNo - 1].Offset, Obj.GCHandle);
end;

{$IFDEF VER6}
{$IFDEF MSWINDOWS}
var
  DefaultUserCodePage: Integer;
{$ENDIF}

type
  PStrRec = ^StrRec;
  StrRec = packed record
    refCnt: Longint;
    length: Longint;
  end;

{$IFDEF LINUX}
const
  libc = 'libc.so.6';

const
  LC_CTYPE    = 0;
  _NL_CTYPE_CODESET_NAME = LC_CTYPE shl 16 + 14;

function iconv_open(ToCode: PChar; FromCode: PChar): Integer; cdecl;
  external libc name 'iconv_open';

function nl_langinfo(item: integer): pchar; cdecl;
  external libc name 'nl_langinfo';

function iconv(cd: Integer; var InBuf; var InBytesLeft: Integer; var OutBuf; var OutBytesLeft: Integer): Integer; cdecl;
  external libc name 'iconv';

function iconv_close(cd: Integer): Integer; cdecl;
  external libc name 'iconv_close';

function CharacterSizeWideChar(P: Pointer; MaxLen: Integer): Integer;
begin
  Result := SizeOf(WideChar);
end;
  
procedure LocaleConversionError;
begin
  Error(TRuntimeError(234) {reCodesetConversion});
end;

type
  TCharacterSizeProc = function(P: Pointer; MaxLen: Integer): Integer;

function __errno_location: PInteger; cdecl;
  external libc name '__errno_location';
  
function GetLastError: Integer;
begin
  Result := __errno_location^;
end;
  
function BufConvert(var Dest;   DestBytes: Integer;
                    const Source; SrcBytes: Integer;
                    context: Integer;
                    DestCharSize: Integer;
                    SourceCharSize: TCharacterSizeProc): Integer;
const
  E2BIG = 7;
  EINVAL = 22;
  EILSEQ = 84;
const
  UnknownCharIndicator = '?';
var
  SrcBytesLeft, DestBytesLeft, Zero: Integer;
  s, d, pNil: Pointer;
  LastError: Integer;
  cs: Integer;
begin
  Result := -1;

  // Make copies of parameters. iconv modifies param pointers.
  DestBytesLeft := DestBytes;
  SrcBytesLeft := SrcBytes;
  s := Pointer(Source);
  d := Pointer(Dest);

  while True do
  begin
    Result := iconv(context, s, SrcBytesLeft, d, DestBytesLeft);
    if Result <> -1 then
      Break
    else
    begin
      LastError := GetLastError;
      if (LastError = E2BIG) and (SrcBytesLeft > 0) and (DestBytesLeft > 0) then
        Continue;

      if (LastError <> EINVAL) and (LastError <> EILSEQ) then
        LocaleConversionError;
      pNil := nil;
      Zero := 0;
      iconv(context, pNil, Zero, pNil, Zero); // Reset state of context

      // Invalid input character in conversion stream.
      // Skip input character and write '?' to output stream.
      // The glibc iconv() implementation also returns EILSEQ
      // for a valid input character that cannot be converted
      // into the requested codeset.
      cs := SourceCharSize(s, SrcBytesLeft);
      Inc(Cardinal(s), cs);
      Dec(SrcBytesLeft, cs);

      Assert(DestCharSize in [1, 2]);
      case DestCharSize of
        1:
          begin
            PChar(d)^ := UnknownCharIndicator;
            Inc(PChar(d));
            Dec(DestBytesLeft, SizeOf(Char));
          end;

        2:
          begin
            PWideChar(d)^ := UnknownCharIndicator;
            Inc(PWideChar(d));
            Dec(DestBytesLeft, SizeOf(WideChar));
          end;
      end;
    end;
  end;

  if Result <> -1 then
    Result := DestBytes - DestBytesLeft;
end;
{$ENDIF}
  
function CharFromWCharD7(CharDest: PChar; DestBytes: Integer; const WCharSource: PWideChar; SrcChars: Integer): Integer;
{$IFDEF LINUX}
var
  IconvContext: Integer;
{$ENDIF}
begin
{$IFDEF LINUX}
  if (DestBytes <> 0) and (SrcChars <> 0) then
  begin
    IconvContext := iconv_open(nl_langinfo(_NL_CTYPE_CODESET_NAME), 'UNICODELITTLE');
    if IconvContext = -1 then
      LocaleConversionError;
    try
      Result := BufConvert(CharDest, DestBytes, WCharSource, SrcChars * SizeOf(WideChar),
         IconvContext, 1, CharacterSizeWideChar);
    finally
      iconv_close(IconvContext);
    end;
  end
  else
    Result := 0;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Result := WideCharToMultiByte(DefaultUserCodePage, 0, WCharSource, SrcChars,
      CharDest, DestBytes, nil, nil);
{$ENDIF}
end;

procedure _LStrClr(var S);
var
  P: PStrRec;
begin
  if Pointer(S) <> nil then
  begin
    P := Pointer(Integer(S) - Sizeof(StrRec));
    Pointer(S) := nil;
    if P.refCnt > 0 then
      if InterlockedDecrement(P.refCnt) = 0 then
        FreeMem(P);
  end;
end;

function _NewAnsiString(length: Longint): Pointer;
var
  P: PStrRec;
begin
  Result := nil;
  if length <= 0 then Exit;
  // Alloc an extra null for strings with even length.  This has no actual cost
  // since the allocator will round up the request to an even size anyway.
  // All widestring allocations have even length, and need a double null terminator.
  GetMem(P, length + sizeof(StrRec) + 1 + ((length + 1) and 1));
  Result := Pointer(Integer(P) + sizeof(StrRec));
  P.length := length;
  P.refcnt := 1;
  PWideChar(Result)[length div 2] := #0;  // length guaranteed >= 2
end;

procedure _LStrFromPCharLen(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
asm
  { ->    EAX     pointer to dest }
  {       EDX source              }
  {       ECX length              }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        { allocate new string }

        MOV     EAX,EDI

        CALL    _NewAnsiString
        MOV     ECX,EDI
        MOV     EDI,EAX

        TEST    ESI,ESI
        JE      @@noMove

        MOV     EDX,EAX
        MOV     EAX,ESI
        CALL    Move

        { assign the result to dest }

@@noMove:
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     [EBX],EDI

        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure _LStrFromPWCharLenD7(var Dest: AnsiString; Source: PWideChar; Length: Integer);
var
  DestLen: Integer;
  Buffer: array[0..4095] of Char;
begin
  if Length <= 0 then
  begin
    _LStrClr(Dest);
    Exit;
  end;
  if Length+1 < (High(Buffer) div sizeof(WideChar)) then
  begin
    DestLen := CharFromWCharD7(Buffer, High(Buffer), Source, Length);
    if DestLen >= 0 then
    begin
      _LStrFromPCharLen(Dest, Buffer, DestLen);
      Exit;
    end;
  end;

  DestLen := (Length + 1) * sizeof(WideChar);
  SetLength(Dest, DestLen);  // overallocate, trim later
  DestLen := CharFromWCharD7(Pointer(Dest), DestLen, Source, Length);
  if DestLen < 0 then DestLen := 0;
  SetLength(Dest, DestLen);
end;

procedure _LStrFromWStrD7(var Dest: AnsiString; const Source: WideString);
asm
        { ->    EAX pointer to dest              }
        {       EDX pointer to WideString data   }

        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@1
        MOV     ECX,[EDX-4]
        SHR     ECX,1
@@1:    JMP     _LStrFromPWCharLenD7
end;
{$ENDIF}

function TData.ReadBlob(FieldNo: word; RecBuf: IntPtr; Position: longint;
  Count: longint; Dest: IntPtr; FromRollback: boolean = false;
  TrueUnicode: boolean = False): longint;
var
  Blob: TBlob;
  LenBytes, BlobPos: longint;
  Ws, Buf: IntPtr;
  s: string;
  
begin
  Blob := TBlob(GetObject(FieldNo, RecBuf));
  if FromRollback and (Blob.Rollback <> nil) then
    Blob := Blob.Rollback;

  if not Blob.FIsUnicode or TrueUnicode then
    Result := Blob.Read(Position, Count, Dest)
  else
  begin
    BlobPos := Blob.TranslatePosition(Position);
    if Count = 0 then
      LenBytes := LongInt(Blob.Size) - BlobPos
    else
      LenBytes := Blob.TranslatePosition(Count);

    Ws := Marshal.AllocHGlobal(LenBytes);
    Buf := nil;
    try
      Result := Blob.Read(BlobPos, LenBytes, Ws);
    {$IFNDEF VER6}
      s := Marshal.PtrToStringUni(Ws, Result div 2);
    {$ELSE}
      _LStrFromWStrD7(s, Marshal.PtrToStringUni(Ws, Result div 2));
    {$ENDIF}
      Result := Length(s);
      Buf := Marshal.StringToHGlobalAnsi(s);
      CopyBuffer(Buf, Dest, Result);
    finally
      Marshal.FreeHGlobal(Ws);
      if Buf <> nil then
        Marshal.FreeCoTaskMem(Buf);
    end;
  end;
end;

procedure TData.WriteBlob(FieldNo: word; RecBuf: IntPtr; Position: longint;
  Count: longint; Source: IntPtr; TrueUnicode: boolean = False);
var
  Blob: TBlob;
  Buf: IntPtr;
  S: string;
  Ws: WideString;

begin
  Blob := TBlob(GetObject(FieldNo, RecBuf));

  Blob.EnableRollback;
  if not Blob.FIsUnicode or TrueUnicode then
    Blob.Write(Position, Count, Source)
  else begin
    S := Marshal.PtrToStringAnsi(Source, Count);
    Ws := S;
    Count := Length(Ws) * 2; // for MBCS this differ from Count * 2
    Position := Blob.TranslatePosition(Position);
    Buf := Marshal.StringToHGlobalUni(Ws);
    try
      Blob.Write(Position, Count, Buf); //Count length in bytes
    finally
      Marshal.FreeCoTaskMem(Buf);
    end;
  end;

  SetNull(FieldNo, RecBuf, False);
end;

procedure TData.TruncateBlob(FieldNo: word; RecBuf: IntPtr; Size: longint;
  TrueUnicode: boolean = False);
var
  Blob:TBlob;
begin
  Blob := TBlob(GetObject(FieldNo, RecBuf));

  Blob.EnableRollback;
  if Blob.FIsUnicode and not TrueUnicode then
    Size := Blob.TranslatePosition(Size);

  Blob.Truncate(Size);

  if Size = 0 then
    SetNull(FieldNo, RecBuf, True);
end;

function TData.GetBlobSize(FieldNo: word; RecBuf: IntPtr; FromRollback: boolean = false;
  TrueUnicode: boolean = False): longint;
var
  Blob: TBlob;
begin
  if GetNull(FieldNo, RecBuf) then begin
    Result := 0;
    Exit;
  end;
  Blob := TBlob(GetObject(FieldNo, RecBuf));
  if FromRollback and (Blob.Rollback <> nil) then
    Blob := Blob.Rollback;
  if not Blob.FIsUnicode or TrueUnicode then
    Result := Blob.Size
  else
    Result := Blob.GetSizeAnsi;
end;

procedure TData.SetBlobSize(FieldNo: word; RecBuf: IntPtr; NewSize: longint; FromRollback: boolean = false;
  TrueUnicode: boolean = False);
var
  Blob: TBlob;
  OldSize: integer;
begin
  SetNull(FieldNo, RecBuf, False);

  Blob := TBlob(GetObject(FieldNo, RecBuf));
  if FromRollback and (Blob.Rollback <> nil) then
    Blob := Blob.Rollback;

  if Blob.FIsUnicode and not TrueUnicode then begin
    // Blob.Size is char count * 2
    OldSize := Blob.GetSizeAnsi;
    if NewSize > OldSize then
      Blob.Size := Integer(Blob.Size) + (NewSize - OldSize) * 2
    else
      Blob.Size := Blob.TranslatePosition(NewSize);
  end
  else
    Blob.Size := NewSize;
end;

procedure TData.SetCachedUpdates(Value: boolean);
begin
  if Value <> FCachedUpdates then begin
    if FCachedUpdates then
      CancelUpdates;

    FCachedUpdates := Value;

    if FCachedUpdates then
      FFilterItemTypes := [isUnmodified, isUpdated, isAppended];
  end;
end;

procedure TData.SetFilterText(Value: string);
begin
  if Value <> FFilterText then begin
    if Active then
      CreateFilterExpression(Value);
    FFilterText := Value;
  end;
end;

procedure TData.SetFilterItemTypes(Value:TItemTypes);
begin
  FFilterItemTypes := Value;
end;

{ TSortColumns }

destructor TSortColumns.Destroy;
begin
  Clear;

  inherited;
end;

procedure TSortColumns.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i] <> nil then
      TSortColumn(Items[i]).Free;

  inherited Clear;
end;

function TSortColumns.GetItems(Index: integer): TSortColumn;
begin
  Result := TSortColumn(inherited Items[Index]);
end;

{ TMemData }

constructor TMemData.Create;
begin
  inherited;

  BlockMan := TBlockManager.Create;
  FIndexFields := TSortColumns.Create;

  InitData;
end;

destructor TMemData.Destroy;
begin
  inherited;

  FIndexFields.Free;
  BlockMan.Free;
  SetLength(FRecordNoCache, 0);
end;

{ Items / Data }

procedure TMemData.SetIndexFieldNames(Value: string);
begin
  FIndexFieldNames := Value;
  if Active then begin
    UpdateIndexFields;
    SortItems;
  end;
end;

procedure TMemData.UpdateIndexFields;
var
  S, S1: string;
  FldName: string;
  FieldDesc: TFieldDesc;
  SortColumn: TSortColumn;
  ProcessedCS, ProcessedDESC: boolean;

  procedure RaiseError;
  begin
    raise Exception.Create('Invalid IndexFieldNames format!');
  end;

begin
  FIndexFields.Clear;
  S := FIndexFieldNames;
  if Trim(S) <> '' then begin
    Parser := TBoolParser.Create(S);

    try
      Parser.ToBegin();
      Code := Parser.GetNext(S1);
      while Code <> lcEnd do begin
        case Code of
          lcIdent, lcString, lxLeftSqBracket: begin
            if Code = lxLeftSqBracket then begin
              Parser.OmitBlank := False;
              Code := Parser.GetNext(S1);
              FldName := '';
              while (Code <> lxRightSqBracket) and (Code <> lcEnd) do begin
                FldName := FldName + S1;
                Code := Parser.GetNext(S1);
              end;
              Parser.OmitBlank := True;
              S1 := FldName;
            end;

            FieldDesc := Fields.FindField(S1);
            if FieldDesc = nil then
              raise Exception.Create(Format(SFieldNotFound, [S1]));
            SortColumn := TSortColumn.Create;
            SortColumn.FieldDesc := FieldDesc;
            SortColumn.CaseSensitive := True;
            FIndexFields.Add(SortColumn);
            Code := Parser.GetNext(S1);
            ProcessedCS := False;
            ProcessedDESC := False;
            while not (((Code = lcSymbol) and ((S1 = ';') or (S1 = ','))) or (Code = lcEnd)) do begin
              if Code = lcIdent then begin
                if not ProcessedDESC and ('DESC' = UpperCase(S1)) then begin
                  SortColumn.DescendingOrder := True;
                  ProcessedDESC := True;
                end
                else
                if not ProcessedCS and ('CIS' = UpperCase(S1)) then begin
                  SortColumn.CaseSensitive := False;
                  ProcessedCS := True;
                end
                else
                if not ProcessedDESC and ('ASC' = UpperCase(S1)) then
                  ProcessedDESC := True
                else
                if not ProcessedCS and ('CS' = UpperCase(S1)) then
                  ProcessedCS := True
                else
                  RaiseError;
                Code := Parser.GetNext(S1);
              end
              else
                RaiseError;
            end;
          end;
          lcSymbol: begin
            if (S1 <> ';') and (S1 <> ',') then
              RaiseError;
            Code := Parser.GetNext(S1);
          end
        else
          RaiseError;
        end;
      end;
    finally
      Parser.Free;
    end;
  end;
end;

{$IFNDEF CLR}
function TMemData.InternalAnsiStrComp(const Value1, Value2: IntPtr;
  const Options: TLocateExOptions): integer;
begin
  if lxCaseInsensitive in Options then
    Result := AnsiStrICompS(Value1, Value2)
  else
    Result := AnsiStrCompS(Value1, Value2);
end;
{$ENDIF}

function TMemData.InternalAnsiCompareText(const Value1, Value2: string;
  const Options: TLocateExOptions): integer;
begin
  if lxCaseInsensitive in Options then
    Result := AnsiCompareTextS(Value1, Value2)
  else
    Result := AnsiCompareStrS(Value1, Value2);
end;

function TMemData.InternalWStrLComp(const Value1, Value2: WideString;
  const Options: TLocateExOptions): integer;
begin
  if lxCaseInsensitive in Options then
    Result := AnsiStrLICompWS(Value1, Value2, Length(Value1))
  else
    Result := AnsiStrLCompWS(Value1, Value2, Length(Value1))
end;

function TMemData.InternalWStrComp(const Value1, Value2: WideString;
  const Options: TLocateExOptions): integer;
begin
  if lxCaseInsensitive in Options then
    Result := AnsiStrICompWS(Value1, Value2)
  else
    Result := AnsiStrCompWS(Value1, Value2);
end;

// Used to compare field value and string KeyValue with matching options
function TMemData.CompareStrValues(const Value: string;
  const FieldValue: string; const Options: TLocateExOptions): integer;
var
  Res: integer;
  ValueLen: integer;
begin
  if lxPartialCompare in Options then begin
    if lxCaseInsensitive in Options then
      Res := Pos(AnsiUpperCase(Value), AnsiUpperCase(FieldValue))
    else
      Res := Pos(Value, FieldValue);
    if Res = 0 then
      Res := 1
    else
      Res := 0;
  end
  else
  if lxPartialKey in Options then begin
    ValueLen := Length(Value);
    if ValueLen = 0 then
      ValueLen := Length(FieldValue);
    if Length(FieldValue) >= ValueLen then
      Result := 0
    else
      Result := 1;
    if Result <> 0 then
      Exit // To avoid AV in case Len(Value) > Len(St)
    else
      Res := InternalAnsiCompareText(Value, Copy(FieldValue, 1, ValueLen), Options);
  end
  else
    Res := InternalAnsiCompareText(Value, FieldValue, Options);
  Result := Res;
end;

function TMemData.CompareWideStrValues(const Value: WideString;
  const FieldValue: WideString; const Options: TLocateExOptions): integer;
var
  Res: integer;
  ValueLen: integer;

{$IFDEF MSWINDOWS}
  ValueS, FieldValueS: string;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if IsWin9x then begin
    ValueS := Value;
    FieldValueS := FieldValue;
    Result := CompareStrValues(ValueS, FieldValueS, Options);
    Exit;
  end;
{$ENDIF}

  if lxPartialCompare in Options then begin
    if lxCaseInsensitive in Options then
      Res := Pos(WideUpperCase(Value), WideUpperCase(FieldValue))
    else
      Res := Pos(Value, FieldValue);
    if Res = 0 then
      Res := 1
    else
      Res := 0;
  end
  else
  if lxPartialKey in Options then begin
    ValueLen := Length(Value);
    if Length(FieldValue) >= ValueLen then
      Result := 0
    else
      Result := 1;
    if Result <> 0 then
      Exit // To avoid AV in case Len(Value) > Len(St)
    else
      Res := InternalWStrLComp(Value, FieldValue, Options);
  end
  else
    Res := InternalWStrComp(Value, FieldValue, Options);
  Result := Res;
end;

// Used to compare binary field value and binary KeyValue with matching options
function TMemData.CompareBinValues(const Value: IntPtr;
  const ValueLen: integer; const FieldValue: IntPtr;
  const FieldValueLen: integer; const Options: TLocateExOptions): integer;

  function CompareMem(FieldValue, Value: IntPtr; FieldValueLen: integer): integer;
  var
    i: integer;
  begin
    for i := 0 to FieldValueLen div 4 - 1 do begin
      if Longword(Marshal.ReadInt32(Value, i shl 2)) > Longword(Marshal.ReadInt64(FieldValue, i shl 2)) then begin
        Result := 1;
        Exit;
      end
      else
      if Longword(Marshal.ReadInt32(Value, i shl 2)) < Longword(Marshal.ReadInt64(FieldValue, i shl 2)) then begin
        Result := -1;
        Exit;
      end
    end;
    for i := ((FieldValueLen - 1) and $fffffffc) to FieldValueLen - 1 do begin
      if Marshal.ReadByte(Value, i) > Marshal.ReadByte(FieldValue, i) then begin
        Result := 1;
        Exit;
      end
      else
      if Marshal.ReadByte(Value, i) > Marshal.ReadByte(FieldValue, i) then begin
        Result := -1;
        Exit;
      end
    end;
    Result := 0;
  end;

var
  i: integer;

begin
  if lxPartialCompare in Options then begin
    if FieldValueLen >= ValueLen then
      Result := 0
    else
      Result := 1;
    if Result <> 0 then
      Exit // Field value is shorter when Value
    else
    begin
      for i := integer(FieldValue) to integer(FieldValue) + FieldValueLen - ValueLen - 1 do begin
        Result := CompareMem(IntPtr(i), Value, ValueLen);
        if Result = 0 then
          Break;
      end;
      Result := 1;
    end;
  end
  else
  if lxPartialKey in Options then begin
    if FieldValueLen >= ValueLen then
      Result := 0
    else
      Result := 1;
    if Result <> 0 then
      Exit // Field value is shorter when Value
    else
      Result := CompareMem(FieldValue, Value, ValueLen);
  end
  else
  begin
    if ValueLen = FieldValueLen then
      Result := 0
    else
      Result := 1;
    if Result <> 0  then
      Exit
    else
      Result := CompareMem(FieldValue, Value, FieldValueLen);
  end;
end;

// Used to compare field value and KeyValue from MemDataSet.LocateRecord
function TMemData.CompareFieldValue(
  ValuePtr: IntPtr; const ValueType: integer; FieldDesc: TFieldDesc;
  RecBuf: IntPtr; const Options: TLocateExOptions): integer;
var
  St: string;
  WSt: WideString;
  BlobValue: IntPtr;
  FieldBuf: IntPtr;
  FieldBufStatic: IntPtr;
  IsBlank: boolean;
  l: integer;
  c, cValue: Currency;
{$IFDEF VER6P}
  bcd, bcdValue: TBcd;
{$ENDIF}
{$IFDEF CLR}
  Data: TBytes;
{$ENDIF}
  Value: string;
  WValue: WideString;
  v1, v2: variant;
  v1VType, v2VType: TVarType;
{$IFNDEF CLR}
  v1VArray, v2VArray: PVarArray;
  v1VArrayData, v2VArrayData: IntPtr;
{$ENDIF}

begin
  FieldBufStatic := nil;

  if FieldDesc.ParentField = nil then
    FieldBuf := IntPtr(integer(RecBuf) + FieldDesc.Offset)
  else begin
  // support objects
    FieldBufStatic := Marshal.AllocHGlobal(4001);
    FieldBuf := FieldBufStatic;
    GetField(FieldDesc.FieldNo, RecBuf, FieldBuf, IsBlank);  // GetChildField
  end;

  Result := 0;
  try
    case ValueType of
      dtString, dtGuid: begin
        case FieldDesc.DataType of
          dtString: begin
          {$IFNDEF CLR}
            if not (lxPartialKey in Options)
              and not (lxPartialCompare in Options)
              and not (FieldDesc.Fixed and TrimFixedChar)
              and not (not FieldDesc.Fixed and TrimVarChar)
            then begin
              Result := InternalAnsiStrComp(ValuePtr, FieldBuf, Options);
              Exit;
            end;
          {$ENDIF}
            St := Marshal.PtrToStringAnsi(FieldBuf);
            if FieldDesc.Fixed and TrimFixedChar then
              St := Trim(St)
            else
            if not FieldDesc.Fixed and TrimVarChar then
              St := Trim(St)
          end;
          dtWideString: begin
            St := Marshal.PtrToStringUni(FieldBuf);
            if FieldDesc.Fixed and TrimFixedChar then
              St := Trim(St)
            else
            if not FieldDesc.Fixed and TrimVarChar then
              St := Trim(St)
          end;
          dtExtString: begin
          {$IFNDEF CLR}
            if not (lxPartialKey in Options) and not (lxPartialCompare in Options) then begin
              Result := InternalAnsiStrComp(ValuePtr, Marshal.ReadIntPtr(FieldBuf), Options);
              Exit;
            end;
          {$ENDIF}
            St := Marshal.PtrToStringAnsi(Marshal.ReadIntPtr(FieldBuf));
          end;
          dtExtWideString:
            St := Marshal.PtrToStringUni(Marshal.ReadIntPtr(FieldBuf));
        {$IFDEF VER5P}
          dtVariant:
            St := TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(FieldBuf))).Value;
        {$ENDIF}
          dtInt8:
            St := IntToStr(ShortInt(Marshal.ReadByte(FieldBuf)));
          dtInt16:
            St := IntToStr(Marshal.ReadInt16(FieldBuf));
          dtUInt16:
            St := IntToStr(Word(Marshal.ReadInt16(FieldBuf)));
          dtInt32:
            St := IntToStr(Marshal.ReadInt32(FieldBuf));
          dtUInt32:
            St := IntToStr(Longword(Marshal.ReadInt32(FieldBuf)));
          dtInt64:
            St := IntToStr(Marshal.ReadInt64(FieldBuf));
          dtFloat, dtCurrency:
            St := FloatToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtDate:
            St := DateToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtTime:
            St := TimeToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtDateTime:
            St := DateTimeToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtBCD:
          begin
            c := Marshal.ReadInt64(RecBuf, FieldDesc.Offset) / 10000;
            St := CurrToStr(c);
            Result := CompareStrValues(Marshal.PtrToStringAnsi(ValuePtr), St, Options + [lxCaseInsensitive]);
            Exit;
          end;
        {$IFDEF VER6P}
          dtFmtBCD:
          begin
          {$IFDEF CLR}
            SetLength(Data, SizeOfTBcd);
            Marshal.Copy(IntPtr(Integer(RecBuf) + FieldDesc.Offset), Data, 0, SizeOfTBcd);
            bcd := TBcd.FromBytes(Data);
          {$ELSE}
            bcd := PBcd(PChar(RecBuf) + FieldDesc.Offset)^;
          {$ENDIF}
            St := BcdToStr(bcd);
            Result := CompareStrValues(Marshal.PtrToStringAnsi(ValuePtr), St, Options + [lxCaseInsensitive]);
            Exit;
          end;
        {$ENDIF}
          dtGuid:
          begin
            Result := CompareStrValues(Marshal.PtrToStringAnsi(ValuePtr), Marshal.PtrToStringAnsi(FieldBuf), Options + [lxCaseInsensitive]);
            Exit;
          end;
        else
          if IsBlobFieldType(FieldDesc.DataType) then begin
            l := GetBlobSize(FieldDesc.FieldNo, RecBuf);
            BlobValue := Marshal.AllocHGlobal(l + 1);
            try
              ReadBlob(FieldDesc.FieldNo, RecBuf, 0, l, BlobValue);
              St := Marshal.PtrToStringAnsi(BlobValue, l);
            finally
              Marshal.FreeHGlobal(BlobValue);
            end;
          end
          else
            raise EConvertError.Create(SCannotConvertType);
        end;

        if ((FieldDesc.DataType = dtString) or (FieldDesc.DataType = dtWideString))
          and ((FieldDesc.Fixed and TrimFixedChar) or (not FieldDesc.Fixed and TrimVarChar)) then
          Value := Trim(Marshal.PtrToStringAnsi(ValuePtr))
        else
          Value := Marshal.PtrToStringAnsi(ValuePtr);
        Result := CompareStrValues(Value, St, Options);
      end;
      dtWideString: begin
        case FieldDesc.DataType of
          dtWideString: begin
            WSt := Marshal.PtrToStringUni(FieldBuf);
            if FieldDesc.Fixed and TrimFixedChar then
              WSt := Trim(WSt)
            else
            if not FieldDesc.Fixed and TrimVarChar then
              WSt := Trim(WSt)
          end;
          dtString: begin
            WSt := Marshal.PtrToStringAnsi(FieldBuf);
            if FieldDesc.Fixed and TrimFixedChar then
              WSt := Trim(WSt)
            else
            if not FieldDesc.Fixed and TrimVarChar then
              WSt := Trim(WSt)
          end;
          dtExtString:
            WSt := Marshal.PtrToStringAnsi(Marshal.ReadIntPtr(FieldBuf));
          dtExtWideString:
            WSt := Marshal.PtrToStringUni(Marshal.ReadIntPtr(FieldBuf));
        {$IFDEF VER5P}
          dtVariant:
            WSt := TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(FieldBuf))).Value;
        {$ENDIF}
          dtInt8:
            WSt := IntToStr(ShortInt(Marshal.ReadByte(FieldBuf)));
          dtInt16:
            WSt := IntToStr(Marshal.ReadInt16(FieldBuf));
          dtUInt16:
            WSt := IntToStr(Word(Marshal.ReadInt16(FieldBuf)));
          dtInt32:
            WSt := IntToStr(Marshal.ReadInt32(FieldBuf));
          dtUInt32:
            WSt := IntToStr(Longword(Marshal.ReadInt16(FieldBuf)));
          dtInt64:
            WSt := IntToStr(Marshal.ReadInt64(FieldBuf));
          dtFloat, dtCurrency:
            WSt := FloatToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtDate:
            WSt := DateToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtTime:
            WSt := TimeToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtDateTime:
            WSt := DateTimeToStr(BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)));
          dtBCD:
          begin
            c := Marshal.ReadInt64(RecBuf, FieldDesc.Offset) / 10000;
            WSt := CurrToStr(c);
            Result := CompareWideStrValues(Marshal.PtrToStringUni(ValuePtr), WSt, Options + [lxCaseInsensitive]);
            Exit;
          end;
        else
          if IsBlobFieldType(FieldDesc.DataType) then begin
            BlobValue := Marshal.AllocHGlobal(GetBlobSize(FieldDesc.FieldNo, RecBuf));
            try
              ReadBlob(FieldDesc.FieldNo, RecBuf, 0, 0, BlobValue);
              St := Marshal.PtrToStringUni(BlobValue);
            finally
              Marshal.FreeHGlobal(BlobValue);
            end;
          end
          else
            raise EConvertError.Create(SCannotConvertType);
        end;

        if ((FieldDesc.DataType = dtString) or (FieldDesc.DataType = dtWideString))
          and ((FieldDesc.Fixed and TrimFixedChar) or (not FieldDesc.Fixed and TrimVarChar)) then
          WValue := Trim(Marshal.PtrToStringUni(ValuePtr))
        else
          WValue := Marshal.PtrToStringUni(ValuePtr);
        Result := CompareWideStrValues(WValue, WSt, Options);
      end;
      dtInt8:
        if ShortInt(Marshal.ReadByte(FieldBuf)) < ShortInt(Marshal.ReadByte(ValuePtr)) then
          Result := 1
        else
        if ShortInt(Marshal.ReadByte(FieldBuf)) > ShortInt(Marshal.ReadByte(ValuePtr)) then
          Result := -1
        else
          Result := 0;
      dtInt16:
        if Marshal.ReadInt16(FieldBuf) < Marshal.ReadInt16(ValuePtr) then
          Result := 1
        else
        if Marshal.ReadInt16(FieldBuf) > Marshal.ReadInt16(ValuePtr) then
          Result := -1
        else
          Result := 0;
      dtUInt16:
        if Word(Marshal.ReadInt16(FieldBuf)) < Word(Marshal.ReadInt16(ValuePtr)) then
          Result := 1
        else
        if Word(Marshal.ReadInt16(FieldBuf)) > Word(Marshal.ReadInt16(ValuePtr)) then
          Result := -1
        else
          Result := 0;
      dtInt32:
        if Marshal.ReadInt32(FieldBuf) < Marshal.ReadInt32(ValuePtr) then
          Result := 1
        else
        if Marshal.ReadInt32(FieldBuf) > Marshal.ReadInt32(ValuePtr) then
          Result := -1
        else
          Result := 0;
      dtUInt32:
        if Longword(Marshal.ReadInt32(FieldBuf)) < Longword(Marshal.ReadInt32(ValuePtr)) then
          Result := 1
        else
        if Longword(Marshal.ReadInt32(FieldBuf)) > Longword(Marshal.ReadInt32(ValuePtr)) then
          Result := -1
        else
          Result := 0;
      dtInt64:
        if Marshal.ReadInt64(FieldBuf) < Marshal.ReadInt64(ValuePtr) then
          Result := 1
        else
        if Marshal.ReadInt64(FieldBuf) > Marshal.ReadInt64(ValuePtr) then
          Result := -1
        else
          Result := 0;
      dtBoolean:
        if (Marshal.ReadByte(FieldBuf) = 0) = (Marshal.ReadByte(ValuePtr) = 0) then // Cannot use 'boolean(FieldBuf^) = boolean(ValuePtr^)' because 'True' may have any value without 0
          Result := 0
        else
        if (Marshal.ReadByte(FieldBuf) = 0) then
          Result := 1
        else
          Result := -1;
      dtFloat, dtCurrency,
      dtDateTime, dtDate, dtTime: begin
        if BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)) < BitConverter.Int64BitsToDouble(Marshal.ReadInt64(ValuePtr)) then
          Result := 1
        else
        if BitConverter.Int64BitsToDouble(Marshal.ReadInt64(FieldBuf)) > BitConverter.Int64BitsToDouble(Marshal.ReadInt64(ValuePtr)) then
          Result := -1
        else
          Result := 0;
      end;
      dtBytes:
        Result := CompareBinValues(IntPtr(integer(ValuePtr) + SizeOf(Word)),
         Marshal.ReadInt16(ValuePtr), FieldBuf, FieldDesc.Length, Options);
      dtVarBytes:
        Result := CompareBinValues(IntPtr(integer(ValuePtr) + SizeOf(Word)),
          Marshal.ReadInt16(ValuePtr), IntPtr(integer(FieldBuf) + SizeOf(Word)),
          Marshal.ReadInt16(FieldBuf), Options);
      dtExtVarBytes:
        Result := CompareBinValues(IntPtr(integer(ValuePtr) + SizeOf(Word)),
          Marshal.ReadInt16(ValuePtr),
          IntPtr(integer(Marshal.ReadIntPtr(FieldBuf)) + SizeOf(Word)),
          Marshal.ReadInt16(Marshal.ReadIntPtr(FieldBuf)), Options);
      dtBCD: begin
        c := Marshal.ReadInt64(RecBuf, FieldDesc.Offset) / 10000;
        cValue := BitConverter.Int64BitsToDouble(Marshal.ReadInt64(ValuePtr));
        if c < cValue then
          Result := 1
        else
        if c > cValue then
          Result := -1
        else
          Result := 0;
      end;
      dtVariant: begin
        v1 := TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(FieldBuf))).Value;
        v2 := TVariantObject(GetGCHandleTarget(Marshal.ReadIntPtr(ValuePtr))).Value;
        v1VType := VarType(v1);
        v2VType := VarType(v2);

      {$IFNDEF CLR}
        if (v1VType = varArray + varByte) or (v2VType = varArray + varByte) then begin
          if (v1VType = varNull) and (v2VType = varNull) then
            Result := 0
          else
          if v1VType = varNull then // (v1VType = varNull) and (v2VType = varArray + varByte)
            Result := 1
          else
          if v2VType = varNull then // (v2VType = varNull) and (v1VType = varArray + varByte)
            Result := -1
          else // (v1VType <> varNull) and (v2VType <> varNull)
          if v1VType <> v2VType then begin
            if v1VType < v2VType then
              Result := 1
            else
              Result := -1;
          end
          else begin
            Assert(v1VType = varArray + varByte, 'Invalid v1.VType');
            Assert(v2VType = varArray + varByte, 'Invalid v2.VType');

            v1VArray := TVarData(v1).VArray;
            v2VArray := TVarData(v2).VArray;
            if (v1VArray = nil) and (v2VArray = nil) then
              Result := 0
            else
            if (v1VArray = nil) and (v2VArray = nil) then
              Result := 0
            else
            if v1VArray = nil then // (v1VArray = nil) and (v2VArray <> nil)
              Result := 1
            else
            if v2VArray = nil then // (v2VArray = nil) and (v1VArray <> nil)
              Result := -1
            else // (v1VArray <> nil) and (v2VArray <> nil)
            if v1VArray.Bounds[0].ElementCount < v2VArray.Bounds[0].ElementCount then
              Result := 1
            else
            if v1VArray.Bounds[0].ElementCount > v2VArray.Bounds[0].ElementCount then 
              Result := - 1
            else begin
              v1VArrayData := v1VArray.Data;
              v2VArrayData := v2VArray.Data;
              if (v1VArrayData = nil) and (v2VArrayData = nil) then
                Result := 0
              else
              if (v1VArrayData = nil) and (v2VArrayData = nil) then
                Result := 0
              else
              if v1VArrayData = nil then // (v1VArrayData = nil) and (v2VArrayData <> nil)
                Result := 1
              else
              if v2VArrayData = nil then // (v2VArrayData = nil) and (v1VArrayData <> nil)
                Result := -1
              else // (v1VArrayData <> nil) and (v2VArrayData <> nil)
                Result := CompareBinValues(v1VArrayData, v1VArray.Bounds[0].ElementCount, v2VArrayData, v2VArray.Bounds[0].ElementCount, Options);
            end;
          end
        end
        else
      {$ENDIF}
        {$IFNDEF VER6P}
          if (v1VType = v2VType) and (v1VType = varDecimal) then begin
            if PInt64(@TVarData(v1).VInteger)^ < PInt64(@TVarData(v2).VInteger)^ then
              Result := 1
            else
            if PInt64(@TVarData(v1).VInteger)^ > PInt64(@TVarData(v2).VInteger)^ then
              Result := -1
            else
              Result := 0;
          end
          else
        {$ENDIF}
          if (v1VType = v2VType) or
             ((((v1VType >= varSmallint) and (v1VType <= varCurrency)) or ((v1VType >= varDecimal) and (v1VType <= varInt64))) and
              (((v2VType >= varSmallint) and (v2VType <= varCurrency)) or ((v2VType >= varDecimal) and (v2VType <= varInt64)))) then begin // Equal VarType or Numbers
            if v1 < v2 then
              Result := 1
            else
            if v1 > v2 then
              Result := -1
            else
              Result := 0;
          end
          else
          if ((v1VType = varString) or (v1VType = varOleStr)) or
             ((v2VType = varString) or (v2VType = varOleStr)) then begin// String
            Result := CompareStrValues(v2, v1, Options)
          end
          else // VarType is different 
          if v1VType < v2VType then
            Result := 1
          else
            Result := -1;
      end;
    {$IFDEF VER6P}
      dtFmtBCD: begin
      {$IFDEF CLR}
        SetLength(Data, SizeOfTBcd);

        Marshal.Copy(IntPtr(Integer(RecBuf) + FieldDesc.Offset), Data, 0, SizeOfTBcd);
        bcd := TBcd.FromBytes(Data);

        Marshal.Copy(ValuePtr, Data, 0, SizeOfTBcd);
        bcdValue := TBcd.FromBytes(Data);
      {$ELSE}
        bcd := PBcd(PChar(RecBuf) + FieldDesc.Offset)^;
        bcdValue := PBcd(ValuePtr)^;
      {$ENDIF}
        Result := BcdCompare(bcdValue, bcd);
      end;
    {$ENDIF}
    else
      Assert(False, 'Unknown ValueType = ' + IntToStr(ValueType));
    end;
  finally
    if FieldBufStatic <> nil then
      Marshal.FreeHGlobal(FieldBufStatic);
  end;
end;

function TMemData.CompareFields(RecBuf1: IntPtr; RecBuf2: IntPtr; SortColumn: TSortColumn): integer;
var
  Options: TLocateExOptions;
begin
  if not SortColumn.CaseSensitive then
    Options := [lxCaseInsensitive]
  else
    Options := [];

  Result := CompareFields(RecBuf1, RecBuf2, SortColumn.FieldDesc, Options);
end;

function TMemData.CompareFields(RecBuf1: IntPtr; RecBuf2: IntPtr; FieldDesc: TFieldDesc; Options: TLocateExOptions = []): integer;
var
  FieldBuf: IntPtr;
  IsBlank1, IsBlank2: boolean;
  DataType: integer;
  NativeBuffer: boolean;
begin
  FieldBuf := nil;
  NativeBuffer := True;
  try
    FieldBuf := GetFieldBuf(RecBuf1, FieldDesc, DataType, IsBlank1, NativeBuffer);
    IsBlank2 := GetNull(FieldDesc.FieldNo, RecBuf2);
    if IsBlank1 and not IsBlank2 then
      Result := -1
    else
    if not IsBlank1 and IsBlank2 then
      Result := 1
    else
    if IsBlank1 and IsBlank2 then
      Result := 0
    else
      Result := CompareFieldValue(FieldBuf, DataType, FieldDesc,
        RecBuf2, Options);
  finally
    if not NativeBuffer then
      Marshal.FreeHGlobal(FieldBuf);
  end;
end;

function TMemData.CompareRecords(RecBuf1, RecBuf2: IntPtr): integer;
var
  SortColumn: TSortColumn;
  i: integer;
  Dir: integer;

  CalcRecBuf1, CalcRecBuf2: IntPtr;
begin
  CalcRecBuf1 := nil;
  CalcRecBuf2 := nil;
  try
    Result := 0;
    for i := 0 to FIndexFields.Count - 1 do begin
      SortColumn := FIndexFields.Items[i];
      if SortColumn.DescendingOrder then
        Dir := -1
      else
        Dir := 1;

      if SortColumn.FieldDesc.FieldDescKind = fdkCalculated then begin
        if CalcRecBuf1 = nil then begin
          CalcRecBuf1 := Marshal.AllocHGlobal(FRecordSize + CalcRecordSize);
          CalcRecBuf2 := Marshal.AllocHGlobal(FRecordSize + CalcRecordSize);
          if Assigned(FOnGetCachedBuffer) then
            FOnGetCachedBuffer(CalcRecBuf1, RecBuf1);
          if Assigned(FOnGetCachedBuffer) then
            FOnGetCachedBuffer(CalcRecBuf2, RecBuf2);
        end;
        Result := CompareFields(CalcRecBuf1, CalcRecBuf2, SortColumn) * Dir;
      end
      else
        Result := CompareFields(RecBuf1, RecBuf2, SortColumn) * Dir;

      if Result <> 0 then
        break;
    end;
  finally
    if CalcRecBuf1 <> nil then
      Marshal.FreeHGlobal(CalcRecBuf1);
    if CalcRecBuf2 <> nil then
      Marshal.FreeHGlobal(CalcRecBuf2);
  end;
end;

procedure TMemData.Exchange(I, J: PItemHeader);
var
  NextToI, PrevToJ: PItemHeader;
begin
  NextToI := I.Next;
  PrevToJ := J.Prev;
  if IntPtr(I.Prev) <> nil then
    I.Prev.Next := J;
  if IntPtr(J.Next) <> nil then
    J.Next.Prev := I;
  J.Prev := I.Prev;
  I.Next := J.Next;
  if NextToI = J then begin
    I.Prev := J;
    J.Next := I;
  end
  else begin
    I.Prev := PrevToJ;
    if IntPtr(PrevToJ) <> nil then
      PrevToJ.Next := I;
    J.Next := NextToI;
    if IntPtr(NextToI) <> nil then
      NextToI.Prev := J;
  end;

  if I = FirstItem then FirstItem := J;
  if J = LastItem then LastItem := I;
end;

procedure TMemData.MoveSortedRecord(Dir: integer);
begin
  if Dir = 0 then
    Exit;
  while True do begin
    if Dir > 0 then begin
      if (IntPtr(CurrentItem.Next) <> nil) and
        (CompareRecords(IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)), IntPtr(Integer(CurrentItem.Next) + sizeof(TItemHeader))) > 0)
      then
        Exchange(CurrentItem, CurrentItem.Next)
      else
        break;
    end
    else begin
      if (IntPtr(CurrentItem.Prev) <> nil) and
        (CompareRecords(IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)), IntPtr(Integer(CurrentItem.Prev) + sizeof(TItemHeader))) < 0)
      then
        Exchange(CurrentItem.Prev, CurrentItem)
      else
        break;
    end;
  end;
end;

procedure TMemData.QuickSort(L, R, P: PItemHeader);
var
  I, J, IP, JP, I1: PItemHeader;
  changeIP, changeJP: boolean;
begin
  repeat
    I := L;
    J := R;
    IP := I;
    JP := J;
    changeIP := False;
    changeJP := False;
    while True do begin
      while (IntPtr(I) <> IntPtr(P)) and (CompareRecords(IntPtr(Integer(I) + sizeof(TItemHeader)), IntPtr(Integer(P) + sizeof(TItemHeader))) < 0) do begin
        I := I.Next;
        if changeIP then
          IP := IP.Next;
        changeIP := not changeIP;
      end;
      while (IntPtr(J) <> IntPtr(P)) and (CompareRecords(IntPtr(Integer(J) + sizeof(TItemHeader)), IntPtr(Integer(P) + sizeof(TItemHeader))) > 0) do begin
        J := J.Prev;
        if changeJP then
          JP := JP.Prev;
        changeJP := not changeJP;
      end;
      if (IntPtr(J.Next) = IntPtr(I)) or
        (IntPtr(I) = IntPtr(J))
      then
        break;

      if CompareRecords(IntPtr(Integer(I) + sizeof(TItemHeader)), IntPtr(Integer(J) + sizeof(TItemHeader))) <> 0 then begin
        Exchange(I, J);
        I1 := I;
        I := J;
        J := I1;
        if L = I then
          L := J
        else
        if L = J then
          L := I;

        if JP = I then
          JP := J
        else
        if JP = J then
          JP := I;

        if IP = I then
          IP := J
        else
        if IP = J then
          IP := I;

        if R = I then
          R:=J
        else
        if R=J then
          R:=I;
      end;

      if IntPtr(I) <> IntPtr(R) then begin
        I := I.Next;
        if changeIP then
          IP := IP.Next;
        changeIP := not changeIP;
      end;
      if IntPtr(J) <> IntPtr(L) then begin
        J := J.Prev;
        if changeJP then
          JP := JP.Prev;
        changeJP := not changeJP;
      end;
    end;
    if IntPtr(L) <> IntPtr(J) then QuickSort(L, J, IP);
    if (IntPtr(I) = IntPtr(J)) and (IntPtr(I) <> IntPtr(R)) then
      I := I.Next;
    L := I;
    P := JP;
  until I = R;
end;

procedure TMemData.SortItems;
begin
  if FIndexFields.Count = 0 then
    Exit;
  if (IntPtr(FirstItem) <> nil) and (IntPtr(LastItem) <> nil) then begin
    QuickSort(FirstItem, LastItem, FirstItem);
    ReorderItems(nil, roFull);
  end;
end;

function TMemData.InsertItem: PItemHeader;
var
  Item: PItemHeader;
begin
  if EOF then begin
    Result := AppendItem;
    Exit;
  end;

  if BOF then
    CurrentItem := FirstItem;

  BlockMan.AllocItem(Item);

  Item.Next := CurrentItem;

  if IntPtr(CurrentItem) <> nil then begin
    Item.Prev := CurrentItem.Prev;
    if IntPtr(CurrentItem.Prev) <> nil then
      CurrentItem.Prev.Next := Item;
    CurrentItem.Prev := Item
  end
  else begin
    Item.Prev := nil;
  end;

  if FirstItem = CurrentItem then
    FirstItem := Item;

  if IntPtr(LastItem) = nil then
    LastItem := Item;

  Result := Item;
end;

function TMemData.AppendItem: PItemHeader;
var
  Item: PItemHeader;
begin
  BlockMan.AllocItem(Item);

  if IntPtr(FirstItem) = nil then begin
    FirstItem := Item;
    Item.Order := 1;
  end
  else begin
    LastItem.Next := Item;
    Item.Order := LastItem.Order + 1;
  end;

  Item.Prev := LastItem;
  Item.Next := nil;
  LastItem := Item;

  Result := Item;
end;

procedure TMemData.DeleteItem(Item: PItemHeader);
begin
  if IntPtr(Item) <> nil then begin
    if Item = FirstItem then
      if Item = LastItem then begin
        CurrentItem := nil;
        FirstItem := nil;
        LastItem := nil;
        FBOF := True;
        FEOF := True;
      end
      else begin
        FirstItem := Item.Next;
        FirstItem.Prev := nil;
        if Item = CurrentItem then
          CurrentItem := FirstItem;
      end
    else
      if Item = LastItem then begin
        LastItem := Item.Prev;
        LastItem.Next := nil;
        if Item = CurrentItem then
          CurrentItem := LastItem;
      end
      else begin
        if Item = CurrentItem then
          CurrentItem := Item.Next;

        if IntPtr(Item.Prev) <> nil then
          Item.Prev.Next := Item.Next;
        if IntPtr(Item.Next) <> nil then
          Item.Next.Prev := Item.Prev;
      end;

    {if IsComplexFields then
      FreeComplexFields(PChar(Item) + sizeof(TItemHeader), True);}

    BlockMan.FreeItem(Item);
  end;
end;

procedure TMemData.InitData;
begin
  FirstItem := nil;
  LastItem := nil;
  CurrentItem := nil;
  Cache := nil;
  LastCacheItem := nil;

  FBOF := True;
  FEOF := True;
  FRecordCount := 0;
  FRecordNoOffset := 0;

  BlockMan.FirstFree := nil;
  Inc(RefreshIteration);
  FRefreshIteration := RefreshIteration;
end;

procedure TMemData.FreeData;
var
  CacheItem: TCacheItem;
  Item: PItemHeader;
  NeedFreeComplex: boolean;

  function HasComplexFields (IncludeStrings : boolean): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to FieldCount - 1 do
      if IsComplexFieldType(Fields[i].DataType) then
        case Fields[i].DataType of
          dtExtString, dtExtWideString, dtExtVarBytes:
            Result := IncludeStrings;
        else
          begin
            Result := True;
            Exit;
          end;
        end;
  end;

begin
  if not StringHeap.SysGetMem then begin
    NeedFreeComplex := HasComplexFields(False);
    StringHeap.Clear;
  end
  else
    NeedFreeComplex := HasComplexFields(True);

  if NeedFreeComplex then begin
  // Free complex fields
    Item := FirstItem;
    while IntPtr(Item) <> nil do begin
      FreeComplexFields(IntPtr(Integer(Item) + sizeof(TItemHeader)), True);
      Item := Item.Next;
    end;
    CacheItem := Cache;
    while CacheItem <> nil do begin
      Item := CacheItem.Item.Rollback;
      if IntPtr(Item) <> nil then
        FreeComplexFields(IntPtr(Integer(Item) + sizeof(TItemHeader)), True);
      CacheItem := CacheItem.Next;
    end;
  end;

// Free cache
  while Cache <> nil do begin
    CacheItem := Cache;
    Cache := Cache.Next;
    CacheItem.Free;
  end;

  StringHeap.Clear;
  BlockMan.FreeAllBlock;

  InitData;
end;

procedure TMemData.ReorderItems(Item: PItemHeader; ReorderOption: TReorderOption);
var
  No: longint;
  Item1: PItemHeader;
begin
  if Length(FRecordNoCache) > 0 then
    SetLength(FRecordNoCache, 0);
  if (IntPtr(Item) <> nil) or (ReorderOption = roFull) and (IntPtr(FirstItem) <> nil)
  then begin
    if ReorderOption = roFull then begin
      Item := FirstItem;
      No := 1;
    end
    else
      if IntPtr(Item.Next) <> nil then
        No := Item.Next.Order
      else
        if IntPtr(Item.Prev) <> nil then
          No := Item.Prev.Order
        else begin
          Item.Order := 1;
          FRecordNoOffset := 0;
        { $IFDEF LINUX
          No := 0; // Kylix 1 anti warning
         $ENDIF}
          Exit;
        end;

    if (ReorderOption = roFull) or (No > (FRecordCount + FRecordNoOffset) div 2)
    then begin
      Item1 := Item.Prev;
      while (IntPtr(Item1) <> nil) and OmitRecord(Item1) do
        Item1 := Item1.Prev;
      if IntPtr(Item1) <> nil then
        No := Item1.Order + 1
      else begin
        No := 1;
        FRecordNoOffset := 0;
      end;

      while IntPtr(Item) <> nil do begin

        if not OmitRecord(Item) then begin
          Item.Order := No;
          Inc(No);
        end
        else
          Item.Order := 0;
        Item := Item.Next;
      end;
    end
    else begin
      Item1 := Item.Next;
      while (IntPtr(Item1) <> nil) and OmitRecord(Item1) do
        Item1 := Item1.Next;
      if IntPtr(Item1) <> nil then begin
        No := Item1.Order - 1;
        if ReorderOption = roInsert then
          Inc(FRecordNoOffset)
        else
          Dec(FRecordNoOffset)
      end
      else begin
        No := FRecordCount;
        FRecordNoOffset := 0;
      end;

      while IntPtr(Item) <> nil do begin
        if not OmitRecord(Item) then begin
          Item.Order := No;
          Dec(No);
        end
        else
          Item.Order := 0;
        Item := Item.Prev;
      end;
    end;

    if ReorderOption = roFull then
      FRecordCount := No - 1;
  end;
end;

{ Fields }

procedure TMemData.Open;
begin
  inherited Open;
end;

procedure TMemData.Reopen;
begin
  inherited;

  if Length(FRecordNoCache) > 0 then
    SetLength(FRecordNoCache, 0);

  // M11255
  if FilterText <> '' then
    FilterUpdated;
  // M11254
  if IndexFields.Count > 0 then
    SortItems;
end;

procedure TMemData.InitFields;
begin
  inherited;

  BlockMan.RecordSize := RecordSize;
  UpdateIndexFields;
end;

procedure TMemData.ClearFields;
begin
  FIndexFields.Clear;

  inherited;
end;

{ Records }

function TMemData.OmitRecord(Item: PItemHeader): boolean;
var
  LocalFilterBuf: IntPtr;
begin
  if IntPtr(Item) <> nil then begin
    if Item.FilterResult = fsNotChecked then begin
      FilterRecBuf := BlockMan.GetRecordPtr(Item);
      LocalFilterBuf := nil;
      try
        Result := FCachedUpdates and not (Item.Status in FFilterItemTypes);
        if not Result then begin
          if (CalcRecordSize > 0) and (Assigned(FFilterMDFunc) or Assigned(FilterExpression) or
            Assigned(FFilterFunc))
          then begin
            LocalFilterBuf := Marshal.AllocHGlobal(RecordSize + CalcRecordSize);
            CopyBuffer(FilterRecBuf, LocalFilterBuf, RecordSize);
            if Assigned(FOnGetCachedBuffer) then
              FOnGetCachedBuffer(LocalFilterBuf);
            FilterRecBuf := LocalFilterBuf;
          end;

          Result := Assigned(FFilterFunc) and not FFilterFunc(FilterRecBuf) or
            Assigned(FFilterMDFunc) and not FFilterMDFunc(FilterRecBuf) or
            Assigned(FilterExpression) and not Eval(FilterExpression);
        end;
      finally
        if LocalFilterBuf <> nil then
          Marshal.FreeHGlobal(LocalFilterBuf);
      end;
      if Result then
        Item.FilterResult := fsOmitted
      else
        Item.FilterResult := fsNotOmitted;
    end
    else
      Result := Item.FilterResult = fsOmitted;
  end
  else
    Result := True; //False;
end;

procedure TMemData.GetRecord(RecBuf: IntPtr);
begin
  if not(EOF or BOF or (IntPtr(CurrentItem) = nil)) then
    if OmitRecord(CurrentItem) then
      GetNextRecord(RecBuf)
    else
      BlockMan.GetRecord(CurrentItem, RecBuf);
end;

procedure TMemData.GetNextRecord(RecBuf: IntPtr);
  procedure OmitRecords;
  begin
    while (IntPtr(CurrentItem) <> nil) and OmitRecord(CurrentItem) do
      CurrentItem := CurrentItem.Next;
  end;
begin
  if not EOF then begin
    if BOF then begin
      FBOF := False;
      CurrentItem := FirstItem;
    end
    else
      if IntPtr(CurrentItem) <> nil then
        CurrentItem := CurrentItem.Next
      else
        CurrentItem := FirstItem;

    OmitRecords;
    if IntPtr(CurrentItem) = nil then
      FEOF := True
    else
      if RecBuf <> nil then
        GetRecord(RecBuf);
  end;
end;

procedure TMemData.GetPriorRecord(RecBuf: IntPtr);
  procedure OmitRecords;
  begin
    while (IntPtr(CurrentItem) <> nil) and OmitRecord(CurrentItem) do
      CurrentItem := CurrentItem.Prev;
  end;
begin
  if not BOF then begin
    if EOF then begin
      FEOF := False;
      CurrentItem := LastItem;
    end
    else
      if IntPtr(CurrentItem) <> nil then
        CurrentItem := CurrentItem.Prev
      else
        CurrentItem := LastItem;

    OmitRecords;
    if IntPtr(CurrentItem) = nil then
      FBOF := True
    else
      if RecBuf <> nil then
        GetRecord(RecBuf);
  end;
end;

procedure TMemData.UpdateCachedBuffer(FItem, LItem: PItemHeader);
var
  Item: PItemHeader;
begin
  if not Assigned(FOnGetCachedBuffer) or (CalcDataSize > 0) then
    Exit;

  if IntPtr(FItem) = nil then
    FItem := FirstItem;
  if IntPtr(LItem) = nil then
    LItem := LastItem;

  Item := FItem;

  while IntPtr(Item) <> nil do begin
    FOnGetCachedBuffer(IntPtr(Integer(Item) + SizeOf(TItemHeader)));
    if Item = LItem then
      Break;
    Item := Item.Next;
  end;
end;

procedure TMemData.PutRecord(RecBuf: IntPtr);
begin
  Assert(IntPtr(CurrentItem) <> nil);
  if Length(FRecordNoCache) > 0 then
    SetLength(FRecordNoCache, 0);
  CurrentItem.FilterResult := fsNotChecked;
  BlockMan.PutRecord(CurrentItem, RecBuf);
end;

procedure TMemData.AddRecord(RecBuf: IntPtr);
var
  OldCurrentItem: PItemHeader;
  MoveDir, i: integer;
  Blob: TBlob;
begin
  OldCurrentItem := CurrentItem;
  CurrentItem := InsertItem;

  PutRecord(RecBuf);

  if HasBlobFields then
    for i := 0 to FieldCount - 1 do
      if IsBlobFieldType(Fields[i].DataType) then begin
        Blob := TBlob(InternalGetObject(Fields[i].FieldNo, RecBuf));
        if Blob <> nil then
          Blob.Commit;
      end;

  if FIndexFields.Count > 0 then begin
    if IntPtr(OldCurrentItem) = nil then
      MoveDir := -1
    else
      MoveDir := CompareRecords(RecBuf, IntPtr(Integer(OldCurrentItem) + sizeof(TItemHeader)));
    MoveSortedRecord(MoveDir);
  end;
  Inc(FRecordCount);
  ReorderItems(CurrentItem, roInsert);
end;

procedure TMemData.InsertRecord(RecBuf: IntPtr);
var
  CacheItem: TCacheItem;
begin
  if not FCachedUpdates then
    InternalAppend(RecBuf);

  AddRecord(RecBuf);

  if FCachedUpdates then begin
    CacheItem := TCacheItem.Create;
    CacheItem.Item := CurrentItem;
    AddCacheItem(CacheItem);

    CurrentItem.Status := isAppended;
    CurrentItem.UpdateResult := urNone;
  end;
end;

procedure TMemData.AppendRecord(RecBuf: IntPtr);
begin
  SetToEnd;
  InsertRecord(RecBuf);
end;

procedure TMemData.UpdateRecord(RecBuf: IntPtr);
var
  CacheItem: TCacheItem;
  Rollback: PItemHeader;
  i: integer;
  Blob: TBlob;
  RollbackRecBuf: IntPtr;
  ItemRecBuf: IntPtr;
  MoveDir: integer;
begin
  Assert(IntPtr(CurrentItem) <> nil);

  if not FCachedUpdates then
    InternalUpdate(RecBuf)
  else begin
    if CurrentItem.Status = isUnmodified then begin
    // add to cache
      CacheItem := TCacheItem.Create;
      CacheItem.Item := CurrentItem;
      AddCacheItem(CacheItem);
    end;

    if (CurrentItem.Status <> isAppended) or (CurrentItem.UpdateResult = urApplied)
    then begin
      CurrentItem.Status := isUpdated;

      if IntPtr(CurrentItem.Rollback) = nil then begin
      // create rollback record
        BlockMan.AllocItem(Rollback);
        CurrentItem.Rollback := Rollback;
        BlockMan.CopyRecord(CurrentItem, Rollback);
        AddRefComplexFields(IntPtr(Integer(Rollback) + sizeof(TItemHeader)));
      end;
      if HasBlobFields then begin
        RollbackRecBuf := IntPtr(Integer(CurrentItem.Rollback) + sizeof(TItemHeader));
        ItemRecBuf := IntPtr(Integer(CurrentItem) + sizeof(TItemHeader));
        for i := 0 to FieldCount - 1 do
          if IsBlobFieldType(Fields[i].DataType) then begin
            Blob := TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(RollbackRecBuf, Fields[i].Offset)));
            if (Blob.Rollback <> nil)
              and (Blob = TBlob(GetGCHandleTarget(Marshal.ReadIntPtr(ItemRecBuf, Fields[i].Offset))))
            then begin
              Marshal.WriteIntPtr(RollbackRecBuf, Fields[i].Offset, Blob.Rollback.GCHandle);
              Blob.Rollback := nil;
              Blob.Release;
            end;
          end;
      end;
    end;
    CurrentItem.UpdateResult := urNone;
  end;

  MoveDir := CompareRecords(RecBuf, IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)));
  PutRecord(RecBuf);
  if FIndexFields.Count > 0 then begin
    MoveSortedRecord(MoveDir);
    ReorderItems(nil, roFull);
  end;
end;

procedure TMemData.RemoveRecord;
var
  PermitDelete: boolean;
begin
  if FCachedUpdates then begin
    PermitDelete := CurrentItem.Status <> isAppended;
    RevertRecord;
  end
  else
    PermitDelete := True;

  if PermitDelete then begin
    if HasComplexFields then
      FreeComplexFields(IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)), True);
    DeleteItem(CurrentItem);
    Dec(FRecordCount); // if PermitDelete = False RecordCount is decreased on RevertRecord
  end;

  ReorderItems(CurrentItem, roDelete);
end;

procedure TMemData.DeleteRecord;
var
  CacheItem: TCacheItem;
  OldCacheItem: TCacheItem;
begin
  if IntPtr(CurrentItem.Next) = nil then
    Fetch;

  if not FCachedUpdates then begin
    InternalDelete;

    RemoveRecord;
  end
  else begin
    if CurrentItem.Status = isUnmodified then begin
    // add to cache
      CacheItem := TCacheItem.Create;
      CacheItem.Item := CurrentItem;
      AddCacheItem(CacheItem);

      CurrentItem.Status := isDeleted;
      CurrentItem.UpdateResult := urNone;
    end
    else
      case CurrentItem.Status of
        isAppended: begin
        // remove record from cache
          CacheItem := Cache;
          OldCacheItem := CacheItem;
          while CacheItem <> nil do begin
            if CacheItem.Item = CurrentItem then begin
              if CacheItem = LastCacheItem then
                if CacheItem = Cache then
                  LastCacheItem := nil
                else
                  LastCacheItem := OldCacheItem;

              if CacheItem = Cache then
                Cache := CacheItem.Next
              else
                OldCacheItem.Next := CacheItem.Next;

              CacheItem.Free;
              break;
            end;

            OldCacheItem := CacheItem;
            CacheItem := CacheItem.Next;
          end;

          if HasComplexFields then
            FreeComplexFields(IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)), True);

          DeleteItem(CurrentItem);
        end;
        isUpdated: begin
        // rollback record
          FreeComplexFields(IntPtr(Integer(CurrentItem) + sizeof(TItemHeader)), True);
          BlockMan.CopyRecord(CurrentItem.Rollback, CurrentItem);
          BlockMan.FreeItem(CurrentItem.Rollback);
          CurrentItem.Rollback := nil;

          CurrentItem.Status := isDeleted;
          CurrentItem.UpdateResult := urNone;
        end;
      end;
      if IntPtr(CurrentItem) <> nil then
        CurrentItem.FilterResult := fsNotChecked;
      Dec(FRecordCount);
      ReorderItems(CurrentItem, roDelete);
  end;
end;

{ Edit }

{ Navigation }

function TMemData.GetBOF: boolean;
begin
  Result := (IntPtr(CurrentItem) = nil) and FBOF;  // WAR
end;

function TMemData.GetEOF: boolean;
begin
  Result := (IntPtr(CurrentItem) = nil) and FEOF;  // WAR
end;

procedure TMemData.SetToBegin;
begin
  CurrentItem := nil; //FirstItem;
  FBOF := True;
  if IntPtr(LastItem) <> nil then
    FEOF := False;
end;

procedure TMemData.SetToEnd;
begin
  CurrentItem := nil; //LastItem;
  FEOF := True;
  if IntPtr(FirstItem) <> nil then
    FBOF := False;
end;

procedure TMemData.PrepareRecNoCache;
var
  i: Integer;
  Item: PItemHeader;
begin
  if Length(FRecordNoCache) > 0 then
    Exit;
  i := 0;
  Item := FirstItem;
  SetLength(FRecordNoCache, RecordCount);
  while IntPtr(Item) <> nil do begin
    if Item.FilterResult = fsNotOmitted then begin
      FRecordNoCache[i] := Item;
      inc(i);
    end;
    Item := Item.Next;
  end;
end;

function TMemData.GetRecordCount: longint;
begin
  Result := FRecordCount;
end;

function TMemData.GetRecordNo: longint;
begin
  if IntPtr(CurrentItem) <> nil then
    Result := CurrentItem.Order + FRecordNoOffset
  else
    Result := 0;
end;

procedure TMemData.SetRecordNo(Value: longint);
var
  Item, CurrItem, LastOrderedItem: PItemHeader;
  ForwardDir: boolean;
begin
  if (IntPtr(FirstItem) <> nil) and (Value > 0) then begin
    if Length(FRecordNoCache) > 0 then begin
      CurrentItem := FRecordNoCache[Value - 1];
      Exit;
    end;

    if IntPtr(CurrentItem) <> nil then
      CurrItem := CurrentItem
    else
      CurrItem := FirstItem;

    LastOrderedItem := LastItem;
    while LastOrderedItem.Order = 0 do begin // if recordset is filtered
      LastOrderedItem := LastOrderedItem.Prev;
      if IntPtr(LastOrderedItem) = nil then
        Exit; // all records are rejected by filter
    end;

    if (Value < Abs(LastOrderedItem.Order + FRecordNoOffset - Value)) and
      (Value < Abs(CurrItem.Order + FRecordNoOffset - Value))
    then begin
    // from first
      Item := FirstItem;
      ForwardDir := True;
    end
    else
      if Abs(LastOrderedItem.Order + FRecordNoOffset - Value) <
        Abs(CurrItem.Order + FRecordNoOffset - Value)
      then begin
      // from
        Item := LastOrderedItem;
        ForwardDir := LastOrderedItem.Order + FRecordNoOffset < Value;
      end
      else begin
      // from current
        Item := CurrItem;
        ForwardDir := CurrItem.Order + FRecordNoOffset < Value;
      end;

    while (IntPtr(Item) <> nil) and (Item.Order + FRecordNoOffset <> Value) do
      if ForwardDir then begin
        if IntPtr(Item.Next) = nil then
          Fetch;
        Item := Item.Next
      end
      else
        Item := Item.Prev;

    if IntPtr(Item) <> nil then
      CurrentItem := Item;
  end;
end;

{ Fetch }

function TMemData.Fetch(FetchBack: boolean = False): boolean;
begin
  Result := False;
end;

procedure TMemData.InitFetchedItems(FetchedItem: IntPtr; NoData, FetchBack: boolean);
var
  Item: IntPtr;
  ItemHeader: PItemHeader {$IFNDEF CLR}absolute Item{$ENDIF};
  NewOrder: Integer;
begin
  Item := FetchedItem;
{$IFDEF CLR}
  ItemHeader := Item;
{$ENDIF}
  if not FetchBack then begin
    NewOrder := 1;
    while (Item = FetchedItem) or ((Item <> nil) and OmitRecord(ItemHeader)) do begin
      ItemHeader := ItemHeader.Prev;
    {$IFDEF CLR}
      Item := ItemHeader;
    {$ENDIF}
    end;
    if Item <> nil then
      NewOrder := ItemHeader.Order + 1;
  end
  else
    NewOrder := ItemHeader.Order;

  Item := FetchedItem;
{$IFDEF CLR}
  ItemHeader := Item;
{$ENDIF}
  while IntPtr(Item) <> nil do begin
    if not OmitRecord(ItemHeader) then begin
      if not (NoData or FetchBack)  then
        Inc(FRecordCount);
      ItemHeader.Order := NewOrder;
      if FetchBack then
        Dec(NewOrder)
      else
        Inc(NewOrder);
    end;
    if FetchBack then
      ItemHeader := ItemHeader.Prev
    else
      ItemHeader := ItemHeader.Next;
  {$IFDEF CLR}
    Item := ItemHeader;
  {$ENDIF}
  end;
end;

{ BookMarks }

procedure TMemData.GetBookmark(Bookmark: PRecBookmark);
begin
  Bookmark.RefreshIteration := FRefreshIteration;
  Bookmark.Item := CurrentItem;
  if IntPtr(CurrentItem) <> nil then
    Bookmark.Order := CurrentItem.Order + FRecordNoOffset
  else
    Bookmark.Order := -1;
end;

procedure TMemData.SetToBookmark(Bookmark: PRecBookmark);
var
  OldCurrentItem: PItemHeader;
begin
  if (Bookmark.RefreshIteration = FRefreshIteration) and
    (IntPtr(Bookmark.Item) <> nil)
  then begin
    OldCurrentItem := CurrentItem;
    try // for freed item
      CurrentItem := Bookmark.Item;
      if CurrentItem.Flag = flUsed then begin
        FBOF := False;
        FEOF := False;
        Exit;
      end
      else
        CurrentItem := OldCurrentItem;
    except
      CurrentItem := OldCurrentItem;
    end;
  end;

// Set by order
  inherited;
end;

function TMemData.BookmarkValid(Bookmark: PRecBookmark): boolean;
begin
  if IntPtr(Bookmark) <> nil then
    Result := (Bookmark.Order <> -1) or (IntPtr(Bookmark.Item) <> nil)
  else
    Result := False;

  if Result and Filtered then 
    Result := not OmitRecord(Bookmark.Item);
end;

function TMemData.CompareBookmarks(Bookmark1, Bookmark2: PRecBookmark): integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
begin
  Result := RetCodes[IntPtr(Bookmark1) = nil, IntPtr(Bookmark2) = nil];
  if Result = 2 then
    if Bookmark1.RefreshIteration = Bookmark2.RefreshIteration then
      if Bookmark1.Item = Bookmark2.Item then begin
        Result := 0;
        Exit;
      end;

// Compare by order
  Result := inherited CompareBookmarks(Bookmark1, Bookmark2);
end;

{ CachedUpdates }

function TMemData.GetUpdateStatus: TItemStatus;
begin
  if IntPtr(CurrentItem) <> nil then
    Result := CurrentItem.Status
  else
    Result := isUnmodified;
end;

function TMemData.GetUpdateResult: TUpdateRecAction;
begin
  if IntPtr(CurrentItem) <> nil then
    Result := CurrentItem.UpdateResult
  else
    Result := urNone;
end;

procedure TMemData.AddCacheItem(CacheItem: TCacheItem);
begin
// add to end cache
  CacheItem.Next := nil;
  if Cache = nil then
    Cache := CacheItem
  else
    LastCacheItem.Next := CacheItem;

  LastCacheItem := CacheItem;
end;

procedure TMemData.SetCacheRecBuf(NewBuf: IntPtr; OldBuf: IntPtr);
begin
  NewCacheRecBuf := NewBuf;
  OldCacheRecBuf := OldBuf;
end;

procedure TMemData.ApplyUpdates;
var
  CacheItem, NextCacheItem, PrevCacheItem: TCacheItem;
  Action: TUpdateRecAction;
  OldCurrentItem: PItemHeader;

  PacketCacheItem: TCacheItem;
  PrevPacketCacheItem: TCacheItem;

  function ValidateCacheItem: boolean;
    { On case of deleting current item from cache via RevertRecord in
      ApplyRecord call. Returns True if CacheItem was deleted. }
  begin
    Result := True;
    if PrevCacheItem <> nil then begin
      if PrevCacheItem.Next = NextCacheItem then begin
        CacheItem := NextCacheItem;
        Result := True;
      end;
    end
    else
      if NextCacheItem <> nil then begin
        if CacheItem.Next <> NextCacheItem then begin
          CacheItem := NextCacheItem;
          Result := False;
        end;
      end
      else
        if Cache = nil then begin
          CacheItem := nil;
          Result := False;
        end;
  end;

  procedure SetAction(Action: TUpdateRecAction);
  var
    Temp: TCacheItem;
  begin
    // Set action for batch of items
    if Action <> urSuspended then begin
      Temp := PacketCacheItem;
      while (Temp <> nil) and (Temp <> CacheItem) do begin
        Temp.Item.UpdateResult := Action;
        Temp := Temp.Next;
      end;
    end;  
    CacheItem.Item.UpdateResult := Action;
  end;

begin
  if FCachedUpdates then begin
    OldCurrentItem := CurrentItem;
    try
      PrevCacheItem := nil;
      PacketCacheItem := nil;
      PrevPacketCacheItem := nil;
      CacheItem := Cache;
      while CacheItem <> nil do
        if CacheItem.Item.UpdateResult <> urApplied then begin
          NextCacheItem := CacheItem.Next;
          try
            CurrentItem := CacheItem.Item; // for refresh on applied
            Action := urFail;
            try
              case CacheItem.Item.Status of
                isAppended: begin
                  BlockMan.GetRecord(CacheItem.Item, NewCacheRecBuf);
                  BlockMan.GetRecord(CacheItem.Item, OldCacheRecBuf);
                  ApplyRecord(ukInsert, Action, CacheItem.Next = nil);
                  BlockMan.PutRecord(CacheItem.Item, NewCacheRecBuf); // for ReturnParams
                end;
                isUpdated: begin
                  BlockMan.GetRecord(CacheItem.Item, NewCacheRecBuf);
                  BlockMan.GetRecord(CacheItem.Item.Rollback, OldCacheRecBuf);
                  ApplyRecord(ukUpdate, Action, CacheItem.Next = nil);
                  BlockMan.PutRecord(CacheItem.Item, NewCacheRecBuf); // for ReturnParams
                end;
                isDeleted: begin
                  BlockMan.GetRecord(CacheItem.Item, NewCacheRecBuf);
                  BlockMan.GetRecord(CacheItem.Item, OldCacheRecBuf);
                  ApplyRecord(ukDelete, Action, CacheItem.Next = nil);
                end;
              else
                Assert(False);
              end;
            finally
              if Active and ValidateCacheItem then begin
                SetAction(Action);
                case Action of
                  urSuspended:
                    if PacketCacheItem = nil then begin
                      PacketCacheItem := CacheItem;
                      PrevPacketCacheItem := PrevCacheItem;
                    end;
                  urRetry:
                    if PacketCacheItem <> nil then begin
                      CacheItem := PacketCacheItem;
                      PrevCacheItem := PrevPacketCacheItem;
                    end;
                else
                  PacketCacheItem := nil;
                  PrevPacketCacheItem := nil;
                end;
                if Action <> urRetry then begin
                  PrevCacheItem := CacheItem;
                  CacheItem := NextCacheItem;
                end;
              end;
            end;
          except
            if CacheItem <> nil then
              OldCurrentItem := CacheItem.Item; // failed item is current
            raise;
          end;
        end
        else
          CacheItem := CacheItem.Next;
    finally
      CurrentItem := OldCurrentItem;
    end;
  end;
end;

procedure TMemData.CommitUpdates;
var
  CacheItem, CacheItem1: TCacheItem;
begin
  if UpdatesPending then
    ApplyUpdates;

  CacheItem := Cache;
  LastCacheItem := nil;
  while CacheItem <> nil do
    if CacheItem.Item.UpdateResult = urApplied then begin
      if IntPtr(CacheItem.Item.Rollback) <> nil then begin
        FreeComplexFields(IntPtr(Integer(CacheItem.Item.Rollback) + SizeOf(TItemHeader)), True);
        BlockMan.FreeItem(CacheItem.Item.Rollback);
        CacheItem.Item.Rollback := nil;
      end;

      if CacheItem.Item.Status = isDeleted then begin
        if HasComplexFields then
          FreeComplexFields(IntPtr(Integer(CacheItem.Item) + sizeof(TItemHeader)), True);

        DeleteItem(CacheItem.Item)
      end
      else begin
        CacheItem.Item.Status := isUnmodified;
        CacheItem.Item.UpdateResult := urNone;
      end;

      CacheItem1 := CacheItem;
      CacheItem := CacheItem.Next;

      if CacheItem1 = Cache then
        Cache := CacheItem;

      if (LastCacheItem <> nil) and (CacheItem1 = LastCacheItem.Next) then
        LastCacheItem.Next := CacheItem;
      CacheItem1.Free;
    end
    else begin
      LastCacheItem := CacheItem;
      CacheItem := CacheItem.Next;
    end;
end;

procedure TMemData.RevertItem(Item: PItemHeader);
begin
  case Item.Status of
    isAppended: begin
      if HasComplexFields then
        FreeComplexFields(IntPtr(Integer(Item) + sizeof(TItemHeader)), True);

      DeleteItem(Item);
      Dec(FRecordCount);
    end;
    isUpdated: begin
      FreeComplexFields(IntPtr(Integer(Item) + sizeof(TItemHeader)), True);
      BlockMan.CopyRecord(Item.Rollback, Item);
      BlockMan.FreeItem(Item.Rollback);
      Item.Rollback := nil;
      Item.Status := isUnmodified;
      Item.UpdateResult := urNone;
      Item.FilterResult := fsNotChecked;
    end;
    isDeleted: begin
      Item.Status := isUnmodified;
      Item.UpdateResult := urNone;
      Item.FilterResult := fsNotChecked;      
      Inc(FRecordCount);
    end;
    isUnmodified: begin
      Item.UpdateResult := urNone;
      Item.FilterResult := fsNotChecked;
    end;        
  end;
end;

procedure TMemData.RevertRecord;
var
  CacheItem: TCacheItem;
  OldCacheItem: TCacheItem;
begin
  if Cache <> nil then begin
    CacheItem := Cache;
    OldCacheItem := CacheItem;
    while (CacheItem <> nil) and not (CacheItem.Item = CurrentItem) do begin
      OldCacheItem := CacheItem;
      CacheItem := CacheItem.Next;
    end;
    if CacheItem <> nil then begin
      if OldCacheItem <> CacheItem then
        OldCacheItem.Next := CacheItem.Next
      else
        Cache := CacheItem.Next;

      RevertItem(CacheItem.Item);
      if CacheItem = LastCacheItem then
        LastCacheItem := OldCacheItem;
      CacheItem.Free;
    end;
  end;
end;

procedure TMemData.CancelUpdates;
var
  CacheItem: TCacheItem;
begin
  if Cache <> nil then begin
    while Cache <> nil do begin
      RevertItem(Cache.Item);
      CacheItem := Cache;
      Cache := Cache.Next;
      CacheItem.Free;
    end;

    LastCacheItem := nil;

    ReorderItems(nil, roFull);
  end;
end;

procedure TMemData.RestoreUpdates;
var
  CacheItem: TCacheItem;
begin
  if FCachedUpdates then begin
    CacheItem := Cache;
    while CacheItem <> nil do begin
      //CacheItem.Item.Status
      CacheItem.Item.UpdateResult := urNone;
      CacheItem := CacheItem.Next;
    end;
  end;
end;

function TMemData.GetUpdatesPending: boolean;
var
  CacheItem: TCacheItem;
begin
  Result := False;
  CacheItem := Cache;
  while (CacheItem <> nil) and not Result do begin
    Result := CacheItem.Item.UpdateResult <> urApplied;
    CacheItem := CacheItem.Next;
  end;
end;

procedure TMemData.GetOldRecord(RecBuf: IntPtr);
begin
  if not(EOF or BOF or (IntPtr(CurrentItem) = nil)) then begin
    if OmitRecord(CurrentItem) then
      GetNextRecord(RecBuf);
    if IntPtr(CurrentItem) <> nil then
      if IntPtr(CurrentItem.Rollback) <> nil then
        BlockMan.GetRecord(CurrentItem.Rollback, RecBuf)
      else
        BlockMan.GetRecord(CurrentItem, RecBuf);
  end;
end;

{ Filter }

procedure TMemData.FilterUpdated;
begin
  ClearItemsOmittedStatus;
  ReorderItems(nil, roFull);
  FEOF := RecordCount = 0; // for correct navigation
end;

procedure TMemData.ClearItemsOmittedStatus;
var
  Item: PItemHeader;
begin
  Item := FirstItem;
  while IntPtr(Item) <> nil do begin
    Item.FilterResult := fsNotChecked;
    Item := Item.Next;
  end;
end;

procedure TMemData.SetFilterItemTypes(Value: TItemTypes);
begin
  if Value <> FilterItemTypes then begin
    inherited;

    ClearItemsOmittedStatus;
    ReorderItems(nil, roFull);
    FEOF := RecordCount = 0; // for correct navigation
  end;
end;

{ TBlockManager }

{$IFDEF CLR}
[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'HeapAlloc')]
function HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD): IntPtr; external;

[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'HeapFree')]
function HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: IntPtr): BOOL; external;

[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'HeapCreate')]
function HeapCreate(flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle; external;

[DllImport(kernel32, CharSet = CharSet.Ansi, SetLastError = True, EntryPoint = 'HeapDestroy')]
function HeapDestroy(hHeap: THandle): BOOL; external;

const
  HEAP_NO_SERIALIZE = 1;
  HEAP_GENERATE_EXCEPTIONS = 4;
{$ENDIF}


constructor TBlockManager.Create;
begin
  inherited;

  DefaultItemCount := 10;  // WAR
end;

destructor TBlockManager.Destroy;
begin
  FreeAllBlock;

  inherited;
end;

procedure TBlockManager.AllocBlock(var Block: PBlockHeader; ItemCount: word);
var
  BlockSize: integer;
begin
  BlockSize := sizeof(TBlockHeader) + ItemCount*(sizeof(TItemHeader) + RecordSize);

{$IFDEF CLR}
  if IntPtr(FHeap) = nil then
    FHeap := HeapCreate(HEAP_GENERATE_EXCEPTIONS + HEAP_NO_SERIALIZE, BlockSize + 100 {overhead}, 0);
  Block := HeapAlloc(FHeap, HEAP_GENERATE_EXCEPTIONS + HEAP_NO_SERIALIZE, BlockSize);
{$ELSE}
  GetMem(Block, BlockSize);
{$ENDIF}

  Block.ItemCount := ItemCount;
  Block.UsedItems := ItemCount;

  Block.Next := FirstBlock;
  Block.Prev := nil;

  //Block.Test := btSign;         // DEBUG

  if IntPtr(FirstBlock) <> nil then
    FirstBlock.Prev := Block;
  FirstBlock := Block;
end;

procedure TBlockManager.FreeBlock(Block: PBlockHeader);
begin
  if Block = FirstBlock then begin
    FirstBlock := Block.Next;
    if IntPtr(FirstBlock) <> nil then
      FirstBlock.Prev := nil;
  end
  else begin
    Block.Prev.Next := Block.Next;
    if IntPtr(Block.Next) <> nil then
      Block.Next.Prev := Block.Prev;
  end;

{$IFDEF CLR}
  HeapFree(FHeap, HEAP_NO_SERIALIZE, Block);
{$ELSE}
  FreeMem(Block, BlockSize);
{$ENDIF}
end;

procedure TBlockManager.FreeAllBlock;
begin
{$IFDEF CLR}
  HeapDestroy(FHeap);
  FHeap := 0;
  FirstBlock := nil;
{$ELSE}
  while IntPtr(FirstBlock) <> nil do
    FreeBlock(FirstBlock);
{$ENDIF}

  FirstFree := nil;
end;

procedure TBlockManager.AddFreeBlock;
var
  Block: PBlockHeader;
  Item: PItemHeader;
  i: word;
begin
  AllocBlock(Block, DefaultItemCount);

  Item := IntPtr(Integer(Block) + sizeof(TBlockHeader));
  for i := 1 to DefaultItemCount do begin
    Item.Prev := nil;
    Item.Next := FirstFree;
    Item.Block := Block;
    Item.Flag := flFree;

    if IntPtr(FirstFree) <> nil then
      FirstFree.Prev := Item;
    FirstFree := Item;

    Item := IntPtr(Integer(Item) + sizeof(TItemHeader) + RecordSize);
  end;
  Block.UsedItems := 0;
end;

procedure TBlockManager.AllocItem(var Item: PItemHeader);
begin
  if IntPtr(FirstFree) = nil then
    AddFreeBlock;

  Item := FirstFree;

  Assert(Item.Flag = flFree);
  Item.Flag := flUsed;

  FirstFree := FirstFree.Next;
  if IntPtr(FirstFree) <> nil then
    FirstFree.Prev := nil;

  Item.Rollback := nil;
  Item.Status := isUnmodified;
  Item.UpdateResult := urNone;
  Item.Order := 0;
  Item.FilterResult := fsNotChecked;

  Item.Block.UsedItems := Item.Block.UsedItems + 1;
end;

procedure TBlockManager.FreeItem(Item: PItemHeader);
var
  Free: PItemHeader;
  i: integer;
begin
  Assert(Item.Flag = flUsed);

  Item.Flag := flFree;

  if Item.Block.UsedItems =  1 then begin
  // Procesing Free List
    Free := IntPtr(Integer(Item.Block) + sizeof(TBlockHeader));
    for i := 1 to Item.Block.ItemCount do begin
      if not(Free = Item) then begin
        Assert(Free.Flag = flFree);

        if Free = FirstFree then begin
          FirstFree := Free.Next;
          if IntPtr(FirstFree) <> nil then
            FirstFree.Prev := nil;
        end
        else begin
          Free.Prev.Next := Free.Next;
          if IntPtr(Free.Next) <> nil then
            Free.Next.Prev := Free.Prev;
        end;
      end;
      Free := IntPtr(Integer(Free) + sizeof(TItemHeader) + RecordSize);
    end;
    FreeBlock(Item.Block);
  end
  else begin
    Item.Prev := nil;
    Item.Next := FirstFree;
    if IntPtr(FirstFree) <> nil then
      FirstFree.Prev := Item;
    FirstFree := Item;
    Item.Block.UsedItems := Item.Block.UsedItems - 1;
  end;
end;

procedure TBlockManager.InitItem(Item: PItemHeader);
begin
  Item.Rollback := nil;
  Item.Status := isUnmodified;
  Item.UpdateResult := urNone;
end;

procedure TBlockManager.PutRecord(Item: PItemHeader; Rec: IntPtr);
begin
  CopyBuffer(Rec, IntPtr(Integer(Item) + sizeof(TItemHeader)), RecordSize)
end;

procedure TBlockManager.GetRecord(Item: PItemHeader; Rec: IntPtr);
begin
  CopyBuffer(IntPtr(Integer(Item) + sizeof(TItemHeader)), Rec, RecordSize)
end;

function TBlockManager.GetRecordPtr(Item: PItemHeader): IntPtr;
begin
  Result := IntPtr(Integer(Item) + sizeof(TItemHeader));
end;

procedure TBlockManager.CopyRecord(ItemSrc: PItemHeader; ItemDest: PItemHeader);
begin
  CopyBuffer(IntPtr(Integer(ItemSrc) + sizeof(TItemHeader)),
    IntPtr(Integer(ItemDest) + sizeof(TItemHeader)), RecordSize);
end;

{ TStringHeap }

{$IFDEF CLR}
function PBlock.GetNext: PBlock;
begin
  Result := Marshal.ReadIntPtr(Ptr, 0);
end;

procedure PBlock.SetNext(Value: PBlock);
begin
  Marshal.WriteIntPtr(Ptr, 0, Value);
end;

class operator PBlock.Implicit(AValue: IntPtr): PBlock;
begin
  Result.Ptr := AValue;
end;

class operator PBlock.Implicit(AValue: PBlock): IntPtr;
begin
  Result := AValue.Ptr;
end;

{$ENDIF}

constructor TStringHeap.Create;
begin
  inherited;

  FRoot := nil;
  FEmpty := True;
  FSysGetMem := False;

{$IFDEF WIN32}
  FUseSysMemSize := not IsMemoryManagerSet;
{$ENDIF}
  FThreadSafety := False;
  FThreadSafetyCS := nil;
end;

destructor TStringHeap.Destroy;
begin
  Clear;
  FThreadSafetyCS.Free;

  inherited;
end;

procedure TStringHeap.SetThreadSafety(const Value: boolean);
begin
  if Value <> FThreadSafety then begin
    FThreadSafety := Value;
    if Value then begin
      Assert(FThreadSafetyCS = nil);
      FThreadSafetyCS := TCriticalSection.Create;
    end
    else begin
      FThreadSafetyCS.Free;
      FThreadSafetyCS := nil;
    end;
  end;
end;

procedure TStringHeap.Clear;
var
  P, Temp: PBlock;
  i: integer;
begin
  if Empty then
    Exit;
  if FThreadSafetyCS <> nil then
    FThreadSafetyCS.Acquire;
  try
    P := FRoot;
    while IntPtr(P) <> nil do begin
      Temp := P;
      P := P.Next;
      Marshal.FreeHGlobal(Temp);
    end;
    FRoot := nil;
    FFree := SizeOf_TStrData;
    for i := Low(FSmallTab) to High(FSmallTab) do
      FSmallTab[i] := nil;
    FEmpty := True;
    FSysGetMem := False;
  finally
    if FThreadSafetyCS <> nil then
      FThreadSafetyCS.Release;
  end;
end;

function TStringHeap.AllocStr(Str: IntPtr; Trim: boolean = false; Len: integer = -1): IntPtr;
var
  EndPtr: IntPtr;
begin
  if Str = nil then
    Result := nil
  else begin
    if Len = -1 then
      Len := StrLen(Str);
    if Trim then begin
      EndPtr := IntPtr(Integer(Str) + Len - 1);
      while (Len > 0) and
      {$IFDEF CLR}
        (Marshal.ReadByte(EndPtr) = Byte(' '))
      {$ELSE}
        (PByte(EndPtr)^ = Byte(' ')) 
      {$ENDIF}
      do begin
        EndPtr := IntPtr(Integer(EndPtr) - 1 {sizeof(AsciiChar)});
        Dec(Len);
      end;
    end;
    Result := NewBuf(Len + 1);
    CopyBuffer(Str, Result, Len);
    Marshal.WriteByte(Result, Len, byte(#0));
  end;
end;

function TStringHeap.AllocWideStr(Str: IntPtr; Trim: boolean = false; Len: integer = -1): IntPtr;
var
  EndPtr: IntPtr;
begin
  if Str = nil then
    Result := nil
  else begin
    if Len = -1 then
      Len := StrLenW(Str);
    if Trim then begin
      EndPtr := IntPtr(Integer(Str) + (Len - 1) * sizeof(WideChar));
      while (Len > 0) and
      {$IFDEF CLR}
        (Marshal.ReadInt16(EndPtr) = SmallInt(' '))
      {$ELSE}
        (PSmallInt(EndPtr)^ = SmallInt(' '))
      {$ENDIF}
      do begin
        EndPtr := IntPtr(Integer(EndPtr) - sizeof(WideChar));
        Dec(Len);
      end;
    end;
    Result := NewBuf((Len + 1) * sizeof(WideChar));
    CopyBuffer(Str, Result, Len * sizeof(WideChar));
    Marshal.WriteInt16(Result, Len * sizeof(WideChar), byte(#0));
  end;
end;

function TStringHeap.ReAllocStr(Str: IntPtr; Trim: boolean = false): IntPtr;
begin
  Result := AllocStr(Str, Trim);
  DisposeBuf(Str);
end;

function TStringHeap.ReAllocWideStr(Str: IntPtr; Trim: boolean = false): IntPtr;
begin
  Result := AllocStr(Str, Trim);
  DisposeBuf(Str);
end;

function TStringHeap.UseSmallTabs(divSize: integer): boolean;
begin
  Result := divSize <= SmallSize div Align;
  // This fix was added 04.04.2006 and rolled back 07.03.2007 because of bug
  // with allocation using memory manager and disposing using StringHeap block of memroy with size 2002 bytes
  // if (not Result) and ((Size - 1) div Align <= SmallSize div Align) then
  //   Result := True;
end;

function TStringHeap.NewBuf(Size: integer): IntPtr;
var
  P: IntPtr;
  Temp: PBlock;
  Idx: integer;
  divSize: integer;
begin
  if Size <= 0 then begin
    Result := nil;
  end
  else begin
    if FThreadSafetyCS <> nil then
      FThreadSafetyCS.Acquire;
    try
      FEmpty := False;
      divSize := (Size + Align - 1) div Align;
      if UseSmallTabs(divSize) then begin
        Result := FSmallTab[divSize];
        if Result <> nil then begin
          FSmallTab[divSize] := Marshal.ReadIntPtr(Result);
          p := IntPtr(Integer(Result) - SizeOf(Word));
          Marshal.WriteInt16(p, Marshal.ReadInt16(p) + 1);
          Exit;
        end;
        Size := divSize * Align;
        if IntPtr(FRoot) = nil then begin
          FRoot := Marshal.AllocHGlobal(SizeOf_TBlock);
          FRoot.Next := nil;
          FFree := SizeOf_TStrData;
        end
        else
        if FFree < Size + SizeOf(Integer) + SizeOf(Word) then begin
          P := IntPtr(Integer(IntPtr(FRoot)) + SizeOf(PBlock) + SizeOf_TStrData - FFree);
          divSize := (FFree - SizeOf(Integer) - SizeOf(Word)) div Align;
          Marshal.WriteInt32(P, divSize * Align);
          P := IntPtr(Integer(P) + SizeOf(Integer));
          Marshal.WriteInt16(P, RefNull);
          P := IntPtr(Integer(P) + SizeOf(Word));
          Idx := divSize;
          Marshal.WriteIntPtr(P, FSmallTab[Idx]);
          FSmallTab[Idx] := P;
          Temp := FRoot;
          FRoot := Marshal.AllocHGlobal(SizeOf_TBlock);
          FRoot.Next := Temp;
          FFree := SizeOf_TStrData;
        end;
        Result := IntPtr(Integer(IntPtr(FRoot)) + SizeOf(PBlock) + SizeOf_TStrData - FFree);
        Marshal.WriteInt32(Result, Size);
        Dec(FFree, Size + SizeOf(Integer) + SizeOf(Word));
        if FFree < SizeOf(Integer) + SizeOf(Word) + Align then begin
          Marshal.WriteInt32(Result, Marshal.ReadInt32(Result) + FFree and not (Align - 1));
          Temp := FRoot;
          FRoot := Marshal.AllocHGlobal(SizeOf_TBlock);
          FRoot.Next := Temp;
          FFree := SizeOf_TStrData;
        end;
        Result := IntPtr(Integer(Result) + SizeOf(Integer));
      end
      else begin
      {$IFDEF WIN32}
        if FUseSysMemSize then
          Result := Marshal.AllocHGlobal(Size + SizeOf(Word))
        else begin
      {$ENDIF}
          Result := Marshal.AllocHGlobal(Size + SizeOf(Word) + SizeOf(Integer));
          Marshal.WriteInt32(Result, Size);
          Result := IntPtr(Integer(Result) + SizeOf(Integer));
      {$IFDEF WIN32}
        end;
      {$ENDIF}
        FSysGetMem := True;
      end;
      Marshal.WriteInt16(Result, RefNull);
      Result := IntPtr(Integer(Result) + SizeOf(Word));
    finally
      if FThreadSafetyCS <> nil then
        FThreadSafetyCS.Release;
    end;
  end;
end;

procedure TStringHeap.DisposeBuf(Buf: IntPtr);
var
  Size: integer;
  PRefCount: IntPtr;
  RefCount: Word;
  Idx: integer;
  divSize: integer;
begin
  if (Buf <> nil) then begin
    if FThreadSafetyCS <> nil then
      FThreadSafetyCS.Acquire;
    try
      PRefCount := IntPtr(Integer(Buf) - SizeOf(Word));
      RefCount := Marshal.ReadInt16(PRefCount);
      Assert(RefCount >= RefNull, 'DisposeBuf failed');
      if RefCount = RefNull then begin
        Marshal.WriteInt16(PRefCount, RefCount - 1);
        Size := Marshal.ReadInt32(IntPtr(Integer(PRefCount) - SizeOf(Integer)));
        divSize := (Size + Align - 1) div Align;
        Assert(divSize <> 0, 'SmallTab in DisposeBuf failed');
        if UseSmallTabs(divSize) then begin
          Idx := divSize;
          Marshal.WriteIntPtr(Buf, FSmallTab[Idx]);
          FSmallTab[Idx] := Buf;
        end
        else
        {$IFDEF WIN32}
          if FUseSysMemSize then
            Marshal.FreeHGlobal(PRefCount)
          else
        {$ENDIF}
            Marshal.FreeHGlobal(IntPtr(Integer(PRefCount) - SizeOf(Integer)));
      end
      else
        Marshal.WriteInt16(PRefCount, RefCount - 1);
    finally
      if FThreadSafetyCS <> nil then
        FThreadSafetyCS.Release;
    end;
  end;
end;

procedure TStringHeap.AddRef(Buf: IntPtr);
var
  PRefCount: IntPtr;
  RefCount: Word;
begin
  if (Buf <> nil) then begin
    PRefCount := IntPtr(Integer(Buf) - SizeOf(Word));
    RefCount := Marshal.ReadInt16(PRefCount);
    Assert(RefCount >= RefNull, 'AddRefStr failed');
    Marshal.WriteInt16(PRefCount, RefCount + 1);
  end;
end;

{ TSharedObject }

constructor TSharedObject.Create;
begin
  inherited;

  AddRef;

{$IFDEF CRDEBUG} Inc(ShareObjectCnt); {$ENDIF}
end;

destructor TSharedObject.Destroy;
begin
  {$IFDEF CRDEBUG} Dec(ShareObjectCnt); {$ENDIF}
  FRefCount := 0;

  inherited;
end;

procedure TSharedObject.CheckValid;
begin
  if FRefCount = 0 then
    raise Exception.Create(SInvalidSharedObject);
end;

procedure TSharedObject.Free;
begin
  if Assigned(Self) then begin
    Assert(FRefCount > 0, ClassName + '.Free RefCount = ' + IntToStr(FRefCount));

    if FRefCount = 1 then begin
      if FGCHandle <> nil then
        FreeGCHandle(FGCHandle);
      inherited Free;
    end
    else
      Dec(FRefCount);
  end;
end;

procedure TSharedObject.AddRef;
begin
  Inc(FRefCount);
end;

procedure TSharedObject.Release;
begin
  Free;
end;

{$IFNDEF CLR}
function TSharedObject.GetHashCode: integer;
begin
  Result := Integer(Self);
end;
{$ENDIF}

function TSharedObject.GetGCHandle: IntPtr;
begin
  if FGCHandle = nil then
    FGCHandle := AllocGCHandle(Self);
  Result := FGCHandle;
end;

{ TPiece }

function NextPiece(Piece: PPieceHeader): PPieceHeader;
begin
  if IntPtr(Piece) <> nil then
    Result := Piece.Next
  else
    Result := nil;
end;

function PieceData(Piece: PPieceHeader): IntPtr;
begin
  if IntPtr(Piece) <> nil then
    Result := IntPtr(Integer(Piece) + sizeof(TPieceHeader))
  else
    Result := nil;
end;

function PieceUsedPtr(Piece: PPieceHeader): IntPtr;
begin
  if IntPtr(Piece) <> nil then
    Result := IntPtr(Integer(Piece) + sizeof(integer) * 2)
  else
    Result := nil;
end;

{ TBlob }

constructor TBlob.Create(IsUnicode: boolean = False);
begin
  inherited Create;

  FIsUnicode := IsUnicode;
  PieceSize := DefaultPieceSize;
  Test := btSign;                    // DEBUG
end;

destructor TBlob.Destroy;
begin
  CheckValid;   // DEBUG
  Test := 0;    // DEBUG
  
  InternalClear;

  if Rollback <> nil then
    Rollback.Free;

  inherited;
end;

procedure TBlob.CheckValid;
begin
  if Test <> btSign then                    // DEBUG
    raise Exception.Create(SInvalidBlob);
end;

procedure TBlob.Clear;
begin
  if FNeedRollback and (Rollback = nil) then
    SaveToRollback;

  InternalClear;

  FModified := True;
end;

{ Pieces }

procedure TBlob.AllocPiece(var Piece: PPieceHeader; Size: cardinal);
begin
  Assert(Size > 0);
  Piece := Marshal.AllocHGlobal(Integer(sizeof(TPieceHeader)) + Integer(Size));
  Piece.Blob := 0;
  Piece.Size := Size;
  Piece.Used := 0;
  Piece.Prev := nil;
  Piece.Next := nil;
end;

procedure TBlob.ReallocPiece(var Piece: PPieceHeader; Size: cardinal);
var
  MemSize: integer;
begin
  if Size = 0 then begin
    FreePiece(Piece);
    Piece := nil;
  end
  else
    if Size <> Piece.Size then begin
      MemSize := Integer(sizeof(TPieceHeader)) + Integer(Size);
      Piece := Marshal.ReAllocHGlobal(Piece, IntPtr(MemSize));
      Piece.Size := Size;
      if Piece.Used > Size then
        Piece.Used := Size;
      if Piece.Blob <> 0 then begin
        if IntPtr(Piece.Prev) <> nil then
          Piece.Prev.Next := Piece
        else
          FFirstPiece := Piece;

        if IntPtr(Piece.Next) <> nil then
          Piece.Next.Prev := Piece;
      end;
    end;
end;

procedure TBlob.FreePiece(Piece: PPieceHeader);
begin
  if Piece.Blob <> 0 then
    DeletePiece(Piece);

  Marshal.FreeHGlobal(Piece);
end;

procedure TBlob.AppendPiece(Piece: PPieceHeader);
var
  Last: PPieceHeader;
begin
  Piece.Blob := Self.GetHashCode;
  Piece.Next := nil;
  if IntPtr(FFirstPiece) = nil then begin
    Piece.Prev := nil;
    FFirstPiece := Piece;
  end
  else begin
    Last := FFirstPiece;
    while IntPtr(Last.Next) <> nil do
      Last := Last.Next;
    Last.Next := Piece;
    Piece.Prev := Last;
  end;
end;

procedure TBlob.DeletePiece(Piece: PPieceHeader);
begin
  Assert(Piece.Blob = Self.GetHashCode);

  if FFirstPiece = Piece then begin
    FFirstPiece := Piece.Next;
    if IntPtr(FFirstPiece) <> nil then
      FFirstPiece.Prev := nil;
  end
  else
  begin
    Piece.Prev.Next := Piece.Next;
    if IntPtr(Piece.Next) <> nil then
      Piece.Next.Prev := Piece.Prev;
  end;

  Piece.Blob := 0;
end;

procedure TBlob.CompressPiece(var Piece: PPieceHeader);
begin
  if Piece.Used < Piece.Size then
    ReallocPiece(Piece, Piece.Used);
end;

function TBlob.FirstPiece: PPieceHeader;
begin
  Result := FFirstPiece;
end;

procedure TBlob.CheckValue;
begin
end;

function TBlob.Read(Position: cardinal; Count: cardinal; Dest: IntPtr): cardinal;
var
  Piece: PPieceHeader;
  Pos, { shift from Blob begin }
  Shift, { for read, in Piece }
  ReadCount, { all }
  MoveSize: cardinal; { in Piece }
begin
  CheckValid;   // DEBUG

  CheckValue;

  Result := 0;

  if (IntPtr(FFirstPiece) = nil) or (Position > Size) then
    Exit;

  if Count = 0 then
    Count := Size;

  if Position + Count > Size then
    Count := Size - Position;

  Piece := FFirstPiece;
  ReadCount := 0;
  Pos := 0;
  while (IntPtr(Piece) <> nil) and (Pos < (Position + Count)) do begin
    if Pos + Piece.Used > Position then begin
      if Position > Pos then
        Shift := Position - Pos
      else
        Shift := 0;

      if (Pos + Piece.Used) > (Position + Count) then
        MoveSize := (Position + Count) - (Pos + Shift)
      else
        MoveSize := Piece.Used - Shift;

      CopyBuffer(IntPtr(Integer(Piece) + sizeof(TPieceHeader) + Integer(Shift)),
        IntPtr(Integer(Dest) + Integer(ReadCount)), MoveSize);
      Inc(ReadCount, MoveSize);
    end;
    Inc(Pos, Piece.Used);
    Piece := Piece.Next;
  end;
  Result := ReadCount;
end;

{ similar to Read }

procedure TBlob.Write(Position: cardinal; Count: cardinal; Source: IntPtr);
var
  Piece: PPieceHeader;
  Pos, { shift from Blob begin }
  Shift, { for write, in Piece }
  WriteCount, { all }
  MoveSize: cardinal; { in Piece }
begin
  CheckValid;   // DEBUG

  if FNeedRollback and (Rollback = nil) then
    SaveToRollback;

  if (Position > Size) then
    Position := Size;

  Piece := FFirstPiece;
  WriteCount := 0;
  Pos := 0;
  while (Pos < (Position + Count)) do begin
    if IntPtr(Piece) = nil then begin
      if Count > PieceSize then
        AllocPiece(Piece, PieceSize)
      else
        AllocPiece(Piece, Count);
      AppendPiece(Piece);
    end;

    if Pos + Piece.Size > Position then begin
      if Position > Pos then
        Shift := Position - Pos
      else
        Shift := 0;

      if (Pos + Piece.Size) > (Position + Count) then
        MoveSize := (Position + Count) - (Pos + Shift)
      else
        MoveSize := Piece.Size - Shift;

      CopyBuffer(IntPtr(Integer(Source) + Integer(WriteCount)),
        IntPtr(Integer(Piece) + sizeof(TPieceHeader) + Integer(Shift)), MoveSize);
      Inc(WriteCount, MoveSize);

      Assert(Shift <= Piece.Used);
      if (Shift + MoveSize) > Piece.Used then
        Piece.Used := Shift + MoveSize;
    end;
    Inc(Pos, Piece.Used);
    Piece := Piece.Next;
  end;

  FModified := True;
end;

procedure TBlob.Truncate(NewSize: cardinal);
var
  Piece: PPieceHeader;
  Size: cardinal;
begin
  if FNeedRollback and (Rollback = nil) then
    SaveToRollback;

  if NewSize = 0 then
    Clear
  else begin
    Size := 0;
    Piece := FirstPiece;
    while IntPtr(Piece) <> nil do begin
      if Size + Piece.Used > NewSize then
        Piece.Used := NewSize - Size;
      Inc(Size, Piece.Used);
      Piece := Piece.Next;
    end;
  end;

  FModified := True;
end;

procedure TBlob.Compress;
var
  Piece: PPieceHeader;
  NextPiece: PPieceHeader;
begin
  Piece := FirstPiece;
  while IntPtr(Piece) <> nil do begin
    NextPiece := Piece.Next;
    CompressPiece(Piece);
    Piece := NextPiece;
  end;
end;

procedure TBlob.Defrag; // Move all data to first piece
var
  pc: IntPtr;
  Piece: PPieceHeader;
  NextPiece: PPieceHeader;
begin
  if IntPtr(FirstPiece) = nil then
    Exit; // Is empty

  ReallocPiece(FFirstPiece, GetDataSize);
  pc := IntPtr(Integer(FFirstPiece) + sizeof(TPieceHeader) + Integer(FFirstPiece.Used));

  Piece := FFirstPiece.Next;
  while IntPtr(Piece) <> nil do begin
    CopyBuffer(IntPtr(Integer(Piece) + sizeof(TPieceHeader)), pc, Piece.Used);
    pc := IntPtr(Integer(pc) + Integer(Piece.Used));
    FFirstPiece.Used := FFirstPiece.Used + Piece.Used;

    NextPiece := Piece.Next;
    FreePiece(Piece);
    Piece := NextPiece;
  end;
end;

{ Stream/File }

procedure TBlob.LoadFromStream(Stream: TStream);
var
  Piece: PPieceHeader;
  Remainder: cardinal;
  BufLen: cardinal;
{$IFDEF CLR}
  Buffer: TBytes;
{$ENDIF}
begin
  Clear;

  Stream.Seek(0, soFromBeginning);

  Remainder := Stream.Size;
  while Remainder > 0 do begin
    if Remainder > PieceSize then
      BufLen := PieceSize
    else
      BufLen := Remainder;

    AllocPiece(Piece, BufLen);
  {$IFDEF CLR}
    SetLength(Buffer, BufLen);
    Stream.Read(Buffer{$IFNDEF CLR}[0]{$ENDIF}, BufLen);
    Marshal.Copy(Buffer, 0, IntPtr(Integer(Piece) + Sizeof(TPieceHeader)), BufLen);
  {$ELSE}
    Stream.Read(IntPtr(Integer(Piece) + Sizeof(TPieceHeader))^, BufLen);
  {$ENDIF}
    Piece.Used := BufLen;
    AppendPiece(Piece);

    Dec(Remainder, BufLen);
  end;

  FModified := True;
end;

procedure TBlob.SaveToStream(Stream: TStream);
var
  Piece: PPieceHeader;
  BufLen: cardinal;
{$IFDEF CLR}
  Buffer: TBytes;
{$ENDIF}
begin
  Stream.Size := 0;

  Piece := FirstPiece;

  while IntPtr(Piece) <> nil do begin
    BufLen := Piece.Used;

  {$IFDEF CLR}
    SetLength(Buffer, BufLen);
    Marshal.Copy(IntPtr(Integer(Piece) + Sizeof(TPieceHeader)), Buffer, 0, BufLen);
    Stream.Write(Buffer{$IFNDEF CLR}[0]{$ENDIF}, BufLen);
  {$ELSE}
    Stream.Write(IntPtr(Integer(Piece) + Sizeof(TPieceHeader))^, BufLen);
  {$ENDIF}

    Piece := Piece.Next;
  end;
end;

procedure TBlob.LoadFromFile(const FileName: string);
var
  Stream:TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TBlob.SaveToFile(const FileName: string);
var
  Stream:TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TBlob.Assign(Source: TBlob);
const
  BufSize = 65536;
var
  Buf: IntPtr;
  Pos: cardinal;
  Size: cardinal;
begin
  Clear;

  Pos := 0;
  Buf := Marshal.AllocHGlobal(BufSize);
  try
    repeat
      Size := Source.Read(Pos, BufSize, Buf);
      if Size > 0 then begin
        Write(Pos, Size, Buf);
        Inc(Pos, Size);
      end;
    until Size = 0;
  finally
    Marshal.FreeHGlobal(Buf);
  end;
end;

{ Cached }

procedure TBlob.CheckCached;
begin
  if not FNeedRollback then
    raise Exception.Create(SBlobMustBeCached);
end;

procedure TBlob.SaveToRollback;
var
  Piece: PPieceHeader;
  CSize: Longint;
begin
  CheckCached;

  Rollback := TBlob.Create;
  Rollback.FIsUnicode := FIsUnicode;
  Rollback.FModified := FModified;

  if IntPtr(FFirstPiece) <> nil then begin
    // make copy of data
    CSize := Size;
    AllocPiece(Piece, CSize);
    Piece.used := CSize;
    Read(0, CSize, IntPtr(Integer(Piece) + sizeof(TPieceHeader)));

    Rollback.FFirstPiece := FFirstPiece;
    FFirstPiece := nil;
    AppendPiece(Piece);
  end;
end;

procedure TBlob.EnableRollback;
begin
  {if FNeedRollback then
    raise Exception.Create(SCachedAlreadyEnabled);}

  FNeedRollback := True;
end;

procedure TBlob.Commit;
begin
  //CheckCached;

  if Rollback <> nil then begin
    Rollback.Free;
    Rollback := nil;
  end;
end;

procedure TBlob.Cancel;
var
  Piece: PPieceHeader;
begin
  //CheckCached;

  if Rollback <> nil then begin
    Piece := Rollback.FFirstPiece;
    Rollback.FFirstPiece := FFirstPiece;
    FFirstPiece := Piece;
    FModified := Rollback.FModified; 

    Rollback.Free;
    Rollback := nil;
  end;
end;

function TBlob.CanRollback: boolean;
begin
  Result := Rollback <> nil;
end;

function TBlob.GetDataSize: cardinal; // sum of pieces.used
var
  Piece: PPieceHeader;
begin
  Result := 0;
  Piece := FFirstPiece;
  while IntPtr(Piece) <> nil do begin
    Inc(Result, Piece.Used);
    Piece := Piece.Next;
  end;
end;

function TBlob.GetSize: cardinal;
begin
  Result := GetDataSize;
end;

procedure TBlob.SetSize(Value: cardinal);
var
  Piece: PPieceHeader;
  OldSize: cardinal;
begin
  OldSize := Size;
  if OldSize > Value then
    Truncate(Value)
  else
    if OldSize < Value then begin
      AllocPiece(Piece, Value - OldSize);
      Piece.Used := Value - OldSize;
      FillChar(IntPtr(Integer(Piece) + Sizeof(TPieceHeader)), Value - OldSize, 0);
      AppendPiece(Piece);
    end;
end;

procedure TBlob.SetIsUnicode(Value: boolean);
begin
  if Value = IsUnicode then
    Exit;

  if Size > 0 then
    DataError(SCannotChangeIsUnicode);

  FIsUnicode := Value;
end;

procedure TBlob.InternalClear;
var
  Piece: PPieceHeader;
begin
  while IntPtr(FFirstPiece) <> nil do begin
    Piece := FFirstPiece;
    FFirstPiece := FFirstPiece.Next;
    Marshal.FreeHGlobal(Piece);
  end;
end;

function TBlob.TranslatePosition(Position: integer): integer; // Ansi to Unicode
var
  Piece: PPieceHeader;
  CurPosAnsi, CurPosUni, i: integer;
  p: IntPtr;
  w: WideString;
  s: string;
begin
  Assert(FIsUnicode);

  if {$IFNDEF CLR}not SysLocale.FarEast{$ELSE}(LeadBytes = []){$ENDIF} or (Position = 0) then begin
    Result := Position * 2;
    Exit;
  end;

  CurPosAnsi := 0;
  CurPosUni := 0;
  Piece := FFirstPiece;
  while IntPtr(Piece) <> nil do begin
    p := IntPtr(Integer(Piece) + Sizeof(TPieceHeader));
    for i := 0 to Cardinal((Piece.Used div 2) - 1) do begin
      w := Marshal.PtrToStringUni(IntPtr(Integer(p) + i * 2), 1);
      s := w;
      Inc(CurPosUni, 2);
      Inc(CurPosAnsi, Length(s));
      if CurPosAnsi = Position then begin
        Result := CurPosUni;
        Exit;
      end;
      if CurPosAnsi > Position then
        raise Exception.Create(SInvalidBlobPosition);
    end;
    Piece := Piece.Next;
  end;
  raise Exception.Create(SInvalidBlobPosition);
end;

function TBlob.GetSizeAnsi: integer;
var
  Piece: PPieceHeader;
  i: integer;
  p: IntPtr;
  w: WideString;
  s: string;
begin
  Assert(FIsUnicode);

  if {$IFNDEF CLR}not SysLocale.FarEast{$ELSE}(LeadBytes = []){$ENDIF} then begin
    Result := Cardinal(Size div 2);
    Exit;
  end;

  Result := 0;
  Piece := FFirstPiece;
  while IntPtr(Piece) <> nil do begin
    p := IntPtr(Integer(Piece) + Sizeof(TPieceHeader));
    for i := 0 to Cardinal((Piece.Used div 2) - 1) do begin
      w := Marshal.PtrToStringUni(IntPtr(Integer(p) + i * 2), 1);
      s := w;
      Inc(Result, Length(s));
    end;
    Piece := Piece.Next;
  end;
end;

function TBlob.GetAsString: string;
var
  Buffer: TBytes;
  Handle: IntPtr;
begin
  SetLength(Buffer, Size);
  Handle := AllocGCHandle(Buffer, True);
  try
    Read(0, 0, GetAddrOfPinnedObject(Handle));
  finally
    FreeGCHandle(Handle);
  end;
  if FIsUnicode then
    Result := Encoding.Unicode.GetString(Buffer, 0, Size)
  else
    Result := Encoding.Default.GetString(Buffer, 0, Size);
end;

procedure TBlob.SetAsString(Value: string);
var
  Ws: WideString;
  Buffer: IntPtr;
  Size: cardinal;
begin
  Clear;
  if FIsUnicode then begin
    Ws := Value;
    Buffer := Marshal.StringToHGlobalUni(Ws);
    Size := (Length(Value) shl 1);
  end
  else begin
    Buffer := Marshal.StringToHGlobalAnsi(Value);
    Size := Length(Value);
  end;
  try
    Write(0, Size, Buffer);
  finally
    Marshal.FreeCoTaskMem(Buffer);
  end;
end;

function TBlob.GetAsWideString: WideString;
var
  Buffer: TBytes;
  Handle: IntPtr;
  CachedSize: integer; // performance optimization
begin
  CachedSize := Size;
  SetLength(Buffer, CachedSize);
  Handle := AllocGCHandle(Buffer, True);
  try
    Read(0, 0, GetAddrOfPinnedObject(Handle));
  finally
    FreeGCHandle(Handle);
  end;
  if FIsUnicode then begin
    Assert(CachedSize mod 2 = 0); // WideString must have even Size
    Result := Encoding.Unicode.{$IFDEF CLR}GetString{$ELSE}GetWideString{$ENDIF}(Buffer);
  end
  else
    Result := Encoding.Default.GetString(Buffer);
end;

procedure TBlob.SetAsWideString(Value: WideString);
{$IFDEF WIN32}
var
  s: string;
{$ENDIF}
begin
{$IFDEF CLR}
  SetAsString(Value);
{$ENDIF}
{$IFDEF WIN32}
  Clear;
  if not FIsUnicode then begin
    s := Value;
    Write(0, Length(s), PChar(s));
  end
  else
    Write(0, Length(Value) shl 1, PWideChar(Value));
{$ENDIF}
end;

procedure TBlob.AddCR;
begin
  if FIsUnicode then
    AddCRUnicode
  else
    AddCRString;

  FModified := True;
end;

procedure TBlob.RemoveCR;
begin
  if FIsUnicode then
    RemoveCRUnicode
  else
    RemoveCRString;

  FModified := True;
end;

procedure TBlob.AddCRString;
var
  SourcePiece: PPieceHeader;
  DestPiece: PPieceHeader;
  LastPiece: PPieceHeader;
  FirstPiece: PPieceHeader;
  TempPiece: PPieceHeader;

  Source: IntPtr;
  SourceStart: IntPtr;
  Dest: IntPtr;
  DestEnd: IntPtr;
  SourceEnd: IntPtr;

  Shift: cardinal;
  Used: cardinal;
  w: word;
  b: byte;
  c: byte;

  procedure AllocDestPiece;
  var
    AUsed, AUsed2: cardinal;
  begin
    AUsed := Used + Cardinal(Integer(SourceStart)) - Cardinal(Integer(Source));
    if Dest <> nil then
      DestPiece.Used := Cardinal(DestPiece.Size) - 1 + Cardinal(Integer(Dest))- Cardinal(Integer(DestEnd));
    if AUsed < PieceSize div 2 then begin
      AUsed2 := AUsed * 2; //temporary for Update 7.1
      AllocPiece(DestPiece, AUsed2)
    end
    else
      AllocPiece(DestPiece, PieceSize);
    Dest := IntPtr(Integer(DestPiece) + SizeOf(TPieceHeader));
    DestEnd := IntPtr(Integer(Dest) + Integer(DestPiece.Size) - 1);
    DestPiece.Blob := Self.GetHashCode;
    DestPiece.Prev := LastPiece;
    if IntPtr(LastPiece) <> nil then
      LastPiece.Next := DestPiece;
    LastPiece := DestPiece;
    if IntPtr(FirstPiece) = nil then
      FirstPiece := DestPiece;
  end;

begin
  CheckValid;   // DEBUG

  CheckValue;

  if (IntPtr(FFirstPiece) = nil) then
    Exit;

  SourcePiece := FFirstPiece;
  FirstPiece := nil;
  LastPiece := nil;
  DestPiece := nil;
  Dest := nil;
  DestEnd := nil;
  Shift := 0;
  Used := Size;

  while (IntPtr(SourcePiece) <> nil) do begin
    if SourcePiece.Used > Shift then begin
      SourceStart := IntPtr(Integer(SourcePiece) + SizeOf(TPieceHeader) + Integer(Shift));
      Source := SourceStart;
      SourceEnd := IntPtr(Integer(Source) + Integer(SourcePiece.Used) - 1 - Integer(Shift));

      while Integer(Source) < Integer(SourceEnd) do begin
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        w := Marshal.ReadInt16(Source);
        if w = CRLF then begin
          Marshal.WriteInt16(Dest, w);
          Source := IntPtr(Integer(Source) + 2);
          Dest := IntPtr(Integer(Dest) + 2);
        end
        else begin
          b := Byte(w);
          if b = LF then begin
            Marshal.WriteInt16(Dest, CRLF);
            Source := IntPtr(Integer(Source) + 1);
            Dest := IntPtr(Integer(Dest) + 2);
          end
          else begin
            Marshal.WriteByte(Dest, b);
            Source := IntPtr(Integer(Source) + 1);
            Dest := IntPtr(Integer(Dest) + 1);
          end;
        end;
      end;

      if Source = SourceEnd then begin
        c := Marshal.ReadByte(Source);
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        Shift := Ord(
          ((c = 13)
            and
            (((IntPtr(SourcePiece.Next) <> nil)
            and
            (
              Marshal.ReadByte(
                IntPtr(Integer(IntPtr(SourcePiece.Next)) + SizeOf(TPieceHeader))
              ) = 10
            ))
            or
            (IntPtr(SourcePiece.Next) = nil)))
          or
          (c = 10)
        );
        if (Shift = 1) then begin
          Marshal.WriteInt16(Dest, CRLF);
          Dest := IntPtr(Integer(Dest) + 2);
        end
        else begin
          Marshal.WriteByte(Dest, c);
          Dest := IntPtr(Integer(Dest) + 1);
        end;
      end else
        Shift := 0;
    end;
    Dec(Used, SourcePiece.Used);
    TempPiece := SourcePiece;
    SourcePiece := SourcePiece.Next;
    Marshal.FreeHGlobal(TempPiece);
  end;
  if Dest <> nil then
    DestPiece.Used := DestPiece.Size - 1 + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
  FFirstPiece := FirstPiece;
end;

procedure TBlob.RemoveCRString;
var
  SourcePiece: PPieceHeader;
  DestPiece: PPieceHeader;
  LastPiece: PPieceHeader;
  FirstPiece: PPieceHeader;
  TempPiece: PPieceHeader;

  SourceStart: IntPtr;
  Source: IntPtr;
  Dest: IntPtr;
  DestEnd: IntPtr;
  SourceEnd: IntPtr;

  Shift: cardinal;
  Used: cardinal;
  w: word;
  c: byte;

  procedure AllocDestPiece;
  var
    AUsed: cardinal;
  begin
    AUsed := Used + Cardinal(Integer(SourceStart)) - Cardinal(Integer(Source));
    if Dest <> nil then
      DestPiece.Used := DestPiece.Size + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
    if AUsed < PieceSize then
      AllocPiece(DestPiece, AUsed)
    else
      AllocPiece(DestPiece, PieceSize);
    Dest := IntPtr(Integer(IntPtr(DestPiece)) + SizeOf(TPieceHeader));
    DestEnd := IntPtr(Integer(Dest) + Integer(DestPiece.Size));
    DestPiece.Blob := Self.GetHashCode;
    DestPiece.Prev := LastPiece;
    if IntPtr(LastPiece) <> nil then
      LastPiece.Next := DestPiece;
    LastPiece := DestPiece;
    if IntPtr(FirstPiece) = nil then
      FirstPiece := DestPiece;
  end;

begin
  CheckValid;   // DEBUG

  CheckValue;

  if (IntPtr(FFirstPiece) = nil) then
    Exit;

  SourcePiece := FFirstPiece;
  FirstPiece := nil;
  LastPiece := nil;
  DestPiece := nil;
  Dest := nil;
  DestEnd := nil;
  Shift := 0;
  Used := Size;

  while (IntPtr(SourcePiece) <> nil) do begin
    if SourcePiece.Used > Shift then begin
      SourceStart := IntPtr(Integer(SourcePiece) + SizeOf(TPieceHeader) + Integer(Shift));
      Source := SourceStart;
      SourceEnd := IntPtr(Integer(Source) + Integer(SourcePiece.Used) - 1 - Integer(Shift));

      while Integer(Source) < Integer(SourceEnd) do begin
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        w := Marshal.ReadInt16(Source);
        if w = CRLF then begin
          Marshal.WriteByte(Dest, LF);
          Source := IntPtr(Integer(Source) + 2);
          Dest := IntPtr(Integer(Dest) + 1);
        end
        else
        begin
          Marshal.WriteByte(Dest, Byte(w));
          Source := IntPtr(Integer(Source) + 1);
          Dest := IntPtr(Integer(Dest) + 1);
        end;
      end;

      if Source = SourceEnd then begin
        c := Marshal.ReadByte(Source);
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        Shift := Ord((c = 13) and (IntPtr(SourcePiece.Next) <> nil)
          and
          (
            Marshal.ReadByte(
              IntPtr(Integer(IntPtr(SourcePiece.Next)) + SizeOf(TPieceHeader))
            ) = 10)
          );
        if Shift = 1 then
          c := 10;
        Marshal.WriteByte(Dest, c);
        Dest := IntPtr(Integer(Dest) + 1);
      end else
        Shift := 0;
    end;
    Dec(Used, SourcePiece.Used);
    TempPiece := SourcePiece;
    SourcePiece := SourcePiece.Next;
    Marshal.FreeHGlobal(TempPiece);
  end;
  if Dest <> nil then
    DestPiece.Used := DestPiece.Size + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
  FFirstPiece := FirstPiece;
end;

procedure TBlob.AddCRUnicode;
var
  SourcePiece: PPieceHeader;
  DestPiece: PPieceHeader;
  LastPiece: PPieceHeader;
  FirstPiece: PPieceHeader;
  TempPiece: PPieceHeader;

  Source: IntPtr;
  SourceStart: IntPtr;
  Dest: IntPtr;
  DestEnd: IntPtr;
  SourceEnd: IntPtr;

  Shift: cardinal; //bytes
  Used: cardinal; //bytes
  w: LongWord;
  b: Word;
  c: Word;
  procedure AllocDestPiece;
  var
    AUsed, AUsed2: cardinal;
  begin
    AUsed := Used + Cardinal(Integer(SourceStart)) - Cardinal(Integer(Source));
    if Dest <> nil then
      DestPiece.Used := DestPiece.Size - sizeof(WideChar) + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
    if AUsed < PieceSize div 2 then begin
      AUsed2 := AUsed * 2; //temporary for Update 7.1
      AllocPiece(DestPiece, AUsed2)
    end
    else
      AllocPiece(DestPiece, PieceSize);
    Dest := IntPtr(Integer(DestPiece) + SizeOf(TPieceHeader));
    DestEnd := IntPtr(Integer(Dest) + Integer(DestPiece.Size) - sizeof(WideChar));
    DestPiece.Blob := Self.GetHashCode;
    DestPiece.Prev := LastPiece;
    if IntPtr(LastPiece) <> nil then
      LastPiece.Next := DestPiece;
    LastPiece := DestPiece;
    if IntPtr(FirstPiece) = nil then
      FirstPiece := DestPiece;
  end;

begin
  CheckValid;   // DEBUG

  CheckValue;

  if (IntPtr(FFirstPiece) = nil) then
    Exit;

  SourcePiece := FFirstPiece;
  FirstPiece := nil;
  LastPiece := nil;
  DestPiece := nil;
  Dest := nil;
  DestEnd := nil;
  Shift := 0;
  Used := Size;

  while (IntPtr(SourcePiece) <> nil) do begin
    if SourcePiece.Used > Shift then begin
      SourceStart := IntPtr(Integer(SourcePiece) + SizeOf(TPieceHeader) + Integer(Shift));
      Source := SourceStart;
      SourceEnd := IntPtr(Integer(Source) + Integer(SourcePiece.Used) - sizeof(WideChar) - Integer(Shift));

      while Integer(Source) < Integer(SourceEnd) do begin
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        w := Marshal.ReadInt32(Source);
        if w = CRLF_UTF16 then begin
          Marshal.WriteInt32(Dest, w);
          Source := IntPtr(Integer(Source) + 4);
          Dest := IntPtr(Integer(Dest) + 4);
        end
        else begin
          b := Word(w);
          if b = LF_UTF16 then begin
            Marshal.WriteInt32(Dest, CRLF_UTF16);
            Source := IntPtr(Integer(Source) + 2);
            Dest := IntPtr(Integer(Dest) + 4);
          end
          else begin
            Marshal.WriteInt16(Dest, b);
            Source := IntPtr(Integer(Source) + 2);
            Dest := IntPtr(Integer(Dest) + 2);
          end;
        end;
      end;

      if Source = SourceEnd then begin
        c := Marshal.ReadInt16(Source);
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        Shift := Ord(
          (c = 13) and (IntPtr(SourcePiece.Next) <> nil) and
          (
            Marshal.ReadInt16(IntPtr(Integer(IntPtr(SourcePiece.Next)) + SizeOf(TPieceHeader))) = 10
          )
        ) * sizeof(WideChar);
        if Shift = sizeof(WideChar) then begin
          Marshal.WriteInt32(Dest, CRLF_UTF16);
          Dest := IntPtr(Integer(Dest) + 4);
        end
        else begin
          Marshal.WriteInt16(Dest, c);
          Dest := IntPtr(Integer(Dest) + 2);
        end;
      end else
        Shift := 0;
    end;
    Dec(Used, SourcePiece.Used);
    TempPiece := SourcePiece;
    SourcePiece := SourcePiece.Next;
    Marshal.FreeHGlobal(TempPiece);
  end;
  if Dest <> nil then
    DestPiece.Used := DestPiece.Size - sizeof(WideChar) + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
  FFirstPiece := FirstPiece;
end;

procedure TBlob.RemoveCRUnicode;
var
  SourcePiece: PPieceHeader;
  DestPiece: PPieceHeader;
  LastPiece: PPieceHeader;
  FirstPiece: PPieceHeader;
  TempPiece: PPieceHeader;

  SourceStart: IntPtr;
  Source: IntPtr;
  Dest: IntPtr;
  DestEnd: IntPtr;
  SourceEnd: IntPtr;

  Shift: cardinal; //bytes
  Used: cardinal;  //bytes
  w: LongWord;
  c: word;

  procedure AllocDestPiece;
  var
    AUsed: cardinal;
  begin
    AUsed := Used + Cardinal(Integer(SourceStart)) - Cardinal(Integer(Source));
    if Dest <> nil then
      DestPiece.Used := DestPiece.Size + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
    if AUsed < PieceSize then
      AllocPiece(DestPiece, AUsed)
    else
      AllocPiece(DestPiece, PieceSize);
    Dest := IntPtr(Integer(DestPiece) + SizeOf(TPieceHeader));
    DestEnd := IntPtr(Integer(Dest) + Integer(DestPiece.Size));
    DestPiece.Blob := Self.GetHashCode;
    DestPiece.Prev := LastPiece;
    if IntPtr(LastPiece) <> nil then
      LastPiece.Next := DestPiece;
    LastPiece := DestPiece;
    if IntPtr(FirstPiece) = nil then
      FirstPiece := DestPiece;
  end;

begin
  CheckValid;   // DEBUG

  CheckValue;

  if (IntPtr(FFirstPiece) = nil) then
    Exit;

  SourcePiece := FFirstPiece;
  FirstPiece := nil;
  LastPiece := nil;
  DestPiece := nil;
  Dest := nil;
  DestEnd := nil;
  Shift := 0;
  Used := Size;

  while (IntPtr(SourcePiece) <> nil) do begin
    if SourcePiece.Used > Shift then begin
      SourceStart := IntPtr(Integer(SourcePiece) + SizeOf(TPieceHeader) + Integer(Shift));
      Source := SourceStart;
      SourceEnd := IntPtr(Integer(Source) + Integer(SourcePiece.Used) - sizeof(WideChar) - Integer(Shift));

      while Integer(Source) < Integer(SourceEnd) do begin
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        w := marshal.ReadInt32(Source);
        if w = CRLF_UTF16 then begin
          Marshal.WriteInt16(Dest, LF_UTF16);
          Source := IntPtr(Integer(Source) + 4);
          Dest := IntPtr(Integer(Dest) + 2);
        end
        else
        begin
          Marshal.WriteInt16(Dest, Word(w));
          Source := IntPtr(Integer(Source) + 2);
          Dest := IntPtr(Integer(Dest) + 2);
        end;
      end;

      if Source = SourceEnd then begin
        c := Marshal.ReadInt16(Source);
        if Integer(Dest) >= Integer(DestEnd) then
          AllocDestPiece;
        Shift := Ord(
          (c = 13) and (IntPtr(SourcePiece.Next) <> nil) and
          (
            Marshal.ReadInt16(IntPtr(Integer(IntPtr(SourcePiece.Next)) + SizeOf(TPieceHeader))) = 10
          )
        ) * sizeof(WideChar);
        if Shift = sizeof(WideChar) then
          c := 10;
        Marshal.WriteInt16(Dest, c);
        Dest := IntPtr(Integer(Dest) + 2);
      end else
        Shift := 0;
    end;
    Dec(Used, SourcePiece.Used);
    TempPiece := SourcePiece;
    SourcePiece := SourcePiece.Next;
    Marshal.FreeHGlobal(TempPiece);
  end;
  if Dest <> nil then
    DestPiece.Used := DestPiece.Size + Cardinal(Integer(Dest)) - Cardinal(Integer(DestEnd));
  FFirstPiece := FirstPiece;
end;

{ TBlobUtils }

class procedure TBlobUtils.SetModified(Blob: TBlob; Value: boolean);
begin
  Blob.FModified := Value;
end;

{$IFDEF HAVE_COMPRESS}

{ TCompressedBlob }

function TCompressedBlob.CompressFrom(source: IntPtr; const sourceLen: longint): boolean;
var
  CPiece: PPieceHeader;
  CSize: integer;
begin
  // see my_compress_alloc
  // *complen=  *len * 120 / 100 + 12;
  CheckZLib;
  CSize := CCompressBlobHeaderSize{header} + sourceLen + (sourceLen div 5) + 12;
  AllocPiece(CPiece, CSize);
  try
    DoCompress(Pointer(Integer(CPiece) + sizeof(TPieceHeader) + CCompressBlobHeaderSize), @CSize, source, sourceLen);
    CPiece.Used := CCompressBlobHeaderSize + CSize;
    Result := LongInt(CPiece.Used) < sourceLen; // Compression is successful
  except
    Result := False;
  end;
  if not Result then begin
    FreePiece(CPiece);
    Exit;
  end;

  // WriteHeader
  CopyBuffer(@CCompressBlobHeaderGuid[0], PByte(Integer(CPiece) + sizeof(TPieceHeader)), CCompressBlobHeaderGuidSize);
  Marshal.WriteInt32(CPiece, sizeof(TPieceHeader) + CCompressBlobHeaderSize - SizeOf(Integer), sourceLen);

  CompressPiece(CPiece);
  if FFirstPiece <> nil then
    FreePiece(FFirstPiece);
  AppendPiece(CPiece);

  FModified := True;
end;

procedure TCompressedBlob.UncompressTo(dest: IntPtr; var destlen: integer);
var
  source: IntPtr;
begin
  Assert(FFirstPiece <> nil);

  Defrag;
  source := PByte(Integer(FFirstPiece) + sizeof(TPieceHeader));

  Assert(FFirstPiece.Next = nil);

  // Check header
  if FFirstPiece.Used <= CCompressBlobHeaderSize then
    DataError(SInvalidComprBlobSize);
  if not CompareMem(source, @CCompressBlobHeaderGuid[0], CCompressBlobHeaderGuidSize) then
    DataError(SInvalidComprBlobHeader);

  CheckZLib;
  try
    DoUncompress(dest, @destlen, IntPtr(Integer(source) + CCompressBlobHeaderSize), FFirstPiece.Used - CCompressBlobHeaderSize);
  except
    DataError(SInvalidComprBlobData);
  end;
end;

function TCompressedBlob.GetSize: cardinal;
begin
  if Compressed then begin
    Result := UnCompressedSize;
    Assert(Result > 0);
  end
  else
    Result := inherited GetSize;
end;

procedure TCompressedBlob.SetSize(Value: cardinal);
begin
  if Compressed then
    Assert((Value = 0) or (Value = Size));

  inherited;
end;

function TCompressedBlob.GetCompressedSize: cardinal;
begin
  if not Compressed then
    DataError(sBlobNotCompressed);
  Result := inherited GetSize;
end;

function TCompressedBlob.GetCompressed: boolean;
begin
  Result :=
    (FFirstPiece <> nil) and
    // (FFirstPiece.Next = nil) and - false, if blob copied from another blob
    (FFirstPiece.Used > CCompressBlobHeaderSize) and
    CompareMem(IntPtr(Integer(FFirstPiece) + sizeof(TPieceHeader)), @CCompressBlobHeaderGuid[0], CCompressBlobHeaderGuidSize);
end;

procedure TCompressedBlob.SetCompressed(Value: boolean);
var
  CPiece: PPieceHeader;
  Count, CSize: integer;
begin
  if (IntPtr(FFirstPiece) = nil) or (Compressed = Value) then
    Exit;

  if Value then begin
    { pack
    (b) small blob without compression (Size < MIN_COMPRESS_LENGTH).
    (c) big blobs without compression (ZIP, JPG etc).
    (d) big blobs with compression (TXT etc).
    }
    Count := Size;
    // (b)
    if Count <= MIN_COMPRESS_LENGTH then
      Exit;

    Defrag;
    CompressFrom(PByte(Integer(FFirstPiece) + sizeof(TPieceHeader)), Count);
  end
  else
  begin
    // unpack
    CheckValid;   // DEBUG
    CheckValue;

    Assert(FFirstPiece <> nil, 'FFirstPiece = nil');

    CSize := UnCompressedSize;
    AllocPiece(CPiece, CSize);
    try
      UncompressTo(IntPtr(Integer(CPiece) + sizeof(TPieceHeader)), CSize);
      CPiece.Used := CSize;
      if CPiece.Used <> CPiece.Size then
        DataError(SInvalidUnComprBlobSize); //DatabaseError(SInvalidUnComprBlobSize);
    except
      FreePiece(CPiece);
      raise;
    end;

    FreePiece(FFirstPiece);
    AppendPiece(CPiece);
  end;

  FModified := True;
end;

function TCompressedBlob.UnCompressedSize: cardinal;
begin
  Assert(Compressed);
  Result := Marshal.ReadInt32(FFirstPiece, sizeof(TPieceHeader) + CCompressBlobHeaderSize - SizeOf(Integer));
end;

procedure TCompressedBlob.Truncate(NewSize: cardinal);
begin
  if Compressed and (NewSize <> 0) then
    Compressed := False;
  inherited;
end;

function TCompressedBlob.Read(Position, Count: cardinal;
  Dest: IntPtr): cardinal;
var
  CSize: Longint;
  ReadAll: boolean;
begin
  // partial read or read all blob?
  ReadAll := (Position = 0) and ((Count = Size) or (Count = 0));
  if Compressed and not ReadAll then
    Compressed := False;

  if Compressed then begin
    Assert(ReadAll);

    // Copied from inherited
    CheckValid;   // DEBUG
    CheckValue;
    Result := 0;

    if (IntPtr(FFirstPiece) = nil) or (Position > Size) then
      Exit;

    if Count = 0 then
      Count := Size;
    //-----------

    CSize := Count;
    UncompressTo(Dest, CSize);
    Assert(Cardinal(CSize) = Count);
    Result := CSize;
  end
  else
    Result := inherited Read(Position, Count, Dest);
end;

procedure TCompressedBlob.Write(Position, Count: cardinal; Source: IntPtr);
begin
  if Compressed then begin
    if (Position <> 0) or ((Count <> Size) and (Size <> 0)) {full rewrite} then begin
      Compressed := False;
      inherited;
      Exit;
    end;
    Clear;

    { pack
    (b) small blob without compression (Size < MIN_COMPRESS_LENGTH).
    (c) big blobs without compression (ZIP, JPG etc).
    (d) big blobs with compression (TXT etc).
    }

    // (b)
    if (Count <= MIN_COMPRESS_LENGTH) or not CompressFrom(Source, Count) then
      inherited;
  end
  else
    inherited;
end;

procedure TCompressedBlob.SaveToRollback;
var
  Piece: PPieceHeader;
  CSize: Longint;
begin
  CheckCached;

  Rollback := TCompressedBlob.Create;
  Rollback.IsUnicode := IsUnicode;
  Rollback.FModified := FModified;

  CSize := Size;
  if (IntPtr(FFirstPiece) <> nil) and (CSize <> 0) then begin
    // make copy of data
    AllocPiece(Piece, CSize);
    Piece.used := CSize;
    Read(0, CSize, IntPtr(Integer(Piece) + sizeof(TPieceHeader)));

    TCompressedBlob(Rollback).FFirstPiece := FFirstPiece;
    FFirstPiece := nil;
    AppendPiece(Piece);
  end;
end;
{$ENDIF}

{$IFDEF VER6}
{$IFDEF MSWINDOWS}
function LCIDToCodePage(ALcid: LongWord): Integer;
const
  CP_ACP = 0;                                // system default code page
  LOCALE_IDEFAULTANSICODEPAGE = $00001004;   // default ansi code page
var
  ResultCode: Integer;
  Buffer: array [0..6] of Char;
begin
  GetLocaleInfo(ALcid, LOCALE_IDEFAULTANSICODEPAGE, Buffer, SizeOf(Buffer));
  Val(Buffer, Result, ResultCode);
  if ResultCode <> 0 then
    Result := CP_ACP;
end;
{$ENDIF}
{$ENDIF}

initialization
  StartWaitProc := nil;
  StopWaitProc := nil;
  ApplicationTitleProc := nil;
{$IFNDEF VER6P}
  ApplicationHandleException := nil;
{$ENDIF}

{$IFDEF VER6}
{$IFDEF MSWINDOWS}
  // Code from Delphi7 system.pas
  // High bit is set for Win95/98/ME
  if not IsWin9x then
  begin
    if {Lo(GetVersion) > 4} Win32MajorVersion > 4 then
      DefaultUserCodePage := 3  // Use CP_THREAD_ACP with Win2K/XP
    else
      // Use thread's current locale with NT4
      DefaultUserCodePage := LCIDToCodePage(GetThreadLocale);
  end
  else
    // Convert thread's current locale with Win95/98/ME
    DefaultUserCodePage := LCIDToCodePage(GetThreadLocale);
{$ENDIF}    
{$ENDIF}

  BoolSymbolLexems := TStringList.Create;
  BoolKeywordLexems := TStringList.Create;

  BoolSymbolLexems.AddObject('=', TObject(Integer(lxEqual)));
  BoolSymbolLexems.AddObject('>', TObject(Integer(lxMore)));
  BoolSymbolLexems.AddObject('<', TObject(Integer(lxLess)));
  BoolSymbolLexems.AddObject('>=', TObject(Integer(lxMoreEqual)));
  BoolSymbolLexems.AddObject('<=', TObject(Integer(lxLessEqual)));
  BoolSymbolLexems.AddObject('<>', TObject(Integer(lxNoEqual)));
  BoolSymbolLexems.AddObject('(', TObject(Integer(lxLeftBracket)));
  BoolSymbolLexems.AddObject(')', TObject(Integer(lxRightBracket)));
  BoolSymbolLexems.AddObject('-', TObject(Integer(lxMinus)));
  BoolSymbolLexems.AddObject('+', TObject(Integer(lxPlus)));
  BoolSymbolLexems.AddObject('[', TObject(Integer(lxLeftSqBracket)));
  BoolSymbolLexems.AddObject(']', TObject(Integer(lxRightSqBracket)));
  BoolSymbolLexems.CustomSort(CRCmpStrings);

  BoolKeywordLexems.AddObject('AND', TObject(Integer(lxAND)));
  BoolKeywordLexems.AddObject('FALSE', TObject(Integer(lxFALSE)));
  BoolKeywordLexems.AddObject('IS', TObject(Integer(lxIS)));
  BoolKeywordLexems.AddObject('NOT', TObject(Integer(lxNOT)));
  BoolKeywordLexems.AddObject('NULL', TObject(Integer(lxNULL)));
  BoolKeywordLexems.AddObject('OR', TObject(Integer(lxOR)));
  BoolKeywordLexems.AddObject('TRUE', TObject(Integer(lxTRUE)));
  BoolKeywordLexems.AddObject('LIKE', TObject(Integer(lxLIKE)));
  BoolKeywordLexems.CustomSort(CRCmpStrings);

  RefreshIteration := 1;

finalization
  BoolSymbolLexems.Free;
  BoolKeywordLexems.Free;
  
{$IFDEF MSWINDOWS}
  {$IFDEF CRDEBUG} if DataCnt <> 0 then MessageBox(0, PChar(IntToStr(DataCnt) + ' Data(s) hasn''t been released'), 'DA warning', MB_OK); {$ENDIF}
  {$IFDEF CRDEBUG} if ShareObjectCnt <> 0 then MessageBox(0, PChar(IntToStr(ShareObjectCnt) + ' ShareObject(s) hasn''t been released'), 'DA warning', MB_OK); {$ENDIF}
{$ENDIF}
end.
