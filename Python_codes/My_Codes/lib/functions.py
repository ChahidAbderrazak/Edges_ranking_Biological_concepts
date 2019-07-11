import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


#%%a and b are indices on the vectors table
def plot_signal(vectors, a,b):
        vectors[a:b].plot()
        plt.xticks(list(range(a,b)), list(vectors['index'][a:b]), rotation='vertical')
        plt.show()

def annotate_text(vectors, d):
        scores = np.array(vectors[[d, 'index']])
        content = ' '.join(list(map(lambda x: '<span style="color:rgb('+str(int(255*x[0]))+',0,0);font-weight:'+str(int(1000*x[0]/100)*100)+'">'+x[1]+'</span>',scores)))
        content ='<html><head><meta charset="utf-8"></head><body>'+content+'</body></html>'
        with open('./html/'+d+'.html', 'w') as f: f.write(content)


def plot_something():
        #https://matplotlib.org/users/pyplot_tutorial.html
    plt.figure(1)                # the first figure
    plt.subplot(211)             # the first subplot in the first figure
    plt.plot([1,2,3,4], [1,4,9,16], 'r--')
    plt.xlim([0, 10])
    plt.ylim([0, 30])
    plt.legend({'curve 1'})
    plt.xlabel('Smarts')
    plt.ylabel('Probability')
    plt.title(r'$\sigma_i=15$' +'  Title here ')
    plt.text(3, 3, r'$\mu=100,\ \sigma=15$')
    plt.grid(True)
    plt.show()


def Load_doc_embeddibgs(article_name):

    vectors = pd.read_csv('./data/'+ article_name, sep='\t')
    vectors['function']=vectors['functional']; vectors=vectors.drop(['functional'], axis=1)
    vectors0=vectors; vectors=vectors.drop(['index'], axis=1)
    List_dict=list(vectors.columns)
    vectors['index']=vectors0['index']
#vectors.tail()

    for dictionary in List_dict:
#        print(dictionary)
        annotate_text(vectors, dictionary)

    vectors['tokens']=vectors['index']




    return vectors
def select_words_TH(sentence_df, word_Th,sent_start) :
    sentence=sentence_df.values
#    print('sentence',sentence)
    selected_idex=[]
    selected_words=''
    for i in range(sentence.shape[0]):
        slect=0

        for j in range(sentence.shape[1]):
            word=sentence[i,j]
#            print(word)
            if not isinstance(word, str):
                if word >= word_Th:
                    slect=1
                    break

        if slect==1 :
            selected_idex.append(i+sent_start)

#    print(selected_idex)
    return  selected_idex

def Split_Doc_into_sentences(vectors,word_Th,weight_sent):
    sent_idx=list(vectors[vectors['tokens'].str.contains('\.', na = False)].index.values.astype(int))
    sent_idx.insert(0, -1)


    list_of_sentences=list();     list_of_series=list();
    list_of_sentences_full=list();list_of_series_full=list();
    cnt=0;empty_sent=0
    # loop for sentences
    for idx in range(len(sent_idx)-1):
    #    cnt=cnt+1; print('cnt=',cnt)
        sent_start=sent_idx[idx]+1
        sent_end=sent_idx[idx+1]+1

        if weight_sent=='median':
            new_score= vectors[sent_start:sent_end].median()
        else:
            new_score=np.mean(vectors[sent_start:sent_end])

        if not np.isnan(np.asanyarray(new_score)).any():

            selected_idex=select_words_TH(vectors[sent_start:sent_end], word_Th, sent_start )
            if len(selected_idex) > 0:
                list_of_sentences.append(' '.join(vectors['tokens'][selected_idex]))
                list_of_series.append(new_score)
                list_of_sentences_full.append(' '.join(vectors['tokens'][sent_start:sent_end]))
                list_of_series_full.append(new_score)

            else:
    #            print('empty sentences starts at : ',sent_start)
                empty_sent=empty_sent+1;

    #    print(idx, 'weights', new_sents, 'sentence ', vectors['tokens'][sent_idx[idx]+1:sent_idx[idx+1]])

    print('The input sentences have ',empty_sent ,' empty sentences which were neglected')

    vect_sents_full = pd.DataFrame(list_of_series_full,list_of_sentences_full)
    vect_sents = pd.DataFrame(list_of_series,list_of_sentences)
    vect_sents.plot()
    plt.legend(list(vect_sents.columns))
    plt.xlabel('Sentenes')
    plt.title(r' Mean vector per sentence $\hat{V}$')
    plt.grid(True)
    plt.show()


    return list_of_sentences, list_of_sentences_full, vect_sents, vect_sents_full

