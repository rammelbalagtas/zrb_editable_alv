CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZRBFIORIAPPMAINT'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'FioriAppMaintenance' table = 'ZFIORIAPPMAINT' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_FIORIAPPMAINTENANCE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR FioriAppMaintAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION FioriAppMaintAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR FioriAppMaintAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_FIORIAPPMAINTENANCE_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_FioriAppMaintenance_S IN LOCAL MODE
    ENTITY FioriAppMaintAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_FioriAppMaintenance = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_FioriAppMaintenance_S IN LOCAL MODE
      ENTITY FioriAppMaintAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_FioriAppMaintenance_S IN LOCAL MODE
      ENTITY FioriAppMaintAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_FIORIAPPMAINTENANCE_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_FIORIAPPMAINTENANCE_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_FIORIAPPMAINTENANCE DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR FioriAppMaintenance
        RESULT result,
      COPYFIORIAPPMAINTENANCE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION FioriAppMaintenance~CopyFioriAppMaintenance,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR FioriAppMaintenance
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR FioriAppMaintenance
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_FIORIAPPMAINTENANCE FOR FioriAppMaintenance~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_FIORIAPPMAINTENANCE IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYFIORIAPPMAINTENANCE.
    DATA new_FioriAppMaintenance TYPE TABLE FOR CREATE ZI_FioriAppMaintenance_S\_FioriAppMaintenance.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-FioriAppMaintenance = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_FioriAppMaintenance_S IN LOCAL MODE
      ENTITY FioriAppMaintenance
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_FioriAppMaintenance)
        FAILED DATA(read_failed).

    IF ref_FioriAppMaintenance IS NOT INITIAL.
      ASSIGN ref_FioriAppMaintenance[ 1 ] TO FIELD-SYMBOL(<ref_FioriAppMaintenance>).
      DATA(key) = keys[ KEY draft %TKY = <ref_FioriAppMaintenance>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_FioriAppMaintenance>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_FioriAppMaintenance>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_FioriAppMaintenance> EXCEPT
          SingletonID
          LocalCreatedBy
          LocalCreatedAt
          LocalLastChangedBy
          LocalLastChangedAt
          LastChangedAt
        ) ) )
      ) TO new_FioriAppMaintenance ASSIGNING FIELD-SYMBOL(<new_FioriAppMaintenance>).
      <new_FioriAppMaintenance>-%TARGET[ 1 ]-ProcessKey = key-%PARAM-ProcessKey.

      MODIFY ENTITIES OF ZI_FioriAppMaintenance_S IN LOCAL MODE
        ENTITY FioriAppMaintAll CREATE BY \_FioriAppMaintenance
        FIELDS (
                 ProcessKey
                 ScriptId
                 ProcessDesc
               ) WITH new_FioriAppMaintenance
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-FioriAppMaintenance = mapped_create-FioriAppMaintenance.
    ENDIF.

    INSERT LINES OF read_failed-FioriAppMaintenance INTO TABLE failed-FioriAppMaintenance.

    IF failed-FioriAppMaintenance IS INITIAL.
      reported-FioriAppMaintenance = VALUE #( FOR created IN mapped-FioriAppMaintenance (
                                                 %CID = created-%CID
                                                 %ACTION-CopyFioriAppMaintenance = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-FioriAppMaintAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-FioriAppMaintAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    result-%ACTION-CopyFioriAppMaintenance = if_abap_behv=>auth-allowed.
*    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_FIORIAPPMAINTENANCE' ID 'ACTVT' FIELD '02'.
*    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*                                  ELSE if_abap_behv=>auth-unauthorized ).
*    result-%ACTION-CopyFioriAppMaintenance = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
  ENDMETHOD.
ENDCLASS.
