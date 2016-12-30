unit Utils;
interface
uses Dialogs,SysUtils,Menus;
function IntToString(Value:LongInt):string;
function IntToStringUkr(Value:LongInt):string;
function MonthToString(Value:integer;RodPad:boolean):string;
function MonthToStringUkr(Value:integer;RodPad:boolean):string;

implementation
function IntToString(Value:LongInt):string;
var dig :array [1..6] of integer;
    i:integer;
    t:string;
begin
 Result:='';
 t:='����� ';
 if Value>999999 then
  begin
   Result:='******';
   exit;
  end;
 for i:=1 to 6 do
  begin
   dig[i]:=Value mod 10;
   Value:=Value div 10;
  end;
 case dig[6] of
  1:Result:=Result+'��� ';
  2:Result:=Result+'������ ';
  3:Result:=Result+'������ ';
  4:Result:=Result+'��������� ';
  5:Result:=Result+'������� ';
  6:Result:=Result+'�������� ';
  7:Result:=Result+'������� ';
  8:Result:=Result+'��������� ';
  9:Result:=Result+'��������� ';
 end;
 case dig[5] of
  1:begin
     case dig[4] of
      0:Result:=Result+'������ ';
      1:Result:=Result+'���������� ';
      2:Result:=Result+'���������� ';
      3:Result:=Result+'���������� ';
      4:Result:=Result+'������������ ';
      5:Result:=Result+'���������� ';
      6:Result:=Result+'����������� ';
      7:Result:=Result+'���������� ';
      8:Result:=Result+'������������ ';
      9:Result:=Result+'������������ ';
     end;
    end;
  2:Result:=Result+'�������� ';
  3:Result:=Result+'�������� ';
  4:Result:=Result+'����� ';
  5:Result:=Result+'��������� ';
  6:Result:=Result+'���������� ';
  7:Result:=Result+'��������� ';
  8:Result:=Result+'����������� ';
  9:Result:=Result+'��������� ';
 end;
 if dig[5]<>1 then
  case dig[4] of
   1:begin
      Result:=Result+'���� ';
      t:='������ ';
     end;
   2:begin
      Result:=Result+'��� ';
      t:='������ ';
     end;
   3:begin
      Result:=Result+'��� ';
      t:='������ ';
     end;
   4:begin
      Result:=Result+'������ ';
      t:='������ ';
     end;
   5:Result:=Result+'���� ';
   6:Result:=Result+'����� ';
   7:Result:=Result+'���� ';
   8:Result:=Result+'������ ';
   9:Result:=Result+'������ ';
  end;
  if dig[6]+dig[5]+dig[4]>0 then Result:=Result+t;
//********************
 case dig[3] of
  1:Result:=Result+'��� ';
  2:Result:=Result+'������ ';
  3:Result:=Result+'������ ';
  4:Result:=Result+'��������� ';
  5:Result:=Result+'������� ';
  6:Result:=Result+'�������� ';
  7:Result:=Result+'������� ';
  8:Result:=Result+'��������� ';
  9:Result:=Result+'��������� ';
 end;
 case dig[2] of
  1:begin
     case dig[1] of
      0:Result:=Result+'������ ';
      1:Result:=Result+'���������� ';
      2:Result:=Result+'���������� ';
      3:Result:=Result+'���������� ';
      4:Result:=Result+'������������ ';
      5:Result:=Result+'���������� ';
      6:Result:=Result+'����������� ';
      7:Result:=Result+'���������� ';
      8:Result:=Result+'������������ ';
      9:Result:=Result+'������������ ';
     end;
    end;
  2:Result:=Result+'�������� ';
  3:Result:=Result+'�������� ';
  4:Result:=Result+'����� ';
  5:Result:=Result+'��������� ';
  6:Result:=Result+'���������� ';
  7:Result:=Result+'��������� ';
  8:Result:=Result+'����������� ';
  9:Result:=Result+'��������� ';
 end;
 if dig[2]<>1 then
  case dig[1] of
   1:Result:=Result+'���� ';
   2:Result:=Result+'��� ';
   3:Result:=Result+'��� ';
   4:Result:=Result+'������ ';
   5:Result:=Result+'���� ';
   6:Result:=Result+'����� ';
   7:Result:=Result+'���� ';
   8:Result:=Result+'������ ';
   9:Result:=Result+'������ ';
  end;
 Result:=AnsiUpperCase(Copy(Result,1,1))+Copy(Result,2,255);
end;
function IntToStringUkr(Value:LongInt):string;
var dig :array [1..6] of integer;
    i:integer;
    t:string;
