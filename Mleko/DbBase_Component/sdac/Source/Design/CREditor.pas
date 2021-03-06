
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright � 1998-2007 Core Lab. All right reserved.
//  Base Component Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit CREditor;
{$ENDIF}

interface
uses
{$IFDEF MSWINDOWS}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, DBGrids, Dialogs,
  StdCtrls, ExtCtrls, Buttons,
{$ENDIF}
{$IFDEF LINUX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDBGrids, QDialogs, QStdCtrls, QExtCtrls,
  QButtons, Qt,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$IFDEF CLR}
  System.Text,
{$ENDIF}
{$ENDIF}
   DBAccess, DADesignUtils;

type
  TCREditorClass = class of TCREditorForm;
  TCREditorForm = class(TForm)
    BtnPanel: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    imCorner: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  {$IFDEF DBTOOLS}
  {$IFDEF CLR}
  protected
    OldMessageProcessing : TMessageEvent;
    procedure MessageProcessing(var Msg: TMsg; var Handled: Boolean);
  public
    destructor Destroy; override;
  {$ENDIF}
  {$ENDIF}
  private
    FOldCreateOrder: boolean;
  {$IFDEF MSWINDOWS}
    FOldPosition: TPosition;
  {$ENDIF}

    FConfirmCancel: boolean;

    procedure SetConfirmCancel(const Value: boolean);
  {$IFDEF DBTOOLS}
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  {$ENDIF}
  protected
    FModified: boolean;
    FolderName: string;
    FDADesignUtilsClass: TDADesignUtilsClass;
    FInitialProperty: string;
  {$IFDEF USE_SYNEDIT}
    FSynSQLSyn: TPersistent;
    FUseSynEdit: boolean;
  {$ENDIF}

    function GetModified: boolean; virtual;
    procedure SetModified(Value: boolean); virtual;

    procedure ReplaceMemos;
  {$IFDEF USE_SYNEDIT}
    procedure SynMenuItemClick(Sender: TObject);
    procedure SynMenuPopup(Sender: TObject);
  {$ENDIF}

    procedure DoInit; virtual;
    procedure DoActivate; virtual;
    procedure DoSave; virtual;
    procedure DoFinish; virtual;

    procedure ExitActiveControl; virtual;
    procedure SaveControlData; virtual;

    function SaveState: boolean; virtual;
    function LoadState: boolean; virtual;

    function GetComponent: TComponent; virtual;
    procedure SetComponent(Value: TComponent); virtual;
    function GetLocalComponent: TComponent; virtual;

  {$IFDEF MSWINDOWS}
    function KeyPath: string;
  {$ENDIF}
  {$IFDEF DBTOOLS}
    procedure ActiveChanged; override;
  {$ENDIF}
    property Modified: boolean read GetModified write SetModified;

  public
    constructor Create(Owner: TComponent; DADesignUtilsClass: TDADesignUtilsClass); reintroduce; virtual;

  {$IFDEF USE_SYNEDIT}
    procedure ReplaceMemo(var Memo: TWinControl; DrawGutter: boolean);
  {$ENDIF}

    procedure CheckConnection(const Component: TComponent);

  /// If ConfirmCancel is True editor asks user for comfirmation to discard
  /// changes. By default ConfirmCancel is set to True.
    property ConfirmCancel: boolean read FConfirmCancel write SetConfirmCancel;

    property DADesignUtilsClass: TDADesignUtilsClass read FDADesignUtilsClass;

    property Component: TComponent read GetComponent write SetComponent;
    property LocalComponent: TComponent read GetLocalComponent;
    property InitialProperty: string read FInitialProperty write FInitialProperty;

  published
    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder; // for D3
  end;

  {
  TComponent
    TControl
      TWinControl
        TCustomEdit
          TCustomMemo
            TMemo
              TDAMemo
        TCustomControl
          TCustomSynEdit
            TSynEdit
              TSynMemo
  }

  TDAMemo = class(TMemo)
  protected
    BackSpacePressed: boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  end;

{$IFDEF LINUX}
  TWinControlClass = class of TWinControl;
{$ENDIF}

  function ReplaceControl(var Control: TWinControl; const NewClass: TWinControlClass): boolean;
  function ReplaceGridToCRGrid(var DBGrid: TCustomDBGrid): boolean;

  function GetMemoText(Memo: TWinControl): string;
  procedure SetMemoText(Memo: TWinControl; Value: string);
  function GetReadOnly(Memo: TWinControl): boolean;
  procedure SetReadOnly(Memo: TWinControl; Value: boolean);
  function GetSelStart(Memo: TWinControl): integer;  
  procedure SetSelStart(Memo: TWinControl; Value: integer);
  procedure SetSelLength(Memo: TWinControl; Value: integer);
  procedure LoadFromFile(Memo: TWinControl; FileName: string);
  procedure SaveToFile(Memo: TWinControl; FileName: string);  

implementation
uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
{$IFDEF USE_SYNEDIT}
  Menus,
{$ENDIF}
  TypInfo,
  DAParamValueEditor, DB, DAConsts;

