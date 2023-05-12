% SA - Simulated Annealing for Sudoku

% NÃO CONSIGO DAR IMPORT DESTE FILE

% Get the initial solution for the sudoku with random values
% The values are chosen randomly from 1 to 9 for each empty cell
% but the values must be valid for a subgrid (3x3) of the puzzle
function s = getInitialSolution(data)
    s = data.puzzle;
    % For each subgrid (3x3) of the puzzle
    % Check the list of values that are missing in the subgrid
    % Fill the empty cells with random values from the list
    % Remove the chosen value from the list
    for i = 1:3:9
        for j = 1:3:9
            missingValues = getMissingValues(s, i, j);
            for k = i:i+2
                for l = j:j+2
                    if isnan(s(k,l))
                        s(k,l) = missingValues(randi(length(missingValues)));
                        missingValues(missingValues == s(k,l)) = [];
                    end
                end
            end
        end
    end
end

% Get the list of values that are missing in the subgrid (3x3) of the puzzle
function missingValues = getMissingValues(s, i, j)
    missingValues = [1 2 3 4 5 6 7 8 9];
    for k = i:i+2
        for l = j:j+2
            if ~isnan(s(k,l))
                missingValues(missingValues == s(k,l)) = [];
            end
        end
    end
end

% Get random neighbour of the current solution
function n = getRandomNeighbour(s, data)
    n = s;

    % Choose a random subgrid
    % The subgrid should have at least two empty cells
    % e.g. subgrid (1,1) -> i = 1, j = 1
    % e.g. subgrid (2,2) -> i = 4, j = 4
    i = 3*randi(3)-2;
    j = 3*randi(3)-2;
    while length(find(isnan(data.puzzle(i:i+2,j:j+2)))) < 2
        i = 3*randi(3)-2;
        j = 3*randi(3)-2;
    end

    % Choose two random empty cells in the subgrid
    emptyCells = find(isnan(data.puzzle(i:i+2,j:j+2)));
    k = emptyCells(randi(length(emptyCells)));
    emptyCells(emptyCells == k) = [];
    l = emptyCells(randi(length(emptyCells)));

    %fprintf('Subgrid (%d,%d)\n', i, j);
    %fprintf('K = %d, L = %d\n', k, l);
    %fprintf('Empty cells (%d,%d) and (%d,%d)\n', i+floor((k-1)/3),j+mod(k-1,3),i+floor((l-1)/3),j+mod(l-1,3));

    % Swap the values of the two cells
    temp = n(i+floor((k-1)/3),j+mod(k-1,3));
    n(i+floor((k-1)/3),j+mod(k-1,3)) = n(i+floor((l-1)/3),j+mod(l-1,3));
    n(i+floor((l-1)/3),j+mod(l-1,3)) = temp;

    %fprintf('Swapped (%d,%d) with (%d,%d)\n', i+floor((k-1)/3),j+mod(k-1,3),i+floor((l-1)/3),j+mod(l-1,3));
    %printPuzzle(s);
    %printPuzzle(n);
end

% Evaluation function
% Counts the number of repeated values in the rows and columns
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