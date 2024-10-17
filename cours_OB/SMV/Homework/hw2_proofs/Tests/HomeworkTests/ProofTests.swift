import XCTest
import SwiftKanren
import Homework

extension ProofTests {
    static var allTests : [(String, (ProofTests) -> () throws -> Void)] {
        return [
            ("testEquationalProof", testEquationalProof),
            ("testZeroSumIdentity", testZeroSumIdentity)
        ]
    }
}

class ProofTests: XCTestCase {


  internal func tassert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) == \(ADTm.pprint(b))"
    print(msg)
    XCTAssertTrue(ADTm.eval(a).equals(ADTm.eval(b)), msg)
  }

  internal func TAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) == (\(b))"
    print(msg)
    XCTAssertTrue(a.equals(b),msg)
  }

  internal func FAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) != (\(b))"
    print(msg)
    XCTAssertFalse(a.equals(b),msg)
  }

  override func setUp() {
    super.setUp()
   }

  func testZeroSumIdentity(){
    // Proof of: x + 0 = x
    let nat = ADTm["nat"]
    // -- x + 0 = x
    let t1 = nat.a("+")[0]
    print("t1 - nat.+.ax[0]\n\t\(t1)")
    // -- x + s(y) = s(x + y)
    let t2 = nat.a("+")[1]
    print("t2 - nat.+.ax[1]\n\t\(t2)")
    // -- x + s(0) = s(x + 0)
    let t3 = Proof.substitution(t2, Variable(named:"y"), Nat.zero())
    print("t3 - substitution[ax1,y,0]\n\t\(t3)")
    // -- s(x + 0) = s(x)
    let t4 = Proof.substitutivity(Nat.succ, [t1])
    print("t4 - substitutivity[succ, ax[0]]\n\t\(t4)")
    // -- x + s(0) = s(x)
    let t5 = Proof.transitivity (t3, t4)
    print("t5 - transitivity[t3,t4]\n\t\(t5)")
    self.TAssert(t5, Rule(
      Nat.add(Variable(named: "a"), Nat.succ(x: Nat.zero())),
      Nat.succ(x: Variable(named:"a"))
    ))
  }

  func testEquationalProof(){
    let a_proof = Rule(Nat.add(Variable(named: "x"), Nat.zero()), Variable(named:"x"))
    let b_proof = Rule(Nat.add(Variable(named: "z"), Nat.zero()), Variable(named:"z"))
    let c_proof = Rule(Nat.add(Variable(named: "z"), Nat.succ(x: Variable(named:"y"))), Nat.succ(x: Nat.add(Variable(named:"z"), Variable(named: "y"))))
    self.TAssert(a_proof, b_proof)
    self.FAssert(a_proof, c_proof)
    // reflexivity
    print("can apply reflexivity")
    // reflexivity(Term(not(x))) -> Rule(not(x) = not(x))
    var t = Proof.reflexivity(Boolean.not(Variable(named: "x")))
    self.TAssert(t, Rule(Boolean.not(Variable(named: "y")),Boolean.not(Variable(named: "y"))))
    
    print("can apply symmetry")
    // symmetry(Rule(True, not(False)) -> Rule(not(False), True)
    t = Proof.symmetry(Rule(Boolean.True(), Boolean.not(Boolean.False())))
    self.TAssert(t, Rule(Boolean.not(Boolean.False()), Boolean.True()))
   
    print("can apply transitivity")
    // transitivity(Rule(x, not(not(x)), Rule(not(not(w)), w)) -> Rule(x,x)
    let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
    let t1 = Rule(Boolean.not(Boolean.not(Variable(named:"w"))), Variable(named:"w"))
    t = Proof.transitivity(t0,t1)
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

    print("Can apply substitution")
    // substitution(Rule(x+0=0), x, 0) -> Rule(0+0=0)
    t = Proof.substitution(ADTm["nat"].a("+")[0], Variable(named:"x"), Nat.zero())
    self.TAssert(t, Rule(Nat.add(Nat.zero(), Nat.zero()), Nat.zero()))

    print("Can apply substitution")
    // substitution(Rule(x+0=0), x, suc(y)) -> Rule(suc(y)+0=suc(y))
    t = Proof.substitution(ADTm["nat"].a("+")[0], Variable(named:"x"), Nat.succ(x:Variable(named: "y")))
    self.TAssert(t, Rule(Nat.add(Nat.succ(x: Variable(named: "y")), Nat.zero()), Nat.succ(x: Variable(named: "y"))))

    print("Can apply substitutivity")
    // substitutivity(succ, Rule(x+0=x)) -> Rule(succ(x+0) = succ(x))
    t = Proof.substitutivity(Nat.succ, [ADTm["nat"].a("+")[0]])
    self.TAssert(t, Rule(
      Nat.succ(x: Nat.add(Variable(named:"x"), Nat.zero())),
      Nat.succ(x: Variable(named:"x"))
    ))
  }
  
}
