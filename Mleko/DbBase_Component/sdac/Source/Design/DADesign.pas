
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright @ 1998-2007 Core Lab. All right reserved.
//  DADesign
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DADesign;
{$ENDIF}
interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  Registry, StdCtrls,
{$IFDEF CLR}
  Borland.Vcl.Design.DesignEditors, Borland.Vcl.Design.DesignIntf,
  Borland.Vcl.Design.FldLinks,
  System.Runtime.InteropServices,
{$ELSE}
  {$IFDEF VER6P}DesignIntf, DesignEditors,{$ELSE}DsgnIntf,{$ENDIF}
  {$IFNDEF BCB}{$IFDEF VER5P}FldLinks, {$ENDIF}ColnEdit, {$ELSE}CRFldLinks,{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IFDEF LINUX}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  DesignIntf, DesignEditors, CRFldLinks,
{$ENDIF}
{$IFDEF DBTOOLS}
  Menus,
  {$IFDEF CLR}Borland.Vcl.Design.DesignMenus{$ELSE}DesignMenus{$ENDIF},
  DBToolsIntf,
  DBToolsClient,
{$ENDIF}
  SysUtils, Classes, TypInfo, DBAccess, DAScript, DALoader, DADump,
  CRFrame, CREditor, DADesignUtils, CRParser;

  procedure ConvertToClass(Designer:{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}; Component: TComponent; NewClass: TComponentClass);

{ ------------  DAC property editors ----------- }
type
  TDAFieldsEditor = class (TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TDAPropertyEditor = class (TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TDAPasswordProperty = class(TStringProperty)
  protected
    FActivated: boolean;
{$IFNDEF CLR}
  public
{$ENDIF}
    procedure Initialize; override;
{$IFDEF CLR}
  public
{$ENDIF}
    procedure Activate; override;
    function GetValue: string; override;
  end;

  TDATableNameEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TDAUpdatingTableEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TDADatabaseNameEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TDASPNameEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TDAFieldDefsListEditor = class (TStringProperty) // TDATableOrderFieldsEditor
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TDAFieldsListEditor = class (TStringProperty) // TDADataSetIndexFieldNamesEditor
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TDALoaderTableNameEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

{$IFDEF LINUX}
  TDADataSetMasterFieldsEditor = class (TCRFieldLinkProperty)
{$ELSE}
{$IFDEF BCB}
  TDADataSetMasterFieldsEditor = class (TCRFieldLinkProperty)
{$ELSE}
  TDADataSetMasterFieldsEditor = class (TFieldLinkProperty)
{$ENDIF}
{$ENDIF}
  protected
    function GetMasterFields: string; override;
    procedure SetMasterFields(const Value: string); override;
    function GetIndexFieldNames: string; override;
    procedure SetIndexFieldNames(const Value: string); override;
  end;

  TVariantEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TDADatasetOrSQLProperty = class(TComponentProperty)
  private
    FCheckProc: TGetStrProc;
    procedure CheckComponent(const Value: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TDAUpdateSQLProperty = class(TComponentProperty)
  private
    FCheckProc: TGetStrProc;
    procedure CheckComponent(const Value: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TCustomDAConnectionClass = class of TCustomDAConnection;

  TDAConnectionList = class
  private
    procedure ListBoxDblClick(Sender: TObject);
    procedure ListBoxKeyPress(Sender: TObject; var Key: Char);
  {$IFDEF CLR}
    procedure FormShow(Sender: TObject);
  {$ENDIF}

  protected
    Items: TStrings;
    Form: TForm;
  {$IFDEF CLR}
    FormLeft: integer;
    FormTop: integer;
  {$ENDIF}
  
    procedure StrProc(const S: string);
    function GetConnectionType: TCustomDAConnectionClass; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConnection(Component: TComponent; Designer: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}): TCustomDAConnection;
  end;

{$IFDEF VER6P}

  TDAConnectionListClass = class of TDAConnectionList;

  TDADesignNotification = class(TInterfacedObject, IDesignNotification)
  protected
    FItem: TPersistent;
    FConnectionList: TDAConnectionList;
    DSItems: TStrings;
    procedure StrProc(const S: string);
    procedure DSStrProc(const S: string);
  public
    procedure ItemDeleted(const ADesigner: IDesigner; AItem: TPersistent); virtual;
    //overide this method on Product level and add all product specific classess
    procedure ItemInserted(const ADesigner: IDesigner; AItem: TPersistent); virtual; abstract;
    procedure ItemsModified(const ADesigner: IDesigner); virtual;
    procedure SelectionChanged(const ADesigner: IDesigner;
      const ASelection: IDesignerSelections); virtual;
    procedure DesignerOpened(const ADesigner: IDesigner
      {$IFNDEF K1}; AResurrecting: Boolean{$ENDIF}); virtual;
    procedure DesignerClosed(const ADesigner: IDesigner
      {$IFNDEF K1}; AGoingDormant: Boolean{$ENDIF}); virtual;

    function CreateConnectionList: TDAConnectionList; virtual; abstract;
    function GetConnectionPropertyName: string; virtual; abstract;
  end;
{$ENDIF}

{ ------------  DAC component editors ----------- }
type
  TVerbMethod = procedure of object;
  TVerb = record
    Caption: string;
    Method: TVerbMethod;
  end;
  TVerbs = array of TVerb;

  TDAComponentEditorClass = class of TDAComponentEditor;
  TDAComponentEditor = class (TComponentEditor)
  protected
    FCREditorClass: TCREditorClass;
    FDADesignUtilsClass: TDADesignUtilsClass;

    FVerbs: TVerbs;
  {$IFDEF DBTOOLS}
    FDBToolsVerbs: TDBToolsVerbs;
    FDBToolsSingleVerb: TDBToolsVerb;
    FDBToolsVerbIndex: integer;
  {$ENDIF}
    function AddVerb(const Caption: string; Method: TVerbMethod): integer; overload;
    function AddVerb(const Caption: string; CREditorClass: TCREditorClass; DADesignUtilsClass: TDADesignUtilsClass): integer; overload;
    procedure InitVerbs; virtual;

    procedure ShowEditor; overload;
    procedure ShowEditor(const InitialProperty: string); overload;
  {$IFDEF DBTOOLS}
    procedure AddDBToolsVerbs(Verbs: TDBToolsVerbs);
    procedure DBToolsMenuExecute;
  {$ENDIF}
  public
    constructor Create(AComponent: TComponent; ADesigner: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}); override;

    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
    procedure Edit; override;
  {$IFDEF DBTOOLS}
    procedure PrepareItem(Index: integer; const AItem: IMenuItem); override;
  {$ENDIF}
  end;

  TDAConnectionEditor = class(TDAComponentEditor);

  TDASQLEditor = class(TDAComponentEditor);

  TDAScriptEditor = class(TDAComponentEditor);

  TDAUpdateSQLEditor = class(TDAComponentEditor);

  TDADataSetEditor = class(TDAComponentEditor)
  private
{$IFDEF MSWINDOWS}
{$IFNDEF VER8}
    procedure ExecuteDsmAction(const ProcName: string);
    procedure DsmCreateDefaultControl;
    procedure DsmShowInDataSetManager;
    procedure Separator;
{$ENDIF}
{$ENDIF}
  protected
    procedure ShowFieldsEditor;
    procedure ShowDataEditor;
{$IFDEF MSWINDOWS}
{$IFNDEF VER8}
    procedure InitVerbs; override;
{$ENDIF}
{$ENDIF}
  end;

  TDALoaderEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
    procedure ShowColEditor;
    procedure CreateColumns;
  end;

{$IFDEF MSWINDOWS}
  TDASQLMonitorEditor = class (TDAComponentEditor)
  protected
    procedure RunDBMonitor;
    procedure RunSQLMonitor;
    procedure InitVerbs; override;
  public
    procedure Edit; override;
  end;
{$ENDIF}

  TCRDataSourceEditor = class(TDAComponentEditor)
  private
    Items: TStrings;
    FFirstProp: {$IFDEF VER6P}IProperty{$ELSE}TPropertyEditor{$ENDIF};
    procedure StrProc(const S: string);
    procedure ConvertToDataSource;
    procedure CheckEdit({$IFDEF VER6P}const Prop: IProperty{$ELSE}Prop: TPropertyEditor{$ENDIF});
  protected
    procedure InitVerbs; override;
  public
    constructor Create(Component: TComponent; aDesigner: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}); override;
    procedure Edit; override;
  end;

  TDesignMacros = class(TMacros)
  protected
    function GetMacroValue(Macro: TMacro): string; override;
  public
    procedure Scan(var SQL: string); reintroduce;
  end;

procedure Register;
procedure DARegisterComponentEditor(ComponentClass: TComponentClass; ComponentEditor: TDAComponentEditorClass;
  CREditorClass: TCREditorClass;
  DADesignUtilsClass: TDADesignUtilsClass);
procedure ShowEditor(
  CREditorClass: TCREditorClass;
  DADesignUtilsClass: TDADesignUtilsClass;
  Component: TComponent;
  Designer:{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF};
  InitialProperty: string = ''
);

implementation

uses
{$IFDEF CLR}
  Borland.Studio.ToolsAPI, Borland.VCL.Design.DSDesign, Borland.Vcl.Design.ColnEdit,
  MemUtils,
{$ELSE}
  ToolsAPI,
{$IFNDEF BCB}
{$IFNDEF LINUX}
  DSDesign,
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IFDEF VER6P}
  Variants,
{$ENDIF}
{$IFDEF MSWINDOWS}
  DBMonitorClient, DASQLMonitor, ShellAPI,
{$ENDIF}
{$IFDEF DBTOOLS}
  Download,
{$ENDIF}
  DB, CRAccess,
  DAConnectionEditor, DATableEditor, DAQueryEditor, DASQLEditor, DADataEditor, CRTabEditor,
  DAStoredProcEditor, DAScriptEditor, DADumpEditor,
  DAParamsFrame, DAMacrosFrame, DAConsts;

