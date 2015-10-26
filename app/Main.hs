{-# LANGUAGE FlexibleContexts #-}

module Main where

import Lib
import FRP.Netwire
import Control.Wire
import Control.Monad.IO.Class

main :: IO ()
main = do
  (wt', wire') <- return runIntProcess
  -- (d, w) <- stepWire test_ clockSession_ $ Right 0
  --(d, w) <- stepWire test_ clockSession_ $ Right 0
  --(d, w) <- return idStepTest 
  (d, w) <- ioStepTest
  print wt'
  return ()

runIntProcess :: (Either Int Int, Wire () Int Identity Int Int) 
runIntProcess = runProcess () 0

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

--runSimpleCount :: (Fractional t, Monad m, HasTime t (Session m (Timed NominalDiffTime ()))) => (Either t b, Wire s t Identity t t)
--runSimpleCount :: (Applicative m, Control.Monad.IO.Class.MonadIO m, Fractional t, HasTime t (Session m (Timed NominalDiffTime ())) ) => (Either t b, Wire s t m t t)
--runSimpleCount = runSimpleCount_ clockSession_ 0.0

--runSimpleCount_ :: (Fractional t, HasTime t s) => s -> t -> (Either t b, Wire s t Identity t t)
--runSimpleCount_ session initial = runProcess_ simpleCount session $ Right initial


type SimpleTime = Timed NominalDiffTime ()
type TimeSession m = Session m SimpleTime
type TimeSessionIO = TimeSession IO

--test :: (Real a, HasTime a TimeSessionIO) => IO (Either a a, Wire TimeSessionIO a IO a a) 
--test = return (Left 0, test_)

--idStepTest :: (Show a, HasTime a (TimeSession IO)) => (Either a a, Wire (TimeSession IO) a Identity a a)
--idStepTest = runIdentity $ stepTest

stepTest :: (Show a, Monad m, MonadIO io, HasTime a (TimeSession io)) => m (Either a a, Wire (TimeSession io) a m a a)
--stepTest :: (Monad m, HasTime t s) => m (Either a a, Wire s a IO a a) 
stepTest = stepWire test_ clockSession_ $ Right 0


ioStepTest :: (Real a, MonadIO m, HasTime a (TimeSession m)) => IO (Either a a, Wire (TimeSession m) a IO a a)
ioStepTest = stepWire test clockSession_ $ Right 0

test :: (Real a, HasTime a s) => Wire s a IO a a
test = test_

--test_ :: (Real a, MonadIO m, HasTime a (TimeSession m)) => Wire (TimeSession m) a m a a
--test_ :: (MonadIO m, HasTime t (Session m SimpleTime)) => Wire (Session m SimpleTime) a m a a
test_ :: (Real a, Monad m, HasTime a s) => Wire s a m a a
test_ = mkGen $ \s a -> return (simpleCount_ (dtime s) a, test_) 

--simpleCount :: (Real a, HasTime a s) => Wire s a m a a
--simpleCount = mkPure $ \s a -> do
--  (simpleCount_ (dtime s) a, simpleCount)

simpleCount_ :: (Real a) => a -> a -> Either a a
simpleCount_ dt x =
  if x < 10
  then Right (x + dt)
  else Left x


