-- | The autochill entrypoint
module AutoChill where

import AutoChill.Env as Env
import AutoChill.PanelMenu as PanelMenu
import AutoChill.PrefsWidget (mkPrefWidget)
import AutoChill.Settings as Settings
import AutoChill.UIClutter as UIClutter
import AutoChill.UIGtk4 as UIGtk4
import AutoChill.Worker (autoChillWorker, stopChillWorker)
import Effect (Effect)
import GJS as GJS
import GLib.MainLoop as GLib.MainLoop
import GObject as GObject
import Gtk4 as Gtk
import Gtk4.Application as Application
import Gtk4.Window as Window
import Prelude
import Gnome.UI.Main as UI
import Gnome.Extension (Extension)

log :: String -> Effect Unit
log msg = GJS.log $ "autochill: " <> msg

extension :: Extension Env.Settings Env.UIEnv
extension = { enable, disable, init }
  where
  init :: Effect Env.Settings
  init = do
    log "init called"
    settings <- Settings.getSettings
    colorSettings <- Settings.getColorSettings
    pure { settings, colorSettings }

  enable :: Env.Settings -> Effect Env.UIEnv
  enable settings = do
    log "enable called"
    env <- Env.createEnv false
    bin <- UIClutter.mkWidget settings env
    button <- PanelMenu.create bin settings env
    UIClutter.add bin
    autoChillWorker settings env (UIClutter.showWidget bin)
    UI.notify "AutoChill engaged" ""
    pure { env, bin, button }

  disable :: Env.UIEnv -> Effect Unit
  disable uiEnv = do
    log "disable called"
    PanelMenu.delete uiEnv.button
    UIClutter.remove uiEnv.bin
    stopChillWorker uiEnv.env

-- | Standalone gtk4 setup
gtkApp :: String -> (GLib.MainLoop.Loop -> Env.Settings -> Effect Unit) -> Effect Unit
gtkApp appName activate = do
  settings <- Settings.getSettingsFromPath "./autochill@tristancacqueray.github.io/schemas"
  colorSettings <- Settings.getColorSettings
  loop <- GLib.MainLoop.new
  app <- Application.new appName
  _ <- GObject.signal_connect_closure app "activate" (activate loop { settings, colorSettings })
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
    prefWidget <- mkPrefWidget settings.settings
    Window.set_child win prefWidget
    Gtk.show win

-- | Standalone runner
standalone :: Boolean -> Effect Unit
standalone debug = gtkApp "autochille.standalone" activate
  where
  activate _loop settings = do
    env <- Env.createEnv debug
    widget <- UIGtk4.mkWidget settings env
    if env.debug then
      UIGtk4.showWidget widget
    else
      autoChillWorker settings env (UIGtk4.showWidget widget)

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