type
  TDAComponentInfo = record
    ComponentClass: TComponentClass;
    ComponentEditor: TDAComponentEditorClass;
    CREditorClass: TCREditorClass;
    DADesignUtilsClass: TDADesignUtilsClass
  end;

var
  ComponentsInfo: array of TDAComponentInfo;
  NotificationActive: boolean;

procedure DARegisterComponentEditor(ComponentClass: TComponentClass; ComponentEditor: TDAComponentEditorClass;
  CREditorClass: TCREditorClass;
  DADesignUtilsClass: TDADesignUtilsClass);
var
  i: integer;
begin
  RegisterComponentEditor(ComponentClass, ComponentEditor);
  i := Length(ComponentsInfo);
  SetLength(ComponentsInfo, i + 1);
  ComponentsInfo[i].ComponentClass := ComponentClass;
  ComponentsInfo[i].ComponentEditor := ComponentEditor;
  ComponentsInfo[i].CREditorClass := CREditorClass;
  ComponentsInfo[i].DADesignUtilsClass := DADesignUtilsClass;
end;

procedure ConvertToClass(Designer:{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}; Component: TComponent; NewClass: TComponentClass);
type
  TPropData = record
    Component: TComponent;
    PropInfo: PPropInfo;
  end;
var
  AName: string;
  NewComponent: TComponent;
  DesignInfo: Longint;
  Instance: TComponent;

  FreeNotifies: TList;
  i, j, PropCount: integer;
{$IFDEF CLR}
  PropList: TPropList;
{$ELSE}
  PropList: PPropList;
{$ENDIF}
  Refs: array of TPropData;
  l: integer;

  Root: TComponent;
  OldNotificationActive: boolean;
begin
  DesignInfo := Component.DesignInfo;
  OldNotificationActive := NotificationActive;
  try
    NotificationActive := False;
    NewComponent := Designer.CreateComponent(NewClass, Component.Owner,
      Word(DesignInfo {$IFDEF CLR}shr 16{$ENDIF}), Word(DesignInfo  {$IFNDEF CLR}shr 16{$ENDIF}), 28, 28);
  finally
    NotificationActive := OldNotificationActive;
  end;
  AName := Component.Name;
  Component.Name := 'CRTemp_' + AName;
  FreeNotifies := TList.Create;
  try
{$IFDEF VER6P}
    Root := Designer.Root;
{$ELSE}
    Root := Designer.ContainerWindow;
{$ENDIF}
    for i := 0 to Root.ComponentCount - 1 do begin
      FreeNotifies.Add(Root.Components[i]);
    end;
    for i := 0 to FreeNotifies.Count - 1 do begin
      Instance := TComponent(FreeNotifies[i]);
  {$IFDEF CLR}
      PropList := GetPropList(Instance.ClassInfo, [tkClass]{$IFNDEF CLR}, nil{$IFDEF VER6P}, False{$ENDIF}{$ENDIF});
      PropCount := Length(PropList);
      if PropCount > 0 then begin
  {$ELSE}
      PropCount := GetPropList(Instance.ClassInfo, [tkClass]{$IFNDEF CLR}, nil{$IFDEF VER6P}, False{$ENDIF}{$ENDIF});
      if PropCount > 0 then begin
        GetMem(PropList, PropCount * SizeOf(PropList[0]));
        try
          GetPropList(Instance.ClassInfo, [tkClass]{$IFNDEF CLR}, PropList{$IFDEF VER6P}, False{$ENDIF}{$ENDIF});
  {$ENDIF}
          for j := 0 to PropCount - 1 do begin
            if (PropList[j].PropType <> nil) and
            ({$IFDEF CLR}KindOf(PropList[j].PropType){$ELSE}PropList[j].PropType^.Kind{$ENDIF}= tkClass)
              and (TComponent(GetObjectProp(Instance, PropList[j])) = Component)
            then begin
              l := Length(Refs);
              SetLength(Refs, l + 1);
              Refs[l].Component := Instance;
              Refs[l].PropInfo := PropList[j];
            end;
          end;
  {$IFNDEF CLR}
        finally
          FreeMem(PropList);
        end;
      end;
  {$ELSE}
      end;
  {$ENDIF}
    end;
  finally
    FreeNotifies.Free;
  end;
  NewComponent.Assign(Component);
  for i := 0 to Length(Refs) - 1 do begin
    SetObjectProp(Refs[i].Component, Refs[i].PropInfo, NewComponent);
  end;
  Component.Free;
  NewComponent.Name := AName;
  Designer.Modified;
end;

type
{$IFDEF LINUX}
  {$DEFINE OLDDESIGNER}
{$ENDIF}
{$IFDEF BCB}
  {$DEFINE OLDDESIGNER}
{$ENDIF}

{$IFDEF OLDDESIGNER}
  TDADSDesigner = class (TDataSetDesigner)
  private
    FFieldsEditor: TForm; // TFieldsEditor;  // WAR For support TDSDesigner
  public
    constructor Create(DataSet: TDataSet);
    destructor Destroy; override;
    property FieldsEditor: TForm read FFieldsEditor;
  end;
{$ELSE}
  TDADSDesigner = TDSDesigner;
{$ENDIF}

{$IFDEF OLDDESIGNER}
var
  DataSetEditorClass: TComponentEditorClass;
  

