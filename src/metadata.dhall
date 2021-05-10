let info =
      { name = "autochill"
      , description = "Help you chill by setting up breath time"
      , version = 1
      , url = "https://github.com/TristanCacqueray/autochill"
      }

let metadata =
      { uuid = "${info.name}@tristancacqueray.github.io"
      , name = info.name
      , description = info.description
      , version = info.version
      , shell-version = [ "40.0" ]
      , url = info.url
      }

in  { info, metadata }
