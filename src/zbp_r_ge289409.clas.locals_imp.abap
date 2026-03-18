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
