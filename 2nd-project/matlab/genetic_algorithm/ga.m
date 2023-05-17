% Function: ga
% ----------------------------
% Performs a genetic algorithm to find the optimum solution of a problem.
%
% @param data: data structure containing problem information
% @param t_max: maximum number of iterations
% @param pop_size: population size
% @param cross_prob: crossover probability
% @param mut_prob: mutation probability
% @param select: selection function
% @param crossover: crossover function
% @param mutate: mutation function
% @param get_initial_solution: function to generate an initial solution
% @param evaluate: function to evaluate a solution
% @param is_optimum: function to check if a solution is the optimum
% @param sense: 'maximize' or 'minimize'
%
% @return res: structure with the following fields:
%   - num_evaluations: number of evaluations
%   - cost: cost of the best solution found
%   - t_max: maximum number of iterations
%   - pop_size: population size
%   - cross_prob: crossover probability
%   - mut_prob: mutation probability
%   - u: best solution found
%   - s: best solution found
%   - fit: vector with the best fitness found in each iteration
function res = ga(data, t_max, pop_size, cross_prob, ...
                        mut_prob, select, crossover, mutate, ...
                        get_initial_solution, ...
                        evaluate, is_optimum, sense)
    % GA Genetic Algorithm
    %   Make t = 0;
    %   Initialize the population P(0), at random.
    %   Evaluate P(0)
    %   Repeat step 1 to 5 (until close to saturation)
    %     Step 1 t = t+1
    %     Step 2 Select the fittest from P(t-1) to build P(t)
    %     Step 3 Cross P(t)
    %     Step 4 Mutate some solution from P(t)
    %     Step 5 Evaluate P(t)
    %

    % Number of evaluations
    num_evaluations = 0;
    % Variable used to specify stop criteria
    found_optimum = false;

    % Initialize the population P(0), at random.
    initial_pop = get_initial_population(data, pop_size, get_initial_solution);
    % Evaluate P(0)
    initial_pop_fit =  evaluate_population(data, initial_pop, evaluate);
    % Increment number of evaluations
    num_evaluations = num_evaluations + pop_size;
    % Current population and evaluation
    pop = initial_pop;
    pop_fit = initial_pop_fit;

    j = 1;
    % Get best fitness
    fu = get_best_fitness(pop_fit, sense);
    fit(j) = fu;
    % Mean fitness
    mean_fit(j) = mean(pop_fit);
    j = j+1;

    % Iteration index
    t = 0;
    % Repeat step 1 to 5 (until close to saturation)
    while (t < t_max && ~found_optimum)
        % Step 1 Increment iteration index
        t = t+1;
        % Step 2 Select the fittest from P(t-1) to build P(t)
        %pop = select(pop, pop_fit, sense);
        pop = select(pop, pop_fit);
        % Step 3 Cross P(t)
        pop = crossover(data, pop, cross_prob);
        % Step 4 Mutate some solution from P(t)
        pop = mutate(data, pop, mut_prob);
        % Step 5 Evaluate P(t)
        pop_fit = evaluate_population(data, pop, evaluate);

        % Increment number of evaluations
        num_evaluations = num_evaluations + pop_size;
        % Get best fitness
        fu = get_best_fitness(pop_fit, sense);
        fit(j) = fu;
        % Mean fitness
        mean_fit(j) = mean(pop_fit);
        j = j+1;
        % if optimum found then stop.
        if is_optimum(fu, data)
            found_optimum = true;
        end
    end

    % Get best solution
    [fu, I] = get_best_fitness(pop_fit, sense);
    u = pop(I(1));

    %fprintf('BestCost: %f\n', fu);
    %fprintf('num_evaluations: %d\n', num_evaluations);

    % Plot
    figure(1)
    plot(fit);
    i = 1 : t+1; % t reaches t_max if the optimum solution is not found before
    fit;
    mean_fit;
    t
    figure(2)
    plot(i, fit / data.optimum * 100, 'k-', i, mean_fit / data.optimum * 100, 'k:');
    xlabel('Generation no.');
    ylabel('Fitness (%)');
    axis([1 t+1 50 110]);
    legend('Pop Max', 'Pop Mean');

    res = struct('num_evaluations', num_evaluations, 'cost', fu, ...
        't_max', t_max, 'pop_size', pop_size, 'cross_prob', cross_prob, ...
        'mut_prob', mut_prob, 'u', u, 's', u, 'fit', fit);
end

% Function: get_best_fitness
% ----------------------------
% Returns the best fitness and its index
%
% @param pop_fit: vector with the fitness of each individual
% @param sense: 'maximize' or 'minimize'
%
% @return fit: best fitness
% @return I: index of the best fitness
function [fit, i] = get_best_fitness(pop_fit, sense)
    if strcmp(sense, 'maximize')
        [fit, i] = max(pop_fit);
    elseif strcmp(sense, 'minimize')
        [fit, i] = min(pop_fit);
    end
end

% Function: get_initial_population
% ----------------------------
% Returns the initial population
%
% @param data: structure with the data
% @param pop_size: population size
% @param get_initial_solution: function to generate an initial solution
%
% @return pop: initial population
function pop = get_initial_population(data, pop_size, get_initial_solution)
    pop = cell(1, pop_size);  % Initialize P as a cell array

    for i = 1 : pop_size
        pop{i} = get_initial_solution(data);  % Assign the solution to P{i}
    end

    pop = reshape(pop, 1, pop_size);  % Convert cell array to a row vector
end

% Function: evaluate_population
% ----------------------------
% Returns the fitness of each individual
%
% @param data: structure with the data
% @param pop: population
% @param evaluate: function to evaluate a solution
%
% @return fp: vector with the fitness of each individual
function fp = evaluate_population(data, pop, evaluate)
    pop_size = length(pop);
    for i = 1 : pop_size
        fp(i) = evaluate(pop{i}, data);
    end
end
