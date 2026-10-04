clear, clc, close all
year="CEC2017";
%% 使用CEC2017测试
var="test";
Func_names_CEC2017 = ["F1", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23","F24","F25","F26","F27","F28","F29","F30"];
% Func_names_CEC2022 = ["F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"];
% Func_names=Func_names_CEC2022;
Func_names=Func_names_CEC2017;
repeat_numbers = 30;
dim=30;

Algorithms_name = ["RBMO","RBMO_9","RBMO_10","RBMO_11","RBMO_12","RBMO_13","RBMO_14","RBMO-SWDPF"];
funcs = {@RBMO,@RBMO_9,@RBMO_10,@RBMO_11,@RBMO_12,@RBMO_13,@RBMO_14,@IMRBMO,};
Algorithms_numbers = length(Algorithms_name);
Func_numbers=length(Func_names);
Average_fitness = zeros(Func_numbers, Algorithms_numbers);
Std_fitness=zeros(Func_numbers, Algorithms_numbers);
Gbest_fitness=zeros(Func_numbers, Algorithms_numbers);
Position= zeros(Func_numbers, Algorithms_numbers,dim);
popsize = 30; % 种群数量
maxIter=500;
max_FES = 1000*dim; % 最大评估次数
%%        
Best_fitness_csv=zeros(repeat_numbers,Func_numbers,Algorithms_numbers);
Position_csv=zeros(repeat_numbers,Func_numbers,Algorithms_numbers,dim);
Iter_curve_csv=zeros(repeat_numbers,Func_numbers,Algorithms_numbers,max_FES/1000);

figure('Position', [100, 100, 1600, 800]);  % 创建一个较大的图形窗口
for index = 1:Func_numbers
    [lb, ub, dim, fobj] = Get_CEC_details(year, index, dim,Func_names);
    Best_fitness = zeros(repeat_numbers, Algorithms_numbers);
    Best_pos = zeros(repeat_numbers, Algorithms_numbers, dim);
    Iter_curve = zeros(repeat_numbers, Algorithms_numbers, max_FES/1000); 
    % 求解
    
    parfor repeat_index = 1:repeat_numbers
        for i = 1:Algorithms_numbers
            [Best_fitness(repeat_index, i), Best_pos(repeat_index, i, :), Iter_curve(repeat_index, i, :)] = funcs{i}(popsize, dim, maxIter, lb, ub, fobj,max_FES);
        end
    end
    
    Best_fitness_csv(:,index,:)=Best_fitness;
    Position_csv(:,index,:,:)=Best_pos(:,:,:);   
    Iter_curve_csv(:,index,:,:)=Iter_curve(:,:,:);
    
    Average_fitness(index,:)=mean(Best_fitness,1);
    Std_fitness(index,:)=std(Best_fitness,1);
    Gbest_fitness(index,:)=min(Best_fitness,[],1);
    %% 绘制箱图
	subplot(4, 8, index)  % 将每个函数放到 4x8 的网格中
    boxplot(Best_fitness, 'Whisker', 1.5,'Labels', Algorithms_name);  % 绘制箱形图，'Whisker'控制胡须的长度
    title(sprintf('%s Function %s', year, Func_names(index)));
    xlabel('Algorithm Category');
    ylabel('Average Fitness');
    
end

%% save name
filename=sprintf('%s-repeat_number%d-popsize%d-maxIter%d',year,repeat_numbers, popsize, maxIter);

% 保存箱图到文件（例如 PNG 格式）% 创建动态文件名
if ~exist('figure_box', 'dir')
        % 创建文件夹
        mkdir('figure_box');
        fprintf('文件夹已创建: %s\n', 'figure_box');
    else
        fprintf('文件夹已存在: %s\n', 'figure_box');
    end
boxplot_filename = fullfile('figure_box', strcat(var,'-',filename, '.pdf'));
exportgraphics(gcf, boxplot_filename );

%% csv Fitness
FITNESS_foldername = strcat('FITNESS', '--', filename);
% 检查文件夹是否已经存在
    if ~exist(FITNESS_foldername, 'dir')
        % 创建文件夹
        mkdir(FITNESS_foldername);
        fprintf('文件夹已创建: %s\n', FITNESS_foldername);
    else
        fprintf('文件夹已存在: %s\n', FITNESS_foldername);
    end
% 创建动态文件名
FITNESS_filename = fullfile(FITNESS_foldername, strcat(filename, '.xlsx'));
row_titles_cell = cellstr(Func_names);  % 将数字数组转换为单元格数组
col_titles_cell = cellstr(Algorithms_name);
% 组合成完整数据矩阵

sheet_data=Average_fitness;
data_with_titles = [ {''}, col_titles_cell; row_titles_cell', num2cell(sheet_data)];  % 添加行和列标题
writecell(data_with_titles, FITNESS_filename, 'Sheet', 'Average', 'Range', 'A1');

for i = 1:repeat_numbers
    sheet_data = squeeze(Best_fitness_csv(i, :, :));
    data_with_titles = [ {''}, col_titles_cell; row_titles_cell', num2cell(sheet_data)];  % 添加行和列标题
    % 使用 writematrix 写入 Excel 文件，每个矩阵存储到不同的 sheet 中
    sheet_name = ['repeat ' num2str(i)];
    writecell(data_with_titles, FITNESS_filename, 'Sheet', sheet_name, 'Range', 'A1');
end
%% csv Position
POSITION_folder_name = strcat('POSITION', '--', filename);

% 检查文件夹是否已经存在
    if ~exist(POSITION_folder_name, 'dir')
        % 创建文件夹
        mkdir(POSITION_folder_name);
        fprintf('文件夹已创建: %s\n', POSITION_folder_name);
    else
        fprintf('文件夹已存在: %s\n', POSITION_folder_name);
    end
    
% 假设我们在每个文件中写入相应的函数名
for i = 1:length(Func_names)
    % 获取函数名作为文件夹名称
    Func_folder_name =fullfile(POSITION_folder_name,char(Func_names(i)));
    
    % 检查文件夹是否已存在
    if ~exist(Func_folder_name, 'dir')
        % 创建文件夹
        mkdir(Func_folder_name);
        fprintf('文件夹已创建: %s\n', Func_folder_name);
    else
        fprintf('文件夹已存在: %s\n', Func_folder_name);
    end
    
    % 生成Excel文件名
    POSITION_filename = fullfile(Func_folder_name,strcat(filename, '.xlsx'));
    
    for j = 1:repeat_numbers
        % 获取当前的数据
        sheet_data =  squeeze(Position_csv(j,i, :, :));
        % 合并行列标题与数据
        data_with_titles = [col_titles_cell', num2cell(sheet_data)];
        
        sheet_name = ['repeat ' num2str(i)];
        writecell(data_with_titles, POSITION_filename, 'Sheet', sheet_name, 'Range', 'A1');
    end
end

disp('数据已成功存入 Excel 文件');


%% csv curve
CURVE_folder_name = strcat('CURVE', '--', filename);

% 检查文件夹是否已经存在
    if ~exist(CURVE_folder_name, 'dir')
        % 创建文件夹
        mkdir(CURVE_folder_name);
        fprintf('文件夹已创建: %s\n', CURVE_folder_name);
    else
        fprintf('文件夹已存在: %s\n', CURVE_folder_name);
    end
    
% 假设我们在每个文件中写入相应的函数名
for i = 1:length(Func_names)
    % 获取函数名作为文件夹名称
    Func_folder_name =fullfile(CURVE_folder_name,char(Func_names(i)));
    
    % 检查文件夹是否已存在
    if ~exist(Func_folder_name, 'dir')
        % 创建文件夹
        mkdir(Func_folder_name);
        fprintf('文件夹已创建: %s\n', Func_folder_name);
    else
        fprintf('文件夹已存在: %s\n', Func_folder_name);
    end
    
    % 生成Excel文件名
    CURVE_filename = fullfile(Func_folder_name,strcat(filename, '.xlsx'));
    
    for j = 1:repeat_numbers
        % 获取当前的数据
        sheet_data =  squeeze(Iter_curve_csv(j,i, :, :));
        % 合并行列标题与数据
        data_with_titles = [col_titles_cell', num2cell(sheet_data)];
        
        sheet_name = ['repeat ' num2str(i)];
        writecell(data_with_titles, CURVE_filename, 'Sheet', sheet_name, 'Range', 'A1');
    end
end

disp('数据已成功存入 Excel 文件');

%% 表格
% 创建一个图形窗口并生成一个uitable
fig = uifigure("Position", [500 500 760 360],'Name', year);

% 创建一个uitable，设置其大小为填满整个窗口
h = uitable(fig, 'Data', num2cell(round(Average_fitness, 2)), ...
            'ColumnName', Algorithms_name, ...
            'RowName', Func_names, ...
            'Position', [20 20 500 300]);

% 创建字体加粗样式
sBold = uistyle("FontWeight", "bold");  % 字体加粗样式
% 创建黄色背景色样式
yellowBackground = uistyle("BackgroundColor", [1 1 0]);  % 黄色背景色

% 遍历每一行，找到最小值并应用加粗字体和黄色背景
for row = 1:Func_numbers
    [~, col] = min(Average_fitness(row, :));  % 找到每行最小值的列索引
    % 为该单元格应用加粗样式
    addStyle(h, sBold, "cell", [row, col]);
    % 为该单元格应用黄色背景色
    addStyle(h, yellowBackground, "cell", [row, col]);
end
%% frideman+柱状图
% 使用 Friedman 检验计算排名
[~, ~, rk] = friedman(Average_fitness);

% 提取 Friedman 排名的平均排名
rk = rk.meanranks;

% 绘制柱状图
figure;
b = bar(rk);

% 设置 x 轴标签为 Algorithms_name
set(gca, 'xticklabel', Algorithms_name);

% 设置标题和标签
title(sprintf('%s Friedman Test Mean Ranks', year));
xlabel('Algorithm Category');
ylabel('Mean Rank');

% 在柱状图顶部标注每列的数字
for i = 1:length(rk)
    % 微调数字的显示位置，避免与柱状图重叠
    text(i, rk(i) + 0.05, num2str(rk(i), '%.2f'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

% 如果需要调整字体大小
set(gca, 'FontSize', 12);

% 保存柱状图到文件（例如 PNG 格式）% 创建动态文件名
if ~exist('figure_bar', 'dir')
    % 创建文件夹
    mkdir('figure_bar');
    fprintf('文件夹已创建: %s\n', 'figure_bar');
else
    fprintf('文件夹已存在: %s\n', 'figure_bar');
end
friedman_filename = fullfile('figure_bar', strcat(var,'-',filename, '.png'));
saveas(gcf, friedman_filename);  % 使用 saveas 保存图形为图片
