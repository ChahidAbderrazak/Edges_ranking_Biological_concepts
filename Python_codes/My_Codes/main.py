#%% Packages and functions
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from lib.functions import *

#%%##################################################################################################
# input parameters
Article_name='article_signal.csv'


#  --------------------------  GET THE EMBEDDINGS   ----------------------------

vectors = pd.read_csv('./data/'+ Article_name, sep='\t')
vectors['tokens']=vectors['index']
#vectors=vectors.drop(['index'], axis=1)
#vectors.tail()


#  ----------------------  STATISTICAL PRE-PROCESSING  -------------------------
#%% Split the test into sentences
sent_idx=list(vectors[vectors['tokens'].str.contains('\.', na = False)].index.values.astype(int))
sent_idx.insert(0, -1)

list_of_series=list();
list_of_sentences=list();
# loop for sentences
for idx in range(len(sent_idx)-1):
     new_score=np.mean(vectors[sent_idx[idx]+1:sent_idx[idx+1]])
     if not np.isnan(np.asanyarray(new_score)).any():
         list_of_sentences.append(' '.join(vectors['tokens'][sent_idx[idx]+1:sent_idx[idx+1]]))
         list_of_series.append(new_score)
#     print(idx, 'weights', new_sents, 'sentence ', vectors['tokens'][sent_idx[idx]+1:sent_idx[idx+1]])


vect_sents = pd.DataFrame(list_of_series,list_of_sentences)
vect_sents.plot()
plt.legend(list(vect_sents.columns))
plt.xlabel('Sentenes')
plt.title(r' Mean vector per sentence $\hat{V}$')
plt.grid(True)
plt.show()

#%% process the dictionaries and their relations
topic_mean=np.mean(vect_sents)
topic_std=np.std(vect_sents)
topic_dot=np.multiply(topic_mean,topic_std)
##


#%% Plot signal
#plot_signal(vectors, 0,10)
annotate_text(vectors, 'diseases')
annotate_text(vectors, 'functional')
annotate_text(vectors, 'drugs')
annotate_text(vectors, 'genes')
Sub_dict=['diseases','functional','drugs','genes']




topic_mean[Sub_dict].plot()
plt.legend(Sub_dict)
plt.xlabel('Sentenes')
plt.title(r' Mean vector per sentence $\hat{V}$')
plt.grid(True)
plt.show()
new_sents= vectors['tokens'][476:488]

#  ----------------------  SVD-based PRE-PROCESSING  -------------------------

#%% SVD decomposition
from scipy.linalg import svd
from numpy import diag
from numpy import dot
from numpy import zeros

A = np.array(vect_sents)

U, S, VT = svd(A)

Concepts=['Concept '+str(x) for x in range(S.shape[0])]
U_df = pd.DataFrame(U,list_of_sentences)
VT_df = pd.DataFrame(VT,Concepts)


# create m x n Sigma matrix
Sigma = zeros((A.shape[0], A.shape[1]))
# populate Sigma with n x n diagonal matrix


Sigma[:A.shape[1], :A.shape[1]] = diag(S)
Sigma_df = pd.DataFrame(Sigma,['C_sent '+str(x) for x in range(A.shape[0])],columns = ['C_dict '+str(x) for x in range(A.shape[1])])
#Sigma_df[3:] = 0
# reconstruct matrix
B = U.dot(Sigma.dot(VT))
vect_sents_SVD= pd.DataFrame(B,columns=vect_sents.columns)
topic_mean_SVD=np.mean(vect_sents_SVD)
topic_std_SVD=np.std(vect_sents_SVD)
topic_dot_SVD=np.multiply(topic_mean_SVD,topic_std_SVD)

#%% study the singular vectors
# VT
topic_VT=pd.DataFrame(VT.T)
topic_VT['Dictionaries']=pd.DataFrame(vect_sents.columns)

# U
U0=U
U=np.abs(U)
topic_U = pd.DataFrame(U[:,0:A.shape[1]],columns=vect_sents.columns)
topic_U=np.abs(topic_U)

topic_mean_U=np.mean(topic_U)
topic_std_U=np.std(topic_U)
topic_dot_U=np.multiply(topic_mean_U,topic_std_U)

topic_dot_U.plot()#[['diseases','functional','drugs']].plot()
plt.title('topic_dot_U vectors of SVD')
plt.xlabel('sentences')
plt.show()

#%%

#topic_U[topic_U>0.1][Sub_dict][:10].plot.bar()#[['diseases','functional','drugs']].plot()
topic_U[topic_U>0.1][Sub_dict][:-1].plot.bar()#[['diseases','functional','drugs']].plot()
plt.title('Topics using SVD')
plt.xlabel('Sentences')
plt.ylabel(' U with Threshold 0.1')
plt.show()


topic_mean_U_Th=np.mean(topic_U[topic_U>0.1][Sub_dict])



#%% covariance matrix of U
C = np.cov(U[:,0:A.shape[1]])
C =C-np.mean(C)
np.mean(C)
C[C<0.2*np.max(C)]=0
C_df= pd.DataFrame(C, )


#%% PCA
from sklearn.decomposition import PCA

pca = PCA(n_components=2)
pca.fit(A)

A_PCA=A.dot(np.diag(pca.components_[0]))
A_PCA_df=pd.DataFrame(A_PCA)

#%% Test Script #################################################################################################
#word='dfdf'
# df = df.reindex(index=a.index)



