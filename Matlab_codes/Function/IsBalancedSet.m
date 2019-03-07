function balnced=IsBalancedSet(Class)

Ind0=max(size(find(Class==0)));
Ind1=max(size(find(Class==1)));
balnced= Ind1==Ind0;
d=1;