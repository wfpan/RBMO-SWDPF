function [lb, ub, dim, fobj] = Get_CEC_details(year, index, dim,Func_names)
    if strcmp(year, 'CEC2005')
        % 调用 Get_CEC2015_details 函数
        [lb, ub, dim, fobj] = Get_CEC2005_details(Func_names(index));
    elseif strcmp(year, 'CEC2017')
        % 调用 Get_CEC2017_details 函数
        [lb, ub, dim, fobj] = Get_CEC2017_details(Func_names(index), dim);
    elseif strcmp(year, 'CEC2022')
        % 调用 Get_CEC2017_details 函数
        [lb, ub, dim, fobj] = Get_CEC2022_details(Func_names(index), dim);
    else
        error('Invalid year. Please input either "CEC2015" or "CEC2017".');
    end
    lb=lb(1);
    ub=ub(1);
end

% function output = fobj(x)
%     % 确保 x 是一个行向量或者列向量
%     [n,~] = size(x);  
%     output = zeros(n,1);  % 初始化 output 为一个与 x 相同长度的向量
% 
%     for i = 1:n
%         % 逐个处理 x 中的每一项，调用 fobj_serial
%         output(i) = fobj_serial(x(i,:));
%     end
% end