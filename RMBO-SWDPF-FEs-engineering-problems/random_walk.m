function Xnew=random_walk(X,XBest,t,tmax)
    row=size(X,1);
    cow=size(X,2);
    c=6;
    a=(t/tmax)^2;
    for i=1:row
        for j=1:cow
            r1=rand;
             Xnew(i,j) = X(i,j) + (c * r1 - c / 2) * cos(pi / 2 *a) * (X(i,j) - XBest(j));
        end
    end
end
