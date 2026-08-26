module LatticeLab
  ( Cell
  , Grid
  , Rule(..)
  , conway
  , highLife
  , seeds
  , fromAscii
  , render
  , step
  , evolve
  , detectCycle
  ) where

import Data.List (intercalate, nub)
import qualified Data.Set as Set

type Cell = (Int, Int)
data Grid = Grid { width :: Int, height :: Int, live :: Set.Set Cell }
  deriving (Eq, Ord, Show)

data Rule = Rule
  { birth :: [Int]
  , survive :: [Int]
  } deriving (Eq, Show)

conway, highLife, seeds :: Rule
conway = Rule [3] [2, 3]
highLife = Rule [3, 6] [2, 3]
seeds = Rule [2] []

fromAscii :: [String] -> Grid
fromAscii rows = Grid w h $ Set.fromList
  [ (x, y) | (y, row) <- zip [0..] rows, (x, c) <- zip [0..] row, c `elem` "#O" ]
  where
    h = length rows
    w = maximum (0 : map length rows)

render :: Grid -> [String]
render (Grid w h cells) =
  [ [ if Set.member (x, y) cells then '#' else '.'
    | x <- [0 .. w - 1] ] | y <- [0 .. h - 1] ]

neighbors :: Grid -> Cell -> [Cell]
neighbors (Grid w h _) (x, y) =
  [ (nx, ny)
  | dx <- [-1..1], dy <- [-1..1], (dx, dy) /= (0, 0)
  , let nx = x + dx, let ny = y + dy
  , nx >= 0, nx < w, ny >= 0, ny < h
  ]

step :: Rule -> Grid -> Grid
step rule grid@(Grid _ _ cells) = grid { live = Set.fromList next }
  where
    candidates = nub (concatMap (\cell -> cell : neighbors grid cell) (Set.toList cells))
    next = [ cell | cell <- candidates
                  , let count = length (filter (`Set.member` cells) (neighbors grid cell))
                  , if Set.member cell cells then count `elem` survive rule
                    else count `elem` birth rule ]

evolve :: Rule -> Int -> Grid -> [Grid]
evolve rule count grid = take (count + 1) (iterate (step rule) grid)

detectCycle :: Rule -> Grid -> Maybe (Int, Int)
detectCycle rule grid = go 0 Set.empty grid
  where
    go n seen current
      | Set.member current seen = Just (n, n - 1)
      | n > width current * height current * 4 + 1000 = Nothing
      | otherwise = go (n + 1) (Set.insert current seen) (step rule current)
