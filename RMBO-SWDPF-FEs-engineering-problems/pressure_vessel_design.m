function PHI = pressure_vessel_design(x)
%% Pressure Vessel design
    PCONST=10000;  % PENALTY FUNCTION CONSTANT
    fit= 0.6224*x(1)*x(3)*x(4)+ 1.7781*x(2)*x(3)^2 + 3.1661 *x(1)^2*x(4) + 19.84 * x(1)^2*x(3);
    G1= -x(1)+ 0.0193*x(3);
    G2=  -x(2) + 0.00954* x(3);
    G3=  -pi*x(3)^2*x(4)-(4/3)* pi*x(3)^3 +1296000;
    G4= x(4) - 240;
    PHI =fit + PCONST*(max(0,G1)^2+max(0,G2)^2+...
        max(0,G3)^2+max(0,G4)^2); % PENALTY FUNCTION
end
