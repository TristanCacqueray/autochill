module AutoChill.Worker where

import Prelude
import AutoChill.Curve (chillTemperature)
-- import AutoChill.UIGtk4 (chillWindow, chillDialog)
import AutoChill.DBus (isScreenLocked, getIdleTime)
import Data.Int (round, toNumber)
import Data.Maybe (Maybe(..))
import Effect.Ref (Ref, write, read, new)
import Effect (Effect)
import GJS as GJS
import GLib as GLib
import GLib.DateTime as DateTime
import GLib.Variant as Variant
import Gio.Settings as Settings
import AutoChill.Env (Env, class AutoChillWidget, widget_show, widget_handler)

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
  timerM <- read env.timer
  case timerM of
    Just timer -> GLib.sourceRemove timer
    Nothing -> GJS.log "Oops, empty timer"

autoChillWorker :: forall widget. AutoChillWidget widget => Env -> widget -> Ref Boolean -> Boolean -> Settings.Settings -> Effect Unit
autoChillWorker env widget resetRef debug settings = do
  colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
  widget_handler widget (onChilled colorSettings) (onSnooze colorSettings)
  unless debug $ enableNightLight colorSettings
  startTime <- DateTime.getUnix
  if debug then do
    widget_show widget
  else
    startAutoChill colorSettings startTime
  where
  -- in debug mode, a minute is 1 second
  minute_sec = if debug then 1 else 60

  minute_msec = minute_sec * 1000

  maxIdleTime = 10 * minute_msec

  snoozeDelay = 5 * minute_msec

  startAutoChill colorSettings startTime = do
    write false resetRef
    screenLockedRef <- new false
    idleTimeRef <- new 0
    timer <- GLib.timeoutAdd 1000 (go screenLockedRef idleTimeRef colorSettings startTime)
    write (Just timer) env.timer
    pure unit

  onChilled colorSettings = do
    GJS.log "Ah darn, here we go again"
    startTime' <- DateTime.getUnix
    void $ startAutoChill colorSettings startTime'

  onSnooze colorSettings = do
    GJS.log $ "Asking again in " <> show snoozeDelay
    void
      $ GLib.timeoutAdd snoozeDelay
          ( do
              widget_show widget
              pure false
          )

  go screenLockedRef idleTimeRef colorSettings startTime = do
    now <- DateTime.getUnix
    -- todo: cancel running dbus request...
    isScreenLocked screenLockedRef
    getIdleTime idleTimeRef
    durationSeconds <- getSetting "duration"
    startTemp <- getSetting "work-temp"
    endTemp <- getSetting "chill-temp"
    slope <- getCurveSetting "slope"
    cutoff <- getCurveSetting "cutoff"
    screenLocked <- read screenLockedRef
    idleTime <- read idleTimeRef
    reset <- read resetRef
    let
      duration = durationSeconds * (toNumber minute_sec)

      elapsed = toNumber $ now - startTime

      elapsedNorm = elapsed / duration

      newTempNorm = chillTemperature cutoff slope elapsedNorm

      newTemp = endTemp + (startTemp - endTemp) * newTempNorm

      idle = idleTime > maxIdleTime

      shouldStop = elapsed >= duration || screenLocked || idle || reset
    GJS.log
      $ "AutoChill running for "
      <> (show elapsed <> " sec (" <> show elapsedNorm <> ") ")
      <> (" idle: " <> show idleTime)
      <> " temp: "
      <> (show newTemp <> " (" <> show newTempNorm <> ") ")
      <> (if screenLocked then " screenlocked" else "")
      <> (if idle then " idle" else "")
    if shouldStop then do
      unless debug $ setColor colorSettings (round newTemp)
      write false resetRef
      widget_show widget
      pure false
    else
      pure true

  getCurveSetting name = Settings.get_double settings name

  getSetting name = toNumber <$> Settings.get_int settings name
