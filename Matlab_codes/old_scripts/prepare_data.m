clear all; close all; addpath ./Function 

Idx=find(nodes.concept_id==117196132);
concept=nodes.name(Idx);
Dic=nodes.dict(Idx)
res=[name0 ',' concept ]