function Exist_edge=Get_testing_edges(TS_Data_indexed)

N=max(max(TS_Data_indexed(:,1:2)));
Exist_edge=zeros(N,N);

% get the indexes of the concepts
concept_a=TS_Data_indexed(:,1);
concept_b=TS_Data_indexed(:,2);

% Assign 1 to the testing edges in order to sort their correspponsing weights the indexes of the concepts

for k=1:size(TS_Data_indexed,1)
    Exist_edge(concept_a(k),concept_b(k))=1;
    Exist_edge(concept_b(k),concept_a(k))=1;
end
Idx=find(Exist_edge==1);
d=1;
