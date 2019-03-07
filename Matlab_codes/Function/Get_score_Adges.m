%% Get the   score

function [score_op ,Ranked_Edges_table,KSVD_op,Score_matrix]=Get_score_Adges(TS_Data_indexed,Sparse_Data)

global T_Concept2Dict

TS_Data_indexed=sortrows(TS_Data_indexed ,'Class','descend');
TS_Data=TS_Data_indexed(:, {'EdgeNumber', 'NodeA','NodeB','AFreq','BFreq','Class'});
class=TS_Data.Class;


 %% Use SVD to rank
% tic
 [U,S0,V] =svds(Sparse_Data);
%  Full_Data=full(Sparse_Data);
%   [U,S0,V] =svd(Full_Data);
% 
%   U1=unique(U);

  
% toc


Nsvd=max(size(S0));
Ws=zeros(1,Nsvd);


% Score1
N=size(TS_Data,1);
% Weights=zeros(N,4);
predict_Classs=zeros(N,1);



idxU0=find(U(:,1:Nsvd)==Ws);
Idxall=1:size(U,1);
[idxU10,idxU00] = setdiff(Idxall, idxU0');
Sum_S=sum(sum(S0));

% S=eye(Nsvd);

%% Take half singular values
NE=floor(Nsvd/2);
% S(S<S(NE,NE))=0;

Cost_function=-inf;TP_op=-inf;Cost_function_TH=-inf; Cost_op=-inf;accuracy_op0=-inf;
cnt=0;

% S0=eye(Nsvd);

for sk=Nsvd:-1:1
    
    S=S0;
    if sk<=Nsvd+1
        S(sk:Nsvd,sk:Nsvd)=0 ;
%         S(sk,sk)=0 ;

    end
   
   K_svd=100*sum(sum(S))/Sum_S;

%    Cost_function=0;TP_op=0;Cost_function_TH=0;
 
%  score_op=[];  

 Cost_function=-inf;
 
    for num_score= 1:20

        %% Compute the SVD based score : num_score
        Weights = Compute_SVD_Scores(num_score, TS_Data, U, S, V);
        if Weights==-inf
            break;
        end
        
        %% Group the different weights  to select the optimal weighting score
        TS_Data2=TS_Data; TS_Data2.scoree=Weights;
       
        
        
        for k=1:size(Weights,2)
            Score= Weights(:,k);
            
            
            N_levels=max(size(unique(Score)));
            
            if N_levels<=2
                break;
            end
            
            %% Get the optimal threshold
%             [Thshold_op_k, Cost_function_k, Roc_op_k,Score_prediction_k,Unblc_op, Over_Under_rank_op_k]= Find_Best_Threshold(class,Score) ;           
            [Results_prediction,Unblc, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1 ]= Find_Predicted_class(class,Score);
          
             Cost_k=mAP;% Over_Under_rank*accuracy/100;%;%
            if Cost_function<Cost_k
                Cost_function=Cost_k;
                predict_Classs=Results_prediction.Predicted;
                score_equation_op0=num_score;
                score_idx_op0=k;
                score_op0=Score;%Weights(:,score_idx);
                Over_Under_rank_op0=Over_Under_rank;
                Results_prediction_op0=Results_prediction;
                SumTop1_op0=SumTop1;
                accuracy_op0=accuracy;
                MSE_op0=MSE;
                %% Build the corresponding optimal performance results

%                 Roc_op=Roc_op_k;
%                 Thshold_op=Thshold_op_k;
%                 Score_prediction_op=Score_prediction_k;

        
            end
    
%             cnt=cnt+1;Scores_comp(cnt,:)=[K_svd num_score Cost_function Over_Under_rank_op k];

        end
%         Data_features=[Weights   class ];
%         save(strcat('./Feature_Scores/X_data',num2str(num_score),'.mat'),'Data_features')


      if Cost_op < Cost_function
        Cost_op=Cost_function;
        predict_Classs_op=predict_Classs;
        score_equation=score_equation_op0;
        score_idx=score_idx_op0;
        score_op=score_op0;%Weights(:,score_idx);
        Over_Under_rank_op=Over_Under_rank_op0;
        Results_prediction_op=Results_prediction_op0;
        SumTop1_op=SumTop1_op0;
        accuracy_op=accuracy_op0;
        MSE_op=MSE_op0;
        KSVD_op=K_svd;
        Results=[predict_Classs score_op0];


      end
        clearvars Weights
        

    end
    % save('X_data.mat','Data_features'
    
     Scores_comp(sk,:)=[K_svd score_equation_op0 Cost_function accuracy_op0, MSE_op0,Over_Under_rank_op0,SumTop1_op0,k];

end

% score_equation
% score_idx
            
Results_T=TS_Data;
Results_T.Predicted=predict_Classs_op;
Results_T.ScoreOp=score_op;


score_op= unique(score_op', 'rows')';

Scores_comp_T=array2table(Scores_comp(:,:,1),'VariableNames',{'K_SVD','OpScore_Equation','Cost','accuracy','MSE', 'OverUnderRank','SumTop1', 'Score_index'});



%% Plot RoC  Curve
% Plot_ROC(Roc_op)

%% Build the output table containing :'NodeA','NodeB','Score', 'Class', 'rank', 'abFreq', 'NameNodeA' , 'NameNodeB' ,'IdNodeA' ,'IdNodeB'
[Score_matrix, Ranked_Edges_table]=Build_output_Ranked_Edges_Table(Sparse_Data, Results_T);



d=1;


% Weights=Weights_full(1:N,1:N)
% Score1=Weights.*Exist_edge_to_Score ;
% Score1(find(Score1==0))=+inf;
% % Score1 = max(Score1,0);
% Score1_Rank=sort_matrix_values(Score1);
% % Plot the graph scores
% figure;
% 
% G1 = digraph(Score1_Rank.*Exist_edge_to_Score,names)
% h=plot(G1,'EdgeLabel',G1.Edges.Weight,'MarkerSize',25)%,'LineWidth',G2.Edges.Weight )
% set(gca,'XTickLabel',[],'YTickLabel',[])
% title('Scoring using Singlar vector:  V')
