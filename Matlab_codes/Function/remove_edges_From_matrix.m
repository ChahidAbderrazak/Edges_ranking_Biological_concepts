function [Sparse_Data2,TS_Data2]=remove_edges_From_matrix(Idx_SVD,TS_Data,Sparse_Data)

%% Remote the ranked edges from datset
Idxx=1:size(TS_Data.EdgeNumber,1);

%% Remote the ranked edges from SVD matrix

Sparse_Data2=Sparse_Data;
for k=1:max(size(Idx_SVD))
    
    Idx=find(TS_Data.EdgeNumber==Idx_SVD(k));
    Idxx(Idx)=0;
    Sparse_Data2(TS_Data.NodeA(Idx),TS_Data.NodeB(Idx))=0;
    Sparse_Data2(TS_Data.NodeB(Idx),TS_Data.NodeA(Idx))=0;

   
end
Idx=find(Idxx~=0);
Idx_2_keep=Idxx(Idx);
TS_Data2=TS_Data(Idx_2_keep,:);
d=1; 