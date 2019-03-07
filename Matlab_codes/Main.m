%% Concepts Edges Ranking using text mining : 
% Tis script studies the ranking of concepets based on their co-occirance 
% in scientific paper or literature document. The main goal of this work is
% to find scoring accuate enough to rank the stong relationships between
% words <concepts> based on how often they co-exist in texts.
%
%% ###########################################################################
%  Author:
%  Abderrazak Chahid (abderrazak.chahid@gmail.com)
%  Adviser:
%  Taous-Meriem Laleg (taousmeriem.laleg@kaust.edu.sa)
%  Vladimir Bajic (vladimir.bajic@kaust.edu.sa )

% Done: Dec,  2018
% King Abdullah University of Sciences and Technology (KAUST)
%% ###########################################################################


clear all; close all; addpath ./Function 
global T_Concept2Dict cnt; cnt=1;
%% Load Concepts data 
load('./Input_Data/Data_Adil_Oct06nd2018.mat')

%% Build the datset and graphs
Rank_Sub_Graph
% [ Score,Ranked_Adge_T]=Rank_Sub_Graph(graph, groundtruth,names);
load('./mat/example_ground_truth.mat')

%%  Compare scores
 
% Old matrics
    Compare_Scores_Ranking_Performance

% SVD based  matrics
    Compare_SVD_based_Compare_Scores_Ranking_Performance
    













% %% Load Concepts data 
% load('./Input_Data/graph_matrix/Data_Adil_Oct06nd2018_matrices0.mat')

% Load Concepts data 
% load('./Input_Data/graph_matrix/Data_Adil_Oct06nd2018_matrices_full_TS.mat')


% 
% global K
% 
% K=60;
%  
% Apply_KSVD(K, Sparse_Data, TS_Data_indexed_Blced)
%  
 
 % Exist_edge=Get_testing_edges(TS_Data_indexed_Blced);
% TS_Data_class_occ=Get_occur_data_test(TS_Data_indexed_Blced,Data_indexed);
% load('X_data2.mat')
% Data_features=[TS_Data_class_occ(:,3) Data_features];
% Data_features=[TS_Data_class_occ(:,3) Data_features(:,end)];
% [ Score,Results_table]=Get_score_Adges(TS_Data_indexed_Blced,Sparse_Data);

