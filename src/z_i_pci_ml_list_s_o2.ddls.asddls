@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for Z_I_PCI_ML_LIST_O2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_i_pci_ml_list_s_o2
  as select from Z_I_PCI_ML_LIST_O2
  association [1..1] to Z_I_ML_MAIN_LockSingleton_S_O2 as _MainLockSingleton on $projection.SingletonID = _MainLockSingleton.SingletonID
  association to parent Z_I_PCI_ML_MAIN_S_O2 as _Main on $projection.ProcessKey = _Main.ProcessKey
{
  key ProcessKey,
  key ProcessSeq,
  cast( 'PCI Mail' as abap.char(50)  ) as SingletonID,
      SendToSap,
      SapAddress,
      SendToSmtp,
      SmtpAddress,
      Express,
      Copy,
      Blindcopy,
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
      /* Associations */
      _MainLockSingleton,
      _Main
}
