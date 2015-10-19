module Main where

import Lib
import FRP.Netwire

main :: IO ()
main = testWire clockSession_ Lib.sqrIntegral

