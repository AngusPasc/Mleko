unit InPlatTov;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Dialogs,
  StdCtrls, Forms, MlekoForm, DBCtrls, DB, Mask, ExtCtrls, Buttons, Grids,
  DBGrids, RXDBCtrl, IniFiles, DBCtrlsEh, Math,
  DBAccess, MsAccess, Variants, RxMemDS, MemDS, ActnList, DBGridEh,
  DBLookupEh;

type
  ECashError = class(Exception);

  TfmEditPlat = class(TMlekoForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label4: TLabel;
    EditDate: TDBEdit;
    Label5: TLabel;
    EditSumma: TDBEdit;
    Label6: TLabel;
    EditSpravka: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    quDolg: TMSQuery;
    RxDBGrid1: TRxDBGrid;
    dsDolg: TDataSource;
    quDolgNaklNo: TIntegerField;
    quDolgNom: TIntegerField;
    deNom: TDBEdit;
    quMaxNom: TMSQuery;
    quMaxNomNom: TIntegerField;
    quRashod: TMSQuery;
    lcPost: TDBLookupComboBox;
    lcTipNakl: TDBLookupComboBox;
    quSaleCash: TMSQuery;
    quRashodNaklNo: TIntegerField;
    quRashodRasNo: TSmallintField;
    quRashodNameTovarShort: TStringField;
    quNaklR: TMSQuery;
    quNaklRNaklNo: TIntegerField;
    quNaklRPostNo: TSmallintField;
    quNaklRBuh: TSmallintField;
    quNaklRRealDateOpl: TDateTimeField;
    quNaklRDateNakl: TDateTimeField;
    quPlatP: TMSQuery;
    dsPlatP: TDataSource;
    quTipNakl: TMSQuery;
    quTipNaklTipNo: TSmallintField;
    quTipNaklTipName: TStringField;
    quDolgSumma: TFloatField;
    quDolgSummaDolg: TFloatField;
    quDolgDateNakl: TDateTimeField;
    quDolgSumOplat: TFloatField;
    quDolgSotrudNo: TSmallintField;
    quRashodPriceOut: TFloatField;
    quRashodKol: TFloatField;
    quRashodKolOpl: TFloatField;
    quRashodTovarNo: TSmallintField;
    quWork: TMSQuery;
    lcSotrud: TDBLookupComboBox;
    Label3: TLabel;
    Label7: TLabel;
    quPodotchetList: TMSQuery;
    quPodotchetListPodotchetRNo: TSmallintField;
    quPodotchetListSotrudNo: TSmallintField;
    quPodotchetListNaklNo: TIntegerField;
    quPodotchetListDatePodotche: TDateTimeField;
    quPodotchetListSumma: TFloatField;
    quPodotchetListSummaPlat: TFloatField;
    quPodotchetListPodotchetNom: TStringField;
    quPodotchetP: TMSQuery;
    quPodotchetR: TMSQuery;
    quPodotchetRPodotchetRNo: TSmallintField;
    quPodotchetRDatePodotche: TDateTimeField;
    quPodotchetRNom: TIntegerField;
    quPodotchetRName: TStringField;
    quPodotchetRDateNaklFirst: TDateTimeField;
    quPodotchetRSummaDolg: TFloatField;
    quPodotchetRSotrudNo: TSmallintField;
    quDolgOtdelName: TStringField;
    quNaklRAddressNo: TSmallintField;
    quArticle: TMSQuery;
    quArticleTovarNo: TSmallintField;
    quArticleArticle_0: TSmallintField;
    quArticleArticle_1: TSmallintField;
    mdSpravka: TRxMemoryData;
    mdSpravkaNaklNo: TIntegerField;
    mdSpravkaSumma: TFloatField;
    Label8: TLabel;
    spModify_Plat_Nakl_link: TMSStoredProc;
    DSBuh: TDataSource;
    QuBuh: TMSQuery;
    quPost: TMSQuery;
    DSPost: TDataSource;
    quRashodWithNoNDS: TBooleanField;
    quRashodIsStavNDS: TBooleanField;
    Label9: TLabel;
    Label10: TLabel;
    cbCurrencyHead: TDBLookupComboboxEh;
    dbeRateCurrencyHead: TDBEdit;
    dsCurrency: TMSDataSource;
    quCurrency: TMSQuery;
    quCurrencyNAME: TStringField;
    quCurrencyL_CODE: TStringField;
    Label11: TLabel;
    cbCurrencyAccounting: TDBLookupComboboxEh;
    Label12: TLabel;
    dbeRateCurrencyAccounting: TDBEdit;
    Label13: TLabel;
    EditSummaAccounting: TDBEdit;
    quDolgCurrencyHead: TStringField;
    quDolgSummaCurrencyAccounting: TFloatField;
    quDolgSummaDolgCurrencyAccounting: TFloatField;
    quDolgSumOplatCurrencyAccounting: TFloatField;
    dsCurrencyAccounting: TMSDataSource;
    quCurrencyAccounting: TMSQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure bbOkClick(Sender: TObject);
    procedure quDolgAfterPost(DataSet: TDataSet);
    procedure quDolgSumOplatChange(Sender: TField);
    procedure RxDBGrid1Exit(Sender: TObject);
    procedure quDolgAfterInsert(DataSet: TDataSet);
    procedure RxDBGrid1GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quPlatPNewRecord(DataSet: TDataSet);
    procedure EditDateExit(Sender: TObject);
    procedure FiscPrinterPrintChek;
    procedure FiscCashPrintChek;
    procedure quDolgBeforeOpen(DataSet: TDataSet);
    procedure quNaklRBeforeOpen(DataSet: TDataSet);
    procedure quPlatPAfterPost(DataSet: TDataSet);
    procedure quPlatPAfterUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure quPlatPBeforeUpdateExecute(Sender: TCustomMSDataSet;
      StatementTypes: TStatementTypes; Params: TMSParams);
    procedure cbCurrencyHeadChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbCurrencyHeadExit(Sender: TObject);
    procedure cbCurrencyAccountingExit(Sender: TObject);
    procedure quDolgBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    l_PlatNo: integer;
    SummaDolg: double;
    SummaDolgAccounting: double;
    Buh: boolean;
    PKeyPlat: Int64;
    CurrencyHead: string;
    RateCurrencyHead: real;
    RateCurrencyAccounting: real;
  public
    { public declarations }
  end;
const
  Digits: array[1..25] of Char = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');
var
  fmEditPlat: TfmEditPlat;
procedure PrihodManyTov(Buh: boolean);
implementation

uses data, EditDebet, PrihodPodotchet0, main;

{$R *.DFM}

{����� ��������
 ��� �������� (�� 14 ��������)
 ���� (�� 0.00  �� 999999.99) - ����� � ��� ����� ����� ��� �����������
 ���������� (�� 0.001 �� 99999.999) - ����� � ��� ����� ����� ��� �����������
 ����� ������ (�� 1 �� 9)
 ����� ������ ������ (�� 1 �� 99)
 ����� ��������� ������ (�� 1 �� 8)
 ��������� ���� (������ ���� ����� 0)
 ��������� ���� (������ ���� ����� 0)}

function SerNom(Nom: string): string;
var
  i: integer;
begin
  if Length(Nom) = 0 then
    Result := '� 0001'
  else
  begin
    if Copy(Nom, 3, Length(Nom)) = '9999' then
    begin
      i := 1;
      while Copy(Nom, 1, 1) <> Digits[i] do
        inc(i);
      Result := Digits[i + 1] + ' 0001'
    end
    else
    begin
      case Length(IntToStr(StrToInt(Copy(Nom, 3, Length(Nom))) + 1)) of
        1: Result := Copy(Nom, 1, 5) + IntToStr(StrToInt(Copy(Nom, 3, Length(Nom))) + 1);
        2: Result := Copy(Nom, 1, 4) + IntToStr(StrToInt(Copy(Nom, 3, Length(Nom))) + 1);
        3: Result := Copy(Nom, 1, 3) + IntToStr(StrToInt(Copy(Nom, 3, Length(Nom))) + 1);
        4: Result := Copy(Nom, 1, 2) + IntToStr(StrToInt(Copy(Nom, 3, Length(Nom))) + 1);
      end;
    end;
  end;

end;

procedure PrihodManyTov(Buh: boolean);
var
  PostNo: integer;
  Name, l_code : string;
  Rate : real;
begin

  dmDataModule.OpenSQL('select c.Name, c.l_code, ce.Rate from D_CURRENCY c inner join CurrencyExchange ce on c.IsDefault = 1 and ce.IsActive = 1 and ce.CurrencyId = c.ID and c.isTrash = 0');
  Name := dmDataModule.qfo.FieldByName('Name').Value;
  l_code := dmDataModule.qfo.FieldByName('l_code').Value;
  Rate := dmDataModule.qfo.FieldByName('Rate').Value;

  PostNo := EditDebetors(False, Buh);
  if PostNo = 0 then exit;

  fmEditPlat := TfmEditPlat.Create(Application);
  try


    fmEditPlat.Buh := Buh;
    with fmEditPlat do
    begin
      mdSpravka.Active := True;
      quDolg.ParamByName('PostNo').AsInteger := PostNo;
      if Buh then
      begin
        quDolg.ParamByName('BuhB').AsInteger := 2;
        quDolg.ParamByName('BuhE').AsInteger := 3;
      end
      else
      begin
        quDolg.ParamByName('BuhB').AsInteger := 1;
        quDolg.ParamByName('BuhE').AsInteger := 1;
      end;
      quDolg.Open;
      fmEditPlat.SummaDolg := 0;
      fmEditPlat.SummaDolgAccounting := 0;
      while not (fmEditPlat.quDolg.EOF) do
      begin
        fmEditPlat.SummaDolg := fmEditPlat.SummaDolg + fmEditPlat.quDolgSummaDolg.AsFloat;

        dmDataModule.OpenSQL('select Rate from CurrencyExchange ce left join D_CURRENCY c on c.id = ce.currencyid where IsActive = 1 and (l_code = :p1_l_code)',[quDolgCurrencyHead.Value]);
        RateCurrencyHead := dmDataModule.qfo.FieldByName('Rate').Value;

        dmDataModule.OpenSQL('select ce.Rate from D_CURRENCY c inner join CurrencyExchange ce on c.IsDefault = 1 and ce.IsActive = 1 and ce.CurrencyId = c.ID and c.isTrash = 0');
        RateCurrencyAccounting := dmDataModule.qfo.FieldByName('Rate').Value;

        fmEditPlat.SummaDolgAccounting := fmEditPlat.SummaDolg*RateCurrencyHead/RateCurrencyAccounting;
        //fmEditPlat.SummaDolgAccounting + fmEditPlat.quDolgSummaDolgCurrencyAccounting.AsFloat;
        fmEditPlat.quDolg.Next;
      end;
      fmEditPlat.quDolg.First;
      //
      quPlatP.Open;
      quPlatP.Insert;
{
    fmEditPlat.cbCurrencyHead.KeyValue := l_code;
    fmEditPlat.cbCurrencyAccounting.KeyValue := l_code;
    fmEditPlat.cbCurrencyHead.Text := Name;
    fmEditPlat.cbCurrencyAccounting.Text := Name;
    fmEditPlat.dbeRateCurrencyHead.Text := FloatToStr(Rate);
    fmEditPlat.dbeRateCurrencyAccounting.Text := FloatToStr(Rate);
}
      if Buh then
        quMaxNom.ParamByName('Buh').AsInteger := 2
      else
        quMaxNom.ParamByName('Buh').AsInteger := 1;
      quMaxNom.Open;
      quPlatP.FieldByName('Nom').AsInteger := quMaxNomNom.AsInteger + 1;
      quMaxNom.Close;
      //
      quPlatP.FieldByName('SotrudNo').AsInteger := fmEditPlat.quDolgSotrudNo.AsInteger;
      if Buh then quPlatP.FieldByName('Buh').AsInteger := 2;
      quPlatP.FieldByName('PostNo').AsInteger := PostNo;
      quPlatP.FieldByName('PostNoFirst').AsInteger := PostNo;
      quPlatP.FieldByName('Spravka').AsString := '����. � ';
      dmDataModule.quSotrud.Close;
      dmDataModule.quSotrud.Open;
      quPost.Open;
      quBuh.Open;
      fmEditPlat.Caption := format('%s :����� ����� %2f', [quPost.FieldByName('Name').AsString, fmEditPlat.SummaDolg]);
      fmEditPlat.RxDBGrid1.Col := 6;
    end;
    fmEditPlat.ShowModal;
  finally
    fmEditPlat.quDolg.Close;
    fmEditPlat.quPlatP.Close;
    fmEditPlat.quTipNakl.Close;
    fmEditPlat.Free;
  end;
end;

procedure TfmEditPlat.FiscCashPrintChek;
type
  TSetComPortProc = function(Numb, Speed: Integer): Integer; StdCall;
  TCloseComPortProc = function(Numb: integer): integer; StdCall;
  TResetCashesProc = function: integer; StdCall;
  TIsCashProc = function(NumCash: integer): integer; StdCall;
  TStrPrntCashProc = function(NumCash: integer; str1, str2, str3, str4, str5: PChar): integer; StdCall;
  TSellArtCashProc = function(NumCash: integer; Art: PChar): integer; StdCall;
  TCloseReceiptProc = function(Numb: integer): integer; StdCall;
var
  nLib: THandle;
  SetComPortProc: TSetComPortProc;
  CloseComPortProc: TCloseComPortProc;
  ResetCashesProc: TResetCashesProc;
  IsCashProc: TIsCashProc;
  StrPrntCashProc: TStrPrntCashProc;
  SellArtCashProc: TSellArtCashProc;
  CloseReceiptProc: TCloseReceiptProc;
  Res, Port: Integer;
  OldSeparator: Char;
  Ini: TIniFile;
  CurTime: TDateTime;
  SummaOplat, KolOpl: double;
  PodotchetRNoNew: integer;
  Proba: integer;
begin
  quDolg.AfterPost := nil;
  CurTime := Now();
  quPlatP.Post;
  fmEditPlat.quDolg.First;
  while not (quDolg.EOF) do
  begin
    if quDolgSumOplat.AsFloat > 0 then
    begin
      quPodotchetList.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
      quPodotchetList.Open;

      if quPodotchetList.RecordCount = 1 then
      begin
        quWork.SQL.Clear;
        quWork.SQL.add('UPDATE PodotchetR');
        quWork.SQL.Append('SET  SummaPlat = SummaPlat + :SummaPlat');
        quWork.SQL.Append('WHERE (PodotchetRNo = :PodotchetRNo)');
        quWork.ParamByName('SummaPlat').AsFloat := StrToFloat(EditSumma.Text);
        quWork.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
        quWork.Execute;

        quPodotchetP.Close;
        quWork.SQL.Clear;
        quWork.SQL.Add('select Max(PodotchetPNo) AS MaxPodotchetPNo  from PodotchetP');
        quWork.Open;
        quPodotchetP.ParamByName('PodotchetPNo').AsInteger := quWork.Fields[0].AsInteger + 1;
        quPodotchetP.ParamByName('SotrudNo').AsInteger := quDolgSotrudNo.AsInteger;
        quPodotchetP.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
        quPodotchetP.ParamByName('DatePlat').AsDate := StrToDate(EditDate.Text);
        quPodotchetP.ParamByName('Summa').AsFloat := StrToFloat(EditSumma.Text);
        quPodotchetP.Execute;
        quWork.Close;
      end;

      if quPodotchetList.RecordCount > 1 then
        PrihodPodotchetList(quDolgNaklNo.AsInteger, StrToFloat(EditSumma.Text));

      quPodotchetList.Close;

      ///////////

      quNaklR.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
      quNaklR.Open;
      if (abs(fmEditPlat.quDolgSumOplat.AsFloat - fmEditPlat.quDolgSummaDolg.AsFloat) < 0.01) then
      begin
        quNaklR.Edit;
        quNaklRPostNo.AsInteger := quPlatP.FieldByName('POstNo').AsInteger;
        quNaklRBuh.AsInteger := quPlatP.FieldByName('Buh').AsInteger;
        quNaklRRealDateOpl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
        if quPlatP.FieldByName('POstNo').AsInteger = 90 then //��������
        begin
          quDolg.Edit;
          quDolgDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime; //��� �� �� ���� ���������� ���������� ����
          quDolg.Post;
          quNaklRDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
          quNaklRAddressNo.AsInteger := 1;
        end;
        quNaklR.Post;
      end;
    end;
    fmEditPlat.quDolg.Next;
  end;

  if quPlatP.FieldByName('Buh').AsInteger <> 2 then
    if (Application.MessageBox(PChar('��������� ��� ?'), '������', MB_YESNO) = IDYES) then
    begin
      Screen.Cursor := crHourGlass;
      nLib := LoadLibrary('fisc.dll');
      MessageDlg('1', mtWarning, [mbOK], 0);
      if nLib < 32 then
      begin
        ShowMessage('�� ���� ��������� fisc.dll');
        exit;
      end;
      SetComPortProc := TSetComPortProc(GetProcAddress(nLib, 'SetComPort'));
      CloseComPortProc := TCloseComPortProc(GetProcAddress(nLib, 'CloseComPort'));
      ResetCashesProc := TResetCashesProc(GetProcAddress(nLib, 'ResetCashes'));
      IsCashProc := TIsCashProc(GetProcAddress(nLib, 'IsCash'));
      StrPrntCashProc := TStrPrntCashProc(GetProcAddress(nLib, 'StrPrntCash'));
      SellArtCashProc := TSellArtCashProc(GetProcAddress(nLib, 'SellArtCash'));
      CloseReceiptProc := TCloseReceiptProc(GetProcAddress(nLib, 'CloseReceipt'));
      Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setup.ini');
      Port := dmDataModule.getFiscalPort(dmDataModule.FirmNo);
      Ini.Free;
      try
        Res := SetComPortProc(Port, 4800);

        if (Res < 0) then
          raise ECashError.Create('������ �������� ����� ' + IntToStr(Res));
        ResetCashesProc;
        Res := IsCashProc(1);
        if (Res < 0) then
          raise ECashError.Create('������ ����������� ����� ' + IntToStr(Res));

        fmEditPlat.quDolg.First;
        while not (fmEditPlat.quDolg.EOF) do
        begin
          if fmEditPlat.quDolgSumOplat.AsFloat > 0 then
          begin
            fmEditPlat.quRashod.Close;
            fmEditPlat.quRashod.Open;
            SummaOplat := quDolgSumOplat.AsFloat;
            while not (quRashod.EOF) do
            begin
              if SummaOplat <= ((quRashodKol.AsFloat - quRashodKolOpl.AsFloat) * quRashodPriceOut.AsFloat) then
                KolOpl := SummaOplat / quRashodPriceOut.AsFloat
              else
                KolOpl := (quRashodKol.AsFloat - quRashodKolOpl.AsFloat);
              KolOpl := Round(KolOpl * 1000) / 1000;
              SummaOplat := SummaOplat - KolOpl * quRashodPriceOut.AsFloat;
              if KolOpl > 0 then
              begin
                //ShowMessage(format('���=%.6f ����=%.3f ��������=%.6f',[KolOpl,quRashodPrice.AsFloat,SummaOplat]));
                OldSeparator := SysUtils.DecimalSeparator;
                SysUtils.DecimalSeparator := '.';
                Res := SellArtCashProc(1, PChar(format('0;%.14s;%.2f;%.3f;1;1;1;0;0;',
                  [quRashodNameTovarShort.AsString, quRashodPriceOut.AsFloat, KolOpl])));
                SysUtils.DecimalSeparator := OldSeparator;
                if Res >= 0 then
                begin
                  quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                  quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                  quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                  quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                  quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                  try
                    quSaleCash.Execute;
                  except
                    ShowMessage('������ ������!');
                  end
                end;
              end;
              quRashod.Edit;
              quRashodKolOpl.AsFloat := quRashodKolOpl.AsFloat + KolOpl;
              quRashod.Post;
              if SummaOplat = 0 then break;
              quRashod.Next;
            end;
            StrPrntCashProc(1, PChar('��������� ' + IntToStr(quDolgNom.AsInteger)),
              PChar('�� ' + DateToStr(quDolgDateNakl.AsDateTime)), '', '', '');
            Res := CloseReceiptProc(1);
            if (Res < 0) then
              raise ECashError.Create('������ �������� ���� ' + IntToStr(Res));
            fmEditPlat.quRashod.Close;
          end;

          //
          fmEditPlat.quDolg.Next;
        end;
      finally
        CloseComPortProc(Port);
        FreeLibrary(nLib);
        Screen.Cursor := crDefault;
      end;
    end;
  fmEditPlat.ModalResult := mrOk;
  fmEditPlat.Close;
end;

procedure TfmEditPlat.FiscPrinterPrintChek;
var
  CurTime: TDateTime;
  CheckResultStr: string;
  KolPrintMy, TempStr, KolPrint_Two, KolPrint, PricePrint: string;
  Divided, DelChar, Cycle: integer;


  // OldSeparator:Char;

  TypeTovar: string;
  WithNoNDS: integer;

  TwoLineCheck: Boolean;
  CashSumm, SummaCash, SummaOplat, KolOpl: double;
  PodotchetRNoNew: integer;
  Proba: integer;
  LastArticle, MAXArticle_0, MAXArticle_1: integer;
  ArticleTovarNo_0, ArticleTovarNo_1: integer;
begin
  Screen.Cursor := crHourGlass;
  if ((quPlatP.FieldByName('Buh').AsInteger <> 3) and (quPlatP.FieldByName('Buh').AsInteger <> 4)) then
  begin
    //�������� ����� ��� �������� ����
    quDolg.AfterPost := nil;
    CurTime := Now();
    quPlatP.Post;
    fmEditPlat.quDolg.First;
    while not (quDolg.EOF) do
    begin
      if quDolgSumOplat.AsFloat > 0 then
      begin
        l_PlatNo := quPlatP.FieldByName('PlatNo').AsInteger;
        /////////
        quPodotchetList.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
        quPodotchetList.Open;
        if quPodotchetList.RecordCount = 1 then
        begin
          quWork.SQL.Clear;
          quWork.SQL.add('UPDATE PodotchetR');
          quWork.SQL.Append('SET  SummaPlat = SummaPlat + :SummaPlat');
          quWork.SQL.Append('WHERE (PodotchetRNo = :PodotchetRNo)');
          quWork.ParamByName('SummaPlat').AsFloat := StrToFloat(EditSumma.Text);
          quWork.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
          quWork.Execute;
          quPodotchetP.Close;
          quWork.SQL.Clear;
          quWork.SQL.Add('select Max(PodotchetPNo) AS MaxPodotchetPNo  from PodotchetP');
          quWork.Open;
          quPodotchetP.ParamByName('PodotchetPNo').AsInteger := quWork.Fields[0].AsInteger + 1;
          quPodotchetP.ParamByName('SotrudNo').AsInteger := quDolgSotrudNo.AsInteger;
          quPodotchetP.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
          quPodotchetP.ParamByName('DatePlat').AsDate := StrToDate(EditDate.Text);
          quPodotchetP.ParamByName('Summa').AsFloat := StrToFloat(EditSumma.Text);
          quPodotchetP.Execute;
          quWork.Close;
        end;
        if quPodotchetList.RecordCount > 1 then
          PrihodPodotchetList(quDolgNaklNo.AsInteger, StrToFloat(EditSumma.Text));
        quPodotchetList.Close;
        ///////////
        
        quNaklR.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
        quNaklR.Open;
        if (abs(fmEditPlat.quDolgSumOplat.AsFloat - fmEditPlat.quDolgSummaDolg.AsFloat) < 0.01) then
        begin
          quNaklR.Edit;
          quNaklRPostNo.AsInteger := quPlatP.FieldByName('POstNo').AsInteger;
          quNaklRBuh.AsInteger := quPlatP.FieldByName('Buh').AsInteger;
          quNaklRRealDateOpl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
          if quPlatP.FieldByName('POstNo').AsInteger = 90 then //��������
          begin
            quDolg.Edit;
            quDolgDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime; //��� �� �� ���� ���������� ���������� ����
            quDolg.Post;
            quNaklRDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
            quNaklRAddressNo.AsInteger := 1;
          end;
          quNaklR.Post;
        end;
      end;
      fmEditPlat.quDolg.Next;
    end;
  end;
  if ((quPlatP.FieldByName('Buh').AsInteger = 3) or (quPlatP.FieldByName('Buh').AsInteger = 4)) then
    if (Application.MessageBox(PChar('��������� ��� ?'), '������', MB_YESNO) = IDYES) then
    begin
      if dmDataModule.FiscPrinterConnect(True) then
        //    if 1=1 then
      begin
        {��������� ���������� � ������� ��������� ����� �� ��������.
        ����������: ��������� ����� � ������ ������ ��� -1 � ������ �������.
        GetPrinterKeyPosition ��������� ��������� ��������:
        0 -  "��������" (�);
        1 - "������" (�);
        2 - "X- �����" (X);
        3 - "Z-�����" (Z);
        4 - "����������������" (�).}
		
		
		
		
		
		

	//****************************************************************************************************************	
		  if GlobalOurFirmNo = 490 then
	    	begin
				if FiscPrinter.GetPrinterKeyPosition = 1 then
          //      if 1=1 then
        begin
		
          //��������� ������ � ��������
          if FiscPrinter.LockPrinter(3000) = 1 then
            //      if 1=1 then
          begin
            //�������� ����� � ��������� ����
            quDolg.AfterPost := nil;
            CurTime := Now();
            quPlatP.Post;
            fmEditPlat.quDolg.First;
            while not (quDolg.EOF) do
            begin
              if quDolgSumOplat.AsFloat > 0 then
              begin
                l_PlatNo := quPlatP.FieldByName('PlatNo').AsInteger;
                /////////
                quPodotchetList.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
                quPodotchetList.Open;
                if quPodotchetList.RecordCount = 1 then
                begin
                  quWork.SQL.Clear;
                  quWork.SQL.add('UPDATE PodotchetR');
                  quWork.SQL.Append('SET  SummaPlat = SummaPlat + :SummaPlat');
                  quWork.SQL.Append('WHERE (PodotchetRNo = :PodotchetRNo)');
                  quWork.ParamByName('SummaPlat').AsFloat := StrToFloat(EditSumma.Text);
                  quWork.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
                  quWork.Execute;

                  quPodotchetP.Close;
                  quWork.SQL.Clear;
                  quWork.SQL.Add('select Max(PodotchetPNo) AS MaxPodotchetPNo  from PodotchetP');
                  quWork.Open;
                  quPodotchetP.ParamByName('PodotchetPNo').AsInteger := quWork.Fields[0].AsInteger + 1;
                  quPodotchetP.ParamByName('SotrudNo').AsInteger := quDolgSotrudNo.AsInteger;
                  quPodotchetP.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
                  quPodotchetP.ParamByName('DatePlat').AsDate := StrToDate(EditDate.Text);
                  quPodotchetP.ParamByName('Summa').AsFloat := StrToFloat(EditSumma.Text);
                  quPodotchetP.Execute;
                  quWork.Close;
                end;

                if quPodotchetList.RecordCount > 1 then
                  PrihodPodotchetList(quDolgNaklNo.AsInteger, StrToFloat(EditSumma.Text));

                quPodotchetList.Close;
                ///////////
                quNaklR.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
                quNaklR.Open;
                if (abs(fmEditPlat.quDolgSumOplat.AsFloat - fmEditPlat.quDolgSummaDolg.AsFloat) < 0.01) then
                begin
                  quNaklR.Edit;
                  quNaklRPostNo.AsInteger := quPlatP.FieldByName('POstNo').AsInteger;
                  quNaklRBuh.AsInteger := quPlatP.FieldByName('Buh').AsInteger;
                  quNaklRRealDateOpl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
                  if quPlatP.FieldByName('POstNo').AsInteger = 90 then //��������
                  begin
                    quDolg.Edit;
                    quDolgDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime; //��� �� �� ���� ���������� ���������� ����
                    quDolg.Post;
                    quNaklRDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
                    quNaklRAddressNo.AsInteger := 1;
                  end;
                  quNaklR.Post;
                end;
              end;
              fmEditPlat.quDolg.Next;
            end;

            //����������� ���������� �������
            LastArticle := 0;
            quWork.Close;
            quWork.SQL.Clear;
            quWork.SQL.Add('SELECT MAX(Article_0) AS MAXArticle_0 ');
            quWork.SQL.Append('FROM Articles');
            quWork.Open;
            MAXArticle_0 := quWork.FieldByName('MAXArticle_0').AsInteger;
            quWork.Close;
            quWork.SQL.Clear;
            quWork.SQL.Add('SELECT MAX(Article_1) AS MAXArticle_1 ');
            quWork.SQL.Append('FROM Articles');
            quWork.Open;
            MAXArticle_1 := quWork.FieldByName('MAXArticle_1').AsInteger;
            quWork.Close;
            if (MAXArticle_0 <> 0) or (MAXArticle_1 <> 0) then
            begin
              if MAXArticle_0 > MAXArticle_1 then
                LastArticle := MAXArticle_0 + 1
              else
                LastArticle := MAXArticle_1 + 1
            end
            else
              LastArticle := 1;

            if LastArticle = 9998 then
              if not (Application.MessageBox(PChar('�������� ������������ �������� � �������� ��������. ������� ����������?'), '����������', MB_YESNO)
                = IDYES) then exit;

            //���������� ����������� �� ����
            FiscPrinter.SetCheckBottomLine('          "������ �� �������!"');
            //���������� ����� �������� ���������� ������� �� ����� ����
            {����������� ����� ������� ���������� �������
            (������� � ������� ����������). ���� SaleTaxesOnTotal = 1
            (��������� �� ���������), �� ���������� ������ �����������
            �� ���� ����� ����. ����� (SaleTaxesOnTotal = 0) ����������
            ������ ����������� �� ������ ����� � �����������, � ����� �����������.}
            FiscPrinter.SetTaxesCalcMode(1);
            //���������� ��������� ����� ������ �����
            {�������������/��������� ����� ���������� ������ ��� ������ ����.
            ����������: 1 � ������ ������, 0 � ������ �������.
            TableMode - 1 - ���������� ��������� ����� ������ ���������� � ����,
            0 - ��������� ��������� �����.}
            FiscPrinter.SetTableMode(0);
            //������� ���
            {�������� ����������� ����.
            ����������: 1 � ������ ������, 0 � ������ �������.
            Department - ������������� ������, �� ����� 2-� �������� ������
            (��� ������ �������� M301-MTM ���������� ����� 15 ��������).}
            if FiscPrinter.OpenCheck('����. ����') = 1 then
              //           if 1 = 1 then
            begin
              fmEditPlat.quDolg.First;
              while not (fmEditPlat.quDolg.EOF) do
              begin
                if fmEditPlat.quDolgSumOplat.AsFloat > 0 then
                begin
                  FiscPrinter.FreeTextLine(1, 1, 0, '����. � ' + IntToStr(quDolgNom.AsInteger) +
                    ' �� ' + DateToStr(quDolgDateNakl.AsDateTime));
                  {������ � ����������� ��������� ��������� ����������, �������
                  ����� ���������� ������ ���� (������� TEXT)
                  ����������: 1 � ������ ������, 0 � ������ �������.
                  PlaceBeforFiscalPart - ��������� ������ ������ �� (1) ���
                  ����� (0) ���������� ����� ����;
                  PrintOnJornal - ���������� (1) ��� �� ���������� (0) ������
                  ������ �� ����������� �����;
                  UseBoldStyle - �������� ��� ������ ������� (1) ��� �������
                  (0) ��������;
                  Text - �� 18 �������� ������ (��� ������ �������� �301-���
                  ����������� ����� ������ � 36 ��������)}
                  fmEditPlat.quRashod.Close;
                  fmEditPlat.quRashod.Open;
                  SummaOplat := quDolgSumOplat.AsFloat;
                  while not (quRashod.EOF) do
                  begin
                    if SummaOplat <= ((quRashodKol.AsFloat - quRashodKolOpl.AsFloat) * quRashodPriceOut.AsFloat) then
                      KolOpl := SummaOplat / quRashodPriceOut.AsFloat
                    else
                      KolOpl := (quRashodKol.AsFloat - quRashodKolOpl.AsFloat);
                    KolOpl := Round(KolOpl * 1000) / 1000;
                    SummaOplat := SummaOplat - KolOpl * quRashodPriceOut.AsFloat;
                    if KolOpl > 0 then
                    begin
                      //ShowMessage(format('���=%.6f ����=%.3f ��������=%.6f',[KolOpl,quRashodPrice.AsFloat,SummaOplat]));
                      //OldSeparator:=SysUtils.DecimalSeparator;
                      //SysUtils.DecimalSeparator:='.';
                      //������� �������� ������ �� ������

                      {LONG FiscalLine([in] BSTR GoodName, [in] LONG Qty, [in] LONG Price,
                      [in] LONG GoodsDividual, [in] LONG Tax1Index, [in] LONG Tax2Index,
                      [in] LONG Article)
                      ������ ��������� �������� ������
                      ����������: ����� �� ������ ������ ���� � ������ ������, 0 � ������
                      �������.
                      GoodName - ������������ ������ (�� 12 ��������). ��� ������ ���-T1
                      �������� ����� ������������ ������ ���������� 36 ���������.
                      ��� ������ MTM-T3 � MTM-T4 ����� ������������ ����� ����������
                      43 �������;
                      Qty - ���������� ������: �����, ���� Divided == 0 ��� ������,
                      ���� Divided == 1;
                      Price - ���� ������� ������, ���� Divided == 0 ��� ���� ����������
                      ������ ���� Divided == 1;
                      GoodsDividual - ������� ��������� ������. ��� ��������� �������
                      ����� �������� 0, � 1 - ��� ������� �������;
                      Tax1Index, Tax2index - ������ ������ �������, �������� ����������
                      ������ �����. ��������� �������� �� 1 �� 8, ���� ����� ����������
                      ������ ������� � 0, ���� �� ����� ��������;
                      Article - ����� ��������, 0, ���� ��� ������������� ����� ��
                      ���������. � ������ �������� MTM T3-T4 ���� �� ��������� ����������;

                      LONG FiscalLineEx([in] BSTR GoodName, [in] LONG Qty, [in] LONG Price,
                      [in] LONG GoodsDividual, [in] LONG Tax1Index, [in] LONG Tax2Index,
                      [in] LONG Article, [in] LONG DiscountDirection, [in] BSTR DiscountName,
                      [in] LONG)
                      ������ ��������� �������� ������ � ������������ ����� �� ��������� �
                      ������������ ������������� ������/��������.
                      ����������: ����� �� ������ ������ ���� � ������ ������, 0 � ������
                      �������.
                      GoodName - ������������ ������ (�� 12 ��������). ��� ������ ���-T1
                      �������� ����� ������������ ������ ���������� 36 ���������. ���
                      ������ MTM-T3 � MTM-T4 ����� ������������ ����� ���������� 43 �������;
                      Qty - ���������� ������: �����, ���� Divided == 0 ��� ������, ����
                      Divided == 1;
                      Price - ���� ������� ������, ���� Divided == 0 ��� ���� ����������
                      ������ ���� Divided == 1;
                      GoodsDividual - ������� ��������� ������. ��� ��������� ������� �����
                      �������� 0, � 1 - ��� ������� �������;
                      Tax1Index, Tax2index - ������ ������ �������, �������� ����������
                      ������ �����. ��������� �������� �� 1 �� 8, ���� ����� ����������
                      ������ ������� � 0, ���� �� ����� ��������;
                      Article - ����� ��������, 0, ���� ��� ������������� ����� ��
                      ���������. � ������ �������� MTM T3-T4 ���� �� ��������� ����������;
                      DiscountDirection - ��� ������ ��������: -1 - ��� ������/��������,
                      0 - ������, 1 - ��������;
                      DiscountName - �������� ������/��������;
                      Discount - ����� ������/�������� (������ �������������), 0 - ����
                      ������/�������� �� �����������;}
                      TwoLineCheck := False;
                      Divided := 0;
                      //                     RoundTo(1.245, -2)	1.24
                      TempStr := FloatToStr(RoundTo(KolOpl, -3));
                      DelChar := 0;
                      for Cycle := 1 to Length(TempStr) do
                      begin
                        if Pos(',', TempStr) > 0 then DelChar := Pos(',', TempStr);
                      end;
                      if DelChar = 0 then
                      begin
                        Divided := 0;
                        KolPrint := TempStr;
                      end
                      else
                      begin
                        Divided := 1;
                        case (Length(TempStr) - DelChar) of
                          1: KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '00';
                          2: KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                        else
                          KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr));
                        end;
                        if KolOpl >= 100 then
                        begin
                          TwoLineCheck := True;
                          case (Length(TempStr) - DelChar) of
                            1:
                              begin
                                KolPrint := Copy(TempStr, 0, DelChar - 1);
                                KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr)) + '00';
                              end;
                            2:
                              begin
                                KolPrint := Copy(TempStr, 0, DelChar - 1);
                                KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                              end;
                          else
                            begin
                              KolPrint := Copy(TempStr, 0, DelChar - 1);
                              KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr));
                            end;
                          end;
                        end;
                      end;
                      //                     RoundTo(1.245, -2)	1.24
                      TempStr := FloatToStr(RoundTo(quRashodPriceOut.AsFloat, -2));
                      DelChar := 0;
                      for Cycle := 1 to Length(TempStr) do
                      begin
                        if Pos(',', TempStr) > 0 then DelChar := Pos(',', TempStr);
                      end;
                      if DelChar = 0 then
                        PricePrint := TempStr + '00'
                      else
                      begin
                        case (Length(TempStr) - DelChar) of
                          1: PricePrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                        else
                          PricePrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr));
                        end;
                      end;
                      SummaCash := 0;
                      SummaCash := KolOpl * quRashodPriceOut.AsFloat;
                      if SummaCash > 0.01 then
                      begin
                        ArticleTovarNo_0 := 0;
                        ArticleTovarNo_1 := 0;

                        quArticle.Close;
                        quArticle.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                        quArticle.Open;
                        if quArticle.RecordCount = 0 then
                        begin
                          if Divided = 0 then
                          begin
                            ArticleTovarNo_0 := LastArticle;
                            quWork.Close;
                            quWork.SQL.Clear;
                            quWork.SQL.Add('INSERT INTO Articles ');
                            quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                            quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                            quWork.ParamByName('Article_0').AsInteger := LastArticle;
                            quWork.ParamByName('Article_1').AsInteger := 0;
                            quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                            quWork.Execute;
                            LastArticle := LastArticle + 1;
                          end
                          else
                          begin
                            if not TwoLineCheck then
                            begin
                              ArticleTovarNo_1 := LastArticle;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('INSERT INTO Articles ');
                              quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                              quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                              quWork.ParamByName('Article_0').AsInteger := 0;
                              quWork.ParamByName('Article_1').AsInteger := LastArticle;
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.Execute;
                              LastArticle := LastArticle + 1;
                            end
                            else
                            begin
                              ArticleTovarNo_0 := LastArticle;
                              ArticleTovarNo_1 := LastArticle + 1;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('INSERT INTO Articles ');
                              quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                              quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                              quWork.ParamByName('Article_0').AsInteger := LastArticle;
                              quWork.ParamByName('Article_1').AsInteger := LastArticle + 1;
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.Execute;
                              LastArticle := LastArticle + 2;
                            end;
                          end;
                        end
                        else
                        begin
                          if Divided = 0 then
                          begin
                            if quArticleArticle_0.AsInteger <> 0 then
                              ArticleTovarNo_0 := quArticleArticle_0.AsInteger
                            else
                            begin
                              ArticleTovarNo_0 := LastArticle;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('UPDATE Articles ');
                              quWork.SQL.Append('SET Article_0 = :Article_0 ');
                              quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.ParamByName('Article_0').AsInteger := LastArticle;
                              quWork.Execute;
                              LastArticle := LastArticle + 1;
                            end;
                          end
                          else
                          begin
                            if not TwoLineCheck then
                            begin
                              if quArticleArticle_1.AsInteger <> 0 then
                                ArticleTovarNo_1 := quArticleArticle_1.AsInteger
                              else
                              begin
                                ArticleTovarNo_1 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_1 = :Article_1 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_1').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                            end
                            else
                            begin
                              if quArticleArticle_0.AsInteger <> 0 then
                                ArticleTovarNo_0 := quArticleArticle_0.AsInteger
                              else
                              begin
                                ArticleTovarNo_0 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_0 = :Article_0 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_0').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                              if quArticleArticle_1.AsInteger <> 0 then
                                ArticleTovarNo_1 := quArticleArticle_1.AsInteger
                              else
                              begin
                                ArticleTovarNo_1 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_1 = :Article_1 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_1').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                            end;
                          end;
                        end;
                        quArticle.Close;

                        if not TwoLineCheck then
                        begin
                          if ArticleTovarNo_0 <> 0 then
                          begin
{                            if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, 1, 0,
                              ArticleTovarNo_0) <> 0 then
                              //                         if 1=1 then}
                              if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                              if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
{
                              showmessage('FiscPrinter.FiscalLine('+quRashodNameTovarShort.AsString+','+KolPrint+','+PricePrint+','+
                              inttostr(Divided)+','+ inttostr(WithNoNDS)+',0,'+inttostr(ArticleTovarNo_0));
}
                              if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, WithNoNDS, 0,
                              ArticleTovarNo_0) <> 0 then
                            begin
                              if UserNo = 74 then
                                MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                  ', ���������: ' + IntToStr(Divided) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_0)+ ' '+ TypeTovar,
                                  mtInformation, [mbOk], 0);
                              quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                              quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                              quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                              quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                              quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                              try
                                quSaleCash.Execute;
                              except
                                ShowMessage('������ ������!');
                              end
                            end;
                          end
                          else
                          begin
{                            if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, 1, 0,
                              ArticleTovarNo_1) <> 0 then}
                              //                         if 1=1 then
                              if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                              if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
                              if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, WithNoNDS, 0,
                              ArticleTovarNo_1) <> 0 then
                            begin
                              if UserNo = 74 then
                                MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                  ', ���������: ' + IntToStr(Divided) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_1)+ ' '+ TypeTovar,
                                  mtInformation, [mbOk], 0);
                              quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                              quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                              quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                              quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                              quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                              try
                                quSaleCash.Execute;
                              except
                                ShowMessage('������ ������!');
                              end
                            end;
                          end;

                        end
                        else
                        begin
{                          if (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), 0, 1, 0,
                            ArticleTovarNo_0) <> 0)
                            and (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint_Two), StrToInt(PricePrint), 1, 1, 0,
                            ArticleTovarNo_1) <> 0)
                            //                       if 1=1 then}
                            if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                            if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
                            if (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), 0, WithNoNDS, 0,
                            ArticleTovarNo_0) <> 0)
                            and (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint_Two), StrToInt(PricePrint), 1, WithNoNDS, 0,
                            ArticleTovarNo_1) <> 0) then
                          begin
                            if UserNo = 74 then
                              MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                ', ���������: ' + IntToStr(0) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_0)+ ' '+ TypeTovar + #13
                                + '�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint_Two + ', ����: ' + PricePrint +
                                ', ���������: ' + IntToStr(1) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_1)+ ' '+ TypeTovar,
                                mtInformation, [mbOk], 0);
                            quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                            quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                            quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                            quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                            quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                            try
                              quSaleCash.Execute;
                            except
                              ShowMessage('������ ������!');
                            end
                          end;
                        end;
                      end;
                    end;
                    quRashod.Edit;
                    quRashodKolOpl.AsFloat := quRashodKolOpl.AsFloat + KolOpl;
                    quRashod.Post;
                    if SummaOplat = 0 then break;
                    quRashod.Next;
                  end;

                  if quPlatP.FieldByName('POstNo').AsInteger <> 90 then //��������
                  begin
                    FiscPrinter.FreeTextLine(0, 0, 0, quPost.FieldByName('NameLong').AsString);
                    {������ � ����������� ��������� ��������� ����������, �������
                    ����� ���������� ������ ���� (������� TEXT)
                    ����������: 1 � ������ ������, 0 � ������ �������.
                    PlaceBeforFiscalPart - ��������� ������ ������ �� (1) ���
                    ����� (0) ���������� ����� ����;
                    PrintOnJornal - ���������� (1) ��� �� ���������� (0) ������
                    ������ �� ����������� �����;
                    UseBoldStyle - �������� ��� ������ ������� (1) ��� �������
                    (0) ��������;
                    Text - �� 18 �������� ������ (��� ������ �������� �301-���
                    ����������� ����� ������ � 36 ��������)}
                  end;

                  //������� ���
                  {�������� ����������� ����.
                  ����������: ����� �� ���� � ������ ������, 0 � ������ �������.
                  CheckSum (���������) - ����� ���������� �� ���� � ������ ����������
                  �������. ����� ����� ���� ������������� � ������, ���� ����� ��������
                  �� ���� ��������� ����� ������� �� ����. �������� ���, ��������������
                  ����������� ����� ����������. ���� ��� ���� ��� �������� ������;}

                  if (quPlatP.FieldByName('Buh').AsInteger = 4) then CashSumm := FiscPrinter.CloseCheckEx(0,(FiscPrinter.CheckSumm + FiscPrinter.CheckOnSaleTaxes),0,0)
                                                                else CashSumm := FiscPrinter.CloseCheck;
                  if CashSumm = 0 then
