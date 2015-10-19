module Main where

import Lib
import FRP.Netwire
import Control.Wire

main :: IO ()
main = do
  (st, session') <- stepSession clockSession_
  (wt', wire') <- return $ runProcess session' 0
  print wt'
  return ()

runProcess :: s -> Int -> (Either Int Int, Wire s Int Identity Int Int) 
runProcess session initial = runProcess_ process session $ Right initial

runProcess_ :: Wire s a Identity t t -> s -> Either a t -> (Either a b, Wire s a Identity t t)
runProcess_ wire session (Left x) = (Left x, wire)
runProcess_ wire session state = 
  runProcess_ wire' session state'
  where (state', wire') = runIdentity $ stepWire wire session state

process :: Wire s Int Identity Int Int
process = mkPure_ $ process_

process_ :: Int -> Either Int Int
process_ x =
  if x < 10
  then Right (x + 1)
  else Left x


