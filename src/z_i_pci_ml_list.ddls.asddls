@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PCI ML List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_i_pci_ml_list
  as select from zpci_ml_list
{
  key process_key           as ProcessKey,
  key process_seq           as ProcessSeq,
      send_to_sap           as SendToSap,
      sap_address           as SapAddress,
      send_to_smtp          as SendToSmtp,
      smtp_address          as SmtpAddress,
      express               as Express,
      copy                  as Copy,
      blindcopy             as Blindcopy,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
