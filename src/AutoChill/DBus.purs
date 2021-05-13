module AutoChill.DBus (isScreenLocked, getIdleTime) where

import Prelude
import Effect (Effect)
import Effect.Ref as Ref
import Data.Maybe (Maybe(..))
import GLib.Variant as Variant
import Gio.DBusConnection as DBusConnection
import Gio.DBusCallFlags as DBusCallFlags

simpleCall :: String -> String -> String -> (Variant.Variant -> Effect Unit) -> Effect Unit
simpleCall interface path method writeCb = do
  DBusConnection.call
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
    (Just cb)
  where
  cb res = do
    xs <- DBusConnection.call_finish DBusConnection.session res
    x <- Variant.get_child_value xs 0
    writeCb x

isScreenLocked :: Ref.Ref Boolean -> Effect Unit
isScreenLocked ref = simpleCall "org.gnome.ScreenSaver" "/org/gnome/ScreenSaver" "GetActive" writeCb
  where
  writeCb variant = do
    value <- Variant.get_boolean variant
    Ref.write value ref

getIdleTime :: Ref.Ref Int -> Effect Unit
getIdleTime ref = simpleCall "org.gnome.Mutter.IdleMonitor" "/org/gnome/Mutter/IdleMonitor/Core" "GetIdletime" writeCb
  where
  writeCb variant = do
    value <- Variant.get_uint64 variant
    Ref.write value ref
