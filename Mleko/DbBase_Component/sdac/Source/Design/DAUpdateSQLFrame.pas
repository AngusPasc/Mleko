
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright � 1998-2005 Core Lab. All right reserved.
//  UpdateSQL Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DAUpdateSQLFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,
{$ENDIF}
{$IFDEF LINUX}
  QGraphics, QStdCtrls, QExtCtrls, QButtons, QControls,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
  Classes, SysUtils, DBAccess, CRFrame, CRTabEditor,
  DASQLFrame;

type
  TDAUpdateSQLFrame = class(TDASQLFrame)
    pnlTop: TPanel;
    btClear: TSpeedButton;
    gbStatementType: TGroupBox;
    procedure rbClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure meSQLChange(Sender: TObject);
  protected
    FStatementType: TStatementType;
    FStatementTypeSetted: boolean;
    Frb: array[TStatementType] of TRadioButton;

  {$IFDEF DBTOOLS}
    procedure LoadMemo; override;
  {$ENDIF}
    function GetStatementTypes: TStatementTypes; virtual;

    function GetLocalComponentSQL: TStrings; override;
    procedure SetLocalComponentSQL(Value: TStrings); override;

    procedure CreateStatementIndicators;
    procedure RefreshEmptyIndicators;
    procedure SetEmpty(st: TStatementType; Empty: boolean);
    procedure DoActivate; override;

  public
    procedure SetStatementType(StatementType: TStatementType);
  end;

implementation

{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R DAUpdateSQLFrame.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}

uses
  DB, DAQueryEditor, DASQLEditor, DAUpdateSQLEditor, CREditor;

procedure TDAUpdateSQLFrame.SetStatementType(StatementType: TStatementType);
begin
  FStatementTypeSetted := True;
  FStatementType := StatementType;
  CreateStatementIndicators;
  Assert(Frb[FStatementType] <> nil);
  Frb[FStatementType].Checked := True;
  LoadMemo;
end;

procedure TDAUpdateSQLFrame.DoActivate;
var
  st: TStatementType;
  sts: TStatementTypes;
begin
  if not FStatementTypeSetted then begin
    CreateStatementIndicators;
    sts := GetStatementTypes;
    for st := Low(TStatementType) to High(TStatementType) do
      if (st in sts) and (TrimRight(Editor.DADesignUtilsClass.GetSQL(Editor.LocalComponent, st).Text) <> '') then begin
        SetStatementType(st);
        Break;
      end;

    if not FStatementTypeSetted then begin
      for st := Low(TStatementType) to High(TStatementType) do
        if (Frb[st] <> nil) and Frb[st].Visible and Frb[st].Enabled then begin
          SetStatementType(st);
          Break;
        end;
    end;
  end;

  inherited;
  
  RefreshEmptyIndicators;
end;

procedure TDAUpdateSQLFrame.SetEmpty(st: TStatementType;
  Empty: boolean);
begin
  Assert(Frb[st] <> nil);
  if Empty then
    Frb[st].Font.Style := []
  else
    Frb[st].Font.Style := [fsBold];
end;

procedure TDAUpdateSQLFrame.CreateStatementIndicators;
var
  st: TStatementType;
  sts: TStatementTypes;
  rbCount, dW, i: integer;
  rb: TRadioButton;
begin
  for st := Low(TStatementType) to High(TStatementType) do
    if Frb[st] <> nil then
      Exit;

  Assert(Owner is TCREditorForm);
  rbCount := 0;
  sts := GetStatementTypes;
  for st := Low(TStatementType) to High(TStatementType) do begin
    Frb[st].Free;
    Frb[st] := nil;
    if st in sts then begin
      Inc(rbCount);
      rb := TRadioButton.Create(Self);
      with rb do
      begin
        Parent := gbStatementType;
        Top := 15;
        Width := 75;
        Height := 17;
        case st of
          stQuery:
            Caption := 'Query';
          stInsert:
            Caption := 'Insert';
          stUpdate:
            Caption := 'Update';
          stDelete:
            Caption := 'Delete';
          stLock:
            Caption := 'Lock';
          stRefresh:
            Caption := 'Refresh';
          else
            Assert(False);
        end;
        //TabStop := True; ???
        OnClick := rbClick;
      end;
      Frb[st] := rb;
    end;
  end;

  i := 0;
  dW := (gbStatementType.Width - 8 {rbInsert.Left} * 2) div rbCount;
  for st := Low(TStatementType) to High(TStatementType) do
    if st in sts then begin
      Assert(Frb[st] <> nil);
      Frb[st].Left := 8 {rbInsert.Left} + dW * i;
      Inc(i);
    end;
end;

procedure TDAUpdateSQLFrame.RefreshEmptyIndicators;
var
  st: TStatementType;
  sts: TStatementTypes;
begin
  sts := GetStatementTypes;
  for st := Low(TStatementType) to High(TStatementType) do
    if st in sts then
      SetEmpty(st, TrimRight(Editor.DADesignUtilsClass.GetSQL(Editor.LocalComponent, st).Text) = '');
end;

procedure TDAUpdateSQLFrame.rbClick(Sender: TObject);
var
  st: TStatementType;
begin
{$IFDEF DBTOOLS}
  DBTools.CheckDBToolsChanges(Self);
{$ENDIF}
  for st := Low(TStatementType) to High(TStatementType) do
    if (Frb[st] <> nil) and Frb[st].Checked then begin
      if FStatementType <> st then begin
        SaveMemo;
        FStatementType := st;
        LoadMemo;
      end;
      Exit;
    end;
  Assert(False);
end;

procedure TDAUpdateSQLFrame.btClearClick(Sender: TObject);
begin
  SQLText := ' ';
  SaveMemo;
  meSQLChange(nil);
end;

procedure TDAUpdateSQLFrame.meSQLChange(Sender: TObject);
begin
  if FStatementTypeSetted then
    SetEmpty(FStatementType, TrimRight(SQLText) = '');
end;

{$IFDEF DBTOOLS}
procedure TDAUpdateSQLFrame.LoadMemo;
begin
  if DBTools.HasDACSqlEditorFrame(meSQL) then
    DBTools.GetDACSqlEditorFrame(meSQL).StatementType := FStatementType;

  inherited;
end;
{$ENDIF}

function TDAUpdateSQLFrame.GetStatementTypes: TStatementTypes;
begin
  Result := Editor.DADesignUtilsClass.GetStatementTypes - [stQuery];
  if Editor.LocalComponent is TCustomDAUpdateSQL then
    Result := Result - [stLock];
end;

function TDAUpdateSQLFrame.GetLocalComponentSQL: TStrings;
begin
  Assert(Editor <> nil);
  if FStatementType = stQuery then
    Result := inherited GetLocalComponentSQL
  else
    Result := Editor.DADesignUtilsClass.GetSQL(Editor.LocalComponent, FStatementType);
end;

procedure TDAUpdateSQLFrame.SetLocalComponentSQL(Value: TStrings);
begin
  Assert(Editor <> nil);
  if FStatementType = stQuery then
    inherited SetLocalComponentSQL(Value)
  else
    Editor.DADesignUtilsClass.SetSQL(Editor.LocalComponent, Value, FStatementType);
end;

end.
