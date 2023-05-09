% ============= Sudoku Solver in MATLAB ==============
% See: https://en.wikipedia.org/wiki/Sudoku
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
% To run the solver, run the "sudoku" function
% ====================================================

function sa_sudoku()
    disp('Welcome to the Sudoku Solver in MATLAB!');
    
    difficulty = input('Choose the difficulty of the puzzle [0-3]: ');
    while ~(difficulty >= 0 && difficulty <= 3)
        difficulty = input('Invalid input! Please choose a difficulty between 0 and 3: ');
    end
    
    puzzles = {
        [nan,nan,5,2,6,9,7,8,1;
         6,8,2,5,7,1,4,9,3;
         1,nan,7,8,3,4,5,6,2;
         8,2,6,1,nan,5,3,nan,7;
         3,7,4,6,8,2,9,1,5;
         9,5,1,7,4,3,6,2,8;
         5,1,9,nan,2,6,8,7,4;
         2,4,8,9,5,7,1,3,6;
         7,6,3,4,1,8,2,5,nan]

        [5,nan,nan,6,nan,1,nan,nan,nan;
        nan,3,nan,nan,7,5,nan,4,9;
        nan,nan,nan,9,4,8,nan,nan,nan;
        1,5,7,nan,nan,nan,nan,nan,nan;
        nan,9,6,nan,nan,nan,2,nan,8;
        2,nan,nan,1,6,9,nan,5,nan;
        4,1,nan,3,nan,7,nan,6,nan;
        nan,2,nan,5,1,nan,3,7,nan;
        7,nan,3,4,nan,nan,1,8,nan]
    
        [nan,nan,nan,6,nan,nan,4,nan,nan;
        7,nan,nan,nan,nan,3,6,nan,nan;
        nan,nan,nan,nan,9,1,nan,8,nan;
        nan,nan,nan,nan,nan,nan,nan,nan,nan;
        nan,5,nan,1,8,nan,nan,nan,3;
        nan,nan,nan,3,nan,6,nan,4,5;
        nan,4,nan,2,nan,nan,nan,6,nan;
        9,nan,3,nan,nan,nan,nan,nan,nan;
        nan,2,nan,nan,nan,nan,1,nan,nan]
        
        [nan,nan,nan,nan,nan,nan,nan,nan,nan;
        nan,nan,nan,nan,nan,3,nan,8,5;
        nan,nan,1,nan,2,nan,nan,nan,nan;
        nan,nan,nan,5,nan,7,nan,nan,nan;
        nan,nan,4,nan,nan,nan,1,nan,nan;
        nan,9,nan,nan,nan,nan,nan,nan,nan;
        5,nan,nan,nan,nan,nan,nan,7,3;
        nan,nan,2,nan,1,nan,nan,nan,nan;
        nan,nan,nan,nan,4,nan,nan,nan,9]
    };

    puzzle = puzzles{difficulty+1};

    disp('Puzzle:');
    printPuzzle(puzzle);

    disp('Solving...');
    solution = solve(puzzle);

    disp('Solution:');
    printPuzzle(solution);
end

function printPuzzle(puzzle)
    for i = 1:9
        fprintf('%s', ' ');
        for j = 1:9
            if isnan(puzzle(i, j))
                fprintf('%s', ' ');
            else
                fprintf('%d', puzzle(i, j));
            end
            if mod(j, 3) == 0 && j ~= 9
                fprintf('%s', ' | ');
            else
                fprintf('%s', ' ');
            end
        end
        disp(' ');
        if mod(i, 3) == 0 && i ~= 9
            disp('-------+-------+-------');
        end
    end
    disp(' ');
end

function solution = solve(puzzle)
    % Implement the puzzle solving algorithm here
    % You can use different algorithms based on the "algorithm" input
    % Placeholder code: return the original puzzle as the solution
    solution = puzzle;
end
