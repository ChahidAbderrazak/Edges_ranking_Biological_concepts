function [Sparse_Data, Sparse_Data_diag]=Build_NONSymetric_SVD_matrix(Weight_name,TS_Data_indexed) 
global T_Concept2Dict

eval([strcat('weights= TS_Data_indexed.',Weight_name,';')]);

Nodes=TS_Data_indexed(:,{'EdgeNumber','NodeA','NodeB','AFreq','BFreq'});
Nodes.weights=weights;

[Sparse_Data,Sparse_Data_diag]=Build_NONSymetric_Sparse(Nodes);


d=1;

function [Sparse_Data,Sparse_Data_diag]=Build_NONSymetric_Sparse(Nodes)
global T_Concept2Dict

bk_Nc=max([ Nodes.NodeA ; Nodes.NodeB]);

NodeAB=Nodes(:,{'EdgeNumber','NodeA','NodeB'});
NodeAB.weights=Nodes.weights./Nodes.AFreq;

NodeBA=Nodes(:,{'EdgeNumber'});
NodeBA.NodeA=Nodes.NodeB;
NodeBA.NodeB=Nodes.NodeA;
NodeBA.weights=Nodes.weights./Nodes.BFreq;


Sparse_Data = sparse([NodeAB.NodeA;NodeBA.NodeA ],[NodeAB.NodeB;NodeBA.NodeB;  ] , [NodeAB.weights;NodeBA.weights] ,bk_Nc,bk_Nc);

% Add the Concept frequancy to the diagonal
Idx_diag=unique([Nodes.NodeA ; Nodes.NodeB]);
NodeWeight=T_Concept2Dict.Freq(Idx_diag);
Sparse_Data_diag = sparse([NodeAB.NodeA;NodeBA.NodeA; Idx_diag],[NodeAB.NodeB;NodeBA.NodeB;  Idx_diag] , [NodeAB.weights;NodeBA.weights; NodeWeight] ,bk_Nc,bk_Nc);

