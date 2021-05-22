module AutoChill.Worker where

import Prelude
import AutoChill.Curve (chillTemperature)
import AutoChill.DBus (getIdleTime)
import Data.Int (round, toNumber)
import Data.Maybe (Maybe(..))
import Effect.Ref as Ref
import Effect (Effect)
import GJS as GJS
import GLib as GLib
import GLib.DateTime as DateTime
import GLib.Variant as Variant
import Gio.Cancellable as Cancellable
import Gio.Settings as Settings
import AutoChill.Env as Env

setColor :: Settings.Settings -> Int -> Effect Unit
setColor colorSettings value = do
  v <- Variant.new_uint32 value
  _ <- Settings.set_value colorSettings "night-light-temperature" v
  pure unit

enableNightLight :: Settings.Settings -> Effect Unit
enableNightLight colorSettings = do
  v <- Variant.new_double 0.0
  _ <- Settings.set_value colorSettings "night-light-schedule-from" v
  v' <- Variant.new_double 24.0
  _' <- Settings.set_value colorSettings "night-light-schedule-to" v'
  GJS.log $ "Activating night light"

stopChillWorker :: Env.Env -> Effect Unit
stopChillWorker env = do
  cancellableM <- Ref.read env.cancellable
  case cancellableM of
    Just cancellable -> do
      Cancellable.cancel cancellable
      Ref.write Nothing env.cancellable
    Nothing -> GJS.log "Oops, empty cancellable"
  sourceRemoveM env.timerMain
  sourceRemoveM env.timerDbus
  where
  sourceRemoveM ref = do
    timerM <- Ref.read ref
    case timerM of
      Just timer -> GLib.sourceRemove timer
      Nothing -> GJS.log "Oops, empty timer"
    Ref.write Nothing ref

startIdleWorker :: Env.Env -> Effect Unit
startIdleWorker env = do
  timerDbusM <- Ref.read env.timerDbus
  case timerDbusM of
    Just timer -> do
      GJS.log "Idle worker already running!"
      GLib.sourceRemove timer
    Nothing -> pure unit
  cancellable <- Cancellable.new
  Ref.write (Just cancellable) env.cancellable
  timer <- GLib.timeoutAdd 5000 (go cancellable)
  Ref.write (Just timer) env.timerDbus
  where
  go cancellable = do
    getIdleTime cancellable env.idleTimeRef
    pure true

autoChillWorker :: Env.Settings -> Env.Env -> Effect Unit -> Effect Unit
autoChillWorker settings env show_dialog = do
  GJS.log "Ah darn, here we go again"
  unless env.debug $ enableNightLight settings.colorSettings
  startIdleWorker env
  startTime <- DateTime.getUnix
  lastTimeRef <- Ref.new startTime
  Ref.write 0 env.idleTimeRef
  -- TODO: remove any running timer
  timer <- GLib.timeoutAdd 1000 (go startTime lastTimeRef)
  Ref.write (Just timer) env.timerMain
  where
  -- in debug mode, a minute is 1 second
  minute_sec = if env.debug then 1 else 60

  minute_msec = minute_sec * 1000

  maxIdleTime = 10 * minute_msec

  go startTime lastTimeRef = do
    now <- DateTime.getUnix
    durationSeconds <- getSetting "duration"
    startTemp <- getSetting "work-temp"
    endTemp <- getSetting "chill-temp"
    slope <- getCurveSetting "slope"
    cutoff <- getCurveSetting "cutoff"
    idleTime <- Ref.read env.idleTimeRef
    lastTime <- Ref.read lastTimeRef
    let
      duration = durationSeconds * (toNumber minute_sec)

      elapsed = toNumber $ now - startTime

      elapsedNorm = elapsed / duration

      newTempNorm = chillTemperature cutoff slope elapsedNorm

      newTemp = endTemp + (startTemp - endTemp) * newTempNorm

      idle = idleTime > maxIdleTime

      asleep = now - lastTime > 600

      shouldStop = elapsed >= duration || idle || asleep
    GJS.log
      $ "AutoChill running for "
      <> (show elapsed <> " sec ( remaining: " <> show (duration - elapsed) <> ") ")
      <> (" idle: " <> show idleTime)
      <> (" temp: " <> show newTemp)
      <> (if idle then " idle" else "")
      <> (if asleep then " asleep" else "")
    if shouldStop then do
      stopChillWorker env
      show_dialog
      pure false
    else do
      unless env.debug $ setColor settings.colorSettings (round newTemp)
      Ref.write now lastTimeRef
      pure true
    where
    getCurveSetting name = Settings.get_double settings.settings name

    getSetting name = toNumber <$> Settings.get_int settings.settings name
