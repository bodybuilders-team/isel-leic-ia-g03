% ================ Hex Game in Prolog ================
% See: https://en.wikipedia.org/wiki/Hex_(board_game)
% ====================================================
% @ISEL, 2022-2023 Summer Semester
% BSc in Computer Science and Engineering
% Artificial Intelligence
% ====================================================
% Authors:
%   - 48280 André Jesus
%   - 48287 Nyckollas Brandão
% Professor:
%   - Nuno Leite
% ====================================================
% To run the game, use this query: 
% ?- play.
%
% Player 1 plays with black pieces and wins if they connect the top and bottom sides of the board.
% Player 2 plays with white pieces and wins if they connect the left and right sides of the board.
% ====================================================

% Explanation of the game rules
help :-
    writeln('Welcome to the Prolog Hex Game!'),
    writeln('The game is played on a hexagonal grid, with two players taking turns to place their pieces on the board.'),
    writeln('The goal is to connect the top and bottom sides of the board for Player 1 (black) or the left and right sides of the board for Player 2 (white).'),
    writeln('The game is over when one of the players has connected the sides of the board.'),
    writeln('The game can be played in two modes: PvP or PvC.'),
    writeln('In PvP mode, the players take turns to place their pieces on the board.'),
    writeln('In PvC mode, the player plays against the computer.'),
    writeln('The computer uses the minimax algorithm to determine the best move.'),
    writeln('The game can be played with a board of size 2 to 11.'),
    writeln('To start the game, use the query: play.'),
    writeln('To exit the game, use the query: halt.').

% Start the game
play :-
    writeln('Welcome to the Prolog Hex Game! Use the query \'help.\' to see the game rules.'),
    get_game_mode(GameMode),
    get_board_size(BoardSize),
    create_board(BoardSize, Board),
    display_board(Board),
    play(GameMode, Board).
 
% Gets the game mode
get_game_mode(GameMode):-
    write('Please enter the game mode [0(PvP)/1(PvC)]: '),
    read(GameMode),
    between(0, 1, GameMode).

% Gets the board size from the user
get_board_size(BoardSize):-
    write('Please enter the board size [2-11]: '),
    read(BoardSize).

% ==============================================
% ============== Board Creation ================
% ==============================================

% Creates a board with the given size
create_board(BoardSize, Board):-
    between(2, 11, BoardSize),
    create_board_r(BoardSize, BoardSize, Board).

% Creates a board recursively
create_board_r(0, _, []).
create_board_r(Iter, BoardSize, [Row|Board]):-
    create_row(BoardSize, Row),
    NewIter is Iter - 1,
    create_board_r(NewIter, BoardSize, Board).

% Creates a row with the given size
create_row(0, []).
create_row(Iter, [0|Row]):-
    NewIter is Iter - 1,
    create_row(NewIter, Row).

% ==============================================
% ============== Board Display =================
% ==============================================

% Displays the board
display_board(Board):-
    display_column_letters(Board, 'A'),
    display_board_r(Board, 1),
    display_column_letters(Board, 'A').

% Displays the column letters
display_column_letters([], _):- nl.
display_column_letters([_|Board], L):-
    write(' '), write(L),
    char_code(L, LCode),
    NewLCode is LCode + 1,
    char_code(NewL, NewLCode), 
    display_column_letters(Board, NewL).

% Displays the board recursively
display_board_r([], RowNumber) :-
    NumberOfSpaces is RowNumber + 1,
    print_spaces(NumberOfSpaces).
display_board_r([Row|Board], RowNumber):-
    print_spaces(RowNumber),
    write(RowNumber), write(' '),
    display_row(Row),
    writeln(RowNumber),
    NewRowNumber is RowNumber + 1,
    display_board_r(Board, NewRowNumber).

% Prints the spaces before a row
print_spaces(1).
print_spaces(SpacesRemaining):-
    SpacesRemaining > 1,
    write(' '),
    NewSpacesRemaining is SpacesRemaining - 1,
    print_spaces(NewSpacesRemaining).

