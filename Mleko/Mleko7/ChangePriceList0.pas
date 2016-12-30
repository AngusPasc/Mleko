unit ChangePriceList0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MlekoForm, ActnList, DBGridEh, StdCtrls, Mask, DBCtrlsEh, DB,
  DBAccess, MSAccess, MemDS, DBLookupEh, Buttons, Registry, ComObj,
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
    dsFilterPrice: TMSDataSource;
    ds_ChangePriceList: TMSDataSource;
    QuUpdatePrice: TMSQuery;
    Label1: TLabel;
    qu_ChangePriceListPriceOld: TStringField;
    qu_ChangePriceListPriceValidDate: TStringField;
    qu_ChangePriceListCurrency: TStringField;
    procedure bb_ExportPriceListClick(Sender: TObject);
    procedure bb_ImportPriceListClick(Sender: TObject);
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

  WorkSheet := Excel.Workbooks[1].WorkSheets[1];

  qu_ChangePriceList.Close;
  if cbDBLookupFilterPrice.Text = '' then qu_ChangePriceList.ParamByName('NameGroup').Clear
                                     else qu_ChangePriceList.ParamByName('NameGroup').Value := cbDBLookupFilterPrice.Text;
  qu_ChangePriceList.Open;

  qu_ChangePriceList.First;

  index := 0;

  if qu_ChangePriceList.RecordCount > 0 then
  while not qu_ChangePriceList.Eof do
    begin
      index := index + 1;


      WorkSheet.Cells[index,1] := qu_ChangePriceListTovarNo.Value; // ����� ������
      WorkSheet.Cells[index,2] := qu_ChangePriceListPrice.Value; // ���� 1
      WorkSheet.Cells[index,3] := qu_ChangePriceListPrice1.Value; // ���� 2
      WorkSheet.Cells[index,4] := qu_ChangePriceListPrice2.Value; // ���� 3
      WorkSheet.Cells[index,5] := qu_ChangePriceListPrice3.Value; // ���� 4
      WorkSheet.Cells[index,6] := qu_ChangePriceListPrice4.Value; // ���� 5
      WorkSheet.Cells[index,7] := qu_ChangePriceListPrice5.Value; // ���� ������� (Price5)
      WorkSheet.Cells[index,8] := qu_ChangePriceListPrice6.Value; // ���� ������1 (Price6)
      WorkSheet.Cells[index,9] := qu_ChangePriceListPrice7.Value; // ���� ������2 (Price7)
      WorkSheet.Cells[index,10] := qu_ChangePriceListPrice8.Value; // ���� ���� (Price8)
      WorkSheet.Cells[index,11] := qu_ChangePriceListPrice13.Value; // ���� ��� (Price13)
      WorkSheet.Cells[index,12] := qu_ChangePriceListPrice14.Value; // ���� �����2 (Price14)
      WorkSheet.Cells[index,13] := qu_ChangePriceListPrice15.Value; // ���� �����3 (Price15)
      WorkSheet.Cells[index,14] := qu_ChangePriceListPrice9.Value; // ���� �������� (Price9)
      WorkSheet.Cells[index,15] := qu_ChangePriceListPrice10.Value; // ���� �����4 (Price10)
      WorkSheet.Cells[index,16] := qu_ChangePriceListPriceVeb.Value; // ���� �����  (PriceForVeb)
      WorkSheet.Cells[index,17] := qu_ChangePriceListPriceInInst.Value; //���� ������� ������������� (PriceInInst)
      WorkSheet.Cells[index,18] := qu_ChangePriceListPriceOld.Value; // ������ ����
      WorkSheet.Cells[index,19] := qu_ChangePriceListNameTovar.Value; // ������������ ������
      WorkSheet.Cells[index,20] := qu_ChangePriceListNameGroup.Value; // ��� ������
      WorkSheet.Cells[index,21] := qu_ChangePriceListPriceValidDate.Value; //  ���� ������������
      WorkSheet.Cells[index,22] := qu_ChangePriceListCurrency.Value; // ������

      qu_ChangePriceList.Next;
    end;

  od_PriceList.DefaultExt := '.xls';   // �������� ���� ��� �������� ������
  od_PriceList.Filter := 'Excel (*.xls)|*.xls'; // ������������� �������

  if od_PriceList.Execute then
   begin
     Excel.Application.EnableEvents := true;
     Excel.Application.Interactive := true;
     Excel.Application.DisplayAlerts := true;
     Excel.ActiveWorkBook.SaveCopyAs(od_PriceList.FileName);
     Excel.ActiveWorkBook.Close(0); // xlDontSaveChanges
     Excel.Quit;
     Excel := Unassigned;
     ShowMessage('�������� ��� ���������'+ #10#13 +'��������� ' + IntToStr(index-1)+' �������.');
   end;



end;

procedure TChangePriceList.bb_ImportPriceListClick(Sender: TObject);
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


  od_PriceList.DefaultExt := '.xls';   // �������� ���� ��� ������� ������
  od_PriceList.Filter := 'Excel (*.xls)|*.xls'; // ������������� �������

  if od_PriceList.Execute then
   begin
     Excel.Workbooks.Open(od_PriceList.FileName);
     WorkSheet := Excel.Workbooks[1].WorkSheets[1];
     i := Excel.ActiveSheet.UsedRange.Rows.Count;

     for index := 2 to i do
     begin
       if (WorkSheet.Cells[index,1].Text <> '') then
        begin
          QuUpdatePrice.Close;

          QuUpdatePrice.ParamByName('Price').Value := WorkSheet.Cells[index,2].text;
          QuUpdatePrice.ParamByName('Price1').Value := WorkSheet.Cells[index,3].text;
          QuUpdatePrice.ParamByName('Price2').Value := WorkSheet.Cells[index,4].text;
          QuUpdatePrice.ParamByName('Price3').Value := WorkSheet.Cells[index,5].text;
          QuUpdatePrice.ParamByName('Price4').Value := WorkSheet.Cells[index,6].text;
          QuUpdatePrice.ParamByName('Price5').Value := WorkSheet.Cells[index,7].text;
          QuUpdatePrice.ParamByName('Price6').Value := WorkSheet.Cells[index,8].text;
          QuUpdatePrice.ParamByName('Price7').Value := WorkSheet.Cells[index,9].text;
          QuUpdatePrice.ParamByName('Price8').Value := WorkSheet.Cells[index,10].text;
          QuUpdatePrice.ParamByName('Price13').Value := WorkSheet.Cells[index,11].text;
          QuUpdatePrice.ParamByName('Price14').Value := WorkSheet.Cells[index,12].text;
          QuUpdatePrice.ParamByName('Price15').Value := WorkSheet.Cells[index,13].text;
          QuUpdatePrice.ParamByName('Price9').Value := WorkSheet.Cells[index,14].text;
          QuUpdatePrice.ParamByName('Price10').Value := WorkSheet.Cells[index,15].text;
          QuUpdatePrice.ParamByName('PriceVeb').Value := WorkSheet.Cells[index,16].text;
          QuUpdatePrice.ParamByName('PriceInInst').Value := WorkSheet.Cells[index,17].text;
          QuUpdatePrice.ParamByName('PriceOld').Value := WorkSheet.Cells[index,18].text;
          QuUpdatePrice.ParamByName('TovarNo').Value := StrToInt(WorkSheet.Cells[index,1].text);
          QuUpdatePrice.ParamByName('PriceValidDate').Value := WorkSheet.Cells[index,21].text;
          QuUpdatePrice.ParamByName('TovarNo').Value := StrToInt(WorkSheet.Cells[index,1].text);
          QuUpdatePrice.ParamByName('Currency').Value := WorkSheet.Cells[index,22].text;


          QuUpdatePrice.Execute;
        end;
//       if index > 200 then showmessage(inttostr(index));
     end;
   end;

  Excel.Quit;
  Excel := Unassigned;

   ShowMessage('�������� ��� ���������'+ #10#13 +'���������� ' + IntToStr(index-2)+' �������.');

end;

end.
