module Lib
    ( baseIntegral
    , sqrIntegral
    ) where

import Prelude hiding ((.))
import Control.Wire
import FRP.Netwire

baseIntegral :: (Monad m, HasTime t s, Fractional a) => Wire s () m a a
baseIntegral = integral 0 . 1

sqrIntegral :: (Monad m, HasTime t s, Fractional t) => Wire s () m a t
sqrIntegral = integral 0 . time


