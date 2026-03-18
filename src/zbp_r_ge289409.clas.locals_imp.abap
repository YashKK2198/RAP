CLASS lsc_zr_ge289409 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_ge289409 IMPLEMENTATION.

  METHOD save_modified.
    DATA : ShoppingCarts       TYPE STANDARD TABLE OF zGE289409,
           ShoppingCart        TYPE                   zGE289409,
           events_to_be_raised TYPE TABLE FOR EVENT zr_GE289409~statusUpdated.

    IF create-shoppingcart IS NOT INITIAL.
      LOOP AT create-shoppingcart INTO DATA(create_shoppingcart).
        IF create_shoppingcart-%control-OverallStatus = if_abap_behv=>mk-on
          " AND create_shoppingcart-OverallStatus = zbp_r_GE289409=>order_state-in_process.
          AND create_shoppingcart-OverallStatus = zbp_r_GE289409=>order_state-saved.
          zcl_GE289409_start_bgpf=>run_via_bgpf_tx_uncontrolled( i_rap_bo_key = create_shoppingcart-OrderUuid ).
        ENDIF.
      ENDLOOP.
    ENDIF.

    "the salesorder and the status is updated via BGPF
    IF update-shoppingcart IS NOT INITIAL.
      LOOP AT update-shoppingcart INTO DATA(update_shoppingcart).
        IF update_shoppingcart-%control-SalesOrderStatus = if_abap_behv=>mk-on.
          CLEAR events_to_be_raised.
          APPEND INITIAL LINE TO events_to_be_raised.
          events_to_be_raised[ 1 ] = CORRESPONDING #( update_shoppingcart ).
          RAISE ENTITY EVENT zr_GE289409~statusUpdated FROM events_to_be_raised.
        ENDIF.

        IF update_shoppingcart-%control-OverallStatus = if_abap_behv=>mk-on
          "AND update_shoppingcart-OverallStatus = zbp_r_GE289409=>order_state-in_process.
          AND update_shoppingcart-OverallStatus = zbp_r_GE289409=>order_state-saved.
          zcl_GE289409_start_bgpf=>run_via_bgpf_tx_uncontrolled( i_rap_bo_key = update_shoppingcart-OrderUuid ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_zr_ge289409 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ShoppingCart
        RESULT result,
      setStatusToNew FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ShoppingCart~setStatusToNew.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~calculateOrderID.

    METHODS setStatusToSaved FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~setStatusToSaved.
ENDCLASS.

CLASS lhc_zr_ge289409 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setStatusToNew.

    READ ENTITIES OF zr_ge289409 IN LOCAL MODE
      ENTITY ShoppingCart
        FIELDS ( OverallStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      MODIFY ENTITIES OF zr_ge289409 IN LOCAL MODE
        ENTITY ShoppingCart
          UPDATE FIELDS ( OverallStatus )
          WITH VALUE #(
            ( %tky = entity-%tky
              OverallStatus = zbp_r_GE289409=>order_state-new )
          ).
      APPEND VALUE #(
            %tky        = entity-%tky
            %state_area = 'Determination'
        ) TO reported-ShoppingCart.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculateOrderID.


    DATA: lv_count        TYPE i,
          lv_semantic_key TYPE string.

    " Count the number of entries in the table ZGE289409
    SELECT COUNT(*) FROM zGE289409 INTO @lv_count.

    " Calculate the semantic key based on the count
    lv_semantic_key = |SEM-{ lv_count + 1 }|.

    " Read the entities to be updated
    READ ENTITIES OF zr_GE289409 IN LOCAL MODE
      ENTITY ShoppingCart
        FIELDS ( OrderID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    " Update the OrderID with the calculated semantic key
    LOOP AT entities INTO DATA(entity).
      MODIFY ENTITIES OF zr_GE289409 IN LOCAL MODE
        ENTITY ShoppingCart
          UPDATE FIELDS ( OrderID )
          WITH VALUE #(
            ( %tky = entity-%tky
              OrderID = lv_semantic_key )
          ).
      APPEND VALUE #(
          %tky        = entity-%tky
          %state_area = 'Determination'
      ) TO reported-ShoppingCart.
    ENDLOOP.

  ENDMETHOD.



  METHOD setStatusToSaved.

    READ ENTITIES OF zr_GE289409 IN LOCAL MODE
      ENTITY ShoppingCart
        FIELDS ( OverallStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      MODIFY ENTITIES OF zr_GE289409 IN LOCAL MODE
        ENTITY ShoppingCart
          UPDATE FIELDS ( OverallStatus )
          WITH VALUE #(
            ( %tky = entity-%tky
              OverallStatus = zbp_r_GE289409=>order_state-saved )
          ).
      APPEND VALUE #(
          %tky        = entity-%tky
          %state_area = 'Determination'
      ) TO reported-ShoppingCart.
    ENDLOOP.



  ENDMETHOD.

ENDCLASS.