{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R CREditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}

const
  sSynMemo = 'TSynMemo';
  sSynSQLSyn = 'TSynSQLSyn';

{$IFDEF USE_SYNEDIT}
  SynMenuItemNames: array[0..7] of string = (
    '&Undo',
    '-',
    'Cu&t',
    '&Copy',
    '&Paste',
    '&Delete',
    '-',
    'Select &All'
  );

type
  TSynMenuItem = class(TMenuItem)
  public
    Memo: TWinControl;
  end;
{$ENDIF}


function ReplaceControl(var Control: TWinControl; const NewClass: TWinControlClass): boolean;
var
  NewControl: TWinControl;

  i, PropCount: integer;
{$IFDEF CLR}
  PropList: TPropList;
  PropInfo: TPropInfo;
{$ELSE}
  PropList: PPropList;
  PropInfo: PPropInfo;
{$ENDIF}

  OldParent: TWinControl;
  OldTabOrder: integer;
  OldName: string;

  Obj, NewObj: TPersistent;

  OldAct: boolean;
  OldMemoValue: string;

begin
  Result := NewClass <> nil;
  if not Result then
    Exit;

{$IFDEF CLR}
  if NewClass.ClassName = 'TCRDBGrid' then begin
    Result := False;
    Exit;
  end;
{$ENDIF}

  NewControl := NewClass.Create(Control.Owner);

  OldParent := Control.Parent;
  OldTabOrder := Control.TabOrder;
  OldName := Control.Name;

  if (Control is TMemo) and (NewControl is TMemo) then
    OldMemoValue := TMemo(Control).Lines.Text
  else
    OldMemoValue := '';

  OldAct := (Control.Owner <> nil)
    and (Control.Owner is TCustomForm)
    and (TCustomForm(Control.Owner).ActiveControl = Control);

  Control.Parent := OldParent;

{$IFDEF CLR}
  PropList := GetPropList(NewClass.ClassInfo, tkAny, False);
  PropCount := Length(PropList);
{$ELSE}
  PropCount := GetPropList(NewClass.ClassInfo, tkAny, nil{$IFDEF VER6P}, False {$ENDIF});
  GetMem(PropList, PropCount * sizeof(PropList[0]));
  try
    GetPropList(NewClass.ClassInfo, tkAny, PropList{$IFDEF VER6P}, False {$ENDIF});
{$ENDIF}
    for i := 0 to PropCount - 1 do begin
      PropInfo := GetPropInfo(Control, PropList[i].Name);
      if (PropInfo <> nil) // published property
        and (PropList[i].Name <> 'Name')
        and (IsStoredProp(Control, PropInfo)) then
        case PropList[i].PropType{$IFNDEF CLR}^{$ENDIF}.Kind of
          tkClass:
          begin
          {$IFDEF CLR}
            Obj := GetObjectProp(Control, PropInfo) as TPersistent;
          {$ELSE}
            Obj := TPersistent(integer(GetPropValue(Control, PropList[i].Name)));
          {$ENDIF}

            if (Obj <> nil) and (Obj.ClassName <> 'TMemoStrings'{$IFDEF CLR}{$IFDEF VER9P} + '$StdCtrls'{$ENDIF}{$ENDIF}) then begin
              Assert(Obj is TPersistent);
            {$IFDEF CLR}
              NewObj := GetObjectProp(NewControl, PropList[i].Name) as TPersistent;
            {$ELSE}
              NewObj := TPersistent(integer(GetPropValue(NewControl, PropList[i].Name)));
            {$ENDIF}
              if NewObj = nil then begin
                NewObj := Obj;
                SetObjectProp(Control, PropInfo, nil);
                //SetOrdProp(Control, PropList[i], integer(nil));
              end
              else
              begin
                Assert(NewObj is TPersistent);
              {$IFDEF VER10}
                if NewObj is TMargins then Continue;
              {$ENDIF}
                NewObj.Assign(Obj);
              end;
            {$IFDEF CLR}
              PropInfo := GetPropInfo(NewControl, PropList[i].Name);
            {$ENDIF}
              SetObjectProp(NewControl, PropInfo, NewObj);
              //SetOrdProp(NewControl, PropList[i], integer(NewObj));
            end;
          end;
          tkMethod:
            SetMethodProp(NewControl, PropList[i], GetMethodProp(Control, PropList[i]));
          else
            SetPropValue(NewControl, PropList[i].Name, GetPropValue(Control, PropList[i].Name));
        end;
    end;

{$IFNDEF CLR}            
  finally
    FreeMem(PropList);
  end;
{$ENDIF}

  Control.Free;
  Control := NewControl;
  Control.Name := OldName;
  Control.Parent := OldParent;
  Control.TabOrder := OldTabOrder;

  if Control is TMemo then
    TMemo(Control).Lines.Text := OldMemoValue;

  if OldAct then
    TCustomForm(Control.Owner).ActiveControl := Control;
end;

