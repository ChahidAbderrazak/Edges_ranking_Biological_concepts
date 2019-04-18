#%% Packages and functions 
import matplotlib.pyplot as plt
import numpy as np
import pandas

vectors = pandas.read_csv('article_signal.csv', sep='\t')
vectors['tokens']=vectors['index']
#vectors = vectors.drop(columns="index")
sent_idx=[[0,27],[28,62],[63,81],[82,110],[111,121],[122,134],[135,146]]

#a and b are indices on the vectors table
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
plot_signal(vectors, 0,10)
vectors.mean()
annotate_text(vectors, 'functional')
#%% Split the test into sentences 

#for idx, token in zip(vectors['functional'], vectors['tokens']):
cnt=-1

contxt=mean(vectors[idx[0]:idx[1])
for idx in sent_idx:
    cnt+=1
    print(idx)    
    contxt=mean(vectors[idx[0]:idx[1]]
#    plot_signal(vectors, idx[0],idx[1])

#%% Split the test into sentences Spacy
import spacy

# Load English tokenizer, tagger, parser, NER and word vectors
nlp = spacy.load("en_core_web_sm")  

# Process whole documents
text=" ".join(list(vectors['tokens']))

  #text = ("When Sebastian Thrun started working on self-driving cars at "
#        "Google in 2007, few people outside of the company took him "
#        "seriously. “I can tell you very senior CEOs of major American "
#        "car companies would shake my hand and turn away because I wasn’t "
#        "worth talking to,” said Thrun, in an interview with Recode earlier "
#        "this week.")
        
doc = nlp(text)
for sent in doc.sents:
    print(sent.text)
    
#%%  Analyze syntax
#print("Noun phrases:", [chunk.text for chunk in doc.noun_chunks])
#print("Verbs:", [token.lemma_ for token in doc if token.pos_ == "VERB"])

# Find named entities, phrases and concepts
#for entity in doc.ents:
#    print(entity.text, entity.label_)
    
#%% END 

#%%
