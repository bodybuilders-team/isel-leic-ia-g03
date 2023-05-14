% SA - Simulated Annealing for Sudoku

% Prevent Octave from thinking that this is a function file:
1;


% Function: get_initial_solution
% ----------------------------
% Get the initial solution for the sudoku.
% For each subgrid (3x3) of the puzzle:
%   - Check the list of values that are missing in the subgrid
%   - Fill the empty cells with random values from the list
%
% @param data - the data for the problem
% @return s - the initial solution
function s = get_initial_solution(data)
    s = data.puzzle;
    for i = 1:3:9
        for j = 1:3:9
            missing_values = get_missing_values(s, i, j);
            for k = i:i+2
                for l = j:j+2
                    if isnan(s(k,l))
                        s(k,l) = missing_values(randi(length(missing_values)));
                        missing_values(missing_values == s(k,l)) = [];
                    end
                end
            end
        end
    end
end

% Function: get_missing_values
% ----------------------------
% Get the list of values that are missing in the subgrid (3x3)
%
% @param s - the current solution
% @param i - the row of the subgrid
% @param j - the column of the subgrid
% @return missing_values - the list of missing values
function missing_values = get_missing_values(s, i, j)
    missing_values = [1 2 3 4 5 6 7 8 9];
    for k = i:i+2
        for l = j:j+2
            if ~isnan(s(k,l))
                missing_values(missing_values == s(k,l)) = [];
            end
        end
    end
end

% Function: get_random_neighbour
% ----------------------------
% Get a random neighbour of the current solution:
%   - Choose a random subgrid (with at least two empty cells)
%   - Choose two random empty cells in the subgrid
%   - Swap the values of the two cells
%
% @param s - the current solution
% @param data - the data for the problem
% @return n - the random neighbour
function n = get_random_neighbour(s, data)
    n = s;

    % Choose a random subgrid (with at least two empty cells)
    i = 3*randi(3)-2;
    j = 3*randi(3)-2;
    while length(find(isnan(data.puzzle(i:i+2,j:j+2)))) < 2
        i = 3*randi(3)-2;
        j = 3*randi(3)-2;
    end

    % Choose two random empty cells in the subgrid
    empty_cells = find(isnan(data.puzzle(i:i+2,j:j+2)));
    k = empty_cells(randi(length(empty_cells)));
    empty_cells(empty_cells == k) = [];
    l = empty_cells(randi(length(empty_cells)));

    % Swap the values of the two cells
    temp = n(i+floor((k-1)/3),j+mod(k-1,3));
    n(i+floor((k-1)/3),j+mod(k-1,3)) = n(i+floor((l-1)/3),j+mod(l-1,3));
    n(i+floor((l-1)/3),j+mod(l-1,3)) = temp;
end

% Function: evaluate
% ----------------------------
% Evaluate the current solution:
%   - For each row and column, count the number of duplicates
%   - Return the sum of the two counts
%
% @param s  - the current solution
% @param data - the data for the problem
% @return e - the evaluation of the current solution
function e = evaluate(s, data)
    e = 0;
    for i = 1:9
        e = e + length(s(i,:)) - length(unique(s(i,:)));
        e = e + length(s(:,i)) - length(unique(s(:,i)));
    end
end

% Function: is_optimum
% ----------------------------
% Check if the current solution is the optimum
%
% @param fu - the evaluation of the current solution
% @param data - the data for the problem
% @return res - true if the current solution is the optimum, false otherwise
function res = is_optimum(fu, data)
    res = fu == data.optimum;
end
