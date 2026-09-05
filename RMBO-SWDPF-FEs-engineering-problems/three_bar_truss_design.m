function PHI =three_bar_truss_design(x)
%% Three Bar Truss Design
    PCONST=10000;  % PENALTY FUNCTION CONSTANT
    P=2;
    RU=2;
    L=100;
    fit=(2*(2*x(1))^1/2+x(2))*L;
    G1=((2)^1/2*x(1)+ x(2))/ ((2)^1/2*x(1)^2+ 2*x(1)*x(2))*P-RU;
    G2= (x(2))/ ((2)^1/2*x(1)^2+2*x(1)*x(2))*P-RU;
    G3= (1)/(x(1)+ (2)^1/2*x(2))*P-RU;
    PHI =fit + PCONST*(max(0,G1)^2+max(0,G2)^2+ max(0,G3)^2);
end