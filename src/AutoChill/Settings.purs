module AutoChill.Settings (getSettings, getSettingsFromPath) where

import Prelude
import Effect (Effect)
import ExtensionUtils as ExtensionUtils
import Gio.SettingsSchemaSource as SettingsSchemaSource
import Gio.Settings as Settings

getSettingsFromPath :: String -> Effect Settings.Settings
getSettingsFromPath path = do
  schemaSource <- SettingsSchemaSource.new_from_directory path false
  schema <- SettingsSchemaSource.lookup schemaSource "org.gnome.shell.extensions.autochill" false
  Settings.new_full schema

getSettings :: Effect Settings.Settings
getSettings = do
  me <- ExtensionUtils.getCurrentExtension
  path <- ExtensionUtils.getPath me "schemas"
  getSettingsFromPath path