//                  if FiscPrinter.CloseCheck = 0 then
                    //                 if 0<>0 then
                    MessageDlg('������ �������� ����!!!', mtInformation, [mbOk], 0)
                  else
                  begin
                    //������� ����� �� ���������
 //                   CheckResultStr:= FloatToStr(FiscPrinter.CheckSumm+FiscPrinter.CheckOnSaleTaxes);
                    CheckResultStr := FloatToStr(FiscPrinter.CheckSumm);
                    case Length(CheckResultStr) of
                      0: CheckResultStr := '0.00';
                      1: CheckResultStr := '0.0' + CheckResultStr;
                      2: CheckResultStr := '0.' + CheckResultStr;
                    else
                      CheckResultStr := Copy(CheckResultStr, 1, Length(CheckResultStr) - 2) + '.' + Copy(CheckResultStr, Length(CheckResultStr) - 2,
                        2);
                    end;
                    FiscPrinter.PutToDisplay('����', CheckResultStr);
                  end;
                  fmEditPlat.quRashod.Close;
                end;
                fmEditPlat.quDolg.Next;
              end;
            end
            else
              MessageDlg('�� ������� ������� ���', mtInformation, [mbOk], 0);
            //���������� ������� ��� ������ ����������
            FiscPrinter.ClearFreeTextLines;
            if PrinterOpenCashBox then FiscPrinter.OpenCashBox;
            FiscPrinter.UnlockPrinter;
          end
          else
            MessageDlg('���������� ������� ����� ������ �����������. ����������� �����', mtInformation, [mbOk], 0);
        end
       


	   else
          MessageDlg('���������� ���� � ��������� "������" (�)', mtInformation, [mbOk], 0);
      end;
			
			
			
		
		
	//*************************************************************************************	
		
		

		
		
		
		
	 //************************************************************************************	
		
		 if GlobalOurFirmNo = 7419 then
        begin

