# Lea Heiniger
# Data Science - TP7
# 18.12.2023

from dahuffman import HuffmanCodec
import random
import numpy as np

def gen_sequence(n : int, symb_length : int, prob_1 : float) -> list[str] :
    bin_seq = []
    for i in range(n//symb_length) :
        symb = ''
        for _ in range(5) :
            p = random.random()
            if p <= prob_1 :
             bin_seq += '1'
        
            else :
                bin_seq += '0'
        bin_seq.append(symb)
    return bin_seq

def get_count(bin_seq : list[str]) -> dict :
    nb_symb = len(bin_seq)
    count = {}
    for i in range(nb_symb) :
        symb = bin_seq[i]
        if symb in count.keys() :
            count[symb] += 1
        else :
            count[symb] = 1
        
    return count

def compute_entropy(count : dict, nb_symb : int) -> float :
    count_list = np.array([v for v in count.values()])
    norm_count = count_list / count_list.sum()
    entropy = -(norm_count * np.log(norm_count)/np.log(2)).sum()

    return entropy


#### Main
n = 10000

symb_length = 5
nb_symb = n//symb_length
print('We have a binary sequence of ', nb_symb, ' symbols where each symbol has the length ', symb_length)

prob_1 = 0.1
bin_seq = gen_sequence(n, symb_length, prob_1)
count = get_count(bin_seq)

codec = HuffmanCodec.from_frequencies(count)
encoded = codec.encode(bin_seq)
print("The length of the encoded sequence is : ", len(encoded))
print("if we divide it by the length of the sequence we have : ", len(encoded)/nb_symb)

entropy = compute_entropy(count, nb_symb)
print("The entropy of the sequence is : ", entropy)