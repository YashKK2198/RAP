CLASS zcl_bookstore_sample_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS delete_demo_data.
    METHODS generate_demo_data.
ENDCLASS.


CLASS zcl_bookstore_sample_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    delete_demo_data( ).
    out->write( 'Book table entries deleted' ).

    generate_demo_data( ).
    out->write( 'Book demo data was generated' ).

  ENDMETHOD.


  METHOD delete_demo_data.
    DELETE FROM zbook000zac.
    COMMIT WORK.
  ENDMETHOD.


  METHOD generate_demo_data.
    DATA: ls_book           TYPE zbook000zac,
          lt_books          TYPE STANDARD TABLE OF zbook000zac,
          lv_index          TYPE i,
          lv_book_id        TYPE c LENGTH 10,
          lv_price          TYPE p LENGTH 8 DECIMALS 2,
          lv_discount_price TYPE p LENGTH 8 DECIMALS 2,
          lv_date           TYPE d,
          lv_timestamp      TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    DO 10 TIMES.
      CLEAR ls_book.

      lv_index = sy-index.

      ls_book-client = sy-mandt.
      ls_book-uuid   = xco_cp=>uuid( )->value.

      lv_book_id = |BOOK{ lv_index WIDTH = 3 PAD = '0' }|.
      ls_book-book_id = lv_book_id.

      ls_book-title  = |Sample Book { lv_index }|.
      ls_book-genre  = |Genre { lv_index }|.
      ls_book-author = |Author { lv_index }|.

      lv_price = 15 * lv_index.
      ls_book-price = lv_price.

      lv_date = cl_abap_context_info=>get_system_date( ) - lv_index.
      ls_book-published_date = lv_date.

      ls_book-stock = 100 - lv_index.

      lv_discount_price = lv_price * '0.90'.
      ls_book-discounted_price = lv_discount_price.

      ls_book-book_age = lv_index.

      ls_book-price_curr = 'USD'.

      ls_book-local_created_by      = sy-uname.
      ls_book-local_created_at      = lv_timestamp.
      ls_book-local_last_changed_by = sy-uname.
      ls_book-local_last_changed_at = lv_timestamp.
      ls_book-last_changed_at       = lv_timestamp.

      APPEND ls_book TO lt_books.
    ENDDO.

    INSERT zbook000zac FROM TABLE @lt_books.
    COMMIT WORK.
  ENDMETHOD.

ENDCLASS.
