clear all; close all; addpath ./Function 

%% Load Concepts data 


load('./Input_Data/Data_Adil_Oct06nd2018.mat')


%% Get the dicionaries sorted
Data=table2array(graph);                    % convert table to matrix
Dicts=unique([Data(:,9); Data(:,10)]);     % get the existing Dicionaries
Nd=max(size(Dicts));

%% Get the conceptes  from the ground thruth dataset
Concepts =Get_concepts_from_groundtruth(groundtruth);    % get the existing Dicionaries
Nc=max(size(Concepts)); 
%% assign to each concept its dictionary from the Dataset <Data>
[Concept2Dict, T_Concept2Dict]=Get_Concept2Dict(Data,Concepts);


%% Build the the idexed data with nodes  existing in the test dataset
[Sparse_Data,Data_indexed, concept_a, concept_b, a_freq, b_freq, ab_freq, p_value, fdr,Full_Data]=Get_Indexed_data(Data,Concept2Dict);


%% Build the  indexed data for the graph of concepts  using  truth data 
[TS_Sparse_Data,TS_Data_indexed, TS_concept_a, TS_concept_b, TS_Class]=Get_Indexed_data_test(groundtruth,Concept2Dict);




% save('./Input_Data/graph_matrix/Data_Adil_Oct06nd2018_matrices_full_TS.mat','Full_Data','graph','names','groundtruth','Sparse_Data','Data_indexed','concept_a','concept_b','a_freq','b_freq','ab_freq',...
%          'p_value','fdr','Data','Concept2Dict','Dicts','Concepts','Nd','Nc','TS_Sparse_Data','TS_Data_indexed', 'TS_concept_a', 'TS_concept_b', 'TS_Class')
%      
%  