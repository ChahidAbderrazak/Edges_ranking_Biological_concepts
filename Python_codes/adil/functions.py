import re
import psycopg2
import pymongo
from pymongo import MongoClient
from Bio import trie
import pickle
import numpy as np
########################## utility 




def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in range(0, len(l), n):
        yield l[i:i + n]

def flatten(l_of_ls):
        result = []
        for l in l_of_ls:
                result.extend(l)
        return result

def is_ascii(text):
	return all(ord(char) < 128 for char in text)

def get_token_index(string):
	p_ = '([^ \t\n\r\x0b\x0c!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~]){1,}'
	return list(map(lambda x: (x.start(), x.end()),list(re.finditer(p_, string))))


def are_different(str1, str2):
        if(str1.find(str2) == -1 and str2.find(str1) == -1): return True
        return False

########################## databases 



def get_article(_id):
	with MongoClient() as conn:
		db = conn.biotextrepository
		article = db.articles.find({"_id":_id}).next()
	return article



def get_articles_(s_id, e_id):
	with MongoClient() as conn:
		db = conn.biotextrepository
		articles = list(db.articles.find({"$and":[{"_id":{"$gte":s_id, "$lt":e_id}}, {"duplicate":{"$exists": False}},{"id.ui":""}]}))
	return articles


def get_max_id():
        with MongoClient() as conn:
                db = conn.biotextrepository
                max_id = db.articles.find( {}, { "_id": 1 } ).sort( "_id",  pymongo.DESCENDING ).next()['_id']
        return max_id





