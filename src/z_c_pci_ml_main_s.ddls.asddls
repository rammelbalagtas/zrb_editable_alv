@EndUserText.label: 'Projection view for Z_I_PCI_ML_MAIN_S'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.semanticKey: ['ProcessKey']
define view entity Z_C_PCI_ML_MAIN_S as projection on Z_I_PCI_ML_MAIN_S
{
    key ProcessKey,
    @Consumption.hidden: true
    SingletonID,
    ScriptId,
    ProcessDesc,
    LocalLastChangedAt,
    /* Associations */
    _List : redirected to composition child Z_C_PCI_ML_LIST_S,
    _MainLockSingleton : redirected to parent Z_C_ML_MAIN_LOCKSINGLETON_S
}
