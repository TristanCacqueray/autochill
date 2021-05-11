-- | The AutoChill formula
module AutoChill.Curve where

import Prelude

chillTemperature :: Number -> Number -> Number -> Number
chillTemperature cutoff slope time = temp
  where
    x = max 0.0 (time - cutoff)
    y = 1.0 - (x * x * slope)
    temp = max 0.0 y
