CLASS zcl_GE289409_generate_data DEFINITION
PUBLIC
FINAL
CREATE PUBLIC .

PUBLIC SECTION.
INTERFACES if_oo_adt_classrun.

PROTECTED SECTION.
PRIVATE SECTION.
METHODS: delete_demo_data.
METHODS: generate_demo_data.

ENDCLASS.

CLASS zcl_GE289409_generate_data IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

delete_demo_data(  ).
out->write( 'Table entries deleted' ).

generate_demo_data(  ).
out->write( 'Demo data was generated' ).

ENDMETHOD.

METHOD delete_demo_data.
DELETE FROM zGE289409.
COMMIT WORK.
ENDMETHOD.


METHOD generate_demo_data.
  DATA: demo_data_line  TYPE zge289409,
        demo_data       TYPE STANDARD TABLE OF zge289409,
        long_time_stamp TYPE timestampl,
        lv_index        TYPE i,
        lv_order_id     TYPE c LENGTH 8,
        lv_order_qty    TYPE c LENGTH 4.

  GET TIME STAMP FIELD long_time_stamp.

  DO 20 TIMES.
    CLEAR demo_data_line.

    lv_index = sy-index.

    demo_data_line-client     = sy-mandt.
    demo_data_line-order_uuid = xco_cp=>uuid( )->value.

    lv_order_id = |{ lv_index WIDTH = 8 PAD = '0' }|.
    demo_data_line-order_id = lv_order_id.

    demo_data_line-ordered_item = |HT-{ 1000 + lv_index }|.

    lv_order_qty = |{ lv_index WIDTH = 4 PAD = '0' }|.
    demo_data_line-order_quantity = lv_order_qty.

    demo_data_line-total_price = 10 * lv_index.
    demo_data_line-currency = 'EUR'.
    demo_data_line-requested_delivery_date = cl_abap_context_info=>get_system_date( ).
    demo_data_line-created_by = sy-uname.
    demo_data_line-created_at = long_time_stamp.
    demo_data_line-last_changed_by = sy-uname.
    demo_data_line-last_changed_at = long_time_stamp.
    demo_data_line-local_last_changed_at = long_time_stamp.

    APPEND demo_data_line TO demo_data.
  ENDDO.

  INSERT zge289409 FROM TABLE @demo_data.
  COMMIT WORK.
ENDMETHOD..

ENDCLASS.
