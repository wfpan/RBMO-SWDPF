%% =====================================================================%%
%% 粒子群优化：最早版本(doi:10.1109/icnn.1995.488968)
% coding：陈小斌
% Github：doFighter
% Encoding format：utf-8
% N: 种群大小
% dim:求解问题的维度
% x_max:解空间上限
% x_min:解空间下限
% iterate_max:最大迭代次数
% fitness:评价函数
%% --------------------------------------------------------------------%%
function[gfit,gBest,Conv_selected]=PSO(N,dim,iterate_max,x_min,x_max,fitness,max_FES)
    FES=0;
    NFES = FES;
    c = 2*ones(1,2); % 定义加速系数 c1,c2;这里直接放入一个矩阵中
    %由于在文中未能看到上面的 rand 是随机生成亦或是初始化生成，这里使用随机生成
    v_min = x_min*0.2;
    v_max = x_max*0.2;
%     x = x_min + (x_max-x_min)*rand(N,dim); % 初始化种群位置；三行两列的矩阵，元素处于-10~10之间。三行寓意为种群，两列为维度.
    pop=init(N,dim,x_min,x_max);
    x=pop;
    v = v_min + (v_max-v_min)*rand(N,dim);   % 初始化种群速度；速度一般在位置的取值范围的10%~20%，这里取10%
    pBest = x;  % 存储粒子的局部最优值,初始为 初始值
    gBest = x(1,:);  % 存储粒子的全局最优值
    gfit=fitness(gBest);
    FES=FES+1;
    pfit=inf*ones(N,1);
    Conv=zeros(1,max_FES);
    Conv_selected=zeros(1, max_FES/1000);
    for i = 2:N
        pfit(i)=fitness(pBest(i,:));
        FES=FES+1;
       if gfit > pfit(i)
          gfit=pfit(i);
          gBest = pBest(i,:); 
       end
        
    end
    Conv(1, NFES+1 : FES) =gfit;
    NFES = FES;
%     iterate = 1;
 
    res = inf*ones(N,1);
    while FES < max_FES
        % 下面进行速度与位置的更新，当速度超出 -2~2 时，将其置为边界数，同理，当位置超出 边界 时，将其也置为边界数
        v = v + c(1)*rand(N,dim).*(pBest-x) + c(2)*rand(N,dim).*(gBest-x);
        v(v>v_max) = v_max;
        v(v<v_min) = v_min;
        x = x + v;
        x(x>x_max) = x_max;
        x(x<x_min) = x_min;
        
        for i = 1:N                     % 对每个粒子进行求解
            if FES>=max_FES
                break;
            end
            xfit=fitness(x(i,:));
            FES=FES+1;
            if FES>max_FES
                break;
            end
            if  xfit <pfit(i)   % 判断当前位置是否优于局部最优位置，若优于局部最优，则更新局部最优位置
                pBest(i,:) = x(i,:);
            end
            pfit(i) = fitness(pBest(i,:));
            FES=FES+1;
                   
        end
         
        if min(pfit) < gfit        % 判断当前所有的局部最优位置是否优于全局最优位置，若是，则更新
            gfit= min(pfit) ;
            position = find(pfit == min(pfit));
            gBest = pBest(position(1),:);
        end
        Conv(1, NFES+1 : FES) =gfit;
        NFES = FES;
%         Convergence_curve(iterate)=rest;
        % 迭代计数器加1
%         if iterate<iterate_max
%             iterate = iterate + 1;
%         end
    end
    indices = [ 1000:1000:max_FES];
    Conv_selected = Conv(indices);
%     rest = fitness(gBest);
end