function ReplaceGridToCRGrid(var DBGrid: TCustomDBGrid): boolean;
var
  wc: TWinControl;
  NewClass: TWinControlClass;
begin
  wc := TWinControl(DBGrid);
  NewClass := TWinControlClass(GetClass('TCRDBGrid'));
  Result := ReplaceControl(wc, NewClass);
  if Result then
    DBGrid := wc as TCustomDBGrid;
end;

function GetMemoText(Memo: TWinControl): string;
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then
    Result := DBTools.GetDACSqlEditorFrame(Memo).Text
  else
{$ENDIF}
  if Memo is TMemo then
    Result := TMemo(Memo).Lines.Text
  else
    if Memo.ClassName = sSynMemo then
      Result := TStrings(GetObjectProp(Memo, 'Lines')).Text
    else
    begin
      Result := '';
      Assert(False, Memo.ClassName);
    end;
end;

procedure SetMemoText(Memo: TWinControl; Value: string);
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then
    DBTools.GetDACSqlEditorFrame(Memo).Text := Value
  else
{$ENDIF}
  if Memo is TMemo then
    TMemo(Memo).Lines.Text := Value
  else
    if Memo.ClassName = sSynMemo then
      TStrings(GetObjectProp(Memo, 'Lines')).Text := Value
    else
      Assert(False, Memo.ClassName);
end;

function GetReadOnly(Memo: TWinControl): boolean;
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then
    Result := DBTools.GetDACSqlEditorFrame(Memo).ReadOnly
  else
{$ENDIF}
  if Memo is TMemo then
    Result := TMemo(Memo).ReadOnly
  else
    if Memo.ClassName = sSynMemo then
      Result := Boolean(GetOrdProp(Memo, 'ReadOnly'))
    else
    begin
      Result := False;
      Assert(False, Memo.ClassName);
    end;
end;

procedure SetReadOnly(Memo: TWinControl; Value: boolean);
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then
    DBTools.GetDACSqlEditorFrame(Memo).ReadOnly := Value
  else
{$ENDIF}
  if Memo is TMemo then
    TMemo(Memo).ReadOnly := Value
  else
    if Memo.ClassName = sSynMemo then
      SetOrdProp(Memo, 'ReadOnly', Longint(Value));
end;

function GetSelStart(Memo: TWinControl): integer;
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then
    Result := 0
  else
{$ENDIF}
  if Memo is TMemo then
    Result := TMemo(Memo).SelStart
  else
  {$IFDEF USE_SYNEDIT}
    if Memo.ClassName = sSynMemo then
      SendMessage(Memo.Handle, EM_GETSEL, Integer(@Result), 0)
    else
  {$ENDIF}
    begin
      Result := -1;
      Assert(False, Memo.ClassName);
    end;  
end;

procedure SetSelStart(Memo: TWinControl; Value: integer);
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then begin

  end
  else
{$ENDIF}
  if Memo is TMemo then
    TMemo(Memo).SelStart := Value
  else
  {$IFDEF USE_SYNEDIT}
    if Memo.ClassName = sSynMemo then
      SendMessage(Memo.Handle, EM_SETSEL, Value, Value)
    else
  {$ENDIF}
      Assert(False, Memo.ClassName);
end;

procedure SetSelLength(Memo: TWinControl; Value: integer);
begin
{$IFDEF DBTOOLS}
  if DBTools.HasDACSqlEditorFrame(Memo) then begin

  end
  else
{$ENDIF}
  if Memo is TMemo then
    TMemo(Memo).SelLength := Value
  else
  {$IFDEF USE_SYNEDIT}
    if Memo.ClassName = sSynMemo then
      SetOrdProp(Memo, 'SelLength', Value)
    else
  {$ENDIF}
      Assert(False, Memo.ClassName);
end;

procedure LoadFromFile(Memo: TWinControl; FileName: string);
var
  SL: TStrings;
{$IFDEF DBTOOLS}
  UseDBTools: boolean;
{$ENDIF}
begin
  SL := nil;
{$IFDEF DBTOOLS}
  if not DBTools.HasDACSqlEditorFrame(Memo) then
{$ENDIF}
    if Memo is TMemo then
      SL := TMemo(Memo).Lines
    else
    {$IFDEF USE_SYNEDIT}
      if Memo.ClassName = sSynMemo then
        SL := TStrings(GetObjectProp(Memo, 'Lines'))
      else
    {$ENDIF}
       Assert(False, Memo.ClassName);
       
{$IFDEF DBTOOLS}
  UseDBTools := SL = nil;
  if UseDBTools then
    SL := TSTringList.Create;
  try
{$ENDIF}
    SL.LoadFromFile(FileName);
{$IFDEF DBTOOLS}
    if UseDBTools then
      DBTools.GetDACSqlEditorFrame(Memo).Text := SL.Text
  finally
    if UseDBTools then
      SL.Free;
  end;
{$ENDIF}
end;

