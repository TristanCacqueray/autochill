-- | The autochill entrypoint
module AutoChill where

import AutoChill.Env (Env, createEnv)
import AutoChill.PanelMenu (addPanelMenu, removePanelMenu)
import AutoChill.PrefsWidget (mkPrefWidget)
import AutoChill.Settings (getSettings, getSettingsFromPath)
import AutoChill.UIClutter as UIClutter
import AutoChill.UIGtk4 as UIGtk4
import AutoChill.Worker (autoChillWorker, stopChillWorker)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Ref as Ref
import GJS (log)
import GJS as GJS
import GLib.MainLoop as GLib.MainLoop
import GObject as GObject
import Gio.Settings (Settings)
import Gtk4 as Gtk
import Gtk4.Application as Application
import Gtk4.Window as Window
import Prelude
import ShellUI.Main as UI

-- | Create the extension environment, to be shared by enable/disable
create :: Effect Env
create = createEnv false

-- | The extension init phase
init :: Env -> Effect Unit
init env = do
  log "init called"
  UIClutter.init env

-- | Enable the extension
enable :: Env -> Effect Unit
enable env = do
  log "enable called"
  UIClutter.add env
  settings <- getSettings
  Ref.write (Just settings) env.settings
  addPanelMenu env
  widgetM <- Ref.read env.ui
  case widgetM of
    Just widget -> do
      autoChillWorker env (UIClutter.showWidget widget)
      UI.notify "AutoChill engaged" ""
    Nothing -> log "oops, empty widget"
  where
  debugMode = false

-- | Disable the extension
disable :: Env -> Effect Unit
disable env = do
  log "disable called"
  UIClutter.remove env
  removePanelMenu env
  stopChillWorker env
  UI.notify "AutoChill disabled" ""

-- | Standalone gtk4 setup
gtkApp :: String -> (GLib.MainLoop.Loop -> Settings -> Effect Unit) -> Effect Unit
gtkApp appName activate = do
  settings <- getSettingsFromPath "./autochill@tristancacqueray.github.io/schemas"
  loop <- GLib.MainLoop.new
  app <- Application.new appName
  _ <- GObject.signal_connect_closure app "activate" (activate loop settings)
  Application.run app
  GLib.MainLoop.run loop
  GJS.print "Done."

-- | Standalone preference editor
mainPrefs :: Effect Unit
mainPrefs = gtkApp "autochill.prefs" activate
  where
  activate loop settings = do
    win <- Window.new
    _ <- GObject.signal_connect_closure win "close-request" (GLib.MainLoop.quit loop)
    Window.set_title win "AutoChill Prefs"
    prefWidget <- mkPrefWidget settings
    Window.set_child win prefWidget
    Gtk.show win

-- | Standalone runner
standalone :: Boolean -> Effect Unit
standalone debug = gtkApp "autochille.standalone" activate
  where
  activate _loop settings = do
    env <- createEnv debug
    reset <- Ref.new false
    widget <- UIGtk4.mkWidget env
    Ref.write (Just settings) env.settings
    if env.debug then
      UIGtk4.showWidget widget
    else
      autoChillWorker env (UIGtk4.showWidget widget)

-- | CLI entrypoint
main :: Effect Unit
main = case GJS.argv of
  [] -> GJS.log "loading autochill"
  [ "--help" ] -> usage
  [ "--run" ] -> standalone false
  [ "--run-debug" ] -> standalone true
  [ "--prefs" ] -> mainPrefs
  _ -> usage
  where
  usage = GJS.printerr "autochill - [--run|--prefs|--help]"
