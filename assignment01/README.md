# 1st Practical Project

## Introduction

In this project, the goal is to develop the famous [Hex Game](https://en.wikipedia.org/wiki/Hex_(board_game)) in Prolog. Hex is a two player abstract strategy board game in which players attempt to connect opposite sides of a rhombus-shaped board made of hexagonal cells.

The Prolog program will allow two human players to play, using the standard input to enter game commands. The Hex board, points, and other info is displayed in the standard output. Hence, the input/output is text-based.

Optionally, the program could use [**Constraint Logic Programming (CLP)**](https://en.wikipedia.org/wiki/Constraint_logic_programming) in order to be more efficient.

In addition to allow playing by humans, the program should have an operation mode where a
human player plays against the computer. The computer player (AI player) is programmed using the [**Alpha-beta algorithm**](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning), an efficient implementation of the [**Minimax principle**](https://en.wikipedia.org/wiki/Minimax).

---

## Game Rules

The game is played on a hexagonal board with a variable number of rows and columns. The board is divided into hexagonal cells. Each player has a different piece color, and two opposite sides of the board. 
The two players take turns placing their pieces on the board. The first player to connect opposite sides of the board wins the game.

> A fun fact is that **draws are not possible** in Hex.
