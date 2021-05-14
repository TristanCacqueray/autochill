module AutoChill.Worker where

import Prelude
import AutoChill.Curve (chillTemperature)
-- import AutoChill.UIGtk4 (chillWindow, chillDialog)
import AutoChill.DBus (isScreenLocked, getIdleTime)
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
import AutoChill.Env (Env)

setColor :: Settings.Settings -> Int -> Effect Unit
setColor colorSettings value = do
  v <- Variant.new_uint32 value
  r <- Settings.set_value colorSettings "night-light-temperature" v
  pure unit

enableNightLight :: Settings.Settings -> Effect Unit
enableNightLight colorSettings = do
  v <- Variant.new_double 0.0
  r <- Settings.set_value colorSettings "night-light-schedule-from" v
  v' <- Variant.new_double 24.0
  r' <- Settings.set_value colorSettings "night-light-schedule-to" v'
  GJS.log $ "Activating night light"

stopChillWorker :: Env -> Effect Unit
stopChillWorker env = do
  timerM <- Ref.read env.timer
  case timerM of
    Just timer -> GLib.sourceRemove timer
    Nothing -> GJS.log "Oops, empty timer"

autoChillWorker :: Env -> Effect Unit -> Effect Unit
autoChillWorker env show_dialog = do
  GJS.log "Ah darn, here we go again"
  unless env.debug $ enableNightLight env.colorSettings
  startTime <- DateTime.getUnix
  lastTimeRef <- Ref.new startTime
  cancellable <- Cancellable.new
  -- ensure reset is unset
  Ref.write false env.reset
  -- initialize dbus values
  screenLockedRef <- Ref.new false
  idleTimeRef <- Ref.new 0
  -- grab settings instance
  settingsM <- Ref.read env.settings
  -- TODO: remove any running timer
  case settingsM of
    Just settings -> do
      timer <- GLib.timeoutAdd 1000 (go settings screenLockedRef idleTimeRef startTime lastTimeRef cancellable)
      Ref.write (Just timer) env.timer
      pure unit
    Nothing -> pure unit
  where
  -- in debug mode, a minute is 1 second
  minute_sec = if env.debug then 1 else 60

  minute_msec = minute_sec * 1000

  maxIdleTime = 10 * minute_msec

  snoozeDelay = 5 * minute_msec

  go settings screenLockedRef idleTimeRef startTime lastTimeRef cancellable = do
    now <- DateTime.getUnix
    -- todo: cancel running dbus request...
    isScreenLocked cancellable screenLockedRef
    getIdleTime cancellable idleTimeRef
    durationSeconds <- getSetting "duration"
    startTemp <- getSetting "work-temp"
    endTemp <- getSetting "chill-temp"
    slope <- getCurveSetting "slope"
    cutoff <- getCurveSetting "cutoff"
    screenLocked <- Ref.read screenLockedRef
    idleTime <- Ref.read idleTimeRef
    lastTime <- Ref.read lastTimeRef
    reset <- Ref.read env.reset
    let
      duration = durationSeconds * (toNumber minute_sec)

      elapsed = toNumber $ now - startTime

      elapsedNorm = elapsed / duration

      newTempNorm = chillTemperature cutoff slope elapsedNorm

      newTemp = endTemp + (startTemp - endTemp) * newTempNorm

      idle = idleTime > maxIdleTime

      asleep = now - lastTime > 600

      shouldStop = elapsed >= duration || screenLocked || idle || reset || asleep
    GJS.log
      $ "AutoChill running for "
      <> (show elapsed <> " sec ( remaining: " <> show (duration - elapsed) <> ") ")
      <> (" idle: " <> show idleTime)
      <> (" temp: " <> show newTemp)
      <> (if screenLocked then " screenlocked" else "")
      <> (if idle then " idle" else "")
      <> (if asleep then " asleep" else "")
    if shouldStop then do
      Cancellable.cancel cancellable
      Ref.write false env.reset
      show_dialog
      pure false
    else do
      unless env.debug $ setColor env.colorSettings (round newTemp)
      Ref.write now lastTimeRef
      pure true
    where
    getCurveSetting name = Settings.get_double settings name

    getSetting name = toNumber <$> Settings.get_int settings name
