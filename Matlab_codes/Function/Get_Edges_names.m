function [name_pairs,ID_Concepts]=Get_Edges_names(Edges, T_Concept2Dict)

    for k=1:size(Edges,1)

        Idxa=Edges(k,1);Idxb=Edges(k,2);
        name_pairs{k,1}=T_Concept2Dict.NameConcept{Idxa};
        name_pairs{k,2}=T_Concept2Dict.NameConcept{Idxb};
        
        ID_Concepts(k,1)=T_Concept2Dict.Concept(Idxa);
        ID_Concepts(k,2)=T_Concept2Dict.Concept(Idxb);

        

    end


end