module Main where

import LatticeLab
import System.Exit (exitFailure)

assert :: Bool -> String -> IO ()
assert ok message = if ok then pure () else putStrLn message >> exitFailure

main :: IO ()
main = do
  let block = fromAscii ["##", "##"]
      blinker = fromAscii [".#.", ".#.", ".#."]
  golden <- lines <$> readFile "test/golden/blinker.txt"
  assert (render (step conway block) == ["##", "##"]) "block is not stable"
  assert (render (step conway blinker) == ["...", "###", "..."]) "blinker did not rotate"
  assert (render (step conway (step conway blinker)) == golden) "blinker golden failed"
  assert (birth highLife == [3, 6]) "HighLife rule definition changed"
  assert (survive seeds == []) "Seeds rule definition changed"
  assert (detectCycle conway block == Just (1, 0)) "cycle detection failed"
  putStrLn "golden: all cellular automata checks passed"
