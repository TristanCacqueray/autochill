-- | The extension pref.js
module AutoChill.Prefs (main, init, buildPrefsWidget) where

import Prelude

import AutoChill.Settings (getSettings)
import AutoChill.PrefsWidget (mkPrefWidget)
import Effect (Effect)
import GJS as GJS
import Gtk4.Box (Box)

main :: Effect Unit
main = pure mempty

init :: Effect Unit
init = pure mempty

buildPrefsWidget :: Effect Box
buildPrefsWidget = do
  GJS.log "buildPrefsWidget called"
  settings <- getSettings
  mkPrefWidget settings
