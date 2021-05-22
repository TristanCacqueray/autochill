-- | The GNOME shell panel menu
module AutoChill.PanelMenu (create, delete) where

import AutoChill.Env as Env
import AutoChill.Worker as Worker
import AutoChill.UIClutter as UIClutter
import Clutter.Actor as Actor
import Effect (Effect)
import GJS (log)
import Gio.ThemedIcon as ThemedIcon
import Prelude
import Gnome.UI.Main.Panel as Panel
import Gnome.UI.PanelMenu as PanelMenu
import Gnome.UI.PopupMenu as PopupMenu
import St as St
import St.Bin (Bin)
import St.Icon as St.Icon
import St.Label as St.Label

create :: Bin -> Env.Settings -> Env.Env -> Effect PanelMenu.Button
create ui settings env = do
  button <- PanelMenu.newButton 0.0 "AutoChill" false
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
  pure button
  where
  onClick = do
    log "Restart"
    Worker.stopChillWorker env
    Worker.autoChillWorker settings env (UIClutter.showWidget ui)

delete :: PanelMenu.Button -> Effect Unit
delete = Actor.destroy
