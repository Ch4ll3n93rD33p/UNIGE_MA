# Lea Heiniger
# Modélisation et Simulation de Phénomènes Naturels
# TP1

import os
import numpy as np
import matplotlib.pyplot as plt

def apply_boundaries(T):
    ''' 
    Function that applies the restrictions on the matrix borders

    Paremeters :
     T -> the domain matrix

    Returns :
     T -> the matrix once the restrictions applied
    '''
    W, H = T.shape

    for i in range(W) :
        T[i][0] = 1
        T[i][H-1] = 0

    for j in range(H) :
        T[0][j] = 1
        T[W-1][j] = 0

    return T


def mean_neighbors(T):
    '''
    Function that computes the mean of the neighbors for each element in T
    
    Parameters :
     T -> the domain matrix
     
    Returns :
     T -> the matrix updated
    '''
    T_right = np.roll(T, 1, axis = 1)
    T_left = np.roll(T, -1, axis = 1)
    T_up = np.roll(T, -1, axis = 0)
    T_down = np.roll(T, 1, axis = 0)
    T = 1/4*(T_right+T_left+T_up+T_down)
    
    return T


W, H = 250, 250
iter_max = 50000+1


T = np.ones((W, H)) * 0.5
T = apply_boundaries(T)

#os.system('mkdir -p ./domains_Laplace')

for it in range(iter_max):
    T = mean_neighbors(T)
    T = apply_boundaries(T)
    if it % 500 == 0:
        plt.imshow(T, origin='lower')
        plt.title("Iteration : "+str(it))
        #plt.savefig('domains_Laplace/domain_'+str(it).zfill(4)+'.png')
        plt.show()
        #plt.close()