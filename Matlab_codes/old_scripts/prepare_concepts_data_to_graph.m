clear all; close all; addpath ./Function 
global T_Concept2Dict
%% Load Concepts data 
load('./Input_Data/Data_Adil_Oct06nd2018.mat')


%% Get the dicionaries sorted
Data=table2array(graph);                    % convert table to matrix
Dicts=unique([Data(:,9); Data(:,10)]);     % get the existing Dicionaries
Nd=max(size(Dicts));

%% Get the conceptes 
% Concepts=Get_concepts_list(graph,names);          % get the existing Concepts graph
Concepts=Get_concepts_list(groundtruth, names);     % get the existing Concepts in groundtruth

[ Score,Results_table,Adg_ranked]=Rank_Sub_Graph(Data, Concepts);

% global K
% 
% K=60;
%  TS_Data_indexed_Blced=Get_Balanced_TS(TS_Data_indexed);
%  [Results,Thshold_op_TN]=Apply_KSVD(K, Sparse_Data, TS_Data_indexed_Blced);
%  %% Plot the ranked graph 
% Plot_graph(Adg_ranked)

% save('Example_Vars_GroundTH_Graph_TS_Graph.mat')
% save('SVD_results1.mat','Results_table')
% save('./Input_Data/graph_matrix/Data_Adil_Oct06nd2018_matrices.mat','graph','names','groundtruth','Sparse_Data','Data_indexed','concept_a','concept_b','a_freq','b_freq','ab_freq',...
%          'p_value','fdr','Data','Concept2Dict','Dicts','Concepts','Nd','Nc','TS_Sparse_Data','TS_Data_indexed', 'TS_concept_a', 'TS_concept_b', 'TS_Class')
