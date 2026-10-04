function [BestValue, Xfood, Conv_selected] = RBMO_10(popsize, dim, T, lb, ub, fobj,max_FES)
    % Initialize the relevant parameters
    Xfood = inf(popsize, 1);
    BestValue = inf;
    Conv = zeros(1, max_FES);
    Conv_t = zeros(1, T);
    Conv_selected=zeros(1, max_FES/1000);
    fitness = inf(popsize, 1);
    fitness_old=inf(popsize, 1);
    FES = 0;
    NFES = FES;
    Epsilon = 0.5;
    pop=comb_init(popsize,dim,lb, ub,fobj);
%     pop = initialization(popsize, dim, ub, lb);
    
    X_old = pop;
    for i = 1:popsize
        fitness_old(i) = fobj(X_old(i, :));
        FES=FES+1;
         if fitness_old(i)<=BestValue
            BestValue=fitness_old(i);
            Xfood=X_old(i,:);
         end
    end
    Conv(1, NFES+1 : FES) =BestValue;
    NFES = FES;

    fitness=fitness_old;
    t = 1; % Start of the main loop
    
    while FES < max_FES
%%
%          Epsilon =  0.5 * (1 + cos(pi * FES / max_FES));
        % Search for food
        for i = 1:popsize

            % Randomly select 2 to 5 red-billed blue magpies
            p = randi([2, 5]);
            selected_index_p = randperm(popsize, p);
            Xp = pop(selected_index_p, :);
            Xpmean = mean(Xp);

            % Randomly select 10 to popsize red-billed blue magpies
            q = randi([10, popsize]);
            selected_index_q = randperm(popsize, q);
            Xq = pop(selected_index_q, :);
            Xqmean = mean(Xq);

            A = randperm(popsize);
            R1 = A(1);
            if rand < Epsilon
                pop(i, :) = pop(i, :) + (Xpmean - pop(R1, :)) .* rand; % Eq. (3)
            else
                pop(i, :) = pop(i, :) + (Xqmean - pop(R1, :)) .* rand; % Eq. (4)
            end
        end
        
        % Boundary handling
        pop = boundaryCheck(pop, lb, ub);
        
        for i = 1:popsize 
            if FES>=max_FES
                break;
            end 
            fitness(i, 1) = fobj(pop(i, :));
            FES = FES + 1;
            if fitness(i, 1) < BestValue
                BestValue = fitness(i, 1);
                Xfood = pop(i, :);
            end
           
        end
        Conv(1, NFES+1 : FES) =BestValue;
        NFES = FES;

        % Food storage
        [fitness, pop, fitness_old, X_old] = Food_storage(fitness, pop, fitness_old, X_old); % Eq. (7)
        
          %% 动态自适应权重
           CF = 1 - ((exp(FES / max_FES) - 1) / (exp(1) - 1))^2;
%         CF = (1 - FES / max_FES)^(2 * FES / max_FES);
        
        % Exploitation
        for i = 1:popsize
            % Randomly select 2 to 5 red-billed blue magpies
            p = randi([2, 5]);
            selected_index_p = randperm(popsize, p);
            Xp = pop(selected_index_p, :);
            Xpmean = mean(Xp);

            % Randomly select 10 to popsize red-billed blue magpies
            q = randi([10, popsize]);
            selected_index_q = randperm(popsize, q);
            Xq = pop(selected_index_q, :);
            Xqmean = mean(Xq);

            if rand() < Epsilon
                pop(i, :) = Xfood + CF * (Xpmean - pop(i, :)) .* randn(1, dim); % Eq. (5)
            else
                pop(i, :) = Xfood + CF * (Xqmean - pop(i, :)) .* randn(1, dim); % Eq. (6)
            end
        end

        % Boundary handling
        pop = boundaryCheck(pop, lb, ub);

        for i = 1:popsize 
            if FES>=max_FES
                break;
            end
            fitness(i, 1) = fobj(pop(i, :));
            FES = FES + 1;
            if fitness(i, 1) < BestValue
                BestValue = fitness(i, 1);
                Xfood = pop(i, :);
            end
        end 
       
        Conv(1, NFES+1 : FES) =BestValue;
        NFES = FES;

        % Food storage
        [fitness, pop, fitness_old, X_old] = Food_storage(fitness, pop, fitness_old, X_old); % Eq. (7)
        %%   随机游走   
%            if(t>1&& Conv_t(t)== Conv_t(t-1))
%                 pop=random_walk(pop,Xfood,t,T);
%                 % Boundary handling
%                 pop = boundaryCheck(pop, lb, ub);
% 
%                 for i = 1:popsize
%                     if FES>=max_FES
%                         break;
%                     end
%                     fitness(i, 1) = fobj(pop(i, :));
%                     if fitness(i, 1) < BestValue
%                         BestValue = fitness(i, 1);
%                         Xfood = pop(i, :);
%                     end
%                     FES = FES + 1;
% 
%                 end
% 
%                 % Food storage
%                 [fitness, pop, fitness_old, X_old] = Food_storage(fitness, pop, fitness_old, X_old); % Eq. (7)      
%             end
%         
%         Conv(1, NFES+1 : FES) =BestValue;
%         NFES = FES;

%         if t<T
            t = t + 1;  
%         end
    end
    indices = [1000:1000:max_FES];
    Conv_selected = Conv(indices);
end

function pop = initialization(popsize, dim, ub, lb)
    B_no = size(ub, 2); % number of boundaries

    if B_no == 1
        pop = rand(popsize, dim) .* (ub - lb) + lb;
    end

    % If each variable has a different lb and ub
    if B_no > 1
        for i = 1:dim
            Xmax_i = ub(i);
            Xmin_i = lb(i);
            pop(:, i) = rand(popsize, 1) .* (Xmax_i - Xmin_i) + Xmin_i;
        end
    end
end

function pop = boundaryCheck(pop, lb, ub)
    for i = 1:size(pop, 1)
        FU = pop(i, :) > ub;
        FL = pop(i, :) < lb;
        pop(i, :) = (pop(i, :) .* (~(FU + FL))) + ub .* FU + lb .* FL;
    end
end

