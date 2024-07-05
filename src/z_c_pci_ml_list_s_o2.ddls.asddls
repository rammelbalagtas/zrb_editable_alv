@EndUserText.label: 'projection for Z_I_PCI_ML_LIST_S_O2'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity Z_C_PCI_ML_LIST_S_O2
  as projection on Z_i_pci_ml_list_s_o2
{
  key ProcessKey,
  key ProcessSeq,
      @Consumption.hidden: true
      SingletonID,
      SendToSap,
      SapAddress,
      SendToSmtp,
      SmtpAddress,
      Express,
      Copy,
      Blindcopy,
      LocalLastChangedAt,
      /* Associations */
      _Main              : redirected to parent Z_C_PCI_ML_MAIN_S_O2,
      _MainLockSingleton : redirected to Z_C_ML_MAIN_LOCKSINGLETON_S_O2
}