% Displays a row
% 0 - Empty cell
% 1 - Player 1 (Black)
% 2 - Player 2 (White)
display_row([]).
display_row([0|Row]):-
    write('. '),
    display_row(Row).
display_row([1|Row]):-
    write('\u2b22 '),
    display_row(Row).
display_row([2|Row]):-
    write('\u2b21 '),
    display_row(Row).

% ==============================================
% ============== Gameplay =====================
% ==============================================

% GameMode: 0 - PvP, 1 - PvC

% Play the game in PvP Mode
play(0, Board):-
    play_game_pvp_r(Board, 1).
% Play the game in PvC Mode
play(1, Board):-
    play_game_pvc_r(Board, 1).


% ========================================================
% =================== Player vs Player ===================
% ========================================================

% Play the game in PvP Mode recursively
play_game_pvp_r(Board, CurrentPlayer):-
    prompt_player(CurrentPlayer, Move),
    (
        parse_move(Move, Row, Column),
        validate_move(Row, Column, Board)
            ->  (
                    make_move(Row, Column, CurrentPlayer, Board, NewBoard),
                    display_board(NewBoard),

                    (
                        check_win(NewBoard, CurrentPlayer)
                            -> !, write('Player '), write(CurrentPlayer), writeln(' has won!')
                            ; (
                                switch_player(CurrentPlayer, NextPlayer),
                                play_game_pvp_r(NewBoard, NextPlayer)
                            )
                    )
            )
            ; (
                writeln('Invalid move! The move must be in the board and the cell must be empty. Try again [row/column] e.g. 1/a.'),
                play_game_pvp_r(Board, CurrentPlayer)
            )
    ).

% ==============================================
% ============== Win Check =====================
% ==============================================

% Check if the given player has won
check_win(Board, Player) :-
    (
        Player = 1, check_top_bottom(Board) ; 
        Player = 2, check_left_right(Board)
    ).

% Check if player 1 has connected the top and bottom sides
check_top_bottom(Board) :-
    get_board_size(Board, BoardSize),
    end_node(1, EndNode, BoardSize),
    get_start_nodes(Board, 1, StartNodes),
    member(StartNode, StartNodes),
    dfs(Board, StartNode, EndNode, 1).

% Check if player 2 has connected the left and right sides
check_left_right(Board) :-
    get_board_size(Board, BoardSize),
    end_node(2, EndNode, BoardSize),
    get_start_nodes(Board, 2, StartNodes),
    member(StartNode, StartNodes),
    dfs(Board, StartNode, EndNode, 2).

% Define start node based on player
start_node(1, (1, _)).
start_node(2, (_, 1)).

% Get the start nodes for a given player
% A start node is a cell that belongs to the player and is on the edge of the board
get_start_nodes(Board, Player, StartNodes) :-
    findall(StartNode, (
        start_node(Player, StartNode),
        StartNode = (Row, Column),
        get_cell(Board, Row, Column, Cell),
        Cell = Player
    ), StartNodes).

% Define end node based on player and board size
end_node(1, (BoardSize, _), BoardSize).
end_node(2, (_, BoardSize), BoardSize).

