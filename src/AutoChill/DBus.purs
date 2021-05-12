module AutoChill.DBus (isScreenLock, getIdleTime) where

import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
import GLib.Variant as Variant
import Gio.DBusConnection as DBusConnection
import Gio.DBusCallFlags as DBusCallFlags

simpleCall :: String -> String -> String -> Effect (Maybe Variant.Variant)
simpleCall interface path method = do
  variantsM <-
    DBusConnection.call_sync_maybe
      DBusConnection.session
      (Just interface)
      path
      interface
      method
      Nothing
      Nothing
      DBusCallFlags.none
      200
      Nothing
  case variantsM of
    Just variants -> Just <$> Variant.get_child_value variants 0
    Nothing -> pure Nothing

isScreenLock :: Effect Boolean
isScreenLock = do
  variantM <- simpleCall "org.gnome.ScreenSaver" "/org/gnome/ScreenSaver" "GetActive"
  case variantM of
    Just variant -> Variant.get_boolean variant
    Nothing -> pure false

getIdleTime :: Effect Int
getIdleTime = do
  variantM <- simpleCall "org.gnome.Mutter.IdleMonitor" "/org/gnome/Mutter/IdleMonitor/Core" "GetIdletime"
  case variantM of
    Just variant -> Variant.get_uint64 variant
    Nothing -> pure 0
