*CLASS lhc_main DEFINITION INHERITING FROM cl_abap_behavior_handler.
*
*  PRIVATE SECTION.
*
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR Main RESULT result.
*
*ENDCLASS.
*
*CLASS lhc_main IMPLEMENTATION.

*  METHOD get_instance_features.
*    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
*        ENTITY Main
*          ALL FIELDS
*          WITH CORRESPONDING #(  keys  )
*        RESULT DATA(lt_main).
*    IF sy-subrc EQ 0.
*    ENDIF.
*
*    result = VALUE #( FOR ls_main IN lt_main
*                        ( %tky    = ls_main-%tky
*                          %field-ProcessKey = COND #( WHEN ls_main-%is_draft = if_abap_behv=>fc-o-enabled
*                                                    THEN if_abap_behv=>fc-f-unrestricted
*                                                    ELSE if_abap_behv=>fc-f-unrestricted )
*                         ) ).
*  ENDMETHOD.
*
*ENDCLASS.

CLASS lhc_Singleton DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Singleton RESULT result.

ENDCLASS.

CLASS lhc_Singleton IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_ML_MAIN_LOCKSINGLETON_ DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_ML_MAIN_LOCKSINGLETON_ IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
