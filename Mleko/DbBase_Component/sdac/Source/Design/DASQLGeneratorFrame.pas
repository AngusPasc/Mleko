
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright � 1998-2005 Core Lab. All right reserved.
//  SQLGenerator Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DASQLGeneratorFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,
{$ENDIF}
{$IFDEF LINUX}
  QStdCtrls, QExtCtrls, QButtons, QControls,
{$ENDIF}
  Classes,  SysUtils,
  DBAccess, CRAccess,
  CRFrame, CRTabEditor;

type
  TDASQLGeneratorFrame = class(TCRFrame)
    pnSQLGenerator: TPanel;
    lbTableName: TLabel;
    lbKeyFieldsLabel: TLabel;
    lbUpdateFieldsLabel: TLabel;
    cbTables: TComboBox;
    btGenerate: TButton;
    lbKeyFields: TListBox;
    lbUpdateFields: TListBox;
    btGetFields: TButton;
    cbInsert: TCheckBox;
    cbUpdate: TCheckBox;
    cbDelete: TCheckBox;
    cbRefresh: TCheckBox;
    cbQuoteFields: TCheckBox;
    procedure pnSQLGeneratorResize(Sender: TObject);
    procedure btGetFieldsClick(Sender: TObject);
    procedure cbTablesChange(Sender: TObject);
    procedure cbIUDRClick(Sender: TObject);
    procedure btGenerateClick(Sender: TObject);
    procedure lbUpdateFieldsClick(Sender: TObject);
    procedure cbTablesDropDown(Sender: TObject);

  protected
    FLocalDataSet: TCustomDADataSet;
    FOnChange: TNotifyEvent;
    FLockUpdateControlsState: boolean;
    FLastGeneratedSQL,
    FLastOriginSQL,
    FOldSQL,
    FOldFilterSQL: string;
    FOldUpdatingTable: string;
    Fcb: array[TStatementType] of TCheckBox;

    FPromptlyServerRead,
    FParseTableNames: boolean;
    FActivated: boolean;

    procedure GenerateSelectFromAllFields; virtual;
    procedure SetFilterSQL(Value: string; Open: boolean = False);
    function OpenDataSet(RaiseException: boolean = False): boolean;
    procedure InitTables(DeleteBadTableNames: boolean = False);
    procedure ClearFields;
    procedure GetFields(Forced: boolean = False);
    procedure UpdateControlsState; virtual;

    function GetOriginLocalDataSet: TCustomDADataSet;
    function GetLocalDataSet: TCustomDADataSet;

    function GetTablesInfo: TCRTablesInfo; virtual;
    function SelectedTableName: string; virtual;
    function NormSelectedTableName: string; virtual;
    function UnqSelectedTableName: string;

    procedure SetControlEnabled(Control: TControl; Value: boolean);
    function cbChecked(StatementType: TStatementType): boolean;

    property LocalDataSet: TCustomDADataSet read GetLocalDataSet;
    property OriginLocalDataSet: TCustomDADataSet read GetOriginLocalDataSet;    
    property TablesInfo: TCRTablesInfo read GetTablesInfo;

    procedure DoActivate; override;
    procedure DoFinish; override;

    function GenerateSQLforUpdTable(TableInfo: TCRTableInfo;
      const KeyAndDataFields: TKeyAndDataFields;
      const StatementType: TStatementType;
      const ModifiedFieldsOnly: boolean): string; virtual;
  public
    constructor Create(AOwner: TComponent); override;

    function ActiveControl: TWinControl; override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

  end;

implementation

{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R DASQLGeneratorFrame.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}

uses
  DB, DAQueryEditor, DAUpdateSQLEditor, DAUpdateSQLFrame, MemData;

constructor TDASQLGeneratorFrame.Create(AOwner: TComponent);
var
  st: TStatementType;
begin
  inherited;
  for st := Low(TStatementType) to High(TStatementType) do
    Fcb[st] := nil;
  Fcb[stInsert] := cbInsert;
  Fcb[stUpdate] := cbUpdate;
  Fcb[stDelete] := cbDelete;
  Fcb[stRefresh] := cbRefresh;
  FPromptlyServerRead := True;
  FParseTableNames := False;
  FActivated := False;
end;

procedure TDASQLGeneratorFrame.SetControlEnabled(Control: TControl; Value: boolean);
begin
{$IFNDEF LINUX}
  if not Value and (Editor.ActiveControl = Control) then
    Editor.ActiveControl := Control.Parent;
{$ENDIF}

  Control.Enabled := Value;
end;

