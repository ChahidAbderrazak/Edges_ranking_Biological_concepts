
function [ Score,Ranked_Adge_T,KSVD_op]=SVD_Levels_based_ranking(Level, Sparse_Data, TS_Data_indexed0) 
global K T_Concept2Dict


TS_Data=TS_Data_indexed0(:, {'EdgeNumber', 'NodeA','NodeB','ABFreq','Class'});


%% get the high ab_freq of the ground truth edges
ab_freq=Get_AB_freq(table2array(TS_Data(:,{'NodeA','NodeB'})), Sparse_Data);
Wmin=min(ab_freq);
Wmax=max(ab_freq);

%% remove the high edges from the occurance graph 
Sparse_Data(Sparse_Data>Level*Wmax)=0;

%% Use SVD to score the ground truth edges 
[ Score,Ranked_Adge_T,KSVD_op]=Get_score_Adges(TS_Data,Sparse_Data);


    
 

