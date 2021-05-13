-- | AutoChill Dialog window
module AutoChill.UIGtk4 (Widget, mkWidget) where

import Effect (Effect)
import GObject as GObject
import Gtk4 as Gtk4
import Gtk4.Box as Box
import Gtk4.Button as Button
import Gtk4.Label as Label
import Gtk4.Window as Window
import AutoChill.Env (class AutoChillWidget)
import Prelude

data Widget
  = Widget
    { win :: Window.Window
    , chillButton :: Button.Button
    , snoozeButton :: Button.Button
    }

instance autoChillWidget :: AutoChillWidget Widget where
  widget_show (Widget widget) = Gtk4.show widget.win
  widget_handler (Widget widget) onChilled onSnooze = do
    _ <- GObject.signal_connect_closure widget.chillButton "clicked" (closeButton onChilled)
    _ <- GObject.signal_connect_closure widget.snoozeButton "clicked" (closeButton onSnooze)
    pure unit
    where
    closeButton action = do
      Gtk4.hide widget.win
      action

mkWidget :: Effect Widget
mkWidget = do
  win <- Window.new
  Window.set_title win "AutoChill"
  Window.set_decorated win false
  box <- Box.new 1 5.0
  label <- Label.new "Time for a break?"
  Box.append box label
  actionBox <- Box.new 0 5.0
  chillButton <- Button.new_with_label "I feel chilled"
  snoozeButton <- Button.new_with_label "Snooze!"
  Box.append actionBox chillButton
  Box.append actionBox snoozeButton
  Box.append box actionBox
  Window.set_child win box
  -- Without this, the background thread segfault to show for the first time the dialog
  -- Gtk4.show win
  Gtk4.hide win
  pure $ Widget { win, chillButton, snoozeButton }

-- where
