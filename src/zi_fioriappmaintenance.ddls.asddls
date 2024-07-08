@EndUserText.label: 'Fiori app table maintenance'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZI_FioriAppMaintenance
  as select from zfioriappmaint
  association to parent ZI_FioriAppMaintenance_S as _FioriAppMaintAll on $projection.SingletonID = _FioriAppMaintAll.SingletonID
{
  key process_key as ProcessKey,
  script_id as ScriptId,
  process_desc as ProcessDesc,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _FioriAppMaintAll
  
}
