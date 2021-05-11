module AutoChill.PrefsWidget (mkPrefWidget, main) where

import Prelude

import AutoChill.Curve (chillTemperature)
import GLib.MainLoop as GLib.MainLoop
import Cairo as Cairo
import Data.Int (round, toNumber)
import Data.List as L
import Data.Traversable (traverse_)
import Effect (Effect)
import GJS as GJS
import Gtk4.Application as Application
import GObject as GObject
import Gio.Settings as Settings
import Gio.SettingsSchemaSource as SettingsSchemaSource
import Gtk4 as Gtk
import Gtk4.Orientation as Orientation
import Gtk4.Box (Box)
import Gtk4.Box as Box
import Gtk4.Button as Button
import Gtk4.Label as Label
import Gtk4.DrawingArea as DrawingArea
import Gtk4.Range as Range
import Gtk4.Scale as Scale
import Gtk4.Window as Window

graphX :: Number
graphX = 500.0
graphY :: Number
graphY = 500.0

drawCurve :: Cairo.Context -> Effect Unit
drawCurve cr = do
  let x = graphX
      y = graphY
  GJS.log $ "Drawing on " <> show x
  box x y
  graph x y
  legend x y
  where
    padding = 20.0
    legend maxX maxY = do
      legendX maxX maxY
      legendY maxX maxY
    legendX maxX maxY = do
      let xAxis = maxY - padding / 2.5
      Cairo.moveTo cr (padding / 2.0) xAxis
      Cairo.showText cr "Work start"
      Cairo.moveTo cr (maxX / 2.0) xAxis
      Cairo.showText cr "->"
      Cairo.moveTo cr (maxX - 35.0) xAxis
      Cairo.showText cr "Break"
    legendY maxX maxY = do
      let yAxis = padding + 5.0
      Cairo.moveTo cr yAxis (yAxis + 6.0)
      Cairo.showText cr "Temperature"
    box :: Number -> Number -> Effect Unit
    box maxX maxY = do
      let maxX' = maxX - padding
          maxY' = maxY - padding
      Cairo.moveTo cr padding padding
      Cairo.setSourceRGB cr 0.8 0.8 0.8
      Cairo.lineTo cr maxX' padding
      Cairo.lineTo cr maxX' maxY'
      Cairo.lineTo cr padding maxY'
      Cairo.lineTo cr padding padding
      Cairo.stroke cr
    graph x y = do
      Cairo.moveTo cr padding padding
      Cairo.setSourceRGB cr 0.0 0.0 0.0
      traverse_ (segment x y) (toNumber <$> L.range 0 (round x))
      Cairo.stroke cr
    segment :: Number -> Number -> Number -> Effect Unit
    segment maxX maxY x =
      let maxX' = maxX - padding * 2.0
          maxY' = maxY - padding * 2.0
          xn = x / maxX
          yn = chillTemperature xn
          y' = padding + (1.0 - yn) * maxY'
          x' = padding + xn * maxX'
       in Cairo.lineTo cr x' y'

mkPrefWidget :: String -> Effect Box
mkPrefWidget path = do
  durationL <- Label.new "Work duration:"
  duration <- Scale.new_with_range Orientation.horizontal 20.0 120.0 5.0
  Scale.set_format_value_func duration (\n -> show (round n) <> " sec")
  Scale.set_draw_value duration true

  schemaSource <- SettingsSchemaSource.new_from_directory path false
  schema <- SettingsSchemaSource.lookup schemaSource "org.gnome.shell.extensions.autochill" false
  settings <- Settings.new_full schema

  _ <- GObject.signal_connect_closure settings "changed::duration" (onChange settings duration)

  val <- Settings.get_int settings "duration"
  Range.set_value duration val

  drawing <- DrawingArea.new
  DrawingArea.set_draw_func drawing drawCurve
  Gtk.set_size_request drawing (round graphX) (round graphY)

  apply <- Button.new_with_label "Apply"
  _ <- GObject.signal_connect_closure apply "clicked" (onApply settings duration)

  box <- Box.new 1 5.0
  Box.append box durationL
  Box.append box duration
  Box.append box apply
  Box.append box drawing
  pure box
  where
    onApply settings scale = do
      GJS.log "onApply called"
      v <- Range.get_value scale
      _ <- Settings.set_int settings "duration" v
      GJS.log $ "applied " <> show v

    onChange settings scale = do
      GJS.log "onChange called!"
      v <- Settings.get_int settings "duration"
      GJS.log $ "to: " <> show v
      Range.set_value scale v
      Gtk.queue_draw scale


main :: Effect Unit
main = do
  GJS.log "Showing preferences"
  Gtk.init

  loop <- GLib.MainLoop.new
  app <- Application.new "autochill.prefs"
  _ <- GObject.signal_connect_closure app "activate" (activate loop)
  Application.run app
  GLib.MainLoop.run loop
  where
    activate loop = do
      win <- Window.new
      _ <- GObject.signal_connect_closure win "close-request" (GLib.MainLoop.quit loop)
      Window.set_title win "AutoChill Prefs"
      prefWidget <- mkPrefWidget "./dist/schemas"

      Window.set_child win prefWidget
      Gtk.show win
