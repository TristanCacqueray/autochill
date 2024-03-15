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
import ExtensionUtils (ExtensionMetadata)
import GJS as GJS
import GLib.MainLoop as GLib.MainLoop
import GObject as GObject
import Gnome.Extension (Extension)
import Gnome.UI.Main as UI
import Gtk4 as Gtk
import Gtk4.Application as Application
import Gtk4.Window as Window
import Prelude

log :: String -> Effect Unit
log msg = GJS.log $ "autochill: " <> msg

extension :: Extension Env.Settings Env.UIEnv
extension = { extension_enable, extension_disable, extension_init }
  where
  extension_init :: ExtensionMetadata -> Effect Env.Settings
  extension_init me = do
    log "init called"
    settings <- Settings.getSettings me
    colorSettings <- Settings.getColorSettings
    pure { settings, colorSettings }

  extension_enable :: Env.Settings -> Effect Env.UIEnv
  extension_enable settings = do
    log "enable called"
    env <- Env.createEnv false
    bin <- UIClutter.mkWidget settings env
    button <- PanelMenu.create bin settings env
    UIClutter.add bin
    autoChillWorker settings env (UIClutter.showWidget bin)
    UI.notify "AutoChill engaged" ""
    pure { env, bin, button }

  extension_disable :: Env.UIEnv -> Effect Unit
  extension_disable uiEnv = do
    log "disable called"
    PanelMenu.delete uiEnv.button
    UIClutter.remove uiEnv.bin
    stopChillWorker uiEnv.env
