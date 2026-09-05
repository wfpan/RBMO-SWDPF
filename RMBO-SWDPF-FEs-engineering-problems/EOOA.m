%==========================================================================
% Enhanced Osprey Optimization Algorithm (EOOA)
% DOI: https://doi.org/10.3390/biomimetics11080545
%
%--------------------------------------------------------------------------
%
% If you use this code in your research, please cite:
% Bouali, Yacine, and Basem Alamri. “Enhanced Osprey Optimization Algorithm for Global Optimization with Application to PEM Fuel Cell Parameter Identification.” 
% Biomimetics, vol. 11, no. 8, Aug. 2026, p. 545, https://doi.org/10.3390/biomimetics11080545.
%==========================================================================

function [Best_score, Best_pos,Conv_selected] = EOOA(N, dim, ~, lb, ub, fobj,max_FES)
FES=0;
NFES = FES;
Conv=zeros(1,max_FES);
Conv_selected=zeros(1, max_FES/1000);
fit=inf*ones(N,1);
%% ── Non-linear Adaptive Parameter ────────────────────────────────────────
%  alpha_t in (0,1]: drives the phase 3 parameters.
%  Formula : alpha_t = exp(-lambda * (FES/Tmax)^2)          [Eq. 9]

%% ── DE Control Parameters ─────────────────────────────────────────────────
lambda = 3;    % Lambda  : steepness constant (range 2–4). Default = 3.
CR    = 0.9;   % Crossover probability                                
F_max = 0.9;   % Upper bound of adaptive DE scaling factor            
F_min = 0.3;   % Lower bound of adaptive DE scaling factor            
%% ── Bounds Setup ──────────────────────────────────────────────────────────
if(max(size(ub)) == 1)
    lb = ones(1, dim) .* lb;
    ub = ones(1, dim) .* ub;
end
%% ── Initialisation (uniform random) ──────────────────────────────────────
for i = 1:dim
    X(:,i) = lb(i) + rand(N,1) .* (ub(i) - lb(i));
end
for i = 1:N
    fit(i) = fobj(X(i,:));
    FES=FES+1;
end
t=1;
    [Fbest, bestLoc] = min(fit);
        xbest = X(bestLoc,:);
        fbest = Fbest;
%% ═══════════════════════ MAIN LOOP ═══════════════════════════════════════
while FES < max_FES

    %% ── Eq. 9: Non-linear adaptive parameter ──────────────────────────────
    alpha_t = exp(-lambda * (FES / max_FES)^2);   % alpha_t in (0, 1]

    %% ── Eq. 10: Adaptive DE scaling factor ────────────────────────────────
    %  F is large early (high alpha_t --> diverse mutation)
    %  F is small late  (low  alpha_t --> fine perturbation)
    F_de = F_min + (F_max - F_min) * alpha_t;

    %% ── Update global best ────────────────────────────────────────────────
    [Fbest, bestLoc] = min(fit);

   if Fbest < fbest
        fbest = Fbest;
        xbest = X(bestLoc,:);
    end

    %% ─────────── Three-Phase Agent Update Loop ───────────────────────────
    for i = 1:N

        %% ── PHASE 1: Exploration ────────────────
        if FES>=max_FES
            break;
        end
        fish_position = find(fit < fit(i));
        if isempty(fish_position)
            selected_fish = xbest;
        else
            if rand < 0.5                          % [Eq. 4] selection rule
                selected_fish = xbest;
            else
                k = randperm(numel(fish_position), 1);
                selected_fish = X(fish_position(k), :);
            end
        end
        I = round(1 + rand);
        X_new = X(i,:) + rand .* (selected_fish - I .* X(i,:));   % [Eq. 5]
        X_new = max(X_new, lb); X_new = min(X_new, ub);

        fit_new = fobj(X_new);
        FES=FES+1;
        if fit_new < fit(i), X(i,:) = X_new; fit(i) = fit_new; end % [Eq. 6]
        % END Phase 1 ──────────────────────────────────────────────────────

        %% ── PHASE 2: Exploitation ───────────
        %  Retained unchanged from the original OOA (linear 1/FES decay).
        if FES>=max_FES
            break;
        end
        X_new = X(i,:) + (lb + rand*(ub-lb)) / t;                 % [Eq. 7]
        X_new = max(X_new, lb); X_new = min(X_new, ub);
        

        fit_new = fobj(X_new);
        FES=FES+1;
        if fit_new < fit(i), X(i,:) = X_new; fit(i) = fit_new; end % [Eq. 8]
        % END Phase 2 ──────────────────────────────────────────────────────

        %% ── PHASE 3: DE-based (NEW PHASE) ──────────
        %  Not present in original OOA. Adds cross-agent information sharing.
        % Select 3 distinct random agents different than i
        if FES>=max_FES
            break;
        end 
        candidates = randperm(N, 4);
        candidates(candidates == i) = [];
        r1 = candidates(1); r2 = candidates(2); r3 = candidates(3);

        % Mutant vector:                                            [Eq. 11]
        mutant = X(r1,:) + F_de .* (X(r2,:) - X(r3,:));
        mutant = max(mutant, lb); mutant = min(mutant, ub);

        % Binomial crossover: mix mutant with current agent         [Eq. 12]
        mask = rand(1, dim) < CR;
        if ~any(mask), mask(randi(dim)) = true; end   % enforce j_rand
        trial = X(i,:);
        trial(mask) = mutant(mask);

        % Greedy selection                                          [Eq. 13]
        fit_trial = fobj(trial);
        FES=FES+1;
        if fit_trial < fit(i), X(i,:) = trial; fit(i) = fit_trial; end
        % END Phase 3 ──────────────────────────────────────────────────────

    end % end agent loop

    Conv(1, NFES+1 : FES) =fbest;
    NFES = FES; 
t=t+1;
end % end main loop
%% ═════════════════════════════════════════════════════════════════════════

Best_score = fbest;
Best_pos   = xbest;

    indices = [ 1000:1000:max_FES];
    Conv_selected = Conv(indices);
end
