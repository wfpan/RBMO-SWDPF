function PHI = gear_train_design(x)
    %% gear train design
    %PCONST=10000;  % PENALTY FUNCTION CONSTANT
    fit=((1/6.931)- floor (x(1))*floor (x(2))/floor (x(3))*floor (x(4)))^2;
    PHI=fit;
end