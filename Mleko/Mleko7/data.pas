unit data;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Db, IniFiles, ExtCtrls, DBAccess, ImgList, ComObj,
  MemDS, ActnList, CitDbComboEdit, StrUtils, BCDb, ADODB,
  BCDbMSSQL, MsAccess, WinSock;

type
  TdmDataModule = class(TBCDbMSSQLDm)
    dsTovar: TDataSource;
    dsSotrud: TDataSource;
    dsVidTov: TDataSource;
    quWork: TMSQuery;
    UpdateTovar: TMSUpdateSQL;
    quTovar: TMSQuery;
    quTovarTovarNo: TSmallintField;
    quTovarEdIzm: TStringField;
    quTovarVidNo: TSmallintField;
    quTovarCompanyNo: TSmallintField;
    quTovarKolPerPak: TSmallintField;
    quTovarSrokReal: TSmallintField;
    quTovarWeight: TFloatField;
    quTovarNameCompany: TStringField;
    quTovarVidName: TStringField;
    quVidTov: TMSQuery;
    quCompany: TMSQuery;
    UpdateVidTov: TMSUpdateSQL;
    UpdateCompany: TMSUpdateSQL;
    dsCompany: TDataSource;
    quVidTovVidNo: TSmallintField;
    quVidTovVidName: TStringField;
    quVidTovPrintToPrice: TBooleanField;
    quVidTovPriceWithNDS: TBooleanField;
    quTovarVidNameLC: TStringField;
    quCompanyCompanyNo: TSmallintField;
    quCompanyNameCompany: TStringField;
    quTovarNameCompanyLC: TStringField;
    quSotrud: TMSQuery;
    UpdateSotrud: TMSUpdateSQL;
    spGetSummaNaklP: TMSStoredProc;
    spGetSummaNaklPSumma: TFloatField;
    spGetSummaNaklPSummaDolg: TFloatField;
    spGetSummaNaklR: TMSStoredProc;
    spGetSummaNaklRSumma: TFloatField;
    spGetSummaNaklRSummaDolg: TFloatField;
    quTipNakl: TMSQuery;
    quTipNaklTipNo: TSmallintField;
    quTipNaklTipName: TStringField;
    spGetNomNaklR: TMSStoredProc;
    spGetNomNaklRNom: TIntegerField;
    spGetNomNaklP: TMSStoredProc;
    spGetNomNaklPNom: TIntegerField;
    quCompanyPercentSalary: TFloatField;
    quRegions: TMSQuery;
    quRegionsRegionNo: TSmallintField;
    quRegionsRegionName: TStringField;
    dsRegions: TDataSource;
    UpdateRegions: TMSUpdateSQL;
    quMenu: TMSQuery;
    quMenuUserNo: TSmallintField;
    quMenuItemName: TStringField;
    quMenuEnabled: TBooleanField;
    quVidRashod: TMSQuery;
    dsVidRashod: TDataSource;
    UpdateVidRashod: TMSUpdateSQL;
    quVidRashodVidRashodNo: TSmallintField;
    quVidRashodVidRashodName: TStringField;
    dsTipTovara: TDataSource;
    quTipTovara: TMSQuery;
    UpdateTipTovara: TMSUpdateSQL;
    quTipTovaraTipNo: TSmallintField;
    quTipTovaraTipName: TStringField;
    quTovarTipName: TStringField;
    quTovarTipNameLC: TStringField;
    quTovarTipNo: TSmallintField;
    quTovarCodReport: TStringField;
    dsCars: TDataSource;
    UpdateCars: TMSUpdateSQL;
    quCars: TMSQuery;
    dsShipping_Agent: TDataSource;
    UpdateShipping_Agent: TMSUpdateSQL;
    quShipping_Agent: TMSQuery;
    quShipping_AgentShipping_AgentNo: TSmallintField;
    quShipping_AgentShipping_AgentName: TStringField;
    quShipping_AgentShipping_AgentDelete: TBooleanField;
    quTovarExport1C: TBooleanField;
    quTovarChange1C: TBooleanField;
    quTovarCod1C: TStringField;
    quTovarID1C: TStringField;
    ADOConnection1C: TMSConnection;
    quTovarOtdelName: TStringField;
    quTovarOtdelNameLC: TStringField;
    quOtdel: TMSQuery;
    quOtdelOtdelNo: TSmallintField;
    quOtdelOtdelName: TStringField;
    dsOtdel: TDataSource;
    quTovarOtdelNo: TSmallintField;
    quTara: TMSQuery;
    dsTara: TDataSource;
    quTovarTaraNo: TSmallintField;
    quTaraTovarNo: TSmallintField;
    quTaraNameTovar: TStringField;
    quTovarTaraNameLC: TStringField;
    quVidTovPrintToExpedition: TBooleanField;
    quTovarVisible: TBooleanField;
    quVidTovVisible: TBooleanField;
    quTipTovaraVisible: TBooleanField;
    quCompanyVisible: TBooleanField;
    quRegionsVisible: TBooleanField;
    quVidRashodVisible: TBooleanField;
    quShipping_AgentVisible: TBooleanField;
    dsSetup: TDataSource;
    quSetup: TMSQuery;
    UpdateSetup: TMSUpdateSQL;
    quSetupDateBlock: TDateTimeField;
    spSetUserLoginParam: TMSStoredProc;
    ImageListToolBar: TImageList;
    quTovarweight_packed: TBooleanField;
    SpGenTmpTable: TMSStoredProc;
    quVidRashodGroup: TMSQuery;
    quVidRashodGroupid: TAutoIncField;
    quVidRashodGroupname: TStringField;
    quVidRashodGroup_id: TSmallintField;
    quVidRashodGroupName2: TStringField;
    quTovaris_weight: TBooleanField;
    spAdd_session_params: TMSStoredProc;
    spDel_session_params: TMSStoredProc;
    QFO1: TMSQuery;
    quTovarNameTovar: TStringField;
    quTovarNameTovarShort: TStringField;
    quShipping_Agentis_our: TBooleanField;
    ImageList_32_32: TImageList;
    quTovarBarCode: TLargeintField;
    spclear_session_params: TMSStoredProc;
    quPost: TMSQuery;
    dsCategoryTT: TMSDataSource;
    quCategoryTT: TMSQuery;
    quSotrudSotrudNo: TSmallintField;
    quSotrudSotrudName: TStringField;
    quSotrudSotrudOtdel: TSmallintField;
    quSotrudOtdelName: TStringField;
    quSotrudVisible: TBooleanField;
    spGetPrihodOrderNo: TMSStoredProc;
    spGetPrihodOrderNoOrderNo: TIntegerField;
    quSetupForExpedition: TMSQuery;
    UpdateSetupForExpedition: TMSUpdateSQL;
    quSetupForExpeditionDateBlock: TDateTimeField;
    quCarsCarsNo: TSmallintField;
    quCarsCarsName: TStringField;
    quCarsCarsDelete: TBooleanField;
    quCarsCarsDriver: TStringField;
    quCarsCarsType: TStringField;
    quCarsCarsNomer: TStringField;
    quCarsCarsOKPO: TStringField;
    quCarsCarsFirma: TStringField;
    quCarsVisible: TBooleanField;
    quCarsMOLPostNo: TSmallintField;
    quCarsMolName: TStringField;
    quCarsis_our: TBooleanField;
    quCarsCapacity: TIntegerField;
    quCarsVolume: TFloatField;
    quCarsOur_Car: TBooleanField;
    UpdateDeliveryOfGoods: TMSUpdateSQL;
    dsDeliveryOfGoods: TDataSource;
    quDeliveryOfGoods: TMSQuery;
    quDeliveryOfGoodsDeliveryTovarNo: TIntegerField;
    quDeliveryOfGoodsDeliveryGoodsName: TStringField;
    quDeliveryOfGoodsVisible: TBooleanField;
    quDeliveryOfGoodsNoVisibleOfOtchetZero: TBooleanField;
    quClassifierABCDZ: TMSQuery;
    quClassifierABCDZClassifierNo: TIntegerField;
    quClassifierABCDZClassifierName: TStringField;
    quClassifierABCDZActive: TFloatField;
    dsClassifierABCDZ: TMSDataSource;
    quVidRashodIsExtInBDDS: TBooleanField;
    quBanks: TMSQuery;
    dsBanks: TMSDataSource;
    quKassa: TMSQuery;
    dsKassa: TMSDataSource;
    quKassaName: TStringField;
    quKassaDate: TWideStringField;
    quKassaSummaRest: TFloatField;
    quBanksNAME: TStringField;
    quBanksMFO: TStringField;
    quBanksOKPO: TStringField;
    quBanksid: TIntegerField;
    quBanksinvoice_num: TFloatField;
    quBanksName_Invoice: TStringField;
    quBanksDescription: TStringField;
    quBanksDate: TWideStringField;
    quBanksSummaRest: TFloatField;
    quBanksIsMain: TBooleanField;
    quBanksPkey: TLargeintField;
    quBanksInvoice_pkey: TLargeintField;
    dsVidSotrudInPepsico: TMSDataSource;
    quVidSotrudInPepsico: TMSQuery;
    quVidSotrudInPepsicoLevel: TStringField;
    quVidSotrudInPepsicoLevelName: TStringField;
    quVidSotrudInPepsicoSubLevelAbb: TStringField;
    quVidSotrudInPepsicoActive: TBooleanField;
    UpdateVidSotrudInPepsico: TMSUpdateSQL;
    quVidSotrudInPepsicoId: TIntegerField;
    quSalesChannelsOfPepsico: TMSQuery;
    dsSalesChannelsOfPepsico: TMSDataSource;
    UpdateSalesChannelsOfPepsico: TMSUpdateSQL;
    quSalesChannelsOfPepsicoId: TIntegerField;
    quSalesChannelsOfPepsicoCode: TIntegerField;
    quSalesChannelsOfPepsicoChannelL1: TStringField;
    quSalesChannelsOfPepsicoChannelL2: TStringField;
    quSalesChannelsOfPepsicoChannelL3: TStringField;
    quSalesChannelsOfPepsicoChannelL4: TStringField;
    quSalesChannelsOfPepsicoActive: TBooleanField;
    quSotrudSotrudLevelInPepsico: TStringField;
    quKOATUU: TMSQuery;
    dsKOATUU: TMSDataSource;
    UpdateKOATUU: TMSUpdateSQL;
    quKOATUUId: TIntegerField;
    quKOATUUKOATUU_ID_CODE: TStringField;
    quKOATUUKOATUU_L1_Name_Rus: TStringField;
    quKOATUUKOATUU_L2_Name_Rus: TStringField;
    quKOATUUKOATUU_L3_Name_Rus: TStringField;
    quKOATUUKOATUU_L4_Name_Rus: TStringField;
    quKOATUUKOATUU_L1_Name_En: TStringField;
    quKOATUUKOATUU_L2_Name_En: TStringField;
    quKOATUUKOATUU_L3_Name_En: TStringField;
    quKOATUUKOATUU_L4_Name_En: TStringField;
    quKOATUUKOATUU_LEVEL: TWideStringField;
    quKOATUUActive: TBooleanField;
    quAddressPost_CODE_Commerce_Network: TMSQuery;
    dsAddressPost_CODE_Commerce_Network: TMSDataSource;
    UpdateAddressPost_CODE_Commerce_Network: TMSUpdateSQL;
    quAddressPost_CODE_Commerce_NetworkID: TIntegerField;
    quAddressPost_CODE_Commerce_NetworkCode: TWideStringField;
    quAddressPost_CODE_Commerce_NetworkDescription: TWideStringField;
    quAddressPost_CODE_Commerce_NetworkDescriptionRUS: TWideStringField;
    quAddressPost_CODE_Commerce_NetworkActive: TBooleanField;
    quSotrudParentSotrudNo: TSmallintField;
    quSotrudParentSotrudName: TStringField;
    quSotrudNameLevel: TStringField;
    quSotrudV: TBooleanField;
    dsReasonForUnlocking: TMSDataSource;
    quReasonForUnlocking: TMSQuery;
    UpdateReasonForUnlocking: TMSUpdateSQL;
    quReasonForUnlockingReasonNo: TSmallintField;
    quReasonForUnlockingReasonName: TStringField;
    quReasonForUnlockingVisible: TBooleanField;
    quReasonForUnlockingLimit: TIntegerField;
    quCarsis_Refrigerator: TBooleanField;
    quReasonForUnlockingIsSendForCite: TBooleanField;
    quReasonForUnlockingPercentUnlocking: TIntegerField;
    dsVidOtdel: TMSDataSource;
    quVidOtdel: TMSQuery;
    quVidOtdelOtdelNo: TSmallintField;
    quVidOtdelOtdelName: TStringField;
    quVidOtdelD_ACTIVITY_TYPE_ID: TIntegerField;
    quVidOtdelD_ACTIVITY_TYPE_NAME: TStringField;
    quVidOtdelD_RESPONSE_DEPT_ID: TLargeintField;
    quVidOtdelD_RESPONSE_DEPT_NAME: TStringField;
    UpdateVidOtdel: TMSUpdateSQL;
    quVidOtdelManager_Team_Id: TSmallintField;
    quVidOtdelNameManegerTeam: TStringField;
    dsUsers: TMSDataSource;
    quUsers: TMSQuery;
    quUsersUserNo: TIntegerField;
    quUsersUserName: TStringField;
    quUsersCodeAccess: TSmallintField;
    quUsersPassword: TStringField;
    quUsersEditPost: TBooleanField;
    quUsersFormWight: TIntegerField;
    quUsersFormHeight: TIntegerField;
    quUsersFormLeft: TIntegerField;
    quUsersFormTop: TIntegerField;
    quUsersSkin: TIntegerField;
    quVidNakl: TMSQuery;
    dsVidNakl: TMSDataSource;
    quVidRashodIsVisebleInDolg: TBooleanField;
    quTovarMinCarryover: TFloatField;
    dsCheckMeshCutting: TMSDataSource;
    quCheckMeshCutting: TMSQuery;
    UpdateCheckMeshCutting: TMSUpdateSQL;
    quCheckMeshCuttingDateCheck: TDateTimeField;
    quCheckMeshCuttingIsCheck: TBooleanField;
    dsGroupCutting: TMSDataSource;
    quGroupCutting: TMSQuery;
    quGroupCuttingid: TIntegerField;
    quGroupCuttingNameGropCutting: TStringField;
    quGroupCuttingPriorityGroupCutting: TIntegerField;
    quGroupCuttingPercentGroupCutting: TIntegerField;
    dsCurrency: TMSDataSource;
    quCurrency: TMSQuery;
    quCurrencyID: TIntegerField;
    quCurrencyNAME: TStringField;
    quCurrencyL_CODE: TStringField;
    quCurrencySHORT_NAME: TStringField;
    quCurrencyIsDefault: TBooleanField;
    UpdateCurrency: TMSUpdateSQL;
    quCurrencyisTrash: TBooleanField;
    dsCurrencyExchange: TMSDataSource;
    quCurrencyExchange: TMSQuery;
    UpdateCurrencyExchange: TMSUpdateSQL;
    quCurrencyExchangeid: TLargeintField;
    quCurrencyExchangeCurrencyId: TIntegerField;
    quCurrencyExchangeDateExchange: TDateTimeField;
    quCurrencyExchangeRate: TFloatField;
    quCurrencyExchangeIsActive: TBooleanField;
    quCurrencyExchangeCyrrencyName: TStringField;
    quCurrencyExchangeCyrrencyAbv: TStringField;
    dsVidRashodGroup1: TMSDataSource;
    UpdateVidRashodGroup1: TMSUpdateSQL;
    quVidRashodGroupIsTrash: TBooleanField;
    quVidRashodGroup1: TMSQuery;
    quVidRashodGroup1id: TIntegerField;
    quVidRashodGroup1name: TStringField;
    quVidRashodGroup1IsTrash: TBooleanField;
    quCurrencyisCrossCurrency: TBooleanField;
    procedure quTovarBeforePost(DataSet: TDataSet);
    procedure quTovarBeforeDelete(DataSet: TDataSet);
    procedure quTovarAfterOpen(DataSet: TDataSet);
    procedure quTovarBeforeClose(DataSet: TDataSet);
    procedure quVidTovNewRecord(DataSet: TDataSet);
    procedure quVidTovBeforePost(DataSet: TDataSet);
    procedure quVidTovBeforeDelete(DataSet: TDataSet);
    procedure quTovarNameTovarChange(Sender: TField);
    procedure quSotrudBeforePost(DataSet: TDataSet);
    procedure quSotrudBeforeDelete(DataSet: TDataSet);
    procedure quCompanyBeforePost(DataSet: TDataSet);
    procedure quCompanyBeforeDelete(DataSet: TDataSet);
    procedure quRegionsBeforePost(DataSet: TDataSet);
    procedure quRegionsBeforeDelete(DataSet: TDataSet);
    procedure quVidRashodBeforeDelete(DataSet: TDataSet);
    procedure quVidRashodBeforePost(DataSet: TDataSet);
    procedure quTipTovaraBeforeDelete(DataSet: TDataSet);
    procedure quTipTovaraBeforePost(DataSet: TDataSet);
    procedure quCarsAfterOpen(DataSet: TDataSet);
    procedure quCarsBeforeClose(DataSet: TDataSet);
    procedure quCarsBeforeDelete(DataSet: TDataSet);
    procedure quCarsBeforePost(DataSet: TDataSet);
    procedure quShipping_AgentAfterOpen(DataSet: TDataSet);
    procedure quShipping_AgentBeforeClose(DataSet: TDataSet);
    procedure quShipping_AgentBeforeDelete(DataSet: TDataSet);
    procedure quShipping_AgentBeforePost(DataSet: TDataSet);
    procedure quTovarNewRecord(DataSet: TDataSet);
    procedure quSotrudNewRecord(DataSet: TDataSet);
    procedure quSetupBeforePost(DataSet: TDataSet);
    procedure quSetupForExpeditionBeforePost(DataSet: TDataSet);
    procedure quDeliveryOfGoodBeforeDelete(DataSet: TDataSet);
    procedure quDeliveryOfGoodBeforePost(DataSet: TDataSet);


  private
    function GetUserConnectParam(var ConnectionInfo: string): Boolean; override;
    { Private declarations }
  public
    { Public declarations }
    FirmNo, PrevPostNo, PrevCarsNo, PrevShipping_AgentNo, PrevTovarNo1, PrevTovarNo: integer;
    NaklNoForBlankOrder: integer; //����� ������ ���� ������
    OurFirmName: string;
    function is_user_exists(p_password: string; var p_UserNo: Integer; var p_CodeAccess: Integer; var p_FormWight: Integer; var p_FormHeight:
      Integer; var p_FormLeft: Integer; var p_FormTop: Integer): boolean;
    function get_entity_param(p_entity_code: string): Tstrings; overload;
    function get_entity_param(attribute_id: Integer): Tstrings; overload;
    function get_prop_dlg_attribute_param(attribute_id: Integer): TStrings;
    function get_selected_sql(p_owner_name: string; p_param_name: string; p_table_name: string; p_key_field: string; p_txt_field: string):
      WideString;
      overload;
    function get_selected_sql(p_owner_name: string; p_param_name: string; p_entity_code: string): WideString; overload;
    function get_selected_value(p_owner_name: string; p_param_name: string; p_entity_code: string; var p_txt_value: TStrings; var p_key_value:
      TStrings): Integer; overload;
    function get_selected_value(p_owner_name: string; p_param_name: string; p_entity_code: string; var p_txt_value: string; var p_key_value: string):
      Integer; overload;
    function parse_flt_sql(p_sql: WideString; p_Owner_Name: string; p_Entity_Name: string): WideString;
    function get_prop_dlg_attribute_owner(attribute_id: Integer): string;
    function get_prop_dlg_owner(prop_dlg_id: Integer): string;
    function get_entity_sql(p_entity_code: string; p_KeyFieldValue: string = ''): WideString;
    procedure Add_session_params(p_owner_name: string; p_entity_name: string; p_value: string);
    procedure Del_session_params(p_owner_name: string; p_entity_name: string; p_value: string);
    procedure SetDefaultValue(p_control: TWinControl; attribute_id: Integer; Value: string = '');
    procedure set_entity_value(p_control: TWinControl; Value: string = '');
    procedure get_flt_sql(attribute_id: Integer; var a_filter_sql: string; var a_default_value: string; Value: string='');
    procedure set_txt_value_by_key(p_control: TCitDbComboEdit);
    procedure WriteDataSetParam(var DataSet: TMSQuery; params: TStrings);
    function ReadDataSetParam(var DataSet: TMSQuery): TStrings;
    function GetDefaultValue(attribute_id: Integer): string;
    function GetAppSettingsValue(section: string; name: string): string;
    function ConvertToVariant(const Value: TVarRec): Variant;
    function getFiscalPort(OurFirmNo: Integer): Integer;
    function FiscPrinterConnect(Open: Boolean): Boolean;
    procedure TestCash;
    procedure SetModeCash(Mode: integer);
    //    procedure ReadDataSetParam(var DataSet:TMSQuery;params:TStrings);
    function get_object_property_values(
      object_property_id: Integer): TParams;
    function OnUserConnect(var ConnectionInfo: string): Boolean; override;
    procedure OnUserDisConnect(var ConnectionInfo: string); override;

  end;
  
   ECashError = class(Exception);
   function GetCompName: string;


