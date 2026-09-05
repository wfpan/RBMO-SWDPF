
                      
%             Chaotic GSA for Mechanical Engineering Design Problems
% 
%                  E-Mail: sajad.win8@gmail.com                   
%                                                                         
%              Homepage: https://github.com/SajadAHMAD1.                            
%                                                                         
%   Main paper: Rather, S. and Bala, P. (2020), "Swarm-based chaotic gravitational search algorithm for solving mechanical engineering design problems",
%                                               World Journal of Engineering, Vol. 17 No. 1, pp. 97-114. https://doi.org/10.1108/WJE-09-2019-0254   

%               Department of Computer Science and Engineering
%               School of Engineering and Technology
%               Pondicherry University- 605014, India
%               
%   Programmer: Sajad Ahmad Rather      
%   Developed in MATLAB R2013a 



% This function gives boundaries and dimension of search space for test functions.

function [down,up,dim]=benchmark_functions_details(Benchmark_Function_ID)

    if Benchmark_Function_ID==1 %Welded Design
        down=[0.10;0.10;0.10;0.10]';
        up=[2;10;10;2]';
        dim=4;
    end
    if Benchmark_Function_ID==2 %Spring Design
        down=[0.05;0.25;2.00]';
        up=[2.00;1.30;15.0]';
        dim=3;

    end
    if Benchmark_Function_ID==3 %Pressure vessel

        down=[0;0;10;10]';         % Lower Bound of Variables
        up= [99;99;200;200]';    % Upper Bound of Variables
        dim=4;
    end
    if Benchmark_Function_ID==4 %Speed Reducer design
        down=[2.6;0.7;17;7.3;7.3;2.9;5]';         % Lower Bound of Variables
        up= [3.6;0.8;28;8.3;8.3;3.9;5.5]';        % Upper Bound of Variables
        dim=7;
    end
    if Benchmark_Function_ID==5 %Gear Train design
        down=[12;12;12;12]'; % Lower Bound of Variables
        up=[60;60;60;60]';   % Upper Bound of Variables
        dim=4;
    end
%     if Benchmark_Function_ID==6 %Himmelblau's Problem
%         down=[78;33;27;27;27]'; % Lower Bound of Variables
%         up=[102;45;45;45;45]';   % Upper Bound of Variables
%         dim=5;
%     end
    if Benchmark_Function_ID==6 % Three Bar Truss Design
        down=[0;0]'; % Lower Bound of Variables
        up=[1;1]';   % Upper Bound of Variables
        dim=2;
    end
    if Benchmark_Function_ID==7 % Cantilever Beam Design
        
        down = [0.01;0.01;0.01;0.01;0.01]';% Lower Bound of Variables
        up= [100;100;100;100;100]';% Upper Bound of Variables
        dim = 5; 
    end
    if Benchmark_Function_ID==8 %gas_transmission_compressor_design
        down=[20;1;20;0.1]'; % Lower Bound of Variables
        up=[50;10;50;60]';   % Upper Bound of Variables
        dim=4;
    end
%     if Benchmark_Function_ID==8 % Multiple Disc Clutch Brake Design
%         down=[60;90;1.5;600;2]'; % Lower Bound of Variables
%         up=[80;110;3;1000;9]';   % Upper Bound of Variables
%         dim=5;
%     end
%     if Benchmark_Function_ID==9 % Robot Gripper Design
%         down=[10;10;100;0;10;100;1]';        % Lower Bound of Variables
%         up=[150;150;200;50;150;300;3.14]';       % Upper Bound of Variables
%         dim=4;
%     end

end









