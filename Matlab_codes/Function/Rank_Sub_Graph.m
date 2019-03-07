% Concepts=Concepts;
% function [ Score,Ranked_Adge]=Rank_Sub_Graph(graph, groundtruth,names)

%% Get the dicionaries sorted
    Dicts=unique([graph.dict_a; graph.dict_b]);     % get the existing Dicionaries
    Nd=max(size(Dicts));

%% Get the concepts 
    % Concepts=Get_concepts_list(graph,names);          % get the existing Concepts graph
    Concepts=Get_concepts_list(groundtruth, names(:,{'concept_id','name'}));     % get the existing Concepts in groundtruth

    Nc=max(size(Concepts)); 
    % assign to each concept its dictionary from the Dataset <graph>
    [Concepts2Dict, T_Concept2Dict]=Get_Concept2Dict(graph,Concepts,names(:,2:3));

%% Build the  indexed data for the graph of concepts as  nodes 
% [Sparse_Data,graph_indexed]=Get_Indexed_data(Col_num, graph, T_Concept2Dict);

%% Build the  indexed data for the graph of concepts  using  truth data 
Col_num=8;            % the graph weights:  6) ab_freq    7)Pvalue   8)fdr
[ TS_Data_indexed_GR]=Get_Indexed_data_test(Col_num,graph,groundtruth,T_Concept2Dict);

% X_features=Ranked_Adge(:,[1 2 7 8 9 10]);
% 
% X_features.Score=Score;
% X_features.ScoreL=ScoreL;
% X_features.Score_GR=Score_GR;
% 
% 
% %% Combine the scores with other features : ab_freq, pvalue, fdr
% X_features=Get_Other_Features(X_features, graph_indexed);
% 
% X_features.Class=Ranked_Adge.Class;
% 
% save('./Feature_Scores/KSVD_feature_Combine2_PMI.mat','X_features')
% 