procedure SaveToFile(Memo: TWinControl; FileName: string);
var
  SL: TStrings;
{$IFDEF DBTOOLS}
  UseDBTools: boolean;
{$ENDIF}
begin
  SL := nil;
{$IFDEF DBTOOLS}
  if not DBTools.HasDACSqlEditorFrame(Memo) then
{$ENDIF}
    if Memo is TMemo then
      SL := TMemo(Memo).Lines
    else
    {$IFDEF USE_SYNEDIT}
      if Memo.ClassName = sSynMemo then
        SL := TStrings(GetObjectProp(Memo, 'Lines'))
      else
    {$ENDIF}
        Assert(False, Memo.ClassName);
        
{$IFDEF DBTOOLS}
  UseDBTools := SL = nil;
  if UseDBTools then begin
    SL := TSTringList.Create;
    SL.Text := DBTools.GetDACSqlEditorFrame(Memo).Text
  end;
  try
{$ENDIF}
    SL.SaveToFile(FileName);
{$IFDEF DBTOOLS}
  finally
    if UseDBTools then
      SL.Free;
  end;
{$ENDIF}
end;

{ TDAMemo }

procedure TDAMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  if Shift = [ssCtrl] then begin
    if Key = 65 then
      SelectAll
    else
    if (Key = {$IFNDEF LINUX}VK_BACK{$ELSE}Key_Backspace{$ENDIF}) then
      BackSpacePressed := True;
  end;
end;

procedure TDAMemo.KeyPress(var Key: Char);
var
  StartI, EndI: integer;
  Text: string;
begin
  inherited;

  if BackSpacePressed then begin
    BackSpacePressed := False;
    Text := Lines.Text;
    StartI := SelStart;
    EndI := SelStart;
    while (StartI > 0) and (Text[StartI] <= ' ') do
      Dec(StartI);
    while (StartI > 0) and (Text[StartI] > ' ') do
      Dec(StartI);
    if EndI > StartI then begin
      SelStart := StartI;
      SelLength := EndI - StartI;
      SelText := '';
    end;
    Key := #0;
  end;
end;

{ TCREditorForm }

constructor TCREditorForm.Create(Owner: TComponent; DADesignUtilsClass: TDADesignUtilsClass);
begin
  inherited Create(Owner);
  FDADesignUtilsClass := DADesignUtilsClass;
  FolderName := ClassName;
  ConfirmCancel := True;
end;

{$IFDEF USE_SYNEDIT}
procedure TCREditorForm.SynMenuPopup(Sender: TObject);
var
  n, m: DWORD;
  Memo: TWinControl;
  HasSelection: boolean;
begin
  with TPopupMenu(Sender) do begin
    Memo := TSynMenuItem(Items[0]).Memo;
    SendMessage(Memo.Handle, EM_GETSEL, Integer(@n), Integer(@m));
    HasSelection := n < m;
    Items[0].Enabled := // Undo
      SendMessage(Memo.Handle, EM_CANUNDO, 0, 0) <> 0;
    Items[2].Enabled := // Cut
      HasSelection;
    Items[3].Enabled := // Copy
      HasSelection;
    Items[4].Enabled := // Paste
      IsClipboardFormatAvailable(CF_TEXT);
    Items[5].Enabled := // Delete
      HasSelection;
    Items[7].Enabled := // Select All
      GetMemoText(Memo) <> '';
  end;
end;

procedure TCREditorForm.SynMenuItemClick(Sender: TObject);
begin
  with TSynMenuItem(Sender) do begin
    case Tag of
      0: // Undo
        SendMessage(Memo.Handle, EM_UNDO, 0, 0);
      2:// Cut
        SendMessage(Memo.Handle, WM_CUT, 0, 0);
      3:// Copy
        SendMessage(Memo.Handle, WM_COPY, 0, 0);
      4:// Paste
        SendMessage(Memo.Handle, WM_PASTE, 0, 0);
      5:// Delete
        SendMessage(Memo.Handle, WM_CLEAR, 0, 0);
      7:// Select All
        SendMessage(Memo.Handle, EM_SETSEL, 0, Length(GetMemoText(Memo)));
    end;
  end;
end;

procedure TCREditorForm.ReplaceMemo(var Memo: TWinControl; DrawGutter: boolean);
type
  TSetProc = procedure (Self: TObject; Ptr: pointer);
const
  NilMethod: TMethod =
   (Code: nil; Data: nil);
var
  MemoClass: string;
  NewMemo: TCustomControl;
  OldName: string;
  TypeInfo: PTypeInfo;
//  Ptr:pointer;
//  i: integer;
  Gutter: TObject;
  i: integer;
  Menu: TPopupMenu;
  MenuItem: TSynMenuItem;
