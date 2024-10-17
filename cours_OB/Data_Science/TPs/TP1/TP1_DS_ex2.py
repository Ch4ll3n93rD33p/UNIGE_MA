# Lea Heiniger
# Data science
#09.10.2023

# TP1

import numpy as np

# create 2 random vectors of length 7
u = np.random.randn(7)
v = np.random.randn(7)

# the 3 following lines can be replaced with np.dot(u,v)
r = 0
for ui, vi in zip(u, v) :
    r += ui * vi

# We compute w a vector orthogonal to u
w = v - np.dot(u,v)/np.dot(u,u)*u 

# We compute w2 orthogonal to u and with the same norm
a = np.linalg.norm(u) / np.linalg.norm(w)
w2 = w*a


assert np.linalg.norm(u)==np.linalg.norm(w2) # We make sure that w2 and u have the same norm

dotProd = np.dot(u, w2)

print(dotProd)