module AutoChill where

import Prelude
import Effect (Effect)
import GJS (log)
import GLib as GLib
import AutoChill.Worker
import AutoChill.Settings

type Env = Unit

create :: Effect Env
create = do
  log "Creating env"

disable :: Env -> Effect Unit
disable env = do
  log "disable called"

enable :: Env -> Effect Unit
enable env = do
  log "enable called"
  settings <- getSettings
  _ <- autoChillWorker settings
  log "enabled"


init :: Env -> Effect Unit
init env = do
  log "init called"
