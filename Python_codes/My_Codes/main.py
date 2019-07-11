#%% Packages and functions
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from lib.functions import *
import seaborn as sns; sns.set()


#%%##################################################################################################
# input parameters
article_name='article_signal.csv'
sub_dict=['diseases','genes'] # sub_dict=['diseases','function','drugs','genes']
word_Th=0.2
weight_sent='median'#'mean'

#%%  --------------------------  GET THE EMBEDDINGS   ----------------------------
vectors=Load_doc_embeddibgs(article_name)

# Split the test into sentences
list_of_sentences, list_of_sentences_full, vect_sents, vect_sents_full= Split_Doc_into_sentences(vectors,word_Th,weight_sent)

#%%  ----------------------  STATISTICAL PRE-PROCESSING  -------------------------
topic_mean, topic_std, topic_dot= Statistical_ranking_scores(vect_sents, sub_dict)

###  ----------------------  SVD-based PRE-RANKING   -------------------------
sentences_SVD_Ranking=SVD_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences )

# SAVE THE RANKS
sentences_SVD_Ranking.to_csv('./Outputs/sentences_ranking_'+weight_sent+'_Th'+str(word_Th)+'.csv')


###  ----------------------  PCA-based PRE-RANKING   -------------------------
sentences_PCA_Ranking=PCA_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences )

#%%  ----------------------  RANKING VALIDATION  -------------------------

#%% Manual ranking CBRC
filename_ranks='2019-07-11-Manual_Validatoin_CHR_MHB.csv'
Ranking_validation(filename_ranks)

#%% Test Script #################################################################################################
#word='dfdf'
# df = df.reindex(index=a.index)


