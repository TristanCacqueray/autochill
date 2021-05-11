module AutoChill.Worker where

import Prelude
import Effect (Effect)
import GLib as GLib
import GJS as GJS
import Gio.Settings as Settings

autoChillWorker :: Settings.Settings -> Effect GLib.EventSourceId
autoChillWorker settings = do
  GLib.timeoutAdd 1000 go
  where
    go = do
      GJS.log "Running..."
      v <- Settings.get_int settings "duration"
      GJS.log $ "to: " <> show v
      pure true
