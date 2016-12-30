unit GetDate0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, MlekoForm, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Mask, ActnList;

type
  TfmZapDate = class(TMlekoForm)
    Panel1: TPanel;
    mdDate: TMaskEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    mdDate2: TMaskEdit;
    bbPeriod: TBitBtn;
    procedure bbPeriodClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mdDateChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure mdDate2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type TPeriodDate = array [1..2] of tDateTime;
 //��� ��� �������� ������� ���

var
  fmZapDate: TfmZapDate;
function ZapDate(Tip:integer):TPeriodDate; overload;
function ZapDate(Tip:integer; SetDate: Tdate;p_caption: String):TPeriodDate; overload;
implementation

{$R *.DFM}
function ZapDate(Tip:integer):TPeriodDate;
var vYear,vMonth,vDay:word;
{ tip 1-������ ����
      2-���� � �������� ������
      3-������ ������
      4-������ �������� ����
}
begin
 Application.CreateForm(TfmZapDate, fmZapDate);
 fmZapDate.bbPeriod.Enabled:=(Tip=2) or (Tip=4);
 fmZapDate.mdDate.Focused;
 fmZapDate.mdDate.Text:=(DateToStr(Now));
 fmZapDate.mdDate2.Visible:=Tip>2;
 if fmZapDate.mdDate2.Visible then
  begin
   DecodeDate(Date(),vYear,vMonth,vDay);
   fmZapDate.mdDate.Text:=DateToStr(EncodeDate(vYear,vMonth,1));
   if vMonth=12 then
    begin
     vMonth:=0;
     Inc(vYear)
    end;
   fmZapDate.mdDate2.Text:=DateToStr(EncodeDate(vYear,vMonth+1,1));
   fmZapDate.bbPeriod.Caption:='&����';
   fmZapDate.Caption:='������� ������'
  end else
  begin
   fmZapDate.bbPeriod.Caption:='&������';
   fmZapDate.Caption:='������� ����';
  end;

 fmZapDate.ShowModal;

 Result[1]:=0;
 Result[2]:=0;
 if (fmZapDate.ModalResult=mrOk) then
  begin
   try
   Result[1]:=StrToDate(fmZapDate.mdDate.Text);
   if fmZapDate.mdDate2.Visible then
    Result[2]:=StrToDate(fmZapDate.mdDate2.Text)
   else
    Result[2]:=Result[1];
   except
    on EConvertError do MessageDlg('������������ ����',mtError,[mbOk],0);
   end;
  end;
end;

function ZapDate(Tip:integer; SetDate: Tdate; p_caption: String):TPeriodDate;
var vYear,vMonth,vDay:word;
{ tip 1-������ ����
      2-���� � �������� ������
      3-������ ������
      4-������ �������� ����
}
begin
 Application.CreateForm(TfmZapDate, fmZapDate);
 fmZapDate.bbPeriod.Enabled:=(Tip=2) or (Tip=4);
 fmZapDate.mdDate.Focused;
 fmZapDate.mdDate.Text:=(DateToStr(SetDate));
 fmZapDate.Caption:=p_caption;
 fmZapDate.mdDate2.Visible:=Tip>2;
 if fmZapDate.mdDate2.Visible then
  begin
   DecodeDate(Date(),vYear,vMonth,vDay);
   fmZapDate.mdDate.Text:=DateToStr(EncodeDate(vYear,vMonth,1));
   if vMonth=12 then
    begin
     vMonth:=0;
     Inc(vYear)
    end;
   fmZapDate.mdDate2.Text:=DateToStr(EncodeDate(vYear,vMonth+1,1));
   fmZapDate.bbPeriod.Caption:='&����';
   fmZapDate.Caption:=p_caption
  end else
  begin
   fmZapDate.bbPeriod.Caption:='&������';
   fmZapDate.Caption:=p_caption;
  end;

 fmZapDate.ShowModal;

 Result[1]:=0;
 Result[2]:=0;
 if (fmZapDate.ModalResult=mrOk) then
  begin
   try
   Result[1]:=StrToDate(fmZapDate.mdDate.Text);
   if fmZapDate.mdDate2.Visible then
    Result[2]:=StrToDate(fmZapDate.mdDate2.Text)
   else
    Result[2]:=Result[1];
   except
    on EConvertError do MessageDlg('������������ ����',mtError,[mbOk],0);
   end;
  end;
end;

procedure TfmZapDate.bbPeriodClick(Sender: TObject);
var vYear,vMonth,vDay:word;
begin
 with fmZapDate.mdDate2 do
  begin
   Visible:=Not Visible;
   if Visible then
    begin
     DecodeDate(Date(),vYear,vMonth,vDay);
     fmZapDate.mdDate.Text:=DateToStr(EncodeDate(vYear,vMonth,1));
     if vMonth=12 then
      fmZapDate.mdDate2.Text:=DateToStr(EncodeDate(vYear+1,1,1))
     else
      fmZapDate.mdDate2.Text:=DateToStr(EncodeDate(vYear,vMonth+1,1));
     fmZapDate.bbPeriod.Caption:='&����';
     fmZapDate.Caption:='������� ������';
    end
   else
    begin
     fmZapDate.mdDate.Text:=(DateToStr(Now));
     fmZapDate.bbPeriod.Caption:='&������';
     fmZapDate.Caption:='������� ����';
    end;
  end;
 fmZapDate.ActiveControl:=mdDate;
end;

procedure TfmZapDate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;


procedure TfmZapDate.mdDateChange(Sender: TObject);
begin
  if (mdDate.Showing)and(mdDate.SelStart=8)then
   begin
    try
     StrToDate(mdDate.Text);
    except
     mdDate.Clear;
    end;
   end;
end;

procedure TfmZapDate.BitBtn1Click(Sender: TObject);
begin
 try
  StrToDate(mdDate.Text);
 except
  mdDate.Clear;
  ActiveControl:=mdDate;
  exit;
 end;

 if mdDate2.Visible then
  begin
   try
    StrToDate(mdDate2.Text);
   except
    mdDate2.Clear;
    ActiveControl:=mdDate2;
    exit;
   end;
  end;
  // ���� ��� except-����� �� ��������� �����
  fmZapDate.ModalResult:=mrOK;
end;

procedure TfmZapDate.mdDate2Change(Sender: TObject);
begin
  if (mdDate2.Showing)and(mdDate2.SelStart=8)then
   begin
    try
     StrToDate(mdDate2.Text);
    except
     mdDate2.Clear;
    end;
   end;
end;

end.
