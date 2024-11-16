from bacterium import *
import numpy as np
import scipy.spatial.distance as distance

C = [50,50] 

def rho_A(x) :
    return 1/(1+distance.euclidean(x.pos, C))

def rho_B(x) :
    if distance.euclidean(x.pos, C)<= 15 :
        return 1
    else :
        return 0

def random_pos() :
    x = 100*random.random()
    y = 100*random.random()

    return [x,y]

bacterias = [Bacterium(random_pos()) for _ in range(100)]
for b in bacterias :
    b.prevRho = rho_A(b)

iter_max = ...
