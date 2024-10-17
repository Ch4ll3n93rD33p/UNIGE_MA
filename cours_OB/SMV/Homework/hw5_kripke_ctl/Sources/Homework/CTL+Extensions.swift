//
//  CTL+CustomString.swift
//  TP5
//
//  Created by Damien Morard on 13.11.18.
//


extension CTL {
  // All functions to reduce CTL Formula in basic cases
  public static func reduce(_ ctl_formula: CTL) -> CTL {
    
    // Generators
    switch ctl_formula {
    case .ap(let ap):
      return .ap(ap)
    case .true:
      return .true
    case .not(let x):
      let red = reduce(x)
      switch red {
      case .not(let x):
        return reduce(x)
      case let x:
        return .not(reduce(x))
      }
    case .or(.true, _):
      // TODO
      return .true
    case .or(_, .true):
      // TODO
      return .true
    case .or(let x, let y):
      // TODO
      let red = reduce(x)
      switch red {
      case let x:
        return reduce(x)
      case .not(let x):
        return reduce(y)
      }
    case .ex(let x): ///////////////
      // TODO
      return .ex(x)
    case .eg(let x): ///////////////
      // TODO
      return .eg(x)
    case .eu(let x, let y): ///////////////
      // TODO
      return .eu(x,y)
      
    // Can be derived with generators
    case .false:
      // TODO
      return .not(.true)
    case .and(let x, .true):
      // TODO
      return reduce(x)
    case .and(.true, let x):
      // TODO
      return reduce(x)
    case .and(let x, let y):
      // TODO
      return .not(.or(reduce(.not(x)), reduce(.not(y))))
    case .implies(let x, let y): ///////////////
      // TODO
      break
    case .ax(let x):
      // TODO
      return .not(.ex(reduce(.not(x))))
    case .af(let x):
      // TODO
      return .not(.eg(reduce(.not(x))))
    case .ef(let x):
      // TODO
      return .eu(.true, x)
    case .ag(let x):
      // TODO
      return .not(.ef(reduce(.not(x))))
    case .au(let x, let y):
      // TODO
      return reduce(.and(reduce(.af(y)), reduce(.aw(x, y))))
    case .aw(let x, let y):
      // TODO
      return .not(.eu(reduce(.not(y)), .not(.or(x, y))))
    case .ew(let x, let y):
      // TODO
      return .eg(.or(x, .eu(x, y)))
    }
    
    // At the end you don't need this return (you can remove it)
    return .true
  }
  
  
}


extension AP: CustomStringConvertible {
  // Computed properties to have a nice print
  public var description: String {
    switch self {
    case .x: return "x"
    case .y: return "y"
    case .z: return "z"
    }
  }
}


extension CTL: CustomStringConvertible {
  // Computed properties to have a nice print
  public var description: String {
    switch self {
    case .ap(let x): return "\(x)"
    case .true: return "true"
    case .false: return "false"
    case .not(let x): return "not(\(x))"
    case .and (let x, let y): return "And(\(x), \(y))"
    case .or(let x, let y): return "Or(\(x), \(y))"
    case .implies(let x, let y): return "Implies(\(x), \(y))"
    case .ax(let x): return "AX(\(x))"
    case .ex(let x): return "EX(\(x))"
    case .af(let x): return "AF(\(x))"
    case .ef(let x): return "EF(\(x))"
    case .ag(let x): return "AG(\(x))"
    case .eg(let x): return "EG(\(x))"
    case .au(let x, let y): return "AU(\(x), \(y))"
    case .eu(let x, let y): return "EU(\(x), \(y))"
    case .aw(let x, let y): return "AW(\(x), \(y))"
    case .ew(let x, let y): return "EW(\(x), \(y))"
      
    }
  }
}
