CLASS zcl_GE289409_product_api DEFINITION

 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
              RAISING
                cx_http_dest_provider_error
                cx_web_http_client_error
                /iwbep/cx_gateway.

    INTERFACES if_oo_adt_classrun .

    TYPES tys_a_clfn_product_type TYPE zsc_GE289409_api_product=>tys_a_clfn_product_type.
    TYPES tyt_a_clfn_product_type TYPE STANDARD TABLE OF tys_a_clfn_product_type WITH DEFAULT KEY.
    "! <p class="shorttext synchronized">Filter range for property PRODUCT.</p>
    TYPES tyt_range_product       TYPE RANGE OF tys_a_clfn_product_type-product.

    METHODS get_products
      IMPORTING
        it_range_product TYPE tyt_range_product
        i_top            TYPE i OPTIONAL
        i_skip           TYPE i OPTIONAL
      EXPORTING
        et_business_data TYPE zsc_GE289409_api_product=>tyt_a_clfn_product_type
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy.
    DATA use_mock_data TYPE abap_bool VALUE abap_true.

ENDCLASS.

CLASS zcl_GE289409_product_api IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA business_data TYPE zsc_GE289409_api_product=>tyt_a_clfn_product_type .
    DATA lt_range_product  TYPE tyt_range_product.

    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    ranges_table = VALUE #(
                                (  sign = 'I' option = 'EQ' low = 'MZ-TG-Y240' )
                                (  sign = 'I' option = 'BT' low = 'TG' high = 'TH' )
                              ).

    MOVE-CORRESPONDING ranges_table TO lt_range_product .

    TRY.
        get_products(
          EXPORTING
            it_range_product    = lt_range_product
            i_top               = 50
            i_skip              = 0
          IMPORTING
            et_business_data  = business_data
          ) .
        out->write( business_data ).
      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD get_products.

    IF use_mock_data = abap_true.
      et_business_data = VALUE #( ( Product = 'TG11'  )
                                  ( Product = 'TG12'  )
                                  ( Product = 'TG13'  )
                                  ( Product = 'TG15_not_exists' ) ).
      EXIT.
    ENDIF.

*    DATA read_products TYPE REF TO lcl_read_a_clfn_product.
*    read_products = NEW #( odata_client_proxy ).
*    et_business_data = read_products->execute( it_range_product = it_range_product
*                                               i_top            = i_top
*                                               i_skip           = i_skip ).
  ENDMETHOD.

  METHOD constructor.
    DATA http_client        TYPE REF TO if_web_http_client.
    DATA proxy_model_id     TYPE /iwbep/if_cp_runtime_types=>ty_proxy_model_id.

    proxy_model_id = to_upper( 'ZSC_GE289409_API_PRODUCT' ).

    DATA(http_destination) =
    cl_http_destination_provider=>create_by_cloud_destination( i_name       = 'S4HANA_ODATA_Products_ABAP_ReadOnly'
                                                               i_authn_mode = if_a4c_cp_service=>service_specific ).

    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    odata_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                                 proxy_model_id      = proxy_model_id
                                                                 proxy_model_version = '0001' )
                             io_http_client           = http_client
                             iv_relative_service_root = '' ).

  ENDMETHOD.

ENDCLASS.
