function [Concepts,Concepts_names] =Get_concepts_list(data, names)

Data=table2array(data(:,2:3));                    % convert table to matrix
Concepts=unique([Data(:,1); Data(:,2)]);     % get the existing Dicionaries


