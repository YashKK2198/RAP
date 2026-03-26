CLASS lhc_zr_book000zac DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
          REQUEST requested_authorizations FOR Book
        RESULT result,

      validateTitle FOR VALIDATE ON SAVE
        IMPORTING keys FOR Book~validateTitle.
ENDCLASS.

CLASS lhc_zr_book000zac IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateTitle.

    READ ENTITIES OF ZR_BOOK000ZAC IN LOCAL MODE
      ENTITY Book
        FIELDS ( Title )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_book).

    LOOP AT lt_book INTO DATA(ls_book).

      APPEND VALUE #(
        %tky        = ls_book-%tky
        %state_area = 'VALIDATE_TITLE'
      ) TO reported-book.

      IF ls_book-Title IS INITIAL.
        APPEND VALUE #(
          %tky = ls_book-%tky
        ) TO failed-book.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
