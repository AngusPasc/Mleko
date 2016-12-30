unit CangePriceList0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MlekoForm, ActnList, DBGridEh, StdCtrls, Mask, DBCtrlsEh,
  DBLookupEh, Buttons, DB, MemDS, DBAccess, MSAccess,  Registry, ComObj,
  Excel2000, ActiveX;


type
  TChangePriceList = class(TMlekoForm)
    od_PriceList: TOpenDialog;
    bb_ExportPriceList: TBitBtn;
    cbDBLookupFilterPrice: TDBLookupComboboxEh;
    quFilterPrice: TMSQuery;
    bb_ImportPriceList: TBitBtn;
    qu_ChangePriceList: TMSQuery;
    qu_ChangePriceListPrice: TStringField;
    qu_ChangePriceListPrice1: TStringField;
    qu_ChangePriceListPrice2: TStringField;
    qu_ChangePriceListPrice3: TStringField;
    qu_ChangePriceListPrice4: TStringField;
    qu_ChangePriceListPrice5: TStringField;
    qu_ChangePriceListPrice6: TStringField;
    qu_ChangePriceListPrice7: TStringField;
    qu_ChangePriceListPrice8: TStringField;
    qu_ChangePriceListPrice13: TStringField;
    qu_ChangePriceListPrice14: TStringField;
    qu_ChangePriceListPrice15: TStringField;
    qu_ChangePriceListPrice9: TStringField;
    qu_ChangePriceListPrice10: TStringField;
    qu_ChangePriceListPriceVeb: TStringField;
    qu_ChangePriceListPriceInInst: TStringField;
    qu_ChangePriceListNameTovar: TStringField;
    qu_ChangePriceListNameGroup: TStringField;
    qu_ChangePriceListTovarNo: TStringField;
    procedure bb_ExportPriceListClick(Sender: TObject);
  private
    function IsOLEObjectInstalled(Name:string):boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangePriceList: TChangePriceList;

implementation

uses data;

{$R *.dfm}

function TChangePriceList.IsOLEObjectInstalled(Name:string):boolean;
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

procedure TChangePriceList.bb_ExportPriceListClick(Sender: TObject);
 var
   cls_ExcelObject: string;
   WorkSheet: Variant;
   Excel: Variant;
   RegData: TRegistry;
   index, i : integer;
begin
  inherited;
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

  // ������� ����� �������

  Excel.Workbooks.Add;

  qu_ChangePriceList.Close;
  qu_ChangePriceList.ParamByName('NameGroup').AsString := cbDBLookupFilterPrice.Text;
  qu_ChangePriceList.Open;

  qu_ChangePriceList.First;

  index := 0;

  while not qu_ChangePriceList.Eof do
    begin
      index := index + 1;

      Excel.Range[excel.Cells[index,1]] := qu_ChangePriceListTovarNo.Value;
//      Excel.Sheets[1].Cells[index,1] := qu_ChangePriceListTovarNo.Value; // ����� ������
      Excel.Range[excel.Cells[index,2]] := qu_ChangePriceListPrice.Value; // ���� 1
      Excel.Range[excel.Cells[index,3]] := qu_ChangePriceListPrice1.Value; // ���� 2
      Excel.Range[excel.Cells[index,4]] := qu_ChangePriceListPrice2.Value; // ���� 3
      Excel.Range[excel.Cells[index,5]] := qu_ChangePriceListPrice3.Value; // ���� 4
      Excel.Range[excel.Cells[index,6]] := qu_ChangePriceListPrice4.Value; // ���� 5
      Excel.Range[excel.Cells[index,7]] := qu_ChangePriceListPrice5.Value; // ���� ������� (Price5)
      Excel.Range[excel.Cells[index,8]] := qu_ChangePriceListPrice6.Value; // ���� ������1 (Price6)
      Excel.Range[excel.Cells[index,9]] := qu_ChangePriceListPrice7.Value; // ���� ������2 (Price7)
      Excel.Range[excel.Cells[index,10]] := qu_ChangePriceListPrice8.Value; // ���� ���� (Price8)
      Excel.Range[excel.Cells[index,11]] := qu_ChangePriceListPrice13.Value; // ���� ��� (Price13)
      Excel.Range[excel.Cells[index,12]] := qu_ChangePriceListPrice14.Value; // ���� �����2 (Price14)
      Excel.Range[excel.Cells[index,13]] := qu_ChangePriceListPrice15.Value; // ���� �����3 (Price15)
      Excel.Range[excel.Cells[index,14]] := qu_ChangePriceListPrice9.Value; // ���� �������� (Price9)
      Excel.Range[excel.Cells[index,15]] := qu_ChangePriceListPrice10.Value; // ���� �����4 (Price10)
      Excel.Range[excel.Cells[index,16]] := qu_ChangePriceListPriceVeb.Value; // ���� �����  (PriceForVeb)
      Excel.Range[excel.Cells[index,17]] := qu_ChangePriceListPriceInInst.Value; //���� ������� ������������� (PriceInInst)
      Excel.Range[excel.Cells[index,18]] := qu_ChangePriceListNameTovar.Value; // ������������ ������
      Excel.Range[excel.Cells[index,19]] := qu_ChangePriceListNameGroup.Value; // ��� ������
    end;

  od_PriceList.DefaultExt := '.xls';   // �������� ���� ��� �������� ������
  od_PriceList.Filter := 'Excel (*.xls)|*.xls'; // ������������� �������

  if od_PriceList.Execute then
   begin
     Excel.Application.EnableEvents := true;
     Excel.Application.Interactive := true;
     Excel.Application.DisplayAlerts := true;
     Excel.ActiveWorkbook.SaveCopyAs(od_PriceList.FileName);
     Excel.ActiveWorkbook.Close(0); // xlDontSaveChanges
     Excel.Quit;
     Excel := Unassigned;
   end;


end;

end.
