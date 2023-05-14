% Function: sa
% ----------------------------
% Performs the Simulated Annealing algorithm.
%
% @param t_max: maximum temperature
% @param t_min: minimum temperature
% @param r: rate of temperature decrease
% @param k: number of iterations per temperature
% @param data: data structure with problem information
% @param get_initial_solution: function that returns an initial solution
% @param get_random_neighbour: function that returns a random neighbour
% @param evaluate: function that evaluates a solution
% @param is_optimum: function that checks if a solution is optimum
% @param sense: 'maximize' or 'minimize'
%
% @return res: structure with the following fields:
%   - t: final temperature
%   - num_evaluations: number of evaluations
%   - cost: cost of the best solution found
%   - t_max: maximum temperature
%   - t_min: minimum temperature
%   - r: rate of temperature decrease
%   - k: number of iterations per temperature
%   - u: best solution found
%   - f: vector with the cost of the best solution found at each iteration
%   - s: best solution found
function res = sa(t_max, t_min, r, k, ...
    data, get_initial_solution, get_random_neighbour, evaluate, ...
    is_optimum, sense)
    % Simulated Annealing (algorithm 2 for minimization of f)
    %
    % Step 1  Make t = t_max  and Choose a solution u (at random)
    %
    % Step 2  Select a neighbor of u, say v
    %         If f(v) < f(u) make u = v;
    %         Else make u = v with probability
    %              p = exp((fu-fv)/(fu * t)))
    %
    %         Repeat Step 2  k times
    %
    % Step 3  Make t = t+1; Set t = t(t)
    %         see Eq.(4) of lecture notes
    %
    %         If  t >= t_min  go to Step 2;
    %         Else Stop.
    %

    % Rate increment variable
    t = 0;
    % Step 1  Make t = t_max and
    T = t_max;
    % Number of evaluations
    num_evaluations = 0;
    % Variable used to specify stop criteria
    found_optimum = false;

    % Choose a solution u (at random) and compute fu = f(u)
    u = get_initial_solution(data);
    fu = evaluate(u, data);
    fprintf('Initial cost: %d\n', fu);
    % Increment number of evaluations
    num_evaluations = num_evaluations + 1;

    z = 1;
    f(z) = fu;
    z = z+1;

    while (~found_optimum)
        % Step 2  Select a neighbor of u, say v
        %         If f(v) < f(u) make u = v;
        %         Else make u = v with probability
        %              p = exp((fu-fv)/(fu * t)))
        %
        %         Repeat Step 2   k times
        i = 0;
        while (i < k && ~found_optimum)
            % Select a neighbor of u, say v.
            v = get_random_neighbour(u, data);
            % Evaluate v
            fv = evaluate(v, data);
            % Increment number of evaluations
            num_evaluations = num_evaluations + 1;

            % If f(v) < f(u) (minimization) make u = v;
            % Else make u = v with probability
            %   p = exp((fu-fv)/(fu t)))
            dif = fv-fu;
            if (strcmp(sense, 'maximize'))
                dif = -dif;
            end

            % if (fv < fu) % Minimization problem
            % if (fv > fu) % Maximization problem

            fprintf('fu (sol) = %d, fv (new neighbour) = %d\n', fu, fv);

            if (dif < 0)
                disp('Neighbour accepted');
                u = v;
                fu = fv;
            else
                prob = p(fu, fv, T, sense);
                x = rand();
                if (x <= prob)
                    % Accept this solution
                    u = v;
                    fu = fv;
               end
            end
            % Make i = i+1.
            i = i + 1;

            f(z) = fu;
            z = z+1;

            % if optimum found then stop.
            if is_optimum(fu, data)
                found_optimum = true;
            end
        end

        if ~found_optimum
            % Step 3  Make t = t+1; Set T = T(t)
            % see Eq.(4) of lecture notes
            t = t + 1;
            T = temp(t, t_max, r);
            % If  T < t_min  Stop.
            if (T < t_min)
                break;
            end
        end
    end

    fprintf('BestCost: %f\n', fu);
    fprintf('num_evaluations: %d\n', num_evaluations);

    res = struct('t', T, 'num_evaluations', num_evaluations, 'cost', fu, ...
        't_max', t_max, 't_min', t_min, 'r', r, 'k', k, ...
        'u', u, 'f', f, 's', u);

    figure(1);
    plot(f);
end

% Function: temp
% ----------------------------
% Computes the temperature for the next iteration.
%
% @param t: current iteration
% @param t_max: maximum temperature
% @param r: rate of temperature decrease
%
% @return new_temp: new temperature
function new_temp = temp(t, t_max, r)
    new_temp = t_max * exp(-r * t);
end

% Function: p
% ----------------------------
% Computes the probability of accepting a solution.
%
% @param fu: cost of the current solution
% @param fv: cost of the new solution
% @param t: current temperature
% @param sense: 'maximize' or 'minimize'
%
% @return x: probability of accepting the new solution
function x = p(fu, fv, t, sense)
    if strcmp(sense, 'maximize')
        x = exp((fv-fu) / (t*fu));
    elseif strcmp(sense, 'minimize')
        x = exp((fu-fv) / (t));
    end
end

