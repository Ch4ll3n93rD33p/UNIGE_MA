//
//  CTL.swift
//  TP5
//
//  Created by Damien Morard on 06.11.18.
//

public enum AP {
  case x, y, z
}

public indirect enum CTL: Equatable {
  // Generators
  case ap(_ value: AP)
  case `true`
  case not(CTL)
  case or(CTL, CTL)
  case ex(CTL)
  case eg(CTL)
  case eu(CTL, CTL)

  // Can be derived by the generators
  case `false`
  case and(CTL, CTL)
  case implies(CTL, CTL)
  case ax(CTL)
  case af(CTL)
  case ef(CTL)
  case ag(CTL)
  case au(CTL, CTL)
  case aw(CTL, CTL)
  case ew(CTL, CTL)
}
