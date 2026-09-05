function PHI = compression_spring_design(x)
%% TENSION/COMPRESSION SPRING DESIGN PROBLEM DEFINITION (all units are in british system) 
    PCONST = 10000; % PENALTY FUNCTION CONSTANT

    fit=(x(3)+2)*x(2)*(x(1)^2);
    G1=1-(x(2)^3*x(3))/(71785*x(1)^4);
    G2=(4*x(2)^2-x(1)*x(2))/(12566*(x(2)*x(1)^3-x(1)^4))+1/(5108*x(1)^2);
    G3=1-(140.45*x(1))/(x(2)^2*x(3));
    G4=((x(1)+x(2))/1.5)-1;

    PHI = fit + PCONST*(max(0,G1)^2++max(0,G2)^2+...
        max(0,G3)^2+max(0,G4)^2); % PENALTY FUNCTION
end
