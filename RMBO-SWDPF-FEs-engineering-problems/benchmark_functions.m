
                      
%              Chaotic GSA for Mechanical Engineering Design Problems
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

% This function calculates the value of objective function.
function fobj=benchmark_functions(Benchmark_Function_ID)

% // Penalty Function Method has been used to deal with Constraints \\

    % Define the function handles for the different benchmark functions
benchmark_funcs = {
        @welded_beam_design,   % welded_beam_design 1
        @compression_spring_design, % compression_spring_design 2
        @pressure_vessel_design,  % pressure_vessel_design 3 
        @speed_reducer_design,  % speed_reducer_design 4
        @gear_train_design,     % gear_train_design 5
        @three_bar_truss_design, % three_bar_truss_design 6
        @cantilever_beam_design, % stepped_cantilever_beam_design 7
        @gas_transmission_compressor_design, % himmelblau_problem 8
};
    
    % Call the appropriate benchmark function based on the ID
    fobj = benchmark_funcs{Benchmark_Function_ID};

end
