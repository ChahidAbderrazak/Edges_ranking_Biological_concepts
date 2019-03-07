
% Build the output table containing :
% 'NodeA','NodeB','Score', 'Class', 'rank', 'abFreq', 'NameNodeA' , 'NameNodeB' ,'IdNodeA' ,'IdNodeB'

function [Score_matrix, Ranked_Edges_table]=Build_output_Ranked_Edges_Table(Sparse_Data, Results)

global T_Concept2Dict

N=size(Results,2);
%     % nmevar= 'weights1'
%     nmevar{1}='A';
%     nmevar{2}='B';
% 
% 
%     for k=3:N-1
%     nmevar{k}=strcat('W',num2str(k-2));
%     end
% 
%     nmevar{N-2}='Class';
%     nmevar{N-1}='Predicted';
%     nmevar{N}='Wop';%strcat('Wop Th=',num2str(Thshold_op));


    concept_a=Results.NodeA; concept_b=Results.NodeB;
    Nc=max(max([concept_a;concept_b]));

%     Ranked_Edges=sortrows(Ranked_Edges,3,'descend');
    Edge_matrix=table2array(Results(:, {'NodeA','NodeB'}));
    M=size(Edge_matrix,1);

    ab_freq=Get_AB_freq(Edge_matrix, Sparse_Data);

    Ranked_Edges=[Edge_matrix  ab_freq'];
    Ranked_Edges_table=Results;
    Ranked_Edges_table.GraphWeights=ab_freq';
    
    [name_edges_pairs, ID_Concepts]=Get_Edges_names(Ranked_Edges, T_Concept2Dict);
    Ranked_Edges_table.NameNodeA=name_edges_pairs(:,1);
    Ranked_Edges_table.NameNodeB=name_edges_pairs(:,2);
    Ranked_Edges_table.IdNodeA=ID_Concepts(:,1);
    Ranked_Edges_table.IdNodeB=ID_Concepts(:,2);

    score_op=Results.ScoreOp;
    Score_matrix = sparse([concept_a;concept_b],[concept_b;concept_a],[score_op;score_op],Nc,Nc);


% save('./Ranked_Edges_Tables/Ranked_Edges_table_all_TS.mat','Ranked_Edges_table')

% Nc=max(max([concept_a;concept_b]));
% snames = string(T_Concept2Dict{:, 4});
% Concept2Dict=table2array(T_Concept2Dict(:,3));
% for k=1:M
%     idx=find(Concept2Dict==Ranked_Edges(k,1));
%     Concepts_a{k,:}=char(snames(idx));
%     idx1=find(Concept2Dict==Ranked_Edges(k,1));
%     Concepts_b{k,:}=char(snames(idx1)); 
% end
% Ranked_Edges.NameNodeA=Concepts_a;
% Ranked_Edges.NameConceptb=Concepts_b;
% 
% T_Concept2Dict.name=Concepts_names;
% d=1;
