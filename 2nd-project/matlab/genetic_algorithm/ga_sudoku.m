% GA - Genetic Algorithm for Sudoku
% https://nidragedd.github.io/sudoku-genetics/

% Prevent Octave from thinking that this is a function file:
1;

% Function: select
% ----------------------------
% Select the best individuals of the population.
%
% @param pop: the population
% @param pop_fit: the fitness of the population
% @return new_pop: the selected population
function new_pop = select(pop, pop_fit)
    pop_size = length(pop);
    pop_rand_idxs = randi([1, pop_size], 1, pop_size); % Random indexes for the second parent

    % Binary tournament selection
    for i = 1 : pop_size
        if pop_fit(i) < pop_fit(pop_rand_idxs(i)) % Minimization
            new_pop{i} = pop{i};
        else
            new_pop{i} = pop{pop_rand_idxs(i)};
        end
    end
end

% Function: crossover
% ----------------------------
% Cross the population.
%
% @param data: the data for the problem
% @param pop: the population
% @param cross_prob: the probability of crossover
% @return new_pop: the crossed population
function new_pop = crossover(data, pop, cross_prob)
    % one-point crossover
    new_pop = onePointCrossover(data, pop, cross_prob);

    % two-point crossover
    %new_pop = twoPointCrossover(data, pop, cross_prob);
end

% Function: onePointCrossover
% ----------------------------
% Cross the population.
% For each individual of the population, with a probability of cross_prob:
%   - Choose a random subgrid index (1 to 9)
%   - All the subgrids before the chosen one are copied from the first parent
%   - The chosen subgrid is copied from the second parent
%   - All the subgrids after the chosen one are copied from the first parent
%
% @param data: the data for the problem
% @param pop: the population
% @param cross_prob: the probability of crossover
% @return new_pop: the crossed population
function new_pop = onePointCrossover(data, pop, cross_prob)
    pop_size = size(pop, 1);
    new_pop = pop;

    for i = 1:2:pop_size
        if rand() < cross_prob
            % Choose a random subgrid index (1 to 9)
            subgrid_idx = randi([1,9]);
            for j = 1:3:9
                if j <= subgrid_idx
                    new_pop{i}(j:j+2,:) = pop{i+1}(j:j+2,:);
                    new_pop{i+1}(j:j+2,:) = pop{i}(j:j+2,:);
                else
                    new_pop{i}(j:j+2,:) = pop{i}(j:j+2,:);
                    new_pop{i+1}(j:j+2,:) = pop{i+1}(j:j+2,:);
                end
            end
        end
    end
end

% Function: twoPointCrossover
% ----------------------------
% Cross the population.
% For each individual of the population, with a probability of cross_prob:
%   - Choose two random subgrid indexes (1 to 9)
%   - All the subgrids before the first chosen one are copied from the first parent
%   - All the subgrids between the two chosen ones are copied from the second parent
%   - All the subgrids after the second chosen one are copied from the first parent
%
% @param data: the data for the problem
% @param pop: the population
% @param cross_prob: the probability of crossover
% @return new_pop: the crossed population
function new_pop = twoPointCrossover(data, pop, cross_prob)
    pop_size = size(pop, 1);

    % Choose two random subgrid indexes (1 to 9)
    subgrid_idx1 = randi([1,9]);
    subgrid_idx2 = randi([1,9]);
    while subgrid_idx1 == subgrid_idx2
        subgrid_idx2 = randi([1,9]);
    end
    if subgrid_idx1 > subgrid_idx2
        tmp = subgrid_idx1;
        subgrid_idx1 = subgrid_idx2;
        subgrid_idx2 = tmp;
    end

    new_pop = pop;
    for i = 1:length(pop)
        if rand() < cross_prob
            new_pop{i} = pop{1}; % First parent
            for j = 1:3:9
                if j >= subgrid_idx1 && j <= subgrid_idx2
                    new_pop{i}(j:j+2,:) = pop{2}(j:j+2,:);
                else
                    new_pop{i}(j:j+2,:) = pop{1}(j:j+2,:);
                end
            end
        end
    end
end


% Function: mutate
% ----------------------------
% Mutate the population.
% For each individual of the population, with a probability of mut_prob:
%   - Choose a random subgrid
%   - Choose two random empty cells in the subgrid
%   - Swap the values of the two cells
%
% @param data: the data for the problem
% @param pop: the population
% @param mut_prob: the probability of mutation
% @return new_pop: the mutated population
function new_pop = mutate(data, pop, mut_prob)
    pop_size = size(pop, 1);
    mut_idxs = randi([1,81], pop_size, 1);
    new_pop = pop;
    probs = rand(pop_size, 1);

    for e = 1:pop_size,
        if probs(e) < mut_prob
            % Choose a random subgrid
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
            new_pop{e} = pop{e};
            new_pop{e}(i+floor((k-1)/3),j+mod(k-1,3)) = pop{e}(i+floor((l-1)/3),j+mod(l-1,3));
            new_pop{e}(i+floor((l-1)/3),j+mod(l-1,3)) = pop{e}(i+floor((k-1)/3),j+mod(k-1,3));
        end
    end
end

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