const
  SearchSet = ['A'..'Z', 'a'..'z', '�'..'�', '�'..'�', '0'..'9'];
  SearchSetWitoutDigits = ['A'..'Z', 'a'..'z', '�'..'�', '�'..'�'];
var


//////////////////////////////////////////////////////////////////////////
NameUsersState: string;
UserAccessToEditingPublishers: Boolean;
//////////////////////////////////////////////////////////////////////////


  dmDataModule: TdmDataModule;
  CodeAccess, UserNo: integer;
  ServSection: string;
  FormWight, FormHeight, FormLeft, FormTop: integer;
function Coder(Value: string): string;
procedure FillComboEdit(DataSet: TDataSet; p_ComboEdit: TComboBox; p_KeyPosition: integer; p_field_Name: string);
implementation

uses main, UtilsDataConvert, UtilsCommon,cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar;

{$R *.DFM}

function TdmDataModule.FiscPrinterConnect(Open: Boolean): Boolean;
var
  Ini: TIniFile;
  Port: Integer;
begin
  //����������� ����������� ��������
  if (not Open) and PrinterCash then
  begin
    PrinterCash := False;
    Result := True;
    Exit;
  end;
  if (not Open) and (not PrinterCash) then
  begin
    PrinterCash := False;
    Result := False;
    Exit;
  end;

  if not PrinterCash then
  begin
    PrinterCash := True;
    try
       //*******************************************************************************************
       if GlobalOurFirmNo = 490 then
       begin
         FiscPrinter := createoleobject('M301Manager.Application');
       end;


         if GlobalOurFirmNo = 7419 then
         begin
           FiscPrinter := createoleobject('M304Manager.Application');
           //FiscPrinter := createoleobject('M301Manager.Application');
         end;

        //******************************************************************************************

    except
      PrinterCash := False;
    end;
    if PrinterCash then
    begin
      FiscPrinter.ShowErrorMessages := 0;
      {��������/��������� ����� �� ����� ��������� ��������
      ��� ������ ����� � ������ ���������. �� ��������� ���
      ����������� ��������� ����� OLE ��������� �������
      ������� �� ���������.}
      FiscPrinter.ShowStatusDialogs := 0;
      Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setup.ini');
      Port := getFiscalPort(FirmNo);
      Ini.Free;
      {     Result:=False;
           PrinterCash:=False;
           try
            FiscPrinter.Init(Port, '���� �.', '1111111111', 0, 'Mleko');
           except
            Result:=True;
            PrinterCash:=True;
           end;
            ShowMessage(NameUsersState);
           }

      if FiscPrinter.Init(Port, NameUsersState, '1111111111', 0, 'Mleko') = 0 then
      begin
        Result := False;
        PrinterCash := False;
        MessageDlg('FiscPrinter.Init(' + IntToStr(Port) + ', '''+NameUsersState+''', "1111111111", 0, "Mleko")!', mtInformation, [mbOk], 0);
      end
      else
      begin
        Result := True;
        PrinterCash := True;
      end;
    end;
  end
  else
    Result := True;
end;

procedure TdmDataModule.TestCash;
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
  //SellArtCashProc :TSellArtCashProc;
  //CloseReceiptProc:TCloseReceiptProc;
  Res, Port: Integer;
  Ini: TIniFile;
begin
  Screen.Cursor := crHourGlass;
  nLib := LoadLibrary('fisc.dll');
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
  //CloseReceiptProc:=TCloseReceiptProc(GetProcAddress(nLib,'CloseReceipt'));
  //
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setup.ini');
  Port := getFiscalPort(FirmNo);
  Ini.Free;
  try

//*******************************************************************************************
       if GlobalOurFirmNo = 490 then
         begin
           Res := SetComPortProc(Port, 4800);
          end;

       if GlobalOurFirmNo = 7419 then
         begin
           Res := SetComPortProc(Port, 9600);
           end;

//********************************************************************************************

    if (Res < 0) then
      raise ECashError.Create('������ �������� ����� ' + IntToStr(Res));
    ResetCashesProc;
    Res := IsCashProc(1);
    if (Res < 0) then
      raise ECashError.Create('������ ����������� ����� ' + IntToStr(Res));
    Res := StrPrntCashProc(1, '�������� �����', nil, nil, nil, nil);
    if (Res < 0) then
      raise ECashError.Create('������ ������ ' + IntToStr(Res));
  finally
    CloseComPortProc(Port);
    FreeLibrary(nLib);
    Screen.Cursor := crDefault;
  end;
end;

procedure TdmDataModule.SetModeCash(Mode: integer);
type
  TSetModeProc = function(NumCash, Mode: integer): integer; StdCall;
  TSetComPortProc = function(Numb, Speed: Integer): Integer; StdCall;
  TCloseComPortProc = function(Numb: integer): integer; StdCall;

var
  nLib: THandle;
  SetModeProc: TSetModeProc;
  SetComPortProc: TSetComPortProc;
  CloseComPortProc: TCloseComPortProc;
  Port, Res: integer;
  Ini: TiniFile;
begin
  Screen.Cursor := crHourGlass;
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setup.ini');
  Port := getFiscalPort(FirmNo);
  Ini.Free;
  nLib := LoadLibrary('fisc.dll');
  if nLib < 32 then
  begin
    ShowMessage('�� ���� ��������� fisc.dll');
    Screen.Cursor := crDefault;
    exit;
  end;
  SetComPortProc := TSetComPortProc(GetProcAddress(nLib, 'SetComPort'));
  CloseComPortProc := TCloseComPortProc(GetProcAddress(nLib, 'CloseComPort'));
  SetModeProc := TSetModeProc(GetProcAddress(nLib, 'SetMode'));
  try


//*******************************************************************************************
       if GlobalOurFirmNo = 490 then
         begin
           Res := SetComPortProc(Port, 4800);
          end;

       if GlobalOurFirmNo = 7419 then
         begin
           Res := SetComPortProc(Port, 9600);
           end;

//********************************************************************************************


    if (Res < 0) then
      raise ECashError.Create('������ �������� ����� ' + IntToStr(Res));
    Res := SetModeProc(1, Mode);
    if (Res < 0) then
      raise ECashError.Create('������ SetMode ' + IntToStr(Res));
  finally
    CloseComPortProc(Port);
    FreeLibrary(nLib);
    Screen.Cursor := crDefault;
  end;
end;

function Coder(Value: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(Value) do
    Result := Result + Chr(Ord(Value[i]) xor $A5);
end;

procedure TdmDataModule.quTovarBeforePost(DataSet: TDataSet);
begin
  quTovarVidName.AsString := quTovarVidNameLC.AsString;
  quTovarTipName.AsString := quTovarTipNameLC.AsString;
  quTovarNameCompany.AsString := quTovarNameCompanyLC.AsString;
  quTovarOtdelName.AsString := quTovarOtdelNameLC.AsString;
  // quTovartaOtdelName.AsString:=quTovarOtdelNameLC.AsString;
  if quTovar.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(TovarNo) from Tovar ');
    quWork.Open;
    quTovarTovarNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateTovar.Apply(ukInsert);
  end
  else
    UpdateTovar.Apply(ukModify);
end;

procedure TdmDataModule.quTovarBeforeDelete(DataSet: TDataSet);
begin
  UpdateTovar.Apply(ukDelete);
end;

procedure TdmDataModule.quTovarAfterOpen(DataSet: TDataSet);
begin
  quTovar.Locate('TovarNo', PrevTovarNo, []);
end;

procedure TdmDataModule.quTovarBeforeClose(DataSet: TDataSet);
begin
  PrevTovarNo := quTovarTovarNo.AsInteger;
end;

procedure TdmDataModule.quVidTovNewRecord(DataSet: TDataSet);
begin
  quVidTovPriceWithNDS.AsBoolean := True;
  quVidTovPrintToPrice.AsBoolean := True;
  quVidTovPrintToExpedition.AsBoolean := False;
  quVidTovVisible.AsBoolean := False;
end;

procedure TdmDataModule.quVidTovBeforePost(DataSet: TDataSet);
begin
  if quVidTov.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(VidNo) from VidTov');
    quWork.Open;
    quVidTovVidNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateVidTov.Apply(ukInsert);
  end
  else
    UpdateVidTov.Apply(ukModify);
end;

procedure TdmDataModule.quVidTovBeforeDelete(DataSet: TDataSet);
begin
  UpdateVidTov.Apply(ukDelete);
end;

procedure TdmDataModule.quTovarNameTovarChange(Sender: TField);
begin
  if quTovar.State = dsInsert then
    quTovarNameTovarShort.AsString := quTovarNameTovar.AsString;
end;

procedure TdmDataModule.quSotrudBeforePost(DataSet: TDataSet);
begin
  if quSotrud.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(SotrudNo) from Sotrud');
    quWork.Open;
    quSotrud.FieldByName('SotrudNo').AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateSotrud.Apply(ukInsert);
  end
  else
    UpdateSotrud.Apply(ukModify);
end;

procedure TdmDataModule.quSotrudBeforeDelete(DataSet: TDataSet);
begin
  UpdateSotrud.Apply(ukDelete);
end;

procedure TdmDataModule.quCompanyBeforePost(DataSet: TDataSet);
begin
  if quCompany.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(CompanyNo) from Company');
    quWork.Open;
    quCompanyCompanyNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateCompany.Apply(ukInsert);
  end
  else
    UpdateCompany.Apply(ukModify);
end;

procedure TdmDataModule.quCompanyBeforeDelete(DataSet: TDataSet);
begin
  UpdateCompany.Apply(ukDelete);
end;

procedure TdmDataModule.quRegionsBeforePost(DataSet: TDataSet);
begin
  if quRegions.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(RegionNo) from Regions');
    quWork.Open;
    quRegionsRegionNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateRegions.Apply(ukInsert);
  end
  else
    UpdateRegions.Apply(ukModify);
end;

procedure TdmDataModule.quRegionsBeforeDelete(DataSet: TDataSet);
begin
  UpdateRegions.Apply(ukDelete);
end;

procedure TdmDataModule.quVidRashodBeforeDelete(DataSet: TDataSet);
begin
  UpdateVidRashod.Apply(ukDelete);
end;

procedure TdmDataModule.quVidRashodBeforePost(DataSet: TDataSet);
begin
  if quVidRashod.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(VidRashodNo) from VidRashod');
    quWork.Open;
    quVidRashodVidRashodNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateVidRashod.Apply(ukInsert);
  end
  else
    UpdateVidRashod.Apply(ukModify);
end;

procedure TdmDataModule.quTipTovaraBeforeDelete(DataSet: TDataSet);
begin
  UpdateTipTovara.Apply(ukDelete);
end;

procedure TdmDataModule.quTipTovaraBeforePost(DataSet: TDataSet);
begin
  if quTipTovara.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(TipNo) from TipTovara');
    quWork.Open;
    quTipTovaraTipNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateTipTovara.Apply(ukInsert);
  end
  else
    UpdateTipTovara.Apply(ukModify);
end;

procedure TdmDataModule.quCarsAfterOpen(DataSet: TDataSet);
begin
  quCars.Locate('CarsNo', PrevCarsNo, []);
end;

procedure TdmDataModule.quCarsBeforeClose(DataSet: TDataSet);
begin
  PrevCarsNo := quCarsCarsNo.AsInteger;
end;

procedure TdmDataModule.quCarsBeforeDelete(DataSet: TDataSet);
begin
  UpdateCars.Apply(ukDelete);
end;

procedure TdmDataModule.quCarsBeforePost(DataSet: TDataSet);
begin
  if quCars.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(CarsNo) from Cars ');
    quWork.Open;
    quCarsCarsNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateCars.Apply(ukInsert);
  end
  else
    UpdateCars.Apply(ukModify);
end;

procedure TdmDataModule.quShipping_AgentAfterOpen(DataSet: TDataSet);
begin
  quShipping_Agent.Locate('Shipping_AgentNo', PrevShipping_AgentNo, []);
end;

procedure TdmDataModule.quShipping_AgentBeforeClose(DataSet: TDataSet);
begin
  PrevShipping_AgentNo := quShipping_AgentShipping_AgentNo.AsInteger;
end;

procedure TdmDataModule.quShipping_AgentBeforeDelete(DataSet: TDataSet);
begin
  UpdateShipping_Agent.Apply(ukDelete);
end;

procedure TdmDataModule.quShipping_AgentBeforePost(DataSet: TDataSet);
begin
  if quShipping_Agent.State = dsInsert then
  begin
    quWork.SQL.Clear;
    quWork.SQL.Add('select Max(Shipping_AgentNo) from Shipping_Agent ');
    quWork.Open;
    quShipping_AgentShipping_AgentNo.AsInteger := quWork.Fields[0].AsInteger + 1;
    quWork.Close;
    UpdateShipping_Agent.Apply(ukInsert);
  end
  else
    UpdateShipping_Agent.Apply(ukModify);
end;

procedure TdmDataModule.quTovarNewRecord(DataSet: TDataSet);
begin
  quTovarExport1C.AsBoolean := False;
  quTovarChange1C.AsBoolean := False;
  quTovarCod1C.AsString := '';
  quTovarID1C.AsString := '';
  quTovarTaraNo.AsInteger := 0;
  quTovarVisible.AsBoolean := False;
end;

procedure TdmDataModule.quSotrudNewRecord(DataSet: TDataSet);
begin
  quSotrud.FieldByName('Visible').AsBoolean := False;
end;

procedure TdmDataModule.quSetupBeforePost(DataSet: TDataSet);
begin
  if quSetup.State = dsInsert then
  begin

  end
  else
    UpdateSetup.Apply(ukModify);
end;

procedure FillComboEdit(DataSet: TDataSet; p_ComboEdit: TComboBox; p_KeyPosition: integer; p_field_Name: string);
var
  i: integer;
  ln_keyPosition: integer;
begin
  p_ComboEdit.Items.Clear;
  i := 0;
  ln_keyPosition := 0;
  DataSet.First;
  while not DataSet.Eof do
  begin
    if DataSet.FieldByName('ID').AsInteger = p_KeyPosition then ln_keyPosition := i;
    p_ComboEdit.Items.Append(DataSet.FieldByName(p_field_Name).AsString);
    DataSet.Next;
    i := i + 1;
  end;
  p_ComboEdit.ItemIndex := ln_keyPosition;
  DataSet.First;
  DataSet.MoveBy(ln_keyPosition);
end;

function TdmDataModule.is_user_exists(p_password: string
  ; var p_UserNo: Integer
  ; var p_CodeAccess: Integer
  ; var p_FormWight: Integer
  ; var p_FormHeight: Integer
  ; var p_FormLeft: Integer
  ; var p_FormTop: Integer): boolean;
var
  lv_password: string;
begin
  try
    QFO.SQL.Clear;
    QFO.SQL.Add('select u.*,@@SPID as SPID from Users  u where Password=''' + Coder(p_password) + '''');
    QFO.Open;
    result := not QFO.Eof;
    if result then
    begin
      p_CodeAccess := QFO.FieldByName('CodeAccess').AsInteger;
      p_FormWight := QFO.FieldByName('FormWight').AsInteger;
      p_FormHeight := QFO.FieldByName('FormHeight').AsInteger;
      p_FormLeft := QFO.FieldByName('FormLeft').AsInteger;
      p_FormTop := QFO.FieldByName('FormTop').AsInteger;
      p_UserNo := QFO.FieldByName('UserNO').AsInteger;
    end;
  except
    result := false;
  end;
end;

function TdmDataModule.get_entity_param(p_entity_code: string): TStrings;
begin
  OpenSQL('select s.* from d_entity_type s where s.code= :p1_entity_code', [p_entity_code]);
//  showmessage( QFO.Params. );
  result := RowToStrings(QFO);
end;

function TdmDataModule.get_entity_param(attribute_id: Integer): TStrings;
begin
  QFO.Close;
  QFO.SQL.Clear;
  QFO.SQL.Add('select s.* from d_entity_type s,d_prop_dlg_attribute a where a.entity_type_id=s.id and  a.id=' + IntToStr(attribute_id));
  QFO.Open;
  result := RowToStrings(QFO);
end;

function TdmDataModule.get_object_property_values(object_property_id: Integer): TParams;
var
  l_sql: string;
begin

  l_sql := 'select a.name, a.caption, a.pos_left,a.pos_top, a.width, a.height, is_multiselect ' +
    ',def_value, num_order, filter_sql, visible,a.id,s.code ' +
    'from d_entity_type s,d_prop_dlg_attribute a ' +
    'where a.entity_type_id=s.id and  a.id= :p1_id ';
  OpenSQL(l_sql, [object_property_id]);
  result := RowToParams(QFO);
end;

function TdmDataModule.get_prop_dlg_attribute_param(attribute_id: Integer): TStrings;
begin
  QFO.Close;
  QFO.SQL.Clear;
  QFO.SQL.Add('select s.* from d_prop_dlg_attribute s where s.id=''' + IntToStr(attribute_id) + '''');
  QFO.Open;
  result := RowToStrings(QFO);
end;

function TdmDataModule.get_entity_sql(p_entity_code: string; p_KeyFieldValue: string = ''): WideString;
var
  ls_entity_param: TStrings;
  key_field, txt_field: string;
begin
  ls_entity_param := get_entity_param(p_entity_code);
  key_field := ls_entity_param.Values['key_field'];
  txt_field := ls_entity_param.Values['txt_field'];
  try
    result := 'select @@SPID as spid,v.' + key_field + ' as key_field, v.' + txt_field + ' as txt_field,v.*'
      + ' from ' + p_entity_code + ' v';
    if not (p_KeyFieldValue = '') then result := result + ' where v.' + key_field + '=' + p_KeyFieldValue;
  finally
    ls_entity_param.Free;
  end;
end;

function TdmDataModule.get_selected_sql(p_owner_name: string; p_param_name: string; p_table_name: string; p_key_field: string; p_txt_field: string):
  WideString;
begin
  result := 'select @@SPID as spid,p.param_value as key_field, v.' + p_txt_field + ' as txt_field'
    + ' from e_session_params p, ' + p_table_name + ' v'
    + ' where p.owner_name= ''' + p_owner_name + ''''
    + ' and p.param_name= ''' + p_param_name + ''''
    + ' and p.SPID=' + IntTOStr(SPID)
    + ' and p.param_value= v.' + p_key_field;

end;

function TdmDataModule.get_selected_sql(p_owner_name: string; p_param_name: string; p_entity_code: string): WideString;
var
  l_owner_name, l_param_name, l_table_name, l_key_field, l_txt_field: string;
  ls_entity_param: TStrings;
begin
  l_owner_name := p_owner_name;
  l_param_name := p_param_name;
  try
    ls_entity_param := get_entity_param(p_entity_code);
    l_key_field := trim(ls_entity_param.Values['key_field']);
    l_txt_field := trim(ls_entity_param.Values['txt_field']);
    l_table_name := trim(ls_entity_param.Values['name']);
    result := get_selected_sql(l_owner_name, l_param_name, l_table_name, l_key_field, l_txt_field);
  finally
    ls_entity_param.Free;
  end;
end;

function TdmDataModule.get_selected_value(p_owner_name: string; p_param_name: string; p_entity_code: string; var p_txt_value: TStrings; var
  p_key_value: TStrings): Integer;
var
  i: Integer;
  l_sql: string;
begin
  l_sql := get_selected_sql(p_owner_name, p_param_name, p_entity_code);
  p_txt_value.Clear;
  p_key_value.Clear;
  i := 0;
  if (p_entity_code <> 'DATE') and (p_entity_code <> 'BOOLEAN') and (p_entity_code <> 'FLOAT') and (p_entity_code <> 'TEXT') then
  begin
    qfo.close;
    qfo.SQL.Clear;
    qfo.SQL.Add(l_sql);
    qfo.Open;
    qfo.first;
    while not qfo.Eof do
    begin
      p_txt_value.Add(qfo.fieldByName('txt_field').AsString);
      p_key_value.Add(qfo.fieldByName('key_field').AsString);
      qfo.Next;
      inc(i);
    end;
  end;
  result := i;
end;

function TdmDataModule.get_selected_value(p_owner_name: string; p_param_name: string; p_entity_code: string; var p_txt_value: string; var
  p_key_value: string): Integer;
var
  l_txt_value: TStrings;
  l_key_value: TStrings;
begin
  l_txt_value := TStringList.Create;
  l_key_value := TStringList.Create;
  try
    result := get_selected_value(p_owner_name, p_param_name, p_entity_code, l_txt_value, l_key_value);
    p_txt_value := l_txt_value[0];
    p_key_value := l_key_value[0];
  finally
    l_txt_value.Free;
    l_key_value.Free;
  end;
end;

procedure TdmDataModule.Add_session_params(p_owner_name: string; p_entity_name: string; p_value: string);
begin
  spAdd_session_params.Close;
  spAdd_session_params.Params.ParamByName('p_UserNo').Value := UserNo;
  spAdd_session_params.Params.ParamByName('p_owner_name').Value := p_owner_name;
  spAdd_session_params.Params.ParamByName('p_param_name').Value := p_entity_name;
  spAdd_session_params.Params.ParamByName('p_param_value').Value := p_value;
  spAdd_session_params.Params.ParamByName('spid').Value := SPID;
  spAdd_session_params.ExecProc;
end;

procedure TdmDataModule.Del_session_params(p_owner_name: string; p_entity_name: string; p_value: string);
begin
  spDel_session_params.Close;
  spDel_session_params.Params.ParamByName('p_UserNo').Value := UserNo;
  spDel_session_params.Params.ParamByName('p_owner_name').Value := p_owner_name;
  spDel_session_params.Params.ParamByName('p_param_name').Value := p_entity_name;
  spDel_session_params.Params.ParamByName('p_param_value').Value := p_value;
  spDel_session_params.Params.ParamByName('spid').Value := SPID;
  spDel_session_params.ExecProc;
end;

function TdmDataModule.parse_flt_sql(p_sql: WideString; p_Owner_Name: string; p_Entity_Name: string): WideString;
var
  l_result: WideString;
  l_year, l_month, l_day: Word;
  l_globaldatenakl: string;
begin
  l_result := AnsiReplaceText(p_sql, '<USERNO>', IntToStr(UserNo));
  l_result := AnsiReplaceText(l_result, '<OWNERNAME>', '''' + p_Owner_Name + '''');
  l_result := AnsiReplaceText(l_result, '<PARAMNAME>', '''' + p_Entity_Name + '''');
  l_result := AnsiReplaceText(l_result, 'GLOBALDATENAKL', ' :GlobalDateNakl ');
  l_result := AnsiReplaceStr(l_result, 'GLOBALOTDELNO', IntToStr(GlobalOtdelNo));
  l_result := AnsiReplaceText(l_result, '<SPID>', inttostr(SPID));
  result := l_result;
end;

procedure TdmDataModule.get_flt_sql(attribute_id: Integer; var a_filter_sql: string; var a_default_value: string; Value: string);
var
  l_result, l_sql: WideString;
  l_owner_name, l_Entity_name: string;
begin
  qfo.Close;
  qfo.SQL.Clear;
  qfo.SQL.Add('select a.filter_sql,a.def_value,a.name,t.code+ltrim(str(p.num)) as owner from d_prop_dlg_attribute a,d_prop_dlg p,d_prop_dlg_type t where p.id=a.prop_dlg_id and p.type_id=t.id and a.id=' + IntToStr(attribute_id));
  qfo.Open;
  l_owner_name := qfo.fieldByName('owner').AsString;
  l_Entity_name := qfo.fieldByName('name').AsString;
  if Value <> '' then
    a_default_value := parse_flt_sql(Value, l_owner_name, l_Entity_name)
  else
    a_default_value := parse_flt_sql(qfo.fieldByName('def_value').AsString, l_owner_name, l_Entity_name);
  a_filter_sql := parse_flt_sql(qfo.fieldByName('filter_sql').AsString, l_owner_name, l_Entity_name);
end;

function TdmDataModule.get_prop_dlg_attribute_owner(attribute_id: Integer): string;
begin
  qfo.Close;
  qfo.SQL.Clear;
  qfo.SQL.Add('select t.code+ltrim(str(p.num)) as owner from d_prop_dlg_attribute a,d_prop_dlg p,d_prop_dlg_type t where p.id=a.prop_dlg_id and p.type_id=t.id and a.id=' + IntToStr(attribute_id));
  qfo.Open;
  result := qfo.fieldByName('owner').AsString;
end;

function TdmDataModule.get_prop_dlg_owner(prop_dlg_id: Integer): string;
begin
  qfo.Close;
  qfo.SQL.Clear;
  qfo.SQL.Add('select t.code+ltrim(str(p.num)) as owner from d_prop_dlg p,d_prop_dlg_type t where p.type_id=t.id and p.id=' + IntToStr(prop_dlg_id));
  qfo.Open;
  result := qfo.fieldByName('owner').AsString;
end;

procedure TdmDataModule.set_entity_value(p_control: TWinControl; Value: string = '');
var
  sql_str: string;
  ls_txt_value, ls_key_value: TStrings;
  c: TcitDBComboEdit;
  ch: TCheckBox;
  val_count: Integer;
begin
  ls_txt_value := TStringList.Create;
  ls_key_value := TStringList.Create;
  try
    if (p_control is TcitDBComboEdit) then
    begin
      c := (p_control as TcitDBComboEdit);
      val_count := get_selected_value(c.Owner, p_control.Name, c.EntityCode, ls_txt_value, ls_key_value);
      if val_count > 1 then
      begin
        c.Text := ls_txt_value.CommaText;
        c.KeyFieldValue := '1' //ls_key_value.CommaText;
      end
      else if val_count = 1 then
      begin
        c.Text := ls_txt_value[0];
        c.KeyFieldValue := ls_key_value[0];
      end
      else if (c.KeyFieldValue <> '')
           and (val_count<>0) // added 16.02.2017 by Sergio Chemist
           then
      begin
        set_txt_value_by_key((p_control as TcitDBComboEdit));
      end
      else
      begin
        c.KeyFieldValue := '-1';
        c.Text := '';
      end;
    end;
  finally
    ls_txt_value.Free;
    ls_key_value.Free;
  end;
end;

procedure TdmDataModule.SetDefaultValue(p_control: TWinControl; attribute_id: Integer; Value: string);
var
  l_flt, l_def_value, l_sql_str, l_date_res, data_type, control_code: string;
  p: TParam;
begin
  try
    get_flt_sql(attribute_id, l_flt, l_def_value,Value);
    if (p_control is TcitDBComboEdit) then (p_control as TcitDBComboEdit).SqlFilter := l_flt;
    if not (l_def_value = '') then
    begin
      qfo.Close;
      qfo.SQL.Clear;
      l_sql_str := 'select ' + l_def_value + ' as val';
      qfo.SQL.Add(l_sql_str);
      p := qfo.FindParam('GlobalDateNakl');
      if p <> nil then
      begin
//        qfo.Parambyname('GlobalDateNakl').DataType:=ftDate;
        qfo.Parambyname('GlobalDateNakl').AsDateTime := GlobalDateNakl;
      end;
      qfo.Open;
      if (p_control is TcitDBComboEdit) then
      begin
        (p_control as TcitDBComboEdit).KeyFieldValue := qfo.FieldByName('val').AsString;
        set_entity_value(p_control as TcitDBComboEdit);
      end;
      if (p_control is TCheckBox) then (p_control as TCheckBox).Checked := qfo.FieldByName('val').AsInteger = 1;
      if (p_control is TCxDateEdit) then (p_control as TCxDateEdit).Date := qfo.FieldByName('val').AsDateTime;      
    end
    else
    begin
      if (p_control is TcitDBComboEdit) then
      begin
        (p_control as TcitDBComboEdit).KeyFieldValue := '';
        set_entity_value(p_control as TcitDBComboEdit);
      end;
      if (p_control is TCheckBox) then (p_control as TCheckBox).Checked := false;
      if (p_control is TCxDateEdit) then (p_control as TCxDateEdit).Date := GlobalDateNakl;      
    end;
  except

  end;
end;

function TdmDataModule.GetDefaultValue(attribute_id: Integer): string;
var
  l_flt, l_def_value, l_sql_str, l_date_res, data_type, control_code: string;
begin
  get_flt_sql(attribute_id, l_flt, l_def_value);
  if not (l_def_value = '') then
  begin
    qfo.Close;
    qfo.SQL.Clear;
    l_sql_str := 'select ' + l_def_value + ' as val';
    qfo.SQL.Add(l_sql_str);
    qfo.Open;
    result := qfo.FieldByName('val').AsString;
  end
  else
    result := '';
end;

procedure TdmDataModule.set_txt_value_by_key(p_control: TCitDbComboEdit);
var
  l_sql: string;
begin
  if not (p_control.KeyFieldValue = '') then
    if p_control.EditStyle in [EdSelect] then
    begin
      l_sql := get_entity_sql(p_control.EntityCode, p_control.KeyFieldValue);
      qfo.Close;
      qfo.SQL.Clear;
      qfo.SQL.Add(l_sql);
      qfo.Open;
      p_control.Text := qfo.fieldByName('txt_field').AsString;
    end
    else
      p_control.Text := p_control.KeyFieldValue;
end;

procedure TdmDataModule.WriteDataSetParam(var DataSet: TMSQuery; params: TStrings);
var
  i: integer;
  l_param_name: string;
  l_dateValue: TDateTime;
begin
  for i := 0 to DataSet.Params.Count - 1 do
  begin
    l_param_name := DataSet.Params[i].Name;
    if TryStrToDate(params.values[l_param_name], l_dateValue) then
      DataSet.ParamByName(l_param_name).AsDateTime := l_dateValue
    else
      DataSet.ParamByName(l_param_name).AsString := params.values[l_param_name];
  end;
end;

function TdmDataModule.ReadDataSetParam(var DataSet: TMSQuery): TStrings;
var
  i: integer;
  l_param_name: string;
begin
  result := TStringList.Create;
  for i := 0 to DataSet.Params.Count - 1 do
  begin
    l_param_name := DataSet.Params[i].Name;
    result.values[l_param_name] := DataSet.ParamByName(l_param_name).AsString;
  end;
end;

function TdmDataModule.GetAppSettingsValue(section: string; name: string): string;
begin
  qfo1.Close;
  qfo1.SQL.Clear;
  qfo1.SQL.Add('select param_value from d_app_settings where section= :section and name= :name');
  qfo1.ParamByName('section').AsString := section;
  qfo1.ParamByName('name').AsString := name;
  qfo1.Open;
  result := qfo1.FieldByName('param_value').AsString;
end;

function TdmDataModule.ConvertToVariant(const Value: TVarRec): Variant;
begin
  with Value do
    case VType of
      vtInteger: Result := VInteger;
      vtInt64: Result := VInteger;
      vtBoolean: Result := VBoolean;
      vtChar: Result := VChar;
      vtExtended: Result := VExtended^;
      vtString: Result := VString^;
      vtPChar: Result := VPChar^;
      vtAnsiString: Result := string(VAnsiString);
      vtCurrency: Result := VCurrency^;
      //      vtVariant    : if not VarIsClear(VVariant^) then Result := VVariant^;
    else
      raise Exception.Create('���������������� ���������� ���');
    end;
end;

function TdmDataModule.getFiscalPort(OurFirmNo: Integer): Integer;
var
 This_Host_   : string;
begin

    This_Host_:= GetCompName;
    if    This_Host_ = 'SITEC03' then
       begin
           OpenSql('select * from d_fiscal where ourfirmNo=:p1_id and HostName=:p2_id', [OurFirmNo ,This_Host_]); 
           result := qfo.FieldByName('port').AsInteger;

         //***************************************************************************************************************
         //ShowMessage('Port: '  +IntToStr(result));


       end
    Else
       begin
           OpenSql('select * from d_fiscal where ourfirmNo=:p1_id', [OurFirmNo]);
           result := qfo.FieldByName('port').AsInteger;

         //***************************************************************************************************************
         //ShowMessage('Port: '  +IntToStr(result));

        end;  
end;

function TdmDataModule.GetUserConnectParam(
  var ConnectionInfo: string): Boolean;
var
  l_Password: string;

begin
  Result := inherited GetUserConnectParam(ConnectionInfo);
  l_Password := GetParamValue(ConnectionParams, 'UserPwd', varString, '');
  result := is_user_exists(l_Password, UserNo, CodeAccess, FormWight, FormHeight, FormLeft, FormTop);
  if not result then
  begin
    ConnectionInfo:='�������� ������!';
    result:=False;
    Exit;
  end
  else
  begin
      result := True;
      spSetUserLoginParam.Close;
      spSetUserLoginParam.Params.ParamByName('UserNo').AsInteger := UserNo;
      spSetUserLoginParam.Params.ParamByName('Connect_type').AsInteger := 1;
      spSetUserLoginParam.Params.ParamByName('SPID').AsInteger := SPID;
      spSetUserLoginParam.Params.ParamByName('PWD').AsString := 'gorlovka';
      spSetUserLoginParam.ExecProc;

       ////////////////////////////////////////////////////////////////////////

      {
       OpenSql('select UserName from Users where UserNo='''+ IntToStr(UserNo) +'''', [UserNo]);
       ShowMessage('����� ������ '+IntToStr(UserNo)+' | ������ '+l_Password+ ' |  ' + QFO.FieldByName('UserName').AsString);
       NameUsersState := QFO.FieldByName('UserName').AsString;
       ShowMessage(NameUsersState);
        }

      qfo1.Close;
      qfo1.SQL.Clear;
      qfo1.Connection := DB;
      qfo1.SQL.Add('select UserName,EditPost from Users where UserNo = :UserNo ');
      qfo1.ParamByName('UserNo').AsInteger := UserNo;
      qfo1.Open;

//            OpenSql('select UserName,EditPost from Users where UserNo='''+ IntToStr(UserNo) +'''', [UserNo]);     ///  ����� ������� �� ��.
      NameUsersState := QFO1.FieldByName('UserName').AsString;                                              ///  ��� ������� ��� ��������� � ����� ����
//      UserAccessToEditingPublishers := QFO1.FieldByName('EditPost').AsBoolean;                             ///  �����, ��������� �� ������������ ������������� ���������
      qfo1.Close;


            //ShowMessage('����� ������ '+IntToStr(UserNo)+' | ������ '+l_Password+ ' | ���  ' + QFO.FieldByName('UserName').AsString +' | ������ ' + QFO.FieldByName('EditPost').AsString);



       ///////////////////////////////////////////////////////////////////////

      SetParamValue(ConnectionParams, 'UserLogin', 'user_' + IntToStr(UserNo));
      SetParamValue(ConnectionParams, 'UserPwd', 'gorlovka');
//      dmDataModule.FirmNo := 490;
      dmDataModule.FirmNo := main.GlobalOurFirmNo;
  end;
end;

function TdmDataModule.OnUserConnect(var ConnectionInfo: string): Boolean;
begin
  result := inherited OnUserConnect(ConnectionInfo);
  if result then
  begin
    try
      qfo.Close;
      qfo.SQL.Clear;
      qfo.SQL.Add('select @@SPID as SPID');
      qfo.Open;
      SPID := qfo.FIeldByname('SPID').AsInteger;
      qfo.Close;
      spClear_session_params.Close;
      spClear_session_params.ParamByName('SPID').AsInteger := SPID;
      spClear_session_params.ExecProc;
      quPost.Open;
      quSotrud.MacroByName('_where').Value := 'where Sotrud.Visible=0 ';
      quSotrud.MacroByName('_order').Value := 'Sotrud.SotrudName';
      QuSotrud.Open;
    except
      ShowMessage('������ ������� ���������� ������');
    end;
  end;
end;

procedure TdmDataModule.OnUserDisConnect(var ConnectionInfo: string);
begin
  if DB.Connected then
  begin
    spClear_session_params.Close;
    spClear_session_params.ParamByName('SPID').AsInteger := SPID;
    spClear_session_params.ExecProc;
  end;
  inherited;
end;

procedure TdmDataModule.quSetupForExpeditionBeforePost(DataSet: TDataSet);
begin
  if quSetupForExpedition.State = dsInsert then
  begin

  end
  else
    UpdateSetupForExpedition.Apply(ukModify);
end;



procedure TdmDataModule.quDeliveryOfGoodBeforeDelete(DataSet: TDataSet);
begin
  UpdateDeliveryOfGoods.Apply(ukDelete);
end;

procedure TdmDataModule.quDeliveryOfGoodBeforePost(DataSet: TDataSet);
begin
  if quDeliveryOfGoods.State = dsInsert then UpdateDeliveryOfGoods.Apply(ukInsert)
                                        else UpdateDeliveryOfGoods.Apply(ukModify);

end;



function GetCompName: string;
var
  dwLength: dword;
begin
  dwLength := 253;
  SetLength(result, dwLength+1);
  if not Windows.GetComputerName(pchar(result), dwLength) then
    raise exception.create('Computer name not detected');
  result := pchar(result);
end;

initialization
  RegisterClass(TdmDataModule);

finalization
  UnRegisterClass(TdmDataModule);

end.