//��������� ������ � ��������
          if FiscPrinter.LockPrinter(3000) = 1 then
            //      if 1=1 then
          begin
            //�������� ����� � ��������� ����
            quDolg.AfterPost := nil;
            CurTime := Now();
            quPlatP.Post;
            fmEditPlat.quDolg.First;
            while not (quDolg.EOF) do
            begin
              if quDolgSumOplat.AsFloat > 0 then
              begin
                l_PlatNo := quPlatP.FieldByName('PlatNo').AsInteger;
                /////////
                quPodotchetList.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
                quPodotchetList.Open;
                if quPodotchetList.RecordCount = 1 then
                begin
                  quWork.SQL.Clear;
                  quWork.SQL.add('UPDATE PodotchetR');
                  quWork.SQL.Append('SET  SummaPlat = SummaPlat + :SummaPlat');
                  quWork.SQL.Append('WHERE (PodotchetRNo = :PodotchetRNo)');
                  quWork.ParamByName('SummaPlat').AsFloat := StrToFloat(EditSumma.Text);
                  quWork.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
                  quWork.Execute;

                  quPodotchetP.Close;
                  quWork.SQL.Clear;
                  quWork.SQL.Add('select Max(PodotchetPNo) AS MaxPodotchetPNo  from PodotchetP');
                  quWork.Open;
                  quPodotchetP.ParamByName('PodotchetPNo').AsInteger := quWork.Fields[0].AsInteger + 1;
                  quPodotchetP.ParamByName('SotrudNo').AsInteger := quDolgSotrudNo.AsInteger;
                  quPodotchetP.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
                  quPodotchetP.ParamByName('DatePlat').AsDate := StrToDate(EditDate.Text);
                  quPodotchetP.ParamByName('Summa').AsFloat := StrToFloat(EditSumma.Text);
                  quPodotchetP.Execute;
                  quWork.Close;
                end;

                if quPodotchetList.RecordCount > 1 then
                  PrihodPodotchetList(quDolgNaklNo.AsInteger, StrToFloat(EditSumma.Text));

                quPodotchetList.Close;
                ///////////
                quNaklR.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
                quNaklR.Open;
                if (abs(fmEditPlat.quDolgSumOplat.AsFloat - fmEditPlat.quDolgSummaDolg.AsFloat) < 0.01) then
                begin
                  quNaklR.Edit;
                  quNaklRPostNo.AsInteger := quPlatP.FieldByName('POstNo').AsInteger;
                  quNaklRBuh.AsInteger := quPlatP.FieldByName('Buh').AsInteger;
                  quNaklRRealDateOpl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
                  if quPlatP.FieldByName('POstNo').AsInteger = 90 then //��������
                  begin
                    quDolg.Edit;
                    quDolgDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime; //��� �� �� ���� ���������� ���������� ����
                    quDolg.Post;
                    quNaklRDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
                    quNaklRAddressNo.AsInteger := 1;
                  end;
                  quNaklR.Post;
                end;
              end;
              fmEditPlat.quDolg.Next;
            end;

            //����������� ���������� �������
            LastArticle := 0;
            quWork.Close;
            quWork.SQL.Clear;
            quWork.SQL.Add('SELECT MAX(Article_0) AS MAXArticle_0 ');
            quWork.SQL.Append('FROM Articles');
            quWork.Open;
            MAXArticle_0 := quWork.FieldByName('MAXArticle_0').AsInteger;
            quWork.Close;
            quWork.SQL.Clear;
            quWork.SQL.Add('SELECT MAX(Article_1) AS MAXArticle_1 ');
            quWork.SQL.Append('FROM Articles');
            quWork.Open;
            MAXArticle_1 := quWork.FieldByName('MAXArticle_1').AsInteger;
            quWork.Close;
            if (MAXArticle_0 <> 0) or (MAXArticle_1 <> 0) then
            begin
              if MAXArticle_0 > MAXArticle_1 then
                LastArticle := MAXArticle_0 + 1
              else
                LastArticle := MAXArticle_1 + 1
            end
            else
              LastArticle := 1;

            if LastArticle = 9998 then
              if not (Application.MessageBox(PChar('�������� ������������ �������� � �������� ��������. ������� ����������?'), '����������', MB_YESNO)
                = IDYES) then exit;

            //���������� ����������� �� ����
            FiscPrinter.SetCheckBottomLine('          "������ �� �������!"');
            //���������� ����� �������� ���������� ������� �� ����� ����
            {����������� ����� ������� ���������� �������
            (������� � ������� ����������). ���� SaleTaxesOnTotal = 1
            (��������� �� ���������), �� ���������� ������ �����������
            �� ���� ����� ����. ����� (SaleTaxesOnTotal = 0) ����������
            ������ ����������� �� ������ ����� � �����������, � ����� �����������.}
            FiscPrinter.SetTaxesCalcMode(1);
            //���������� ��������� ����� ������ �����
            {�������������/��������� ����� ���������� ������ ��� ������ ����.
            ����������: 1 � ������ ������, 0 � ������ �������.
            TableMode - 1 - ���������� ��������� ����� ������ ���������� � ����,
            0 - ��������� ��������� �����.}
            FiscPrinter.SetTableMode(0);
            //������� ���
            {�������� ����������� ����.
            ����������: 1 � ������ ������, 0 � ������ �������.
            Department - ������������� ������, �� ����� 2-� �������� ������
            (��� ������ �������� M301-MTM ���������� ����� 15 ��������).}
            if FiscPrinter.OpenCheck('����. ����') = 1 then
              //           if 1 = 1 then
            begin
              fmEditPlat.quDolg.First;
              while not (fmEditPlat.quDolg.EOF) do
              begin
                if fmEditPlat.quDolgSumOplat.AsFloat > 0 then
                begin
                  FiscPrinter.FreeTextLine(1, 1, 0, '����. � ' + IntToStr(quDolgNom.AsInteger) +
                    ' �� ' + DateToStr(quDolgDateNakl.AsDateTime));
                  {������ � ����������� ��������� ��������� ����������, �������
                  ����� ���������� ������ ���� (������� TEXT)
                  ����������: 1 � ������ ������, 0 � ������ �������.
                  PlaceBeforFiscalPart - ��������� ������ ������ �� (1) ���
                  ����� (0) ���������� ����� ����;
                  PrintOnJornal - ���������� (1) ��� �� ���������� (0) ������
                  ������ �� ����������� �����;
                  UseBoldStyle - �������� ��� ������ ������� (1) ��� �������
                  (0) ��������;
                  Text - �� 18 �������� ������ (��� ������ �������� �301-���
                  ����������� ����� ������ � 36 ��������)}
                  fmEditPlat.quRashod.Close;
                  fmEditPlat.quRashod.Open;
                  SummaOplat := quDolgSumOplat.AsFloat;
                  while not (quRashod.EOF) do
                  begin
                    if SummaOplat <= ((quRashodKol.AsFloat - quRashodKolOpl.AsFloat) * quRashodPriceOut.AsFloat) then
                      KolOpl := SummaOplat / quRashodPriceOut.AsFloat
                    else
                      KolOpl := (quRashodKol.AsFloat - quRashodKolOpl.AsFloat);
                    KolOpl := Round(KolOpl * 1000) / 1000;
                    SummaOplat := SummaOplat - KolOpl * quRashodPriceOut.AsFloat;
                    if KolOpl > 0 then
                    begin
                      //ShowMessage(format('���=%.6f ����=%.3f ��������=%.6f',[KolOpl,quRashodPrice.AsFloat,SummaOplat]));
                      //OldSeparator:=SysUtils.DecimalSeparator;
                      //SysUtils.DecimalSeparator:='.';
                      //������� �������� ������ �� ������

                      {LONG FiscalLine([in] BSTR GoodName, [in] LONG Qty, [in] LONG Price,
                      [in] LONG GoodsDividual, [in] LONG Tax1Index, [in] LONG Tax2Index,
                      [in] LONG Article)
                      ������ ��������� �������� ������
                      ����������: ����� �� ������ ������ ���� � ������ ������, 0 � ������
                      �������.
                      GoodName - ������������ ������ (�� 12 ��������). ��� ������ ���-T1
                      �������� ����� ������������ ������ ���������� 36 ���������.
                      ��� ������ MTM-T3 � MTM-T4 ����� ������������ ����� ����������
                      43 �������;
                      Qty - ���������� ������: �����, ���� Divided == 0 ��� ������,
                      ���� Divided == 1;
                      Price - ���� ������� ������, ���� Divided == 0 ��� ���� ����������
                      ������ ���� Divided == 1;
                      GoodsDividual - ������� ��������� ������. ��� ��������� �������
                      ����� �������� 0, � 1 - ��� ������� �������;
                      Tax1Index, Tax2index - ������ ������ �������, �������� ����������
                      ������ �����. ��������� �������� �� 1 �� 8, ���� ����� ����������
                      ������ ������� � 0, ���� �� ����� ��������;
                      Article - ����� ��������, 0, ���� ��� ������������� ����� ��
                      ���������. � ������ �������� MTM T3-T4 ���� �� ��������� ����������;

                      LONG FiscalLineEx([in] BSTR GoodName, [in] LONG Qty, [in] LONG Price,
                      [in] LONG GoodsDividual, [in] LONG Tax1Index, [in] LONG Tax2Index,
                      [in] LONG Article, [in] LONG DiscountDirection, [in] BSTR DiscountName,
                      [in] LONG)
                      ������ ��������� �������� ������ � ������������ ����� �� ��������� �
                      ������������ ������������� ������/��������.
                      ����������: ����� �� ������ ������ ���� � ������ ������, 0 � ������
                      �������.
                      GoodName - ������������ ������ (�� 12 ��������). ��� ������ ���-T1
                      �������� ����� ������������ ������ ���������� 36 ���������. ���
                      ������ MTM-T3 � MTM-T4 ����� ������������ ����� ���������� 43 �������;
                      Qty - ���������� ������: �����, ���� Divided == 0 ��� ������, ����
                      Divided == 1;
                      Price - ���� ������� ������, ���� Divided == 0 ��� ���� ����������
                      ������ ���� Divided == 1;
                      GoodsDividual - ������� ��������� ������. ��� ��������� ������� �����
                      �������� 0, � 1 - ��� ������� �������;
                      Tax1Index, Tax2index - ������ ������ �������, �������� ����������
                      ������ �����. ��������� �������� �� 1 �� 8, ���� ����� ����������
                      ������ ������� � 0, ���� �� ����� ��������;
                      Article - ����� ��������, 0, ���� ��� ������������� ����� ��
                      ���������. � ������ �������� MTM T3-T4 ���� �� ��������� ����������;
                      DiscountDirection - ��� ������ ��������: -1 - ��� ������/��������,
                      0 - ������, 1 - ��������;
                      DiscountName - �������� ������/��������;
                      Discount - ����� ������/�������� (������ �������������), 0 - ����
                      ������/�������� �� �����������;}
                      TwoLineCheck := False;
                      Divided := 0;
                      //                     RoundTo(1.245, -2)	1.24
                      TempStr := FloatToStr(RoundTo(KolOpl, -3));
                      DelChar := 0;
                      for Cycle := 1 to Length(TempStr) do
                      begin
                        if Pos(',', TempStr) > 0 then DelChar := Pos(',', TempStr);
                      end;
                      if DelChar = 0 then
                      begin
                        Divided := 0;
                        KolPrint := TempStr;
                      end
                      else
                      begin
                        Divided := 1;
                        case (Length(TempStr) - DelChar) of
                          1: KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '00';
                          2: KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                        else
                          KolPrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr));
                        end;
                        if KolOpl >= 100 then
                        begin
                          TwoLineCheck := True;
                          case (Length(TempStr) - DelChar) of
                            1:
                              begin
                                KolPrint := Copy(TempStr, 0, DelChar - 1);
                                KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr)) + '00';
                              end;
                            2:
                              begin
                                KolPrint := Copy(TempStr, 0, DelChar - 1);
                                KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                              end;
                          else
                            begin
                              KolPrint := Copy(TempStr, 0, DelChar - 1);
                              KolPrint_Two := Copy(TempStr, DelChar + 1, Length(TempStr));
                            end;
                          end;
                        end;
                      end;
                      //                     RoundTo(1.245, -2)	1.24
                      TempStr := FloatToStr(RoundTo(quRashodPriceOut.AsFloat, -2));
                      DelChar := 0;
                      for Cycle := 1 to Length(TempStr) do
                      begin
                        if Pos(',', TempStr) > 0 then DelChar := Pos(',', TempStr);
                      end;
                      if DelChar = 0 then
                        PricePrint := TempStr + '00'
                      else
                      begin
                        case (Length(TempStr) - DelChar) of
                          1: PricePrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr)) + '0';
                        else
                          PricePrint := Copy(TempStr, 0, DelChar - 1) + Copy(TempStr, DelChar + 1, Length(TempStr));
                        end;
                      end;
                      SummaCash := 0;
                      SummaCash := KolOpl * quRashodPriceOut.AsFloat;
                      if SummaCash > 0.01 then
                      begin
                        ArticleTovarNo_0 := 0;
                        ArticleTovarNo_1 := 0;

                        quArticle.Close;
                        quArticle.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                        quArticle.Open;
                        if quArticle.RecordCount = 0 then
                        begin
                          if Divided = 0 then
                          begin
                            ArticleTovarNo_0 := LastArticle;
                            quWork.Close;
                            quWork.SQL.Clear;
                            quWork.SQL.Add('INSERT INTO Articles ');
                            quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                            quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                            quWork.ParamByName('Article_0').AsInteger := LastArticle;
                            quWork.ParamByName('Article_1').AsInteger := 0;
                            quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                            quWork.Execute;
                            LastArticle := LastArticle + 1;
                          end
                          else
                          begin
                            if not TwoLineCheck then
                            begin
                              ArticleTovarNo_1 := LastArticle;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('INSERT INTO Articles ');
                              quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                              quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                              quWork.ParamByName('Article_0').AsInteger := 0;
                              quWork.ParamByName('Article_1').AsInteger := LastArticle;
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.Execute;
                              LastArticle := LastArticle + 1;
                            end
                            else
                            begin
                              ArticleTovarNo_0 := LastArticle;
                              ArticleTovarNo_1 := LastArticle + 1;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('INSERT INTO Articles ');
                              quWork.SQL.Append('(Article_0, Article_1, TovarNo) ');
                              quWork.SQL.Append('VALUES (:Article_0, :Article_1, :TovarNo)');
                              quWork.ParamByName('Article_0').AsInteger := LastArticle;
                              quWork.ParamByName('Article_1').AsInteger := LastArticle + 1;
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.Execute;
                              LastArticle := LastArticle + 2;
                            end;
                          end;
                        end
                        else
                        begin
                          if Divided = 0 then
                          begin
                            if quArticleArticle_0.AsInteger <> 0 then
                              ArticleTovarNo_0 := quArticleArticle_0.AsInteger
                            else
                            begin
                              ArticleTovarNo_0 := LastArticle;
                              quWork.Close;
                              quWork.SQL.Clear;
                              quWork.SQL.Add('UPDATE Articles ');
                              quWork.SQL.Append('SET Article_0 = :Article_0 ');
                              quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                              quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                              quWork.ParamByName('Article_0').AsInteger := LastArticle;
                              quWork.Execute;
                              LastArticle := LastArticle + 1;
                            end;
                          end
                          else
                          begin
                            if not TwoLineCheck then
                            begin
                              if quArticleArticle_1.AsInteger <> 0 then
                                ArticleTovarNo_1 := quArticleArticle_1.AsInteger
                              else
                              begin
                                ArticleTovarNo_1 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_1 = :Article_1 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_1').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                            end
                            else
                            begin
                              if quArticleArticle_0.AsInteger <> 0 then
                                ArticleTovarNo_0 := quArticleArticle_0.AsInteger
                              else
                              begin
                                ArticleTovarNo_0 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_0 = :Article_0 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_0').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                              if quArticleArticle_1.AsInteger <> 0 then
                                ArticleTovarNo_1 := quArticleArticle_1.AsInteger
                              else
                              begin
                                ArticleTovarNo_1 := LastArticle;
                                quWork.Close;
                                quWork.SQL.Clear;
                                quWork.SQL.Add('UPDATE Articles ');
                                quWork.SQL.Append('SET Article_1 = :Article_1 ');
                                quWork.SQL.Append('WHERE (TovarNo = :TovarNo)');
                                quWork.ParamByName('TovarNo').AsInteger := quRashodTovarNo.AsInteger;
                                quWork.ParamByName('Article_1').AsInteger := LastArticle;
                                quWork.Execute;
                                LastArticle := LastArticle + 1;
                              end;
                            end;
                          end;
                        end;
                        quArticle.Close;

                        if not TwoLineCheck then
                        begin
                          if ArticleTovarNo_0 <> 0 then
                          begin
{                            if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, 1, 0,
                              ArticleTovarNo_0) <> 0 then
                              //                         if 1=1 then}
                              if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                              if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
{
                              showmessage('FiscPrinter.FiscalLine('+quRashodNameTovarShort.AsString+','+KolPrint+','+PricePrint+','+
                              inttostr(Divided)+','+ inttostr(WithNoNDS)+',0,'+inttostr(ArticleTovarNo_0));
}
                              if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, WithNoNDS, 0,
                              ArticleTovarNo_0) <> 0 then
                            begin
                              if UserNo = 74 then
                                MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                  ', ���������: ' + IntToStr(Divided) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_0)+ ' '+ TypeTovar,
                                  mtInformation, [mbOk], 0);
                              quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                              quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                              quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                              quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                              quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                              try
                                quSaleCash.Execute;
                              except
                                ShowMessage('������ ������!');
                              end
                            end;
                          end
                          else
                          begin
{                            if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, 1, 0,
                              ArticleTovarNo_1) <> 0 then}
                              //                         if 1=1 then
                              if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                              if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
                              if FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), Divided, WithNoNDS, 0,
                              ArticleTovarNo_1) <> 0 then
                            begin
                              if UserNo = 74 then
                                MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                  ', ���������: ' + IntToStr(Divided) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_1)+ ' '+ TypeTovar,
                                  mtInformation, [mbOk], 0);
                              quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                              quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                              quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                              quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                              quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                              try
                                quSaleCash.Execute;
                              except
                                ShowMessage('������ ������!');
                              end
                            end;
                          end;

                        end
                        else
                        begin
{                          if (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), 0, 1, 0,
                            ArticleTovarNo_0) <> 0)
                            and (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint_Two), StrToInt(PricePrint), 1, 1, 0,
                            ArticleTovarNo_1) <> 0)
                            //                       if 1=1 then}
                            if quRashodWithNoNDS.Value = true then
                                                              begin
                                                                TypeTovar := '����� ��� ���';
                                                                WithNoNDS := 0;
                                                              end
                                                            else
                                                              begin
                                                                TypeTovar := '����� c ���';
                                                                WithNoNDS := 1;
                                                              end;
                            if quRashodIsStavNDS.Value = true then WithNoNDS := 3;
                            if (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint), StrToInt(PricePrint), 0, WithNoNDS, 0,
                            ArticleTovarNo_0) <> 0)
                            and (FiscPrinter.FiscalLine(quRashodNameTovarShort.AsString, StrToInt(KolPrint_Two), StrToInt(PricePrint), 1, WithNoNDS, 0,
                            ArticleTovarNo_1) <> 0) then
                          begin
                            if UserNo = 74 then
                              MessageDlg('�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint + ', ����: ' + PricePrint +
                                ', ���������: ' + IntToStr(0) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_0)+ ' '+ TypeTovar + #13
                                + '�����: ' + quRashodNameTovarShort.AsString + ', ���-��: ' + KolPrint_Two + ', ����: ' + PricePrint +
                                ', ���������: ' + IntToStr(1) + ' �����:' + FloatToStr(SummaCash) + ' �������:' + IntToStr(ArticleTovarNo_1)+ ' '+ TypeTovar,
                                mtInformation, [mbOk], 0);
                            quSaleCash.ParamByName('DateTimeSale').AsDateTime := CurTime;
                            quSaleCash.ParamByName('TovarNo').AsInteger := quRashodTovarNo.Asinteger;
                            quSaleCash.ParamByName('Kol').AsFloat := KolOpl;
                            quSaleCash.ParamByName('Price').AsFloat := quRashodPriceOut.AsFloat;
                            quSaleCash.ParamByName('NaklNo').AsInteger := quRashodNaklNo.AsInteger;
                            try
                              quSaleCash.Execute;
                            except
                              ShowMessage('������ ������!');
                            end
                          end;
                        end;
                      end;
                    end;
                    quRashod.Edit;
                    quRashodKolOpl.AsFloat := quRashodKolOpl.AsFloat + KolOpl;
                    quRashod.Post;
                    if SummaOplat = 0 then break;
                    quRashod.Next;
                  end;

                  if quPlatP.FieldByName('POstNo').AsInteger <> 90 then //��������
                  begin
                    FiscPrinter.FreeTextLine(0, 0, 0, quPost.FieldByName('NameLong').AsString);
                    {������ � ����������� ��������� ��������� ����������, �������
                    ����� ���������� ������ ���� (������� TEXT)
                    ����������: 1 � ������ ������, 0 � ������ �������.
                    PlaceBeforFiscalPart - ��������� ������ ������ �� (1) ���
                    ����� (0) ���������� ����� ����;
                    PrintOnJornal - ���������� (1) ��� �� ���������� (0) ������
                    ������ �� ����������� �����;
                    UseBoldStyle - �������� ��� ������ ������� (1) ��� �������
                    (0) ��������;
                    Text - �� 18 �������� ������ (��� ������ �������� �301-���
                    ����������� ����� ������ � 36 ��������)}
                  end;

                  //������� ���
                  {�������� ����������� ����.
                  ����������: ����� �� ���� � ������ ������, 0 � ������ �������.
                  CheckSum (���������) - ����� ���������� �� ���� � ������ ����������
                  �������. ����� ����� ���� ������������� � ������, ���� ����� ��������
                  �� ���� ��������� ����� ������� �� ����. �������� ���, ��������������
                  ����������� ����� ����������. ���� ��� ���� ��� �������� ������;}

                  if (quPlatP.FieldByName('Buh').AsInteger = 4) then CashSumm := FiscPrinter.CloseCheckEx(0,(FiscPrinter.CheckSumm + FiscPrinter.CheckOnSaleTaxes),0,0)
                                                                else CashSumm := FiscPrinter.CloseCheck;
                  if CashSumm = 0 then
