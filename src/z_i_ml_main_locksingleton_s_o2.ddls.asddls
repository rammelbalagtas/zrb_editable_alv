@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity for table maintenance'
define root view entity Z_I_ML_MAIN_LockSingleton_S_O2
  as select from    I_Language
    left outer join zpciml_main_o2 as main on 0 = 0
  composition [0..*] of Z_I_PCI_ML_MAIN_S_O2 as _Main

{
  key cast( 'PCI Mail' as abap.char(50)  ) as SingletonID,
      max (main.last_changed_at)           as LastChangedAtMax,
      _Main
}

where
  I_Language.Language = $session.system_language
