-- | AutoChill Dialog window
module AutoChill.Dialog where

import Effect (Effect)
import GObject as GObject
import Gtk4 as Gtk4
import Gtk4.Box as Box
import Gtk4.Button as Button
import Gtk4.Dialog as Dialog
import Gtk4.Label as Label
import Gtk4.Window as Window
import Prelude

chillWindow :: Window.Window -> Effect Unit -> Effect Unit -> Effect Unit
chillWindow win onChilled onSnooze = do
  Window.set_title win "AutoChill"
  Window.set_decorated win false
  box <- Box.new 1 5.0
  label <- Label.new "Time for a break?"
  Box.append box label
  actionBox <- Box.new 0 5.0
  chillButton <- Button.new_with_label "I feel chilled"
  snoozeButton <- Button.new_with_label "Snooze!"
  _ <- GObject.signal_connect_closure chillButton "clicked" (closeButton onChilled)
  _ <- GObject.signal_connect_closure snoozeButton "clicked" (closeButton onSnooze)
  Box.append actionBox chillButton
  Box.append actionBox snoozeButton
  Box.append box actionBox
  Window.set_child win box
  -- Without this, the background thread segfault to show for the first time the dialog
  Gtk4.show win
  Gtk4.hide win
  where
    closeButton action = do
      Gtk4.hide win
      action

chillDialog :: Effect Unit -> Effect Unit -> Effect Unit
chillDialog onChilled onSnooze = do
  diag <- Dialog.new
  diagContent <- Dialog.get_content_area diag
  label <- Label.new "Time for a break?"
  Box.append diagContent label
  Dialog.add_button diag "I feel chilled" 1
  Dialog.add_button diag "Snooze!" 2
  Dialog.onResponse diag (onResponse diag)
  Window.set_modal diag true
  Gtk4.show diag
  where
    onResponse diag val = do
      Window.close diag
      case val of
           1 -> onChilled
           2 -> onSnooze
           _ -> pure unit
