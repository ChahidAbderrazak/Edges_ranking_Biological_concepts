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

