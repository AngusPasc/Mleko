unit NaklRDBFForMail0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ShellApi, DBAccess, MSAccess, MemDS, DBTables, Excel2000,
  Registry, ActiveX, ComObj;

type
  TCreateDbfForMail0 = class(TForm)
    DB: TMSConnection;
    quNaklRPostExport: TMSQuery;
    quNaklRPostExportTovarNoP: TIntegerField;
    quNaklRPostExportBarCode: TLargeintField;
    quNaklRPostExportNameTov: TStringField;
    quNaklRPostExportEdIzm: TStringField;
    quNaklRPostExportPrNoNDS: TFloatField;
    quNaklRPostExportPrice: TFloatField;
    quNaklRPostExportStavNDS: TStringField;
    quNaklRPostExportQTY: TFloatField;
    quNaklRPostExportSumNoNDS: TFloatField;
    quNaklRPostExportSumma: TFloatField;
    quNaklRPostExportNomNaklR: TIntegerField;
    quNaklRPostExportDate: TDateTimeField;
    quNaklRPostExportSumNaklR: TFloatField;
    quNaklRPostExportSNRNoNDS: TFloatField;
    quNaklRPostExportOurFirm: TStringField;
    quNaklRPostExportOurOKPO: TStringField;
    quNaklRPostExportFirm: TStringField;
    quNaklRPostExportAdrPost: TStringField;
    quNaklRPostExportPostNo: TSmallintField;
    dsNaklRPostExport: TDataSource;
    TableDbf: TTable;
    quNaklRPostExportAddresId: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SendDBF;
    procedure CreateAndSendExcelFile(PostNo : integer; DateBeg : TDateTime; DateEnd : TDateTime; Is_Period : boolean; Is_SendMail : boolean; SendAddressNo : integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateDbfForMail0: TCreateDbfForMail0;

implementation

uses math;
{$R *.dfm}

procedure TCreateDbfForMail0.FormCreate(Sender: TObject);
begin
  Left:= -2000;
  //// ��� ������
end;

procedure TCreateDbfForMail0.FormShow(Sender: TObject);
begin
// ��� ��� ������
 SendDBF;
 Close;
end;

function DelDir(dir: string): Boolean; 
var
  fos: TSHFileOpStruct;
begin 
  ZeroMemory(@fos, SizeOf(fos)); 
  with fos do 
  begin 
    wFunc  := FO_DELETE; 
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION; 
    pFrom  := PChar(dir + #0); 
  end; 
  Result := (0 = ShFileOperation(fos)); 
end;

procedure makedir(value:string);
var i,x:integer;
    cur_dir:string;
    RootDir:String;
begin
  RootDir:=value[1]+value[2]+value[3];
  SetCurrentDirectory(pchar(RootDir));
  x:=1;
  cur_dir:='';
  if (value[1]='\') then x:=2;
  for i:=x to Length(value) do
   begin
    if not (value[i]='\')then
      cur_dir:=cur_dir+value[i];
    if (value[i]='\')or (i=length(value)) then
     begin
      if not DirectoryExists(cur_dir) then
       CreateDirectory(pchar(cur_dir),0);
      SetCurrentDirectory(pchar(cur_dir));
      cur_dir:='';
     end;
   end;
end;

procedure TCreateDbfForMail0.SendDBF;
label Next;
var
    formattedDateTime, formattedDateTime1 : String;
    FTable_ID    : int64;
    fname        : String;
    fname1       : String;
    f            : String;
    dbf_name     : String;
    dbf_name1    : String;
    Topic        : String;
    Message      : String;
    Mail1        : String;
    Mail2        : String;
    Mail3        : String;
    QuSendDBF    : TMSQuery;
    QuSendDBFA   : TMSQuery;
    QuSendDBFN   : TMSQuery;
    QuCheck      : TMSQuery;
    QuCheckNakl  : TMSQuery;
    ExecString   : String;
    s            : String;
    FilePath     : String;
    AddressNo    : Integer;
    ExecRun      : Boolean;

    myFile : TextFile;
    text   : string;
begin  //1

  f := 'd:\Temp_Send_MailAll\';
  DelDir(f);
  ExecRun := True;

  QuSendDBFA:=TMSQuery.Create(nil);
  QuSendDBFA.Connection := CreateDbfForMail0.DB;
  QuSendDBFA.SQL.Clear;
  QuSendDBFA.SQL.Text:='select  PostNo      '
                      +'        ,AddresNo   '
                      +'        ,convert(datetime, DateBeg) DateBeg    '
                      +'        ,convert(datetime, DateEnd) DateEnd    '
                      +' from ListPostMail  '
                      +'  where Check1 = 1  ';
  QuSendDBFA.Prepare;
  QuSendDBFA.Open;
  QuSendDBFA.First;

  while not QuSendDBFA.Eof do

  begin // 2

////////////////////////////////////////////////////////////////////////////////
  QuCheck:=TMSQuery.Create(nil);
  QuCheck.Connection:=CreateDbfForMail0.DB;
  QuCheck.SQL.Clear;
  QuCheck.SQL.Text := 'select * '
                     +' from L_ExportInExcelFile '
                     +'  where PostNo = :PostNo ';
  QuCheck.Prepare;
  QuCheck.ParamByName('PostNo').Value := QuSendDBFA.FieldByName('PostNo').AsInteger;
  QuCheck.Open;

  if QuCheck.RecordCount <> 0 and QuCheck.FieldByName('Check1').Value = true then begin
                                                                                    QuCheckNakl := TMSQuery.Create(nil);
                                                                                    QuCheckNakl.Connection := CreateDbfForMail0.DB;
                                                                                    QuCheckNakl.SQL.Clear;
                                                                                    QuCheckNakl.SQL.Text := 'select distinct NomNaklR '
                                                                                                           +' from v_NaklRPost_Export v '
                                                                                                           +'  where v.PostNo = Isnull(:PostNo ,v.PostNo) '
                                                                                                           +'    and v.AddressNo = Isnull(:AddressNo ,v.AddressNo)'
                                                                                                           +'    and Isnull (:date1,cast(v.date as date)) <= cast(v.date as date)'
                                                                                                           +'    and Isnull (:date2,cast(v.date as date)) >= cast(v.date as date)';
                                                                                    QuCheckNakl.Prepare;
                                                                                    QuCheckNakl.ParamByName('PostNo').AsInteger := QuSendDBFA.FieldByName('PostNo').AsInteger;
                                                                                    QuCheckNakl.ParamByName('AddressNo').AsInteger := QuSendDBFA.FieldByName('AddresNo').AsInteger;
                                                                                    QuCheckNakl.ParamByName('date1').AsDate := floor(QuSendDBFA.FieldByName('DateBeg').AsDateTime);
                                                                                    QuCheckNakl.ParamByName('date2').AsDate := floor(QuSendDBFA.FieldByName('DateEnd').AsDateTime);
                                                                                    QuCheckNakl.Open;

                                                                                    if QuCheckNakl.RecordCount > 0 then begin
                                                                                                                          CreateAndSendExcelFile(QuSendDBFA.FieldByName('PostNo').AsInteger,QuSendDBFA.FieldByName('DateBeg').AsDateTime,QuSendDBFA.FieldByName('DateEnd').AsDateTime,True,True,QuSendDBFA.FieldByName('AddresNo').AsInteger);
                                                                                                                          QuCheck.Close;
                                                                                                                          QuCheckNakl.Close;
                                                                                                                          GoTo Next;
                                                                                                                        end;
                                                                                    QuCheckNakl.Close;
                                                                                  end;

  QuCheck.Close;

////////////////////////////////////////////////////////////////////////////////

  AddressNo := QuSendDBFA.FieldByName('AddresNo').AsInteger;
  fname := 'd:\\Temp_Send_MailAll\\' + QuSendDBFA.FieldByName('PostNo').AsString +'\\'+QuSendDBFA.FieldByName('AddresNo').AsString;
  fname1 := 'd:\Temp_Send_MailAll\' + QuSendDBFA.FieldByName('PostNo').AsString+'\'+QuSendDBFA.FieldByName('AddresNo').AsString;


  ExecString := '';
  s := '''0''';


  QuSendDBF:=TMSQuery.Create(nil);
  QuSendDBF.Connection:=CreateDbfForMail0.DB;
  QuSendDBF.SQL.Clear;
  QuSendDBF.SQL.Text:='select PostNo'
                     +'      ,isnull(case when LEN(Topic)<1 then '+s+' else Topic end,'+s+') Topic'
                     +'      ,isnull(case when LEN(Message)<1 then '+s+' else Message end,'+s+') Message'
                     +'      ,isnull(case when LEN(Mail1)<1 then '+s+' else Mail1 end,'+s+') Mail1'
                     +'      ,isnull(case when LEN(Mail2)<1 then '+s+' else Mail2 end,'+s+') Mail2'
                     +'      ,isnull(case when LEN(Mail3)<1 then '+s+' else Mail3 end,'+s+') Mail3'
                     +' from Post_Mail where PostNo = :PostNo and AddressNo = :AddressNo'
                     +'   ';
  QuSendDBF.Prepare;
  QuSendDBF.ParamByName('PostNo').Value := QuSendDBFA.FieldByName('PostNo').AsInteger ;
  QuSendDBF.ParamByName('AddressNo').Value := AddressNo;
  QuSendDBF.Open;

  Topic := QuSendDBF.FieldByName('Topic').AsString;
  Message := QuSendDBF.FieldByName('Message').AsString;
  Mail1 := QuSendDBF.FieldByName('Mail1').AsString;
  Mail2 := QuSendDBF.FieldByName('Mail2').AsString;
  Mail3 := QuSendDBF.FieldByName('Mail3').AsString;

  QuSendDBF.Close;

  ExecString := Mail1 +' '+ Mail2 +' '+ Mail3 +' '+'"'+ Topic+'"' +' '+'"'+ Message+'"'  +' '+  fname+'\\';


     try
////////////


       QuSendDBFN:=TMSQuery.Create(nil);
       QuSendDBFN.Connection:=CreateDbfForMail0.DB;
       QuSendDBFN.SQL.Clear;
       QuSendDBFN.SQL.Text:='select distinct NomNaklR '
                           +' from v_NaklRPost_Export v '
                           +'  where v.PostNo = Isnull(:PostNo ,v.PostNo) '
                           +'    and v.AddressNo = Isnull(:AddressNo ,v.AddressNo)'
                           +'    and Isnull (:date1,cast(v.date as date)) <= cast(v.date as date)'
                           +'    and Isnull (:date2,cast(v.date as date)) >= cast(v.date as date)';
       QuSendDBFN.Prepare;
       QuSendDBFN.ParamByName('PostNo').Value := QuSendDBFA.FieldByName('PostNo').AsInteger;
       QuSendDBFN.ParamByName('AddressNo').Value := AddressNo;
       QuSendDBFN.ParamByName('date1').AsDate := floor(QuSendDBFA.FieldByName('DateBeg').AsDateTime);
       QuSendDBFN.ParamByName('date2').AsDate := floor(QuSendDBFA.FieldByName('DateEnd').AsDateTime);

       QuSendDBFN.Open;
       QuSendDBFN.First;

       if QuSendDBFN.RecordCount =0 then
        begin
          DelDir(fname);
          ExecRun := false;
//        raise Exception.Create('��� ������ � �������! ��������� ������� ��������!!!'+ #10#13 +QuSendDBF.SQL.Text);
        end;
//       showmessage(inttostr(QuSendDBFN.RecordCount));

       if ExecRun then  makedir(fname);

       while not QuSendDBFN.Eof do
       begin
       dbf_name := fname + '\\'+QuSendDBFN.FieldByName('NomNaklR').AsString+'.dbf';
//      showmessage (dbf_name);

         CreateDbfForMail0.quNaklRPostExport.Close;
         CreateDbfForMail0.quNaklRPostExport.ParamByName('PostNo').Value := QuSendDBFA.FieldByName('PostNo').AsInteger;
         CreateDbfForMail0.quNaklRPostExport.ParamByName('Date1').AsDate := QuSendDBFA.FieldByName('DateBeg').AsDateTime;
         CreateDbfForMail0.quNaklRPostExport.ParamByName('Date2').AsDate := QuSendDBFA.FieldByName('DateEnd').AsDateTime;
         CreateDbfForMail0.quNaklRPostExport.ParamByName('AddressNo').AsInteger := QuSendDBFA.FieldByName('AddresNo').AsInteger;
         CreateDbfForMail0.quNaklRPostExport.ParamByName('NomNaklR').AsInteger := QuSendDBFN.FieldByName('NomNaklR').AsInteger;
         CreateDbfForMail0.quNaklRPostExport.Open;

         if CreateDbfForMail0.quNaklRPostExport.RecordCount =0 then raise Exception.Create('�� ������ ������� ��������.');

         CreateDbfForMail0.quNaklRPostExport.First;

{
         FTable_ID:=99;
         DataSetFrom := quNaklRPostExport as TDataset;
         DataSetTo:= CreateDBFDataSet(FTable_ID,dbf_name) as TDataset;
         ExportTODBF(DataSetFrom,DataSetTo,True);
}
// -------------------------------

         with CreateDbfForMail0.TableDBF do
         begin
           DatabaseName := extractfilepath(fname); (* alias *)
           TableName := dbf_name;
           TableType := ttFoxPro;

           with FieldDefs do
           begin
             Clear;
             with AddFieldDef do
             begin
               Name := 'TovNPost';
               DataType := ftInteger;
             end;

             with AddFieldDef do
             begin
               Name := 'BarCode';
               DataType := ftString;
             end;

             with AddFieldDef do
             begin
               Name := 'NameTov';
               DataType := ftString;
             end;

             with AddFieldDef do
             begin
               Name := 'EdIzm';
               DataType := ftString;
             end;

             with AddFieldDef do
             begin
               Name := 'PrNoNDS';
               DataType := ftFloat;
               Precision := 3;
             end;

             with AddFieldDef do
             begin
               Name := 'Price';
               DataType := ftFloat;
             end;

             with AddFieldDef do
             begin
               Name := 'StavNDS';
               DataType := ftString;
             end;

             with AddFieldDef do
             begin
               Name := 'QTY';
               DataType := ftFloat;
               Precision := 3;
             end;
             with AddFieldDef do
             begin
               Name := 'SumNoNDS';
               DataType := ftFloat;
               Precision := 3;
             end;
             with AddFieldDef do
             begin
               Name := 'Summa';
               DataType := ftFloat;
             end;
             with AddFieldDef do
             begin
               Name := 'NomNaklR';
               DataType := ftInteger;
             end;
             with AddFieldDef do
             begin
               Name := 'Date';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'SumNaklR';
               DataType := ftFloat;
             end;
             with AddFieldDef do
             begin
               Name := 'SNRNoNDS';
               DataType := ftFloat;
               Precision := 3;
             end;
             with AddFieldDef do
             begin
               Name := 'OurFirm';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'OurOKPO';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'Firm';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'AdrPost';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'PostNo';
               DataType := ftString;
             end;
             with AddFieldDef do
             begin
               Name := 'AddresId';
               DataType := ftString;
             end;


           end;
           CreateTable;
           Open;
         end;


    while not CreateDbfForMail0.quNaklRPostExport.Eof do
  begin
    CreateDbfForMail0.TableDbf.Insert;
    CreateDbfForMail0.TableDBF.FieldByName('TovNPost').AsInteger := CreateDbfForMail0.quNaklRPostExport.FieldByName('TovarNoP').AsInteger;
    CreateDbfForMail0.TableDBF.FieldByName('BarCode').AsString := IntToStr(CreateDbfForMail0.quNaklRPostExport.FieldByName('BarCode').AsInteger);
    CreateDbfForMail0.TableDBF.FieldByName('NameTov').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('NameTov').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('EdIzm').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('EdIzm').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('PrNoNDS').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('PrNoNDS').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('Price').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('Price').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('StavNDS').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('StavNDS').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('QTY').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('QTY').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('SumNoNDS').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('SumNoNDS').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('Summa').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('Summa').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('NomNaklR').AsInteger := CreateDbfForMail0.quNaklRPostExport.FieldByName('NomNaklR').AsInteger;
    CreateDbfForMail0.TableDBF.FieldByName('Date').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('Date').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('SumNaklR').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('SumNaklR').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('SNRNoNDS').AsFloat := CreateDbfForMail0.quNaklRPostExport.FieldByName('SNRNoNDS').AsFloat;
    CreateDbfForMail0.TableDBF.FieldByName('OurFirm').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('OurFirm').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('OurOKPO').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('OurOKPO').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('Firm').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('Firm').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('AdrPost').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('AdrPost').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('PostNo').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('PostNo').AsString;
    CreateDbfForMail0.TableDBF.FieldByName('AddresId').AsString := CreateDbfForMail0.quNaklRPostExport.FieldByName('AddresId').AsString;

    CreateDbfForMail0.TableDBF.Post;
    CreateDbfForMail0.quNaklRPostExport.Next;
  end;

// -------------------------------
   CreateDbfForMail0.TableDBF.Close;



         QuSendDBFN.Next;
       end;

     except
        ShowMessage('������ �������� � dbf' + #10#13 + dbf_name);
     end;


//  showmessage(ExecString);

  if  ExecRun = true then
   begin
//         FilePath := 'd:\Send_Mail\Send_Mail.exe';
         FilePath := ExtractFilePath(Application.ExeName)+'Send_Mail.exe';
         if ShellExecute(0,
                         'open',
                         pAnsiChar(FilePath),
                         pAnsiChar(ExecString),
                         pAnsiChar(ExtractFilePath(Application.ExeName)),
                         SW_MINIMIZE ) < 32
         then
           ShowMessage('�� ����������� ��������� Send_Mail.exe! (������ �������� ������).'+ #10#13 +' �������� ���������� ��������������!');
   end;
//  ShowMessage(fname);
  Next:
  ExecRun := True;
  QuSendDBFA.Next;
  end; // 2

end; //1

////////////////////////////////////////////////////////////////////////////////

function IsOLEObjectInstalled(Name:string):boolean;
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

procedure TCreateDbfForMail0.CreateAndSendExcelFile(PostNo : integer; DateBeg : TDateTime; DateEnd : TDateTime; Is_Period : boolean; Is_SendMail : boolean; SendAddressNo : integer);
 var
   cls_ExcelObject: string;
   RegData: TRegistry;
   Workbook, WorkSheet, ArrayData, {Excel,} Range, Cell1, Cell2 : Variant;
   Excel : OleVariant;

   QuPreparationSQL: TMSQuery;
   QuExportExcelFile: TMSQuery;
   QuSendXLSA: TMSQuery;
   QuSendXLS: TMSQuery;
   QuSendXLSN: TMSQuery;
   Select, Select1, fname, fname1, xls_name, dbf_name1 : String;
   Topic, Message, Mail1, Mail2, Mail3 : String;
   ExecString, s, FilePath  : String;
   AddressNo : Integer;
   BeginCol, BeginRow, RowCount, ColCount, j: integer;
   ExecRun : Boolean;

   myFile : TextFile;
   text   : string;
begin
   BeginCol := 1;
   BeginRow := 1;
   ExecRun := True;

   AssignFile(myFile, 'd:\Temp_Send_MailAll\LogCreateDbfForMail.txt');

   if not FileExists('d:\Temp_Send_MailAll\LogCreateDbfForMail.txt') then ReWrite(myFile)
                                                                     else Append(myFile);

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

   Append(myFile);
   WriteLn(myFile, '��������� ���������� Excel ');
   CloseFile(myFile);

   if not IsOLEObjectInstalled(cls_ExcelObject) then begin
                                                       Append(myFile);
                                                       WriteLn(myFile, 'Excel �� ����������');
                                                       CloseFile(myFile);
                                                       exit;
                                                     end
                                                else begin
                                                       Append(myFile);
                                                       WriteLn(myFile, 'Excel ����������');
                                                       CloseFile(myFile);
                                                     end;




  Append(myFile);
  WriteLn(myFile, '������� ������ �������');
  CloseFile(myFile);

  QuPreparationSQL := TMSQuery.Create(nil);
  QuPreparationSQL.Connection:=CreateDbfForMail0.DB;
  QuPreparationSQL.SQL.Clear;
  QuPreparationSQL.SQL.Text :=  'select Column_Name '
                               +'  from L_VidExportExelFile '
                               +'   where Is_Checked = 1 '
                               +'     and PostNo = :PostNo '
                               +'order by N_pp';
  QuPreparationSQL.ParamByName('PostNo').AsInteger := PostNo;
  QuPreparationSQL.Open;

{
  if QuPreparationSQL.RecordCount = 0 then raise Exception.Create('��� ����� � ' + IntToStr(PostNo) + #10#13 +
                                                                  '�� �������� ������ �����.');
}

  QuPreparationSQL.First;
  Select := '';

  while not QuPreparationSQL.Eof do
   begin
     if Is_SendMail then begin
                           Select := Select + QuPreparationSQL.FieldByName('Column_Name').AsString + ', ';
                         end
                    else begin
                           Select := Select + 'cast('+QuPreparationSQL.FieldByName('Column_Name').AsString+' as varchar), ';
                         end;
     Select1 := Select1 + '''' + QuPreparationSQL.FieldByName('Column_Name').AsString +''''+ ', ';
     QuPreparationSQL.Next;
   end;

  Append(myFile);
  WriteLn(myFile, '������� ��������� ������� �� ������ �������');
  CloseFile(myFile);

  delete (Select,Length(Select)-1,Length(Select));
  delete (Select1,Length(Select1)-1,Length(Select1));
   //////////////////

  QuSendXLSA:=TMSQuery.Create(nil);
  QuSendXLSA.Connection:=CreateDbfForMail0.DB;
  QuSendXLSA.SQL.Clear;
  QuSendXLSA.SQL.Text:='select distinct AddressNo  '
                     +'        ,AdrPost            '
                     +'  from v_NaklRPost_Export v '
                     +'   where v.PostNo = :PostNo '
                     +'    and Isnull (:date1,cast(v.date as date)) <= cast(v.date as date)'
                     +'    and Isnull (:date2,cast(v.date as date)) >= cast(v.date as date)'
                     +'    and AddressNo = :AddressNo ';
  QuSendXLSA.Prepare;
  QuSendXLSA.ParamByName('PostNo').Value := PostNo;
  QuSendXLSA.ParamByName('AddressNo').Value := SendAddressNo;

  if Is_period then begin
                      QuSendXLSA.ParamByName('Date1').AsDate := DateBeg;
                      QuSendXLSA.ParamByName('Date2').AsDate := DateEnd;
                    end;

  QuSendXLSA.Open;

  if QuSendXLSA.RecordCount <> 0 then begin
                                        Append(myFile);
                                        WriteLn(myFile, '�������� ���� � �������� QuSendXLSA ');
                                        CloseFile(myFile);
                                      end;
  //  if QuSendXLSA.RecordCount = 0 then raise Exception.Create('�� ����� ������ �������!'+ #10#13 +QuSendXLSA.SQL.Text);

  QuSendXLSA.First;

  while not QuSendXLSA.Eof do

  begin // 2



     AddressNo := QuSendXLSA.FieldByName('AddressNo').AsInteger;
     fname := 'd:\\Temp_Send_MailAll\\' + IntToStr(PostNo)+'\\'+QuSendXLSA.FieldByName('AddressNo').AsString;
     fname1 := 'd:\Temp_Send_MailAll\' + IntToStr(PostNo)+'\'+QuSendXLSA.FieldByName('AddressNo').AsString;

     ExecString := '';
     s := '''0''';


     QuSendXLS:=TMSQuery.Create(nil);
     QuSendXLS.Connection:=CreateDbfForMail0.DB;
     QuSendXLS.SQL.Clear;
     QuSendXLS.SQL.Text:='select PostNo'
                        +'       ,isnull(case when LEN(Topic)<1 then '+s+' else Topic end,'+s+') Topic'
                        +'       ,isnull(case when LEN(Message)<1 then '+s+' else Message end,'+s+') Message'
                        +'       ,isnull(case when LEN(Mail1)<1 then '+s+' else Mail1 end,'+s+') Mail1'
                        +'       ,isnull(case when LEN(Mail2)<1 then '+s+' else Mail2 end,'+s+') Mail2'
                        +'       ,isnull(case when LEN(Mail3)<1 then '+s+' else Mail3 end,'+s+') Mail3'
                        +'  from Post_Mail where PostNo = :PostNo and AddressNo = :AddressNo'
                        +'   ';
     QuSendXLS.Prepare;
     QuSendXLS.ParamByName('PostNo').Value := PostNo;
     QuSendXLS.ParamByName('AddressNo').Value := AddressNo;
     QuSendXLS.Open;

//     if QuSendXLS.RecordCount =0 then raise Exception.Create('��������� ������� ������������ ������ � �����������! '+ #10#13+'�� ������ ��������: '+QuSendXLSA.FieldByName('AdrPost').AsString+'. ��� ������������ ������'+  #10#13 +QuSendXLS.SQL.Text);

     Topic := QuSendXLS.FieldByName('Topic').AsString;
     Message := QuSendXLS.FieldByName('Message').AsString;
     Mail1 := QuSendXLS.FieldByName('Mail1').AsString;
     Mail2 := QuSendXLS.FieldByName('Mail2').AsString;
     Mail3 := QuSendXLS.FieldByName('Mail3').AsString;

     Append(myFile);
     WriteLn(myFile, '������� �� ���� ������ ���� ������, ���� ������ � 3 ����������� ������ �� ����� ����������� ������ '+ IntToStr(PostNo)+'_'+QuSendXLSA.FieldByName('AddressNo').AsString+' '+Topic+' '+Message+' '+Mail1+' '+Mail2+' '+Mail3);
     CloseFile(myFile);

     QuSendXLS.Close;

     ExecString := Mail1 +' '+ Mail2 +' '+ Mail3 +' '+'"'+ Topic+'"' +' '+'"'+ Message+'"'  +' '+  fname+'\\';

     Append(myFile);
     WriteLn(myFile, ' ���� �� ������� ��������� QuSendXLSN');
     CloseFile(myFile);

     QuSendXLSN:=TMSQuery.Create(nil);
     QuSendXLSN.Connection:=CreateDbfForMail0.DB;
     QuSendXLSN.SQL.Clear;
     QuSendXLSN.SQL.Text:='select distinct NomNaklR '
                         +'               ,Date '
                         +' from v_NaklRPost_Export v '
                         +'  where v.PostNo = Isnull(:PostNo ,v.PostNo) '
                         +'    and v.AddressNo = Isnull(:AddressNo ,v.AddressNo)'
                         +'    and Isnull (:date1,cast(v.date as date)) <= cast(v.date as date)'
                         +'    and Isnull (:date2,cast(v.date as date)) >= cast(v.date as date)';
     QuSendXLSN.Prepare;
     QuSendXLSN.ParamByName('PostNo').Value := PostNo;
     QuSendXLSN.ParamByName('AddressNo').Value := AddressNo;

     if not Is_period then begin
                             QuSendXLSN.ParamByName('Date1').Clear;
                             QuSendXLSN.ParamByName('Date2').Clear;
                           end;
     if Is_period then begin
                         QuSendXLSN.ParamByName('Date1').AsDate := DateBeg;
                         QuSendXLSN.ParamByName('Date2').AsDate := DateEnd;
                       end;
     QuSendXLSN.Open;
     QuSendXLSN.First;



     if QuSendXLSN.RecordCount =0 then
        begin
          ExecRun := false;
          Append(myFile);
          WriteLn(myFile, '  ��� ��������� � '+DateToStr(DateBeg) + ' �� '+DateToStr(DateEnd));
          CloseFile(myFile);
//        raise Exception.Create('��� ������ � �������! ��������� ������� ��������!!!'+ #10#13 +QuSendDBF.SQL.Text);
        end;


     while not QuSendXLSN.Eof do
       begin // QuSendXLSN
         if ExecRun then Begin
                           makedir(fname);
                           Append(myFile);
                           WriteLn(myFile, '  ��������� ����� ' + QuSendXLSN.FieldByName('NomNaklR').AsString );
                           CloseFile(myFile);
                         End;
         xls_name := fname1 + '\'+QuSendXLSN.FieldByName('Date').AsString+'_'+QuSendXLSN.FieldByName('NomNaklR').AsString+'.xls';

         QuExportExcelFile := TMSQuery.Create(nil);
         QuExportExcelFile.Connection:=CreateDbfForMail0.DB;
         QuExportExcelFile.SQL.Clear;
         if Is_SendMail then begin
                               QuExportExcelFile.SQL.Text :=  'select ' + Select
                                                             +' from V_NaklRPost_Export '
                                                             +'  where PostNo = :PostNo '
                                                             +'    and Isnull (:DateBeg,cast(date as date)) <= cast(date as date) '
                                                             +'    and Isnull (:DateEnd,cast(date as date)) >= cast(date as date) '
                                                             +'    and NomNaklR = isnull(:NomNaklR,NomNaklR) '
                                                             +'order by VidName, NameTovar ';
                             end
                        else begin
                               QuExportExcelFile.SQL.Text :=  'select ' + Select1
                                                             +'union all '
                                                             +'select ' + Select
                                                             +' from V_NaklRPost_Export '
                                                             +'  where PostNo = :PostNo '
                                                             +'    and Isnull (:DateBeg,cast(date as date)) <= cast(date as date) '
                                                             +'    and Isnull (:DateEnd,cast(date as date)) >= cast(date as date) '
                                                             +'    and NomNaklR = isnull(:NomNaklR,NomNaklR) ';
//                                                             +'order by VidName, NameTovar ';
                             end;
         QuExportExcelFile.ParamByName('PostNo').AsInteger := PostNo;
         QuExportExcelFile.ParamByName('NomNaklR').AsInteger := QuSendXLSN.FieldByName('NomNaklR').AsInteger;

         if Is_period then begin
                             QuExportExcelFile.ParamByName('DateBeg').AsDate := DateBeg;
                             QuExportExcelFile.ParamByName('DateEnd').AsDate := DateEnd;
                           end;
         QuExportExcelFile.Open;
{
         if QuExportExcelFile.RecordCount = 0 then raise Exception.Create('��� ����� � ' + IntToStr(PostNo) + #10#13 +
                                                                          '�� ������ � ' + datetostr(DateBeg) + ' �� '+ datetostr(DateEnd) + #10#13 +
                                                                          '������ �� ����!');
}
         RowCount := QuExportExcelFile.RecordCount;
         ColCount := QuPreparationSQL.RecordCount;


////////////////////////////////////////////////////////////////////////////////
{
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

         Append(myFile);
         WriteLn(myFile, '  ��������� ���������� Excel ');
         CloseFile(myFile);

         if not IsOLEObjectInstalled(cls_ExcelObject) then
          begin
            Append(myFile);
            WriteLn(myFile, '  Excel �� ����������');
            CloseFile(myFile);
//            ShowMessage('Excel �� ����������.');
            exit;
          end;
}
////////////////////////////////////////////////////////////////////////////////
         // ��� ������ ������� Excel
         Append(myFile);
         WriteLn(myFile, '  C������ OleObject');
         CloseFile(myFile);

         Excel := CreateOleObject(cls_ExcelObject);

         // ��������� ������� Excel �� �������,
         // ����� �������� ��������� ���������� ����������
         // � ������ ������� ���������

         Append(myFile);
         WriteLn(myFile, '  ��������� �� ������ �������� Excel ��� ��������� ������');
         CloseFile(myFile);

         Excel.Application.ScreenUpdating := False;
         Excel.Application.EnableEvents := false;
         Excel.Application.Interactive := False;
         Excel.Application.DisplayAlerts := False;
         Excel.Application.DisplayStatusBar := False;
         Excel.Visible := false;

         Append(myFile);
         WriteLn(myFile, '  ������� ����� �������');
         CloseFile(myFile);
         // ������� ����� �������

         Workbook := Excel.Workbooks.Add; //(xls_name);

         WorkSheet := Excel.Workbooks[1].WorkSheets[1];
         ArrayData := VarArrayCreate([1, RowCount, 1, ColCount], varVariant);

         QuExportExcelFile.First;
         while not QuExportExcelFile.Eof do
          begin
            For J := 1 To QuPreparationSQL.RecordCount Do
              Begin
                  ArrayData[QuExportExcelFile.RecNo, J] :=
                   QuExportExcelFile.FieldbyName(QuExportExcelFile.FieldDefs.Items[j - 1].DisplayName).value;
              End;
            QuExportExcelFile.Next;
          end;

       // ����� ������� ������ �������, � ������� ����� �������� ������
         Cell1 := WorkBook.WorkSheets[1].Cells[BeginRow, BeginCol];
       // ������ ������ ������ �������, � ������� ����� �������� ������
         Cell2 := WorkBook.WorkSheets[1].Cells[BeginRow + RowCount - 1,
         BeginCol + ColCount - 1];

       // �������, � ������� ����� �������� ������
         Range := WorkBook.WorkSheets[1].Range[Cell1, Cell2];

         Append(myFile);
         WriteLn(myFile, '  ������� ������');
         CloseFile(myFile);

       // � ��� � ��� ����� ������
       // ������� ������� ����������� ����������
         Range.Value := ArrayData;

         QuExportExcelFile.Close;

//         Excel.Application.EnableEvents := true;
//         Excel.Application.Interactive := true;
//         Excel.Application.DisplayAlerts := true;

         Append(myFile);
         WriteLn(myFile, '  ��������� ������ � ' + xls_name);
         CloseFile(myFile);

         Excel.ActiveWorkBook.SaveAs(xls_name);

         Append(myFile);
         WriteLn(myFile, '  ������ ���� ' + xls_name);
         CloseFile(myFile);
         //         Excel.ActiveWorkBook.Close(0); // xlDontSaveChanges

         Append(myFile);
         WriteLn(myFile, '  ������� �� Excel');
         CloseFile(myFile);

         Excel.Quit;

         Append(myFile);
         WriteLn(myFile, '  ��������� ����� ����� ����� OleObject � ���������� OleObject');
         WriteLn(myFile, ' ');
         CloseFile(myFile);

         Excel := Unassigned;

         QuSendXLSN.Next;
       end; // QuSendDBFN

//     FilePath := 'd:\Send_Mail\Send_Mail.exe';
     FilePath := ExtractFilePath(Application.ExeName)+'Send_Mail.exe';

     if ExecRun then begin
                       Append(myFile);
                       WriteLn(myFile, '���������� ������ �� ��������� ���� ��������� �� ����� ������ '+ IntToStr(PostNo)+'_'+QuSendXLSA.FieldByName('AddressNo').AsString);
                       CloseFile(myFile);
                     end;
     if Is_SendMail then
      if ExecRun = True then
         if ShellExecute(0,
                         'open',
                         pAnsiChar(FilePath),
                         pAnsiChar(ExecString),
                         pAnsiChar(ExtractFilePath(Application.ExeName)),
                         SW_MINIMIZE ) < 32
          then begin
                 Append(myFile);
                 WriteLn(myFile, '�� ����������� ��������� Send_Mail.exe! (������ �������� ������).');
                 CloseFile(myFile);
               end;

     Append(myFile);
     WriteLn(myFile, '�������� ��������� �� ' + fname1 + ' ���������');
     WriteLn(myFile, ' ');
     CloseFile(myFile);

     ExecRun := True;
     QuSendXLSA.Next;
   end;

   QuPreparationSQL.Close;
end;



end.
