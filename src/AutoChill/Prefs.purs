module AutoChill.Prefs (init, buildPrefsWidget, main) where

import Prelude

import AutoChill.Curve (chillTemperature)
import Cairo as Cairo
import Data.Int (round, toNumber)
import Data.List as L
import Data.Traversable (traverse_)
import Effect (Effect)
import GJS as GJS
import Gtk as Gtk
import Gtk.Box (Box)
import Gtk.Box as Box
import Gtk.DrawingArea as DrawingArea
import Gtk.Widget as Widget
import Gtk.Window as Window

init :: Effect Unit
init = do
  GJS.log "pref init called"
  Gtk.init

buildPrefsWidget :: Effect Box
buildPrefsWidget = do
  GJS.log "buildPrefsWidget called"
  mkPrefWidget

graphX = 500.0
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

mkPrefWidget :: Effect Box
mkPrefWidget = do
  drawing <- DrawingArea.new
  DrawingArea.connectDraw drawing drawCurve
  Widget.set_size_request drawing (round graphX) (round graphY)

  box <- Box.new
  Box.pack_start box drawing true true 0
  pure box


main :: Effect Unit
main = do
  GJS.log "Showing preferences"
  Gtk.init

  win <- Window.new
  Window.connectDelete win Gtk.main_quit

  prefWidget <- mkPrefWidget

  Window.add win prefWidget
  Window.show_all win
  Gtk.main
