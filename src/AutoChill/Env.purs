module AutoChill.Env (Env, createEnv, disableEnv) where

import Data.Maybe (Maybe(..))
import ShellUI.PanelMenu as PanelMenu
import Effect (Effect)
import Effect.Ref (Ref, new, read, write)
import GJS (log)
import Prelude
import Clutter.Actor as Actor


type Env
  = { button :: Ref (Maybe PanelMenu.Button) }

createEnv :: Effect Env
createEnv = do
  button <- new Nothing
  pure { button }


disableEnv :: Env -> Effect Unit
disableEnv env = do
  buttonM <- read env.button
  case buttonM of
    Just button -> Actor.destroy button
    Nothing -> log "[E] Button is undefined"
  write Nothing env.button
