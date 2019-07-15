#%% Packages and functions
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from lib.functions import *
import seaborn as sns; sns.set()
from datetime import datetime

#%%##################################################################################################
# input parameters
article_name='article_signal.csv'
sub_dict=['diseases','genes'] # sub_dict=['diseases','function','drugs','genes']
weight_sent='mean'#'median'#
word_Th=0.2

#%%  --------------------------  GET THE EMBEDDINGS   ----------------------------
vectors=Load_doc_embeddibgs(article_name)

#%% Loo for differntent thresholds
comp_rank=[]
Th_val=[]

for word_Th in np.arange(0.6,0.7,0.1):
    List_ranks=[]
#    print('Word Threshold = ',word_Th)
    # Split the test into sentences
    list_of_sentences, list_of_sentences_full, vect_sents, vect_sents_full= Split_Doc_into_sentences(vectors,word_Th,weight_sent)

    #%%  ----------------------  STATISTICAL PRE-PROCESSING  -------------------------
    topic_mean, topic_std, topic_dot= Statistical_ranking_scores(vect_sents, sub_dict)

    ###  ----------------------  SVD-based PRE-RANKING   -------------------------
    sentences_SVD_Ranking=SVD_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences )
    sentences_SVD_Ranking=sentences_SVD_Ranking.sort_values(by='Rank DiDr', ascending=False)
    # SAVE THE RANKS

    #%%

    dateTimeObj = datetime.now();timestampStr = dateTimeObj.strftime("%Y-%b-%d");

# top sentences to be ranked manually Top +/-4
    from scipy.stats import pearsonr
    from scipy.stats import spearmanr
    top_sent=4

    Top_sentences_man= pd.concat([sentences_SVD_Ranking[0:top_sent], sentences_SVD_Ranking[-top_sent:]])
    #% Save ranks
#    Top_sentences_man.to_csv('./Outputs/manual_rank/'+article_name[:-4]+'-'+timestampStr+'_sentences_ranking_'+weight_sent+'_Th'+str(word_Th)+'.csv')
#    sentences_SVD_Ranking.to_csv('./Outputs/SVD_ranks/'+article_name[:-4]+'-'+timestampStr+'_sentences_ranking_'+weight_sent+'_Th'+str(word_Th)+'.csv')

    #%%  ----------------------  RANKING VALIDATION  -------------------------
    #%% Manual ranking CBRC
    #filename_ranks='2019-07-11-Manual_Validatoin_CHR_MHB.csv'
    #corr_ranks=Ranking_validation(filename_ranks)

    # Get ranks
    #List_IDs=[1, 4, 12, 14, 19 , 21, 27, 28]
    Top_sentences_man=Top_sentences_man.sort_index()
    List_IDs=list(Top_sentences_man.index.values)
    Available_IDs=list(set(List_IDs).intersection(sentences_SVD_Ranking.index.values.astype(int)))
    #Top_sentecences = pd.DataFrame(columns=sentences_SVD_Ranking.columns)
    #for i in Available_IDs:
    #    Top_sentecences.loc[i] =sentences_SVD_Ranking.loc[i]

    rank_CHR=[6,4,3,5,8,1,7,2]; Top_sentences_man['Christophe']=rank_CHR
    rank_MHB=[6,4,3,5,8,1,7,2]; Top_sentences_man['Magbubah']=rank_MHB

    Trail_rank=len(List_IDs)-len(Available_IDs)+1


    input=Top_sentences_man['Rank DiDr'].values
    indices = list(range(len(input)))
    indices.sort(key=lambda x: input[x])
    rank_SVD_up = [0] * len(indices)
    for i, x in enumerate(indices):
        rank_SVD_up[x] = i+1

    rank_SVD=list( rank_SVD_up) + [ rr for rr in range(Trail_rank-1,0,-1)]

    Top_sentences_man['SVD-DiDr']=rank_SVD

    Scorr_CM, Sp_value_CM = spearmanr(rank_CHR, rank_MHB); List_ranks.append('(Christophe, Magbubah)')
    Scorr_CS, Sp_value_CS = spearmanr(rank_CHR, rank_SVD); List_ranks.append('(Christophe, SVD-DiDr)')
    Scorr_SM, Sp_value_SM = spearmanr(rank_SVD, rank_MHB); List_ranks.append('(Magbubah, SVD-DiDr)')
    corr_ranks=[ Scorr_CM, Scorr_CS, Scorr_SM ]
    comp_rank.append(corr_ranks)
    Th_val.append(word_Th)

    print(rank_SVD, '--', word_Th, '--SM ', Scorr_SM)

comp_rank=np.asanyarray(comp_rank)
comp_rank=comp_rank.T
comp_rank = pd.DataFrame(comp_rank,List_ranks,columns=Th_val)
comp_rank.to_csv('./Outputs/Comparison/TOP_sentences_ranking_'+weight_sent+'_Th'+str(word_Th)+'.csv')



#%%  ----------------------  PCA-based PRE-RANKING   -------------------------
#sentences_PCA_Ranking=PCA_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences )

#%% Test Script #################################################################################################
#word='dfdf'
# df = df.reindex(index=a.index)


