@EndUserText.label: 'projection for Z_I_ML_MAIN_LOCKSINGLETON_S_O2'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity Z_C_ML_MAIN_LOCKSINGLETON_S_O2
  provider contract transactional_query
  as projection on Z_I_ML_MAIN_LockSingleton_S_O2
{
  key SingletonID,
      @Consumption.hidden:true
      LastChangedAtMax,
      /* Associations */
      _Main : redirected to composition child Z_C_PCI_ML_MAIN_S_O2
}
