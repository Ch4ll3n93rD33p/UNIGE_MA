import SwiftKanren


//// namespace containing all the operations to prove an axiom
public struct Proof {

  public static func reflexivity(_ term: Term)->Rule{

    return Rule(term,term)
  }

  public static func symmetry(_ rule: Rule) -> Rule{

    return Rule(rule.h_rTerm(), rule.h_lTerm())/rule.variables()
  }

  public static func transitivity(_ lhs: Rule, _ rhs: Rule) -> Rule{
    if equivalence(lhs.rTerm(),rhs.lTerm()){
      let condition : Term
      if equivalence(lhs.condition(), rhs.condition()){
        condition = lhs.condition()
      }else{
        condition = Boolean.and(lhs.condition(), rhs.condition())
      }
      return Rule(lhs.lTerm(),rhs.rTerm(),condition)
    }
    // Don't change the return below
    return Rule(vNil,vNil)
  }

  public static func substitutivity(_ operation: @escaping (Term...)->Term, _ rules: [Rule])->Rule{
    // Look at tests for examples
    // operation_c will be necessary to cast a list of term to one term
    typealias Function = ([Term]) -> Term
    let operation_c = unsafeBitCast(operation, to: Function.self)

    // We build iteratively two tables: one containing the lTerms of rules  and the other containing the rTerms of rules
    var lTermRules: [Term] = []
    var rTermRules: [Term] = []
    for rule in rules { //
      lTermRules.append(rule.h_lTerm())
      rTermRules.append(rule.h_rTerm())
    }

    // then we apply operation_c on both tables
    let lhs: Term = operation_c(lTermRules)
    let rhs: Term = operation_c(rTermRules)
    
    return Rule(lhs, rhs)/rules[0].variables()
  }

  public static func substitution(_ rule: Rule, _ variable: Variable, _ replacement: Term)-> Rule{
    let v = variable

    let lhs = subst_variable(rule.h_lTerm(), v, replacement)
    let rhs = subst_variable(rule.h_rTerm(), v, replacement)
    let condition = subst_variable(rule.h_condition(), v, replacement)

    return Rule(lhs, rhs, condition)
  }

}