//                  if FiscPrinter.CloseCheck = 0 then
                    //                 if 0<>0 then
                    MessageDlg('������ �������� ����!!!', mtInformation, [mbOk], 0)
                  else
                  begin
                    //������� ����� �� ���������
 //                   CheckResultStr:= FloatToStr(FiscPrinter.CheckSumm+FiscPrinter.CheckOnSaleTaxes);
                    CheckResultStr := FloatToStr(FiscPrinter.CheckSumm);
                    case Length(CheckResultStr) of
                      0: CheckResultStr := '0.00';
                      1: CheckResultStr := '0.0' + CheckResultStr;
                      2: CheckResultStr := '0.' + CheckResultStr;
                    else
                      CheckResultStr := Copy(CheckResultStr, 1, Length(CheckResultStr) - 2) + '.' + Copy(CheckResultStr, Length(CheckResultStr) - 2,
                        2);
                    end;
                    FiscPrinter.PutToDisplay('����', CheckResultStr);
                  end;
                  fmEditPlat.quRashod.Close;
                end;
                fmEditPlat.quDolg.Next;
              end;
            end
            else
              MessageDlg('�� ������� ������� ���', mtInformation, [mbOk], 0);
            //���������� ������� ��� ������ ����������
            FiscPrinter.ClearFreeTextLines;
            if PrinterOpenCashBox then FiscPrinter.OpenCashBox;
            FiscPrinter.UnlockPrinter;
          end
          else
            MessageDlg('���������� ������� ����� ������ �����������. ����������� �����', mtInformation, [mbOk], 0);
        end
          
