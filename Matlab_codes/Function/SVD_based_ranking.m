
function [ Score,Ranked_Adge_T,KSVD_op]=SVD_based_ranking(Sparse_Data,TS_Data_indexed) 
global K T_Concept2Dict
% fprintf('\n --> Scoring the graph using SVD....\n')

% TS_Data_indexed=table2array(TS_Data_indexed);


%% Use SVD to score the ground truth edges 
[ Score,Ranked_Adge_T,KSVD_op]=Get_score_Adges(TS_Data_indexed,Sparse_Data);
 d=1;


 %% Testing scripts

%  Ranked_Adge_T_0=Ranked_Adge_T; clearvars Ranked_Adge_T
% cnt=1;
% % Ranked_Adge_T=Ranked_Adge_T_0;
% TS_Data_indexed_k=TS_Data_indexed;
% %% Rank round 2
% for k=1:10
%     Nt=size(TS_Data_indexed_k,1);
%     Nt_k=5;%floor(Nt*0.087)-1;
%     Ranked_Adge_T(cnt:cnt-1+Nt_k,:)=Ranked_Adge_T_0(1:Nt_k,:); cnt=cnt+Nt_k;
%     Edge_to_remove=table2array(Ranked_Adge_T_0(1:Nt_k,1:2))
% 
% 
%     %% remove raked adges
%     [Sparse_Data_k]=Remove_edges_from_Test_data(Edge_to_remove,Sparse_Data );
%     TS_Data_indexed_k=[ Ranked_Adge_T_0.ConceptA(Nt_k+1:end)  Ranked_Adge_T_0.ConceptB(Nt_k+1:end)  Ranked_Adge_T_0.Class(Nt_k+1:end)];
% 
%     [ Score,Ranked_Adge_T_0]=Apply_K_SVD_based_ranking(Sparse_Data_k, TS_Data_indexed_k) ;
% 
% end
% d=1



    
 
 

 
 function [Sparse_Data, TS_Data_indexed]=Remove_edges_from_Test_data(Edges,Sparse_Data, TS_Data_indexed )


% ab_freq=Get_AB_freq(TS_Data_indexed(1,:), Sparse_Data)


for k=1:size(Edges,1)
    
    Sparse_Data(Edges(k,1), Edges(k,2))=0;
    Sparse_Data(Edges(k,2), Edges(k,1))=0;
    
end

d=1;
