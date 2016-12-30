unit RequestForSupplyGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MlekoForm, ActnList, GridsEh, DBGridEh, ExtCtrls, DB, MemDS,
  DBAccess, MSAccess, StdCtrls, Excel2000, Registry, ComObj, ActiveX;

type
  TRequestForSupplyGoodsForm = class(TMlekoForm)
    dsRequestForSupplyGoods: TMSDataSource;
    quRequestForSupplyGoods: TMSQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGridEh1: TDBGridEh;
    quRequestForSupplyGoodsNaklNo: TIntegerField;
    quRequestForSupplyGoodsDeliveryGoodsName: TStringField;
    quRequestForSupplyGoodsTovarNo: TSmallintField;
    quRequestForSupplyGoodsNameTovar: TStringField;
    quRequestForSupplyGoodsQTY: TFloatField;
    quRequestForSupplyGoodsName: TStringField;
    sdRequestForSupply: TSaveDialog;
    ExportInFile: TButton;
    quRequestForSupplyGoodsDOC_DATE: TDateTimeField;
    quRequestForSupplyGoodsPostNo: TSmallintField;
    quRequestForSupplyGoodsSummaNakl: TFloatField;
    procedure ExportInFileClick(Sender: TObject);
    function IsOLEObjectInstalled(Name:string):boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RequestForSupplyGoodsForm: TRequestForSupplyGoodsForm;

procedure RequestForSupply (Nakls: string; DeliveryTovarNo : integer);

implementation

uses Data;

{$R *.dfm}


procedure RequestForSupply (Nakls: string; DeliveryTovarNo : integer);
var
  Dlg : TRequestForSupplyGoodsForm;
begin
  Dlg := TRequestForSupplyGoodsForm.Create(Application);

  Dlg.quRequestForSupplyGoods.Close;
  Dlg.quRequestForSupplyGoods.ParamByName('DeliveryTovarNo').Value := DeliveryTovarNo;
  Dlg.quRequestForSupplyGoods.MacroByName('_where').Value := ' and NaklNo in ' + Nakls;
  Dlg.quRequestForSupplyGoods.Open;

  Dlg.Show;
end;

function TRequestForSupplyGoodsForm.IsOLEObjectInstalled(Name:string):boolean;
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

procedure TRequestForSupplyGoodsForm.ExportInFileClick(Sender: TObject);
var
  cls_ExcelObject: string;
  WorkSheet: Variant;
  Excel: Variant;
  RegData: TRegistry;
  index, i : integer;
begin
  inherited;
  // ����� �� ��������� ���������
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


  // ������� ����� �������

  Excel.Workbooks.Add;

  WorkSheet := Excel.Workbooks[1].WorkSheets[1];

  index := 0;

  if quRequestForSupplyGoods.RecordCount > 0 then
  while not quRequestForSupplyGoods.Eof do
    begin
      index := index + 1;

      WorkSheet.Cells[index,1] := quRequestForSupplyGoodsNaklNo.Value; // ����� ���������
      WorkSheet.Cells[index,2] := quRequestForSupplyGoodsDOC_DATE.Value; // ���� ���������
      WorkSheet.Cells[index,3] := quRequestForSupplyGoodsDeliveryGoodsName.Value; // �������� ������
      WorkSheet.Cells[index,4] := quRequestForSupplyGoodsTovarNo.Value; // ��� ������
      WorkSheet.Cells[index,5] := quRequestForSupplyGoodsNameTovar.Value; // ������������ ������
      WorkSheet.Cells[index,6] := quRequestForSupplyGoodsQTY.Value; // ���-��
      WorkSheet.Cells[index,7] := quRequestForSupplyGoodsPostNo.Value; // ����� �����������
      WorkSheet.Cells[index,8] := quRequestForSupplyGoodsName.Value; // ����������
      WorkSheet.Cells[index,9] := quRequestForSupplyGoodsSummaNakl.Value; // ����� �� ���������
      quRequestForSupplyGoods.Next;

    end;




  sdRequestForSupply.DefaultExt := '.xls';   // �������� ���� ��� ������� ������
  sdRequestForSupply.Filter := 'Excel (*.xls)|*.xls'; // ������������� �������

if sdRequestForSupply.Execute then
   begin
     Excel.Application.EnableEvents := true;
     Excel.Application.Interactive := true;
     Excel.Application.DisplayAlerts := true;
     Excel.ActiveWorkBook.SaveCopyAs(sdRequestForSupply.FileName);
     Excel.ActiveWorkBook.Close(0); // xlDontSaveChanges
     Excel.Quit;
     Excel := Unassigned;
     ShowMessage('�������� �������� ���������'+ #10#13 +'��������� ' + IntToStr(index)+' �������.');
   end;


end;

end.
