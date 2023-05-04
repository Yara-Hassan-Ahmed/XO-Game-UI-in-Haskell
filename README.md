# XO-Game-UI-in-Haskell
This project provides an interactive UI for playing the classic game of tic-tac-toe, implemented in Haskell.

# Usage
To use this XO game UI project, you will need to have Haskell installed on your system. After cloning the project, navigate to the project directory in your terminal and run the command "stack run" to build and run the project.

# Project Structure
The project structure consists of two Haskell modules: "Board" and "Helper". The "Board" module defines the game logic and the game loop for playing tic-tac-toe, while the "Helper" module contains utility functions that are used by the "Board" module. The project also includes a main function that provides a user interface for playing the game.

# Functions

The "Board" module defines the following functions:

  emptyBoard: creates an empty 3x3 board filled with space characters.
  gameLoop: handles the game loop for playing tic-tac-toe.
  getComputerMove: returns the computer's next move.
  applyMove: applies a move to the board.
  parseMoveInput: parses a player's move input.
  renderBoard: renders the board as a string.
  checkWin: checks if a player has won the game.
  checkTie: checks if the game has ended in a tie.
  
The "Helper" module defines the following functions:

  insertAt: inserts an item into an array at a specified index.
  getAt: retrieves an item from an array at a specified index.
  splitIntoSingletons: splits an array of characters into an array of single-length strings.
  getNextMove: returns the next move (either 'x' or 'o').
  allSame: checks if all items in a list are identical.
  getDiagonals: retrieves the diagonal elements of a 2D array.
  
The above functions are called and used in the project's main function to provide the user interface for playing the game of tic-tac-toe.
