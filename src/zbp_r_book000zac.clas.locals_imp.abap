CLASS lhc_zr_book000zac DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
          REQUEST requested_authorizations FOR Book
        RESULT result,

      validateTitle FOR VALIDATE ON SAVE
        IMPORTING keys FOR Book~validateTitle,

      calculateBookAge FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Book~calculateBookAge.
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

  METHOD calculateBookAge.
  " calculate the age of a book based on its PublishedDate and store it.

  READ ENTITIES OF ZR_BOOK000ZAC IN LOCAL MODE
    ENTITY Book
      FIELDS ( PublishedDate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_book).

  DATA lt_update TYPE TABLE FOR UPDATE ZR_BOOK000ZAC.
  DATA lv_current_date TYPE d.
  DATA lv_current_year TYPE i.
  DATA lv_published_year TYPE i.
  DATA lv_age TYPE i.

  lv_current_date = cl_abap_context_info=>get_system_date( ).
  lv_current_year = CONV i( lv_current_date+0(4) ).

  LOOP AT lt_book INTO DATA(ls_book).

    APPEND VALUE #(
      %tky        = ls_book-%tky
      %state_area = 'CALCULATE_BOOK_AGE'
    ) TO reported-book.

    IF ls_book-PublishedDate IS NOT INITIAL.

      lv_published_year = CONV i( ls_book-PublishedDate+0(4) ).
      lv_age = lv_current_year - lv_published_year.

      APPEND VALUE #(
        %tky    = ls_book-%tky
        BookAge = lv_age
      ) TO lt_update.

    ENDIF.

  ENDLOOP.

  MODIFY ENTITIES OF ZR_BOOK000ZAC IN LOCAL MODE
    ENTITY Book
      UPDATE FIELDS ( BookAge )
      WITH lt_update.

ENDMETHOD.
ENDCLASS.
