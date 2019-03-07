function Node=Concept2Node(Concept)
global T_Concept2Dict

Idx=find(T_Concept2Dict.Concept==Concept);
Node=T_Concept2Dict.Node(Idx);

d=1