-- | The AutoChill preference widget
module AutoChill.PrefsWidget (mkPrefWidget) where

import AutoChill.Curve (chillTemperature)
import Cairo as Cairo
import Data.Int (fromString, round, toNumber)
import Data.List as L
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse_)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Ref as Ref
import GJS as GJS
import GObject as GObject
import Gio.Settings as Settings
import GLib.Variant as Variant
import Gtk4 as Gtk
import Gtk4.Box (Box)
import Gtk4.Box as Box
import Gtk4.Button as Button
import Gtk4.DrawingArea as DrawingArea
import Gtk4.Entry as Entry
import Gtk4.EntryBuffer as EntryBuffer
import Gtk4.Label as Label
import Gtk4.Orientation as Orientation
import Gtk4.Range as Range
import Gtk4.Scale as Scale
import Prelude

graphX :: Number
graphX = 500.0

graphY :: Number
graphY = 500.0

drawCurve :: Ref.Ref Number -> Ref.Ref Number -> Cairo.Context -> Effect Unit
drawCurve cutoffRef slopeRef cr = do
  let
    x = graphX

    y = graphY
  box x y
  graph x y
  legend x y
  where
  padding = 20.0

  legend maxX maxY = do
    legendX maxX maxY
    legendY maxX maxY

  legendX maxX maxY = do
    let
      xAxis = maxY - padding / 2.5
    Cairo.moveTo cr (padding / 2.0) xAxis
    Cairo.showText cr "Work start"
    Cairo.moveTo cr (maxX / 2.0) xAxis
    Cairo.showText cr "->"
    Cairo.moveTo cr (maxX - 35.0) xAxis
    Cairo.showText cr "Break"

  legendY maxX maxY = do
    let
      yAxis = padding + 5.0
    Cairo.moveTo cr yAxis (yAxis + 6.0)
    Cairo.showText cr "Temperature"

  box :: Number -> Number -> Effect Unit
  box maxX maxY = do
    let
      maxX' = maxX - padding

      maxY' = maxY - padding
    Cairo.moveTo cr padding padding
    Cairo.setSourceRGB cr 0.8 0.8 0.8
    Cairo.lineTo cr maxX' padding
    Cairo.lineTo cr maxX' maxY'
    Cairo.lineTo cr padding maxY'
    Cairo.lineTo cr padding padding
    Cairo.stroke cr

  graph x y = do
    cutoff <- Ref.read cutoffRef
    slope <- Ref.read slopeRef
    Cairo.moveTo cr padding padding
    Cairo.setSourceRGB cr 0.0 0.0 0.0
    traverse_ (segment cutoff slope x y) (toNumber <$> L.range 0 (round x))
    Cairo.stroke cr

  segment :: Number -> Number -> Number -> Number -> Number -> Effect Unit
  segment cutoff slope maxX maxY x =
    let
      maxX' = maxX - padding * 2.0

      maxY' = maxY - padding * 2.0

      xn = x / maxX

      yn = chillTemperature cutoff slope xn

      y' = padding + (1.0 - yn) * maxY'

      x' = padding + xn * maxX'
    in
      Cairo.lineTo cr x' y'

