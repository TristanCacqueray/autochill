let config = ./src/config.dhall

in  { name = "autochill"
    , domain = "tristancacqueray.github.io"
    , description = "Help you chill by setting up breath time"
    , version = 0.1
    , url = "https://github.com/TristanCacqueray/autochill"
    , options =
      [ config.intOption "duration" 45
      , config.intOption "work-temp" 3500
      , config.intOption "chill-temp" 3000
      , config.floatOption "cutoff" 0.8
      , config.floatOption "slope" 18.3
      ]
    }
