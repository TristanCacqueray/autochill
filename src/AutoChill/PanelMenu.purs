module AutoChill.PanelMenu where

import Prelude
import Effect.Ref (write)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import AutoChill.Env (Env)
import ShellUI.Main.Panel as Panel
import ShellUI.PanelMenu as PanelMenu
import ShellUI.PopupMenu as PopupMenu
import Gio.ThemedIcon as ThemedIcon
import St as St
import St.Label as St.Label
import St.Icon as St.Icon
import Clutter.Actor as Actor
import GJS (log)

setupPanelMenu :: Env -> Effect Unit
setupPanelMenu env = do
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
  label <- St.Label.new "Reset"
  Actor.add_child menuItem label
  PanelMenu.addMenuItem button menuItem
  Panel.addToStatusArea "autochill" button
  where
  onClick = do
    log "Clicked!"
