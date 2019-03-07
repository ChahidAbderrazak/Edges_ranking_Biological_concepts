%% Find the best thresults for ranking 

function [Thshold_op, accuracy_op, Roc_op, Results_prediction,Unblc_op, High_rank_op]= Find_Best_Threshold(class, Score)
   global cnt



N=size(Score,1);
RankL=max(size(find(class==0)));   
RankH=max(size(find(class==1))); 
       
   %% Set the highest scores as 1
       roc=0;accuracy_op=-inf;accuracy_op_TH=-inf;
    for Thshold= median(Score)%linspace(min(Score),max(Score),2*N) %unique(Score)'

        Idx_high_rank= find(Score>=Thshold);       
        predict_Class=zeros(N,1);
        predict_Class(Idx_high_rank)= 1;

        % Compute the ranking performance 
        Err=class-predict_Class;
        Rank_weight=class*10 -5;
   
        idx_0=max(size(find(predict_Class==0)));   
        idx_1=max(size(find(predict_Class==1))); 
        Unblc=RankH-idx_1;
%         if abs(idx_0-idx_1)<=10

                roc=roc+1;
                [accuracy(roc), sensitivity(roc), specificity(roc), precision(roc), gmean(roc), f1score(roc)]=prediction_performance(class, predict_Class);
                
                
                if accuracy_op<accuracy(roc)
                    accuracy_op=accuracy(roc);
                    Unblc_op=Unblc;
                    Thshold_op=Thshold;
                    Results_prediction=predict_Class;
                    High_rank_op=High_rank;

                end

             %% Build the optimal threshold Roc 
            if accuracy_op_TH<accuracy_op

                accuracy_op_TH=accuracy_op;
                Roc_op=[1-specificity', sensitivity'];

            end
    
%         end
    
    end
 

% Unblc_op
% accuracy_op
Results_prediction=[class, Results_prediction, Score];
Results_prediction=array2table(Results_prediction,'VariableNames',{'Class','Predicted','Score'});

%% Plot results

% Range_Ppredict=sortrows(Results_prediction,[1 2],'descend');
% plot( 0.1*cnt*normalize(Range_Ppredict.Predicted,'range'));hold on

 d=1;
   

    
function Rank=Conver_class_rank(class)