end
	   

//**************************************************************************************

	  
	  
      else
      begin
        MessageDlg('���������� ������� �� ���������!', mtInformation, [mbOk], 0);
      end;
    end
    else
    begin
      //�������� ����� ��� �������� ����
      quDolg.AfterPost := nil;
      CurTime := Now();
      quPlatP.Post;
      fmEditPlat.quDolg.First;
      while not (quDolg.EOF) do
      begin
        if quDolgSumOplat.AsFloat > 0 then
        begin
          l_PlatNo := quPlatP.FieldByName('PlatNo').AsInteger;
          /////////
          quPodotchetList.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
          quPodotchetList.Open;
          if quPodotchetList.RecordCount = 1 then
          begin
            quWork.SQL.Clear;
            quWork.SQL.add('UPDATE PodotchetR');
            quWork.SQL.Append('SET  SummaPlat = SummaPlat + :SummaPlat');
            quWork.SQL.Append('WHERE (PodotchetRNo = :PodotchetRNo)');
            quWork.ParamByName('SummaPlat').AsFloat := StrToFloat(EditSumma.Text);
            quWork.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
            quWork.Execute;

            quPodotchetP.Close;
            quWork.SQL.Clear;
            quWork.SQL.Add('select Max(PodotchetPNo) AS MaxPodotchetPNo  from PodotchetP');
            quWork.Open;
            quPodotchetP.ParamByName('PodotchetPNo').AsInteger := quWork.Fields[0].AsInteger + 1;
            quPodotchetP.ParamByName('SotrudNo').AsInteger := quDolgSotrudNo.AsInteger;
            quPodotchetP.ParamByName('PodotchetRNo').AsInteger := quPodotchetListPodotchetRNo.AsInteger;
            quPodotchetP.ParamByName('DatePlat').AsDate := StrToDate(EditDate.Text);
            quPodotchetP.ParamByName('Summa').AsFloat := StrToFloat(EditSumma.Text);
            quPodotchetP.Execute;
            quWork.Close;
          end;

          if quPodotchetList.RecordCount > 1 then
            PrihodPodotchetList(quDolgNaklNo.AsInteger, StrToFloat(EditSumma.Text));

          quPodotchetList.Close;
          ///////////
          quNaklR.ParamByName('NaklNo').AsInteger := quDolgNaklNo.AsInteger;
          quNaklR.Open;
          if (abs(fmEditPlat.quDolgSumOplat.AsFloat - fmEditPlat.quDolgSummaDolg.AsFloat) < 0.01) then
          begin
            quNaklR.Edit;
            quNaklRPostNo.AsInteger := quPlatP.FieldByName('POstNo').AsInteger;
            quNaklRBuh.AsInteger := quPlatP.FieldByName('Buh').AsInteger;
            quNaklRRealDateOpl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
            if quPlatP.FieldByName('POstNo').AsInteger = 90 then //��������
            begin
              quDolg.Edit;
              quDolgDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime; //��� �� �� ���� ���������� ���������� ����
              quDolg.Post;
              quNaklRDateNakl.AsDateTime := quPlatP.FieldByName('DatePlat').AsDateTime;
              quNaklRAddressNo.AsInteger := 1;
            end;
            quNaklR.Post;
          end;
        end;
        fmEditPlat.quDolg.Next;
      end;
    end;
  fmEditPlat.ModalResult := mrOk;
  fmEditPlat.Close;
  Screen.Cursor := crDefault;
