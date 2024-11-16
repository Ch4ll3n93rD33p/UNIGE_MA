#!/usr/bin/python
# -*- coding: latin-1 -*-

from heapq import *

### STATE ##########################################

class State:
    def __init__(self):
        #TODO
    def is_green(self):
        """
        Vrai si le feu est vert
        """
        #TODO
    def add_car(self):
        """
        Ajoute une voiture à la file
        """
        #TODO
    def purge_cars(self):
        """
        Vide les voitures en attente
        """
        #TODO
    def waiting_cars(self):
        """
        Retourne le nombre de voiture qui attendent
        """
        #TODO
    def turn_green(self):
        """
        Le feu passe au vert
        """
        #TODO
    def turn_red(self):
        """
        Le feu passe au rouge
        """
        #TODO
    def __str__(self):
        """
        Affiche l'état du carefour
        """
        #TODO

### EVENTS ###########################################

Tc = 60 #Temps de changement de feu
Tp = 5  #Temps de passage

class Event:
    def time(self):
        """
        Retourne le temps auquel l'événement doit être traité
        """
        return self.t
    def __str__(self):
        """
        Affiche l'événement
        """
        return self.name + "(" + str( self.t ) + ")"
    def __lt__(self, other):
    	"""
        Compare l'événement avec un autre par ordre de traitement
        """
      return self.t < other.t
    
class CAR(Event):
    def __init__(self,time):
        #TODO
    def action(self,queue,state):
        #TODO

class R2G(Event):
    def __init__(self,time):
        #TODO
    def action(self,queue,state):
        #TODO

class G2R(Event):
    def __init__(self,time):
        #TODO
    def action(self,queue,state):
        #TODO

### EVENT QUEUE ##############################################

class EventQueue:
  def __init__(self):
      self.q = []
  def notEmpty(self):
      """
      Retourne vrai si la queue n'est pas vide
      """
      return len(self.q) > 0
  def remaining(self):
      """
      Retourne le nombre d'événements en attente de traitement
      """
      return len(self.q)
  def insert(self, event):
      """ 
      Insère un nouvel événement dans la queue
      """
      heappush( self.q, event )
  def next(self):
      """
      Retourne et enlève de la queue le prochain événement à traiter
      """
      return heappop( self.q )

### MAIN #####################################################

Q = EventQueue()

Q.insert( CAR(80) )
Q.insert( CAR(60) )
Q.insert( CAR(100) )
Q.insert( CAR(20) )

S = State()

while Q.notEmpty():
    e = Q.next()
    print( e )
    e.action(Q,S)

