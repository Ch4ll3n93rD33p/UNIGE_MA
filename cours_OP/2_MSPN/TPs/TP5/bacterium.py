import random
from math import pi, cos, sin

def new_direction(direction) :
    alpha = 2*pi*random.random()
    if alpha != direction :
        return alpha
    else : return new_direction(direction)


class Bacterium :
    def __init__(self, pos, direction = 2*pi*random.random(), v = 20/0.2, prevRho = None, P1 = 0.9, P2 = 0.5) -> None :
        self.pos = pos
        self.direction = direction
        self.v = v
        self.prevRho = prevRho
        self.P1 = P1
        self.P2 = P2
    
    def movements(self, p, Dt = 0.2) -> None :
        r = random.random()
        if pxt > self.prevRho : ############
            if r > self.P1 :
                self.direction = new_direction(self.direction)
        else :
            if r > self.P2 :
                pass # modif self.dir

    def update_pos(self, v) -> None :
        x = v*cos(self.direction)
        y = v*sin(self.direction)
        self.pos[0] = (self.pos[0]+x)%100 # mod 100 to hav periodicity
        self.pos[1] = (self.pos[1]+y)%100

        
        