{ TOraDSDesigner }
constructor TDADSDesigner.Create(DataSet: TDataSet);
begin
  inherited Create(DataSet);

  FFieldsEditor := nil;
end;

destructor TDADSDesigner.Destroy;
begin
  inherited;
end;
{$ENDIF}

procedure ShowEditor(
  CREditorClass: TCREditorClass;
  DADesignUtilsClass: TDADesignUtilsClass;
  Component: TComponent;
  Designer:{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF};
  InitialProperty: string = ''
);
var
  CREditor: TCREditorForm;
begin
  Assert(CREditorClass <> nil);
  CREditor := CREditorClass.Create(nil, DADesignUtilsClass);
  try
    CREditor.Component := Component;
    TCREditorForm(CREditor).InitialProperty := InitialProperty;
    if CREditor.ShowModal = mrOk then
      if Designer <> nil then
        Designer.Modified;
  finally
    CREditor.Free;
  end;
end;

{ TDAFieldsEditor }

function TDAFieldsEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TDAFieldsEditor.GetValue: string;
begin
  Result := '(' + DB.TFields.ClassName + ')';
end;

procedure TDAFieldsEditor.Edit;
var
  NeedCreate: boolean;
  DADSDesigner: TDADSDesigner;
  Component: TComponent;
{$IFDEF OLDDESIGNER}
  DataSetEditor: TComponentEditor;
{$ENDIF}
begin
  Component := TComponent(GetComponent(0));

  if (Component as TDataSet).Designer = nil then
    NeedCreate := True
  else
    if (Component as TDataSet).Designer is TDADSDesigner then begin
      (Component as TDataSet).Designer.Free;
      NeedCreate := True;
    end
    else
      NeedCreate := False;

  if NeedCreate then begin
  {$IFDEF OLDDESIGNER}
    DataSetEditor := DataSetEditorClass.Create(Component, Designer) as TComponentEditor;
    try
      DataSetEditor.ExecuteVerb(0);
    finally
      DataSetEditor.Free;
    end;
  {$ELSE}
    {$IFDEF CLR}Borland.VCL.Design.{$ENDIF}DSDesign.ShowFieldsEditor(Designer, TDataSet(Component), TDSDesigner);
  {$ENDIF}
  end
  else begin
    DADSDesigner := TDADSDesigner((Component as TDataSet).Designer);
    DADSDesigner.FieldsEditor.Show;
  end;
end;

{ TDAPropertyEditor }

function TDAPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TDAPropertyEditor.GetValue: string;
var
{$IFDEF CLR}
  PropInfo: TPropInfo;
{$ELSE}
  PropInfo: PPropInfo;
{$ENDIF}
  Obj: TPersistent;
begin
  Obj := nil;
  PropInfo := GetPropInfo;
  if (PropInfo <> nil) and (PropInfo.PropType{$IFNDEF CLR}^{$ENDIF}.Kind = tkClass) then begin
  {$IFDEF CLR}
    Obj := GetObjectProp(GetComponent(0), PropInfo) as TPersistent;
  {$ELSE}
    Obj := TPersistent(integer(GetPropValue(GetComponent(0), GetName)));
  {$ENDIF}
  end;
  if Obj <> nil then
    Result := '(' + GetPropType.Name + ')' // CR 19906 S
  else
    Result := inherited GetValue;
end;

procedure TDAPropertyEditor.Edit;
var
  Component: TComponent;
  i: integer;
begin
  Component := GetComponent(0) as TComponent;

  for i := 0 to Length(ComponentsInfo) - 1 do
    if Component is ComponentsInfo[i].ComponentClass then begin
      ShowEditor(ComponentsInfo[i].CREditorClass, ComponentsInfo[i].DADesignUtilsClass, Component, Designer, GetName);
      Exit;
    end;
  Assert(False);
end;

{ TDAPasswordProperty }

procedure TDAPasswordProperty.Initialize;
begin
  inherited;
  
  FActivated := False;
end;

function TDAPasswordProperty.GetValue: string;
var
  i: Integer;
begin
  Result := inherited GetValue;
  if not FActivated then begin
    for i := 1 to Length(Result) do
      Result[i] := '*';
  end
  else
    FActivated := False;
end;

procedure TDAPasswordProperty.Activate;
begin
  inherited;
  
  FActivated := True;
end;

{ TDATableNameEditor }

function TDATableNameEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDATableNameEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDATableNameEditor.GetValues(Proc: TGetStrProc);
var
  List: TStringList;
  i: integer;
  Component: TComponent;
  UsedConnection: TCustomDAConnection;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomDADataSet, Component.ClassName);

  UsedConnection := TDBAccessUtils.UsedConnection(TCustomDADataSet(Component));
  if UsedConnection = nil then
    Exit;

  List := TStringList.Create;
  try
    UsedConnection.GetTableNames(List);
    // List.Sort; 
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

{ TDAUpdatingTableEditor }

function TDAUpdatingTableEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TDAUpdatingTableEditor.GetValues(Proc: TGetStrProc);
var
  Component: TComponent;
  DataSet: TCustomDADataset;
  TablesInfo: TCRTablesInfo;
  UsedConnection: TCustomDAConnection;

  i: integer;
  OldSQL: string;
  OldActive: boolean;

begin
  Component := TComponent(GetComponent(0));
  DataSet := Component as TCustomDADataset;

  if (DataSet = nil) then
    Exit;
  UsedConnection := TDBAccessUtils.UsedConnection(DataSet);
  if (UsedConnection = nil) or not UsedConnection.Connected then
    Exit;

  OldSQL := DataSet.SQL.text;
  OldActive := DataSet.Active;
  try
    TablesInfo := TDBAccessUtils.GetTablesInfo(DataSet);
    try
      if TablesInfo.Count = 0 then begin
        DataSet.AddWhere('0=1');
        DataSet.Active := True;
        TablesInfo := TDBAccessUtils.GetTablesInfo(DataSet);
      end;

      for i := 0 to TablesInfo.Count - 1 do
        Proc(TablesInfo[i].TableName);
    except
    end;

  finally
    if DataSet.SQL.Text <> OldSQL then
      DataSet.SQL.Text := OldSQL;

    if DataSet.Active <> OldActive then
      DataSet.Active := OldActive;
  end;
end;

{ TDADatabaseNameEditor }

function TDADatabaseNameEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDADatabaseNameEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDADatabaseNameEditor.GetValues(Proc: TGetStrProc);
var
  List: TStringList;
  i: integer;
  Component: TComponent;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomDAConnection, Component.ClassName);

  List := TStringList.Create;
  try
    TCustomDAConnection(Component).GetDatabaseNames(List);
    List.Sort;
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

{ TDASPNameEditor }

function TDASPNameEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDASPNameEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDASPNameEditor.GetValues(Proc: TGetStrProc);
var
  List: TStringList;
  i: integer;
  Component: TComponent;
  UsedConnection: TCustomDAConnection;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomDADataSet, Component.ClassName);

  UsedConnection := TDBAccessUtils.UsedConnection(TCustomDADataSet(Component));
  if UsedConnection = nil then
    Exit;

  List := TStringList.Create;
  try
    UsedConnection.GetStoredProcNames(List);
    List.Sort;
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

{ TDAFieldDefsListEditor }

function TDAFieldDefsListEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDAFieldDefsListEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDAFieldDefsListEditor.GetValues(Proc: TGetStrProc);
var
  i: integer;
  Component: TComponent;
  Table: TCustomDADataSet;
  DataSetUtils: TDADataSetUtils;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomDADataSet, Component.ClassName);

  DataSetUtils := TDADataSetUtils.Create;
  try
    Table := TCustomDADataSet(GetComponent(0));
    DataSetUtils.QuickOpen(Table);

    for i := 0 to Table.FieldDefs.Count - 1 do
      Proc(Table.FieldDefs[i].Name);

  finally
    DataSetUtils.Restore(True);
    DataSetUtils.Free;
  end;
