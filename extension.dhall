(env:PGS).Extension::{
, name = "autochill"
, module = "AutoChill"
, description = "Help you chill by setting up breath time"
, url = "https://github.com/TristanCacqueray/autochill"
, domain = "tristancacqueray.github.io"
, settings = Some
  [ (env:PGS).intSetting "duration" 45
  , (env:PGS).intSetting "work-temp" 3500
  , (env:PGS).intSetting "chill-temp" 3000
  , (env:PGS).floatSetting "cutoff" 0.8
  , (env:PGS).floatSetting "slope" 18.3
  ]
}
