inherited MlekoDbDsMSSQLDm: TMlekoDbDsMSSQLDm
  Left = 338
  Top = 134
  Height = 469
  Width = 781
  inherited DBDev: TMSConnection
    Options.Provider = prSQL
    Password = '3#_KVAZAR@'
    Server = 'SIRIUS\KVAZAR'
    Connected = True
    Left = 136
  end
  object quDSPEC: TMSQuery
    SQLInsert.Strings = (
      'declare @Res Int'
      '       ,@l_qty dtQty'
      ''
      'set @l_qty= :qty'
      ''
      'EXEC @Res = [work].dbo.pr_add_dspec '
      '    @p_ID = :ID out,'
      '    @p_ARTICLE_ID = :article_id,'
      '    @p_QTY = @l_qty,'
      '    @p_PRICE_ECO = :PRICE_ECO,'
      '    @p_DHEAD_ID = :dhead_id,'
      '    @p_qty_first = @l_qty,'
      '    @DateOfManufacture = :DateOfManufacture,'
      '    @Currency = :Currency,'
      '    @PaymentPrice = :PaymentPrice')
    SQLDelete.Strings = (
      'declare @Res Int'
      ''
      'EXEC @Res = pr_del_dspec @p_ID = :ID')
    SQLUpdate.Strings = (
      'declare @Res Int'
      ''
      'EXEC @Res= [work].dbo.PR_edit_DSPEC '
      '      @p_ID = :ID ,'
      '      @p_ORDER_NUM = NULL,'
      '      @p_ARTICLE_ID = :ARTICLE_ID,'
      '      @p_QTY = :QTY,'
      '      @p_PRICE_ECO = :PRICE_ECO,'
      '      @p_QTY_PAY = NULL,'
      '      @DateOfManufacture = :DateOfManufacture')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'SELECT '
      '       s.NaklNo,'
      '       tnp.No_pp,'
      '       s.order_num,'
      '       s.article_id,'
      '       s.qty,'
      '       round(s.PRICE_ECO,2) as PRICE_ECO,'
      '       s.PRICE_ECO_IN,'
      '       s.article_Name,'
      '       s.QTY_PAY,'
      '       s.vid_name,'
      '       s.Weight,'
      '       s.dhead_id,'
      '       s.ID,'
      '       s.vid_Name,'
      '       s.producer_name,'
      '       s.summa,'
      '       s.summa_no_nds,'
      '       s.dhead_id,  '
      '       s.DateOfManufacture,'
      '       s.Currency, '
      '       s.PaymentPrice'
      '  FROM V_DSPEC s left join '
      '       TovarNOPP tnp on tnp.TovarNo = s.article_id'
      ' WHERE s.DHEAD_ID = :DHEAD_ID'
      'ORDER BY &_order')
    BeforeUpdateExecute = quDSPECBeforeUpdateExecute
    AfterUpdateExecute = quDSPECAfterUpdateExecute
    AfterPost = quDSPECAfterPost
    Options.StrictUpdate = False
    MasterFields = 'pkey'
    Left = 26
    Top = 116
    ParamData = <
      item
        DataType = ftLargeint
        Name = 'DHEAD_ID'
        Value = -1
      end>
    MacroData = <
      item
        Name = '_order'
        Value = 'Order_Num'
      end>
    object quDSPECNaklNo: TIntegerField
      FieldName = 'NaklNo'
    end
    object quDSPECNo_pp: TIntegerField
      FieldName = 'No_pp'
    end
    object quDSPECorder_num: TSmallintField
      FieldName = 'order_num'
    end
    object quDSPECarticle_id: TSmallintField
      FieldName = 'article_id'
    end
    object quDSPECqty: TFloatField
      FieldName = 'qty'
    end
    object quDSPECPRICE_ECO: TFloatField
      FieldName = 'PRICE_ECO'
    end
    object quDSPECPRICE_ECO_IN: TFloatField
      FieldName = 'PRICE_ECO_IN'
    end
    object quDSPECarticle_Name: TStringField
      FieldName = 'article_Name'
      Size = 128
    end
    object quDSPECQTY_PAY: TFloatField
      FieldName = 'QTY_PAY'
    end
    object quDSPECvid_name: TStringField
      FieldName = 'vid_name'
      Size = 30
    end
    object quDSPECWeight: TFloatField
      FieldName = 'Weight'
    end
    object quDSPECdhead_id: TLargeintField
      FieldName = 'dhead_id'
    end
    object quDSPECID: TLargeintField
      FieldName = 'ID'
    end
    object quDSPECvid_Name_1: TStringField
      FieldName = 'vid_Name_1'
      Size = 30
    end
    object quDSPECproducer_name: TStringField
      FieldName = 'producer_name'
      Size = 30
    end
    object quDSPECsumma: TFloatField
      FieldName = 'summa'
      ReadOnly = True
    end
    object quDSPECsumma_no_nds: TFloatField
      FieldName = 'summa_no_nds'
      ReadOnly = True
    end
    object quDSPECdhead_id_1: TLargeintField
      FieldName = 'dhead_id_1'
    end
    object quDSPECDateOfManufacture: TDateTimeField
      FieldName = 'DateOfManufacture'
    end
    object quDSPECCurrency: TStringField
      DisplayLabel = #1042#1072#1083#1102#1090#1072' '#1087#1088#1072#1081#1089#1072
      FieldName = 'Currency'
      ReadOnly = True
      Size = 5
    end
    object quDSPECPaymentPrice: TFloatField
      DisplayLabel = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1072
      FieldName = 'PaymentPrice'
      ReadOnly = True
    end
  end
  object QuLAGGroup: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO L_ARTICLE_GROUP'
      '  ( ARTICLE_GROUP_ID, ARTICLE_ID, ACTIVE)'
      'VALUES'
      '  ( :ARTICLE_GROUP_ID, :ARTICLE_ID, :ACTIVE)')
    SQLDelete.Strings = (
      'DELETE FROM L_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE L_ARTICLE_GROUP'
      'SET'
      
        '   ARTICLE_GROUP_ID = :ARTICLE_GROUP_ID, ARTICLE_ID = :ARTICLE_I' +
        'D, ACTIVE = :ACTIVE'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT L_ARTICLE_GROUP.ID, L_ARTICLE_GROUP.ARTICLE_GROUP_ID, L_A' +
        'RTICLE_GROUP.ARTICLE_ID, L_ARTICLE_GROUP.ACTIVE FROM L_ARTICLE_G' +
        'ROUP'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select l.id'
      '       ,l.article_group_id'
      '       ,l.ACTIVE'
      '       ,g.NAME as GroupName'
      '       ,l.article_id'
      'from L_ARTICLE_GROUP l,D_ARTICLE_GROUP g'
      'where l.ARTICLE_GROUP_ID=g.ID'
      'order by g.Name')
    Options.StrictUpdate = False
    MasterSource = dsTovar
    MasterFields = 'TovarNo'
    DetailFields = 'article_id'
    Left = 634
    Top = 132
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TovarNo'
      end>
  end
  object QuPostArtGroupPriceType: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO L_POST_SET_ARTGROUP_PRICE'
      '  (COLNPRICE, POSTNO, SET_ARTICLE_GROUP_ID)'
      'VALUES'
      '  (:COLNPRICE, :POSTNO, :SET_ARTICLE_GROUP_ID)')
    SQLDelete.Strings = (
      'DELETE FROM L_POST_SET_ARTGROUP_PRICE'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE L_POST_SET_ARTGROUP_PRICE'
      'SET'
      
        '  COLNPRICE = :COLNPRICE, POSTNO = :POSTNO, SET_ARTICLE_GROUP_ID' +
        ' = :SET_ARTICLE_GROUP_ID'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT L_POST_SET_ARTGROUP_PRICE.ID, L_POST_SET_ARTGROUP_PRICE.C' +
        'OLNPRICE, L_POST_SET_ARTGROUP_PRICE.POSTNO, L_POST_SET_ARTGROUP_' +
        'PRICE.SET_ARTICLE_GROUP_ID FROM L_POST_SET_ARTGROUP_PRICE'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select l.id'
      '      ,l.SET_ARTICLE_GROUP_ID'
      
        '      ,(select name from D_SET_ARTICLE_GROUP where id=l.SET_ARTI' +
        'CLE_GROUP_ID) as SET_article_group_Name'
      '      ,l.PostNo'
      '      ,l.COLNPRICE'
      '      ,pt.ColName'
      'from L_POST_SET_ARTGROUP_PRICE l ,D_Price_type pt '
      'where l.COLNPRICE=pt.ColNPrice')
    Options.StrictUpdate = False
    MasterSource = dsPost
    MasterFields = 'PostNo'
    DetailFields = 'PostNo'
    Left = 58
    Top = 180
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PostNo'
      end>
  end
  object QuVidTovGroup: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO d_vidtov_group'
      '  (name)'
      'VALUES'
      '  (:name)'
      'SET :id = SCOPE_IDENTITY()')
    SQLDelete.Strings = (
      'DELETE FROM d_vidtov_group'
      'WHERE'
      '  id = :id')
    SQLUpdate.Strings = (
      'UPDATE d_vidtov_group'
      'SET'
      '  name = :name'
      'WHERE'
      '  id = :id')
    SQLRefresh.Strings = (
      'SELECT d_vidtov_group.name FROM d_vidtov_group'
      'WHERE'
      '  id = :id')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select id,name from d_vidtov_group')
    AfterPost = QuVidTovGroupAfterPost
    Options.StrictUpdate = False
    MasterFields = 'pkey'
    Left = 250
    Top = 4
  end
  object QuBuh: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select bt.buh,bt.Buh_type_name,bt.IS_FRACTION from d_buh_type bt')
    Options.StrictUpdate = False
    MasterFields = 'pkey'
    Left = 333
    Top = 4
  end
  object dsBuh: TDataSource
    DataSet = QuBuh
    Left = 335
    Top = 53
  end
  object dsVidTovGroup: TDataSource
    DataSet = QuVidTovGroup
    Left = 252
    Top = 53
  end
  object QuPostArtGroupDelayPay: TMSQuery
    SQLInsert.Strings = (
      'declare'
      '  @Cnt1 int'
      ' ,@Cnt2 int'
      ''
      'select @Cnt1 = count(*) '
      ' from L_POST_SET_ARTGROUP_DELAY'
      '  where SET_ARTICLE_GROUP_ID = :SET_ARTICLE_GROUP_ID'
      '    and POSTNO = :POSTNO'
      '    and BUH = :BUH'
      '    and Currency = :Currency'
      ''
      'if @Cnt1 = 0  '
      'INSERT INTO L_POST_SET_ARTGROUP_DELAY'
      
        '  (SET_ARTICLE_GROUP_ID, POSTNO, DAY_DELAY, DAY_DELAY_EXT, BUH, ' +
        'Currency)'
      'VALUES'
      
        '  (:SET_ARTICLE_GROUP_ID, :POSTNO, :DAY_DELAY, :DAY_DELAY_EXT, :' +
        'BUH, :Currency)'
      ''
      'select @Cnt2 = count(*) '
      ' from L_Post_Set_ArtGroup_PayBan'
      '  where SET_ARTICLE_GROUP_ID_PayBan = :SET_ARTICLE_GROUP_ID'
      '    and PostNo_PayBan = :POSTNO'
      '    and Buh = :BUH'
      '    and Currency = :Currency'
      ''
      'if @Cnt2 = 0'
      'insert into L_Post_Set_ArtGroup_PayBan'
      
        '  (PostNo_PayBan, SET_ARTICLE_GROUP_ID_PayBan, Buh, PayBan, Curr' +
        'ency) '
      'values'
      
        '  (:POSTNO, :SET_ARTICLE_GROUP_ID, :Buh, isnull(:PayBan,0), :Cur' +
        'rency)')
    SQLDelete.Strings = (
      'begin'
      'declare @ID dtFkey'
      ''
      'set @ID = :ID'
      ''
      
        'delete from d_post_delay_stop_control where L_POST_SET_DELAY_ID ' +
        '= @ID'
      ''
      'DELETE FROM L_POST_SET_ARTGROUP_DELAY WHERE  ID = @ID'
      ''
      'delete '
      ' from L_Post_Set_ArtGroup_PayBan '
      '  where SET_ARTICLE_GROUP_ID_PayBan = :SET_ARTICLE_GROUP_ID'
      '    and PostNo_PayBan = :POSTNO'
      '    and Buh = :Buh'
      '    and Currency = :Currency'
      ''
      'end')
    SQLUpdate.Strings = (
      'declare '
      '   @Cnt int'
      '  ,@Cnt1 int'
      ''
      'select @Cnt = count(*) '
      ' from L_Post_Set_ArtGroup_PayBan '
      '  where SET_ARTICLE_GROUP_ID_PayBan = :SET_ARTICLE_GROUP_ID'
      '    and PostNo_PayBan = :POSTNO'
      '    and Buh = :Buh'
      '    and Currency = :Currency'
      ''
      'select @Cnt1 = count(*) '
      ' from L_POST_SET_ARTGROUP_DELAY '
      '  where SET_ARTICLE_GROUP_ID = :SET_ARTICLE_GROUP_ID'
      '    and PostNo = :POSTNO'
      '    and Buh = :Buh'
      '    and Currency = :Currency'
      ''
      'if @Cnt1 > 0'
      'begin'
      '  UPDATE L_POST_SET_ARTGROUP_DELAY '
      '   SET  SET_ARTICLE_GROUP_ID = :SET_ARTICLE_GROUP_ID'
      '      , POSTNO = :POSTNO'
      '      , DAY_DELAY = :DAY_DELAY'
      '      , DAY_DELAY_EXT = :DAY_DELAY_EXT'
      '      , BUH = :BUH'
      '  WHERE ID = :ID'
      'end'
      'else'
      'begin'
      '  INSERT INTO L_POST_SET_ARTGROUP_DELAY'
      
        '    (SET_ARTICLE_GROUP_ID, POSTNO, DAY_DELAY, DAY_DELAY_EXT, BUH' +
        ', Currency)'
      '  VALUES'
      
        '    (:SET_ARTICLE_GROUP_ID, :POSTNO, :DAY_DELAY, :DAY_DELAY_EXT,' +
        ' :BUH, :Currency)'
      ''
      'end'
      ''
      'if @Cnt >0'
      'Begin'
      '  update L_Post_Set_ArtGroup_PayBan '
      '  set PayBan = :PayBan'
      '  where SET_ARTICLE_GROUP_ID_PayBan = :SET_ARTICLE_GROUP_ID'
      '    and PostNo_PayBan = :POSTNO'
      '    and Buh = :Buh '
      '    and Currency = :Currency'
      'End'
      'Else'
      'Begin'
      '  insert into L_Post_Set_ArtGroup_PayBan'
      
        '    (PostNo_PayBan, SET_ARTICLE_GROUP_ID_PayBan, Buh, PayBan, Cu' +
        'rrency) '
      '  values'
      '    (:PostNo, :SET_ARTICLE_GROUP_ID, :Buh, :PayBan, :Currency)'
      'End')
    SQLRefresh.Strings = (
      
        'SELECT L_POST_SET_ARTGROUP_DELAY.ID, L_POST_SET_ARTGROUP_DELAY.P' +
        'OSTNO, L_POST_SET_ARTGROUP_DELAY.DAY_DELAY, L_POST_SET_ARTGROUP_' +
        'DELAY.DAY_DELAY_EXT, L_POST_SET_ARTGROUP_DELAY.BUH, L_POST_SET_A' +
        'RTGROUP_DELAY.SET_ARTICLE_GROUP_ID, L_POST_SET_ARTGROUP_DELAY.Pa' +
        'yBan FROM L_POST_SET_ARTGROUP_DELAY'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      '/*'
      'select l.id'
      '      ,l.SET_ARTICLE_GROUP_ID'
      
        '      ,(select name from d_set_article_group where id=l.SET_ARTI' +
        'CLE_GROUP_ID) as set_article_group_Name'
      '      ,l.PostNo'
      '      ,l.Day_delay'
      '      ,l.Day_delay_ext'
      '      ,l.buh'
      
        '      ,(select Buh_type_name from d_buh_type t where t.buh=l.buh' +
        ') as buh_name'
      '      ,isnull (l.PayBan,0) as PayBan'
      'from L_POST_SET_ARTGROUP_DELAY l'
      '*/'
      ''
      'select l.id'
      '      ,l.SET_ARTICLE_GROUP_ID'
      
        '      ,(select name from d_set_article_group where id=l.SET_ARTI' +
        'CLE_GROUP_ID) as set_article_group_Name'
      '      ,l.PostNo'
      '      ,l.Day_delay'
      '      ,l.Day_delay_ext'
      '      ,l.buh'
      
        '      ,(select Buh_type_name from d_buh_type t where t.buh=l.buh' +
        ') as buh_name'
      '      ,isnull (lpb.PayBan,0) as PayBan'
      '      ,l.Currency'
      'from L_POST_SET_ARTGROUP_DELAY l left join'
      
        '     L_Post_Set_ArtGroup_PayBan lpb on (l.POSTNO = lpb.PostNo_Pa' +
        'yBan '
      
        '                                    and l.SET_ARTICLE_GROUP_ID =' +
        ' lpb.SET_ARTICLE_GROUP_ID_PayBan'
      '                                    and l.Buh = lpb.Buh'
      
        '                                    and l.Currency = lpb.Currenc' +
        'y)'
      ''
      ''
      '/*'
      'select l.id'
      '      ,l.SET_ARTICLE_GROUP_ID'
      
        '      ,(select name from d_set_article_group where id=l.SET_ARTI' +
        'CLE_GROUP_ID) as set_article_group_Name'
      '      ,l.PostNo'
      '      ,l.Day_delay'
      '      ,l.Day_delay_ext'
      '      ,l.buh'
      
        '      ,(select Buh_type_name from d_buh_type t where t.buh=l.buh' +
        ') as buh_name'
      'from L_POST_SET_ARTGROUP_DELAY l'
      '*/')
    Options.StrictUpdate = False
    MasterSource = dsPost
    MasterFields = 'PostNo'
    DetailFields = 'PostNo'
    Left = 60
    Top = 229
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PostNo'
      end>
    object QuPostArtGroupDelayPayid: TLargeintField
      FieldName = 'id'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.id'
    end
    object QuPostArtGroupDelayPaySET_ARTICLE_GROUP_ID: TLargeintField
      FieldName = 'SET_ARTICLE_GROUP_ID'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.SET_ARTICLE_GROUP_ID'
    end
    object QuPostArtGroupDelayPayset_article_group_Name: TStringField
      FieldName = 'set_article_group_Name'
      Origin = '.'
      ReadOnly = True
      Size = 512
    end
    object QuPostArtGroupDelayPayPostNo: TLargeintField
      FieldName = 'PostNo'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.PostNo'
    end
    object QuPostArtGroupDelayPayDay_delay: TIntegerField
      FieldName = 'Day_delay'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.Day_delay'
    end
    object QuPostArtGroupDelayPayDay_delay_ext: TIntegerField
      FieldName = 'Day_delay_ext'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.Day_delay_ext'
    end
    object QuPostArtGroupDelayPaybuh: TLargeintField
      FieldName = 'buh'
      Origin = 'L_POST_SET_ARTGROUP_DELAY.buh'
    end
    object QuPostArtGroupDelayPaybuh_name: TStringField
      FieldName = 'buh_name'
      Origin = '.'
      ReadOnly = True
    end
    object QuPostArtGroupDelayPayPayBan: TIntegerField
      FieldName = 'PayBan'
      Origin = '.'
      ReadOnly = True
    end
    object QuPostArtGroupDelayPayCurrency: TStringField
      DisplayLabel = #1042#1072#1083#1102#1090#1072
      DisplayWidth = 15
      FieldName = 'Currency'
      Size = 5
    end
  end
  object QuVidTov: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select VidNo,VidName'
      ' from vidtov'
      '  where Visible=0'
      'order by VidName')
    Options.StrictUpdate = False
    Left = 410
    Top = 4
  end
  object dsVidTov: TDataSource
    DataSet = QuVidTov
    Left = 412
    Top = 53
  end
  object QuArticleGroup: TMSQuery
    SQLInsert.Strings = (
      'if :id is not null'
      'INSERT INTO D_ARTICLE_GROUP'
      '  (Id, NAME, ACTIVE, PARENT_ID, CODE_NUM)'
      'VALUES'
      '  (:Id, :NAME, :ACTIVE, :PARENT_ID, :CODE_NUM)'
      'else '
      'INSERT INTO D_ARTICLE_GROUP'
      '  (NAME, ACTIVE, PARENT_ID, CODE_NUM)'
      'VALUES'
      '  (:NAME, :ACTIVE, :PARENT_ID, :CODE_NUM)')
    SQLDelete.Strings = (
      'DELETE FROM D_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE D_ARTICLE_GROUP'
      'SET'
      
        '  NAME = :NAME, ACTIVE = :ACTIVE, PARENT_ID = :PARENT_ID, CODE_N' +
        'UM = :CODE_NUM'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT D_ARTICLE_GROUP.ID, D_ARTICLE_GROUP.NAME, D_ARTICLE_GROUP' +
        '.ACTIVE, D_ARTICLE_GROUP.PARENT_ID, D_ARTICLE_GROUP.CODE_NUM FRO' +
        'M D_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select ag.*'
      'from D_ARTICLE_GROUP ag'
      'order by ag.NAME')
    Options.StrictUpdate = False
    Left = 370
    Top = 107
  end
  object dsArticleGroup: TDataSource
    DataSet = QuArticleGroup
    Left = 372
    Top = 156
  end
  object QuArticleGroupForSelect: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'Declare'
      '@CAN_SELECT_DELAY_PAY dtBool_Y_N'
      ',@CAN_SELECT_PRICE_TYPE dtBool_Y_N'
      ''
      'set @CAN_SELECT_DELAY_PAY = :CAN_SELECT_DELAY_PAY '
      'set @CAN_SELECT_PRICE_TYPE = :CAN_SELECT_PRICE_TYPE '
      ''
      'select ag.ID,ag.CODE_NUM,ag.NAME,ag.PARENT_ID,ag.ACTIVE'
      'from D_ARTICLE_GROUP ag'
      'where active='#39'Y'#39' '
      'and (CAN_SELECT_DELAY_PAY= @CAN_SELECT_DELAY_PAY'
      
        '     or @CAN_SELECT_DELAY_PAY is null or @CAN_SELECT_DELAY_PAY=-' +
        '1)'
      'and (CAN_SELECT_PRICE_TYPE = @CAN_SELECT_PRICE_TYPE'
      
        '     or @CAN_SELECT_PRICE_TYPE is null or @CAN_SELECT_PRICE_TYPE' +
        '=-1)')
    Options.StrictUpdate = False
    Left = 266
    Top = 108
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CAN_SELECT_DELAY_PAY'
      end
      item
        DataType = ftUnknown
        Name = 'CAN_SELECT_PRICE_TYPE'
      end>
  end
  object QuSetArticleGroup: TMSQuery
    SQLInsert.Strings = (
      'if :Id is not null'
      'INSERT INTO D_SET_ARTICLE_GROUP'
      '  (Id, NAME, ACTIVE)'
      'VALUES'
      '  (:Id, :NAME, :ACTIVE)'
      'else'
      'INSERT INTO D_SET_ARTICLE_GROUP'
      '  (NAME, ACTIVE)'
      'VALUES'
      '  (:NAME, :ACTIVE)')
    SQLDelete.Strings = (
      'DELETE FROM D_SET_ARTICLE_GROUP'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE D_SET_ARTICLE_GROUP'
      'SET'
      '  NAME = :NAME, ACTIVE = :ACTIVE'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT D_SET_ARTICLE_GROUP.ID, D_SET_ARTICLE_GROUP.NAME, D_SET_A' +
        'RTICLE_GROUP.ACTIVE FROM D_SET_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select ag.ID,ag.NAME,ag.ACTIVE'
      'from D_SET_ARTICLE_GROUP ag'
      'order by ag.NAME')
    Options.StrictUpdate = False
    Left = 458
    Top = 108
  end
  object dsSetArticleGroup: TDataSource
    DataSet = QuSetArticleGroup
    Left = 460
    Top = 157
  end
  object QuLSetArticleGroup: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO L_SET_ARTICLE_GROUP'
      '  (ARTICLE_GROUP_ID, SET_ARTICLE_GROUP_ID)'
      'VALUES'
      '  (:ARTICLE_GROUP_ID, :SET_ARTICLE_GROUP_ID)')
    SQLDelete.Strings = (
      'DELETE FROM L_SET_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE L_SET_ARTICLE_GROUP'
      'SET'
      
        ' ARTICLE_GROUP_ID = :ARTICLE_GROUP_ID, SET_ARTICLE_GROUP_ID = :S' +
        'ET_ARTICLE_GROUP_ID'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT L_SET_ARTICLE_GROUP.ID, L_SET_ARTICLE_GROUP.ARTICLE_GROUP' +
        '_ID, L_SET_ARTICLE_GROUP.SET_ARTICLE_GROUP_ID FROM L_SET_ARTICLE' +
        '_GROUP'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'declare'
      ' @SET_ARTICLE_GROUP_ID dtFkey'
      ''
      ' SET @SET_ARTICLE_GROUP_ID = :SET_ARTICLE_GROUP_ID'
      ''
      'select l.ID'
      '       ,l.ARTICLE_GROUP_ID'
      '       ,l.SET_ARTICLE_GROUP_ID'
      '       ,d.NAME as set_article_group_name'
      '       ,g.NAME as article_group_name'
      
        'from L_SET_ARTICLE_GROUP l,d_SET_ARTICLE_GROUP d,d_article_group' +
        ' g'
      'where l.article_group_id=g.id'
      '  and l.set_article_group_id=d.ID'
      
        '  and (l.SET_ARTICLE_GROUP_ID = @SET_ARTICLE_GROUP_ID or @SET_AR' +
        'TICLE_GROUP_ID=-1 or @SET_ARTICLE_GROUP_ID is null)')
    BeforePost = QuLSetArticleGroupBeforePost
    Options.StrictUpdate = False
    MasterSource = dsSetArticleGroup
    MasterFields = 'ID'
    DetailFields = 'SET_ARTICLE_GROUP_ID'
    Left = 138
    Top = 76
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SET_ARTICLE_GROUP_ID'
      end
      item
        DataType = ftUnknown
        Name = 'ID'
      end>
  end
  object dsArticleGroupForSelect: TDataSource
    DataSet = QuArticleGroupForSelect
    Left = 268
    Top = 157
  end
  object QuPriceType: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select * from d_price_type')
    Options.StrictUpdate = False
    MasterFields = 'pkey'
    Left = 485
    Top = 4
  end
  object dsPriceType: TDataSource
    DataSet = QuPriceType
    Left = 487
    Top = 53
  end
  object dsPost: TDataSource
    DataSet = quPost
    Left = 384
    Top = 240
  end
  object quPost: TMSQuery
    SQLInsert.Strings = (
      'begin'
      'declare @PostNo dtPkey'
      ''
      'select @PostNo=isnull(max(PostNo),0)+1 from Post'
      'set :PostNo = @PostNo'
      ''
      'insert into Post'
      
        '  (PostNo, Name, NameLong, SotrudNo, NoSvidNDS, CodeNDS, Town, A' +
        'ddress, '
      
        '   Phone, RS, MFO, NameBank, AddressBank, OKPO, DogovorNo, DateD' +
        'ogovor, '
      
        '   PrintPost, AccountCash, NotPlatNDS, Contact, RegionNo, Addres' +
        'sFact, '
      
        '   CategorName, MarschrutNo, DayDelay, Export1C, Change1C, Cod1C' +
        ', ID1C, '
      
        '   IDBank1C, Print3, Visible, VIP, Accept,PriceChange,TTN ,TTN_U' +
        'SE_Name ,TTN_Name)'
      'values'
      
        '  (@PostNo, :Name, :NameLong, :SotrudNo, :NoSvidNDS, :CodeNDS, :' +
        'Town, :Address, '
      
        '   :Phone, :RS, :MFO, :NameBank, :AddressBank, :OKPO, :DogovorNo' +
        ', '
      ':DateDogovor, '
      
        '   :PrintPost, :AccountCash, :NotPlatNDS, :Contact, :RegionNo, :' +
        'AddressFact, '
      
        '   :CategorName, :MarschrutNo, :DayDelay, :Export1C, :Change1C, ' +
        ':Cod1C, '
      
        '   :ID1C, :IDBank1C, :Print3, :Visible, :VIP, :Accept,:PriceChan' +
        'ge,:TTN, :TTN_USE_Name, :TTN_Name)'
      ''
      'end')
    SQLDelete.Strings = (
      'Update Post'
      'set Trash=1, visible=1'
      'where PostNo = :OLD_PostNo')
    SQLUpdate.Strings = (
      'declare '
      '@trash integer'
      'begin'
      'set @trash= :trash'
      'update Post'
      'set'
      '  Name = :Name,'
      '  NameLong = :NameLong,'
      '  SotrudNo = :SotrudNo,'
      '  NoSvidNDS = :NoSvidNDS,'
      '  CodeNDS = :CodeNDS,'
      '  Town = :Town,'
      '  Address = :Address,'
      '  Phone = :Phone,'
      '  RS = :RS,'
      '  MFO = :MFO,'
      '  NameBank = :NameBank,'
      '  AddressBank = :AddressBank,'
      '  OKPO = :OKPO,'
      '  DogovorNo = :DogovorNo,'
      '  DateDogovor = :DateDogovor,'
      '  PrintPost = :PrintPost,'
      '  AccountCash = :AccountCash,'
      '  NotPlatNDS = :NotPlatNDS,'
      '  Contact = :Contact,'
      '  RegionNo = :RegionNo,'
      '  AddressFact = :AddressFact,'
      '  CategorName = :CategorName,'
      '  MarschrutNo = :MarschrutNo,'
      '  DayDelay = :DayDelay,'
      '  Export1C = :Export1C,'
      '  Change1C = 1,'
      '  Cod1C = :Cod1C,'
      '  ID1C = :ID1C,'
      '  IDBank1C = :IDBank1C,'
      '  Print3 = :Print3,'
      '  Visible = case when @trash=1 then 1 else :Visible end,'
      '  VIP = :VIP,'
      '  Accept = :Accept,'
      '  PriceChange = :PriceChange,'
      '  TTN = :TTN,'
      '  TTN_USE_Name = :TTN_USE_Name,'
      '  TTN_Name = :TTN_Name,'
      '  trash= @trash'
      ' '
      'where'
      '  PostNo = :OLD_PostNo'
      'end')
    SQLRefresh.Strings = (
      
        'SELECT Post.PostNo, Post.Name, Post.NameLong, Post.SotrudNo, Pos' +
        't.NoSvidNDS, Post.CodeNDS, Post.Town, Post.Address, Post.Phone, ' +
        'Post.RS, Post.MFO, Post.NameBank, Post.AddressBank, Post.OKPO, P' +
        'ost.DogovorNo, Post.DateDogovor, Post.PrintPost, Post.NotPlatNDS' +
        ', Post.Contact, Post.RegionNo, Post.CategorName, Post.AddressFac' +
        't, Post.MarschrutNo, Post.AddressNo, Post.DayDelay, Post.Account' +
        'Cash, Post.Export1C, Post.Change1C, Post.Cod1C, Post.ID1C, Post.' +
        'IDBank1C, Post.Print3, Post.Visible, Post.VIP, Post.CreateDate, ' +
        'Post.trash, Post.pkey FROM Post'
      'WHERE'
      '  PostNo = :PostNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select *'
      
        '     , (select Name from d_Trash where trash=p.Trash) as TrashNa' +
        'me'
      
        '     , (select distinct max (Expire_Date) from d_firm_contract w' +
        'here PostNo = p.PostNo) as Expire_Date'
      'from Post p'
      'where 1=1'
      ' &_fltProp '
      ' &_fltOurFirm '
      ' &_fltTrash '
      ' &_fltVisible '
      'order by &_order')
    BeforeUpdateExecute = quPostBeforeUpdateExecute
    AfterUpdateExecute = quPostAfterUpdateExecute
    RefreshOptions = [roAfterInsert, roAfterUpdate, roBeforeEdit]
    Options.StrictUpdate = False
    Left = 314
    Top = 242
    MacroData = <
      item
        Name = '_fltProp'
      end
      item
        Name = '_fltOurFirm'
      end
      item
        Name = '_fltTrash'
        Value = 'and trash=0'
      end
      item
        Name = '_fltVisible'
        Value = 'and visible=0'
      end
      item
        Name = '_order'
        Value = 'Name'
      end>
    object quPostPostNo: TSmallintField
      FieldName = 'PostNo'
    end
    object quPostName: TStringField
      FieldName = 'Name'
      Size = 30
    end
    object quPostNameLong: TStringField
      FieldName = 'NameLong'
      Size = 80
    end
    object quPostSotrudNo: TSmallintField
      FieldName = 'SotrudNo'
    end
    object quPostNoSvidNDS: TStringField
      FieldName = 'NoSvidNDS'
      Size = 16
    end
    object quPostCodeNDS: TStringField
      FieldName = 'CodeNDS'
      Size = 12
    end
    object quPostTown: TStringField
      FieldName = 'Town'
      Size = 15
    end
    object quPostAddress: TStringField
      FieldName = 'Address'
      Size = 60
    end
    object quPostPhone: TStringField
      FieldName = 'Phone'
      Size = 15
    end
    object quPostRS: TStringField
      FieldName = 'RS'
      Size = 14
    end
    object quPostMFO: TStringField
      FieldName = 'MFO'
      Size = 10
    end
    object quPostNameBank: TStringField
      FieldName = 'NameBank'
      Size = 40
    end
    object quPostAddressBank: TStringField
      FieldName = 'AddressBank'
      Size = 30
    end
    object quPostOKPO: TStringField
      FieldName = 'OKPO'
      Size = 10
    end
    object quPostDogovorNo: TStringField
      FieldName = 'DogovorNo'
    end
    object quPostDateDogovor: TDateTimeField
      FieldName = 'DateDogovor'
    end
    object quPostPrintPost: TBooleanField
      FieldName = 'PrintPost'
    end
    object quPostNotPlatNDS: TBooleanField
      FieldName = 'NotPlatNDS'
    end
    object quPostContact: TStringField
      FieldName = 'Contact'
      Size = 50
    end
    object quPostRegionNo: TWordField
      FieldName = 'RegionNo'
    end
    object quPostCategorName: TStringField
      FieldName = 'CategorName'
    end
    object quPostAddressFact: TStringField
      FieldName = 'AddressFact'
      Size = 50
    end
    object quPostMarschrutNo: TSmallintField
      FieldName = 'MarschrutNo'
    end
    object quPostAddressNo: TSmallintField
      FieldName = 'AddressNo'
    end
    object quPostDayDelay: TSmallintField
      FieldName = 'DayDelay'
    end
    object quPostAccountCash: TBooleanField
      FieldName = 'AccountCash'
    end
    object quPostExport1C: TBooleanField
      FieldName = 'Export1C'
    end
    object quPostChange1C: TBooleanField
      FieldName = 'Change1C'
    end
    object quPostCod1C: TStringField
      FieldName = 'Cod1C'
      Size = 5
    end
    object quPostID1C: TStringField
      FieldName = 'ID1C'
      Size = 6
    end
    object quPostIDBank1C: TStringField
      FieldName = 'IDBank1C'
      Size = 10
    end
    object quPostPrint3: TBooleanField
      FieldName = 'Print3'
    end
    object quPostVisible: TBooleanField
      FieldName = 'Visible'
    end
    object quPostVIP: TBooleanField
      FieldName = 'VIP'
    end
    object quPostCreateDate: TDateTimeField
      FieldName = 'CreateDate'
    end
    object quPosttrash: TSmallintField
      FieldName = 'trash'
    end
    object quPostpkey: TLargeintField
      FieldName = 'pkey'
    end
    object quPostAccept: TStringField
      FieldName = 'Accept'
      FixedChar = True
      Size = 1
    end
    object quPostPriceChange: TStringField
      FieldName = 'PriceChange'
      FixedChar = True
      Size = 1
    end
    object quPostTTN: TBooleanField
      FieldName = 'TTN'
    end
    object quPostTTN_USE_Name: TBooleanField
      FieldName = 'TTN_USE_Name'
    end
    object quPostTTN_Name: TStringField
      FieldName = 'TTN_Name'
      Size = 50
    end
    object quPostTrashName: TStringField
      FieldName = 'TrashName'
      ReadOnly = True
      Size = 128
    end
    object quPostExpire_Date: TDateTimeField
      DisplayLabel = #1047#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1082#1086#1085#1090#1088#1072#1082#1090#1072
      FieldName = 'Expire_Date'
      ReadOnly = True
    end
  end
  object QuTrash: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select * from d_trash')
    Left = 448
    Top = 240
  end
  object dsTrash: TDataSource
    DataSet = QuTrash
    Left = 504
    Top = 240
  end
  object quTovar: TMSQuery
    SQLInsert.Strings = (
      'begin'
      'declare @TovarNo dtFkey'
      ''
      'select @TovarNo = isnull(Max(TovarNo),0)+1 from Tovar'
      'set :TovarNo=@TovarNo'
      ''
      'INSERT INTO Tovar'
      
        '  (TovarNo, NameTovar, NameTovarShort, EdIzm, VidNo, Company, Co' +
        'mpanyNo, KolPerPak, SrokReal, Weight, TipNo, CodReport, Export1C' +
        ', Change1C, Cod1C, ID1C, OtdelNo, TaraNo, Visible, weight_packed' +
        ', barCode, is_weight, IsInternal, MinCarryover)'
      'VALUES'
      
        '  (@TovarNo, :NameTovar, :NameTovarShort, :EdIzm, :VidNo, :Compa' +
        'ny, :CompanyNo, :KolPerPak, :SrokReal, :Weight, :TipNo, :CodRepo' +
        'rt, :Export1C, :Change1C, :Cod1C, :ID1C, :OtdelNo, :TaraNo, :Vis' +
        'ible, :weight_packed, :barCode, :is_weight, :IsInternal, :MinCar' +
        'ryover)'
      ''
      'insert into PriceForVeb'
      '  (TovarNo, PriceVeb, PriceInInst)'
      'values'
      '  (@TovarNo,0,0)'
      'end')
    SQLDelete.Strings = (
      'DELETE FROM Tovar'
      'WHERE'
      '  TovarNo = :TovarNo'
      ''
      'delete from PriceForVeb'
      'where'
      '  TovarNo = :TovarNo')
    SQLUpdate.Strings = (
      'UPDATE Tovar'
      'SET'
      
        '  NameTovar = :NameTovar, NameTovarShort = :NameTovarShort, EdIz' +
        'm = :EdIzm, VidNo = :VidNo, Company = :Company, CompanyNo = :Com' +
        'panyNo, KolPerPak = :KolPerPak, SrokReal = :SrokReal, Weight = :' +
        'Weight, TipNo = :TipNo, CodReport = :CodReport, Export1C = :Expo' +
        'rt1C, Change1C = :Change1C, Cod1C = :Cod1C, ID1C = :ID1C, OtdelN' +
        'o = :OtdelNo, TaraNo = :TaraNo, Visible = :Visible, weight_packe' +
        'd = :weight_packed, barCode = :barCode, is_weight = :is_weight, ' +
        'pkey = :pkey, IsInternal = :IsInternal, MinCarryover = :MinCarry' +
        'over'
      'WHERE'
      '  TovarNo = :TovarNo')
    SQLRefresh.Strings = (
      
        'SELECT Tovar.TovarNo, Tovar.NameTovar, Tovar.NameTovarShort, Tov' +
        'ar.EdIzm, Tovar.VidNo, Tovar.Company, Tovar.CompanyNo, Tovar.Kol' +
        'PerPak, Tovar.SrokReal, Tovar.Weight, Tovar.TipNo, Tovar.CodRepo' +
        'rt, Tovar.Export1C, Tovar.Change1C, Tovar.Cod1C, Tovar.ID1C, Tov' +
        'ar.OtdelNo, Tovar.TaraNo, Tovar.Visible, Tovar.weight_packed, To' +
        'var.barCode, Tovar.is_weight, Tovar.pkey, Tovar.IsInternal FROM ' +
        'Tovar'
      'WHERE'
      '  TovarNo = :TovarNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'SELECT *'
      'FROM Tovar t'
      'WHERE 1=1'
      '&flt1')
    BeforeUpdateExecute = quTovarBeforeUpdateExecute
    AfterUpdateExecute = quTovarAfterUpdateExecute
    RefreshOptions = [roAfterInsert, roAfterUpdate, roBeforeEdit]
    Options.StrictUpdate = False
    Left = 584
    Top = 8
    MacroData = <
      item
        Name = 'flt1'
      end>
    object quTovarTovarNo: TIntegerField
      FieldName = 'TovarNo'
    end
    object quTovarNameTovar: TStringField
      FieldName = 'NameTovar'
      Size = 128
    end
    object quTovarNameTovarShort: TStringField
      FieldName = 'NameTovarShort'
      Size = 64
    end
    object quTovarEdIzm: TStringField
      FieldName = 'EdIzm'
      Size = 5
    end
    object quTovarVidNo: TSmallintField
      FieldName = 'VidNo'
    end
    object quTovarCompany: TStringField
      FieldName = 'Company'
      Size = 10
    end
    object quTovarCompanyNo: TSmallintField
      FieldName = 'CompanyNo'
    end
    object quTovarKolPerPak: TSmallintField
      FieldName = 'KolPerPak'
    end
    object quTovarSrokReal: TSmallintField
      FieldName = 'SrokReal'
    end
    object quTovarWeight: TFloatField
      FieldName = 'Weight'
    end
    object quTovarTipNo: TSmallintField
      FieldName = 'TipNo'
    end
    object quTovarCodReport: TStringField
      FieldName = 'CodReport'
    end
    object quTovarExport1C: TBooleanField
      FieldName = 'Export1C'
    end
    object quTovarChange1C: TBooleanField
      FieldName = 'Change1C'
    end
    object quTovarCod1C: TStringField
      FieldName = 'Cod1C'
      Size = 6
    end
    object quTovarID1C: TStringField
      FieldName = 'ID1C'
      Size = 6
    end
    object quTovarOtdelNo: TSmallintField
      FieldName = 'OtdelNo'
    end
    object quTovarTaraNo: TIntegerField
      FieldName = 'TaraNo'
    end
    object quTovarVisible: TBooleanField
      FieldName = 'Visible'
    end
    object quTovarweight_packed: TBooleanField
      FieldName = 'weight_packed'
    end
    object quTovarbarCode: TLargeintField
      FieldName = 'barCode'
    end
    object quTovaris_weight: TBooleanField
      FieldName = 'is_weight'
    end
    object quTovarpkey: TLargeintField
      FieldName = 'pkey'
    end
    object quTovarIsInternal: TBooleanField
      FieldName = 'IsInternal'
    end
    object quTovarMinCarryover: TFloatField
      FieldName = 'MinCarryover'
    end
  end
  object dsTovar: TDataSource
    DataSet = quTovar
    Left = 582
    Top = 58
  end
  object quTipTovara: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO TipTovara'
      '  (TipNo, TipName, Visible)'
      'VALUES'
      '  (:TipNo, :TipName, :Visible)')
    SQLDelete.Strings = (
      '/*'
      'DELETE FROM TipTovara'
      'WHERE'
      '  TipNo = :TipNo'
      '*/'
      'UPDATE TipTovara'
      'SET'
      '  Visible = 1'
      'WHERE'
      '  TipNo = :TipNo')
    SQLUpdate.Strings = (
      'UPDATE TipTovara'
      'SET'
      '  TipName = :TipName, Visible = :Visible'
      'WHERE'
      '  TipNo = :TipNo')
    SQLRefresh.Strings = (
      
        'SELECT TipTovara.TipNo, TipTovara.TipName, TipTovara.Visible FRO' +
        'M TipTovara'
      'WHERE'
      '  TipNo = :TipNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select TipNo'
      '      ,TipName'
      '      ,Visible'
      ' from TipTovara'
      'order by TipName')
    Left = 386
    Top = 308
  end
  object dsTipTovara: TDataSource
    DataSet = quTipTovara
    Left = 452
    Top = 370
  end
  object dsCompany: TDataSource
    DataSet = quCompany
    Left = 382
    Top = 370
  end
  object quCompany: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Company'
      '  (CompanyNo, NameCompany, PercentSalary, Visible)'
      'VALUES'
      '  (:CompanyNo, :NameCompany, :PercentSalary, :Visible)')
    SQLDelete.Strings = (
      'DELETE FROM Company'
      'WHERE'
      '  CompanyNo = :CompanyNo')
    SQLUpdate.Strings = (
      'UPDATE Company'
      'SET'
      
        '   NameCompany = :NameCompany, PercentSalary = :PercentSalary, V' +
        'isible = :Visible'
      'WHERE'
      '  CompanyNo = :CompanyNo')
    SQLRefresh.Strings = (
      
        'SELECT Company.CompanyNo, Company.NameCompany, Company.PercentSa' +
        'lary, Company.Visible FROM Company'
      'WHERE'
      '  CompanyNo = :CompanyNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select CompanyNo'
      '      ,NameCompany'
      '      ,PercentSalary'
      '      ,Visible'
      ' from Company'
      'order by NameCompany')
    Left = 314
    Top = 308
  end
  object QuVidOtdel: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO vidOtdel'
      
        '  (OtdelNo, OtdelName, manager_team_id, OtdelPostNo, pkey, new_o' +
        'tdel_no, area_id, brand_type_id)'
      'VALUES'
      
        '  (:OtdelNo, :OtdelName, :manager_team_id, :OtdelPostNo, :pkey, ' +
        ':new_otdel_no, :area_id, :brand_type_id)')
    SQLDelete.Strings = (
      'DELETE FROM vidOtdel'
      'WHERE'
      '  OtdelNo = :OtdelNo')
    SQLUpdate.Strings = (
      'UPDATE vidOtdel'
      'SET'
      
        ' OtdelName = :OtdelName, manager_team_id = :manager_team_id, Otd' +
        'elPostNo = :OtdelPostNo, pkey = :pkey, new_otdel_no = :new_otdel' +
        '_no, area_id = :area_id, brand_type_id = :brand_type_id'
      'WHERE'
      '  OtdelNo = :OtdelNo')
    SQLRefresh.Strings = (
      
        'SELECT vidOtdel.OtdelNo, vidOtdel.OtdelName, vidOtdel.manager_te' +
        'am_id, vidOtdel.OtdelPostNo, vidOtdel.pkey, vidOtdel.new_otdel_n' +
        'o, vidOtdel.area_id, vidOtdel.brand_type_id FROM vidOtdel'
      'WHERE'
      '  OtdelNo = :OtdelNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select *'
      ' from vidOtdel'
      'order by OtdelName')
    Options.StrictUpdate = False
    Left = 450
    Top = 308
  end
  object DsVidOtdel: TDataSource
    DataSet = QuVidOtdel
    Left = 508
    Top = 309
  end
  object QuTara: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO Tovar'
      
        '  (TovarNo, NameTovar, NameTovarShort, EdIzm, VidNo, Company, Co' +
        'mpanyNo, KolPerPak, SrokReal, Weight, TipNo, CodReport, Export1C' +
        ', Change1C, Cod1C, ID1C, OtdelNo, TaraNo, Visible, weight_packed' +
        ', barCode, is_weight, pkey)'
      'VALUES'
      
        '  (:TovarNo, :NameTovar, :NameTovarShort, :EdIzm, :VidNo, :Compa' +
        'ny, :CompanyNo, :KolPerPak, :SrokReal, :Weight, :TipNo, :CodRepo' +
        'rt, :Export1C, :Change1C, :Cod1C, :ID1C, :OtdelNo, :TaraNo, :Vis' +
        'ible, :weight_packed, :barCode, :is_weight, :pkey)')
    SQLDelete.Strings = (
      'DELETE FROM Tovar'
      'WHERE'
      '  TovarNo = :TovarNo')
    SQLUpdate.Strings = (
      'UPDATE Tovar'
      'SET'
      
        '  TovarNo = :TovarNo, NameTovar = :NameTovar, NameTovarShort = :' +
        'NameTovarShort, EdIzm = :EdIzm, VidNo = :VidNo, Company = :Compa' +
        'ny, CompanyNo = :CompanyNo, KolPerPak = :KolPerPak, SrokReal = :' +
        'SrokReal, Weight = :Weight, TipNo = :TipNo, CodReport = :CodRepo' +
        'rt, Export1C = :Export1C, Change1C = :Change1C, Cod1C = :Cod1C, ' +
        'ID1C = :ID1C, OtdelNo = :OtdelNo, TaraNo = :TaraNo, Visible = :V' +
        'isible, weight_packed = :weight_packed, barCode = :barCode, is_w' +
        'eight = :is_weight, pkey = :pkey'
      'WHERE'
      '  TovarNo = :TovarNo')
    SQLRefresh.Strings = (
      
        'SELECT Tovar.TovarNo, Tovar.NameTovar, Tovar.NameTovarShort, Tov' +
        'ar.EdIzm, Tovar.VidNo, Tovar.Company, Tovar.CompanyNo, Tovar.Kol' +
        'PerPak, Tovar.SrokReal, Tovar.Weight, Tovar.TipNo, Tovar.CodRepo' +
        'rt, Tovar.Export1C, Tovar.Change1C, Tovar.Cod1C, Tovar.ID1C, Tov' +
        'ar.OtdelNo, Tovar.TaraNo, Tovar.Visible, Tovar.weight_packed, To' +
        'var.barCode, Tovar.is_weight, Tovar.pkey FROM Tovar'
      'WHERE'
      '  TovarNo = :TovarNo')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'SELECT *'
      ' FROM Tovar'
      '  where OtdelNo=3'
      'order by NameTovar')
    CachedUpdates = True
    Left = 664
    Top = 8
  end
  object DsTara: TDataSource
    DataSet = QuTara
    Left = 662
    Top = 58
  end
  object QuLAGArticle: TMSQuery
    SQLInsert.Strings = (
      'INSERT INTO L_ARTICLE_GROUP'
      '  ( ARTICLE_GROUP_ID, ARTICLE_ID, ACTIVE)'
      'VALUES'
      '  ( :ARTICLE_GROUP_ID, :ARTICLE_ID, :ACTIVE)')
    SQLDelete.Strings = (
      'DELETE FROM L_ARTICLE_GROUP'
      'WHERE'
      '  ID = :ID')
    SQLUpdate.Strings = (
      'UPDATE L_ARTICLE_GROUP'
      'SET'
      
        '   ARTICLE_GROUP_ID = :ARTICLE_GROUP_ID, ARTICLE_ID = :ARTICLE_I' +
        'D, ACTIVE = :ACTIVE'
      'WHERE'
      '  ID = :ID')
    SQLRefresh.Strings = (
      
        'SELECT L_ARTICLE_GROUP.ID, L_ARTICLE_GROUP.ARTICLE_GROUP_ID, L_A' +
        'RTICLE_GROUP.ARTICLE_ID, L_ARTICLE_GROUP.ACTIVE FROM L_ARTICLE_G' +
        'ROUP'
      'WHERE'
      '  ID = :ID')
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select l.id'
      '       ,l.article_group_id'
      '       ,l.ACTIVE'
      '       ,l.ARTICLE_ID'
      '       ,t.NameTovar'
      'from L_ARTICLE_GROUP l,Tovar t'
      'where l.ARTICLE_ID=t.TovarNo'
      'order by t.NameTovar')
    Options.StrictUpdate = False
    MasterSource = dsArticleGroup
    MasterFields = 'ID'
    DetailFields = 'article_group_id'
    Left = 634
    Top = 188
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
      end>
  end
  object dsUsers: TMSDataSource
    DataSet = quUsers
    Left = 650
    Top = 304
  end
  object quUsers: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select *'
      ' from Users')
    Left = 624
    Top = 304
    object quUsersUserNo: TIntegerField
      FieldName = 'UserNo'
    end
    object quUsersUserName: TStringField
      FieldName = 'UserName'
    end
    object quUsersCodeAccess: TSmallintField
      FieldName = 'CodeAccess'
    end
    object quUsersPassword: TStringField
      FieldName = 'Password'
      Size = 8
    end
    object quUsersEditPost: TBooleanField
      FieldName = 'EditPost'
    end
    object quUsersFormWight: TIntegerField
      FieldName = 'FormWight'
    end
    object quUsersFormHeight: TIntegerField
      FieldName = 'FormHeight'
    end
    object quUsersFormLeft: TIntegerField
      FieldName = 'FormLeft'
    end
    object quUsersFormTop: TIntegerField
      FieldName = 'FormTop'
    end
    object quUsersSkin: TIntegerField
      FieldName = 'Skin'
    end
  end
  object quCurrency: TMSQuery
    Connection = dmDataModule.DB
    SQL.Strings = (
      'select *'
      ' from d_currency'
      'where 1=1')
    Options.StrictUpdate = False
    Left = 63
    Top = 296
    object quCurrencyID: TIntegerField
      DisplayLabel = #1063#1080#1089#1083#1086#1074#1086#1081' '#1082#1086#1076' '#1074#1072#1083#1102#1090#1099
      FieldName = 'ID'
    end
    object quCurrencyNAME: TStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1074#1072#1083#1102#1090#1099
      DisplayWidth = 30
      FieldName = 'NAME'
      Size = 100
    end
    object quCurrencyL_CODE: TStringField
      DisplayLabel = #1041#1091#1082#1074#1077#1085#1085#1099#1081' '#1082#1086#1076' '#1074#1072#1083#1102#1090#1099
      DisplayWidth = 11
      FieldName = 'L_CODE'
      Size = 3
    end
    object quCurrencySHORT_NAME: TStringField
      DisplayLabel = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      DisplayWidth = 15
      FieldName = 'SHORT_NAME'
      Size = 10
    end
    object quCurrencyIsDefault: TBooleanField
      DisplayLabel = 'V'
      DisplayWidth = 3
      FieldName = 'IsDefault'
    end
    object quCurrencyisTrash: TBooleanField
      FieldName = 'isTrash'
    end
    object quCurrencyisCrossCurrency: TBooleanField
      FieldName = 'isCrossCurrency'
    end
  end
  object dsCurrency: TMSDataSource
    DataSet = quCurrency
    Left = 32
    Top = 296
  end
end
