unit MlekoSelectPlatType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, MlekoForm,
  Dialogs, CFLMLKSelect, DBAccess, MsAccess, DB, COMPSQLBuilder,   ActnList, 
  citComponentProps, ExtCtrls, comp_TargetFilter_Panel, StdCtrls, ComCtrls,
  ToolWin, Grids, DBGrids, citDbGrid, MemDS;

type
  TMlekoSelectPlatTypeDlg = class(TCFLMLKSelectDlg)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MlekoSelectPlatTypeDlg: TMlekoSelectPlatTypeDlg;

implementation

{$R *.dfm}

initialization
 RegisterClass(TMlekoSelectPlatTypeDlg);

finalization
 UnRegisterClass(TMlekoSelectPlatTypeDlg);

end.
