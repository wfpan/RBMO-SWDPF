function pop = init_point(pop_size,dimension,lb, ub)
    lb =  lb .* ones(1,dimension);          %  Variables Lower Bound
    ub =  ub .* ones(1,dimension);          %  Variables Upper Bound
    bounds=[lb',ub'];
    %佳点集生成初始种群
    p = zeros(pop_size,dimension);
    prime_number_min = dimension*2 +3;
    % 找到(prime_number_min-3)/2>=dimension的最小素数prime_number_min
    while 1
        if isprime(prime_number_min)==1
            break;
        else
           prime_number_min = prime_number_min + 1;
        end
    end

    for i = 1:pop_size
        for j = 1:dimension
            r = mod(2*cos(2*pi*j/prime_number_min)*i,1);% 对应维度的r
    %         r = mod(exp(j)*i,1);
            p(i,j) = bounds(j,1)+r*(bounds(j,2)-bounds(j,1));
        end
    end
    pop = p;
end