end;

{ TDAFieldsListEditor }

function TDAFieldsListEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDAFieldsListEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDAFieldsListEditor.GetValues(Proc: TGetStrProc);
var
  i: integer;
  Component: TComponent;
  Table: TCustomDADataSet;
  DataSetUtils: TDADataSetUtils;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomDADataSet, Component.ClassName);

  DataSetUtils := TDADataSetUtils.Create;
  try
    Table := TCustomDADataSet(GetComponent(0));
    DataSetUtils.QuickOpen(Table);

    for i := 0 to Table.Fields.Count - 1 do
      Proc(Table.Fields[i].FieldName);

  finally
    DataSetUtils.Restore(True);
    DataSetUtils.Free;
  end;
end;

{ TDALoaderTableNameEditor }

function TDALoaderTableNameEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TDALoaderTableNameEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TDALoaderTableNameEditor.GetValues(Proc: TGetStrProc);
var
  List: TStrings;
  i: integer;
  UsedConnection: TCustomDAConnection;
begin
  List := TStringList.Create;
  try
    UsedConnection := TDALoaderUtils.UsedConnection(TDALoader(GetComponent(0)));
    if UsedConnection = nil then
      exit;
    UsedConnection.GetTableNames(List);
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;


{ TDADataSetMasterFieldsEditor }

function TDADataSetMasterFieldsEditor.GetMasterFields: string;
begin
  Result := (DataSet as TCustomDADataSet).MasterFields;
end;

procedure TDADataSetMasterFieldsEditor.SetMasterFields(const Value: string);
begin
  (DataSet as TCustomDADataSet).MasterFields := Value;
end;

function TDADataSetMasterFieldsEditor.GetIndexFieldNames: string;
begin
  Result := (DataSet as TCustomDADataSet).DetailFields;
end;

procedure TDADataSetMasterFieldsEditor.SetIndexFieldNames(const Value: string);
begin
  (DataSet as TCustomDADataSet).DetailFields := Value;
end;

{ TVariantEditor }

function TVariantEditor.GetAttributes: TPropertyAttributes;
begin
  if VarIsArray(GetVarValue) then
    Result := [paReadOnly]
  else
    Result := inherited GetAttributes;
end;

function TVariantEditor.GetValue: string;
begin
  if VarIsArray(GetVarValue) then
    Result := '<Array>'
  else
    Result := GetVarValue;//inherited GetValue;
end;

procedure TVariantEditor.SetValue(const Value: string);
begin
  SetVarValue(Value);
end;

{ TDADatasetOrSQLProperty }

procedure TDADatasetOrSQLProperty.CheckComponent(const Value: string);
var
  i: integer;
  Component: TComponent;
  AClass: TClass;
  DataSetClass: TCustomDADataSetClass;
  SQLClass: TCustomDASQLClass;
  UpdateSQL: TCustomDAUpdateSQL;
begin
  DataSetClass := nil;
  SQLClass := nil; 
  Component := Designer.GetComponent(Value);
  if Component <> nil then begin
    for i := 0 to PropCount - 1 do begin
      UpdateSQL := TCustomDAUpdateSQL(GetComponent(i));
      if UpdateSQL.Dataset = Component then
        Exit;
      if (i = 0) or (DataSetClass <> nil) then begin
        AClass := TDBAccessUtils.GetDataSetClass(UpdateSQL);
        if (i > 0) and (AClass <> DataSetClass) then
          DataSetClass := nil
        else
          DataSetClass := TCustomDADataSetClass(AClass);
      end;
      if (i = 0) or (SQLClass <> nil) then begin
        AClass := TDBAccessUtils.GetSQLClass(UpdateSQL);
        if (i > 0) and (AClass <> SQLClass) then
          SQLClass := nil
        else
          SQLClass := TCustomDASQLClass(AClass);
      end;
    end;
    if not ((Component is SQLClass) or (Component is DataSetClass)) then
      Exit;
  end;
  FCheckProc(Value);
end;

procedure TDADatasetOrSQLProperty.GetValues(Proc: TGetStrProc);
begin
  FCheckProc := Proc;
  inherited GetValues(CheckComponent);
end;

{ TDAUpdateSQLProperty }

procedure TDAUpdateSQLProperty.CheckComponent(const Value: string);
var
  i, j: integer;
  UpdateObject: TComponent;
  UpdateSQL: TCustomDAUpdateSQL;
  DataSetClass: TCustomDADataSetClass;
begin
  Assert(Designer.GetComponent(Value) is TCustomDAUpdateSQL);
  UpdateSQL := TCustomDAUpdateSQL(Designer.GetComponent(Value));

  DataSetClass := TDBAccessUtils.GetDataSetClass(UpdateSQL);
  for i := 0 to PropCount - 1 do
    if not (GetComponent(i) is DataSetClass) then
      Exit;

  for i := 0 to 3 do begin
    UpdateObject := nil;
    case i of
      0: UpdateObject := UpdateSQL.ModifyObject;
      1: UpdateObject := UpdateSQL.InsertObject;
      2: UpdateObject := UpdateSQL.DeleteObject;
      3: UpdateObject := UpdateSQL.RefreshObject;
    end;

    if UpdateObject <> nil then
      for j := 0 to PropCount - 1 do
        if TCustomDADataSet(GetComponent(j)) = UpdateObject then
          Exit;
  end;

  FCheckProc(Value);
end;

procedure TDAUpdateSQLProperty.GetValues(Proc: TGetStrProc);
begin
  FCheckProc := Proc;
  inherited GetValues(CheckComponent);
end;

{ TDAConnectionList }

constructor TDAConnectionList.Create;
begin
  inherited;

  Items := TStringList.Create;
end;

destructor TDAConnectionList.Destroy;
begin
  Items.Free;

  inherited;
end;

procedure TDAConnectionList.StrProc(const S: string);
begin
{$IFNDEF VER6P}
  Items.Add(S);
{$ENDIF}
end;

procedure TDAConnectionList.ListBoxDblClick(Sender: TObject);
begin
  Form.ModalResult := mrOk;
end;

procedure TDAConnectionList.ListBoxKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      Form.ModalResult := mrOk;
    #27:
      Form.ModalResult := mrCancel;
  end;
end;

{$IFDEF CLR} /// DAC 11241
procedure TDAConnectionList.FormShow(Sender: TObject);
begin
  Form.Left := FormLeft - 20;
  Form.Top := FormTop - 20;
end;
{$ENDIF}

function TDAConnectionList.GetConnection(Component: TComponent; Designer: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}): TCustomDAConnection;
const
  Width = 124;
  Height = 180;
