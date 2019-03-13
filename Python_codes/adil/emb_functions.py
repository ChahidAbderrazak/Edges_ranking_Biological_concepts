import numpy as np
from pandas import DataFrame as df
from multiprocessing import Pool, cpu_count
from gensim.models import Word2Vec
from gensim.models.word2vec import Word2VecKeyedVectors
from time import time
from functions import *

chunk_size = 10000


def get_article_sentences(article): #these are not actual sentences, they are just semantically related text chunks
	chunks = (article['title'] + '\n' + article['abstract'] + '\n' + article['body']).split('\n')
	return list(map(lambda x: x.split(), chunks))



def process_batch(article_batch):
	sentences = flatten(list(map(get_article_sentences, article_batch)))
	return sentences

def get_words(sentences):
	words = list(set(flatten(sentences)))
	return words


def get_articles(x):
	return get_articles_(x, x+chunk_size)


def get_w2v(**kwargs):

	t0 = time()
	print('fetching articles in parallel...', flush=True)
	num_p = cpu_count()
	ss = list(range(1000000))[::chunk_size]
	#es = list(map(lambda x: x+chunk_size, ss))
	#ranges = list(zip(ss, es))
	with Pool() as p: chunks=list(p.map(get_articles, ss))
	print(time()-t0)
	
	t0 = time()
	print('producing sentences...', flush=True)
	with Pool() as p: sentences = flatten(list(p.map(process_batch, chunks)))
	#sentences = list(map(lambda sentence:list(map(str, sentence)),sentences))
	print(time()-t0)
	
	t0 = time()
	print('producing words...', flush=True)
	words= get_words(sentences)
	print(time()-t0)

	t0 = time()
	print("Learning representation...", flush=True)
	kwargs["workers"] = kwargs.get("workers", cpu_count())
	kwargs["min_count"] = kwargs.get("min_count", 0)
	kwargs["size"] = kwargs.get("size", 64)
	kwargs["sg"] = 1
	kwargs["sentences"] = sentences
	kwargs["window"] = 5
	word2vec = Word2Vec(**kwargs)
	print(time()-t0)
	return word2vec

def save_model(model, filepath):
	model.wv.save(filepath)


def load_model(filepath):
	return Word2VecKeyedVectors.load(filepath)


def create_embedding(kb_path):
	filepath = './w2v.emb'
	model = get_w2v()
	save_model(model, filepath)

