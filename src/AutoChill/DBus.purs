module AutoChill.DBus (isScreenLocked, getIdleTime) where

import Prelude
import Effect (Effect)
import Effect.Ref as Ref
import Data.Maybe (Maybe(..))
import GLib.Variant as Variant
import Gio.DBusConnection as DBusConnection
import Gio.DBusCallFlags as DBusCallFlags
import Gio.Cancellable (Cancellable)

simpleCall :: Cancellable -> String -> String -> String -> (Variant.Variant -> Effect Unit) -> Effect Unit
simpleCall cancellable interface path method writeCb = do
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
    (Just cancellable)
    (Just cb)
  where
  cb res = do
    xs <- DBusConnection.call_finish DBusConnection.session res
    x <- Variant.get_child_value xs 0
    writeCb x

isScreenLocked :: Cancellable -> Ref.Ref Boolean -> Effect Unit
isScreenLocked c ref = simpleCall c "org.gnome.ScreenSaver" "/org/gnome/ScreenSaver" "GetActive" writeCb
  where
  writeCb variant = do
    value <- Variant.get_boolean variant
    Ref.write value ref

getIdleTime :: Cancellable -> Ref.Ref Int -> Effect Unit
getIdleTime c ref = simpleCall c "org.gnome.Mutter.IdleMonitor" "/org/gnome/Mutter/IdleMonitor/Core" "GetIdletime" writeCb
  where
  writeCb variant = do
    value <- Variant.get_uint64 variant
    Ref.write value ref
