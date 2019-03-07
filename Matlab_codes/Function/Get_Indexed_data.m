% this function assign to each concept in <graph> it  new idex related to the 
% corresponding sorted Dicionaries 

function [Sparse_Data,graph_indexed, concept_a, concept_b, a_freq, b_freq, ab_freq, p_value, weight]=Get_Indexed_data(Col_num, graph,Concept2Dict)

fprintf('\n--> Assign new index to the subgraph based on the Concept2Dict.\n')



N=size(graph,1);
concept_a0=zeros(N,1);
concept_b0=zeros(N,1);
a_freq0=zeros(N,1);
b_freq0=zeros(N,1);
ab_freq0=zeros(N,1);
p_value0=zeros(N,1);
weight0=zeros(N,1);


Nc=size(Concept2Dict,1); 
Weights=table2array(graph(:,Col_num));

parfor k=1:N

    Idx_a=find(Concept2Dict.Concept==graph.concept_a(k));
    Idx_b=find(Concept2Dict.Concept==graph.concept_b(k));
    if (size(Idx_a,1)~=0 & size(Idx_b,1)~=0)

        concept_a0(k)=Concept2Dict.Node(Idx_a);
        concept_b0(k)=Concept2Dict.Node(Idx_b);
        a_freq0(k)=graph.a_freq(k);
        b_freq0(k)=graph.b_freq(k);
        ab_freq0(k)=graph.ab_freq(k);
        p_value0(k)=graph.p_value(k);
        fdr0(k)=graph.fdr(k);

        weight0(k)=Weights(k);
    end
    
    %% build the adjacent matrix    
d=1;
end

Idx=find(concept_a0~=0);
concept_a=concept_a0(Idx);
concept_b=concept_b0(Idx);
a_freq=a_freq0(Idx);
b_freq=b_freq0(Idx);
ab_freq=ab_freq0(Idx);
p_value=p_value0(Idx);
fdr=fdr0(Idx);
weight=weight0(Idx);



%% Build the indexed graph
find(concept_b==1);
graph_indexed=[concept_a concept_b a_freq b_freq ab_freq p_value fdr'];

graph_indexed=array2table(graph_indexed,'VariableNames',{'NodeA','NodeB','AFreq','BFreq','ABFreq','Pvalue','FDR'});

% Sparse_Data = sparse([concept_a;concept_b],[concept_b;concept_a],[ab_freq;ab_freq],Nc,Nc);
Sparse_Data = sparse([concept_a;concept_b],[concept_b;concept_a],[weight;weight],Nc,Nc);