function TDASQLGeneratorFrame.cbChecked(StatementType: TStatementType): boolean;
begin
  Result := (Fcb[StatementType] <> nil) and Fcb[StatementType].Enabled
    and Fcb[StatementType].Checked and Fcb[StatementType].Visible;
end;

function TDASQLGeneratorFrame.GetOriginLocalDataSet: TCustomDADataSet;
begin
  Result := nil;
  if FEditor is TDAQueryEditorForm then
    Result := TDAQueryEditorForm(FEditor).LocalComponent as TCustomDADataSet
  else
  if FEditor is TDAUpdateSQLEditorForm then
    Result := TDAUpdateSQLEditorForm(FEditor).LocalDataSet
  else
    Assert(False);
end;

function TDASQLGeneratorFrame.GetLocalDataSet: TCustomDADataSet;
begin
  if FLocalDataSet = nil then begin
    FLocalDataSet := TComponentClass(OriginLocalDataSet.ClassType).Create(nil) as TCustomDADataSet;
    FLocalDataSet.Assign(OriginLocalDataSet);
    TDBAccessUtils.SetDesigning(FLocalDataSet, csDesigning in OriginLocalDataSet.ComponentState);
  end;
  Result := FLocalDataSet;
end;

function TDASQLGeneratorFrame.GetTablesInfo: TCRTablesInfo;
begin
  Result := TDBAccessUtils.GetTablesInfo(LocalDataSet);
end;

function TDASQLGeneratorFrame.SelectedTableName: string;
begin
  Result := TablesInfo.TableInfoClass.NormalizeName(Trim(cbTables.Text), LocalDataSet.Options.QuoteNames);
end;

function TDASQLGeneratorFrame.NormSelectedTableName: string;
begin
  Result := TablesInfo.TableInfoClass.NormalizeName(Trim(cbTables.Text)); // Without QuoteName!
end;

function TDASQLGeneratorFrame.UnqSelectedTableName: string;
begin
  Result := TablesInfo.TableInfoClass.UnQuote(Trim(cbTables.Text));
end;

function TDASQLGeneratorFrame.ActiveControl: TWinControl;
begin
  Result := cbTables;
end;

procedure TDASQLGeneratorFrame.GenerateSelectFromAllFields;
begin
  LocalDataSet.SQL.Text := 'SELECT * FROM ' + SelectedTableName;
end;

procedure TDASQLGeneratorFrame.SetFilterSQL(Value: string; Open: boolean = False);
var
  OldDebug: boolean;
begin
  OldDebug := LocalDataSet.Debug;
  try
    LocalDataSet.Debug := False;
    LocalDataSet.FilterSQL := Value;
    if Open then
      LocalDataSet.Open;
  finally
    LocalDataSet.Debug := OldDebug;
  end;
end;

function TDASQLGeneratorFrame.OpenDataSet(RaiseException: boolean = False): boolean;
begin
  Result := True;
  try
    Editor.CheckConnection(LocalDataSet);
    SetFilterSQL('1=0', True);
  except
    Result := False;
    if RaiseException then
      raise;
  end;
end;

procedure TDASQLGeneratorFrame.InitTables(DeleteBadTableNames: boolean = False);
var
  i, n, ItemIndex: integer;
  s: string;
begin
  cbTables.Items.BeginUpdate;
  try
  {$IFDEF LINUX}
    if (cbTables.Items.Count = 1) and (cbTables.Items[0] = '') then
      cbTables.Items.Clear;
  {$ENDIF}
    if DeleteBadTableNames then begin
      i := 0;
      while i < cbTables.Items.Count do
        if cbTables.Items.Objects[i] = nil then
          cbTables.Items.Delete(i)
        else
          Inc(i);
    end;

    SetFilterSQL('1=0');
    ItemIndex := -1;
    if FParseTableNames or OpenDataSet then
      for i := 0 to TablesInfo.Count - 1 do begin
        s := Trim(TablesInfo[i].TableName);
        n := cbTables.Items.IndexOf(s);
        if n = -1 then
          n := cbTables.Items.Add(s);
        if i = 0 then
          ItemIndex := n;
      end;

    if (Trim(cbTables.Text) = '') and (FOldUpdatingTable <> '') then
        cbTables.Text := FOldUpdatingTable
    else
    if (ItemIndex <> -1) and (Trim(OriginLocalDataSet.SQL.Text) <> FLastOriginSQL)
      and (cbTables.Items[ItemIndex] <> cbTables.Text) then begin
      FLastOriginSQL := Trim(OriginLocalDataSet.SQL.Text);
      ClearFields;
      cbTables.ItemIndex := ItemIndex;
    end;
  finally
  {$IFDEF LINUX}
    if cbTables.Items.Count = 0 then
      cbTables.Items.Add('');
  {$ENDIF}
    cbTables.Items.EndUpdate;
  end;
