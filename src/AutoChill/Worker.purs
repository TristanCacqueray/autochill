module AutoChill.Worker where

import Prelude
import AutoChill.Curve (chillTemperature)
import AutoChill.Dialog (chillWindow)
import AutoChill.DBus (isScreenLock, getIdleTime)
import Data.Int (round, toNumber)
import Effect (Effect)
import GJS as GJS
import GLib as GLib
import GLib.DateTime as DateTime
import GLib.Variant as Variant
import Gio.Settings as Settings
import Gtk4 as Gtk4
import Gtk4.Window as Window

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

autoChillWorker :: Boolean -> Settings.Settings -> Effect Unit
autoChillWorker debug settings = do
  colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
  dialog <- Window.new
  chillWindow dialog (onChilled colorSettings dialog) (onSnooze colorSettings dialog)
  unless debug $ enableNightLight colorSettings
  startTime <- DateTime.getUnix
  if debug then
    Gtk4.show dialog
  else
    void $ startAutoChill colorSettings startTime dialog
  where
  -- in debug mode, a minute is 1 second
  minute_sec = if debug then 1 else 60

  minute_msec = minute_sec * 1000

  maxIdleTime = 10 * minute_msec

  snoozeDelay = 5 * minute_msec

  startAutoChill colorSettings startTime dialog = GLib.timeoutAdd 1000 (go colorSettings startTime dialog)

  onChilled colorSettings dialog = do
    GJS.log "Ah darn, here we go again"
    startTime' <- DateTime.getUnix
    void $ startAutoChill colorSettings startTime' dialog

  onSnooze colorSettings dialog = do
    GJS.log $ "Asking again in " <> show snoozeDelay
    void
      $ GLib.timeoutAdd snoozeDelay
          ( do
              Gtk4.show dialog
              pure false
          )

  go colorSettings startTime dialog = do
    now <- DateTime.getUnix
    durationSeconds <- getSetting "duration"
    startTemp <- getSetting "work-temp"
    endTemp <- getSetting "chill-temp"
    slope <- getCurveSetting "slope"
    cutoff <- getCurveSetting "cutoff"
    screenLocked <- isScreenLock
    idleTime <- getIdleTime
    let
      duration = durationSeconds * (toNumber minute_sec)

      elapsed = toNumber $ now - startTime

      elapsedNorm = elapsed / duration

      newTempNorm = chillTemperature cutoff slope elapsedNorm

      newTemp = endTemp + (startTemp - endTemp) * newTempNorm

      idle = idleTime > maxIdleTime

      shouldStop = elapsed >= duration || screenLocked || idle
    GJS.log
      $ "AutoChill running for "
      <> (show elapsed <> " sec (" <> show elapsedNorm <> ") ")
      <> " temp: "
      <> (show newTemp <> " (" <> show newTempNorm <> ") ")
      <> (if screenLocked then " screenlocked" else "")
      <> (if idle then " idle" else "")
    if shouldStop then do
      unless debug $ setColor colorSettings (round newTemp)
      Gtk4.show dialog
      pure false
    else
      pure true

  getCurveSetting name = Settings.get_double settings name

  getSetting name = toNumber <$> Settings.get_int settings name
