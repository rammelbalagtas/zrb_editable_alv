@EndUserText.label: 'Projection view for Z_I_PCI_ML_LIST_S'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['ProcessSeq']
define view entity Z_C_PCI_ML_LIST_S as projection on Z_i_pci_ml_list_s
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
    _Main : redirected to parent Z_C_PCI_ML_MAIN_S,
    _MainLockSingleton : redirected to Z_C_ML_MAIN_LOCKSINGLETON_S
}
