function graph=normalize_weight(Concept,graph)

Idxa=find(graph.NodeA==Concept);
Idxb=find(graph.NodeB==Concept);graph.ABFreq(Idxb);
Idx =unique([Idxa;Idxb]);
Fsum=sum(graph.ABFreq(Idx));
A=unique([graph.AFreq(Idxa);graph.BFreq(Idxb)]); 

graph.Pa(Idxa)=A/Fsum;
graph.Pb(Idxb)=A/Fsum;
