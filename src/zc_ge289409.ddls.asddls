@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZGE289409'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_GE289409
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_GE289409
  association [1..1] to ZR_GE289409 as _BaseEntity on $projection.ORDERUUID = _BaseEntity.ORDERUUID
{
  key OrderUUID,
  OrderID,
  OrderedItem,
  OrderQuantity,
  RequestedDeliveryDate,
  @Semantics: {
    Amount.Currencycode: 'Currency'
  }
  TotalPrice,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  Currency,
  OverallStatus,
  SalesOrderStatus,
  Salesorder,
  BgpfStatus,
  BgpgProcessName,
  ManageSalesOrderUrl,
  Notes,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Lastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
