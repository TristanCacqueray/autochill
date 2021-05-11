module AutoChill.Settings (getSettings) where

import Prelude
import ExtensionUtils as ExtensionUtils
import Gio.SettingsSchemaSource as SettingsSchemaSource
import Gio.Settings as Settings

getSettings = do
  me <- ExtensionUtils.getCurrentExtension
  path <- ExtensionUtils.getPath me "schemas"
  schemaSource <- SettingsSchemaSource.new_from_directory path false
  schema <- SettingsSchemaSource.lookup schemaSource "org.gnome.shell.extensions.autochill" false
  Settings.new_full schema
