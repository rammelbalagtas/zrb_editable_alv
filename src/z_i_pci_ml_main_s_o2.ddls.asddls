@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for Z_I_PCI_ML_MAIN_O2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PCI_ML_MAIN_S_O2
  as select from Z_I_PCI_ML_MAIN_O2
  association to parent Z_I_ML_MAIN_LockSingleton_S_O2 as _MainLockSingleton on $projection.SingletonID = _MainLockSingleton.SingletonID
  composition [0..*] of Z_i_pci_ml_list_s_o2           as _List
{
  key ProcessKey,
      cast( 'PCI Mail' as abap.char(50)  ) as SingletonID,
      ScriptId,
      ProcessDesc,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      //local etag field --> odata etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      //total etag field
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      /* Associations and Compositions */
      _MainLockSingleton,
      _List
}
