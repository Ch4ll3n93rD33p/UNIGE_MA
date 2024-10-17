//
//  Kripke.swift
//  TP5
//
//  Created by Damien Morard on 13.11.18.
//

public struct Kripke {
  // We create a Kripke structure to apply our model checking methods
  // nodes is a dictionnary (ex: ["s0": [x, y], "s1": [y, z], "s0": [x, y, z]])
  // transitions is set of list (ex: [["s0", "s1"], ["s0", "s2"]])
  
  public typealias Nodes = [String: Set<AP>]
  public typealias Transitions = Set<[String]>
  
  let nodes: Nodes
  let transitions: Transitions
  
  public init?(nodes: [String: Set<AP>], transitions: Set<[String]>){
    // Verify two things: Each transition has two node which exists
    // A transition contains only two nodes
    
    self.nodes = nodes
    for couple in transitions {
      guard (couple.count == 2) else {
        return nil
      }
      for t in couple {
        guard (nodes[t] != nil) else {
          return nil
        }
      }
    }
    self.transitions = transitions
  }
  
}
