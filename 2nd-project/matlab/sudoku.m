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

source('./simulated_annealing/sa_sudoku.m');
source('./genetic_algorithm/ga_sudoku.m');

% Function: sudoku
% ----------------------------
% Entry point of the application
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

    puzzle = puzzle(difficulty);

    disp('Puzzle:');
    print_puzzle(puzzle);

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
    print_puzzle(solution);
end

% Function: print_puzzle
% ----------------------------
% Prints the puzzle in a human-readable format
%
% @param puzzle: the puzzle to print
function print_puzzle(puzzle)
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

% Function: solve
% ----------------------------
% Solves the puzzle using the specified algorithm
%
% @param puzzle: the puzzle to solve
% @param algorithm: the algorithm to use
function solution = solve(puzzle, algorithm)
    % Create struct data that will contain problem data
    optimum = 0;
    data = struct('puzzle', puzzle, 'optimum', optimum);
    sense = 'minimize'; % Minimization problem

    if algorithm == 0
        t_max = 5000;      % Initial temperature (can be adjusted)
        t_min = 0.001;     % Final temperature (can be adjusted)
        r = 0.005;         % Cooling rate (can be adjusted)
        k = 8;             % Number of iterations per temperature (can be adjusted)

        results = sa(t_max, t_min, r, k, data, @get_initial_solution, @get_random_neighbour, @evaluate, ...
            @is_optimum, sense);

        res = [[results(:).t]; [results(:).num_evaluations]; [results(:).cost]];
        fprintf('Final Temp\t\tNum Evaluations\t\tBest Cost\n');
        fprintf('%.7f\t\t%d\t\t%d\n', res);

        solution = results(end).s;
    else
        t_max = [1000];      % Max number of iterations
        pop_size = [100];    % Population size
        cross_prob = [0.8];  % Cross  probability
        mut_prob = [0.25];   % Mutation probability
        num_of_tests = length(t_max);

        % Run Tests
        for f = 1 : num_of_tests
            fprintf('\ntmax=%d', t_max(f));
            fprintf('\npopSize=%d', pop_size(f));
            fprintf('\ncrossProb=%.1f', cross_prob(f));
            fprintf('\nmutProb=%.1f\n', mut_prob(f));

            fprintf('\nNumEvaluations\t\tCost\n');
            fprintf('============================\n');
            results = ga(data, t_max(f), pop_size(f), cross_prob(f), mut_prob(f), @select, @crossover, @mutate, ...
                @get_initial_solution, @evaluate, @is_optimum, sense);

            res = [[results.num_evaluations]; [results.cost]];
            fprintf('%d\t\t%d\n', res);

            solution = results.s;
        end
    end
end

