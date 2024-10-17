import XCTest
import SwiftKanren
import TP3

class ProofsTests: XCTestCase {

  internal func tassert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) == \(ADTm.pprint(b))"
//    print(msg)
    XCTAssertTrue(ADTm.eval(a).equals(ADTm.eval(b)), msg)
  }

  internal func TAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) == (\(b))"
//    print(msg)
    XCTAssertTrue(a.equals(b),msg)
  }

  internal func FAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) != (\(b))"
//    print(msg)
    XCTAssertFalse(a.equals(b),msg)
  }
  
  func testProofReflexivity() {
    // reflexivity
    print("can apply reflexivity")
    let t = Proof.reflexivity(Boolean.not(Variable(named: "x")))
    self.TAssert(t, Rule(Boolean.not(Variable(named: "y")),Boolean.not(Variable(named: "y"))))
  }
  
  func testProofSymmetry() {
    // symmetry
    print("can apply symmetry")
    let t = Proof.symmetry(Rule(Boolean.True(), Boolean.not(Boolean.False())))
    self.TAssert(t, Rule(Boolean.not(Boolean.False()), Boolean.True()))
  }
  
  func testProofTransitivity() {
    // transitivity
    let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
    let t1 = Rule(Boolean.not(Boolean.not(Variable(named:"w"))), Variable(named:"w"))
    var t = Proof.transitivity(t0,t1)
    print("can apply transitivity")
    self.TAssert(t, Rule(Variable(named:"x"), Variable(named:"x")))

    // transitivity(Rule(x+y,2*y,x==y), Rule(2*x,2+2,x==2)) -> Rule(x+y,2+2,and(x==y, x==2))
    let t2 = Rule(
      Nat.add(Variable(named: "x"), Variable(named: "y")),
      Nat.mul(Nat.n(2), Variable(named: "x")),
      Nat.eq(Variable(named: "x"), Variable(named: "y"))
    )
    let t3 = Rule(
      Nat.mul(Nat.n(2), Variable(named: "x")),
      Nat.add(Nat.n(2), Nat.n(2)),
      Nat.eq(Variable(named: "x"), Nat.n(2))
    )
    t = Proof.transitivity(t2, t3)
    let resExpected = Rule(
      Nat.add(Variable(named: "x"), Variable(named: "y")),
      Nat.add(Nat.n(2), Nat.n(2)),
      Boolean.and(Nat.eq(Variable(named: "x"), Variable(named: "y")), Nat.eq(Variable(named: "x"), Nat.n(2)))
    )
    self.TAssert(t, resExpected)
  }
  
  func testProofSubstitution() {
    print("Can apply substitution")
    var t = Proof.substitution(ADTm["nat"].a("+")[0], Variable(named:"x"), Nat.zero())
    self.TAssert(t, Rule(Nat.add(Nat.zero(), Nat.zero()), Nat.zero()))

    print("Can apply substitution")
    t = Proof.substitution(ADTm["nat"].a("+")[0], Variable(named:"x"), Nat.succ(Variable(named: "y")))
    self.TAssert(t, Rule(Nat.add(Nat.succ(Variable(named: "y")), Nat.zero()), Nat.succ(Variable(named: "y"))))
    
    print("Can apply substitution")
    t = Proof.substitution(ADTm["nat"].a("+")[1], Variable(named:"x"), Nat.succ(Variable(named: "y")))
    let t1 = Proof.substitution(t, Variable(named:"y"), Nat.zero())
    self.TAssert(t1, Rule(Nat.add(Nat.succ(Nat.zero()), Nat.succ(Nat.zero())), Nat.succ(Nat.add(Nat.succ(Nat.zero()), Nat.zero()))))
    
    
    print("Can apply substitution")
    let t2 = Rule(Nat.add(Variable(named: "x"), Nat.succ(Variable(named: "y"))), Nat.add(Variable(named: "y"), Variable(named: "x")))
    let t3 = Rule(Nat.add(Variable(named: "y"), Nat.succ(Variable(named: "x"))), Nat.add(Variable(named: "x"), Variable(named: "y")))
    
    self.TAssert(t2, t3)
  }
  
  func testProofSubstitutivity() {
    print("Can apply substitutivity")
    let t = Proof.substitutivity(Nat.succ, [ADTm["nat"].a("+")[0]])
    self.TAssert(t, Rule(
      Nat.succ(Nat.add(Variable(named:"x"), Nat.zero())),
      Nat.succ(Variable(named:"x"))
    ))
    
    print("Can apply substitutivity")
    // 0 = 0
    let t1 = Proof.reflexivity(Nat.zero())
    // (x + 0) + 0 = x + 0
    let t2 = Proof.substitutivity(Nat.add, [ADTm["nat"].a("+")[0], t1])
    let expectedRes = Rule(
      Nat.add(Nat.add(Variable(named: "x"), Nat.zero()), Nat.zero()),
      Nat.add(Variable(named: "x"), Nat.zero())
    )
    self.TAssert(t2, expectedRes)
  }

  func testEquationalProof(){
    let a_proof = Rule(Nat.add(Variable(named: "x"), Nat.zero()), Variable(named:"x"))
    let b_proof = Rule(Nat.add(Variable(named: "z"), Nat.zero()), Variable(named:"z"))
    let c_proof = Rule(Nat.add(Variable(named: "z"), Nat.succ(Variable(named:"y"))), Nat.succ(Nat.add(Variable(named:"z"), Variable(named: "y"))))
    self.TAssert(a_proof, b_proof)
    self.FAssert(a_proof, c_proof)
    
  }
  
//  func testProofCut()  {
//     print("Can apply cut")
//     t0 = Rule(
//       Boolean.True(),
//       Boolean.True(),
//       Boolean.eq(Variable(named:"x"), Boolean.not(Boolean.not(Variable(named:"x"))))
//     )
//     t1 = Rule(
//       Variable(named:"x"),
//       Boolean.not(Boolean.not(Variable(named:"x")))
//     )
//     // let term = Nat.succ(x:Variable(named:"X"))
//     // let emap = eq_map(Nat.succ(x:Variable(named:"z")), term, [:])
//
//  }
  
  static var allTests = [
    ("testProofReflexivity", testProofReflexivity),
    ("testProofSymmetry", testProofSymmetry),
    ("testProofTransitivity", testProofTransitivity),
    ("testProofSubstitution", testProofSubstitution),
    ("testProofSubstitutivity", testProofSubstitutivity),
    ("testEquationalProof", testEquationalProof),
  ]

}

