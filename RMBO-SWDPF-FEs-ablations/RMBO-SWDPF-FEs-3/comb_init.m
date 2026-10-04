function pop = comb_init(popsize,dim,lb, ub,fobj)

    X1 = init_point(popsize, dim, lb, ub);  % 使用init_point函数生成种群
   % Tent混沌映射序列
    z = rand(popsize, dim); % 随机序列
    for i=1:popsize
        for j=1:dim
            if z(i,j)<0.5
                z(i,j) = 2*z(i,j);
            elseif z(i)>=0.5
                z(i,j) = 2*(1-z(i,j));
            end
        end
    end
    pop=X1.*z;
end