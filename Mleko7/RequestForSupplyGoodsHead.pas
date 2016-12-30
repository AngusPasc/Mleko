unit RequestForSupplyGoodsHead;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MlekoForm, ActnList, DB, GridsEh, DBGridEh, MemDS, DBAccess,
  MSAccess, ExtCtrls, ComCtrls, ToolWin,Excel2000, Registry, ComObj, ActiveX,
  CFLMLKList, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, StdCtrls;

type
  TRequestForSupplyGoodsHeadForm = class(TMlekoForm) // TCFLMLKListForm
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    dsRequestForSupplyGoodsHead: TMSDataSource;
    quRequestForSupplyGoodsHead: TMSQuery;
    DBGridEh1: TDBGridEh;
    quRequestForSupplyGoodsHeadId: TIntegerField;
    quRequestForSupplyGoodsHeadDateRequest: TDateTimeField;
    odLoadRequest: TOpenDialog;
    ToolBarReguest: TToolBar;
    ToolButtonReguest1: TToolButton;
    ToolButtonReguest2: TToolButton;
    ToolButtonReguest3: TToolButton;
    quInsInRequestSpec: TMSQuery;
    ToolButtonReguest4: TToolButton;
    quRequestForSupplyGoodsHeadSummaRequest: TFloatField;
    gBPeriod: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdDateBeg: TcxDateEdit;
    EdDateEnd: TcxDateEdit;
    procedure FormShow(Sender: TObject);
    function IsOLEObjectInstalled(Name:string):boolean;
    procedure ToolButtonReguest1Click(Sender: TObject);
    procedure ToolButtonReguest2Click(Sender: TObject);
    procedure ToolButtonReguest3Click(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure ToolButtonReguest4Click(Sender: TObject);
    procedure EdDateBegPropertiesCloseUp(Sender: TObject);
    procedure EdDateEndPropertiesCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RequestForSupplyGoodsHeadForm: TRequestForSupplyGoodsHeadForm;

implementation

uses data, main, RequestForSupplyGoodsSpec, MlekoCrossRequestForGoods;

{$R *.dfm}
procedure TRequestForSupplyGoodsHeadForm.FormShow(Sender: TObject);
begin
  inherited;
  EdDateBeg.Date := Date();
  EdDateend.Date := Date()+1;

  quRequestForSupplyGoodsHead.Close;
  quRequestForSupplyGoodsHead.ParamByName('DateBeg').Value := EdDateBeg.Date;
  quRequestForSupplyGoodsHead.ParamByName('DateEnd').Value := EdDateEnd.Date;
  quRequestForSupplyGoodsHead.Open;
  quRequestForSupplyGoodsHead.Refresh;

end;

function TRequestForSupplyGoodsHeadForm.IsOLEObjectInstalled(Name:string):boolean;
var
  ClassID : TCLSID;
  Rez     : HRESULT;
begin
  // ���� CLSID OLE-�������
  Rez := CLSIDFromProgID(PWideChar(WideString(Name)),ClassID);
  if Rez=S_OK then
  // ������ ������
                Result := true
              else
                Result := false;
end;

procedure TRequestForSupplyGoodsHeadForm.ToolButtonReguest1Click(Sender: TObject);
 var
   cls_ExcelObject: string;
   WorkSheet: Variant;
   Excel: Variant;
   RegData: TRegistry;
   index, i : integer;
   Qty : Double;
   QtyS : string;
   Date : TDateTime;
   SummaNakl : Double;
   SummaNaklS : string;

begin
  inherited;
  // ��������� ����� ������� �� �������� ������
  // �������� ����� ����� ������� �� �������� ������
  dmDataModule.quWork.SQL.Clear;
  dmDataModule.quWork.SQL.Add('select isnull(max(id),0)+1 as NewId from RequestForSupplyGoodsHead ');
  dmDataModule.quWork.Open;

  quRequestForSupplyGoodsHead.Open;
  quRequestForSupplyGoodsHead.Append;
  quRequestForSupplyGoodsHeadId.Value := dmDataModule.quWork.FieldByName('NewId').AsInteger; // ����� ������� �� �������� ������
  quRequestForSupplyGoodsHeadDateRequest.Value := GlobalDateNakl; // ���� ������� �� �������� ������ - ������� ���� ���������
  quRequestForSupplyGoodsHead.Post;

  DBGridEh1.Refresh;

  ShowMessage('�������� ���� �� �������� ��������� ������ �� �������� ������');

  // ��� ��� ����, ����� �� ��������� ���������
  // ��� ������ ������
  // �������� "Excel.Application.8", "Excel.Application.9".

  cls_ExcelObject := 'Excel.Application';
  RegData := TRegistry.Create;
  RegData.RootKey := HKEY_CLASSES_ROOT;
  try
    if RegData.OpenKey('\Excel.Application\CurVer', False) then
    begin
      cls_ExcelObject := regData.ReadString('');
      RegData.CloseKey;
    end
  finally
    regData.Free;
  end;

  if not IsOLEObjectInstalled(cls_ExcelObject) then
   begin
     ShowMessage('Excel �� ����������.');
     exit;
   end;

  // ��� ������ ������� Excel
  Excel := CreateOleObject(cls_ExcelObject);

  // ��������� ������� Excel �� �������,
  // ����� �������� ��������� ���������� ����������
  // � ������ ������� ���������

  Excel.Application.ScreenUpdating := False;
  Excel.Application.EnableEvents := false;
  Excel.Application.Interactive := False;
  Excel.Application.DisplayAlerts := False;
//  Excel.ActiveSheet.DisplayPageBreaks := False;
  Excel.Application.DisplayStatusBar := False;
  Excel.Visible := false;


  odLoadRequest.DefaultExt := '.xls';   // �������� ���� ��� �������� ������
  odLoadRequest.Filter := 'Excel (*.xls)|*.xls'; // ������������� �������

  if odLoadRequest.Execute then
   begin
     Excel.Workbooks.Open(odLoadRequest.FileName);
     WorkSheet := Excel.Workbooks[1].WorkSheets[1];
     i := Excel.ActiveSheet.UsedRange.Rows.Count;

     for index := 1 to i do
     begin
       if (WorkSheet.Cells[index,1].Text <> '') then
        begin

          WorkSheet.Cells[index,1].EntireColumn.AutoFit;
          WorkSheet.Cells[index,2].EntireColumn.AutoFit;
          WorkSheet.Cells[index,3].EntireColumn.AutoFit;
          WorkSheet.Cells[index,4].EntireColumn.AutoFit;
          WorkSheet.Cells[index,5].EntireColumn.AutoFit;
          WorkSheet.Cells[index,6].EntireColumn.AutoFit;
          WorkSheet.Cells[index,7].EntireColumn.AutoFit;
          WorkSheet.Cells[index,8].EntireColumn.AutoFit;
          WorkSheet.Cells[index,9].EntireColumn.AutoFit;

          DecimalSeparator := '.';

          SummaNaklS := StringReplace(WorkSheet.Cells[index,9].Text, '''', '',[rfReplaceAll, rfIgnoreCase]);
          SummaNaklS := StringReplace(SummaNaklS, ',', '.',[rfReplaceAll, rfIgnoreCase]);
          SummaNakl := StrToFloat(SummaNaklS);

          QtyS := StringReplace(WorkSheet.Cells[index,6].Text, '''', '',[rfReplaceAll, rfIgnoreCase]);
          QtyS := StringReplace(QtyS, ',', '.',[rfReplaceAll, rfIgnoreCase]);
          Qty := StrToFloat(QtyS);

          quInsInRequestSpec.Close;
          quInsInRequestSpec.ParamByName('RequestForSupplyGoods_Id').Value := dmDataModule.quWork.FieldByName('NewId').AsInteger; // ����� ������� �� �������� ������
          quInsInRequestSpec.ParamByName('NaklNo').Value := WorkSheet.Cells[index,1].Text; // ����� ���������
          quInsInRequestSpec.ParamByName('DateNakl').Value := WorkSheet.Cells[index,2].Text ; // ���� ���������
          quInsInRequestSpec.ParamByName('DeliveryGoodsName').Value := WorkSheet.Cells[index,3].Text; // �������� ������
          quInsInRequestSpec.ParamByName('TovarNo').Value := WorkSheet.Cells[index,4].Text; // ��� ������
          quInsInRequestSpec.ParamByName('NameTovar').Value := WorkSheet.Cells[index,5].Text;  // ������������ ������
          quInsInRequestSpec.ParamByName('Qty').Value := Qty; //WorkSheet.Cells[index,6].Text; // ���-��
          quInsInRequestSpec.ParamByName('QtyFirst').Value := Qty; //WorkSheet.Cells[index,6].Text; // ���-��
          quInsInRequestSpec.ParamByName('PostNo').Value := WorkSheet.Cells[index,7].Text; // ����� �����������
          quInsInRequestSpec.ParamByName('PostName').Value := WorkSheet.Cells[index,8].Text; // ����������
          quInsInRequestSpec.ParamByName('SummaNakl').Value := SummaNakl; //WorkSheet.Cells[index,9].Text; // C���� �� ���������

          quInsInRequestSpec.Execute;
        end;
     end;
   end;

  DecimalSeparator := ',';

  Excel.Quit;
  Excel := Unassigned;

  ShowMessage('�������� ������ ���������'+ #10#13 +'���������� ' + IntToStr(index)+' �������.');

  quRequestForSupplyGoodsHead.Open;
  quRequestForSupplyGoodsHead.Edit;
  quRequestForSupplyGoodsHeadId.Value := dmDataModule.quWork.FieldByName('NewId').AsInteger; // ����� ������� �� �������� ������
  quRequestForSupplyGoodsHeadDateRequest.Value := GlobalDateNakl; // ���� ������� �� �������� ������ - ������� ���� ���������
  quRequestForSupplyGoodsHead.Post;

  quRequestForSupplyGoodsHead.Refresh;

  dmDataModule.quWork.Close;

end;

procedure TRequestForSupplyGoodsHeadForm.ToolButtonReguest2Click(Sender: TObject);
begin
  inherited;
  with TRequestForSupplyGoodsSpecForm.Create(Application) do
   try
     quRequestForSupplyGoodsSpec.ParamByName('RequestForSupplyGoods_Id').Value := quRequestForSupplyGoodsHeadId.Value;
     quRequestForSupplyGoodsSpec.Open;
     ShowModal;
   finally
     quRequestForSupplyGoodsSpec.Close;
     Free;
   end;
end;

procedure TRequestForSupplyGoodsHeadForm.ToolButtonReguest3Click(Sender: TObject);
begin
  inherited;
  if (MessageDlg('�� ������� ��� ������ ������� ������ �� �������� ������ ?', mtConfirmation, [mbNo,mbYes], 0) in [mrYes])
   then begin
          dmDataModule.quWork.SQL.Clear;
          dmDataModule.quWork.SQL.Add('delete RequestForSupplyGoodsSpec where RequestForSupplyGoods_Id = :Id ');
          dmDataModule.quWork.ParamByName('id').Value := quRequestForSupplyGoodsHeadId.Value;
          dmDataModule.quWork.Execute;

          quRequestForSupplyGoodsHead.Delete;
        end;
end;

procedure TRequestForSupplyGoodsHeadForm.DBGridEh1DblClick(
  Sender: TObject);
begin
  inherited;
  ToolButtonReguest2.Click;
end;

procedure TRequestForSupplyGoodsHeadForm.ToolButtonReguest4Click(Sender: TObject);
begin
  inherited;
//  TRequestForSupplyGoodsHeadForm.
//  Edit_CrossBlankOrder := True;
  TMlekoCrossRequestForGoodsForm.ShowFormBrand(quRequestForSupplyGoodsHeadDateRequest.Value,quRequestForSupplyGoodsHeadId.Value);
end;

procedure TRequestForSupplyGoodsHeadForm.EdDateBegPropertiesCloseUp(
  Sender: TObject);
begin
  inherited;
  quRequestForSupplyGoodsHead.Close;
  quRequestForSupplyGoodsHead.ParamByName('DateBeg').Value := EdDateBeg.Date;
  quRequestForSupplyGoodsHead.Open;
  quRequestForSupplyGoodsHead.Refresh;
end;

procedure TRequestForSupplyGoodsHeadForm.EdDateEndPropertiesCloseUp(
  Sender: TObject);
begin
  inherited;
  quRequestForSupplyGoodsHead.Close;
  quRequestForSupplyGoodsHead.ParamByName('DateEND').Value := EdDateEnd.Date;
  quRequestForSupplyGoodsHead.Open;
  quRequestForSupplyGoodsHead.Refresh;
end;

end.
