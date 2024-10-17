# Lea Heiniger
# Data science
# TP1

import numpy as np

# create 2 random vectors of length 5
u = np.random.randn(3)
v = np.random.randn(3)
# the 3 folling line can be replaced with np.dot(u,v)
r = 0
for ui, vi in zip(u, v) :
    r += ui * vi

# We compute w a vector orthogonal to u
w = v - np.dot(u,v)/np.dot(u,u)*u

# We compute r orthogonal to u and with the same norm
r = w / np.linalg.norm(w) * np.linalg.norm(u)

assert np.linalg.norm(u)==np.linalg.norm(r) # We make sure that r and u have the same norm

dotProd = np.dot(u, r)

print(dotProd)