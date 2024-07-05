@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for ZPCIML_LIST_O2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PCI_ML_LIST_O2 as select from zpciml_list_o2
{
    key process_key as ProcessKey,
    key process_seq as ProcessSeq,
    send_to_sap as SendToSap,
    sap_address as SapAddress,
    send_to_smtp as SendToSmtp,
    smtp_address as SmtpAddress,
    express as Express,
    copy as Copy,
    blindcopy as Blindcopy,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
}
