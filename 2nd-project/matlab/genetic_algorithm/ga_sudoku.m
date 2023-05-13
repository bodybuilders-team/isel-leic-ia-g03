% GA - Genetic Algorithm for Sudoku
% https://nidragedd.github.io/sudoku-genetics/

% Prevent Octave from thinking that this is a function file:
1;

% Selection
function newPop = select(pop, popFit)
    popSize = length(pop);
    popRandIdxs = randi([1, popSize], 1, popSize);

    % Binary tournament selection
    for i = 1 : popSize
        if popFit(i) > popFit(popRandIdxs(i))
            newPop{i} = pop{i};
        else
            newPop{i} = pop{popRandIdxs(i)};
        end
    end
end

% Crossing
function newPop = crossover(data, pop, crossProb)
    % one-point crossover
    newPop = onePointCrossover(data, pop, crossProb);

    % two-point crossover
    %newPop = twoPointCrossover(data, pop, crossProb);
end

function newPop = onePointCrossover(data, pop, crossProb)
    popSize = size(pop, 1);
    % Choose a random subgrid index (1 to 9)
    subgridIdx = randi([1,9]);

    % All the subgrids before the chosen one are copied from the first parent
    % All the subgrids after the chosen one are copied from the second parent
    % The chosen subgrid is copied from the second parent
    newPop = pop;
    for i = 1:length(pop)
        if rand() < crossProb
            newPop{i} = pop{1}; % First parent
            %printPuzzle(pop{1});
            %printPuzzle(pop{2});
            %fprintf('Crossing subgrid %d\n', subgridIdx);
            for j = 1:3:9
                if j == subgridIdx
                    newPop{i}(j:j+2,:) = pop{2}(j:j+2,:);
                else
                    newPop{i}(j:j+2,:) = pop{1}(j:j+2,:);
                end
            end
            %printPuzzle(newPop{i});
        end
    end
end

function newPop = twoPointCrossover(data, pop, crossProb)
    % To be implemented
 end


% Mutation
function newPop = mutate(data, pop, mutProb)
    popSize = size(pop, 1);
    mutIdxs = randi([1,81], popSize, 1);
    newPop = pop;
    probs = rand(popSize, 1);
    for e = 1:popSize,
        if probs(e) < mutProb
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

            % Swap the values of the two cells
            %fprintf('Mutating subgrid (%d,%d) - (%d,%d)\n', i, j, k, l);
            newPop{e} = pop{e};
            newPop{e}(i+floor((k-1)/3),j+mod(k-1,3)) = pop{e}(i+floor((l-1)/3),j+mod(l-1,3));
            newPop{e}(i+floor((l-1)/3),j+mod(l-1,3)) = pop{e}(i+floor((k-1)/3),j+mod(k-1,3));
            %printPuzzle(pop{e});
            %printPuzzle(newPop{e});
        end
    end
end

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