end;


procedure TfmEditPlat.bbOkClick(Sender: TObject);
begin
  // FiscPrinterPrintChek;

  if dmDataModule.FiscPrinterConnect(True) then
    FiscPrinterPrintChek
  else
    FiscCashPrintChek;
  quDolg.First;

// quPlatP.Post;

  while not (quDolg.EOF) do
  begin
    if quDolgSumOplat.AsFloat > 0 then
    begin
      spModify_Plat_Nakl_link.Close;
      spModify_Plat_Nakl_link.Params.ParamByName('p_ID').Value := -1;
      spModify_Plat_Nakl_link.Params.ParamByName('p_entityNo_1').Value := quDolgNaklNo.AsInteger;
      spModify_Plat_Nakl_link.Params.ParamByName('p_entityNo_2').Value := quPlatP.FieldByName('PlatNo').AsInteger;
      spModify_Plat_Nakl_link.Params.ParamByName('p_Entity_Type_1').Value := 'NAKLR';
      spModify_Plat_Nakl_link.Params.ParamByName('p_Entity_Type_2').Value := 'PLATP';
      spModify_Plat_Nakl_link.Params.ParamByName('p_Link_Summa').Value := quDolgSumOplat.AsFloat;
      spModify_Plat_Nakl_link.Params.ParamByName('p_Link_SummaCurrencyAccounting').Value := quDolgSumOplatCurrencyAccounting.AsFloat;
      spModify_Plat_Nakl_link.Params.ParamByName('p_UserNo').Value := data.UserNo;

      spModify_Plat_Nakl_link.ExecProc;
    end;
    fmEditPlat.quDolg.Next;
  end;

