module AutoChill.Env (Env, createEnv) where

import Data.Maybe (Maybe(..))
import ShellUI.PanelMenu as PanelMenu
import Effect (Effect)
import Effect.Ref (Ref, new)
import Prelude
import Gio.Settings as Settings
import GLib as GLib
import St.Bin (Bin)

type Env
  = { button :: Ref (Maybe PanelMenu.Button)
    , ui :: Ref (Maybe Bin)
    , reset :: Ref Boolean
    , timer :: Ref (Maybe GLib.EventSourceId)
    , settings :: Ref (Maybe Settings.Settings)
    , colorSettings :: Settings.Settings
    , snoozeDelay :: Int
    , debug :: Boolean
    }

class AutoChillWidget a where
  widget_handler :: a -> Effect Unit -> Effect Unit -> Effect Unit

createEnv :: Boolean -> Effect Env
createEnv debug = do
  button <- new Nothing
  ui <- new Nothing
  reset <- new false
  timer <- new Nothing
  settings <- new Nothing
  colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
  pure { button, ui, reset, timer, settings, colorSettings, snoozeDelay: 5000, debug }
