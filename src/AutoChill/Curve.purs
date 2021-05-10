module AutoChill.Curve where

import Prelude

chillTemperature :: Number -> Number
chillTemperature time = temp
  where
    cutoff = 0.5
    slope = 3.0
    x = max 0.0 (time - cutoff)
    y = 1.0 - (x * x * slope)
    temp = max 0.0 y
    -- max(0, 1 - (max(0, x - 0.5) * max(0, x - 0.5) * 3))
