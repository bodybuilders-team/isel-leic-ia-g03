% SA - Simulated Annealing for Sudoku

% data = struct('puzzle', puzzle, 'optimum', optimum,);

% Get the initial solution for the sudoku with random values
function s = getInitialSolution(data)
    s = data.puzzle;
    for i = 1:9
        for j = 1:9
            if isnan(s(i,j))
                s(i,j) = randi(9);
            end
        end
    end
end

% Get random neighbour of the current solution
function n = getRandomNeighbour(s, data)
    n = s;

    % Choose a random empty cell in the puzzle
    i = randi(9);
    j = randi(9);
    while ~isnan(data.puzzle(i,j))
        i = randi(9);
        j = randi(9);
    end

    % Fill the cell with a random value in the neighbour
    n(i,j) = randi(9);
end

% Evaluation function
% Counts the number of repeated values in the rows, columns and squares
function e = evaluate(s, data)
    e = 0;
    for i = 1:9
        e = e + length(s(i,:)) - length(unique(s(i,:)));
        e = e + length(s(:,i)) - length(unique(s(:,i)));
    end
end

% isOptimum
% Parameters:
%   fu - the target function (function to be maximized) 
%   data - the data for the problem
% Returns:
%   res - true if the current solution is the optimum, false otherwise
function res = isOptimum(fu, data)
    res = fu == data.optimum;
end