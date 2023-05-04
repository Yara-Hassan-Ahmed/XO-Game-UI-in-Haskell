module Helper(
   put,
   put2d,
   get2d,
   strArr,
   nextChar,
   allSame,
   diagUR,
   diagUL,
)
where

import Data.List
import Data.Char
import Data.Time.Clock.POSIX

-----------------------------
-----[Helper Functions]------
-----------------------------

-- Insert an item into an array
put :: Int -> a -> [a] -> [a]
put pos newVal list = take pos list ++ newVal : drop (pos+1) list

-- Insert an item into a 2d array
put2d :: Int -> Int -> a -> [[a]] -> [[a]]
put2d x y newVal mat = put y (put x newVal (mat!!y)) mat

-- Get an item from a 2d array
get2d :: Int -> Int -> [[a]]  -> a
get2d x y mat = (mat!!y)!!x

-- Converts an array of characters into an array of single-length strings
strArr :: String -> [String]
strArr = map (\x -> [x])

-- Get the next move ('x' -> 'o' -> 'x' -> etc.)
nextChar :: Char -> Char
nextChar current = if current == 'x' then 'o' else 'x'

-- Tests if all items in the list are the same
allSame :: Eq a => [a] -> Bool
allSame (x:xs) = all (==x) xs

-- Assumes square array
-- Get diagonal from upper right to lower left
diagUR :: [[a]] -> [a]
diagUR xs = [(xs!!n)!!n | n <- [0..(length xs) -1]]

-- Assumes square array
-- Get diagonal from upper left to lower right
diagUL :: [[a]] -> [a]
diagUL xs = [(xs!!n)!!(len - n -1) | n <- [0..len-1]]
  where len = length xs