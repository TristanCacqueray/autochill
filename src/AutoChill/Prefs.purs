module AutoChill.Prefs (init, buildPrefsWidget) where

import Prelude

import AutoChill.Curve (chillTemperature)
import GLib.MainLoop as GLib.MainLoop
import Cairo as Cairo
import Data.Int (round, toNumber)
import Data.List as L
import Data.Traversable (traverse_)
import Effect (Effect)
import ExtensionUtils as ExtensionUtils
import GJS as GJS
import Gtk4.Application as Application
import GObject as GObject
import Gio.Settings as Settings
import Gio.SettingsSchemaSource as SettingsSchemaSource
import Gtk4 as Gtk
import Gtk4.Orientation as Orientation
import Gtk4.Box (Box)
import Gtk4.Box as Box
import Gtk4.Label as Label
import Gtk4.DrawingArea as DrawingArea
import Gtk4.Range as Range
import Gtk4.Scale as Scale
import Gtk4.Window as Window
import AutoChill.PrefsWidget (mkPrefWidget)

init :: Effect Unit
init = do
  GJS.log "pref init called"

buildPrefsWidget :: Effect Box
buildPrefsWidget = do
  GJS.log "buildPrefsWidget called"
  me <- ExtensionUtils.getCurrentExtension
  schemaDir <- ExtensionUtils.getPath me "schemas"
  GJS.log $ "Got schema: " <> schemaDir
  mkPrefWidget schemaDir