end;

procedure TDASQLGeneratorFrame.ClearFields;
begin
  lbKeyFields.Items.Clear;
  lbUpdateFields.Items.Clear;
end;

procedure TDASQLGeneratorFrame.GetFields(Forced: boolean = False);
var
  KeyAndDataFields: TKeyAndDataFields;
  OriginKeyList,
  OriginDataList: TStringList;

  function EmptyLists: boolean;
  begin
    Result := (lbKeyFields.Items.Count = 0) and (lbUpdateFields.Items.Count = 0);
  end;

  procedure GetFieldNames;
  var
    j: integer;
    Empty: boolean;

    procedure AddFieldName(LB: TListBox; Name: string; const FieldList: TStringList; Selected: boolean);
    begin
      if LB.Items.IndexOf(Name) < 0 then begin
        if Selected and (FieldList.Count <> 0) then
          Selected := FieldList.IndexOf(Name) >= 0;
        LB.Selected[LB.Items.Add(Name)] := Selected;
      end;
    end;

  begin
    try
      Empty := EmptyLists;
      for j := 0 to High(KeyAndDataFields.KeyFieldDescs) do begin
        AddFieldName(lbKeyFields, KeyAndDataFields.KeyFieldDescs[j].ActualName, OriginKeyList, Empty);
      end;
      for j := 0 to High(KeyAndDataFields.DataFieldDescs) do begin
        AddFieldName(lbKeyFields, KeyAndDataFields.DataFieldDescs[j].ActualName, OriginKeyList, False);
        AddFieldName(lbUpdateFields, KeyAndDataFields.DataFieldDescs[j].ActualName, OriginDataList, Empty);
      end;

    except
      ClearFields;
      raise;
    end;
  end;

  procedure InitFields(OriginFields: boolean);
  var
    i: integer;

  begin
    if OriginFields then begin
      SetLength(KeyAndDataFields.KeyFieldDescs, 0);
      SetLength(KeyAndDataFields.DataFieldDescs, 0);
    end;
    if not OpenDataSet(not OriginFields) or (OriginFields and not EmptyLists) then
      Exit;

    if TablesInfo.IndexByName(SelectedTableName) = -1 then begin
      ClearFields;
      Exit;
    end;

    TDBAccessUtils.SetUpdatingTable(LocalDataSet, SelectedTableName);
    TDBAccessUtils.GetKeyAndDataFields(LocalDataSet, KeyAndDataFields, False);

    if OriginFields then begin
      for i := 0 to High(KeyAndDataFields.KeyFieldDescs) do
        OriginKeyList.Add(KeyAndDataFields.KeyFieldDescs[i].ActualName);
      for i := 0 to High(KeyAndDataFields.DataFieldDescs) do
        OriginDataList.Add(KeyAndDataFields.DataFieldDescs[i].ActualName);
    end
    else
    if not Forced then
      try
        GetFieldNames;
      finally
        UpdateControlsState;
      end;
  end;

var
  i: integer;

begin
  if not (EmptyLists or Forced) or (UnqSelectedTableName = '') then
    Exit;

  if (TDBAccessUtils.UsedConnection(LocalDataSet) <> nil) then
    Editor.CheckConnection(LocalDataSet);

  try
    OriginKeyList := TStringList.Create;
    OriginDataList := TStringList.Create;
    if FOldSQL <> LocalDataSet.SQL.Text then
      LocalDataSet.SQL.Text := FOldSQL;
    InitFields(True);
    if EmptyLists then begin
      GenerateSelectFromAllFields;
      FLastGeneratedSQL := LocalDataSet.SQL.Text;
    end
    else
      LocalDataSet.SQL.Text := FLastGeneratedSQL;

    InitFields(False);
    i := cbTables.Items.IndexOf(SelectedTableName);
    if i < 0 then
      i := cbTables.Items.Add(SelectedTableName);
    cbTables.Items.Objects[i] := Self; // Mark good table
  finally
    OriginKeyList.Free;
    OriginDataList.Free;
  end;
end;

procedure TDASQLGeneratorFrame.UpdateControlsState;
var
  TableName: string;
  sts: TStatementTypes;
  st: TStatementType;
  IsEnabled: boolean;