begin
  if FUseSynEdit and (GetClass(sSynMemo) <> nil) and (FSynSQLSyn <> nil) then begin
    MemoClass := sSynMemo;

    NewMemo := TCustomControl(GetClass(MemoClass).NewInstance);
    NewMemo.Create(Memo.Owner);
    if GetObjectProp(NewMemo, 'Lines').ClassParent <> TStrings then
      NewMemo.Free
    else begin
      with NewMemo do begin
        Parent := Memo.Parent;
        Left := Memo.Left;
        Top := Memo.Top;
        Width := Memo.Width;
        Height := Memo.Height;
        Align := Memo.Align;
        TabOrder := Memo.TabOrder;
        Anchors := Memo.Anchors;
        //Constraints := Memo.Constraints;
        TypeInfo := GetClass(MemoClass).ClassInfo;
        HelpContext := Memo.HelpContext;
        if Memo is TMemo then begin
          SetReadOnly(NewMemo, TMemo(Memo).ReadOnly);
          if MemoClass = sSynMemo then
            SetOrdProp(NewMemo, 'Color', Longint(TMemo(Memo).Color));
        end;

        if GetPropInfo(Memo.ClassInfo, 'OnChange') <> nil then
          SetMethodProp(NewMemo, GetPropInfo(TypeInfo, 'OnChange'),
            GetMethodProp(Memo, GetPropInfo(Memo.ClassInfo, 'OnChange')));
        SetMethodProp(NewMemo, GetPropInfo(TypeInfo, 'OnExit'),
          GetMethodProp(Memo, GetPropInfo(Memo.ClassInfo, 'OnExit')));
        SetMethodProp(NewMemo, GetPropInfo(TypeInfo, 'OnKeyDown'),
          GetMethodProp(Memo, GetPropInfo(Memo.ClassInfo, 'OnKeyDown')));
        SetMethodProp(NewMemo, GetPropInfo(TypeInfo, 'OnKeyPress'),
          GetMethodProp(Memo, GetPropInfo(Memo.ClassInfo, 'OnKeyPress')));
      end;

      if (Memo.Owner <> nil) and (TForm(Memo.Owner).ActiveControl = Memo) then begin
        SetMethodProp(Memo, GetPropInfo(TypeInfo, 'OnExit'), NilMethod);
        TForm(Memo.Owner).ActiveControl := NewMemo;
      end;

      OldName := Memo.Name;
      Memo.Free;
      Memo := TMemo(NewMemo);
      NewMemo.Name := OldName;

      if MemoClass = sSynMemo then begin
        SetObjectProp(NewMemo, 'Highlighter', FSynSQLSyn);
        SetOrdProp(NewMemo, 'Options', $3680DBF); // [eoAltSetsColumnMode, eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDisableScrollArrows, eoDragDropEditing, eoDropFiles, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoKeepCaretX, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabIndent, eoTabsToSpaces]
        Gutter := GetObjectProp(NewMemo, 'Gutter');
        Assert(Gutter <> nil);
        if DrawGutter then begin
          SetOrdProp(Gutter, 'Visible', Longint(True));

          SetOrdProp(Gutter, 'AutoSize', Longint(True));
          SetOrdProp(Gutter, 'DigitCount', 2);
          SetOrdProp(Gutter, 'LeftOffset', 0);
          SetOrdProp(Gutter, 'RightOffset', 0);
          SetOrdProp(Gutter, 'ShowLineNumbers', Longint(True));
          SetOrdProp(Gutter, 'Width', 1);
        end
        else
          SetOrdProp(Gutter, 'Visible', Longint(False));

        Menu := TPopupMenu.Create(Self);
        Menu.OnPopup := SynMenuPopup;
        for i := 0 to High(SynMenuItemNames) do begin
          MenuItem := TSynMenuItem.Create(Self);
          MenuItem.Memo := Memo;
          MenuItem.Caption := SynMenuItemNames[i];
          MenuItem.Tag := i;
          MenuItem.OnClick := SynMenuItemClick;
          Menu.Items.Add(MenuItem);
        end;
        SetObjectProp(Memo, 'PopupMenu', Menu);
      end;
    end;
  end;
end;
{$ENDIF}

procedure TCREditorForm.ReplaceMemos;
var
  i: integer;
  MemoArr: array of TWinControl;

  procedure ProcessComponent(Component: TComponent);
  var
    i: integer;
    SubComponent: TComponent;
  begin
    for i := 0 to Component.ComponentCount - 1 do begin
      SubComponent := Component.Components[i];
      if SubComponent.ClassType = TMemo then begin
        SetLength(MemoArr, Length(MemoArr) + 1);
        MemoArr[Length(MemoArr) - 1] := TMemo(SubComponent);
      end
      else
      if SubComponent is TFrame then
        ProcessComponent(SubComponent);
    end;
  end;

begin
{$IFDEF USE_SYNEDIT}
  if not (FUseSynEdit or FDADesignUtilsClass.DBToolsAvailable) then
{$ENDIF}
  begin
    ProcessComponent(Self);
    for i := 0 to Length(MemoArr) - 1 do
      ReplaceControl(MemoArr[i], TDAMemo)
  end;
end;

