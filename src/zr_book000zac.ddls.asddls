@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZbookstoreapplicationZAC'
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'BookID' ]
define root view entity ZR_BOOK000ZAC
  as select from ZBOOK000ZAC as Book
{
  key uuid as UUID,
  book_id as BookID,
  title as Title,
  genre as Genre,
  author as Author,
  @Semantics.amount.currencyCode: 'PriceCurr'
  price as Price,
  published_date as PublishedDate,
  stock as Stock,
  @Semantics.amount.currencyCode: 'PriceCurr'
  discounted_price as DiscountedPrice,
  book_age as BookAge,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  price_curr as PriceCurr,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
