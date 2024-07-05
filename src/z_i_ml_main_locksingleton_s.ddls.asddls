@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PCI ML Main Singleton Root View'
define root view entity Z_I_ML_MAIN_LockSingleton_S
  as select from    I_Language
    left outer join zpci_ml_main as main on 0 = 0
  composition [0..*] of Z_I_PCI_ML_MAIN_S as _Main

{
  key cast( 'PCI Mail' as abap.char(50)  ) as SingletonID,
      max (main.last_changed_at) as LastChangedAtMax,
      _Main
}

where
  I_Language.Language = $session.system_language
