�
 TENOCRTRAININGFORM 0�  TPF0TEnOCRTrainingFormEnOCRTrainingFormLeft4Top� WidthHeight�CaptionOCR TrainingColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterShowHint	OnCreate
FormCreatePixelsPerInchd
TextHeight TLabelOCRTrainingLabelLeftTopWidth=HeightCaption OCR Training/Testing && BarcodesFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelImageFileLabelLeftTop%Width-HeightCaption
Image file  TImagePreviewImageLefthTopWidth2HeightA  TEditImageFileEditLeft<Top"Width HeightHint1Name of image file that will be used for trainingTabOrder   TBitBtnImageFileBtnLeft>Top!WidthHeightHintSelect file to useTabOrderOnClickImageFileBtnClick
Glyph.Data
z  v  BMv      v   (                                        �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� UUUUUT�UUUUUWwuUUUUUNDUUUUUwwuP   �@UWwwwwwwUs333ND3���wu�u�p�C�_www_�u���s;����u��u����__w_Wu~����u����u����__w�Wu���{�������u�w���_ww�_Wu������������u���wwwU___wwwUW���UUUUW���UUUUUwwuUUUUUwwuUUUUUUUUUUUUUUUUUUUUMargin	NumGlyphsSpacing�	IsControl	  �TEnProWinFrameImgWinFrameTop� WidthHeight� AlignalBottomAnchorsakLeftakTopakRightakBottom TabOrder �TPanelSpeedBarPanelWidth  �TImageScrollBoxImageScrollBoxOnRubberbandChange)ImgWinFrameImageScrollBoxRubberbandChange  �
TStatusBar	StatusBarTop� Width   TMemoInfoMemoLeft�TopWidthuHeight� AnchorsakLeftakTopakRight BorderStylebsNoneColor	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.StylefsBold Lines.Strings
Top Gray 0
Bot Gray 0
WHRatio  0
Disjoint 0 
ParentFontReadOnly	TabOrder  TPageControlPageControlLeft Top@WidtheHeightp
ActivePageOCRTestingTabSheetStyle	tsButtonsTabOrder 	TTabSheetOCRTrainingTabSheetCaptionOCR Training TLabelConfigLabelLeftTopWidthHeightCaptionConfig  TLabelFontIDLabelLeftTopWidth#HeightCaptionFont ID  TLabelDisplayNumLabelLeft� TopWidth"HeightCaptionDisplay  TEditResultsFileEditLeft8TopWidth HeightHint$Output text file of training resultsTabOrder   TBitBtnResultsFileBtnLeft:Top WidthHeightHintSelect file to useTabOrderOnClickResultsFileBtnClick
Glyph.Data
z  v  BMv      v   (                                        �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� UUUUUT�UUUUUWwuUUUUUNDUUUUUwwuP   �@UWwwwwwwUs333ND3���wu�u�p�C�_www_�u���s;����u��u����__w_Wu~����u����u����__w�Wu���{�������u�w���_ww�_Wu������������u���wwwU___wwwUW���UUUUW���UUUUUwwuUUUUUwwuUUUUUUUUUUUUUUUUUUUUMargin	NumGlyphsSpacing�	IsControl	  TEdit
FontIDEditLeft8TopWidth1HeightHint+Code that represents font (user determined)TabOrder  TButtonStartOCRTrainingBtnLeftTop8WidthKHeightHint/Start processing the current image for trainingCaptionStart TrainingTabOrderOnClickStartOCRTrainingBtnClick  TUpDownDisplayNumUpDownLeftTopWidthHeight	AssociateDisplayEditMin Position TabOrderWrap  TEditDisplayEditLeft� TopWidth1HeightHint$Display training results item numberTabOrderText0OnChangeDisplayEditChange   	TTabSheetOCRTestingTabSheetCaptionOCR Testing
ImageIndex TLabelTestingConstraintsLabelLeftTopWidthAHeightCaptionCharset LimitsVisible  TLabel	MaskLabelLeft� TopWidthHeightCaptionMask  TLabel
ValueLabelLeftTTopWidth#HeightCaptionResults  TLabelOCRResultLabelLeftTopWidth+HeightCaption-EMPTY-  TLabel	ConfLabelLeftTTopWidth!HeightCaptionConf %  TButton
OCRTestBtnLeft� Top8WidthKHeightHint!Use the current image for testingCaption
Start TestTabOrder OnClickOCRTestBtnClick  	TCheckBoxAlphaCheckBoxLeftTopWidth9HeightCaptionA .. ZTabOrderVisible  	TCheckBoxNumericCheckBoxLeftTop"WidthIHeightCaption0 .. 9, - / .TabOrderVisible  TEditMaskEditLeft� Top Width� HeightHint%Single character that represents fontTabOrderOnChangeMaskEditChange  TEdit	ValueEditLeft|TopWidth� HeightHint%Single character that represents fontTabOrderOnChangeMaskEditChange  TEditConfEditLeft|Top Width)HeightHintPercent confidence thresholdTabOrderText99.00  	TComboBoxTypeOCRComboBoxLeft Top8Width� HeightStylecsDropDownList
ItemHeightTabOrderItems.StringsitoNone	itoCustom	itoNumberitoAlphaitoAlphaNumericitoMoneyitoDateitoFirstNameitoMiddleNameitoLastNameitoNameitoTFML
itoAddressitoCityitoState
itoZipCodeitoCSZitoSSNitoEMail
itoBarcodeitoHcfaICD9
itoHcfaPOS
itoHcfaTOS
itoHcfaCPT
itoHcfaModitoHcfaDiagitoHcfaUnits   	TCheckBoxSlowCheckBoxLeft� Top:Width9HeightCaptionSlowChecked	State	cbCheckedTabOrder   	TTabSheetBarcodeTestingTabSheetCaptionBarcode Testing
ImageIndex TLabelBarcodeResultLabelLeftTop*Width+HeightCaption-EMPTY-  TButtonBarcodeTestBtnLeftTopWidthKHeightHintRead selected barcodeCaption
Start TestTabOrder OnClickBarcodeTestBtnClick    TOpenDialogImageFileOpenDialogFilter*TIF file (*.tif)|*.tif|All files (*.*)|*.*OptionsofHideReadOnlyofNoChangeDirofFileMustExistofEnableSizing TitleOpen Image FileLeftHTop  TOpenDialogTextFileOpenDialogFilter+Text file (*.txt)|*.txt|All files (*.*)|*.*OptionsofHideReadOnlyofNoChangeDirofEnableSizing TitleOpen Text FileLeftdTop   