begin
 Result:='';
 if Value=0 then Result:='����';
 t:='����� ';
 if Value>999999 then
  begin
   Result:='******';
   exit;
  end;
 for i:=1 to 6 do
  begin
   dig[i]:=Value mod 10;
   Value:=Value div 10;
  end;
 case dig[6] of
  1:Result:=Result+'��� ';
  2:Result:=Result+'���� ';
  3:Result:=Result+'������ ';
  4:Result:=Result+'��������� ';
  5:Result:=Result+'�`����� ';
  6:Result:=Result+'�������� ';
  7:Result:=Result+'����� ';
  8:Result:=Result+'������ ';
  9:Result:=Result+'���`����� ';
 end;
 case dig[5] of
  1:begin
     case dig[4] of
      0:Result:=Result+'������ ';
      1:Result:=Result+'���������� ';
      2:Result:=Result+'���������� ';
      3:Result:=Result+'���������� ';
      4:Result:=Result+'������������ ';
      5:Result:=Result+'�`��������� ';
      6:Result:=Result+'����������� ';
      7:Result:=Result+'��������� ';
      8:Result:=Result+'���������� ';
      9:Result:=Result+'���`��������� ';
     end;
    end;
  2:Result:=Result+'�������� ';
  3:Result:=Result+'�������� ';
  4:Result:=Result+'����� ';
  5:Result:=Result+'�`������� ';
  6:Result:=Result+'���������� ';
  7:Result:=Result+'������� ';
  8:Result:=Result+'�������� ';
  9:Result:=Result+'���`������ ';
 end;
 if dig[5]<>1 then
  case dig[4] of
   1:begin
      Result:=Result+'���� ';
      t:='������ ';
     end;
   2:begin
      Result:=Result+'�� ';
      t:='������ ';
     end;
   3:begin
      Result:=Result+'��� ';
      t:='������ ';
     end;
   4:begin
      Result:=Result+'������ ';
      t:='������ ';
     end;
   5:Result:=Result+'�`��� ';
   6:Result:=Result+'����� ';
   7:Result:=Result+'�� ';
   8:Result:=Result+'��� ';
   9:Result:=Result+'���`��� ';
  end;
  if dig[6]+dig[5]+dig[4]>0 then Result:=Result+t;
//********************
 case dig[3] of
  1:Result:=Result+'��� ';
  2:Result:=Result+'���� ';
  3:Result:=Result+'������ ';
  4:Result:=Result+'��������� ';
  5:Result:=Result+'��`����� ';
  6:Result:=Result+'�������� ';
  7:Result:=Result+'����� ';
  8:Result:=Result+'������ ';
  9:Result:=Result+'���`������ ';
 end;
 case dig[2] of
  1:begin
     case dig[1] of
      0:Result:=Result+'������ ';
      1:Result:=Result+'���������� ';
      2:Result:=Result+'���������� ';
      3:Result:=Result+'���������� ';
      4:Result:=Result+'������������ ';
      5:Result:=Result+'�`��������� ';
      6:Result:=Result+'����������� ';
      7:Result:=Result+'��������� ';
      8:Result:=Result+'���������� ';
      9:Result:=Result+'���`��������� ';
     end;
    end;
  2:Result:=Result+'�������� ';
  3:Result:=Result+'�������� ';
  4:Result:=Result+'����� ';
  5:Result:=Result+'�`������� ';
  6:Result:=Result+'��������� ';
  7:Result:=Result+'������� ';
  8:Result:=Result+'�������� ';
  9:Result:=Result+'���`������ ';
 end;
 if dig[2]<>1 then
  case dig[1] of
   1:Result:=Result+'���� ';
   2:Result:=Result+'�� ';
   3:Result:=Result+'��� ';
   4:Result:=Result+'������ ';
   5:Result:=Result+'�`��� ';
   6:Result:=Result+'����� ';
   7:Result:=Result+'�� ';
   8:Result:=Result+'��� ';
   9:Result:=Result+'���`��� ';
  end;
 Result:=AnsiUpperCase(Copy(Result,1,1))+Copy(Result,2,255);
end;

function MonthToString(Value:integer;RodPad:boolean):string;
begin
 Result:='';
 if RodPad then
  case Value of
   1:Result:='������';
   2:Result:='�������';
   3:Result:='�����';
   4:Result:='������';
   5:Result:='���';
   6:Result:='����';
   7:Result:='����';
   8:Result:='�������';
   9:Result:='��������';
  10:Result:='�������';
  11:Result:='������';
  12:Result:='�������';
  end
 else
  case Value of
   1:Result:='������';
   2:Result:='�������';
   3:Result:='����';
   4:Result:='������';
   5:Result:='���';
   6:Result:='����';
   7:Result:='����';
   8:Result:='������';
   9:Result:='��������';
  10:Result:='�������';
  11:Result:='������';
  12:Result:='�������';
  end;
end;
function MonthToStringUkr(Value:integer;RodPad:boolean):string;
begin
 Result:='';
 if RodPad then
  case Value of
   1:Result:='����';
   2:Result:='������';
   3:Result:='�������';
   4:Result:='�����';
   5:Result:='������';
   6:Result:='������';
   7:Result:='�����';
   8:Result:='������';
   9:Result:='�������';
  10:Result:='������';
  11:Result:='���������';
  12:Result:='������';
  end
 else
  case Value of
   1:Result:='�����';
   2:Result:='�����';
   3:Result:='��������';
   4:Result:='������';
   5:Result:='�������';
   6:Result:='�������';
   7:Result:='������';
   8:Result:='�������';
   9:Result:='��������';
  10:Result:='�������';
  11:Result:='��������';
  12:Result:='�������';
  end;
end;

end.
