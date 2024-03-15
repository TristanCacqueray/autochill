module AutoChill.Settings (getColorSettings, getSettings, getSettingsFromPath) where

import Effect (Effect)
import ExtensionUtils (ExtensionMetadata)
import ExtensionUtils as ExtensionUtils
import Gio.Settings as Settings
import Gio.SettingsSchemaSource as SettingsSchemaSource
import Prelude

getSettingsFromPath :: String -> Effect Settings.Settings
getSettingsFromPath path = do
  schemaSource <- SettingsSchemaSource.new_from_directory path false
  schema <- SettingsSchemaSource.lookup schemaSource "org.gnome.shell.extensions.autochill" false
  Settings.new_full schema

getSettings :: ExtensionMetadata -> Effect Settings.Settings
getSettings me = do
  path <- ExtensionUtils.getPath me "schemas"
  getSettingsFromPath path

getColorSettings :: Effect Settings.Settings
getColorSettings = Settings.new "org.gnome.settings-daemon.plugins.color"
