#%% Packages and functions 
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


vectors = pd.read_csv('article_signal.csv', sep='\t')
vectors['tokens']=vectors['index']
#vectors = vectors.drop(columns="index")
vectors.tail() 

#%% Test 
word='dfdf'
 
#%%a and b are indices on the vectors table
def plot_signal(vectors, a,b):
        vectors[a:b].plot()
        plt.xticks(list(range(a,b)), list(vectors['index'][a:b]), rotation='vertical')
        plt.show()

def annotate_text(vectors, d):
        scores = np.array(vectors[[d, 'index']])        
        content = ' '.join(list(map(lambda x: '<span style="color:rgb('+str(int(255*x[0]))+',0,0);font-weight:'+str(int(1000*x[0]/100)*100)+'">'+x[1]+'</span>',scores)))
        content ='<html><head><meta charset="utf-8"></head><body>'+content+'</body></html>'
        with open('result.html', 'w') as f: f.write(content)


#%% Plot signal       
#plot_signal(vectors, 0,10)
vectors.mean()
annotate_text(vectors, 'functional')
#%% Split the test into sentences 

#for idx, token in zip(vectors['functional'], vectors['tokens']):
 
#% I need to get the index of all [start, end] of all sentences in vectors
sent_idx=list(vectors[vectors['tokens'].str.contains('\.', na = False)].index.values.astype(int))
sent_idx.insert(0, -1)
 
list_of_series=list();

for idx in range(len(sent_idx)-1):
     new_sents=np.mean(vectors[sent_idx[idx]+1:sent_idx[idx+1]])
     list_of_series.append(new_sents) 
    #% I need to group  all the the means of sentenses in similarvariable as  vectors
#    vect_sents[cnt]=new_sents
vect_sents = pd.DataFrame(list_of_series)
    
## plot
vect_sents.plot()  
plt.show()
     
#    plot_signal(vectors, idx[0],idx[1])
    
#    vect_sents.get(1)
