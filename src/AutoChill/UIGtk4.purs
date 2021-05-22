-- | AutoChill Dialog window
module AutoChill.UIGtk4 (showWidget, mkWidget) where

import Effect (Effect)
import GLib as GLib
import GObject as GObject
import Gtk4 as Gtk4
import Gtk4.Box as Box
import Gtk4.Button as Button
import Gtk4.Label as Label
import Gtk4.Window as Window
import AutoChill.Worker (autoChillWorker)
import AutoChill.Env as Env
import Prelude

showWidget :: Window.Window -> Effect Unit
showWidget win = Gtk4.show win

mkWidget :: Env.Settings -> Env.Env -> Effect Window.Window
mkWidget settings env = do
  win <- Window.new
  Window.set_title win "AutoChill"
  Window.set_decorated win false
  box <- Box.new 1 5.0
  label <- Label.new "Time for a break?"
  Box.append box label
  actionBox <- Box.new 0 5.0
  chillButton <- Button.new_with_label "I feel chilled"
  snoozeButton <- Button.new_with_label "Snooze!"
  void $ GObject.signal_connect_closure chillButton "clicked" (onChilled win)
  void $ GObject.signal_connect_closure snoozeButton "clicked" (onSnooze win)
  Box.append actionBox chillButton
  Box.append actionBox snoozeButton
  Box.append box actionBox
  Window.set_child win box
  -- Without this, the background thread segfault to show for the first time the dialog
  Gtk4.show win
  Gtk4.hide win
  pure win
  where
  onChilled win = do
    Gtk4.hide win
    autoChillWorker settings env (Gtk4.show win)
    pure unit

  onSnooze win = do
    Gtk4.hide win
    void
      $ GLib.timeoutAdd env.snoozeDelay
          ( do
              showWidget win
              pure false
          )
