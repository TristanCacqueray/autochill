-- | The autochill clutter ui
module AutoChill.UIClutter where -- (init, showWidget, add, remove) where

import Prelude
import AutoChill.Env as Env
import AutoChill.Worker (autoChillWorker)
import Clutter.Actor as Actor
import Clutter.BoxLayout as Clutter.BoxLayout
import Data.Maybe (Maybe(..))
import Effect (Effect)
import GJS as GJS
import GLib as GLib
import Gnome.UI.Main as UI
import St as St
import St.Bin (Bin)
import St.Bin as St.Bin
import St.BoxLayout as St.BoxLayout
import St.Button as St.Button
import St.Label as St.Label

add :: Bin -> Effect Unit
add = UI.addTopChrome

remove :: Bin -> Effect Unit
remove = UI.removeChrome

showWidget :: Bin -> Effect Unit
showWidget bin = Actor.show bin

solarColor :: String
solarColor = "background-color: #fdf6e3; color: #586e75;"

button :: String -> Effect St.Button.Button
button label = do
  but <- St.Button.new_with_label label
  Actor.set_reactive but true
  St.add_style_class_name but "button"
  St.set_style but $ Just solarColor
  pure but

mkWidget :: Env.Settings -> Env.Env -> Effect Bin
mkWidget settings env = do
  bin <- St.Bin.new
  Actor.set_position bin 10.0 100.0
  -- Actor.set_size bin 150.0 80.0
  St.set_style bin $ Just $ solarColor <> "padding: 5px; margin: 5px; border: 1px;"
  --
  box <- St.BoxLayout.new
  lm <- Clutter.BoxLayout.new
  Clutter.BoxLayout.set_orientation lm 1
  Actor.set_layout_manager box lm
  --
  label <- St.Label.new "Time for a break?"
  Actor.add_child box label
  --
  actionBox <- St.BoxLayout.new
  lm' <- Clutter.BoxLayout.new
  Clutter.BoxLayout.set_orientation lm' 0
  Actor.set_layout_manager actionBox lm'
  Actor.add_child box actionBox
  --
  chillButton <- button "I feel chilled"
  Actor.add_child actionBox chillButton
  void $ Actor.onButtonPressEvent chillButton (onClick bin $ const $ autoChillWorker settings env (Actor.show bin))
  --
  snoozeButton <- button "Snooze"
  Actor.add_child actionBox snoozeButton
  void $ Actor.onButtonPressEvent snoozeButton (onClick bin snooze)
  --
  St.Bin.set_child bin box
  Actor.hide bin
  pure bin
  where
  onClick bin action _actor _ev = do
    Actor.hide bin
    action bin
    pure true

  snooze bin = do
    GJS.log $ "Snoozing for " <> show env.snoozeDelay
    void
      $ GLib.timeoutAdd env.snoozeDelay
          ( do
              Actor.show bin
              pure false
          )
