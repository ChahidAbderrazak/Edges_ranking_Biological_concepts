function [Sparse_Data, Sparse_Data_diag]=Build_Symetric_SVD_matrix(Weight_name,TS_Data_indexed) 
global K T_Concept2Dict

eval([strcat('weights= TS_Data_indexed.',Weight_name,';')]);

NodeA=TS_Data_indexed.NodeA;
NodeB=TS_Data_indexed.NodeB;

Sparse_Data=Build_Symetric_Sparse(NodeA,NodeB,weights);



% Add the Concept frequancy to the diagonal
Idx_diag=unique([NodeA;NodeB]);
NodeWeight=T_Concept2Dict.Freq(Idx_diag);
Sparse_Data_diag=Build_Symetric_Sparse([NodeA ; Idx_diag] ,[ NodeB ; Idx_diag], [weights ; NodeWeight]);

d=1;

