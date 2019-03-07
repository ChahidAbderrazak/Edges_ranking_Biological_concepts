function X=Combine_score_fdr_abFreq_Pvalue(Ranked_Adge_T, Data_indexed)

Edges=table2array(Ranked_Adge_T(:,1:2))
for k=1:size(Edges,1)
    Idx_a=find(Data_indexed(:,1)==Edges(k,1));
    Idx_b=find(Data_indexed(:,2)==Edges(k,2));
    Idx= find(Idx_b==Idx_a);

    X(k,:)=Data(Edges(k,1),Edges(k,2));
    
end

ab_freq=full(ab_freq);