end;

procedure TfmEditPlat.quDolgAfterPost(DataSet: TDataSet);
var
  Rec: TBookmarkStr;
  Summa: double;
  SummaAccaunting: double;
  Spravka: string;
  Rate, RateAccaunting: real;
begin
  mdSpravka.First;
  if mdSpravka.Locate('NaklNo', quDolgNom.AsInteger, []) then
  begin
    if quDolgSumOplat.AsFloat = 0 then
    begin
      mdSpravka.Delete;
      //     mdSpravka.Post;
      //     mdSpravka.Refresh;
    end
    else
    begin
      mdSpravka.Edit;
      mdSpravkaSumma.AsFloat := quDolgSumOplat.AsFloat;
      mdSpravka.Post;
      mdSpravka.Refresh;
    end;
  end
  else
  begin
    if quDolgSumOplat.AsFloat <> 0 then
    begin
      mdSpravka.Insert;
      mdSpravkaNaklNo.AsInteger := quDolgNom.AsInteger;
      mdSpravkaSumma.AsFloat := quDolgSumOplat.AsFloat;
      mdSpravka.Post;
      mdSpravka.Refresh;
    end;
  end;
  mdSpravka.First;
  mdSpravka.SortOnFields('NaklNo', True, False);
  if mdSpravka.RecordCount > 0 then
  begin
    mdSpravka.First;
    while not mdSpravka.Eof do
    begin
      format('; %s-%2f', [IntToStr(mdSpravkaNaklNo.AsInteger), mdSpravkaSumma.AsFloat]);
      //     Spravka:=Spravka+'; '+IntToStr(mdSpravkaNaklNo.AsInteger)+'-'+FloatToStr(mdSpravkaSumma.AsInteger);
      Spravka := Spravka + format('; %s-%2f', [IntToStr(mdSpravkaNaklNo.AsInteger), mdSpravkaSumma.AsFloat]);
      mdSpravka.Next;
    end;
    Spravka := Copy(Spravka, 2, Length(Spravka));
    Spravka := '����. �' + Spravka;
  end
  else
    Spravka := '';

  quPlatP.FieldByName('Spravka').AsString := Spravka;
  Rec := quDolg.Bookmark;
  quDolg.DisableControls;
  quDolg.First;
  Summa := 0;
  SummaAccaunting := 0;
  while not quDolg.EOF do
  begin
    Summa := Summa + quDolgSumOplat.AsFloat;

    dmDataModule.OpenSQL('select Rate from CurrencyExchange ce left join D_CURRENCY c on c.id = ce.currencyid where IsActive = 1 and (l_code = :p1_l_code)',[quDolgCurrencyHead.Value]);
    RateCurrencyHead := dmDataModule.qfo.FieldByName('Rate').Value;

    dmDataModule.OpenSQL('select ce.Rate from D_CURRENCY c inner join CurrencyExchange ce on c.IsDefault = 1 and ce.IsActive = 1 and ce.CurrencyId = c.ID and c.isTrash = 0');
    RateCurrencyAccounting := dmDataModule.qfo.FieldByName('Rate').Value;

    SummaAccaunting := SummaAccaunting + quDolgSumOplatCurrencyAccounting.AsFloat;
    //Summa * RateCurrencyHead / RateCurrencyAccounting;
    //SummaAccaunting + quDolgSumOplatCurrencyAccounting.AsFloat;


    quDolg.Next;
  end;
  quPlatP.FieldByName('Summa').AsFloat := Summa;
  quPlatP.FieldByName('SummaCurrencyAccounting').AsFloat := SummaAccaunting;
  quDolg.Bookmark := Rec;
  quDolg.EnableControls;
