
function [Ord, Num, BetaVal,I2000] = Cluster(I2000,NumSplit)


%Data clustering algorithm (matlab version 5.1,by Naama Barkai and Uri Alon).
%This program accepts a matrix of input data I2000,
%where each object to be clustered is represented by a column.
%It outputs three variables: Ord, Num and  BetaVal.
%Ord contains the post-clustering order of objects along the binary tree.
%Additional information about the binary tree is found in Num and BetaVal.
%Num contains the sizes of the clusters at each splitting, so that in the second
%row of Num are two nonzero entries corresponding to the sizes of the two clusters
%in the first division in the tree, the third row has 4 entries, etc.
%The matrix BetaVal contains the beta values of the corresponding cluster splits.
%NumSplit is split numbers for the binary tree


%Definitions


Converge = .001 ; 
ConvergeSplit = .001 ;
Split = .01 ; 
DiffSplit = 0 ;
OldSplit = 0 ;

NumClust = 2 ;%Split number
Beta0 = .5 ;  %Initial beta
DeltaBeta = .5 ;

eps=0.000000001; %eps for avoid singularity

Center(1:NumClust,:) = ones(NumClust,1)*mean(I2000') ; % Initial the center
Num = zeros(NumSplit+1,2^NumSplit) ;
BetaVal = zeros(NumSplit+1,2^NumSplit) ;
Num(1,1) = size(I2000,2) ; %Initial the first cluster

S_CompCenter = zeros(NumSplit,2^NumSplit );
E_CompCenter = zeros(NumSplit,2^NumSplit );
Ind_CompCenter = zeros(NumSplit,2^NumSplit );

S_CompCenter(1,1) = 1 ;
E_CompCenter(1,1) = size(I2000,2) ;
Ind_CompCenter(1,1) = 1 ;

tmpOrdVec = I2000 ;
Ord = 1:1:size(I2000,2) ; %Initial the order
tmpOrd = Ord ;



for nSplit=1:1:NumSplit
    
    I2000 = tmpOrdVec;
    nS = 0 ;
    Ord  = tmpOrd ; 
    NewClust = 0 ;
    
    for nClust = 1:1:2^(nSplit-1)
        if(Num(nSplit,nClust)>1)
            
            clear Dist Prob C  Z
            Beta = Beta0 ;
            SplitMeasure = 0 ;
            CInd = nS+1:Num(nSplit,nClust)+nS ;
            %nS
            bs = 0 ;
            while( (SplitMeasure<Split) || (abs(DiffSplit)>ConvergeSplit) )
                if( (bs==0) && (SplitMeasure>Split) )
                    BetaVal(nSplit,nClust) = Beta ;
                    bs=1 ;
                end
                
                Beta = Beta+DeltaBeta ;%update bata
                OldCenter = Center*0 ;
%                 
%                 figure(1); 
%                 
%                 plot(Center','r') ;
%                 hold on ;
%                 plot(mean(I2000(:,CInd)'),'y') ;
                
                Center  = Center.*(1+ 0.001*(rand(size(Center,1),size(Center,2))-.5)) ;% noisy to center
                
                DiffClust =5 ;
                while(DiffClust>Converge)
                    hold off
                    
                    DiffSplit = (OldSplit-SplitMeasure)/max(.01,SplitMeasure) ;
                    DiffClust = sqrt(sum(sum((Center-OldCenter).^2)))/sqrt(sum(sum((Center).^2))) ;
                    OldCenter = Center ;
                    OldSplit = SplitMeasure ;
                    
                    for k=1:1:NumClust
                        C = Center(k,:)'*ones(1,length(CInd)) ;
                        Dist(k,:) = sum(((I2000(:,CInd)-C).^2)) ;
                        Prob(k,:) = exp(-Beta.*Dist(k,:)) ;
                    end
                    Z = sum(Prob) ;
                    
                    
                    for k=1:1:NumClust
                        Prob(k,:) = Prob(k,:)./(Z+eps) ; %%get probility
                        Center(k,:) = (I2000(:,CInd)*Prob(k,:)'/(sum(Prob(k,:))+eps))' ;% update center
                    end
                    
                    pause (.001);
                    SplitMeasure = sqrt(sum((Center(1,:)-Center(2,:)).^2)); 
                end
                
            end
            
            %=======================================================
            %here we make the assignment of Data Points to Clusters
            %=======================================================
            %Calculating the distance from the final centers
            for k=1:1:NumClust
                C = Center(k,:)'*ones(1,length(CInd)) ;
                Dist(k,:) = sum(((I2000(:,CInd)-C).^2)) ;
            end
            
            
            
            
            %First We need to decide on the proper way of splitting the vectors (organize by closeness to the near-by cluster)
            
            in = S_CompCenter(nSplit,nClust):E_CompCenter(nSplit,nClust) ;
            if(length(in)>1)
                CompCenter = mean(I2000(:,in)') ;
            end
            if(length(in)==1)
                CompCenter = I2000(:,in)' ;
            end
            
            
            C = CompCenter'*ones(1,2) ;
            d = sum(((Center-C')'.^2)) ;
            
            if(Ind_CompCenter(nSplit,nClust)==1)
                if(d(1)<d(2))
                    Dist = Dist([2,1],:) ;
                    Center = Center([2,1],:) ;
                end
            end
            if(Ind_CompCenter(nSplit,nClust)==2)
                if(d(1)>d(2))
                    Dist = Dist([2,1],:) ;
                    Center = Center([2,1],:) ;
                end
            end
            
            
            
            %Now we do the actual assignment
            
            
            m = min(Dist)'*ones(1,size(Dist,1))  ;
            [IndMin,~] = find(m'==Dist) ;
            
            for k=1:1:NumClust                
                NewClust = NewClust+1 ;
                IndClust = (IndMin==k) ;
                
                %size(IndClust)
                %CAND=[CAND IndClust];
                Num(nSplit+1,NewClust) = sum(IndClust) ;
                
                if(k==1)
                    S_CompCenter(nSplit+1,NewClust) = nS+sum(IndClust)+1 ;
                    S_CompCenter(nSplit+1,NewClust+1) = nS+1 ;
                end
                if(k==2)
                    E_CompCenter(nSplit+1,NewClust-1) = nS+sum(IndClust) ;
                    E_CompCenter(nSplit+1,NewClust) = nS ;
                end
                Ind_CompCenter(nSplit+1,NewClust) = k ;
                
                
                
                tmp = I2000(:,CInd);
                tmp2 = Ord(CInd) ;
                tmpOrdVec(:,nS+1:nS+sum(IndClust)) = tmp(:,IndClust) ;
                tmpOrd(nS+1:nS+sum(IndClust)) =  tmp2(IndClust) ;
                
                nS = nS + sum(IndClust);
%                 figure(2) ;
%                 subplot(2,2,k) ;
%                 plot(mean(I2000(:,IndClust)')) ;
%                 title(['NumGenes=',num2str(sum(IndClust))]);
            end
        end
        if(Num(nSplit,nClust)==1)
            %CInd
            NewClust = NewClust+1 ;
            Num(nSplit+1,NewClust) = 1 ;
            nS = nS+1 ;
        end
    end
    I2000 = tmpOrdVec ;
    nS = 0 ;
    Ord  = tmpOrd ;
    
    
end