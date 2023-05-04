module Board(
   Board(..),
   Move,
   emptyBoard,
   gameLoop,
   getCPUMove,
   doMove,
   parseMove,
   boardStr,
   isWinner,
   catsGame,
)

where
import Helper
import Data.List
import Data.Char
import Data.Time.Clock.POSIX

-- A board is a list of strings
-- We will use characters to represent tile states
--   player occupies a tile with an 'x'
--   computer occupies a tile with an 'o'
--   unoccupied tiles contain a space character
type Board = [[Char]]

-- A move is an x,y pair of ints
type Move = (Int, Int)


-- Our 3x3 empty board begins with all space characters
emptyBoard = ["   ", "   ", "   "]

-- 2 Player Game Loop
-- The variable `playerChar` keeps track of who's
--   turn it is and the variable `board` keeps track
--   of the state of the board.
-- Since haskell doesn't use loops, we will save the
--   game state by recursively passing the board to the gameLoop
gameLoop :: Board -> Char -> Bool -> IO()
gameLoop board playerChar singlePlayer = do
  -- Single Player, CPU's turn
  if singlePlayer && (playerChar == 'o') then do
    -- Get the system time to use as a seed for generating the CPUs move
    ms <- round `fmap` getPOSIXTime
    let cpuMove = getCPUMove board ms
    -- Apply the move to the board
    let newBoardTuple = doMove board cpuMove playerChar
    let newBoard = fst newBoardTuple
    -- Check for winner
    if isWinner newBoard cpuMove then do
      putStrLn $ boardStr newBoard
      putStrLn "CPU wins!"

    -- Check for tie
    else if catsGame newBoard then do
      putStrLn $ boardStr newBoard
      putStrLn "Tie game!"

    else
      -- No win, no tie: continue playing, set the playerchar to 'x'
      gameLoop newBoard (nextChar playerChar) singlePlayer
  -- 2 Player game or players turn for single player game
  else do
    putStrLn $ "\n" ++ (boardStr board) ++ "\n"
    putStrLn $ "Player " ++ [playerChar] ++ ", please enter a move: "
    line <- getLine
    -- Print 20 empty lines on the screen
    putStrLn $ take 20 $ repeat '\n'
    -- If the input is 'exit', then exit the program
    if "exit" == line then
      return ()
    else do
      -- Get the player's move and parse
      let move = parseMove line
      -- The move is valid
      if snd move then do
        -- Apply the move to the board
        let newBoardTuple = doMove board (fst move) playerChar
        if snd newBoardTuple then do
          -- The newBoard var contains the updated board
          let newBoard = fst newBoardTuple
          -- Check for winner
          if (isWinner newBoard (fst move)) then do
            putStrLn $ boardStr newBoard
            putStrLn $ "Player " ++ [playerChar] ++ " is the winner!"

          -- Check for tie
          else if catsGame newBoard then do
            putStrLn $ boardStr newBoard
            putStrLn $ "Tie Game!"

          else
            -- No win, no tie: continue game
            gameLoop newBoard (nextChar playerChar) singlePlayer
        -- The move was parsed properly, but rejected by the board
        -- This means the move was out of bounds or already taken
        else do
          putStrLn "Out of bounds! / Player already there!"
          putStrLn "Please try again."
          gameLoop board playerChar singlePlayer
      -- The move was invalid (parser could not determine it)
      else do
        putStrLn "Invalid move.\nPlease try again."
        gameLoop board playerChar singlePlayer



-- Get a random move. The recursive nature of this function
--   always guarenntees a valid move
getCPUMove :: Board -> Int -> Move
getCPUMove board seed
  | snd $ doMove board (x,y) 'o'  = (x,y)
  | otherwise                     = getCPUMove board ((7*seed)+67) -- Generate a new 'seed'
  where
    size  = length board
    x     = seed `mod` size
    y     = (seed `div` 10) `mod` size



-- This function will return the state of the board after
--   applying the move. If the move is invalid, the original
--   board state will be returned and the Bool value will
--   be flagged as false indicating an invalid move.
doMove :: Board -> Move -> Char -> (Board, Bool)
doMove b m player
    | x < 0 || y < 0 || x >= w || y >= h  = (b, False) -- Out of bounds
    | get2d x y b /= ' '                  = (b, False) -- Location already taken
    | otherwise                           = (put2d x y player b, True)
  where
    x = fst m  -- x coordinate for the move
    y = snd m  -- y coordinate for the move
    w = length $ head b  -- width of board
    h = length b -- height of board


-- Parses a move string (ex: "A2") into a Move
-- Also returns a Bool value representing whether or not the move is valid
parseMove :: String -> (Move, Bool)
parseMove str
    | length str /= 2                             = badMove -- Other than 2 chars
    | (elem l ['A'..'Z']) && (elem n ['0'..'9'])  = ( ((ord l)-65, (ord n)-48), True )
    | otherwise                                   = badMove -- Invalid Move
  where
    l = str!!0 -- Char letter
    n = str!!1 -- Char number
    badMove = ((0,0), False)


-- Converts a NxN size board into a string with row and col labels
boardStr :: Board -> String
boardStr board =
  -- Put it all together
  letterHeader ++ "\n\n" ++ (intercalate rowSep $ labelRowStr $ map rowStr board)
  where
    width         = length $ head board
    -- Place vertical bars between x's and o's in a row
    rowStr        = intercalate " | " . map (\x -> [x])
    -- Add 1,2..n to the front of each row
    labelRowStr s = [(show n) ++ "  " ++ x | n <- [0..(length s)-1], x <- [s!!n]]
    -- Header A,B..Z labels
    letterHeader  = "   " ++ (intercalate "   " $ strArr $ take width ['A'..])
    -- Generate row separaters ("---+---+---")
    rowSep        = "\n   " ++ (tail $ init $ intercalate "+" $ take width $ repeat "---") ++ "\n"


-- Tests if there is a winner
-- Since the board is only updated where the last move takes place
--   it is sufficient to check only the row and column where that
--   move is located. We also check the two diagonals.
isWinner :: Board -> Move -> Bool
isWinner b m = vert || horiz || diagUpperLeft || diagUpperRight
  where
    dUL             = diagUL b -- The upper left daigonal array
    dUR             = diagUR b -- The upper right diaganal array
    -- Test if any of the diag, vert, or horiz contain all the same cahracter (a winner)
    vert            = allSame $ b !! (snd m)
    horiz           = allSame $ map (!! (fst m)) b
    diagUpperLeft   = (not $ all (== ' ') dUL) && (allSame dUL)
    diagUpperRight  = (not $ all (== ' ') dUR) && (allSame dUR)

-- Tests if the board contains no space characters
catsGame :: Board -> Bool
catsGame = not . foldr1 (||) . map (any(==' '))
