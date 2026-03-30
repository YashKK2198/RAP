"!@testing ZR_BOOK000ZAC
CLASS ltc_zr_book000zac DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_zbook000zac TYPE STANDARD TABLE OF zbook000zac WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zr_book000zac WITH EMPTY KEY.
    DATA exp_results TYPE STANDARD TABLE OF zr_book000zac WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.

    "! In this method test data is inserted into the generated double(s) for test case
    "! "Calculate DISCOUNTEDPRICE field"
    METHODS td_calc_discountedprice_field.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "When price >= 140"
    METHODS td_price_ge_20.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "When price >= 50"
    METHODS td_price_ge_50.

    "! <strong>Test Case:</strong> Calculate DISCOUNTEDPRICE field <br><br>
    "! Test calculation of DISCOUNTEDPRICE field.
    "! <br><br> The results should be asserted with the actuals.
    METHODS calc_discountedprice_field FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> When price >= 140 <br><br>
    "! Test a CDS View when the CASE condition When price >= 140 is satisfied.
    "! <br><br> The results should be asserted with the actuals.
    METHODS price_ge_20 FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> When price >= 50 <br><br>
    "! Test a CDS View when the CASE condition When price >= 50 is satisfied.
    "! <br><br> The results should be asserted with the actuals.
    METHODS price_ge_50 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ZR_BOOK000ZAC IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZR_BOOK000ZAC' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD calc_discountedprice_field.
    td_calc_discountedprice_field( ).
    SELECT * FROM zr_book000zac INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-discountedprice act = act_results[ sy-tabix ]-discountedprice
      msg = 'Test Generated using AI: Expected result for field DISCOUNTEDPRICE is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_calc_discountedprice_field.
    " Prepare test data for 'ZBOOK000ZAC'
    td_zbook000zac = VALUE #(
      (
        client = '100'
        uuid = '0123456789ABCDEF'
        book_id = 'B0001'
        price = '60.00'
        price_curr = 'USD'
      ) ).
    environment->insert_test_data( i_data = td_zbook000zac ).

    " Prepare test data for 'zr_book000zac'
    exp_results = VALUE #(
      (
           uuid = '0123456789ABCDEF'
           bookid = 'B0001'
           price = '60.00'
           discountedprice = '42.00'
           pricecurr = 'USD'
      ) ).
  ENDMETHOD.



  METHOD price_ge_20.
    td_price_ge_20( ).
    SELECT * FROM zr_book000zac INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-discountedprice act = act_results[ sy-tabix ]-discountedprice
      msg = 'Test Generated using AI: Expected result for field DISCOUNTEDPRICE is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_price_ge_20.
    " Prepare test data for 'ZBOOK000ZAC'
    td_zbook000zac = VALUE #(
      (
        client = '100'
        uuid = '0000000000000001'
        price = '25'
        price_curr = 'USD'
      ) ).
    environment->insert_test_data( i_data = td_zbook000zac ).

    " Prepare test data for 'zr_book000zac'
    exp_results = VALUE #(
      (
           uuid = '0000000000000001'
           price = '25'
           discountedprice = '18.75'
           pricecurr = 'USD'
      ) ).
  ENDMETHOD.

  METHOD price_ge_50.
    td_price_ge_50( ).
    SELECT * FROM zr_book000zac INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-discountedprice act = act_results[ sy-tabix ]-discountedprice
      msg = 'Test Generated using AI: Expected result for field DISCOUNTEDPRICE is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_price_ge_50.
    " Prepare test data for 'ZBOOK000ZAC'
    td_zbook000zac = VALUE #(
      (
        client = '100'
        uuid = '0000000000000001'
        price = '100'
        price_curr = 'USD'
      ) ).
    environment->insert_test_data( i_data = td_zbook000zac ).

    " Prepare test data for 'zr_book000zac'
    exp_results = VALUE #(
      (
           uuid = '0000000000000001'
           price = '100'
           discountedprice = '70.00'
           pricecurr = 'USD'
      ) ).
  ENDMETHOD.

ENDCLASS.