var
  ListBox: TListBox;
  TypeData: TTypeData;
{$IFDEF VER6P}
  DesignOffset: TPoint;
{$ENDIF}
begin
{$IFDEF CLR}
  TypeData := TTypeData.Create(TypeOf(GetConnectionType));
  Designer.GetComponentNames(TypeData, StrProc);
{$ELSE}
  TypeData.ClassType := GetConnectionType;
  Designer.GetComponentNames(@TypeData, StrProc);
{$ENDIF}

  if Items.Count = 0 then
    Result := nil
  else
    if Items.Count = 1 then
      Result := TCustomDAConnection(Designer.GetComponent(Items[0]))
    else begin
      Form := TForm.Create(nil);
      ListBox := TListBox.Create(Form);
    {$IFDEF MSWINDOWS}
      Form.BorderStyle := bsSizeToolWin;
    {$ENDIF}
    {$IFDEF LINUX}
      Form.BorderStyle := fbsSizeToolWin;
    {$ENDIF}
    {$IFDEF VER6P}
      if Designer.Root is TForm then begin
      {$IFDEF CLR}
        DesignOffset := (Designer.Root as TForm).ClientToScreen(TPoint.Create(Word(Designer.Root.DesignInfo), Word(Designer.Root.DesignInfo shr 16)));
        FormLeft := DesignOffset.X + Word(Component.DesignInfo shr 16) - Width div 3;
        FormTop := DesignOffset.Y + Word(Component.DesignInfo) - 5;
      {$ELSE}
        DesignOffset := TForm(Designer.Root).BoundsRect.TopLeft;
      {$ENDIF}
      end
      else
      {$IFDEF CLR}
        DesignOffset := TPoint.Create(Word(Designer.Root.DesignInfo), Word(Designer.Root.DesignInfo shr 16));
      {$ELSE}
        DesignOffset := Point(LongRec(Designer.Root.DesignInfo).Lo, LongRec(Designer.Root.DesignInfo).Hi);
      Form.Left := DesignOffset.X + Word(Component.DesignInfo) - Width div 3;
      Form.Top := DesignOffset.Y + Word(Component.DesignInfo shr 16) - 5;      
      {$ENDIF}
    {$ELSE}
      Form.Left := Designer.Form.Left + LongRec(Component.DesignInfo).Lo - Width div 3;
      Form.Top := Designer.Form.Top + LongRec(Component.DesignInfo).Hi - 5;
    {$ENDIF}
      Form.Width := Width;
      Form.Height := Height;
      Form.Caption := 'Connection List';
      Form.InsertControl(TControl(ListBox));//Form.InsertControl(QControls.TControl(ListBox));
      ListBox.Items.Assign(Items);
      ListBox.Align := alClient;
      ListBox.ItemIndex := 0;
      ListBox.OnDblClick := ListBoxDblClick;
      ListBox.OnKeyPress := ListBoxKeyPress;
    {$IFDEF CLR}
      Form.OnShow := FormShow;
    {$ENDIF}

      if Form.ShowModal = mrOk then
        Result := TCustomDAConnection(Designer.GetComponent(Items[ListBox.ItemIndex]))
      else
        Result := nil;
      Form.Free;
    end;
end;

{$IFDEF VER6P}

{ TDADesignNotification }

procedure TDADesignNotification.DesignerClosed(const ADesigner: IDesigner
  {$IFNDEF K1}; AGoingDormant: Boolean{$ENDIF});
begin

end;

procedure TDADesignNotification.DesignerOpened(const ADesigner: IDesigner
  {$IFNDEF K1}; AResurrecting: Boolean{$ENDIF});
begin

end;

procedure TDADesignNotification.ItemDeleted(const ADesigner: IDesigner;
  AItem: TPersistent);
begin

end;

procedure TDADesignNotification.StrProc(const S: string);
begin
  FConnectionList.Items.Add(S);
end;

procedure TDADesignNotification.DSStrProc(const S: string);
begin
  DSItems.Add(S);
end;

procedure TDADesignNotification.ItemsModified(const ADesigner: IDesigner);
var
  Component: TComponent;
  TypeData: TTypeData;
  i, Width, Height: integer;
  DS: TDataSet;
  DADesignUtilsClass: TDADesignUtilsClass;
  Modified: boolean;
begin
  if (FItem <> nil) and (FItem is TCRDataSource) then begin
    try
      Component := TComponent(FItem);
      with TCRDataSource(Component) do
        if TDBAccessUtils.GetDesignCreate(TCRDataSource(Component)) then begin
          DSItems := TStringList.Create;
          try
          {$IFDEF CLR}
            TypeData := TTypeData.Create(TypeOf(TDataSet));
            ADesigner.GetComponentNames(TypeData, DSStrProc);
          {$ELSE}
            TypeData.ClassType := TDataSet;
            ADesigner.GetComponentNames(@TypeData, DSStrProc);
          {$ENDIF}
            for i := 0 to DSItems.Count - 1 do begin
              DS := TDataSet(ADesigner.GetComponent(DSItems[i]));
              Width := Word(DesignInfo) - Word(DS.DesignInfo);
              Height := Word(DesignInfo shr 16) - Word(DS.DesignInfo shr 16);
              if (Width >= -32) and (Width <= 32) and
                 (Height >= -32) and (Height <= 32)
              then begin
                DataSet := DS;
                break;
              end;
            end;
            TDBAccessUtils.SetDesignCreate(TCRDataSource(Component), False);
          finally
            DSItems.Free;
          end
        end;
    finally
      FItem := nil;
      ADesigner.Modified;
    end;
  end

  else begin
    if FConnectionList <> nil then
      exit;
    if not NotificationActive then
      FItem := nil
    else
      if FItem <> nil then begin
        Modified := False;
        DADesignUtilsClass := nil;
        try
          for i := 0 to Length(ComponentsInfo) - 1 do
            if FItem is ComponentsInfo[i].ComponentClass then begin
              DADesignUtilsClass := ComponentsInfo[i].DADesignUtilsClass;
              Modified := True;
              Break;
            end;
          Modified := Modified and (DADesignUtilsClass.GetConnection(TComponent(FItem)) = nil);
          if Modified then
            try
              FConnectionList := CreateConnectionList;
              ADesigner.GetComponentNames(GetTypeData(FConnectionList.GetConnectionType.ClassInfo), StrProc);
              SetObjectProp(FItem, GetConnectionPropertyName, FConnectionList.GetConnection(TComponent(FItem), ADesigner));
            finally
              FreeAndNil(FConnectionList);
            end;
        finally
          FItem := nil;
          if Modified then
            ADesigner.Modified;
        end;
      end; 
  end;
end;

procedure TDADesignNotification.SelectionChanged(
  const ADesigner: IDesigner; const ASelection: IDesignerSelections);
begin

end;
{$ENDIF}

{ TDAComponentEditor }

constructor TDAComponentEditor.Create(AComponent: TComponent; ADesigner: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF});
var
  i: integer;
{$IFNDEF VER6P}
  Connection: TCustomDAConnection;
{$ENDIF}
begin
{$IFDEF DBTOOLS}
  FDBToolsVerbIndex := -1;
{$ENDIF}
  inherited;

  for i := 0 to Length(ComponentsInfo) - 1 do
    if AComponent is ComponentsInfo[i].ComponentClass then begin
      FDADesignUtilsClass := ComponentsInfo[i].DADesignUtilsClass;
      Break;
    end;

  InitVerbs;

{$IFNDEF VER6P}
  if (FDADesignUtilsClass <> nil)
    and FDADesignUtilsClass.HasConnection(Component)
    and FDADesignUtilsClass.GetDesignCreate(Component) then begin

    with TDAConnectionList(FDADesignUtilsClass.GetConnectionList) do begin
      Connection := GetConnection(Component, Designer);
      FDADesignUtilsClass.SetConnection(Component, Connection);
      Free;
    end;
    FDADesignUtilsClass.SetDesignCreate(Component, False);
  end;
{$ENDIF}
end;

procedure TDAComponentEditor.InitVerbs;
begin
end;

procedure TDAComponentEditor.ShowEditor(const InitialProperty: string);
begin
  {$IFDEF CLR}CoreLab.Dac.Design.{$ENDIF}DADesign.ShowEditor(FCREditorClass, FDADesignUtilsClass, Component, Designer, InitialProperty);
end;

procedure TDAComponentEditor.ShowEditor;
begin
  {$IFDEF CLR}CoreLab.Dac.Design.{$ENDIF}DADesign.ShowEditor(FCREditorClass, FDADesignUtilsClass, Component, Designer);
