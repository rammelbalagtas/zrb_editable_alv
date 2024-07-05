@EndUserText.label: 'Projection view for Z_I_ML_MAIN_LOCKSINGLETON_S'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions:true
@ObjectModel.semanticKey: ['SingletonID']
define root view entity Z_C_ML_MAIN_LOCKSINGLETON_S
  provider contract transactional_query
  as projection on Z_I_ML_MAIN_LockSingleton_S
{
  key SingletonID,
      @Consumption.hidden:true
      LastChangedAtMax,
      /* Associations */
      _Main : redirected to composition child Z_C_PCI_ML_MAIN_S
}
