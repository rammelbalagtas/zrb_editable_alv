@EndUserText.label: 'projection for Z_I_PCI_ML_MAIN_S_O2'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity Z_C_PCI_ML_MAIN_S_O2 as projection on Z_I_PCI_ML_MAIN_S_O2
{
    key ProcessKey,
    @Consumption.hidden: true
    SingletonID,
    ScriptId,
    ProcessDesc,
    LocalLastChangedAt,
    /* Associations */
    _List : redirected to composition child Z_C_PCI_ML_LIST_S_O2,
    _MainLockSingleton : redirected to parent Z_C_ML_MAIN_LOCKSINGLETON_S_O2
}
