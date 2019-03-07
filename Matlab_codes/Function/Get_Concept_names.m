function [name_pairs]=Get_Concept_names(names, Concepts)

    nams_concspts=string(T_Concept2Dict{:,4});
    for k=1:size(Edges,1)

        Idxa=Edges(k,1);Idxb=Edges(k,2);
        name_pairs{k,1}=nams_concspts(Idxa);
        name_pairs{k,2}=nams_concspts(Idxb);

    end


end