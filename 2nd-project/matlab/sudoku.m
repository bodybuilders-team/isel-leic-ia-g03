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
% To run the application, run the "sudoku" function
% ====================================================

import SA from simulated_annealing/sa.m
import GA from genetic_algorithm/ga.m


function sudoku()
    disp('Welcome to the Sudoku Solver in MATLAB!');
    
    disp('Difficulties:')
    disp('0 - Easy');
    disp('1 - Medium');
    disp('2 - Hard');
    disp('3 - Expert');
    disp('4 - Nightmare');
    disp('5 - Impossible')
    difficulty = input('Choose the difficulty of the puzzle [0-5]: ');
    while ~(difficulty >= 0 && difficulty <= 5)
        difficulty = input('Invalid input! Please choose a difficulty between 0 and 5: ');
    end

    puzzle = getPuzzle(difficulty);

    disp('Puzzle:');
    printPuzzle(puzzle);

    disp('Algorithms:')
    disp('0 - Simulated Annealing');
    disp('1 - Genetic Algorithm');
    algorithm = input('Choose the algorithm to solve the puzzle [0-1]: ');
    while ~(algorithm >= 0 && algorithm <= 1)
        algorithm = input('Invalid input! Please choose an algorithm between 0 and 1: ');
    end

    disp('Solving...');
    solution = solve(puzzle, algorithm);

    disp('Solution:');
    printPuzzle(solution);
end

function puzzle = getPuzzle(difficulty)
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

        % Nightmare
        [nan,nan,nan,nan,nan,8,3,2,nan;
        nan,6,nan,nan,nan,nan,nan,nan,nan;
        3,4,nan,2,nan,nan,5,nan,nan;
        nan,nan,6,3,nan,nan,nan,nan,nan;
        1,3,nan,nan,nan,9,nan,nan,4;
        nan,nan,8,nan,nan,nan,1,nan,nan;
        nan,nan,nan,nan,7,nan,nan,nan,9;
        nan,nan,1,nan,nan,nan,nan,nan,nan;
        5,2,nan,8,nan,nan,4,nan,nan]

        % Impossible
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

function solution = solve(puzzle, algorithm)
    if algorithm == 0
        solution = SA(puzzle);
    else
        solution = GA(puzzle);
    end
end
