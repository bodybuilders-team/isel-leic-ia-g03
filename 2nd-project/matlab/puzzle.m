% Function: puzzle
% ----------------------------
% Returns a puzzle of the given difficulty
%
% @param difficulty: The difficulty of the puzzle
% @return puzzle: The puzzle
function puzzle = puzzle(difficulty)
    puzzles = {
        % Easy
        [nan,nan,nan,9,nan,nan,5,1,7;
        nan,nan,5,nan,2,nan,nan,nan,nan;
        nan,9,nan,5,nan,nan,8,2,4;
        3,7,nan,nan,9,2,1,4,nan;
        4,nan,9,nan,1,nan,6,7,3;
        nan,nan,1,nan,3,nan,nan,nan,8;
        6,nan,3,nan,8,nan,4,nan,9;
        nan,nan,nan,nan,6,nan,nan,nan,1;
        nan,8,4,nan,nan,1,7,6,nan]

        % Medium
        [1,9,nan,8,4,nan,nan,nan,nan;
        nan,8,4,nan,nan,nan,6,9,nan;
        nan,nan,nan,nan,5,9,nan,4,nan;
        7,nan,2,9,nan,4,nan,3,nan;
        6,4,nan,nan,7,nan,5,nan,nan;
        nan,1,nan,nan,nan,nan,nan,7,nan;
        3,7,5,4,6,8,nan,nan,nan;
        nan,nan,nan,5,nan,nan,7,nan,3;
        nan,nan,nan,7,nan,nan,nan,nan,nan]

        % Hard
        [9,nan,2,nan,7,nan,3,nan,nan;
        nan,nan,nan,nan,nan,8,2,nan,nan;
        nan,nan,6,nan,nan,5,9,nan,nan;
        nan,nan,nan,nan,nan,nan,nan,nan,nan;
        nan,nan,9,nan,nan,7,nan,nan,5;
        nan,nan,1,3,nan,nan,6,nan,nan;
        8,2,nan,nan,nan,nan,nan,nan,nan;
        nan,nan,7,nan,nan,1,nan,nan,4;
        nan,1,nan,nan,8,nan,nan,nan,6]

        % Expert
        [9,6,nan,4,nan,5,nan,nan,nan;
        nan,nan,nan,nan,nan,nan,4,nan,nan;
        3,7,nan,nan,nan,nan,nan,nan,6;
        nan,3,1,6,nan,nan,nan,nan,nan;
        nan,nan,nan,8,3,nan,nan,nan,nan;
        nan,nan,nan,nan,4,nan,nan,nan,1;
        nan,nan,3,2,nan,nan,nan,nan,nan;
        4,nan,nan,nan,nan,nan,8,nan,nan;
        nan,1,8,nan,nan,6,7,5,nan]

        % Evil
        [nan,nan,nan,nan,nan,8,3,2,nan;
        nan,6,nan,nan,nan,nan,nan,nan,nan;
        3,4,nan,2,nan,nan,5,nan,nan;
        nan,nan,6,3,nan,nan,nan,nan,nan;
        1,3,nan,nan,nan,9,nan,nan,4;
        nan,nan,8,nan,nan,nan,1,nan,nan;
        nan,nan,nan,nan,7,nan,nan,nan,9;
        nan,nan,1,nan,nan,nan,nan,nan,nan;
        5,2,nan,8,nan,nan,4,nan,nan]
    };

    puzzle = puzzles{difficulty+1};
end