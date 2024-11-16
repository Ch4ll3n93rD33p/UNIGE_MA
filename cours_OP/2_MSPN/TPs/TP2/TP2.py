# Import modules
import os
import numpy as np
import matplotlib.pyplot as plt
from numpy import random
from numpy import linalg as LA
from scipy.stats import kde


# Inject particles in boundaries for each unit square in the boundary
def inject_particles_boundary(H,W,pos,rho_max):
	# looping on the height of the domain
    for j in range(H):
        posHx = np.random.rand(rho_max) # draws rho_max random particles' x position
        posHy = np.random.rand(rho_max) # draws rho_max random particles' y position...
        posHy += np.ones(rho_max)*j	 # ... at each j position
        pos = np.hstack((pos, np.vstack((posHx,posHy)))) # register these new particles in pos
    # and do the same for the whole width of the domain
    for i in range(W)[1:]:
        posWx = np.random.rand(rho_max)
        posWy = np.random.rand(rho_max)
        posWx += np.ones(rho_max)*i
        pos = np.hstack((pos, np.vstack((posWx,posWy))))
    return pos

# Delete particles in boundaries
def del_particles_boundaries(coords):
    # Cancel left outsider
    indexx = np.argwhere(coords[0]<1) # find particles which x position is lower than 1
    coordsx = np.delete(coords[0],indexx) # and delete this entry in the particles matrix
    coordsy = np.delete(coords[1],indexx)
    # Cancel bottom outsider
    indexy = np.argwhere(coordsy<1)
    coordsx = np.delete(coordsx,indexy)
    coordsy = np.delete(coordsy,indexy)
    # Cancel right outsider
    indexx = np.argwhere(coordsx>W-1) # find particles which x position is higher than W-1
    coordsx = np.delete(coordsx,indexx)
    coordsy = np.delete(coordsy,indexx)
    # Cancel top outsider
    indexy = np.argwhere(coordsy>H-1)
    coordsx = np.delete(coordsx,indexy)
    coordsy = np.delete(coordsy,indexy)
    return np.vstack((coordsx,coordsy)) # return the new matrix

# Particle random walk
def move_particles(pos):
    delta_v = [[-1,0],[1,0],[0,1],[0,-1]]
    for i in range(pos.shape[1]) :
        r = random.randint(4)
        pos[0][i] = pos[0][i]+delta_v[r][0]
        pos[1][i] = pos[1][i]+delta_v[r][1]

    return pos

def plot_contour(pos,W,H):
    # Evaluate a gaussian kde on a regular grid of nbins x nbins over data extents
    nbins = 250
    k = kde.gaussian_kde(pos)
    x,y = pos
    xi, yi = np.mgrid[1:W-1:nbins*1j, 1:H-1:nbins*1j]
    zi = k(np.vstack([xi.flatten(), yi.flatten()]))
    plt.imshow(zi.reshape(xi.shape), origin='lower')

def plot_center(pos,W,H):
    # Evaluate a gaussian kde on a regular grid of nbins x nbins over data extents
    nbins = 10
    k = kde.gaussian_kde(pos)
    x,y = pos
    xi, yi = np.mgrid[2:W-1:nbins*1j, 2:H-1:nbins*1j]
    zi = k(np.vstack([xi.flatten(), yi.flatten()]))
    plt.figure()
    # draws the temperature in the width of the domain
    plt.plot(np.linspace(0,250,num=nbins),zi.reshape(xi.shape).T[:, nbins//2])   
    plt.savefig('pos_RandomWalk/temperature'+'.png')
    plt.close()

if __name__ == "__main__":
    # Simulation Parameters    
    rho_max = 5
    H = 25 + 1
    W = 25 + 1
    unit_area = 1
    particles_number_per_unit_area = rho_max * unit_area

    pos = np.zeros((2,1))   # matrix that will contain the positions of the particles
    # e.g. : pos[0][i] : x and pos[1][i] : y of particle i
    iter_max = 50000 +1 # TODO choose an appropriate value
    freq_output = 500 # TODO choose an appropriate value

    # creates the folder that will contain the output files of the simulation
    os.system('mkdir -p ./pos_RandomWalk')		

    for it in range (iter_max):
        pos = inject_particles_boundary(H,W,pos,rho_max)    
        pos = move_particles(pos)
        
        pos = del_particles_boundaries(pos)
        if it % freq_output == 0:
            plot_contour(pos,W,H)
            plt.title("Iteration : "+str(it))
            plt.savefig('pos_RandomWalk/pos_'+str(it).zfill(4)+'.png')
            #plt.show()
            plt.close()
    
    # TODO plot the particles distribution at mid-height, at equilibrium
    # (you can also plot it in time to observe the convergence)
    # use the plot_center function
