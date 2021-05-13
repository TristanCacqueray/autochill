module AutoChill.Env (Env, createEnv, class AutoChillWidget, widget_show, widget_handler, Widget(..)) where

import Clutter.Actor as Actor
import Data.Maybe (Maybe(..))
import ShellUI.PanelMenu as PanelMenu
import Effect (Effect)
import Effect.Ref (Ref, new)
import Prelude
import St.Bin (Bin)
import St.Button (Button)
import GJS as GJS
import GLib as GLib

data Widget
  = Widget
    { bin :: Bin
    , chillButton :: Button
    , snoozeButton :: Button
    }

instance autoChillWidget :: AutoChillWidget Widget where
  widget_show (Widget widget) = Actor.show widget.bin
  widget_handler (Widget widget) onChilled onSnooze = do
    Actor.onButtonPressEvent widget.chillButton (closeButton onChilled)
    Actor.onButtonPressEvent widget.snoozeButton (closeButton onSnooze)
    pure unit
    where
    closeButton action _ _ev = do
      Actor.hide widget.bin
      action
      pure true

type Env
  = { button :: Ref (Maybe PanelMenu.Button)
    , reset :: Ref Boolean
    , ui :: Ref (Maybe Widget)
    , timer :: Ref (Maybe GLib.EventSourceId)
    }

class AutoChillWidget a where
  widget_show :: a -> Effect Unit
  widget_handler :: a -> Effect Unit -> Effect Unit -> Effect Unit

createEnv :: Effect Env
createEnv = do
  ui <- new Nothing
  button <- new Nothing
  reset <- new false
  timer <- new Nothing
  pure { button, reset, ui, timer }
