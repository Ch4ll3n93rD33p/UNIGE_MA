/// Enum of the different strategies:
/// Generators: identity / fail / axiom / sequence / choice / all
/// Bonus: try / repeat / bottomup / topdown / innermost
public indirect enum Strategy {
  // Generators
  case identity
  case fail
  case axiom
  case sequence(Strategy, Strategy)
  case choice(Strategy, Strategy)
  case all(Strategy)
  // Bonus
  case `try`(Strategy)
  case `repeat`(Strategy)
  // case bottomup(Strategy)
  // case topdown(Strategy)
  case innermost(Strategy)
  case outermost(Strategy)

  // (s1)[t] = fail => (sequence(s1,s2))[t] = fail (where t is self)
  // (s1)[t] = t' => (sequence(s1,s2))[t] = (s2)[t']
  static func sequence(t: Term, s1: Strategy, s2: Strategy) -> Term? {
    // TODO: Complete the function
    var  r : Term?;
    if eval(t: t, s: s1)==nil { // case (s1)[t] = fail
      r = nil // (Sequence(s1,s2))[t] = fail
    }
    if let t2 = eval(t: t, s: s1) { // case (s1)[t] = t2
      r = eval(t: t2, s: s2) // (Sequence(s1,s2))[t] = (s2)[t2]
    }
    return r
  }

  // (s1)[t] = t' => (choice(s1,s2))[t] = t' (where t is self)
  // (s1)[t] = fail => (choice(s1,s2))[t] = (s2)[t]
  static func choice(t: Term, s1: Strategy, s2: Strategy) -> Term? {
    // TODO: Complete the function
    var  r : Term?;
    if let t2 = eval(t: t, s: s1) { // case (s1)[t] = t2
      r = t2 // (Choice(s1,s2))[t] = t2
    }
    if eval(t: t, s: s1)==nil { // case (s1)[t] = fail
      r = eval(t: t, s: s2) // (Choice(s1,s2))[t] = (s2)[t]
    }
    return r
  }

  // (s)[t1] = t1', ..., s[tn] = tn' => (All(s))[f(t1,...,tn)] = f(t1',...,tn')
  // If there exists i, such that (s)[ti] = fail => (All(s))[f(t1,...,tn)] = fail
  // (All(s))[cst] = cst
  // Apply to the direct subterms the strategy s.
  static public func all(t: Term, s: Strategy) -> Term? {
    return t.all(s: s)
  }

  /// Evaluate a term using a given strategy
  /// - Parameters:
  ///   - t: The term to evaluate
  ///   - s: The strategy to use
  /// Returns: The result of the evaluate term with the given strategy. If it fails, it returns nil.
  static public func eval(t: Term, s: Strategy) -> Term? {
    switch s {
    case .identity: // (Identity)[t] = t
      // TODO: Replace nil
      return t
    case .fail:
      return nil
    case .axiom:
      return t.rewriting()
    case .sequence(let s1, let s2):
      return sequence(t: t, s1: s1, s2: s2)
    case .choice(let s1, let s2):
      return choice(t: t, s1: s1, s2: s2)
    case .try(let s1): // Try(s) = Choice(s, Identity)
      // TODO: Replace nil
      return choice(t: t, s1: s1, s2: .identity)
    case .all(let s1):
      return all(t: t, s: s1)
    case .innermost(let s1): // Innermost(s) = Sequence(All(Innermost(s))), Try(Sequence(s,Innermost(s))))
      // TODO: Replace nil
      return sequence(t: t, s1: .all(.innermost(s1)), s2: .try(.sequence(s1, .innermost(s1))))
    case .outermost(let s1): // Outermost(s) = Sequence(Try(Sequence(s,Outermost(s))), All(Innermost(s))))
      // TODO: Replace nil
      return sequence(t: t, s1: .try(.sequence(s1, .outermost(s1))), s2: .all(.innermost(s1)))
    default:
      return nil
    }
  }


}