% Get the adjacent cells for a given cell that belong to the same player
get_adjacent_cells(Board, (Row,Column), Player, AdjacentCells) :-
    findall((AdjacentRow,AdjacentColumn), (
        (AdjacentRow is Row-1, AdjacentColumn is Column,     % above
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ;   (AdjacentRow is Row-1, AdjacentColumn is Column+1,   % above right
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ;   (AdjacentRow is Row, AdjacentColumn is Column-1,     % left
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ;   (AdjacentRow is Row, AdjacentColumn is Column+1,     % right
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ;   (AdjacentRow is Row+1, AdjacentColumn is Column,     % below
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ;   (AdjacentRow is Row+1, AdjacentColumn is Column-1,   % below left
        get_cell(Board, AdjacentRow, AdjacentColumn, Player))
    ), AdjacentCells).

% Depth-first search
dfs(Board, StartNode, EndNode, Player) :-
    dfs_r(Board, StartNode, EndNode, Player, [StartNode]).

% Depth-first search recursive
dfs_r(_, StartNode, EndNode, _, _) :-
    StartNode = EndNode.
dfs_r(Board, StartNode, EndNode, Player, Visited) :-
    StartNode \= EndNode,
    get_adjacent_cells(Board, StartNode, Player, AdjacentCells),
    member(AdjacentCell, AdjacentCells),
    \+ member(AdjacentCell, Visited),
    dfs_r(Board, AdjacentCell, EndNode, Player, [AdjacentCell|Visited]).

% ==============================================
% ============= Player vs Computer =============
% ==============================================

% Play the game in PvC Mode recursively
play_game_pvc_r(Board, Player):-
    prompt_player(Player, Move),
    (
        parse_move(Move, Row, Column),
        validate_move(Row, Column, Board)
            ->  (
                    make_move(Row, Column, Player, Board, NewBoard),
                    display_board(NewBoard),
                    (
                        check_win(NewBoard, Player)
                            -> !, write('Player '), write(Player), writeln(' has won!')
                            ; (
                                switch_player(Player, Computer),
                                get_computer_move(NewBoard, Computer, ComputerRow, ComputerColumn),
                                get_column_letter(ComputerColumn, ComputerColumnLetter),
                                write('Computer played: '), write(ComputerRow), write('/'), write(ComputerColumnLetter), nl,
                                make_move(ComputerRow, ComputerColumn, Computer, NewBoard, NewNewBoard),
                                display_board(NewNewBoard),

                                (
                                    check_win(NewNewBoard, Computer)
                                        -> !, writeln('Computer has won!')
                                        ; play_game_pvc_r(NewNewBoard, Player)
                                )
                            )
                    )
            )
            ; (
                writeln('Invalid move! The move must be in the board and the cell must be empty. Try again [row/column] e.g. 1/a.'),
                play_game_pvc_r(Board, Player)
            )
    ).

% Get the computer move using minimax algorithm
get_computer_move(Board, Computer, Row, Column):-
    get_board_size(Board, BoardSize),
    % Call minimax to get the optimal move
    minimax(Board, Computer, BoardSize, Row, Column).

% Minimax algorithm to find the optimal move for the computer
minimax(Board, Player, BoardSize, BestRow, BestColumn):-
    % Set the maximum depth for the minimax algorithm
    % We set based on the board size, because the bigger the board, the more moves the computer has to calculate per depth
    minimax_depth_by_board_size(BoardSize, Depth),

    % Initialize alpha and beta values
    Alpha is -1000000,
    Beta is 1000000,

    max_value(Board, Player, Depth, BoardSize, Alpha, Beta, _, BestRow, BestColumn).

% Calculate the maximum value for the current player
% Parameters: Board, Player, Depth, BoardSize, Alpha, Beta
% Return: BestEval, BestRow, BestColumn
max_value(Board, Player, Depth, BoardSize, Alpha, Beta, BestEval, BestRow, BestColumn):-
    CurrentBestEval is -1000000,

    get_all_possible_moves(Board, BoardSize, Moves),

    max_value_loop(Board, Player, Depth, BoardSize, Moves, Alpha, Beta, CurrentBestEval, BestEval, _, (BestRow, BestColumn)).

% Loop through all the possible moves and calculate the maximum value
% Parameters: Board, Player, Depth, BoardSize, Moves, Alpha, Beta, CurrentBestEval, CurrentBestMove
% Return: BestEval, BestMove
max_value_loop(_, _, _, _, [], _, _, CurrentBestEval, BestEval, CurrentBestMove, BestMove):- % Reaching the end of the list, return the current best
    BestEval is CurrentBestEval,
    BestMove = CurrentBestMove.
max_value_loop(Board, Player, Depth, BoardSize, [Move|Rest], Alpha, Beta, CurrentBestEval, BestEval, CurrentBestMove, BestMove):-
    % Make the move on a dummy board
    Move = (Row, Column),
    make_move(Row, Column, Player, Board, NewBoard),
    (
        % Check if the game is over
        check_win(NewBoard, Player)
            -> (
                BestEval is Depth,
                BestMove = Move
            )
            ; (
                (Depth = 0) -> (
                    % If the depth is 0, calculate the heuristic value
                    evaluate_board(NewBoard, Player, BoardSize, Eval),
                    BestEval is Eval,
                    BestMove = Move
                )
                ;
                (
                    % Switch the player and decrease the depth, and calculate the best score for the other player
                    switch_player(Player, OtherPlayer),
                    NewDepth is Depth - 1,
                    min_value(NewBoard, OtherPlayer, NewDepth, BoardSize, Alpha, Beta, ChildEval, _, _),

                    % Update the maximum value
                    (
                        ChildEval > CurrentBestEval
                            -> (
                                NewCurrentBestEval is ChildEval,
                                NewCurrentBestMove = Move,
                                NewAlpha is max(Alpha, ChildEval)
                            )
                            ; (
                                NewCurrentBestEval is CurrentBestEval,
                                NewCurrentBestMove = CurrentBestMove,
                                NewAlpha is Alpha
                            )
                    ),
                    (
                        Beta =< NewAlpha % Prune
                            -> (
                                BestEval is NewCurrentBestEval, 
                                BestMove = NewCurrentBestMove
                            )
                            ; max_value_loop(Board, Player, Depth, BoardSize, Rest, NewAlpha, Beta, NewCurrentBestEval, BestEval, NewCurrentBestMove, BestMove)
                    )
                )
            )
    ).

% Calculate the minimum value for the current player
% Parameters: Board, Player, Depth, BoardSize, Alpha, Beta
% Return: BestEval, BestRow, BestColumn
min_value(Board, Player, Depth, BoardSize, Alpha, Beta, BestEval, BestRow, BestColumn):-
    CurrentBestEval is 1000000,

    get_all_possible_moves(Board, BoardSize, Moves),

    min_value_loop(Board, Player, Depth, BoardSize, Moves, Alpha, Beta, CurrentBestEval, BestEval, _, (BestRow, BestColumn)).

% Loop through all the possible moves and calculate the minimum value
% Parameters: Board, Player, Depth, BoardSize, Moves, Alpha, Beta, CurrentBestEval, CurrentBestMove
% Return: BestEval, BestMove
min_value_loop(_, _, _, _, [], _, _, CurrentBestEval, BestEval, CurrentBestMove, BestMove):- % Reaching the end of the list, return the current best
    BestEval is CurrentBestEval,
    BestMove = CurrentBestMove.
min_value_loop(Board, Player, Depth, BoardSize, [Move|Rest], Alpha, Beta, CurrentBestEval, BestEval, CurrentBestMove, BestMove):-
    % Make the move on a dummy board
    Move = (Row, Column),
    make_move(Row, Column, Player, Board, NewBoard),
    (
        % Check if the game is over
        check_win(NewBoard, Player)
            -> (
                BestEval is -Depth, 
                BestMove = Move
            )
            ; (
                (Depth = 0) -> (
                    % If the depth is 0, calculate the heuristic value
                    evaluate_board(NewBoard, Player, BoardSize, Eval),
                    BestEval is Eval,
                    BestMove = Move
                )
                ;
                (
                    % Switch the player and decrease the depth, and calculate the best score for the other player
                    switch_player(Player, OtherPlayer),
                    NewDepth is Depth - 1,
                    max_value(NewBoard, OtherPlayer, NewDepth, BoardSize, Alpha, Beta, ChildEval, _, _),

                    % Update the minimum value
                    (
                        ChildEval < CurrentBestEval
                            -> (
                                NewCurrentBestEval is ChildEval,
                                NewCurrentBestMove = Move,
                                NewBeta is min(Beta, ChildEval)
                            )
                            ; (
                                NewCurrentBestEval is CurrentBestEval,
                                NewCurrentBestMove = CurrentBestMove,
                                NewBeta is Beta
                            )
                    ),
                    (
                        NewBeta =< Alpha % Prune
                            -> (
                                BestEval is NewCurrentBestEval, 
                                BestMove = NewCurrentBestMove
                            )
                            ; min_value_loop(Board, Player, Depth, BoardSize, Rest, Alpha, NewBeta, NewCurrentBestEval, BestEval, NewCurrentBestMove, BestMove)
                    )
                )
            )
    ).

% Get all possible moves for the current player
get_all_possible_moves(Board, BoardSize, Moves):-
    findall((Row, Column),(
        between(1, BoardSize, Row),
        between(1, BoardSize, Column),
        get_cell(Board, Row, Column, 0)
    ), Moves).

% Evaluates the heuristic value of the board for the player, for now it's 0 (reached final depth)
evaluate_board(_, _, _, Eval):-
    Eval is 0.

% Sets depth based on the board size. The bigger the board, the more moves the computer has to calculate per depth level.
minimax_depth_by_board_size(BoardSize, Depth):-
    (BoardSize, Depth) = (2, 10);
    (BoardSize, Depth) = (3, 10);
    (BoardSize, Depth) = (4, 5);
    (BoardSize, Depth) = (5, 4);
    (BoardSize, Depth) = (6, 3);
    (BoardSize, Depth) = (7, 3);
    (BoardSize, Depth) = (8, 3);
    (BoardSize, Depth) = (9, 3);
    (BoardSize, Depth) = (10, 3);
    (BoardSize, Depth) = (11, 3).

% ===========================================================================
% ===========================================================================
% ===========================================================================
% ===========================================================================
% ===========================================================================

% Make a move on the board
make_move(Row, Column, Player, Board, NewBoard):-
    replace(Board, Row, Column, Player, NewBoard).

% Replace a cell in the board
replace(Board, Row, Column, Player, NewBoard):-
    nth1(Row, Board, RowList, Rest),
    nth1(Column, RowList, _, Transfer),
    % Backwards
    nth1(Column, NewRowList, Player, Transfer),
    nth1(Row, NewBoard, NewRowList, Rest).

% Prompt the player for a move
prompt_player(Player, Move):-
    write('Player '), write(Player), write(', please enter your move [row/column]: '),
    read(Move).

% Switch the player
switch_player(1, 2).
switch_player(2, 1).

% Validate a move on the board
validate_move(Row, Column, Board):-
    get_board_size(Board, BoardSize),
    between(1, BoardSize, Row),
    between(1, BoardSize, Column),
    get_cell(Board, Row, Column, 0).

% Get a cell from the board
get_cell(Board, Row, Column, Cell):-
    nth1(Row, Board, RowCells),
    nth1(Column, RowCells, Cell).

% Parse a move
parse_move(Move, Row, Column):-
    term_string(Move, MoveStr),
    split_string(MoveStr, "/", "", [RowStr, ColumnStr]),
    number_string(Row, RowStr),
    string_chars(ColumnStr, [ColumnChar]),
    char_code(ColumnChar, ColumnCode),
    Column is ColumnCode - 96.

% Get the column letter from the column number
get_column_letter(ComputerColumn, ComputerColumnLetter):-
    ColumnCode is ComputerColumn + 96,
    char_code(ComputerColumnLetter, ColumnCode).

% Get the board size
get_board_size(Board, BoardSize):-
    get_board_size_r(Board, 0, BoardSize).

% Get the board size recursively
get_board_size_r([], Iter, BoardSize):-
    BoardSize is Iter.
get_board_size_r([_|Board], Iter, BoardSize):-
    NewIter is Iter + 1,
    get_board_size_r(Board, NewIter, BoardSize).
