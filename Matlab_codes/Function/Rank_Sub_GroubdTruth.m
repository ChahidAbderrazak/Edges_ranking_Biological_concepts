% Concepts=Concepts;
function [ Score,Ranked_Adge]=Rank_Sub_GroubdTruth(graph, groundtruth,names)

%% Get the dicionaries sorted

Dicts=unique([graph.dict_a; graph.dict_b]);     % get the existing Dicionaries
Nd=max(size(Dicts));
names=names(:,2:3);

%% Get the conceptes 
% Concepts=Get_concepts_list(graph,names);          % get the existing Concepts graph
Concepts=Get_concepts_list(groundtruth, names);     % get the existing Concepts in groundtruth

Nc=max(size(Concepts)); 

%  [name_pairs]=Get_Concept_names(names, Concepts)

% Nc2=20;
% Idx_cncpt=unique(randi(Nc,1,Nc2));
%% assign to each concept its dictionary from the Dataset <Data>
[Concepts2Dict, T_Concept2Dict]=Get_Concept2Dict(graph,Concepts,names);

%% Build the  indexed data for the graph of concepts as  nodes 
[Sparse_Data,graph_indexed, concept_a, concept_b, a_freq, b_freq, ab_freq, p_value, fdr]=Get_Indexed_data(groundtruth,T_Concept2Dict);

%% Build the  indexed data for the graph of concepts  using  truth data 
[TS_Sparse_Data,TS_graph_indexed0, TS_concept_a, TS_concept_b, TS_Class]=Get_Indexed_data_test(groundtruth,T_Concept2Dict);

%% Split the groun truth grapg to Training and test
TS_Ratio=20;        % the percentage of testing data with respect to the groung truth
[Data_indexed_Blcd, graph_indexed_TR, graph_indexed_TS]=Get_balanced_Testing_data(TS_Ratio, TS_graph_indexed0);




%% Score the graph KSVD
[ Score,Ranked_Adge]=SVD_based_ranking(Sparse_Data, Data_indexed_Blcd);

%% Score the graph KSVD with threshold level
Level=1.5;
[ ScoreL,Ranked_Adge_L]=SVD_Levels_based_ranking(Level, Sparse_Data, Data_indexed_Blcd);

figure(123);A=legend('All Neighbors connection','Neighbors connection ratio=1.5');A.FontSize=14;




%% Rescore use weights below a threshold Max_weight
Max_weight=max(ab_freq);
Sparse_Data2=Sparse_Data;
max(max(Sparse_Data2)) 
Sparse_Data2(Sparse_Data2>Max_weight)=0
max(max(Sparse_Data2)) 

%% Score the graph2
[ Score2,Ranked_Adge_T2]=SVD_based_ranking(Sparse_Data2, TS_graph_indexed) ;

