function [fit, pop, fit_old, X_old,eliminated_parents] = Food_storage(fit, pop, fit_old, X_old)
    Inx = (fit_old < fit); 
    % 提取被淘汰的父代（即 fit_old > fit）
    eliminated_parents = X_old(~Inx, :);
   
    Indx = repmat(Inx, 1, size(pop, 2));
    pop = Indx .* X_old + ~Indx .* pop;
    fit = Inx .* fit_old + ~Inx .* fit; 
    fit_old = fit;
    X_old = pop;
end