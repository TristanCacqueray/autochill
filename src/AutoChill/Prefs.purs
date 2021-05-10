module AutoChill.Prefs where

import Prelude
import Effect (Effect)
import GJS as GJS

main :: Effect Unit
main = do
  GJS.log "Showing preferences"
