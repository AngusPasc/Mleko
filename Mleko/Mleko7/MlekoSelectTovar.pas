unit MlekoSelectTovar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, MlekoForm,
  Dialogs, CFLMLKSelect, DB, DBAccess, MsAccess, COMPSQLBuilder, ActnList,
  citComponentProps, ExtCtrls, comp_TargetFilter_Panel, StdCtrls,
  ComCtrls, ToolWin, Grids, DBGrids, citDbGrid,
  comp_TargetFilter_CustomFilter, comp_TargetFilter_StringFilter,
  PropFilerEh, MemDS;

type
  TMlekoSelectTovarDlg = class(TCFLMLKSelectDlg)
    ftVidName: TTargetFilter_StringFilter;
    ftTovar: TTargetFilter_StringFilter;
    ftTovarNo: TTargetFilter_StringFilter;
    ftCompany: TTargetFilter_StringFilter;
    procedure ftVidNamea_OnBeforeGetString(
      Sender: TTargetFilter_StringFilter;
      ConditionType: TStringConditionType;
      ConditionGroup: TStringConditionGroup; var LikeStr: String);
    procedure ftCompanya_OnBeforeGetString(
      Sender: TTargetFilter_StringFilter;
      ConditionType: TStringConditionType;
      ConditionGroup: TStringConditionGroup; var LikeStr: String);
    procedure ftTovarNoa_OnBeforeGetString(
      Sender: TTargetFilter_StringFilter;
      ConditionType: TStringConditionType;
      ConditionGroup: TStringConditionGroup; var LikeStr: String);
    procedure ftTovara_OnBeforeGetString(
      Sender: TTargetFilter_StringFilter;
      ConditionType: TStringConditionType;
      ConditionGroup: TStringConditionGroup; var LikeStr: String);
    procedure QueryBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    class function SelectTovar(var aFirmId:integer):boolean;
  end;

var
  MlekoSelectTovarDlg: TMlekoSelectTovarDlg;

implementation

uses MlekoBlkParamPrivyazka,Meko_Blanc_Price;

{$R *.dfm}

class function TMlekoSelectTovarDlg.SelectTovar(var aFirmId:integer):boolean;
Var lv_firmId: String;
begin
  inherited;
  if OpenSelect(aFirmId,true) then begin
      result:=true;
   end else result:=false;
end;

procedure TMlekoSelectTovarDlg.ftVidNamea_OnBeforeGetString(
  Sender: TTargetFilter_StringFilter; ConditionType: TStringConditionType;
  ConditionGroup: TStringConditionGroup; var LikeStr: String);
begin
  inherited;
    LikeStr := '%'+LikeStr+'%';
end;

procedure TMlekoSelectTovarDlg.ftCompanya_OnBeforeGetString(
  Sender: TTargetFilter_StringFilter; ConditionType: TStringConditionType;
  ConditionGroup: TStringConditionGroup; var LikeStr: String);
begin
  inherited;
    LikeStr := '%'+LikeStr+'%';
end;                                                              

procedure TMlekoSelectTovarDlg.ftTovarNoa_OnBeforeGetString(
  Sender: TTargetFilter_StringFilter; ConditionType: TStringConditionType;
  ConditionGroup: TStringConditionGroup; var LikeStr: String);
begin
  inherited;
    LikeStr := '%'+LikeStr+'%';
end;

procedure TMlekoSelectTovarDlg.ftTovara_OnBeforeGetString(
  Sender: TTargetFilter_StringFilter; ConditionType: TStringConditionType;
  ConditionGroup: TStringConditionGroup; var LikeStr: String);
begin
  inherited;
    LikeStr := '%'+LikeStr+'%';
end;


procedure TMlekoSelectTovarDlg.QueryBeforeOpen(DataSet: TDataSet);
begin
  inherited;
   if   Meko_Blanc_Price.BLANC_PRICE.Y_N_Label.Caption = 'Y' then
         begin
           Query.Filter:=Query.Filter + Meko_Blanc_Price.BLANC_PRICE.ITOG_VIDNAME_Memo.Lines.Text;
           Query.Filtered:=True;
         end
         else  if MlekoBlkParamPrivyazka.NaborAddTovar.Label1.Caption <> '' then
                  begin
                    Query.Filter:=Query.Filter + MlekoBlkParamPrivyazka.NaborAddTovar.Memo1.Lines.Text;
                    Query.Filtered:=True;
                  end
               else Query.Filtered:=False;
 end;


initialization
 RegisterClass(TMlekoSelectTovarDlg);

finalization
 UnRegisterClass(TMlekoSelectTovarDlg);


end.
