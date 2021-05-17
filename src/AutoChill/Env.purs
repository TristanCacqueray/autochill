module AutoChill.Env (Env, createEnv) where

import Data.Maybe (Maybe(..))
import ShellUI.PanelMenu as PanelMenu
import Effect (Effect)
import Effect.Ref (Ref, new)
import Prelude
import Gio.Cancellable as Cancellable
import Gio.Settings as Settings
import GLib as GLib
import St.Bin (Bin)

type Env
  = { button :: Ref (Maybe PanelMenu.Button) -- panel menu
    -- clutter widget
    , ui :: Ref (Maybe Bin)
    -- worker timers
    , timerMain :: Ref (Maybe GLib.EventSourceId)
    , timerDbus :: Ref (Maybe GLib.EventSourceId)
    -- dbus value references
    , idleTimeRef :: Ref Int
    , cancellable :: Ref (Maybe Cancellable.Cancellable)
    -- autochill settings
    , settings :: Ref (Maybe Settings.Settings)
    -- color settings
    , colorSettings :: Settings.Settings
    -- const
    , snoozeDelay :: Int
    , debug :: Boolean
    }

class AutoChillWidget a where
  widget_handler :: a -> Effect Unit -> Effect Unit -> Effect Unit

createEnv :: Boolean -> Effect Env
createEnv debug = do
  button <- new Nothing
  ui <- new Nothing
  timerMain <- new Nothing
  timerDbus <- new Nothing
  settings <- new Nothing
  colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
  idleTimeRef <- new 0
  cancellable <- new Nothing
  pure
    { button
    , ui
    , timerMain
    , timerDbus
    , idleTimeRef
    , settings
    , colorSettings
    , snoozeDelay: 5000 * (if debug then 1 else 60)
    , debug
    , cancellable
    }
