import numpy as np
import pylab as plt
from matplotlib import animation
from copy import deepcopy


# take the 4 matrices of all directions
# and outputs the 4 matrices updated after collisions
def collision(north, east, south, west, walls):
    north_mask = (north != 0)
    east_mask = (east != 0)
    south_mask = (south != 0)
    west_mask = (west != 0)
    walls_mask = (walls != 0)

    out_north = deepcopy(north)
    out_east = deepcopy(east)
    out_south = deepcopy(south)
    out_west = deepcopy(west)

    # walls bounce back
    out_north[south_mask & walls_mask] = 1
    out_south[south_mask & walls_mask] = 0

    out_east[west_mask & walls_mask] = 1
    out_west[west_mask & walls_mask] = 0

    out_south[north_mask & walls_mask] = 1
    out_north[north_mask & walls_mask] = 0

    out_west[east_mask & walls_mask] = 1
    out_east[east_mask & walls_mask] = 0

    # N-S collision
    out_north[north_mask & south_mask & ~east_mask & ~west_mask & ~walls_mask] = 0
    out_east[north_mask & south_mask & ~east_mask & ~west_mask & ~walls_mask] = 1
    out_south[north_mask & south_mask & ~east_mask & ~west_mask & ~walls_mask] = 0
    out_west[north_mask & south_mask & ~east_mask & ~west_mask & ~walls_mask] = 1

    # E-W collision
    out_north[east_mask & west_mask & ~north_mask & ~south_mask & ~walls_mask] = 1
    out_east[east_mask & west_mask & ~north_mask & ~south_mask & ~walls_mask] = 0
    out_south[east_mask & west_mask & ~north_mask & ~south_mask & ~walls_mask] = 1
    out_west[east_mask & west_mask & ~north_mask & ~south_mask & ~walls_mask] = 0
    

    return out_north, out_east, out_south, out_west
    
# propagations of particles in the 4 directions
def propagate(north, east, south, west):
    north = np.roll(north, -1, axis=0)
    east = np.roll(east, 1, axis=1)
    south = np.roll(south, 1, axis=0)
    west = np.roll(west, -1, axis=1)
    return north, east, south, west

# function that set edges of a matrix
# to a number num
def countouring(mat, num):
    (m,n) = np.shape(mat)
    mat[0: , 0] = num
    mat[0 , 0:] = num
    mat[m-1, 0:] = num
    mat[0: , n-1] = num
    return mat

# put a wall with a hole at position pos
def setWall(mat, pos):
    (m,n) = np.shape(mat)
    mat[0: , pos-1:pos+1] = 1
    mat[int(m/2)-10:int(m/2)+10, pos-1:pos+1] = 0
    return mat

# init of ciruclar domain particules with center a,b and radius r

n = 151
a, b = 75,110
r = 43

y,x = np.ogrid[-a:n-a, -b:n-b]
mask = x*x + y*y <= r*r

north = np.zeros((n, n))
east = np.zeros((n, n))
south = np.zeros((n, n))
west = np.zeros((n, n))
walls = np.zeros((n, n))

north[mask] = np.random.choice([0, 1], size=5744, p=[6./10, 4./10])
east[mask] =  np.random.choice([0, 1], size=5744, p=[6./10, 4./10])
south[mask] =  np.random.choice([0, 1], size=5744, p=[6./10, 4./10])
west[mask] =  np.random.choice([0, 1],  size=5744, p=[6./10, 4./10])



north = countouring(north,0)
east = countouring(east,0)
south = countouring(south,0)
west = countouring(west,0)

# setting walls
walls = countouring(walls,1)
walls = setWall(walls,50)

print('Computing simulation...')

fig = plt.figure()
im = plt.imshow(north+south+east+west+walls, animated=True, interpolation="none")

def init():
    im.set_array(north+south+east+west+walls)
    return im,

def animate(i):
    global north,east,south,west
    north,east,south,west = collision(north,east,south,west,walls)
    north,east,south,west = propagate(north,east,south,west)
    im.set_array(north+south+east+west+walls)
    return im,

anim = animation.FuncAnimation(fig, animate, init_func=init, frames=int(400), interval=100, blit=True, repeat=False)
#plt.show()
anim.save('wall.gif', writer = 'imagemagick')

print('\nSuccessfully saved in a gif file')

north,south,east,west= south.copy(),north.copy(),west.copy(),east.copy()

anim = animation.FuncAnimation(fig, animate, init_func=init, frames=int(400), interval=100, blit=True, repeat=False)
#plt.show()
anim.save('wall_reverse.gif', writer = 'imagemagick')

print('\nSuccessfully saved in a gif file')

#main()
    
