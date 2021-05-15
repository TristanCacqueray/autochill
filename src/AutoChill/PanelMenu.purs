-- | The GNOME shell panel menu
module AutoChill.PanelMenu where

import AutoChill.Env (Env)
import AutoChill.Worker as Worker
import AutoChill.UIClutter as UIClutter
import Clutter.Actor as Actor
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Ref (read, write)
import GJS (log)
import Gio.ThemedIcon as ThemedIcon
import Prelude
import ShellUI.Main.Panel as Panel
import ShellUI.PanelMenu as PanelMenu
import ShellUI.PopupMenu as PopupMenu
import St as St
import St.Icon as St.Icon
import St.Label as St.Label

addPanelMenu :: Env -> Effect Unit
addPanelMenu env = do
  button <- PanelMenu.newButton 0.0 "AutoChill" false
  write (Just button) env.button
  -- icon <- St.newIcon "weather-snow-symbolic" "system-status-icon"
  gicon <- ThemedIcon.new "weather-snow-symbolic"
  icon <- St.Icon.new
  St.add_style_class_name icon "system-status-icon"
  St.Icon.set_gicon icon gicon
  Actor.add_child button icon
  menuItem <- PopupMenu.newItem ""
  PopupMenu.connectActivate menuItem onClick
  label <- St.Label.new "Restart"
  Actor.add_child menuItem label
  PanelMenu.addMenuItem button menuItem
  Panel.addToStatusArea "autochill" button
  where
  onClick = do
    log "Restart"
    Worker.stopChillWorker env
    widgetM <- read env.ui
    case widgetM of
      Just widget -> do
        Worker.autoChillWorker env (UIClutter.showWidget widget)
      Nothing -> log "oops, empty widget"

removePanelMenu :: Env -> Effect Unit
removePanelMenu env = do
  buttonM <- read env.button
  case buttonM of
    Just button -> Actor.destroy button
    Nothing -> log "[E] Button is undefined"
  write Nothing env.button
