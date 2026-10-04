function [Alpha_score,Alpha_pos,Conv_selected]=GNHGWO(nPop,nVar,~,VarMin,VarMax,fobj,max_FES)
    %%   NH-Grey Wold Optimizer (GWO)
    FES=0;
    NFES = FES; 
    % Initialize Best Solution (Alpha) which will be used for archiving
    Alpha_pos=zeros(1,nVar);
    Alpha_score=inf;

    %Initialize the positions of search agents 
    Positions=rand(nPop,nVar).*(VarMax-VarMin)+VarMin;
    Positions1=rand(nPop,nVar).*(VarMax-VarMin)+VarMin;
% 	Positions1=pop;
   
    Conv=zeros(1,max_FES);

    Conv_selected=zeros(1, max_FES/1000);
    fitness(1:nPop)=inf;
    fitness1=fitness;

%     iter=0;  % Loop counter

    %% Main loop
    while FES<max_FES
        for i=1:nPop

            % Return back the search agents that go beyond the boundaries of the search space
            Flag4ub=Positions1(i,:)>VarMax;
            Flag4lb=Positions1(i,:)<VarMin;
            Positions1(i,:)=(Positions1(i,:).*(~(Flag4ub+Flag4lb)))+VarMax.*Flag4ub+VarMin.*Flag4lb;
            if FES>=max_FES
                break;
            end
            % Calculate objective function for each search agent
            fitness1(i)= fobj(Positions1(i,:));
            FES=FES+1;
           
            % Update Grey Wolves
            if fitness1(i)<fitness(i)
                Positions(i,:)=Positions1(i,:);
                fitness(i) =fitness1(i) ;
            end

            % Update Best Solution (Alpha) for archiving
            if fitness(i)<Alpha_score
                Alpha_score=fitness(i);
                Alpha_pos=Positions(i,:);
            end

        end
        Conv(1, NFES+1 : FES) =Alpha_score;
        NFES = FES; 
        
        a=2-2*(FES/max_FES); % a decreases linearly fron 2 to 0

        % Update the Position of all search agents
        for i=1:nPop
            for j=1:nVar

                GGG=randperm(nPop-1,3);
                ind1= GGG>=i;
                GGG(ind1)=GGG(ind1)+1;
                m1=GGG(1);
                m2=GGG(2);
                m3=GGG(3);

                r1=rand;
                r2=rand;

                A1=2*a*r1-a;
                C1=2*r2;

                D_alpha=abs(C1*Positions(m1,j)-Positions(i,j));
                X1=Positions(m1,j)-A1*D_alpha;

                r1=rand;
                r2=rand;

                A2=2*a*r1-a;
                C2=2*r2;

                D_beta=abs(C2*Positions(m2,j)-Positions(i,j));
                X2=Positions(m2,j)-A2*D_beta;

                r1=rand;
                r2=rand;

                A3=2*a*r1-a;
                C3=2*r2;

                D_delta=abs(C3*Positions(m3,j)-Positions(i,j));
                X3=Positions(m3,j)-A3*D_delta;

                Positions1(i,j)=(X1+X2+X3)/3;

            end
        end
%         if iter <MaxIt
%             iter=iter+1;
%         end
%         BestCosts(iter)=Alpha_score;
    end
        indices = [1000:1000:max_FES];
    Conv_selected = Conv(indices);
end