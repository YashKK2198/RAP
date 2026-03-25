@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZbookstoreapplicationZAC', 
  Semantickey: [ 'BookID' ]
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_BOOK000ZAC
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_BOOK000ZAC
  association [1..1] to ZR_BOOK000ZAC as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  BookID,
  Title,
  Genre,
  Author,
  @Semantics: {
    Amount.Currencycode: 'PriceCurr'
  }
  Price,
  PublishedDate,
  Stock,
  @Semantics: {
    Amount.Currencycode: 'PriceCurr'
  }
  DiscountedPrice,
  BookAge,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  PriceCurr,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