end;

{$IFDEF DBTOOLS}
procedure TDAComponentEditor.AddDBToolsVerbs(Verbs: TDBToolsVerbs);
var
  IsSingle: boolean;
  VerbIdx: TDBToolsVerb;
begin
  if not FDADesignUtilsClass.DBToolsAvailable then begin
    if FDADesignUtilsClass.NeedToCheckDbTools = ncExpired then
      Exit;
    FDADesignUtilsClass.SetDBToolsDownloadParams(True, FDADesignUtilsClass.NeedToCheckDbTools = ncIncompatible);
    if NoCheckForTools(FDADesignUtilsClass.NeedToCheckDbTools = ncIncompatible) then
      Exit;
  end;

  IsSingle := False;
  for VerbIdx := Low(TDBToolsVerb) to High(TDBToolsVerb) do
    if VerbIdx in Verbs then begin
      IsSingle := not IsSingle;
      if not IsSingle then
        Break;
      FDBToolsSingleVerb := VerbIdx;
    end;

  if IsSingle then
    FDBToolsVerbIndex := AddVerb(DBTools.MenuActions[FDBToolsSingleVerb].Caption, DBToolsMenuExecute)
  else begin
    FDBToolsVerbs := Verbs;
    FDBToolsVerbIndex := AddVerb(FDADesignUtilsClass.GetDBToolsMenuCaption, DBToolsMenuExecute);
  end;
end;

procedure TDAComponentEditor.DBToolsMenuExecute;
begin
  DBTools.PrepareMenu(Designer, Component, FDADesignUtilsClass);
  if FDBToolsVerbs = [] then //Single verb
    DBTools.MenuActions[FDBToolsSingleVerb].Execute;
end;

procedure TDAComponentEditor.PrepareItem(Index: integer; const AItem: IMenuItem);
var
  VerbIdx: TDBToolsVerb;
begin
  if (Index = FDBToolsVerbIndex) and (FDBToolsVerbs <> []) then
    for VerbIdx := Low(TDBToolsVerb) to High(TDBToolsVerb) do
      if VerbIdx in FDBToolsVerbs then
        AItem.AddItem(DBTools.MenuActions[VerbIdx]);
end;
{$ENDIF}

function TDAComponentEditor.AddVerb(const Caption: string; Method: TVerbMethod): integer;
begin
  Result := Length(FVerbs);
  SetLength(FVerbs, Result + 1);
  FVerbs[Result].Caption := Caption;
  FVerbs[Result].Method := Method;
end;

function TDAComponentEditor.AddVerb(const Caption: string; CREditorClass: TCREditorClass; DADesignUtilsClass: TDADesignUtilsClass): integer;
begin
  Assert(FCREditorClass = nil);
  FCREditorClass := CREditorClass;
  Assert(FDADesignUtilsClass <> nil);
  Result := AddVerb(Caption, ShowEditor);
end;

function TDAComponentEditor.GetVerbCount: integer;
{$IFDEF DBTOOLS}
var
  i: integer;
{$ENDIF}
begin
{$IFDEF DBTOOLS}
  if (FDBToolsVerbIndex >=0) and not FDADesignUtilsClass.DBToolsAvailable then begin
    FDADesignUtilsClass.SetDBToolsDownloadParams(True, FDADesignUtilsClass.NeedToCheckDbTools = ncIncompatible);
    if NoCheckForTools(FDADesignUtilsClass.NeedToCheckDbTools = ncIncompatible) then begin
      for i := FDBToolsVerbIndex to Length(FVerbs) - 2 do
        FVerbs[i] := FVerbs[i + 1];
      SetLength(FVerbs, Length(FVerbs) - 1);
      FDBToolsVerbIndex := -1;
    end;
  end;
{$ENDIF}  
  Result := Length(FVerbs);
end;

function TDAComponentEditor.GetVerb(Index: integer): string;
begin
  Result := FVerbs[Index].Caption;
end;

procedure TDAComponentEditor.ExecuteVerb(Index: integer);
begin
  FVerbs[Index].Method;
end;

procedure TDAComponentEditor.Edit;
begin
  if FCREditorClass <> nil then
    ShowEditor
  else
    if GetVerbCount > 0 then
      ExecuteVerb(0)
    else
      inherited;
end;

{ TDADataSetEditor }

procedure TDADataSetEditor.ShowFieldsEditor;
var
  NeedCreate: boolean;
  DADSDesigner: TDADSDesigner;
{$IFDEF OLDDESIGNER}
  DataSetEditor: TComponentEditor;
{$ENDIF}
begin
  if (Component as TDataSet).Designer = nil then
    NeedCreate := True
  else
    if (Component as TDataSet).Designer is TDADSDesigner then begin
      (Component as TDataSet).Designer.Free;
      NeedCreate := True;
    end
    else
      NeedCreate := False;

  if NeedCreate then begin
  {$IFDEF OLDDESIGNER}
    DataSetEditor := DataSetEditorClass.Create(Component, Designer) as TComponentEditor;
    try
      DataSetEditor.ExecuteVerb(0);
    finally
      DataSetEditor.Free;
    end;
  {$ELSE}
    {$IFDEF CLR}Borland.VCL.Design.{$ENDIF}DSDesign.ShowFieldsEditor(Designer, TDataSet(Component), TDSDesigner);
  {$ENDIF}
  end
  else begin
    DADSDesigner := TDADSDesigner((Component as TDataSet).Designer);
  {$IFDEF LINUX}
    DADSDesigner.FFieldsEditor.Show;
  {$ELSE}
    DADSDesigner.FieldsEditor.Show;
  {$ENDIF}
  end;
end;

procedure TDADataSetEditor.ShowDataEditor;
begin
  {$IFDEF CLR}CoreLab.Dac.Design.{$ENDIF}DADesign.ShowEditor(TDADataEditorForm, FDADesignUtilsClass, Component, Designer);
end;

{$IFDEF MSWINDOWS}
{$IFNDEF VER8}
const
{$IFDEF VER5}
  DsmBplName = 'DataSetManager50.bpl';
{$ENDIF}
{$IFDEF VER6}
  DsmBplName = 'DataSetManager60.bpl';
{$ENDIF}
{$IFDEF VER7}
  DsmBplName = 'DataSetManager70.bpl';
{$ENDIF}
{$IFDEF VER9}
  DsmBplName = 'DataSetManager90.bpl';
{$ENDIF}
{$IFDEF VER10}
  DsmBplName = 'DataSetManager100.bpl';
{$ENDIF}
{$IFDEF VER11}
  DsmBplName = 'DataSetManager105.bpl';
{$ENDIF}
{$IFDEF CLR}
[DllImport(DsmBplName)]
procedure CreateDefaultControl([MarshalAs(UnmanagedType.LPStr)]Owner, DataSet: string); external;
[DllImport(DsmBplName)]
procedure ShowDataSetManager([MarshalAs(UnmanagedType.LPStr)]Owner, DataSet: string); external;
{$ENDIF}
procedure TDADataSetEditor.ExecuteDsmAction(const ProcName: string);
var
  Handle: Cardinal;
{$IFNDEF CLR}
  Proc: procedure(Owner, DataSet: PChar); stdcall;
{$ENDIF}
  OwnerName: string;
  DataSetName: string;