begin
  if FLockUpdateControlsState then
    Exit;

  Assert(LocalDataSet <> nil);

  sts := TDBAccessUtils.GetUpdateSQLStatementTypes(LocalDataSet);

  TableName := SelectedTableName;
  IsEnabled := TableName <> '';
  SetControlEnabled(btGetFields, IsEnabled and (lbUpdateFields.Items.Count + lbUpdateFields.Items.Count = 0));

  SetControlEnabled(cbInsert, IsEnabled and (lbUpdateFields.SelCount > 0));
  SetControlEnabled(cbUpdate, IsEnabled and (lbKeyFields.SelCount > 0) and (lbUpdateFields.SelCount > 0));
  SetControlEnabled(cbDelete, IsEnabled and (lbKeyFields.SelCount > 0));
  SetControlEnabled(cbRefresh, IsEnabled and (lbKeyFields.SelCount > 0) and (lbUpdateFields.SelCount > 0) {and TableNameSelectedFromList});

  if IsEnabled then
    for st := Low(TStatementType) to High(TStatementType) do
      if st in sts then begin
        IsEnabled := cbChecked(st);
        if IsEnabled then
          Break;
      end;
  SetControlEnabled(btGenerate, IsEnabled);
  SetControlEnabled(cbQuoteFields, IsEnabled);
end;

procedure TDASQLGeneratorFrame.pnSQLGeneratorResize(Sender: TObject);
begin
  lbKeyFields.Width := (lbUpdateFields.Left + lbUpdateFields.Width - lbKeyFields.Left - 8) div 2;
  lbUpdateFields.Left := lbUpdateFields.Left - (lbKeyFields.Width - lbUpdateFields.Width);
  lbUpdateFields.Width := lbKeyFields.Width;
  lbUpdateFieldsLabel.Left := lbUpdateFields.Left;
end;

procedure TDASQLGeneratorFrame.btGetFieldsClick(Sender: TObject);
begin
  GetFields;
end;

procedure TDASQLGeneratorFrame.cbTablesChange(Sender: TObject);
begin
  ClearFields;
  if FPromptlyServerRead and (cbTables.Items.IndexOf(SelectedTableName) <> -1) then
    GetFields;
  UpdateControlsState;
end;

procedure TDASQLGeneratorFrame.DoActivate;
var
  OldSQL: string;
begin
  FOldUpdatingTable := TDBAccessUtils.GetUpdatingTable(LocalDataSet);
  OldSQL := LocalDataSet.SQL.Text;
  FOldFilterSQL := LocalDataSet.FilterSQL;
  try
    inherited;
    if OriginLocalDataSet.SQL.Text <> LocalDataSet.SQL.Text then
      LocalDataSet.SQL := OriginLocalDataSet.SQL;

    if not FActivated then
      cbQuoteFields.Checked := LocalDataSet.Options.QuoteNames;

    if ((TDBAccessUtils.UsedConnection(LocalDataSet) <> nil) and
      TDBAccessUtils.UsedConnection(LocalDataSet).Connected and
      (FOldSQL <> LocalDataSet.SQL.Text) and
      FPromptlyServerRead) or FParseTableNames then
      InitTables(FParseTableNames);
      
    FActivated := True;
  finally
    FOldSQL := OldSQL; // always call; see DoFinish for details
    UpdateControlsState;
  end;
  if FPromptlyServerRead then
    GetFields;
end;

procedure TDASQLGeneratorFrame.DoFinish;
begin
  inherited;

  LocalDataSet.Close;
  if FOldSQL <> LocalDataSet.SQL.Text then
    LocalDataSet.SQL.Text := FOldSQL;
  if FOldFilterSQL <> LocalDataSet.FilterSQL then
    SetFilterSQL(FOldFilterSQL);

  if FOldUpdatingTable <> TDBAccessUtils.GetUpdatingTable(LocalDataSet) then
    TDBAccessUtils.SetUpdatingTable(LocalDataSet, FOldUpdatingTable);
    
  FLocalDataSet.Free;
  FLocalDataSet := nil;
end;

procedure TDASQLGeneratorFrame.cbIUDRClick(Sender: TObject);
begin
  inherited;
  UpdateControlsState;
end;

function TDASQLGeneratorFrame.GenerateSQLforUpdTable(
  TableInfo: TCRTableInfo; const KeyAndDataFields: TKeyAndDataFields;
  const StatementType: TStatementType; const ModifiedFieldsOnly: boolean): string;
begin
  Result := TDBAccessUtils.SQLGenerator(LocalDataSet).GenerateSQLforUpdTable(TableInfo, KeyAndDataFields, StatementType, ModifiedFieldsOnly, nil);
end;

