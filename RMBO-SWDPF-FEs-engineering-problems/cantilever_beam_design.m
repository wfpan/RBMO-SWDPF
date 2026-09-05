function PHI = cantilever_beam_design(x)
 %% Cantilever Beam Design
   panalty_factor = 10000;
%惩罚因子
g(1)=61/x(1)^3+37/x(2)^3+19/x(3)^3+7/x(4)^3+1/x(5)^3-1;% 惩罚项
penalty=panalty_factor*sum(g(g>0).^2);
PHI=0.0624*sum(x)+penalty;

end