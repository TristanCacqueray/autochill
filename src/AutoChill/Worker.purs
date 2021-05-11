module AutoChill.Worker where

import Prelude
import AutoChill.Curve (chillTemperature)
import AutoChill.Dialog (chillWindow)
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

autoChillWorker :: Boolean -> Settings.Settings -> Effect GLib.EventSourceId
autoChillWorker debug settings = do
  colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
  dialog <- Window.new
  chillWindow dialog (onChilled colorSettings dialog) (onSnooze colorSettings dialog)
  unless debug $ enableNightLight colorSettings
  startTime <- DateTime.getUnix
  startAutoChill colorSettings startTime dialog
  where
  snoozeDelay =
    1000
      * if debug then
          5
        else
          5 * 60

  startAutoChill colorSettings startTime dialog = GLib.timeoutAdd 1000 (go colorSettings startTime dialog)

  onChilled colorSettings dialog = do
    GJS.log "Ah darn, here we go again"
    startTime' <- DateTime.getUnix
    void $ startAutoChill colorSettings startTime' dialog

  onSnooze colorSettings dialog = do
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
    let
      duration =
        if debug then
          5.0
        else
          60.0 * durationSeconds

      elapsed = toNumber $ now - startTime

      elapsedNorm = elapsed / duration

      newTempNorm = chillTemperature cutoff slope elapsedNorm

      newTemp = endTemp + (startTemp - endTemp) * newTempNorm
    GJS.log
      $ "AutoChill running for "
      <> (show elapsed <> " sec (" <> show elapsedNorm <> ") ")
      <> " temp: "
      <> (show newTemp <> " (" <> show newTempNorm <> ") ")
    unless debug $ setColor colorSettings (round newTemp)
    when (elapsed >= duration) $ Gtk4.show dialog
    pure $ elapsed < duration

  getCurveSetting name = Settings.get_double settings name

  getSetting name = toNumber <$> Settings.get_int settings name
