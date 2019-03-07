function [ORI_ranks,R]=Get_ranks_of_binary_sequence(Class, predict_Class)


%% Compute the rank of the sequences amoung other sequances
rank_vect=predict_Class';
RankH=sum(Class);
H= predict_Class(1:RankH);      NH =max(size(H)); nh1=sum(H);nh0=sum(H==0);
L= predict_Class(RankH+1:end);  NL =max(size(L)); nl1=sum(L);nl0=sum(L==0);

% R_H=rank_binary_sequence(H);
% R_L=rank_binary_sequence(L);

if nh1==0
    R_H=0
    R_L=0
else
    
R_H=nchoosek(NH,nh1)-nchoosek(NH-1,nh0)    
R_L=nchoosek(NL,nl1)-nchoosek(NL-1,nl0)

end

R=[R_H R_L];
if R_H<1 
    
    ORI_ranks=R_L

else
    ORI_ranks=R_L+ (R_H-1)*nchoosek(NL,nl1)

end

 

for k=nh1-1:-1:1
    ORI_ranks=ORI_ranks+nchoosek(NH,k)*nchoosek(NL,nh1+nl1-k)
end
d=1;
