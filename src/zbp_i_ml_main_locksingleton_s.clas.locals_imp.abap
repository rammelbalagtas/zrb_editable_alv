CLASS lhc_main DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateScriptId FOR VALIDATE ON SAVE
      IMPORTING keys FOR Main~validateScriptId.

ENDCLASS.

CLASS lhc_main IMPLEMENTATION.

  METHOD validateScriptId.
    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
        ENTITY Main
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_main).

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY Main BY \_MainLockSingleton
        FROM CORRESPONDING #( lt_main )
      LINK DATA(main_singleton_links).

    LOOP AT lt_main INTO DATA(ls_main).
      APPEND VALUE #(  %tky        = ls_main-%tky
                        %state_area = 'VALIDATE_SCRIPTID'
                     ) TO reported-main.

      IF ls_main-ScriptId IS INITIAL.
        APPEND VALUE #( %tky = ls_main-%tky ) TO failed-main.
        APPEND VALUE #( %tky = ls_main-%tky
                        %state_area         = 'VALIDATE_SCRIPTID'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Script ID is mandatory' )
                        %path = VALUE #( singleton-%tky  = main_singleton_links[ KEY id source-%tky = ls_main-%tky ]-target-%tky )
                        %element-ScriptId   = if_abap_behv=>mk-on
                       ) TO reported-main.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_list DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateSapAddress FOR VALIDATE ON SAVE
      IMPORTING keys FOR List~validateSapAddress.
    METHODS onModifySendToSap FOR DETERMINE ON MODIFY
      IMPORTING keys FOR List~onModifySendToSap.
    METHODS onModifySendToSmtp FOR DETERMINE ON MODIFY
      IMPORTING keys FOR List~onModifySendToSmtp.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR List RESULT result.
    METHODS validatesmtpaddress FOR VALIDATE ON SAVE
      IMPORTING keys FOR list~validatesmtpaddress.

ENDCLASS.

CLASS lhc_list IMPLEMENTATION.

  METHOD validateSapAddress.
    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
          ENTITY List
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_list).

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List BY \_Main
        FROM CORRESPONDING #( lt_list )
      LINK DATA(list_main_links).

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List BY \_MainLockSingleton
        FROM CORRESPONDING #( lt_list )
      LINK DATA(list_singleton_links).

    LOOP AT lt_list INTO DATA(ls_list).
      APPEND VALUE #(  %tky        = ls_list-%tky
                        %state_area = 'VALIDATE_SAPADDRESS'
                     ) TO reported-list.

      IF ls_list-SendToSap IS NOT INITIAL AND
          ls_list-SapAddress IS INITIAL.
        APPEND VALUE #( %tky = ls_list-%tky ) TO failed-list.
        APPEND VALUE #( %tky = ls_list-%tky
                        %state_area         = 'VALIDATE_SAPADDRESS'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Enter a user ID' )
                        %path = VALUE #( main-%tky = list_main_links[ KEY id  source-%tky = ls_list-%tky ]-target-%tky
                                         singleton-%tky  = list_singleton_links[ KEY id source-%tky = ls_list-%tky ]-target-%tky )
                        %element-SapAddress   = if_abap_behv=>mk-on
                       ) TO reported-list.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD onModifySendToSap.

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_list).

    MODIFY ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
       ENTITY List
         UPDATE
           FIELDS ( SapAddress SmtpAddress )
           WITH VALUE #( FOR list IN lt_list
                           ( %tky                 = list-%tky
                             SapAddress           = ''
                             SmtpAddress          = ''
*                             SendToSmtp           = abap_false
                             %control-SapAddress = if_abap_behv=>mk-on
                             %control-SmtpAddress = if_abap_behv=>mk-on ) )
       MAPPED DATA(upd_mapped)
       FAILED DATA(upd_failed)
       REPORTED DATA(upd_reported).

  ENDMETHOD.

  METHOD onModifySendToSmtp.

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_list).

    MODIFY ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
       ENTITY List
         UPDATE
           FIELDS ( SapAddress SmtpAddress )
           WITH VALUE #( FOR list IN lt_list
                           ( %tky                 = list-%tky
                             SapAddress           = ''
                             SmtpAddress          = ''
*                             SendToSap            = abap_false
                             %control-SapAddress = if_abap_behv=>mk-on
                             %control-SmtpAddress = if_abap_behv=>mk-on ) )
       MAPPED DATA(upd_mapped)
       FAILED DATA(upd_failed)
       REPORTED DATA(upd_reported).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
        ENTITY List
          FIELDS ( SendToSap SendToSMTP )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_list)
        FAILED failed.

    result = VALUE #( FOR ls_list IN lt_list
                      ( %tky      = ls_list-%tky
                        %field-SapAddress = COND #( WHEN ls_list-SendToSap = abap_true
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )
                        %field-SmtpAddress = COND #( WHEN ls_list-SendToSMTP = abap_true
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )
                        %field-SendToSap = COND #( WHEN ls_list-SendToSap = abap_false AND ls_list-SendToSmtp = abap_false
                                                   THEN if_abap_behv=>fc-f-unrestricted
                                                   WHEN ls_list-SendToSap = abap_true AND ls_list-SendToSmtp = abap_false
                                                   THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                        %field-SendToSMTP = COND #( WHEN ls_list-SendToSap = abap_false AND ls_list-SendToSmtp = abap_false
                                                   THEN if_abap_behv=>fc-f-unrestricted
                                                   WHEN ls_list-SendToSap = abap_false AND ls_list-SendToSmtp = abap_true
                                                   THEN if_abap_behv=>fc-f-unrestricted
                                                   ELSE if_abap_behv=>fc-f-read_only )
                       ) ).
  ENDMETHOD.

  METHOD validateSmtpAddress.
    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
          ENTITY List
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_list).

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List BY \_Main
        FROM CORRESPONDING #( lt_list )
      LINK DATA(list_main_links).

    READ ENTITIES OF Z_I_ML_MAIN_LockSingleton_S IN LOCAL MODE
      ENTITY List BY \_MainLockSingleton
        FROM CORRESPONDING #( lt_list )
      LINK DATA(list_singleton_links).

    LOOP AT lt_list INTO DATA(ls_list).
      APPEND VALUE #(  %tky        = ls_list-%tky
                        %state_area = 'VALIDATE_SMTPADDRESS'
                     ) TO reported-list.

      IF ls_list-SendToSmtp IS NOT INITIAL AND
         ls_list-SmtpAddress IS INITIAL.
        APPEND VALUE #( %tky = ls_list-%tky ) TO failed-list.
        APPEND VALUE #( %tky = ls_list-%tky
                        %state_area         = 'VALIDATE_SMTPADDRESS'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Enter an email address' )
                        %path = VALUE #( main-%tky = list_main_links[ KEY id  source-%tky = ls_list-%tky ]-target-%tky
                                         singleton-%tky  = list_singleton_links[ KEY id source-%tky = ls_list-%tky ]-target-%tky )
                        %element-SmtpAddress   = if_abap_behv=>mk-on
                       ) TO reported-list.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

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
