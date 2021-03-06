{-# LANGUAGE OverloadedStrings, QuasiQuotes, StandaloneDeriving #-}
module Main (main) where

import Language.Prolog (consult, resolve, VariableName(..), Term(..))
import Language.Prolog.Quote (ts)

import System.Environment (getArgs)
import Control.DeepSeq (deepseq, NFData(rnf))

instance NFData Term where
   rnf (Struct a ts) = rnf a `seq` rnf ts
   rnf (Var v)       = rnf v
   rnf (Cut n)       = rnf n
   rnf Wildcard      = ()
instance NFData VariableName where
   rnf (VariableName i s) = rnf i `seq` rnf s


main = do
   args <- getArgs
   let n = case args of { [] -> 6; (x:_) -> read x }
   Right p <- consult "bench/queens.pl"
   putStrLn "Starting benchmark..."
   qs <- resolve p [ts|queens($n,Qs)|]
   putStrLn $ qs `deepseq` "Number of solutions: " ++ show (length qs)