begin
  Handle := GetModuleHandle(PChar(DsmBplName));
  if Handle <> 0 then begin
{$IFNDEF CLR}
    Proc := GetProcAddress(Handle, PChar(ProcName));
    if Assigned(Proc) and Assigned(Component.Owner) then begin
      OwnerName := (Component as TDataSet).Owner.Name;
      DataSetName := (Component as TDataSet).Name;
      Proc(@OwnerName[1], @DataSetName[1]);
    end;
{$ELSE}
    if Assigned(Component.Owner) then begin
      OwnerName := Component.Owner.Name;
      DataSetName := (Component as TDataSet).Name;
      if SameText(ProcName, 'CreateDefaultControl') then
        CreateDefaultControl(OwnerName, DataSetName)
      else
        if SameText(ProcName, 'ShowDataSetManager') then
          ShowDataSetManager(OwnerName, DataSetName);
    end;
{$ENDIF}
  end;
end;

procedure TDADataSetEditor.InitVerbs;
var
  Handle: Cardinal;
begin
  inherited;

  Handle := GetModuleHandle(PChar(DsmBplName));
  if Handle <> 0 then begin
    AddVerb('-', Separator);
    AddVerb('Create default control', DsmCreateDefaultControl);
    AddVerb('Show in DataSet Manager', DsmShowInDataSetManager);
  end;
end;

procedure TDADataSetEditor.DsmCreateDefaultControl;
begin
{$IFDEF CLR}
  DsmShowInDataSetManager;
{$ENDIF}
  ExecuteDsmAction('CreateDefaultControl');
end;

procedure TDADataSetEditor.DsmShowInDataSetManager;
begin
  ExecuteDsmAction('ShowDataSetManager');
end;

procedure TDADataSetEditor.Separator;
begin
end;
{$ENDIF}
{$ENDIF}

{ TDALoaderEditor }

procedure TDALoaderEditor.InitVerbs;
begin
  inherited;
{$IFNDEF LINUX}
{$IFNDEF CLR}
{$IFNDEF BCB}
  AddVerb('Columns E&ditor...', ShowColEditor);
{$ENDIF}
{$ENDIF}
{$ENDIF}
  AddVerb('Create Columns', CreateColumns);
end;

procedure TDALoaderEditor.ShowColEditor;
begin
{$IFNDEF LINUX}
{$IFNDEF CLR}
{$IFNDEF BCB}
  Assert(Component is TDALoader);
  with ShowCollectionEditorClass(Designer, TCollectionEditor, Component,
    TDALoader(Component).Columns, 'Columns', [coAdd,coDelete{,coMove}]) do
    UpdateListbox;
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

procedure TDALoaderEditor.CreateColumns;
begin
  Assert(Component is TDALoader);
  if (TDALoader(Component).Columns.Count = 0) or
    (MessageDlg('Do you want recreate columns for table ' +
       TDALoader(Component).TableName + '?', mtConfirmation, [mbYes,mbNo], 0) = mrYes)
  then begin
    TDALoader(Component).CreateColumns;
    ShowColEditor;
  end;
end;

{$IFDEF MSWINDOWS}

{ TDASQLMonitorEditor }

procedure TDASQLMonitorEditor.RunDBMonitor;
begin
  Assert(HasMonitor);
  ShellExecute(0, 'open', PChar(WhereMonitor), '', '', SW_SHOW)
end;

procedure TDASQLMonitorEditor.RunSQLMonitor;
begin
  ShellExecute(0, 'open', 'sqlmon.exe', '', '', SW_SHOW);
end;

procedure TDASQLMonitorEditor.InitVerbs;
begin
  if HasMonitor then
    AddVerb('Run DBMonitor...', RunDBMonitor);
  AddVerb('Run SQL Monitor...', RunSQLMonitor);
end;

procedure TDASQLMonitorEditor.Edit;
begin
  if GetVerbCount > 0 then
    ExecuteVerb(0);
end;

{$ENDIF}
{ TCRDataSourceEditor }
constructor TCRDataSourceEditor.Create(Component: TComponent; aDesigner: {$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF});
var
  TypeData: TTypeData;
  i, Width, Height: integer;
  DS: TDataSet;
begin
  inherited;

  with TCRDataSource(Component) do
    if TDBAccessUtils.GetDesignCreate(TCRDataSource(Component)) then begin
      Items := TStringList.Create;
      try
      {$IFDEF CLR}
        TypeData := TTypeData.Create(TypeOf(TDataSet));
        aDesigner.GetComponentNames(TypeData, StrProc);
      {$ELSE}
        TypeData.ClassType := TDataSet;
        aDesigner.GetComponentNames(@TypeData, StrProc);
      {$ENDIF}

        for i := 0 to Items.Count - 1 do begin
          DS := TDataSet(aDesigner.GetComponent(Items[i]));
          Width := Word(DesignInfo) - Word(DS.DesignInfo);
          Height := Word(DesignInfo shr 16) - Word(DS.DesignInfo shr 16);
          if (Width >= 0) and (Width <= 28 + 4) and
             (Height >= 0) and (Height <= 28 + 4)
          then
            DataSet := DS;
        end;
        TDBAccessUtils.SetDesignCreate(TCRDataSource(Component), False);
      finally
        Items.Free;
      end
    end;
end;

procedure TCRDataSourceEditor.StrProc(const S: string);
begin
  Items.Add(S);
end;

procedure TCRDataSourceEditor.ConvertToDataSource;
begin
  if Designer <> nil then
    ConvertToClass(Self.Designer, Component, TDataSource);
end;

procedure TCRDataSourceEditor.InitVerbs;
begin
  inherited;
  AddVerb('Convert to TDataSource', ConvertToDataSource);
end;

procedure TCRDataSourceEditor.CheckEdit({$IFDEF VER6P}const Prop: IProperty{$ELSE}Prop: TPropertyEditor{$ENDIF});
begin
  if FFirstProp = nil then
    FFirstProp := Prop
{$IFNDEF VER6P}
  else
    Prop.Free;
{$ENDIF}
end;

procedure TCRDataSourceEditor.Edit;
var
  Components: {$IFDEF VER6P}IDesignerSelections;{$ELSE}TDesignerSelectionList;{$ENDIF}
begin
  Components := {$IFDEF VER6P}TDesignerSelections.Create{$ELSE}TDesignerSelectionList.Create{$ENDIF};
{$IFNDEF VER6P}
  try
{$ENDIF}
    Components.Add(Component);
    FFirstProp := nil;
    GetComponentProperties(Components, tkMethods, Designer, CheckEdit);
    if FFirstProp <> nil then
    {$IFNDEF VER6P}
      try
    {$ENDIF}
        FFirstProp.Edit;
    {$IFNDEF VER6P}
      finally
        FFirstProp.Free;
      end;
    {$ENDIF}
{$IFNDEF VER6P}
  finally
   Components.Free;
  end;
{$ENDIF}
end;

{ TDesignMacros }

const
  SComment           = '--';
  SBeginMacroComment = 'MACRO';
  SEndMacroComment   = 'ENDMACRO';

function TDesignMacros.GetMacroValue(Macro: TMacro): string;
var
  i: integer;
  ResultList: TStringList;
begin
  ResultList := TStringList.Create;
  try
    ResultList.Text := Macro.Value;
    if not Macro.Active then
      for i := 0 to ResultList.Count - 1 do
        ResultList[i] := SComment + ' ' + ResultList[i];

    ResultList.Insert(0, '');
    ResultList.Insert(1, SComment + ' ' + SBeginMacroComment + ' ' + Macro.Name);
    ResultList.Add(SComment + ' ' + SEndMacroComment);
  finally
    Result := ResultList.Text;
    ResultList.Free;
  end;
end;

