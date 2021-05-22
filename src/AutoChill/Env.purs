module AutoChill.Env (UIEnv, Env, createEnv, Settings) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Ref (Ref, new)
import GLib as GLib
import Gio.Cancellable as Cancellable
import Gio.Settings as Gio.Settings
import Gnome.UI.PanelMenu as PanelMenu
import St.Bin (Bin)

type UIEnv
  = { button :: PanelMenu.Button -- panel menu
    -- clutter widget
    , bin :: Bin
    -- refs
    , env :: Env
    }

type Env
  = { timerMain :: Ref (Maybe GLib.EventSourceId) -- worker timers
    , timerDbus :: Ref (Maybe GLib.EventSourceId)
    -- dbus value references
    , idleTimeRef :: Ref Int
    , cancellable :: Ref (Maybe Cancellable.Cancellable)
    -- const
    , snoozeDelay :: Int
    , debug :: Boolean
    }

type Settings
  = { settings :: Gio.Settings.Settings
    , colorSettings :: Gio.Settings.Settings
    }

createEnv :: Boolean -> Effect Env
createEnv debug = do
  timerMain <- new Nothing
  timerDbus <- new Nothing
  idleTimeRef <- new 0
  cancellable <- new Nothing
  pure
    { timerMain
    , timerDbus
    , idleTimeRef
    , cancellable
    , snoozeDelay: 5000 * (if debug then 1 else 60)
    , debug
    }
