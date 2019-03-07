
function [ Score,Ranked_Adge_T,KSVD_op]=SVD_ABFreq_based_ranking(Sparse_Data, TS_Data_indexed0) 
global K T_Concept2Dict
%% Exclude the hifrequencies
TS_Data=TS_Data_indexed0;

A=TS_Data.AFreq;
B=TS_Data.BFreq;
F=TS_Data.ABFreq;
class=TS_Data.Class;

%% ABFreq SCore
[ Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]= Find_Predicted_class(class,F) ;           
Results_Comp=TS_Data(:,{'EdgeNumber', 'NodeA','NodeB','AFreq','BFreq','Class', 'ABFreq'});
Results_Comp.ABRatio=A./B;
Results_Comp.F=Results_prediction.Predicted;  
Results_Comp.ABFreq=Results_prediction.Score;

[Ranked_Adge_T, Edges_to_remove,Results_TH]=Get_most_trusted_ranks(Results_Comp,TS_Data);

%% SVD ranking 1
cnt=1;
[Sparse_Data2,TS_Data2]=remove_edges_From_matrix(Edges_to_remove,TS_Data,Sparse_Data);

[ Score2,Ranked_Adge_k,KSVD_op]=Get_score_Adges(TS_Data2,Sparse_Data2);
[ Results_prediction,ORI, accuracy,MSE,Over_Under_rank,Top1, mAP, ORI_ranks, SumTop1]=Find_Predicted_class(Ranked_Adge_k.Class ,Ranked_Adge_k.ScoreOp) ;           


% [Ranked_Adge_T, Edges_SVD,Idx_SVD,Results_TH]=Get_most_trusted_SVD_ranks(Results_Comp,TS_Data)

%% SVD ranking 2
% Remove  highly ranked edges   
    Ranked_Adge_k = sortrows(Ranked_Adge_k,'ScoreOp','descend');
    Edges_to_remove=Ranked_Adge_k.EdgeNumber(1:Top12);

    [Sparse_Data3, TS_Data3]=remove_edges_From_matrix(Edges_to_remove,TS_Data2,Sparse_Data2);

    [ Score3,Ranked_Adge3,KSVD_op3]=Get_score_Adges(TS_Data3,Sparse_Data3);
    [Results_prediction,Unblc, accuracy,MSE,Over_Under_rank,Top13]=Find_Predicted_class(Ranked_Adge3.Class ,Ranked_Adge3.ScoreOp) ;           


%% Get the higher edges levels




Wmin=min(TS_Data_indexed0.ABFreq);
Wmax=max(TS_Data_indexed0.ABFreq);

Idx_subGraph=find(TS_Data_indexed0.ABFreq>Wmax/2);

TS_Data=TS_Data_indexed0(Idx_subGraph, {'EdgeNumber','NodeA','NodeB','ABFreq','Class'});

%% SVD Ranking 
 
TS_Data=sortrows(TS_Data ,'Class','descend');

%% get the high ab_freq of the ground truth edges
ab_freq=Get_AB_freq(table2array(TS_Data(:,{'NodeA','NodeB'})), Sparse_Data);

%% Use SVD to score the ground truth edges 
[ Score2,Ranked_Adge_T2,KSVD_op]=Get_score_Adges(TS_Data,Sparse_Data);


d=1;



function  [Ranked_Adge_T, Edges_to_remove,Results_TH]=Get_most_trusted_ranks(Results_Comp,TS_Data)

A=TS_Data.AFreq;
B=TS_Data.BFreq;
F=TS_Data.ABFreq;

Results_Comp.Capacity=F./(A+B);
Results_Comp=sortrows(Results_Comp ,'Capacity','descend');
Capacity_vect=Results_Comp.Capacity;
Capacity= 0.25*(max(Capacity_vect)-min(Capacity_vect))+min(Capacity_vect);
figure;
plot(Capacity_vect); hold on
plot(Capacity+0* Capacity_vect); hold on


% Remove ABFreq edges with high capacity 
    Idx=find(Capacity_vect>Capacity);
        
    Ranked_Adge_T=Results_Comp(Idx,{'EdgeNumber','NodeA','NodeB','Class' ,'ABFreq','Capacity'});

%     Idx=min(find(Capacity_vect<=Capacity));
%     Ranked_Adge_T=Results_Comp(Idx:end,{'EdgeNumber','NodeA','NodeB','Class' ,'ABFreq','Capacity'});
    
    Ranked_Adge_T.SVDScore=0*Ranked_Adge_T.ABFreq;

    Edges_to_remove= Ranked_Adge_T.EdgeNumber;
%     [Edges_SVD,Idx_SVD] = setdiff(TS_Data.EdgeNumber, Ranked_Adge_T.EdgeNumber);
    
  Results_TH=Results_Comp;
 

  
  
function  [Ranked_Adge_T, Edges_SVD,Idx_SVD,Results_TH]=Get_most_trusted_SVD_ranks(Results_Comp,TS_Data)

A=TS_Data.AFreq;
B=TS_Data.BFreq;
F=TS_Data.ABFreq;

Results_Comp.Capacity=F./(A+B);
Results_Comp=sortrows(Results_Comp ,'Capacity','descend');
Capacity_vect=Results_Comp.Capacity;
Capacity= 0.25*(max(Capacity_vect)-min(Capacity_vect))+min(Capacity_vect);
figure;
plot(Capacity_vect); hold on
plot(Capacity+0* Capacity_vect); hold on


% Remove ABFreq edges with high capacity 
    Idx=max(find(Capacity_vect>Capacity));
    
    Ranked_Adge_T=Results_Comp(1:Idx-1,{'EdgeNumber','NodeA','NodeB','Class' ,'ABFreq','Capacity'});
    Ranked_Adge_T.SVDScore=0*Ranked_Adge_T.ABFreq;

    [Edges_SVD,Idx_SVD] = setdiff(TS_Data.EdgeNumber, Ranked_Adge_T.EdgeNumber);
    
  Results_TH=Results_Comp;
  
  