procedure TDesignMacros.Scan(var SQL: string);
var
  i, j: integer;
  s, St, CommentSt: string;
  SourceSQL: TStringList;
  MacroSQL: TStringList;
  NewMacro,
  MacroFound: boolean;
  Macro: TMacro;

  Parser: TParser;
  CodeLexem: integer;

  function TrimLineSeparator(s: string): string;
  begin
    if Copy(s, Length(s) - Length(SLLineSeparator) + 1, Length(SLLineSeparator)) = SLLineSeparator then
      Result := Copy(s, 1, Length(s) - Length(SLLineSeparator))
    else
      Result := s;
  end;

  function AtFirstPos(Substr: string; s: string): boolean;
  begin
    Result := Copy(Trim(s), 1, Length(Substr)) = Substr;
  end;

  function TrimFirst(Substr: string; s: string): string;
  begin
    s := Trim(s);
    Result := Copy(s, Length(Substr) + 1, Length(s) - Length(Substr))
  end;

begin
  Clear;

  MacroFound := False;
  SourceSQL := TStringList.Create;
  MacroSQL := TStringList.Create;
  Parser := FParserClass.Create('');
  Macro := nil;

  try
    Parser.OmitBlank := False;
    Parser.Uppered := False;
    SourceSQL.Text := SQL;
    SQL := '';

    for i := 0 to SourceSQL.Count - 1 do begin
      s := SourceSQL[i];

      CommentSt := '';

      if AtFirstPos(SComment, s) then begin

        Parser.SetText(Trim(s));
        Parser.ToBegin;
        if Parser.GetNext(St) = lcComment then begin
          Parser.SetText(TrimFirst(SComment, s));
          Parser.ToBegin;
          repeat
            CodeLexem := Parser.GetNext(St)
          until CodeLexem <> lcBlank;
          CommentSt := St;
        end;
      end;

      if Macro <> nil then
        if CommentSt = SEndMacroComment then begin
          if not Macro.Active then
            for j := 0 to MacroSQL.Count - 1 do begin
              St := TrimFirst(SComment, MacroSQL[j]);
              if St[1] = ' ' then
                St := Copy(St, 2, Length(St) - 1);
              MacroSQL[j] := St;
            end;

          if MacroSQL.Count = 0 then
            Macro.Active := True;             
          Macro.Value := TrimLineSeparator(MacroSQL.Text);
          MacroSQL.Clear;
          Macro := nil;
        end
        else begin
          MacroSQL.Add(s);
          if CommentSt = '' then
            Macro.Active := True;
        end

      else begin
        NewMacro := False;

        if CommentSt = SBeginMacroComment then begin

          if Parser.GetNext(St) = lcBlank then begin
            repeat
              CodeLexem := Parser.GetNext(St)
            until CodeLexem <> lcBlank;

            NewMacro := (CodeLexem = lcIdent) or
              Parser.IsNumericMacroNameAllowed and (CodeLexem = lcNumber) or
              (CodeLexem > Parser.SymbolLexems.Count) and
              (CodeLexem <= Parser.SymbolLexems.Count + Parser.KeywordLexems.Count);
            if NewMacro and (CodeLexem = lcNumber) then begin
              CodeLexem := Parser.GetNext(s);
              if (CodeLexem = lcIdent) or (CodeLexem > Parser.SymbolLexems.Count)
                and (CodeLexem <= Parser.SymbolLexems.Count + Parser.KeywordLexems.Count)
              then
                St := St + s
            end;
          end;
        end;

        if NewMacro then begin
          MacroFound := True;
          Macro := FindMacro(St);
          if Macro = nil then begin
            Macro := TMacro(Add);
            Macro.Name := St;
          end;
          Macro.Active := False;
          SQL := TrimLineSeparator(SQL);
          if (SQL <> '') and (Pos(SQL[Length(SQL)], #$9#$A#$D#$20) < 1) then
            SQL := SQL + ' ';
          SQL := SQL + MacroChar + Macro.Name;
        end
        else begin
          if MacroFound then begin
            SQL := TrimLineSeparator(SQL);
          end;
          if i < SourceSQL.Count - 1 then
            s := s + SLLineSeparator;
          SQL := SQL + s;
          MacroFound := False;
        end;
      end;
    end;

  finally
    SourceSQL.Free;
    MacroSQL.Free;
    Parser.Free;
  end;
end;

procedure Register;
{$IFDEF OLDDESIGNER}
var
  DataSet: TDataSet;
  DataSetEditor: TComponentEditor;
{$ENDIF}
begin

{$IFDEF OLDDESIGNER}
{$WARNINGS OFF}
{$IFDEF VER6P}
  DataSet := nil;
  try
    DataSet := TDataSet.Create(nil);
    DataSetEditor := Pointer(Integer(GetComponentEditor(DataSet, nil)) - 20);
    DataSetEditorClass := TComponentEditorClass(DataSetEditor.ClassType);
  finally
    DataSet.Free;
  end;
{$ELSE}
  DataSet := nil;
  DataSetEditor := nil;
  try
    DataSet := TDataSet.Create(nil);
    DataSetEditor := GetComponentEditor(DataSet, nil);
    DataSetEditorClass := TComponentEditorClass(DataSetEditor.ClassType);
  finally
    DataSetEditor.Free;
    DataSet.Free;
  end;
{$ENDIF}
{$WARNINGS ON}
{$ENDIF}

  // Register property editors
  RegisterPropertyEditor(TypeInfo(TFields), TCustomDADataSet, 'Fields', TDAFieldsEditor);
  RegisterPropertyEditor(TypeInfo(TDAParams), TCustomDASQL, 'Params', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TDAParams), TCustomDADataset, 'Params', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TMacros), TCustomDASQL, 'Macros', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TMacros), TDAScript, 'Macros', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TMacros), TCustomDADataset, 'Macros', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataset, 'TableName', TDATableNameEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataset, 'StoredProcName', TDASPNameEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataset, 'OrderFields', TDAFieldDefsListEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataset, 'IndexFieldNames', TDAFieldsListEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataSet, 'MasterFields', TDADataSetMasterFieldsEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataSet, 'DetailFields', TDADataSetMasterFieldsEditor);
  RegisterPropertyEditor(TypeInfo(Variant), TDAParam, 'Value', TVariantEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDAConnection, 'Database', TDADatabaseNameEditor);
  RegisterPropertyEditor(TypeInfo(String), TCustomDADataSet, 'UpdatingTable', TDAUpdatingTableEditor);

  RegisterPropertyEditor(TypeInfo(String), TCustomDAConnection, 'Password', TDAPasswordProperty);

  RegisterPropertyEditor(TypeInfo(TComponent), TCustomDAUpdateSQL, 'RefreshObject', TDADatasetOrSQLProperty);
  RegisterPropertyEditor(TypeInfo(TComponent), TCustomDAUpdateSQL, 'ModifyObject', TDADatasetOrSQLProperty);
  RegisterPropertyEditor(TypeInfo(TComponent), TCustomDAUpdateSQL, 'InsertObject', TDADatasetOrSQLProperty);
  RegisterPropertyEditor(TypeInfo(TComponent), TCustomDAUpdateSQL, 'DeleteObject', TDADatasetOrSQLProperty);
  RegisterPropertyEditor(TypeInfo(TCustomDAUpdateSQL), TCustomDADataSet, 'UpdateObject', TDAUpdateSQLProperty);
  RegisterPropertyEditor(TypeInfo(String), TDALoader, 'TableName', TDALoaderTableNameEditor);
  RegisterPropertyEditor(TypeInfo(Boolean), TDALoader, 'Debug', nil);

  // Register component editors
  RegisterComponentEditor(TDALoader, TDALoaderEditor);
{$IFDEF MSWINDOWS}
  RegisterComponentEditor(TCustomDASQLMonitor, TDASQLMonitorEditor);
{$ENDIF}
end;

initialization

  NotificationActive := True;

end.