mkPrefWidget :: Settings.Settings -> Effect Box
mkPrefWidget settings = do
  -- Options widget and state
  Tuple durationBox duration <- range "Work duration (in minutes)" 20.0 120.0 5.0
  Tuple workBox workEntry <- temp "Work temperature" "work-temp"
  Tuple chillBox chillEntry <- temp "Chill temperature" "chill-temp"
  Tuple cutoffBox cutoff <- range "Cutoff" 0.1 0.9 0.1
  Tuple slopeBox slope <- range "Slope" 1.0 100.0 0.1
  -- Bind schema to value
  _ <- GObject.signal_connect_closure settings "changed::duration" (onChange duration)
  val <- Settings.get_int settings "duration"
  Range.set_value duration (toNumber val)
  -- Drawing ref
  Tuple cutoffRef cutoffValue <- settingRef "cutoff"
  Range.set_value cutoff cutoffValue
  Tuple slopeRef slopeValue <- settingRef "slope"
  Range.set_value slope slopeValue
  -- Graph render
  drawing <- DrawingArea.new
  DrawingArea.set_draw_func drawing (drawCurve cutoffRef slopeRef)
  Gtk.set_size_request drawing (round graphX) (round graphY)
  -- Update drawing
  _ <- GObject.signal_connect_closure cutoff "value-changed" (onDrawingSettingChange cutoffRef cutoff drawing)
  _ <- GObject.signal_connect_closure slope "value-changed" (onDrawingSettingChange slopeRef slope drawing)
  -- Apply button
  apply <- Button.new_with_label "Apply"
  _ <- GObject.signal_connect_closure apply "clicked" (onApply duration workEntry chillEntry cutoff slope)
  -- Final layout
  box <- Box.new 1 5.0
  Box.append box durationBox
  Box.append box workBox
  Box.append box chillBox
  Box.append box cutoffBox
  Box.append box slopeBox
  Box.append box apply
  Box.append box drawing
  pure box
  where
  onDrawingSettingChange ref widget drawing = do
    value <- Range.get_value widget
    Ref.write value ref
    Gtk.queue_draw drawing

  settingRef name = do
    value <- Settings.get_double settings name
    ref <- Ref.new value
    pure $ Tuple ref value

  range labelText min max step = do
    label <- Label.new $ labelText <> ":"
    Gtk.set_size_request label 200 50
    scale <- Scale.new_with_range Orientation.horizontal min max step
    Gtk.set_size_request scale 300 50
    Scale.set_draw_value scale true
    box <- Box.new 0 5.0
    Box.append box label
    Box.append box scale
    pure $ Tuple box scale

  temp labelText name = do
    label <- Label.new $ labelText <> ":"
    Gtk.set_size_request label 200 50
    entry <- Entry.new
    eb <- Entry.get_buffer entry
    val <- Settings.get_int settings name
    EntryBuffer.set_text eb (show val)
    box <- Box.new 0 5.0
    tryButton <- Button.new_with_label "Try"
    _ <-
      GObject.signal_connect_closure tryButton "clicked"
        ( do
            vM <- fromString <$> EntryBuffer.get_text eb
            case vM of
              Just v -> do
                colorSettings <- Settings.new "org.gnome.settings-daemon.plugins.color"
                v' <- Variant.new_uint32 v
                void $ Settings.set_value colorSettings "night-light-temperature" v'
              Nothing -> GJS.log "Invalid value"
        )
    Box.append box label
    Box.append box entry
    Box.append box tryButton
    pure $ Tuple box eb

  onApply scale work chill cutoff slope = do
    GJS.log "onApply called"
    duration <- Range.get_value scale
    cutoffV <- Range.get_value cutoff
    slopeV <- Range.get_value slope
    workValueM <- fromString <$> EntryBuffer.get_text work
    chillValueM <- fromString <$> EntryBuffer.get_text chill
    void $ Settings.set_int settings "duration" (round duration)
    void $ Settings.set_double settings "cutoff" cutoffV
    void $ Settings.set_double settings "slope" slopeV
    case workValueM of
      Just workValue -> void $ Settings.set_int settings "work-temp" workValue
      Nothing -> GJS.log "Bad work value"
    case chillValueM of
      Just chillValue -> void $ Settings.set_int settings "chill-temp" chillValue
      Nothing -> GJS.log "Bad chill value"
    GJS.log $ "applied " <> show duration <> " " <> show workValueM <> " " <> show chillValueM

  onChange scale = do
    GJS.log "onChange called!"
    v <- toNumber <$> Settings.get_int settings "duration"
    GJS.log $ "to: " <> show v
    Range.set_value scale v
    Gtk.queue_draw scale
