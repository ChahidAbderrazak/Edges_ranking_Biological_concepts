function Edges=Get_Other_Features(Edges, graph)

for k=33:size(Edges,1)

    %% Find the index of each sample in the graph to get the corresponding  feature: pvalus, fdr,..

    Idx_a=find(Edges.ConceptA(k)==graph.ConceptA);
    Idx_b=find(Edges.ConceptB(k)==graph.ConceptB);
    
    Idx=intersect(Idx_b,Idx_a);
    
    if size(Idx,1)==0 | size(Idx,2)==0
        Idx_a=find(Edges.ConceptA(k)==graph.ConceptB);
        Idx_b=find(Edges.ConceptB(k)==graph.ConceptA);
        Idx=intersect(Idx_b,Idx_a);
        
    end
    
    
    %% Get the corresponding  feature: pvalus, fdr,...

    
    AFreq(k)=graph.AFreq(Idx);
    BFreq(k)=graph.BFreq(Idx);
    ABFreq(k)=graph.ABFreq(Idx);
    Pvalue(k)=graph.Pvalue(Idx);
    fdr(k)=graph.fdr(Idx);
    PMI(k)=graph.ABFreq(Idx)/(graph.AFreq(Idx)*graph.BFreq(Idx));

%     dict_a(k)=graph.dict_a(Idx);
%     dict_b(k)=graph.dict_b(Idx);
%     
    
    
    
end

Edges.AFreq= AFreq';
Edges.BFreq= BFreq';
Edges.ABFreq= ABFreq';
Edges.Pvalue= Pvalue';
Edges.fdr= fdr';
Edges.PMI= PMI';

% Edges.dict_a= dict_a;
% Edges.dict_b= dict_b;