procedure TCREditorForm.DoInit;
{$IFDEF LINUX} 
  procedure ProcessCombos(Component: TComponent);
  var 
    i: integer;
  begin
    // K2 Only???
    for i := 0 to Component.ComponentCount - 1 do 
      if (Component.Components[i] is TComboBox) 
        and (TComboBox(Component.Components[i]).Items.Count = 0) 
        and Assigned(TComboBox(Component.Components[i]).OnDropDown) then
        TComboBox(Component.Components[i]).Items.Add('');
  end;
  
var 
  i: integer;
{$ENDIF}
begin
  Modified := False;

  if (Component = nil) and (Self is TDAParamValueEditor) then
    Exit;
  Assert(Component <> nil, ClassName);
  if Component.Owner <> nil then
    Caption := Component.Owner.Name + '.' + Component.Name
  else
    Caption := Component.Name;

  ReplaceMemos;
{$IFDEF LINUX} 
  ProcessCombos(Self);
  for i := 0 to ComponentCount - 1 do 
    if Components[i] is TCustomFrame then
      ProcessCombos(Components[i]);

  // Events order on Windows: OnCloseQuery, OnClose
  // Events order on Kylix:   OnClose, OnCloseQuery
  OnCloseQuery := nil; 
{$ENDIF}
end;

procedure TCREditorForm.DoActivate;
begin
end;

procedure TCREditorForm.DoSave;
begin
  SaveControlData;
end;

procedure TCREditorForm.DoFinish;
begin
end;

procedure TCREditorForm.ExitActiveControl;
var
  C: {$IFNDEF LINUX}TWinControl{$ELSE}TWidgetControl{$ENDIF};
begin
  C := ActiveControl;
  if (C is TComboBox) then
    (C as TComboBox).DroppedDown := False;
  ActiveControl := nil;
  if ActiveControl <> nil then
    SysUtils.Abort; // Error on, for example, OnFrameExit
                    // SysUtils prefix is needed to compile in Kylix 

  while (C <> nil) and (not C.Visible or not C.Enabled) do // "Cannot focus disabled or invisible window" bug. See TCRGridTitleEdit.DoFinish code
    C := C.Parent;

  ActiveControl := C;
end;

procedure TCREditorForm.SaveControlData;
begin
  ExitActiveControl;
end;

{$IFDEF MSWINDOWS}

function TCREditorForm.SaveState: boolean;
var
  Registry: TRegistry;
