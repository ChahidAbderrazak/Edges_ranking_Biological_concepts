function Sparse_Data=Build_Symetric_Sparse(concept_a,concept_b, weight)
bk_Nc=max([ concept_a ; concept_b]);

Sparse_Data = sparse([concept_a;concept_b],[concept_b;concept_a],[weight;weight],bk_Nc,bk_Nc);