end;

procedure TfmEditPlat.quDolgSumOplatChange(Sender: TField);
begin
  if (quDolgSumOplat.AsFloat - quDolgSummaDolg.AsFloat) > 0.01 then
  begin
    SysUtils.Beep;
    //quDolgSumOplat.AsFloat:=0;
  end;
end;

procedure TfmEditPlat.RxDBGrid1Exit(Sender: TObject);
begin
  if RxDBGrid1.DataSource.DataSet.State in [dsEdit] then
    RxDBGrid1.DataSource.DataSet.Post;
end;

procedure TfmEditPlat.quDolgAfterInsert(DataSet: TDataSet);
begin
  quDolg.Cancel;
end;

procedure TfmEditPlat.RxDBGrid1GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if (quDolgSumOplat.AsFloat - quDolgSummaDolg.AsFloat) > 0.01 then
    AFont.Color := clRed;
end;

procedure TfmEditPlat.quPlatPNewRecord(DataSet: TDataSet);
begin
  quPlatP.FieldByName('DatePlat').AsDateTime := Date();
  quPlatP.FieldByName('Buh').AsInteger := 1;
  quPlatP.FieldByName('Summa').AsFloat := 0;
  quPlatP.FieldByName('UserNo').AsInteger := Data.UserNo;
  quPlatP.FieldByName('OurFIrmNo').AsInteger := dmDataModule.FirmNo;
  quPlatP.FieldByName('SummaCurrencyAccounting').AsFloat := 0;
end;

procedure TfmEditPlat.EditDateExit(Sender: TObject);
begin
  dmDataModule.quSetup.Close;
  dmDataModule.quSetup.Open;
  if StrToDate(EditDate.Text) < dmDataModule.quSetupDateBlock.AsDateTime then
  begin
    MessageDlg('������ ������������!!!', mtError, [mbOk], 0);
    ActiveControl := EditDate;
  end;
  dmDataModule.quSetup.Close;
end;

procedure TfmEditPlat.quDolgBeforeOpen(DataSet: TDataSet);
begin
  quDolg.ParamByName('OurFirmNo').AsInteger := dmDataModule.FirmNo;
end;

procedure TfmEditPlat.quNaklRBeforeOpen(DataSet: TDataSet);
begin
  quNaklR.ParamByName('OurFirmNo').AsInteger := dmDataModule.FirmNo;
end;

procedure TfmEditPlat.quPlatPAfterPost(DataSet: TDataSet);
begin
  TMSQuery(DataSet).Close;
  TMSQuery(DataSet).ParamByName('pPkey').Value := PKeyPlat;
  TMSQuery(DataSet).Open;
end;

procedure TfmEditPlat.quPlatPAfterUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
  inherited;
  if stInsert in StatementTypes then
  begin
    PKeyPlat := Params.ParamByName('Pkey').Value;
  end;
end;

procedure TfmEditPlat.quPlatPBeforeUpdateExecute(Sender: TCustomMSDataSet;
  StatementTypes: TStatementTypes; Params: TMSParams);
begin
  inherited;
  if stInsert in StatementTypes then
  begin
    Params.ParamByName('Pkey').ParamType := ptOutput;
  end;
end;

procedure TfmEditPlat.cbCurrencyHeadChange(Sender: TObject);
var Rate: real;
    Currency : string;
begin
  inherited;


end;

procedure TfmEditPlat.FormShow(Sender: TObject);
var
  Name, l_code : string;
  Rate : real;
begin
  inherited;
  quCurrency.Open;
  quCurrencyAccounting.Open;

  dmDataModule.OpenSQL('select c.Name, c.l_code, ce.Rate from D_CURRENCY c inner join CurrencyExchange ce on c.IsDefault = 1 and ce.IsActive = 1 and ce.CurrencyId = c.ID and c.isTrash = 0');
  Name := dmDataModule.qfo.FieldByName('Name').Value;
  l_code := dmDataModule.qfo.FieldByName('l_code').Value;
  Rate := dmDataModule.qfo.FieldByName('Rate').Value;

  cbCurrencyHead.KeyValue := l_code;
  cbCurrencyAccounting.KeyValue := l_code;

  cbCurrencyHead.Text := Name;
  cbCurrencyAccounting.Text := Name;

  dbeRateCurrencyHead.Text := FloatToStr(Rate);
  dbeRateCurrencyAccounting.Text := FloatToStr(Rate);

  quPlatP.FieldByName('Rate').Value := Rate;
  quPlatP.FieldByName('RateCurrencyAccounting').Value := Rate;



end;

procedure TfmEditPlat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  quCurrency.Close;
  quCurrencyAccounting.Close;
end;

procedure TfmEditPlat.cbCurrencyHeadExit(Sender: TObject);
var
 Rate : real;
begin
  inherited;
  dmDataModule.OpenSQL('select Rate from CurrencyExchange ce left join D_CURRENCY c on c.id = ce.currencyid where IsActive = 1 and (l_code = :p1_l_code)',[cbCurrencyHead.KeyValue]);

  Rate := dmDataModule.qfo.FieldByName('Rate').Value;

  dbeRateCurrencyHead.Text := FloatToStr(Rate);
  quPlatP.FieldByName('Rate').Value := Rate;

  RateCurrencyHead := Rate;

end;

procedure TfmEditPlat.cbCurrencyAccountingExit(Sender: TObject);
var
 Rate : real;
begin
  inherited;

  dmDataModule.OpenSQL('select Rate from CurrencyExchange ce left join D_CURRENCY c on c.id = ce.currencyid where IsActive = 1 and (l_code = :p1_l_code)',[cbCurrencyAccounting.KeyValue]);

  Rate := dmDataModule.qfo.FieldByName('Rate').Value;
  dbeRateCurrencyAccounting.Text := FloatToStr(Rate);

  quPlatP.FieldByName('RateCurrencyAccounting').Value := Rate;

  RateCurrencyAccounting := Rate;
end;

procedure TfmEditPlat.quDolgBeforePost(DataSet: TDataSet);
begin
  inherited;
  quDolgSumOplatCurrencyAccounting.Value := quDolgSumOplat.Value * StrToFloat(dbeRateCurrencyHead.text) / StrToFloat(dbeRateCurrencyAccounting.text);
  //quDolgSumOplat.Value * RateCurrencyHead / RateCurrencyAccounting;
end;

end.

