module Main where

import LatticeLab
import System.Environment (getArgs)

patterns :: [(String, [String])]
patterns =
  [ ("blinker", [".#.", ".#.", ".#."])
  , ("glider", [".#.", "..#", "###"])
  , ("block", ["##", "##"])
  ]

findPattern :: String -> [String]
findPattern name = maybe (snd (head patterns)) snd (lookup name patterns)

main :: IO ()
main = do
  args <- getArgs
  let name = case args of (x:_) -> x; _ -> "blinker"
      generations = case args of (_:x:_) -> read x; _ -> 4
      initial = fromAscii (findPattern name)
  putStrLn ("rule=conway pattern=" ++ name ++ " generations=" ++ show generations)
  mapM_ (putStrLn . unlines . render) (evolve conway generations initial)
  putStrLn ("cycle=" ++ show (detectCycle conway initial))
