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

        % Create struct data that will contain problem data
        optimum = 0;
        data = struct('puzzle', puzzle, 'optimum', optimum);

        Tmax = 5000;        % Initial temperature (can be adjusted)
        Tmin = 0.001;       % Final temperature (can be adjusted)
        R = 0.005;          % Cooling rate (can be adjusted)
        k = 8;              % Number of iterations per temperature (can be adjusted)
        sense = 'minimize'; % Minimization problem

        Results = sa(Tmax, Tmin, R, k, data, @getInitialSolution, @getRandomNeighbour, @evaluate, @isOptimum, sense);

        Res = [[Results(:).T]; [Results(:).NumEvaluations]; [Results(:).Cost]];
        fprintf('Final Temp\t\tNum Evaluations\t\tBest Cost\n');
        fprintf('%.7f\t\t%d\t\t%d\n', Res);

        solution = Results(end).s;
    else
        % Create struct data that will contain problem data
        optimum = 0;
        data = struct('puzzle', puzzle, 'optimum', optimum);

        sense = 'minimize'; % Minimization problem
        tmax = [1000];      % Max number of iterations
        popSize = [100];    % Population size
        crossProb = [0.7];  % Cross  probability
        mutProb = [0.25];   % Mutation probability

        % Run Tests
        NumbOfTests = length(tmax);
        for f = 1 : NumbOfTests
            fprintf('\ntmax=%d', tmax(f));
            fprintf('\npopSize=%d', popSize(f));
            fprintf('\ncrossProb=%.1f', crossProb(f));
            fprintf('\nmutProb=%.1f\n', mutProb(f));

            fprintf('\nNumEvaluations\t\tCost\n');
            fprintf('============================\n');
            Results = ga(data, tmax(f), popSize(f), crossProb(f), mutProb(f), @select, @crossover, @mutate, ...
                @getInitialSolution, @evaluate, @isOptimum, sense);

            Res = [[Results.NumEvaluations]; [Results.Cost]];
            fprintf('%d\t\t%d\n', Res);

            solution = Results.s;
        end
    end
end

