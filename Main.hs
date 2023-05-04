import Board

-- Main function. We will simply call our gameLoop with
--   an empty board
main = do
  putStrLn $ take 20 $ repeat '\n'
  putStrLn "\nWelcome to tic-tac-toe!\n"
  putStrLn "To enter a move, type 'LN' where L is an uppercase letter signifying the column name and N is a number 0-9 signifying the row number.\n"
  putStrLn "Type 'exit' at any time to quit.\n"
  putStrLn "Two players or one? (1/2): "
  input <- getLine
  if input == "1" then
    -- One player, set the singlePlayer flag to true
    gameLoop emptyBoard 'x' True
  else if input == "2" then
    gameLoop emptyBoard 'x' False
  else if input == "exit" then
    return ()
  else do
    putStrLn "Invalid input. Please input a '1' or '2'"
    main

