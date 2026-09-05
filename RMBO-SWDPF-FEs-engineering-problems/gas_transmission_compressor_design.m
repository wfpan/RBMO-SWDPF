function PHI = gas_transmission_compressor_design(x)
    %% gas_transmission_compressor_design
    PCONST=10000;  % PENALTY FUNCTION CONSTANT
    fit= 8.61* 10^5*x(1)^(1/2)*x(2)*x(3)^(-2/3)*x(4)^(-1/2)
   +3.69*10^4*x(3)+7.72*10^(-1)*x(2)^(0.219)-765.43*10^(6)*x(1)^(-1) ;
    G1= x(4)*x(2)^(-2)+x(2)^(-2)-1;
    PHI =fit + PCONST*(max(0,G1)^2);
end