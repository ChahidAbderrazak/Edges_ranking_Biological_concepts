import numpy as np
import random
from pymongo import MongoClient
from pandas import DataFrame as df
from emb_functions import load_model
from multiprocessing import Pool
from sklearn.model_selection import train_test_split
from keras.utils import to_categorical
from keras.models import Model
from keras.layers import Input, Dense
from keras.callbacks import TensorBoard, ModelCheckpoint
from sklearn.metrics import classification_report


#note: the columns for the annotation are:
#pmid,dictionary,part, cid, tid,sid,spos,epos



def flatten(l_of_ls):
        result = []
        for l in l_of_ls:
                result.extend(l)
        return result



def get_article(_id):
        with MongoClient('mongodb://10.73.42.40:27017/') as conn:
                db = conn.biotextrepository
                article = db.articles.find({"_id":_id}).next()
        return article


def get_annotation(filepath):
	with open(filepath, 'rb') as f: annotation = np.load(f)
	train = annotation[annotation[::,2] == 2]
	train = train[train[::,7] - train[::,6] > 10]
	train = train[train[::,1] == 2]
	train = train[::,[0,6,7]]
	train_ = train[train[::,0] < 1000000]
	df_train = df(train_)
	g = df_train.groupby(0).groups
	train_ids = list(g.keys())
	return annotation, train_, g, train_ids

"""
def get_annotation(filepath):
	with open(filepath, 'rb') as f: annotation = np.load(f)
	train = annotation
	train = train[train[::,1] == 2]
	train = train[::,[0,6,7]]
	train_ = train[train[::,0] < 1000000]
	df_train = df(train_)
	g = df_train.groupby(0).groups
	train_ids = list(g.keys())
	return annotation, train_, g, train_ids
"""



def get_model_params():
	w_size = 11 #context token window size
	iterations = 5 #number of samples taken from each positive example
	return w_size, iterations




def get_vector(x):
	try:
		v = w2v_model.wv.get_vector(x)
	except:
		v = [0.0] * v_size
	return v

def transform(x_):
	x,y = x_
	x = flatten(list(map(lambda x: get_vector(x), x)))
	x.append(y)
	return x

def article_data(_id):
	_id = int(_id)
	d = []
	text = get_article(_id)['body']
	hits = train_[g[_id]][:,[1,2]]
	for x in hits:
		token = text[x[0]:x[1]]
		token_len = len(token.split(' '))
		available = w_size - token_len
		if available < 2: continue
		for _ in range(iterations):	
			before_len = random.choice(range(1, available-1))
			after_len = available  - before_len
			before = text[:x[0]].split()[-before_len:]
			after = text[x[1]:].split()[:after_len]
			train_w = before + token.split(' ') + after
			if len(train_w) != w_size: continue
			encode=[0]*before_len+[1]*token_len+[0]*after_len
			d.append((train_w,tuple(encode)))
	return list(map(transform, d))


def train_val_test_split(df, val_pct=0.1, test_pct=0.1):
    size = df.shape[0]
    val_pct = (val_pct * size) / (size * (1 - test_pct))
    train_val, test = train_test_split(df, test_size=test_pct)
    train, val = train_test_split(train_val, test_size=val_pct)
    return train, val, test



def load_data(raw, to_label):
    train, val, test = raw
    data = dict()
    data["train_y"]=np.array(list(map(lambda x: to_label[x], list(train[v_size*w_size]))))
    data["val_y"] = np.array(list(map(lambda x: to_label[x], list(val[v_size*w_size]))))
    data["test_y"] = np.array(list(map(lambda x: to_label[x], list(test[v_size*w_size]))))
    data["train_X"] = train.drop(v_size*w_size, axis=1)
    data["val_X"] = val.drop(v_size*w_size, axis=1)
    data["test_X"] = test.drop(v_size*w_size, axis=1)
    return data


def build_network(input_features, label_len):
    inputs = Input(shape=(input_features,), name="input")
    x = Dense(512, activation='relu', name="hidden1")(inputs)
    x = Dense(256, activation='relu', name="hidden2")(x)
    x = Dense(128, activation='relu', name="hidden3")(x)
    prediction = Dense(label_len, activation='softmax', name="output")(x)
    model = Model(inputs=inputs, outputs=prediction)
    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=["accuracy"])
    return model


def create_callbacks():
    checkpoint_callback = ModelCheckpoint(filepath="./model-weights.{epoch:02d}-{val_acc:.6f}.hdf5", monitor='val_acc', verbose=0, save_best_only=True)
    return [checkpoint_callback]


def print_model_metrics(model, data, cl_re=False):
    loss, accuracy = model.evaluate(x=data["test_X"], y=data["test_y"])
    print("\n model test loss is "+str(loss)+" accuracy is "+str(accuracy))
    y = data["test_y"]
    y_softmax = model.predict(data["test_X"])  # this is an n x class matrix of probabilities
    y_hat = y_softmax.argmax(axis=-1)  # this will be the class number.
    test_y = data["test_y"].argmax(axis=-1)  # our test data is also categorical
    if cl_re == True: print(classification_report(test_y, y_hat))


#%% first get the word embeddings
print('getting w2v embeddings  as features...')
w2v_model = load_model('w2v.emb') 
v_size = w2v_model.vector_size


#%% get the annotation data
print('getting annotations as data...')
filepath = 'genes.npy'  #replace with corresponding annotation
annotation, train_, g, train_ids = get_annotation(filepath)

#%% get the classification model params - TODO: implment as input args
w_size, iterations = get_model_params()


#%% Generating data
print("generating data...")
#with Pool() as p: r = df(flatten(list(p.map(article_data, train_ids[:10]))))

r = df(flatten(list(map(article_data, train_ids[:100]))))

labels = sorted(set(list(r[w_size*v_size])))
print(labels)
cat_vec = dict(enumerate(list(to_categorical(list(range(len(labels)))))))
to_label = dict(map(lambda x: (x[1], cat_vec[x[0]]), list(enumerate(labels))))


data = load_data(train_val_test_split(r), to_label)
callbacks = create_callbacks()
pred_model = build_network(data["train_X"].shape[1], len(to_label))

#%%
print("fitting model...")
pred_model.fit(x=data["train_X"], y=data["train_y"],
              batch_size=30,
              epochs=5,
              validation_data=(data["val_X"], data["val_y"]),
              verbose=1,
              callbacks=[])

print_model_metrics(pred_model, data)

print('############ END of the script ###########')