procedure TDASQLGeneratorFrame.btGenerateClick(Sender: TObject);
var
  i, j: integer;
  KeyAndDataFields: TKeyAndDataFields;

  TableInfo: TCRTableInfo;
  UpdateSQLFrame: TDAUpdateSQLFrame;

  OldSQL: string;
  OldActive: boolean;
  st: TStatementType;
  sts: TStatementTypes;
  stSQL: array[TStatementType] of string;
  OldQuoteNames: boolean;

begin
  GetFields(True);
  OldSQL := LocalDataSet.SQL.Text;
  OldActive := LocalDataSet.Active;
  OldQuoteNames := LocalDataSet.Options.QuoteNames;
  try
    if LocalDataSet.SQL.Text <> FLastGeneratedSQL then
      LocalDataSet.SQL.Text := FLastGeneratedSQL;
    OpenDataSet(True);
    TableInfo := TablesInfo.TableInfoClass.Create(nil);
    try
      TableInfo.IsView := False; // Use to generate only specified fields
      TableInfo.TableName := NormSelectedTableName;
      TableInfo.TableNameFull := TableInfo.TableName;
      TableInfo.TableAlias := '';

      SetLength(KeyAndDataFields.KeyFieldDescs, lbKeyFields.SelCount);
      j := 0;
      for i := 0 to lbKeyFields.Items.Count - 1 do
        if lbKeyFields.Selected[i] then begin
          KeyAndDataFields.KeyFieldDescs[j] := LocalDataSet.GetFieldDesc(lbKeyFields.Items[i]) as TCRFieldDesc;
          Inc(j);
        end;

      SetLength(KeyAndDataFields.DataFieldDescs, lbUpdateFields.SelCount);
      j := 0;
      for i := 0 to lbUpdateFields.Items.Count - 1 do
        if lbUpdateFields.Selected[i] then begin
          KeyAndDataFields.DataFieldDescs[j] := LocalDataSet.GetFieldDesc(lbUpdateFields.Items[i]) as TCRFieldDesc;
          Inc(j);
        end;

      LocalDataSet.Options.QuoteNames := cbQuoteFields.Checked;

      sts := Editor.DADesignUtilsClass.GetStatementTypes;
      try
        for st := Low(TStatementType) to High(TStatementType) do
          if (st in sts) and cbChecked(st) then begin
            stSQL[st] := GenerateSQLforUpdTable(TableInfo, KeyAndDataFields, st, False);
            Modified := True;
          end;

        // after setting SQL Fields[] may be destroyed
        SetLength(KeyAndDataFields.KeyFieldDescs, 0); // Just in case
        SetLength(KeyAndDataFields.DataFieldDescs, 0);
        for st := Low(TStatementType) to High(TStatementType) do
          if (st in sts) and cbChecked(st) then
            Editor.DADesignUtilsClass.SetSQL(Editor.LocalComponent, stSQL[st], st);

      finally
        UpdateSQLFrame := nil;
        if FEditor is TDAUpdateSQLEditorForm then
          UpdateSQLFrame := TDAUpdateSQLEditorForm(FEditor).UpdateSQLFrame
        else
        if FEditor is TDAQueryEditorForm then
          UpdateSQLFrame := TDAQueryEditorForm(FEditor).UpdateSQLFrame
        else
          Assert(False);

        for st := Low(TStatementType) to High(TStatementType) do
          if (st in sts) and cbChecked(st) then begin
            UpdateSQLFrame.SetStatementType(st);
            Break;
          end;

        if FEditor is TDAUpdateSQLEditorForm then
          TDAUpdateSQLEditorForm(FEditor).ActivateFrame(UpdateSQLFrame)
        else
          TDAQueryEditorForm(FEditor).ActivateFrame(UpdateSQLFrame);
      end;
    finally
      TableInfo.Free;
    end;
  finally
    LocalDataSet.Options.QuoteNames := OldQuoteNames;
    if not OldActive then
      LocalDataSet.SQL.Text := OldSQL;
  end;
end;

procedure TDASQLGeneratorFrame.lbUpdateFieldsClick(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TDASQLGeneratorFrame.cbTablesDropDown(Sender: TObject);
begin
  if FParseTableNames then
    InitTables
  else
    if ((TDBAccessUtils.UsedConnection(LocalDataSet) <> nil) and
      ((cbTables.Items.Count = 0) {$IFDEF LINUX}or (cbTables.Items.Count = 1) and
      (cbTables.Items[0] = ''){$ENDIF})) then begin
      InitTables;
      cbTablesChange(nil);
    end;
end;

end.