def Statistical_ranking_scores(vect_sents, sub_dict):
    #%% process the dictionaries and their relations
    topic_mean=np.mean(vect_sents)
    topic_std=np.std(vect_sents)
    topic_dot=np.multiply(topic_mean,topic_std)
    ##
    topic_mean[sub_dict].plot()
    plt.legend(sub_dict)
    plt.xlabel('Sentenes')
    plt.title(r' Mean vector per sentence $\hat{V}$')
    plt.grid(True)
    plt.show()

    return topic_mean, topic_std, topic_dot

def SVD_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences ):
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
    Sigma_df[3:] = 0
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

    topic_dot_U.plot()#[['diseases','function','drugs']].plot()
    plt.title('topic_dot_U vectors of SVD')
    plt.xlabel('sentences')
    plt.show()

    #%%

    #topic_U[topic_U>0.1][sub_dict][:10].plot.bar()#[['diseases','function','drugs']].plot()
    topic_U[topic_U>0.1][sub_dict][:-1].plot.bar()#[['diseases','function','drugs']].plot()
    plt.title('Topics using SVD')
    plt.xlabel('Sentences')
    plt.ylabel(' U with Threshold 0.1')
    plt.show()


    topic_mean_U_Th=np.mean(topic_U[topic_U>0.1][sub_dict])


    #%% get the top low ranked sentences
    sentences_SVD_Ranking = pd.DataFrame(index=vect_sents.index)
    sentences_SVD_Ranking=pd.DataFrame(data={'Full Sentences': list_of_sentences_full, 'Processed words':list_of_sentences})

    sub_dict1=['diseases','genes']
    cc=vect_sents_SVD[sub_dict1]
    sentence_sumk= cc.sum(axis = 1)
    vect_sents_SVD_DiGe=pd.DataFrame(index=vect_sents.index)
    vect_sents_SVD_DiGe['Rank'] =  sentence_sumk.values
    sentences_SVD_Ranking['Rank DiGe'] =  sentence_sumk.values



    sub_dict2=['diseases','drugs']
    cc=vect_sents_SVD[sub_dict2]
    sentence_sumk= cc.sum(axis = 1)
    vect_sents_SVD_DiDr=pd.DataFrame(index=vect_sents.index)
    vect_sents_SVD_DiDr['Rank'] =  sentence_sumk.values
    sentences_SVD_Ranking['Rank DiDr'] =  sentence_sumk.values


    sub_dict3=['drugs','genes']
    cc=vect_sents_SVD[sub_dict3]
    sentence_sumk= cc.sum(axis = 1)
    vect_sents_SVD_DrGe=pd.DataFrame(index=vect_sents.index)
    vect_sents_SVD_DrGe['Rank'] =  sentence_sumk.values
    sentences_SVD_Ranking['Rank DrGe'] =  sentence_sumk.values


    #%% covariance matrix of U
    C = np.cov(U[:,0:A.shape[1]])
    C =C-np.mean(C)
    np.mean(C)
    C[C<0.2*np.max(C)]=0
    C_df= pd.DataFrame(C, )




    return sentences_SVD_Ranking

def PCA_ranking_scores(vect_sents, sub_dict, list_of_sentences_full,list_of_sentences ):
    sentences_PCA_Ranking=[];
    from sklearn.decomposition import PCA
    A = np.array(vect_sents)
    pca = PCA(n_components=2)
    pca.fit(A)

    A_PCA=A.dot(np.diag(pca.components_[0]))
    A_PCA_df=pd.DataFrame(A_PCA)
    return sentences_PCA_Ranking


def Ranking_validation(filename):
    from scipy.stats import pearsonr
    ranks = pd.read_csv('./Outputs/Validation/'+ filename, sep=',',index_col=False)

    rank_CHR=ranks['Christophe']
    rank_SVD=ranks['Magbubah']
    rank_MHB=ranks['SVD - DiDr']


    corr_CM, p_value_CM = pearsonr(rank_CHR, rank_MHB)
    corr_CS, p_value_CS = pearsonr(rank_CHR, rank_SVD)
    corr_SM, p_value_SM = pearsonr(rank_SVD, rank_MHB)
    return

