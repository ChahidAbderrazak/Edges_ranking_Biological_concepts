function ab_freq=Get_AB_freq(Edges, Data)


for k=1:size(Edges,1)
    ab_freq(k)=Data(Edges(k,1),Edges(k,2));
    
end

ab_freq=full(ab_freq);