begin
  if (BorderStyle <> bsDialog) or (FOldPosition <> poScreenCenter)
  then begin
    Registry := TRegistry.Create;
    try
      with Registry do begin
        OpenKey(KeyPath + '\' + FolderName, True);
        if BorderStyle in [bsSizeable, bsSizeToolWin] then begin
          WriteBool('Maximized', WindowState = wsMaximized);
          WriteBool('Minimized', WindowState = wsMinimized);
          if WindowState = wsNormal then begin
            WriteInteger('Width', Width);
            WriteInteger('Height', Height);
          end;
        end;
        if (FOldPosition <> poScreenCenter) and (WindowState = wsNormal) then begin
          WriteInteger('Left', Left);
          WriteInteger('Top', Top);
        end;
        {if not Modal then
          SetBool('Visible', Visible);}
        Result := True;
      end
    finally
      Registry.Free;
    end
  end
  else
    Result := False;
end;

function TCREditorForm.LoadState: boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    with Registry do begin
      if OpenKey(KeyPath + '\' + FolderName, False) then begin
        if Position <> poScreenCenter then begin
          if ValueExists('Left') then
            Left := ReadInteger('Left');
          if ValueExists('Top') then
            Top := ReadInteger('Top');
        end;
        if BorderStyle in [bsSizeable, bsSizeToolWin] then begin
          if ValueExists('Width') then
            Width := ReadInteger('Width');
          if ValueExists('Height') then
            Height := ReadInteger('Height');

          if ValueExists('Maximized') and ReadBool('Maximized') then
            WindowState := wsMaximized
          else
            {if ValueExists('Minimized') and ReadBool('Minimized') then
              WindowState := wsMinimized
            else}
            WindowState := wsNormal;
        end;
        if ValueExists('Visible') and ReadBool('Visible') then begin
          Show;
          Update;
        end;
        Result := True;
      end
      else
      begin
        Left := (Screen.Width - Width) div 2;
        Top := (Screen.Height - Height) div 2;
        Result := False;
      end;

    {$IFDEF USE_SYNEDIT}
      if OpenKey(KeyPath, False) and ValueExists('UseSynEdit') then
        FUseSynEdit := ReadBool('UseSynEdit')
      else
        FUseSynEdit := True;
      FUseSynEdit := FUseSynEdit and (GetClass(sSynSQLSyn) <> nil) and (GetClass(sSynMemo) <> nil);
    {$ENDIF}
    end;
  finally
    Registry.Free;
  end;
  FOldPosition := Position;
end;

function TCREditorForm.KeyPath: string;
begin
  Result := '\SOFTWARE\CoreLab\' + FDADesignUtilsClass.GetProjectName + '\Editors';
end;

{$ENDIF}

{$IFDEF DBTOOLS}
procedure TCREditorForm.ActiveChanged;
begin
  inherited;
  
  if ActiveControl is TDACSqlEditorFrame then
    ActiveControl.SetFocus;
end;
{$ENDIF}

{$IFDEF LINUX}

function TCREditorForm.SaveState: boolean;
begin
  Result := True;
end;

function TCREditorForm.LoadState: boolean;
begin
  Result := True;
end;
{$ENDIF}

function TCREditorForm.GetComponent: TComponent;
begin
  Assert(False, 'Must be overriden');
  Result := nil;
end;

procedure TCREditorForm.SetComponent(Value: TComponent);
begin
  Assert(False, 'Must be overriden');
end;

function TCREditorForm.GetLocalComponent: TComponent;
begin
  Assert(False, 'Must be overriden');
  Result := nil;
end;

procedure TCREditorForm.FormShow(Sender: TObject);
{$IFDEF USE_SYNEDIT}
var
  NewSHClass: TPersistentClass;
  AltHighlightingStyle: Boolean;
{$IFDEF MSWINDOWS}
  Registry: TRegistry;
{$ENDIF}
  procedure SetSynHighlStyle(SynHiglAttrName: string; FontStyles: string; Foreground: TColor; Background: TColor = -1);
  var
    SynHiglAttr: TObject;
  begin
    SynHiglAttr := GetObjectProp(FSynSQLSyn, SynHiglAttrName);
    if SynHiglAttr <> nil then
      SetSetProp(SynHiglAttr, 'Style', FontStyles);

      if Foreground > -1 then
        SetOrdProp(SynHiglAttr, 'Foreground', Foreground);
      if Background > -1 then
        SetOrdProp(SynHiglAttr, 'Background', Background);
  end;
{$ENDIF}
begin
{$IFDEF DBTOOLS}
{$IFDEF CLR}
  OldMessageProcessing := Application.OnMessage;
  Application.OnMessage := MessageProcessing;
{$ENDIF}
{$ENDIF}

  LoadState;
{$IFDEF USE_SYNEDIT}
  NewSHClass := GetClass(sSynSQLSyn);
  if FUseSynEdit and (NewSHClass <> nil) then begin
    FSynSQLSyn := TComponentClass(NewSHClass).Create(Self);
    SetOrdProp(FSynSQLSyn, 'SQLDialect', FDADesignUtilsClass.SQLDialect);

    //setup syntax highighting
    AltHighlightingStyle := True;
    {$IFDEF MSWINDOWS}
    Registry := TRegistry.Create;
    try
      with Registry do begin
        if OpenKey(KeyPath, False) and ValueExists('AltHighlightingStyle') then
          AltHighlightingStyle := ReadBool('AltHighlightingStyle');
      end;
    finally
      Registry.Free;
    end;
    {$ENDIF}
    if AltHighlightingStyle then begin
      SetSynHighlStyle('CommentAttri', '[fsItalic]', clGray);
      SetSynHighlStyle('ConditionalCommentAttri', '[fsItalic]', clGray);
      SetSynHighlStyle('DataTypeAttri', '[]', clBlue);
      SetSynHighlStyle('FunctionAttri', '[]', clBlue);
      SetSynHighlStyle('KeyAttri', '[]', clBlue);
      SetSynHighlStyle('NumberAttri', '[]', clGreen);
      SetSynHighlStyle('StringAttri', '[]', clTeal);
    end;
  end;
{$ENDIF}

{$IFDEF LINUX}
  DoInit;
{$ELSE}
  try
    DoInit;
  except
    on E: EAbort do begin
      PostMessage(Handle, WM_CLOSE, 0, 0);
    end;
  end;
{$ENDIF}
  DoActivate;
end;

procedure TCREditorForm.FormHide(Sender: TObject);
{$IFDEF LINUX}
var
  CanClose: Boolean; // Skipped by Kylix bug 
{$ENDIF}
begin
{$IFDEF LINUX}
  FormCloseQuery(Sender, CanClose);
{$ENDIF}

  DoFinish;
  SaveState;
{$IFDEF USE_SYNEDIT}
  FSynSQLSyn.Free;
{$ENDIF}
end;

procedure TCREditorForm.SaveClick(Sender: TObject);
begin
  DoSave;

  Modified := False;

  ModalResult := mrOk;
end;

procedure TCREditorForm.CloseClick(Sender: TObject);
begin
  ModalResult := mrCancel
end;

procedure TCREditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
{$IFDEF MSWINDOWS}
const
  ResYes = IDYES;
  ResNo = IDNO;
var
  Res: integer;
{$ELSE}
const
  ResYes = smbYes;
  ResNo = smbNo;
var
  Res: TMessageButton;
{$ENDIF}
  OldActiveControl: TWinControl;
begin
{$IFDEF DBTOOLS}
  DBTools.CheckDBToolsChanges(Self);
{$ENDIF}
  OldActiveControl := ActiveControl;
  try
    ExitActiveControl;
  except
    // Silent. User can enter wrong data
  end;
  if (OldActiveControl <> nil) and OldActiveControl.Visible and OldActiveControl.Enabled then
    ActiveControl := OldActiveControl;

  if Modified then begin
    if ConfirmCancel then
    {$IFDEF MSWINDOWS}
      Res := Application.MessageBox('Save changes to component?', 'Confirm',
        MB_YESNOCANCEL or MB_ICONQUESTION)
    {$ELSE}
      Res := Application.MessageBox('Save changes to component?', 'Confirm',
        [smbYes, smbNo], smsWarning)
    {$ENDIF}
    else
      Res := ResNo;

    if Res = ResYes then begin
    {$IFDEF MSWINDOWS}
      ModalResult := mrOk;
    {$ENDIF}
      DoSave;
      Modified := False;
      CanClose := True;
    end
    else
      if Res = ResNo then begin
        CanClose := True;
      {$IFDEF MSWINDOWS}
        ModalResult := mrCancel;
      {$ENDIF}
      end
      else
        CanClose := False;
  end
  else
    CanClose := True;
end;

procedure TCREditorForm.SetConfirmCancel(const Value: boolean);
begin
  FConfirmCancel := Value;
end;

procedure TCREditorForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then begin
    Close;
    Key := #0;
  end;
end;

function TCREditorForm.GetModified: boolean;
begin
  Result := FModified;
end;

procedure TCREditorForm.SetModified(Value: boolean);
begin
  FModified := Value;
end;

{$IFDEF DBTOOLS}
{$IFDEF CLR}
destructor TCREditorForm.Destroy;
begin
  if Assigned(OldMessageProcessing) then
    Application.OnMessage := OldMessageProcessing;

  inherited;
end;

procedure TCREditorForm.MessageProcessing(var Msg: TMsg; var Handled: Boolean);
var
  Wnd: HWND;
  ParentHwnd: HWND;
  IsDbToolsCtrl: boolean;
  ClassName: StringBuilder;

  function IsDbToolsShortCut(Key: word): boolean;
  var
    Shift: word;
  begin
    Result := False;
    if Key and $FF00 = 0 then begin
      if GetKeyState(VK_CONTROL) < 0 then
        Shift := scCtrl
      else
        Shift := 0;
      if GetKeyState(VK_MENU) < 0 then
        Inc(Shift, scAlt);  //VK_SHIFT is of no importance

      if ((Key = VK_F4) and (Shift = scAlt)) //Alt+F4
        or ((Key = VK_ESCAPE) and (Shift = 0)) //ESC
        or ((Key >= Ord('a')) and (Key <= Ord('z')) and (Shift = scAlt)) //Alt+a..z
        or ((Key = VK_TAB) and ((Shift = scCtrl) or (Shift = 0))) then //[Ctrl+]Tab
        Exit;
    end;
    Result := True;
  end;

begin
//This procedure transports messages to managed non VCL DbToolsControls
  Handled := False;
  if (Msg.Message >= WM_KEYFIRST) and (Msg.Message <= WM_KEYLAST) then
    with Msg do begin
      IsDbToolsCtrl := False;
      Wnd := HWnd;
      if (FindControl(Wnd) = nil) and (Wnd <> 0) then begin
        //Check that Wnd is our managed control handle
        ParentHwnd := GetParent(Wnd);
        ClassName := StringBuilder.Create;
        ClassName.Capacity := 1024;
        while (not IsDbToolsCtrl) and (ParentHwnd <> 0) do begin
          GetClassName(ParentHwnd, ClassName, 1024);
          IsDbToolsCtrl := Pos('TDACSqlEditorFrame', ClassName.ToString) <> 0;
          ParentHwnd := GetParent(ParentHwnd);
        end;
        ClassName.Free;
        if IsDbToolsCtrl and IsDbToolsShortCut(Msg.WParam) then begin
          TranslateMessage(Msg);
          Handled := DispatchMessage(Msg) = 0;
          Exit;
        end;
      end;
    end;

  if (@OldMessageProcessing <> nil) then
    OldMessageProcessing(Msg, Handled);
end;
{$ENDIF}

procedure TCREditorForm.WMActivate(var Message: TWMActivate);
var
  Control: TWinControl;
begin
  if Message.Active = WA_INACTIVE then begin
    Control := DbTools.GetActiveDACSqlEditorFrame;
    if Control <> nil then
      ActiveControl := Control;
  end;
  
  inherited;
end;

{$ENDIF}

procedure TCREditorForm.CheckConnection(const Component: TComponent);
var
  Connection: TCustomDAConnection;
begin
  if Component is TCustomDAConnection then
    Connection := TCustomDAConnection(Component)
  else begin
    Connection := FDADesignUtilsClass.UsedConnection(Component);
    if Connection = nil then
      DatabaseError(SConnectionNotDefined);
  end;
  if not Connection.Connected then begin
    Connection.Connect;
  {$IFDEF DBTOOLS}
    DBTools.CheckConnectionChanges;
  {$ENDIF}
  end;
end;

end.
